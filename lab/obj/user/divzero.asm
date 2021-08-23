
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 20 23 80 00       	push   $0x802320
  800056:	e8 fa 00 00 00       	call   800155 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 3d 0b 00 00       	call   800bad <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007d:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x2d>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	56                   	push   %esi
  800091:	53                   	push   %ebx
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ac:	e8 20 0f 00 00       	call   800fd1 <close_all>
	sys_env_destroy(0);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 b1 0a 00 00       	call   800b6c <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 04             	sub    $0x4,%esp
  8000c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ca:	8b 13                	mov    (%ebx),%edx
  8000cc:	8d 42 01             	lea    0x1(%edx),%eax
  8000cf:	89 03                	mov    %eax,(%ebx)
  8000d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000dd:	74 09                	je     8000e8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e6:	c9                   	leave  
  8000e7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e8:	83 ec 08             	sub    $0x8,%esp
  8000eb:	68 ff 00 00 00       	push   $0xff
  8000f0:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f3:	50                   	push   %eax
  8000f4:	e8 36 0a 00 00       	call   800b2f <sys_cputs>
		b->idx = 0;
  8000f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	eb db                	jmp    8000df <putch+0x1f>

00800104 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800114:	00 00 00 
	b.cnt = 0;
  800117:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012d:	50                   	push   %eax
  80012e:	68 c0 00 80 00       	push   $0x8000c0
  800133:	e8 1a 01 00 00       	call   800252 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800138:	83 c4 08             	add    $0x8,%esp
  80013b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800141:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800147:	50                   	push   %eax
  800148:	e8 e2 09 00 00       	call   800b2f <sys_cputs>

	return b.cnt;
}
  80014d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800153:	c9                   	leave  
  800154:	c3                   	ret    

00800155 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015e:	50                   	push   %eax
  80015f:	ff 75 08             	pushl  0x8(%ebp)
  800162:	e8 9d ff ff ff       	call   800104 <vcprintf>
	va_end(ap);

	return cnt;
}
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
  80016f:	83 ec 1c             	sub    $0x1c,%esp
  800172:	89 c7                	mov    %eax,%edi
  800174:	89 d6                	mov    %edx,%esi
  800176:	8b 45 08             	mov    0x8(%ebp),%eax
  800179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800182:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800190:	39 d3                	cmp    %edx,%ebx
  800192:	72 05                	jb     800199 <printnum+0x30>
  800194:	39 45 10             	cmp    %eax,0x10(%ebp)
  800197:	77 7a                	ja     800213 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	ff 75 18             	pushl  0x18(%ebp)
  80019f:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a5:	53                   	push   %ebx
  8001a6:	ff 75 10             	pushl  0x10(%ebp)
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001af:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b8:	e8 23 1f 00 00       	call   8020e0 <__udivdi3>
  8001bd:	83 c4 18             	add    $0x18,%esp
  8001c0:	52                   	push   %edx
  8001c1:	50                   	push   %eax
  8001c2:	89 f2                	mov    %esi,%edx
  8001c4:	89 f8                	mov    %edi,%eax
  8001c6:	e8 9e ff ff ff       	call   800169 <printnum>
  8001cb:	83 c4 20             	add    $0x20,%esp
  8001ce:	eb 13                	jmp    8001e3 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	56                   	push   %esi
  8001d4:	ff 75 18             	pushl  0x18(%ebp)
  8001d7:	ff d7                	call   *%edi
  8001d9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001dc:	83 eb 01             	sub    $0x1,%ebx
  8001df:	85 db                	test   %ebx,%ebx
  8001e1:	7f ed                	jg     8001d0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	56                   	push   %esi
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f6:	e8 05 20 00 00       	call   802200 <__umoddi3>
  8001fb:	83 c4 14             	add    $0x14,%esp
  8001fe:	0f be 80 38 23 80 00 	movsbl 0x802338(%eax),%eax
  800205:	50                   	push   %eax
  800206:	ff d7                	call   *%edi
}
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5f                   	pop    %edi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    
  800213:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800216:	eb c4                	jmp    8001dc <printnum+0x73>

00800218 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800222:	8b 10                	mov    (%eax),%edx
  800224:	3b 50 04             	cmp    0x4(%eax),%edx
  800227:	73 0a                	jae    800233 <sprintputch+0x1b>
		*b->buf++ = ch;
  800229:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022c:	89 08                	mov    %ecx,(%eax)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	88 02                	mov    %al,(%edx)
}
  800233:	5d                   	pop    %ebp
  800234:	c3                   	ret    

00800235 <printfmt>:
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023e:	50                   	push   %eax
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 05 00 00 00       	call   800252 <vprintfmt>
}
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <vprintfmt>:
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 2c             	sub    $0x2c,%esp
  80025b:	8b 75 08             	mov    0x8(%ebp),%esi
  80025e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800261:	8b 7d 10             	mov    0x10(%ebp),%edi
  800264:	e9 21 04 00 00       	jmp    80068a <vprintfmt+0x438>
		padc = ' ';
  800269:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80026d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800274:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80027b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800287:	8d 47 01             	lea    0x1(%edi),%eax
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028d:	0f b6 17             	movzbl (%edi),%edx
  800290:	8d 42 dd             	lea    -0x23(%edx),%eax
  800293:	3c 55                	cmp    $0x55,%al
  800295:	0f 87 90 04 00 00    	ja     80072b <vprintfmt+0x4d9>
  80029b:	0f b6 c0             	movzbl %al,%eax
  80029e:	ff 24 85 80 24 80 00 	jmp    *0x802480(,%eax,4)
  8002a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ac:	eb d9                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b5:	eb d0                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b7:	0f b6 d2             	movzbl %dl,%edx
  8002ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002cc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002cf:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d2:	83 f9 09             	cmp    $0x9,%ecx
  8002d5:	77 55                	ja     80032c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002d7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002da:	eb e9                	jmp    8002c5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002df:	8b 00                	mov    (%eax),%eax
  8002e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e7:	8d 40 04             	lea    0x4(%eax),%eax
  8002ea:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f4:	79 91                	jns    800287 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800303:	eb 82                	jmp    800287 <vprintfmt+0x35>
  800305:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
  80030f:	0f 49 d0             	cmovns %eax,%edx
  800312:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800318:	e9 6a ff ff ff       	jmp    800287 <vprintfmt+0x35>
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800320:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800327:	e9 5b ff ff ff       	jmp    800287 <vprintfmt+0x35>
  80032c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800332:	eb bc                	jmp    8002f0 <vprintfmt+0x9e>
			lflag++;
  800334:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80033a:	e9 48 ff ff ff       	jmp    800287 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033f:	8b 45 14             	mov    0x14(%ebp),%eax
  800342:	8d 78 04             	lea    0x4(%eax),%edi
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	53                   	push   %ebx
  800349:	ff 30                	pushl  (%eax)
  80034b:	ff d6                	call   *%esi
			break;
  80034d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800350:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800353:	e9 2f 03 00 00       	jmp    800687 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8d 78 04             	lea    0x4(%eax),%edi
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	99                   	cltd   
  800361:	31 d0                	xor    %edx,%eax
  800363:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800365:	83 f8 0f             	cmp    $0xf,%eax
  800368:	7f 23                	jg     80038d <vprintfmt+0x13b>
  80036a:	8b 14 85 e0 25 80 00 	mov    0x8025e0(,%eax,4),%edx
  800371:	85 d2                	test   %edx,%edx
  800373:	74 18                	je     80038d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800375:	52                   	push   %edx
  800376:	68 3b 27 80 00       	push   $0x80273b
  80037b:	53                   	push   %ebx
  80037c:	56                   	push   %esi
  80037d:	e8 b3 fe ff ff       	call   800235 <printfmt>
  800382:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800385:	89 7d 14             	mov    %edi,0x14(%ebp)
  800388:	e9 fa 02 00 00       	jmp    800687 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80038d:	50                   	push   %eax
  80038e:	68 50 23 80 00       	push   $0x802350
  800393:	53                   	push   %ebx
  800394:	56                   	push   %esi
  800395:	e8 9b fe ff ff       	call   800235 <printfmt>
  80039a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a0:	e9 e2 02 00 00       	jmp    800687 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	83 c0 04             	add    $0x4,%eax
  8003ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003b3:	85 ff                	test   %edi,%edi
  8003b5:	b8 49 23 80 00       	mov    $0x802349,%eax
  8003ba:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c1:	0f 8e bd 00 00 00    	jle    800484 <vprintfmt+0x232>
  8003c7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003cb:	75 0e                	jne    8003db <vprintfmt+0x189>
  8003cd:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003d3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003d6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003d9:	eb 6d                	jmp    800448 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e1:	57                   	push   %edi
  8003e2:	e8 ec 03 00 00       	call   8007d3 <strnlen>
  8003e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003ea:	29 c1                	sub    %eax,%ecx
  8003ec:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003ef:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003fc:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fe:	eb 0f                	jmp    80040f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800400:	83 ec 08             	sub    $0x8,%esp
  800403:	53                   	push   %ebx
  800404:	ff 75 e0             	pushl  -0x20(%ebp)
  800407:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800409:	83 ef 01             	sub    $0x1,%edi
  80040c:	83 c4 10             	add    $0x10,%esp
  80040f:	85 ff                	test   %edi,%edi
  800411:	7f ed                	jg     800400 <vprintfmt+0x1ae>
  800413:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800416:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800419:	85 c9                	test   %ecx,%ecx
  80041b:	b8 00 00 00 00       	mov    $0x0,%eax
  800420:	0f 49 c1             	cmovns %ecx,%eax
  800423:	29 c1                	sub    %eax,%ecx
  800425:	89 75 08             	mov    %esi,0x8(%ebp)
  800428:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80042b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042e:	89 cb                	mov    %ecx,%ebx
  800430:	eb 16                	jmp    800448 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800432:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800436:	75 31                	jne    800469 <vprintfmt+0x217>
					putch(ch, putdat);
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	50                   	push   %eax
  80043f:	ff 55 08             	call   *0x8(%ebp)
  800442:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800445:	83 eb 01             	sub    $0x1,%ebx
  800448:	83 c7 01             	add    $0x1,%edi
  80044b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80044f:	0f be c2             	movsbl %dl,%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	74 59                	je     8004af <vprintfmt+0x25d>
  800456:	85 f6                	test   %esi,%esi
  800458:	78 d8                	js     800432 <vprintfmt+0x1e0>
  80045a:	83 ee 01             	sub    $0x1,%esi
  80045d:	79 d3                	jns    800432 <vprintfmt+0x1e0>
  80045f:	89 df                	mov    %ebx,%edi
  800461:	8b 75 08             	mov    0x8(%ebp),%esi
  800464:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800467:	eb 37                	jmp    8004a0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800469:	0f be d2             	movsbl %dl,%edx
  80046c:	83 ea 20             	sub    $0x20,%edx
  80046f:	83 fa 5e             	cmp    $0x5e,%edx
  800472:	76 c4                	jbe    800438 <vprintfmt+0x1e6>
					putch('?', putdat);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	ff 75 0c             	pushl  0xc(%ebp)
  80047a:	6a 3f                	push   $0x3f
  80047c:	ff 55 08             	call   *0x8(%ebp)
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb c1                	jmp    800445 <vprintfmt+0x1f3>
  800484:	89 75 08             	mov    %esi,0x8(%ebp)
  800487:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800490:	eb b6                	jmp    800448 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	53                   	push   %ebx
  800496:	6a 20                	push   $0x20
  800498:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80049a:	83 ef 01             	sub    $0x1,%edi
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	85 ff                	test   %edi,%edi
  8004a2:	7f ee                	jg     800492 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004aa:	e9 d8 01 00 00       	jmp    800687 <vprintfmt+0x435>
  8004af:	89 df                	mov    %ebx,%edi
  8004b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b7:	eb e7                	jmp    8004a0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004b9:	83 f9 01             	cmp    $0x1,%ecx
  8004bc:	7e 45                	jle    800503 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8b 50 04             	mov    0x4(%eax),%edx
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	8d 40 08             	lea    0x8(%eax),%eax
  8004d2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d9:	79 62                	jns    80053d <vprintfmt+0x2eb>
				putch('-', putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	6a 2d                	push   $0x2d
  8004e1:	ff d6                	call   *%esi
				num = -(long long) num;
  8004e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004e9:	f7 d8                	neg    %eax
  8004eb:	83 d2 00             	adc    $0x0,%edx
  8004ee:	f7 da                	neg    %edx
  8004f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004f6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8004fe:	e9 66 01 00 00       	jmp    800669 <vprintfmt+0x417>
	else if (lflag)
  800503:	85 c9                	test   %ecx,%ecx
  800505:	75 1b                	jne    800522 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050f:	89 c1                	mov    %eax,%ecx
  800511:	c1 f9 1f             	sar    $0x1f,%ecx
  800514:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8d 40 04             	lea    0x4(%eax),%eax
  80051d:	89 45 14             	mov    %eax,0x14(%ebp)
  800520:	eb b3                	jmp    8004d5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052a:	89 c1                	mov    %eax,%ecx
  80052c:	c1 f9 1f             	sar    $0x1f,%ecx
  80052f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	8d 40 04             	lea    0x4(%eax),%eax
  800538:	89 45 14             	mov    %eax,0x14(%ebp)
  80053b:	eb 98                	jmp    8004d5 <vprintfmt+0x283>
			base = 10;
  80053d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800542:	e9 22 01 00 00       	jmp    800669 <vprintfmt+0x417>
	if (lflag >= 2)
  800547:	83 f9 01             	cmp    $0x1,%ecx
  80054a:	7e 21                	jle    80056d <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8b 50 04             	mov    0x4(%eax),%edx
  800552:	8b 00                	mov    (%eax),%eax
  800554:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800557:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 40 08             	lea    0x8(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800563:	ba 0a 00 00 00       	mov    $0xa,%edx
  800568:	e9 fc 00 00 00       	jmp    800669 <vprintfmt+0x417>
	else if (lflag)
  80056d:	85 c9                	test   %ecx,%ecx
  80056f:	75 23                	jne    800594 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	ba 00 00 00 00       	mov    $0x0,%edx
  80057b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 40 04             	lea    0x4(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80058f:	e9 d5 00 00 00       	jmp    800669 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	ba 00 00 00 00       	mov    $0x0,%edx
  80059e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 40 04             	lea    0x4(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ad:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005b2:	e9 b2 00 00 00       	jmp    800669 <vprintfmt+0x417>
	if (lflag >= 2)
  8005b7:	83 f9 01             	cmp    $0x1,%ecx
  8005ba:	7e 42                	jle    8005fe <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8b 50 04             	mov    0x4(%eax),%edx
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 08             	lea    0x8(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d3:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8005d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005dc:	0f 89 87 00 00 00    	jns    800669 <vprintfmt+0x417>
				putch('-', putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	6a 2d                	push   $0x2d
  8005e8:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ea:	f7 5d d8             	negl   -0x28(%ebp)
  8005ed:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8005f1:	f7 5d dc             	negl   -0x24(%ebp)
  8005f4:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8005f7:	ba 08 00 00 00       	mov    $0x8,%edx
  8005fc:	eb 6b                	jmp    800669 <vprintfmt+0x417>
	else if (lflag)
  8005fe:	85 c9                	test   %ecx,%ecx
  800600:	75 1b                	jne    80061d <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	ba 00 00 00 00       	mov    $0x0,%edx
  80060c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8d 40 04             	lea    0x4(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
  80061b:	eb b6                	jmp    8005d3 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	ba 00 00 00 00       	mov    $0x0,%edx
  800627:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 40 04             	lea    0x4(%eax),%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
  800636:	eb 9b                	jmp    8005d3 <vprintfmt+0x381>
			putch('0', putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 30                	push   $0x30
  80063e:	ff d6                	call   *%esi
			putch('x', putdat);
  800640:	83 c4 08             	add    $0x8,%esp
  800643:	53                   	push   %ebx
  800644:	6a 78                	push   $0x78
  800646:	ff d6                	call   *%esi
			num = (unsigned long long)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800655:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800658:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800664:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800669:	83 ec 0c             	sub    $0xc,%esp
  80066c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800670:	50                   	push   %eax
  800671:	ff 75 e0             	pushl  -0x20(%ebp)
  800674:	52                   	push   %edx
  800675:	ff 75 dc             	pushl  -0x24(%ebp)
  800678:	ff 75 d8             	pushl  -0x28(%ebp)
  80067b:	89 da                	mov    %ebx,%edx
  80067d:	89 f0                	mov    %esi,%eax
  80067f:	e8 e5 fa ff ff       	call   800169 <printnum>
			break;
  800684:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80068a:	83 c7 01             	add    $0x1,%edi
  80068d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800691:	83 f8 25             	cmp    $0x25,%eax
  800694:	0f 84 cf fb ff ff    	je     800269 <vprintfmt+0x17>
			if (ch == '\0')
  80069a:	85 c0                	test   %eax,%eax
  80069c:	0f 84 a9 00 00 00    	je     80074b <vprintfmt+0x4f9>
			putch(ch, putdat);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	53                   	push   %ebx
  8006a6:	50                   	push   %eax
  8006a7:	ff d6                	call   *%esi
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	eb dc                	jmp    80068a <vprintfmt+0x438>
	if (lflag >= 2)
  8006ae:	83 f9 01             	cmp    $0x1,%ecx
  8006b1:	7e 1e                	jle    8006d1 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 50 04             	mov    0x4(%eax),%edx
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 08             	lea    0x8(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ca:	ba 10 00 00 00       	mov    $0x10,%edx
  8006cf:	eb 98                	jmp    800669 <vprintfmt+0x417>
	else if (lflag)
  8006d1:	85 c9                	test   %ecx,%ecx
  8006d3:	75 23                	jne    8006f8 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
  8006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 40 04             	lea    0x4(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ee:	ba 10 00 00 00       	mov    $0x10,%edx
  8006f3:	e9 71 ff ff ff       	jmp    800669 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800702:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800705:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800711:	ba 10 00 00 00       	mov    $0x10,%edx
  800716:	e9 4e ff ff ff       	jmp    800669 <vprintfmt+0x417>
			putch(ch, putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	6a 25                	push   $0x25
  800721:	ff d6                	call   *%esi
			break;
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	e9 5c ff ff ff       	jmp    800687 <vprintfmt+0x435>
			putch('%', putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 25                	push   $0x25
  800731:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	89 f8                	mov    %edi,%eax
  800738:	eb 03                	jmp    80073d <vprintfmt+0x4eb>
  80073a:	83 e8 01             	sub    $0x1,%eax
  80073d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800741:	75 f7                	jne    80073a <vprintfmt+0x4e8>
  800743:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800746:	e9 3c ff ff ff       	jmp    800687 <vprintfmt+0x435>
}
  80074b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074e:	5b                   	pop    %ebx
  80074f:	5e                   	pop    %esi
  800750:	5f                   	pop    %edi
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 18             	sub    $0x18,%esp
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800762:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800766:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800769:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800770:	85 c0                	test   %eax,%eax
  800772:	74 26                	je     80079a <vsnprintf+0x47>
  800774:	85 d2                	test   %edx,%edx
  800776:	7e 22                	jle    80079a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800778:	ff 75 14             	pushl  0x14(%ebp)
  80077b:	ff 75 10             	pushl  0x10(%ebp)
  80077e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	68 18 02 80 00       	push   $0x800218
  800787:	e8 c6 fa ff ff       	call   800252 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800795:	83 c4 10             	add    $0x10,%esp
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    
		return -E_INVAL;
  80079a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079f:	eb f7                	jmp    800798 <vsnprintf+0x45>

008007a1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 10             	pushl  0x10(%ebp)
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 9a ff ff ff       	call   800753 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c6:	eb 03                	jmp    8007cb <strlen+0x10>
		n++;
  8007c8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007cf:	75 f7                	jne    8007c8 <strlen+0xd>
	return n;
}
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	eb 03                	jmp    8007e6 <strnlen+0x13>
		n++;
  8007e3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e6:	39 d0                	cmp    %edx,%eax
  8007e8:	74 06                	je     8007f0 <strnlen+0x1d>
  8007ea:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007ee:	75 f3                	jne    8007e3 <strnlen+0x10>
	return n;
}
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	53                   	push   %ebx
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007fc:	89 c2                	mov    %eax,%edx
  8007fe:	83 c1 01             	add    $0x1,%ecx
  800801:	83 c2 01             	add    $0x1,%edx
  800804:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800808:	88 5a ff             	mov    %bl,-0x1(%edx)
  80080b:	84 db                	test   %bl,%bl
  80080d:	75 ef                	jne    8007fe <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80080f:	5b                   	pop    %ebx
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800819:	53                   	push   %ebx
  80081a:	e8 9c ff ff ff       	call   8007bb <strlen>
  80081f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	01 d8                	add    %ebx,%eax
  800827:	50                   	push   %eax
  800828:	e8 c5 ff ff ff       	call   8007f2 <strcpy>
	return dst;
}
  80082d:	89 d8                	mov    %ebx,%eax
  80082f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	56                   	push   %esi
  800838:	53                   	push   %ebx
  800839:	8b 75 08             	mov    0x8(%ebp),%esi
  80083c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083f:	89 f3                	mov    %esi,%ebx
  800841:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800844:	89 f2                	mov    %esi,%edx
  800846:	eb 0f                	jmp    800857 <strncpy+0x23>
		*dst++ = *src;
  800848:	83 c2 01             	add    $0x1,%edx
  80084b:	0f b6 01             	movzbl (%ecx),%eax
  80084e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800851:	80 39 01             	cmpb   $0x1,(%ecx)
  800854:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800857:	39 da                	cmp    %ebx,%edx
  800859:	75 ed                	jne    800848 <strncpy+0x14>
	}
	return ret;
}
  80085b:	89 f0                	mov    %esi,%eax
  80085d:	5b                   	pop    %ebx
  80085e:	5e                   	pop    %esi
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	56                   	push   %esi
  800865:	53                   	push   %ebx
  800866:	8b 75 08             	mov    0x8(%ebp),%esi
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086f:	89 f0                	mov    %esi,%eax
  800871:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800875:	85 c9                	test   %ecx,%ecx
  800877:	75 0b                	jne    800884 <strlcpy+0x23>
  800879:	eb 17                	jmp    800892 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80087b:	83 c2 01             	add    $0x1,%edx
  80087e:	83 c0 01             	add    $0x1,%eax
  800881:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800884:	39 d8                	cmp    %ebx,%eax
  800886:	74 07                	je     80088f <strlcpy+0x2e>
  800888:	0f b6 0a             	movzbl (%edx),%ecx
  80088b:	84 c9                	test   %cl,%cl
  80088d:	75 ec                	jne    80087b <strlcpy+0x1a>
		*dst = '\0';
  80088f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800892:	29 f0                	sub    %esi,%eax
}
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a1:	eb 06                	jmp    8008a9 <strcmp+0x11>
		p++, q++;
  8008a3:	83 c1 01             	add    $0x1,%ecx
  8008a6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008a9:	0f b6 01             	movzbl (%ecx),%eax
  8008ac:	84 c0                	test   %al,%al
  8008ae:	74 04                	je     8008b4 <strcmp+0x1c>
  8008b0:	3a 02                	cmp    (%edx),%al
  8008b2:	74 ef                	je     8008a3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b4:	0f b6 c0             	movzbl %al,%eax
  8008b7:	0f b6 12             	movzbl (%edx),%edx
  8008ba:	29 d0                	sub    %edx,%eax
}
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	53                   	push   %ebx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c8:	89 c3                	mov    %eax,%ebx
  8008ca:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008cd:	eb 06                	jmp    8008d5 <strncmp+0x17>
		n--, p++, q++;
  8008cf:	83 c0 01             	add    $0x1,%eax
  8008d2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d5:	39 d8                	cmp    %ebx,%eax
  8008d7:	74 16                	je     8008ef <strncmp+0x31>
  8008d9:	0f b6 08             	movzbl (%eax),%ecx
  8008dc:	84 c9                	test   %cl,%cl
  8008de:	74 04                	je     8008e4 <strncmp+0x26>
  8008e0:	3a 0a                	cmp    (%edx),%cl
  8008e2:	74 eb                	je     8008cf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e4:	0f b6 00             	movzbl (%eax),%eax
  8008e7:	0f b6 12             	movzbl (%edx),%edx
  8008ea:	29 d0                	sub    %edx,%eax
}
  8008ec:	5b                   	pop    %ebx
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    
		return 0;
  8008ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f4:	eb f6                	jmp    8008ec <strncmp+0x2e>

008008f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800900:	0f b6 10             	movzbl (%eax),%edx
  800903:	84 d2                	test   %dl,%dl
  800905:	74 09                	je     800910 <strchr+0x1a>
		if (*s == c)
  800907:	38 ca                	cmp    %cl,%dl
  800909:	74 0a                	je     800915 <strchr+0x1f>
	for (; *s; s++)
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	eb f0                	jmp    800900 <strchr+0xa>
			return (char *) s;
	return 0;
  800910:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800921:	eb 03                	jmp    800926 <strfind+0xf>
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800929:	38 ca                	cmp    %cl,%dl
  80092b:	74 04                	je     800931 <strfind+0x1a>
  80092d:	84 d2                	test   %dl,%dl
  80092f:	75 f2                	jne    800923 <strfind+0xc>
			break;
	return (char *) s;
}
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	57                   	push   %edi
  800937:	56                   	push   %esi
  800938:	53                   	push   %ebx
  800939:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80093f:	85 c9                	test   %ecx,%ecx
  800941:	74 13                	je     800956 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800943:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800949:	75 05                	jne    800950 <memset+0x1d>
  80094b:	f6 c1 03             	test   $0x3,%cl
  80094e:	74 0d                	je     80095d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800950:	8b 45 0c             	mov    0xc(%ebp),%eax
  800953:	fc                   	cld    
  800954:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800956:	89 f8                	mov    %edi,%eax
  800958:	5b                   	pop    %ebx
  800959:	5e                   	pop    %esi
  80095a:	5f                   	pop    %edi
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    
		c &= 0xFF;
  80095d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800961:	89 d3                	mov    %edx,%ebx
  800963:	c1 e3 08             	shl    $0x8,%ebx
  800966:	89 d0                	mov    %edx,%eax
  800968:	c1 e0 18             	shl    $0x18,%eax
  80096b:	89 d6                	mov    %edx,%esi
  80096d:	c1 e6 10             	shl    $0x10,%esi
  800970:	09 f0                	or     %esi,%eax
  800972:	09 c2                	or     %eax,%edx
  800974:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800976:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800979:	89 d0                	mov    %edx,%eax
  80097b:	fc                   	cld    
  80097c:	f3 ab                	rep stos %eax,%es:(%edi)
  80097e:	eb d6                	jmp    800956 <memset+0x23>

00800980 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	57                   	push   %edi
  800984:	56                   	push   %esi
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 75 0c             	mov    0xc(%ebp),%esi
  80098b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80098e:	39 c6                	cmp    %eax,%esi
  800990:	73 35                	jae    8009c7 <memmove+0x47>
  800992:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800995:	39 c2                	cmp    %eax,%edx
  800997:	76 2e                	jbe    8009c7 <memmove+0x47>
		s += n;
		d += n;
  800999:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099c:	89 d6                	mov    %edx,%esi
  80099e:	09 fe                	or     %edi,%esi
  8009a0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a6:	74 0c                	je     8009b4 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a8:	83 ef 01             	sub    $0x1,%edi
  8009ab:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ae:	fd                   	std    
  8009af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b1:	fc                   	cld    
  8009b2:	eb 21                	jmp    8009d5 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b4:	f6 c1 03             	test   $0x3,%cl
  8009b7:	75 ef                	jne    8009a8 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b9:	83 ef 04             	sub    $0x4,%edi
  8009bc:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c2:	fd                   	std    
  8009c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c5:	eb ea                	jmp    8009b1 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c7:	89 f2                	mov    %esi,%edx
  8009c9:	09 c2                	or     %eax,%edx
  8009cb:	f6 c2 03             	test   $0x3,%dl
  8009ce:	74 09                	je     8009d9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d0:	89 c7                	mov    %eax,%edi
  8009d2:	fc                   	cld    
  8009d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d5:	5e                   	pop    %esi
  8009d6:	5f                   	pop    %edi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d9:	f6 c1 03             	test   $0x3,%cl
  8009dc:	75 f2                	jne    8009d0 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009de:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009e1:	89 c7                	mov    %eax,%edi
  8009e3:	fc                   	cld    
  8009e4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e6:	eb ed                	jmp    8009d5 <memmove+0x55>

008009e8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009eb:	ff 75 10             	pushl  0x10(%ebp)
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	ff 75 08             	pushl  0x8(%ebp)
  8009f4:	e8 87 ff ff ff       	call   800980 <memmove>
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	56                   	push   %esi
  8009ff:	53                   	push   %ebx
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a06:	89 c6                	mov    %eax,%esi
  800a08:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a0b:	39 f0                	cmp    %esi,%eax
  800a0d:	74 1c                	je     800a2b <memcmp+0x30>
		if (*s1 != *s2)
  800a0f:	0f b6 08             	movzbl (%eax),%ecx
  800a12:	0f b6 1a             	movzbl (%edx),%ebx
  800a15:	38 d9                	cmp    %bl,%cl
  800a17:	75 08                	jne    800a21 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a19:	83 c0 01             	add    $0x1,%eax
  800a1c:	83 c2 01             	add    $0x1,%edx
  800a1f:	eb ea                	jmp    800a0b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a21:	0f b6 c1             	movzbl %cl,%eax
  800a24:	0f b6 db             	movzbl %bl,%ebx
  800a27:	29 d8                	sub    %ebx,%eax
  800a29:	eb 05                	jmp    800a30 <memcmp+0x35>
	}

	return 0;
  800a2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a30:	5b                   	pop    %ebx
  800a31:	5e                   	pop    %esi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a42:	39 d0                	cmp    %edx,%eax
  800a44:	73 09                	jae    800a4f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a46:	38 08                	cmp    %cl,(%eax)
  800a48:	74 05                	je     800a4f <memfind+0x1b>
	for (; s < ends; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	eb f3                	jmp    800a42 <memfind+0xe>
			break;
	return (void *) s;
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	57                   	push   %edi
  800a55:	56                   	push   %esi
  800a56:	53                   	push   %ebx
  800a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5d:	eb 03                	jmp    800a62 <strtol+0x11>
		s++;
  800a5f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a62:	0f b6 01             	movzbl (%ecx),%eax
  800a65:	3c 20                	cmp    $0x20,%al
  800a67:	74 f6                	je     800a5f <strtol+0xe>
  800a69:	3c 09                	cmp    $0x9,%al
  800a6b:	74 f2                	je     800a5f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a6d:	3c 2b                	cmp    $0x2b,%al
  800a6f:	74 2e                	je     800a9f <strtol+0x4e>
	int neg = 0;
  800a71:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a76:	3c 2d                	cmp    $0x2d,%al
  800a78:	74 2f                	je     800aa9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a7a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a80:	75 05                	jne    800a87 <strtol+0x36>
  800a82:	80 39 30             	cmpb   $0x30,(%ecx)
  800a85:	74 2c                	je     800ab3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a87:	85 db                	test   %ebx,%ebx
  800a89:	75 0a                	jne    800a95 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a8b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a90:	80 39 30             	cmpb   $0x30,(%ecx)
  800a93:	74 28                	je     800abd <strtol+0x6c>
		base = 10;
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9d:	eb 50                	jmp    800aef <strtol+0x9e>
		s++;
  800a9f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa2:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa7:	eb d1                	jmp    800a7a <strtol+0x29>
		s++, neg = 1;
  800aa9:	83 c1 01             	add    $0x1,%ecx
  800aac:	bf 01 00 00 00       	mov    $0x1,%edi
  800ab1:	eb c7                	jmp    800a7a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab7:	74 0e                	je     800ac7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	75 d8                	jne    800a95 <strtol+0x44>
		s++, base = 8;
  800abd:	83 c1 01             	add    $0x1,%ecx
  800ac0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac5:	eb ce                	jmp    800a95 <strtol+0x44>
		s += 2, base = 16;
  800ac7:	83 c1 02             	add    $0x2,%ecx
  800aca:	bb 10 00 00 00       	mov    $0x10,%ebx
  800acf:	eb c4                	jmp    800a95 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ad1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad4:	89 f3                	mov    %esi,%ebx
  800ad6:	80 fb 19             	cmp    $0x19,%bl
  800ad9:	77 29                	ja     800b04 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800adb:	0f be d2             	movsbl %dl,%edx
  800ade:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae4:	7d 30                	jge    800b16 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae6:	83 c1 01             	add    $0x1,%ecx
  800ae9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aed:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aef:	0f b6 11             	movzbl (%ecx),%edx
  800af2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af5:	89 f3                	mov    %esi,%ebx
  800af7:	80 fb 09             	cmp    $0x9,%bl
  800afa:	77 d5                	ja     800ad1 <strtol+0x80>
			dig = *s - '0';
  800afc:	0f be d2             	movsbl %dl,%edx
  800aff:	83 ea 30             	sub    $0x30,%edx
  800b02:	eb dd                	jmp    800ae1 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b04:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b07:	89 f3                	mov    %esi,%ebx
  800b09:	80 fb 19             	cmp    $0x19,%bl
  800b0c:	77 08                	ja     800b16 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b0e:	0f be d2             	movsbl %dl,%edx
  800b11:	83 ea 37             	sub    $0x37,%edx
  800b14:	eb cb                	jmp    800ae1 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1a:	74 05                	je     800b21 <strtol+0xd0>
		*endptr = (char *) s;
  800b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b21:	89 c2                	mov    %eax,%edx
  800b23:	f7 da                	neg    %edx
  800b25:	85 ff                	test   %edi,%edi
  800b27:	0f 45 c2             	cmovne %edx,%eax
}
  800b2a:	5b                   	pop    %ebx
  800b2b:	5e                   	pop    %esi
  800b2c:	5f                   	pop    %edi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b35:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b40:	89 c3                	mov    %eax,%ebx
  800b42:	89 c7                	mov    %eax,%edi
  800b44:	89 c6                	mov    %eax,%esi
  800b46:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5f                   	pop    %edi
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	57                   	push   %edi
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5d:	89 d1                	mov    %edx,%ecx
  800b5f:	89 d3                	mov    %edx,%ebx
  800b61:	89 d7                	mov    %edx,%edi
  800b63:	89 d6                	mov    %edx,%esi
  800b65:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5f                   	pop    %edi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	57                   	push   %edi
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b82:	89 cb                	mov    %ecx,%ebx
  800b84:	89 cf                	mov    %ecx,%edi
  800b86:	89 ce                	mov    %ecx,%esi
  800b88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8a:	85 c0                	test   %eax,%eax
  800b8c:	7f 08                	jg     800b96 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b91:	5b                   	pop    %ebx
  800b92:	5e                   	pop    %esi
  800b93:	5f                   	pop    %edi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b96:	83 ec 0c             	sub    $0xc,%esp
  800b99:	50                   	push   %eax
  800b9a:	6a 03                	push   $0x3
  800b9c:	68 3f 26 80 00       	push   $0x80263f
  800ba1:	6a 23                	push   $0x23
  800ba3:	68 5c 26 80 00       	push   $0x80265c
  800ba8:	e8 ad 13 00 00       	call   801f5a <_panic>

00800bad <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbd:	89 d1                	mov    %edx,%ecx
  800bbf:	89 d3                	mov    %edx,%ebx
  800bc1:	89 d7                	mov    %edx,%edi
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_yield>:

void
sys_yield(void)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bdc:	89 d1                	mov    %edx,%ecx
  800bde:	89 d3                	mov    %edx,%ebx
  800be0:	89 d7                	mov    %edx,%edi
  800be2:	89 d6                	mov    %edx,%esi
  800be4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf4:	be 00 00 00 00       	mov    $0x0,%esi
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bff:	b8 04 00 00 00       	mov    $0x4,%eax
  800c04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c07:	89 f7                	mov    %esi,%edi
  800c09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0b:	85 c0                	test   %eax,%eax
  800c0d:	7f 08                	jg     800c17 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c17:	83 ec 0c             	sub    $0xc,%esp
  800c1a:	50                   	push   %eax
  800c1b:	6a 04                	push   $0x4
  800c1d:	68 3f 26 80 00       	push   $0x80263f
  800c22:	6a 23                	push   $0x23
  800c24:	68 5c 26 80 00       	push   $0x80265c
  800c29:	e8 2c 13 00 00       	call   801f5a <_panic>

00800c2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c37:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c48:	8b 75 18             	mov    0x18(%ebp),%esi
  800c4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4d:	85 c0                	test   %eax,%eax
  800c4f:	7f 08                	jg     800c59 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5f                   	pop    %edi
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c59:	83 ec 0c             	sub    $0xc,%esp
  800c5c:	50                   	push   %eax
  800c5d:	6a 05                	push   $0x5
  800c5f:	68 3f 26 80 00       	push   $0x80263f
  800c64:	6a 23                	push   $0x23
  800c66:	68 5c 26 80 00       	push   $0x80265c
  800c6b:	e8 ea 12 00 00       	call   801f5a <_panic>

00800c70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
  800c76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	b8 06 00 00 00       	mov    $0x6,%eax
  800c89:	89 df                	mov    %ebx,%edi
  800c8b:	89 de                	mov    %ebx,%esi
  800c8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	7f 08                	jg     800c9b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	50                   	push   %eax
  800c9f:	6a 06                	push   $0x6
  800ca1:	68 3f 26 80 00       	push   $0x80263f
  800ca6:	6a 23                	push   $0x23
  800ca8:	68 5c 26 80 00       	push   $0x80265c
  800cad:	e8 a8 12 00 00       	call   801f5a <_panic>

00800cb2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	57                   	push   %edi
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
  800cb8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc6:	b8 08 00 00 00       	mov    $0x8,%eax
  800ccb:	89 df                	mov    %ebx,%edi
  800ccd:	89 de                	mov    %ebx,%esi
  800ccf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	7f 08                	jg     800cdd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdd:	83 ec 0c             	sub    $0xc,%esp
  800ce0:	50                   	push   %eax
  800ce1:	6a 08                	push   $0x8
  800ce3:	68 3f 26 80 00       	push   $0x80263f
  800ce8:	6a 23                	push   $0x23
  800cea:	68 5c 26 80 00       	push   $0x80265c
  800cef:	e8 66 12 00 00       	call   801f5a <_panic>

00800cf4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d02:	8b 55 08             	mov    0x8(%ebp),%edx
  800d05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d08:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0d:	89 df                	mov    %ebx,%edi
  800d0f:	89 de                	mov    %ebx,%esi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	50                   	push   %eax
  800d23:	6a 09                	push   $0x9
  800d25:	68 3f 26 80 00       	push   $0x80263f
  800d2a:	6a 23                	push   $0x23
  800d2c:	68 5c 26 80 00       	push   $0x80265c
  800d31:	e8 24 12 00 00       	call   801f5a <_panic>

00800d36 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d4f:	89 df                	mov    %ebx,%edi
  800d51:	89 de                	mov    %ebx,%esi
  800d53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7f 08                	jg     800d61 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5f                   	pop    %edi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d61:	83 ec 0c             	sub    $0xc,%esp
  800d64:	50                   	push   %eax
  800d65:	6a 0a                	push   $0xa
  800d67:	68 3f 26 80 00       	push   $0x80263f
  800d6c:	6a 23                	push   $0x23
  800d6e:	68 5c 26 80 00       	push   $0x80265c
  800d73:	e8 e2 11 00 00       	call   801f5a <_panic>

00800d78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d89:	be 00 00 00 00       	mov    $0x0,%esi
  800d8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d91:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d94:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
  800da1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	b8 0d 00 00 00       	mov    $0xd,%eax
  800db1:	89 cb                	mov    %ecx,%ebx
  800db3:	89 cf                	mov    %ecx,%edi
  800db5:	89 ce                	mov    %ecx,%esi
  800db7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7f 08                	jg     800dc5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	50                   	push   %eax
  800dc9:	6a 0d                	push   $0xd
  800dcb:	68 3f 26 80 00       	push   $0x80263f
  800dd0:	6a 23                	push   $0x23
  800dd2:	68 5c 26 80 00       	push   $0x80265c
  800dd7:	e8 7e 11 00 00       	call   801f5a <_panic>

00800ddc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de2:	ba 00 00 00 00       	mov    $0x0,%edx
  800de7:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dec:	89 d1                	mov    %edx,%ecx
  800dee:	89 d3                	mov    %edx,%ebx
  800df0:	89 d7                	mov    %edx,%edi
  800df2:	89 d6                	mov    %edx,%esi
  800df4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	05 00 00 00 30       	add    $0x30000000,%eax
  800e06:	c1 e8 0c             	shr    $0xc,%eax
}
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e1b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e28:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e2d:	89 c2                	mov    %eax,%edx
  800e2f:	c1 ea 16             	shr    $0x16,%edx
  800e32:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e39:	f6 c2 01             	test   $0x1,%dl
  800e3c:	74 2a                	je     800e68 <fd_alloc+0x46>
  800e3e:	89 c2                	mov    %eax,%edx
  800e40:	c1 ea 0c             	shr    $0xc,%edx
  800e43:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e4a:	f6 c2 01             	test   $0x1,%dl
  800e4d:	74 19                	je     800e68 <fd_alloc+0x46>
  800e4f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e54:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e59:	75 d2                	jne    800e2d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e5b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e61:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e66:	eb 07                	jmp    800e6f <fd_alloc+0x4d>
			*fd_store = fd;
  800e68:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e77:	83 f8 1f             	cmp    $0x1f,%eax
  800e7a:	77 36                	ja     800eb2 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e7c:	c1 e0 0c             	shl    $0xc,%eax
  800e7f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e84:	89 c2                	mov    %eax,%edx
  800e86:	c1 ea 16             	shr    $0x16,%edx
  800e89:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e90:	f6 c2 01             	test   $0x1,%dl
  800e93:	74 24                	je     800eb9 <fd_lookup+0x48>
  800e95:	89 c2                	mov    %eax,%edx
  800e97:	c1 ea 0c             	shr    $0xc,%edx
  800e9a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ea1:	f6 c2 01             	test   $0x1,%dl
  800ea4:	74 1a                	je     800ec0 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea9:	89 02                	mov    %eax,(%edx)
	return 0;
  800eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		return -E_INVAL;
  800eb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb7:	eb f7                	jmp    800eb0 <fd_lookup+0x3f>
		return -E_INVAL;
  800eb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebe:	eb f0                	jmp    800eb0 <fd_lookup+0x3f>
  800ec0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec5:	eb e9                	jmp    800eb0 <fd_lookup+0x3f>

00800ec7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 08             	sub    $0x8,%esp
  800ecd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed0:	ba e8 26 80 00       	mov    $0x8026e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ed5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eda:	39 08                	cmp    %ecx,(%eax)
  800edc:	74 33                	je     800f11 <dev_lookup+0x4a>
  800ede:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ee1:	8b 02                	mov    (%edx),%eax
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 f3                	jne    800eda <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ee7:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800eec:	8b 40 48             	mov    0x48(%eax),%eax
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	51                   	push   %ecx
  800ef3:	50                   	push   %eax
  800ef4:	68 6c 26 80 00       	push   $0x80266c
  800ef9:	e8 57 f2 ff ff       	call   800155 <cprintf>
	*dev = 0;
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    
			*dev = devtab[i];
  800f11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f14:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f16:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1b:	eb f2                	jmp    800f0f <dev_lookup+0x48>

00800f1d <fd_close>:
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
  800f23:	83 ec 1c             	sub    $0x1c,%esp
  800f26:	8b 75 08             	mov    0x8(%ebp),%esi
  800f29:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f2c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f2f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f30:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f36:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f39:	50                   	push   %eax
  800f3a:	e8 32 ff ff ff       	call   800e71 <fd_lookup>
  800f3f:	89 c3                	mov    %eax,%ebx
  800f41:	83 c4 08             	add    $0x8,%esp
  800f44:	85 c0                	test   %eax,%eax
  800f46:	78 05                	js     800f4d <fd_close+0x30>
	    || fd != fd2)
  800f48:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f4b:	74 16                	je     800f63 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f4d:	89 f8                	mov    %edi,%eax
  800f4f:	84 c0                	test   %al,%al
  800f51:	b8 00 00 00 00       	mov    $0x0,%eax
  800f56:	0f 44 d8             	cmove  %eax,%ebx
}
  800f59:	89 d8                	mov    %ebx,%eax
  800f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f69:	50                   	push   %eax
  800f6a:	ff 36                	pushl  (%esi)
  800f6c:	e8 56 ff ff ff       	call   800ec7 <dev_lookup>
  800f71:	89 c3                	mov    %eax,%ebx
  800f73:	83 c4 10             	add    $0x10,%esp
  800f76:	85 c0                	test   %eax,%eax
  800f78:	78 15                	js     800f8f <fd_close+0x72>
		if (dev->dev_close)
  800f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f7d:	8b 40 10             	mov    0x10(%eax),%eax
  800f80:	85 c0                	test   %eax,%eax
  800f82:	74 1b                	je     800f9f <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f84:	83 ec 0c             	sub    $0xc,%esp
  800f87:	56                   	push   %esi
  800f88:	ff d0                	call   *%eax
  800f8a:	89 c3                	mov    %eax,%ebx
  800f8c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	56                   	push   %esi
  800f93:	6a 00                	push   $0x0
  800f95:	e8 d6 fc ff ff       	call   800c70 <sys_page_unmap>
	return r;
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	eb ba                	jmp    800f59 <fd_close+0x3c>
			r = 0;
  800f9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa4:	eb e9                	jmp    800f8f <fd_close+0x72>

00800fa6 <close>:

int
close(int fdnum)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800faf:	50                   	push   %eax
  800fb0:	ff 75 08             	pushl  0x8(%ebp)
  800fb3:	e8 b9 fe ff ff       	call   800e71 <fd_lookup>
  800fb8:	83 c4 08             	add    $0x8,%esp
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	78 10                	js     800fcf <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	6a 01                	push   $0x1
  800fc4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc7:	e8 51 ff ff ff       	call   800f1d <fd_close>
  800fcc:	83 c4 10             	add    $0x10,%esp
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <close_all>:

void
close_all(void)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fd8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fdd:	83 ec 0c             	sub    $0xc,%esp
  800fe0:	53                   	push   %ebx
  800fe1:	e8 c0 ff ff ff       	call   800fa6 <close>
	for (i = 0; i < MAXFD; i++)
  800fe6:	83 c3 01             	add    $0x1,%ebx
  800fe9:	83 c4 10             	add    $0x10,%esp
  800fec:	83 fb 20             	cmp    $0x20,%ebx
  800fef:	75 ec                	jne    800fdd <close_all+0xc>
}
  800ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801002:	50                   	push   %eax
  801003:	ff 75 08             	pushl  0x8(%ebp)
  801006:	e8 66 fe ff ff       	call   800e71 <fd_lookup>
  80100b:	89 c3                	mov    %eax,%ebx
  80100d:	83 c4 08             	add    $0x8,%esp
  801010:	85 c0                	test   %eax,%eax
  801012:	0f 88 81 00 00 00    	js     801099 <dup+0xa3>
		return r;
	close(newfdnum);
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	e8 83 ff ff ff       	call   800fa6 <close>

	newfd = INDEX2FD(newfdnum);
  801023:	8b 75 0c             	mov    0xc(%ebp),%esi
  801026:	c1 e6 0c             	shl    $0xc,%esi
  801029:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80102f:	83 c4 04             	add    $0x4,%esp
  801032:	ff 75 e4             	pushl  -0x1c(%ebp)
  801035:	e8 d1 fd ff ff       	call   800e0b <fd2data>
  80103a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80103c:	89 34 24             	mov    %esi,(%esp)
  80103f:	e8 c7 fd ff ff       	call   800e0b <fd2data>
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	c1 e8 16             	shr    $0x16,%eax
  80104e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801055:	a8 01                	test   $0x1,%al
  801057:	74 11                	je     80106a <dup+0x74>
  801059:	89 d8                	mov    %ebx,%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
  80105e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801065:	f6 c2 01             	test   $0x1,%dl
  801068:	75 39                	jne    8010a3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80106a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80106d:	89 d0                	mov    %edx,%eax
  80106f:	c1 e8 0c             	shr    $0xc,%eax
  801072:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	25 07 0e 00 00       	and    $0xe07,%eax
  801081:	50                   	push   %eax
  801082:	56                   	push   %esi
  801083:	6a 00                	push   $0x0
  801085:	52                   	push   %edx
  801086:	6a 00                	push   $0x0
  801088:	e8 a1 fb ff ff       	call   800c2e <sys_page_map>
  80108d:	89 c3                	mov    %eax,%ebx
  80108f:	83 c4 20             	add    $0x20,%esp
  801092:	85 c0                	test   %eax,%eax
  801094:	78 31                	js     8010c7 <dup+0xd1>
		goto err;

	return newfdnum;
  801096:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801099:	89 d8                	mov    %ebx,%eax
  80109b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010aa:	83 ec 0c             	sub    $0xc,%esp
  8010ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8010b2:	50                   	push   %eax
  8010b3:	57                   	push   %edi
  8010b4:	6a 00                	push   $0x0
  8010b6:	53                   	push   %ebx
  8010b7:	6a 00                	push   $0x0
  8010b9:	e8 70 fb ff ff       	call   800c2e <sys_page_map>
  8010be:	89 c3                	mov    %eax,%ebx
  8010c0:	83 c4 20             	add    $0x20,%esp
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	79 a3                	jns    80106a <dup+0x74>
	sys_page_unmap(0, newfd);
  8010c7:	83 ec 08             	sub    $0x8,%esp
  8010ca:	56                   	push   %esi
  8010cb:	6a 00                	push   $0x0
  8010cd:	e8 9e fb ff ff       	call   800c70 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010d2:	83 c4 08             	add    $0x8,%esp
  8010d5:	57                   	push   %edi
  8010d6:	6a 00                	push   $0x0
  8010d8:	e8 93 fb ff ff       	call   800c70 <sys_page_unmap>
	return r;
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	eb b7                	jmp    801099 <dup+0xa3>

008010e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	53                   	push   %ebx
  8010e6:	83 ec 14             	sub    $0x14,%esp
  8010e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ef:	50                   	push   %eax
  8010f0:	53                   	push   %ebx
  8010f1:	e8 7b fd ff ff       	call   800e71 <fd_lookup>
  8010f6:	83 c4 08             	add    $0x8,%esp
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	78 3f                	js     80113c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801103:	50                   	push   %eax
  801104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801107:	ff 30                	pushl  (%eax)
  801109:	e8 b9 fd ff ff       	call   800ec7 <dev_lookup>
  80110e:	83 c4 10             	add    $0x10,%esp
  801111:	85 c0                	test   %eax,%eax
  801113:	78 27                	js     80113c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801115:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801118:	8b 42 08             	mov    0x8(%edx),%eax
  80111b:	83 e0 03             	and    $0x3,%eax
  80111e:	83 f8 01             	cmp    $0x1,%eax
  801121:	74 1e                	je     801141 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801126:	8b 40 08             	mov    0x8(%eax),%eax
  801129:	85 c0                	test   %eax,%eax
  80112b:	74 35                	je     801162 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	ff 75 10             	pushl  0x10(%ebp)
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	52                   	push   %edx
  801137:	ff d0                	call   *%eax
  801139:	83 c4 10             	add    $0x10,%esp
}
  80113c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113f:	c9                   	leave  
  801140:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801141:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801146:	8b 40 48             	mov    0x48(%eax),%eax
  801149:	83 ec 04             	sub    $0x4,%esp
  80114c:	53                   	push   %ebx
  80114d:	50                   	push   %eax
  80114e:	68 ad 26 80 00       	push   $0x8026ad
  801153:	e8 fd ef ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801160:	eb da                	jmp    80113c <read+0x5a>
		return -E_NOT_SUPP;
  801162:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801167:	eb d3                	jmp    80113c <read+0x5a>

00801169 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
  80116f:	83 ec 0c             	sub    $0xc,%esp
  801172:	8b 7d 08             	mov    0x8(%ebp),%edi
  801175:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801178:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117d:	39 f3                	cmp    %esi,%ebx
  80117f:	73 25                	jae    8011a6 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	89 f0                	mov    %esi,%eax
  801186:	29 d8                	sub    %ebx,%eax
  801188:	50                   	push   %eax
  801189:	89 d8                	mov    %ebx,%eax
  80118b:	03 45 0c             	add    0xc(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	57                   	push   %edi
  801190:	e8 4d ff ff ff       	call   8010e2 <read>
		if (m < 0)
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	78 08                	js     8011a4 <readn+0x3b>
			return m;
		if (m == 0)
  80119c:	85 c0                	test   %eax,%eax
  80119e:	74 06                	je     8011a6 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011a0:	01 c3                	add    %eax,%ebx
  8011a2:	eb d9                	jmp    80117d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011a4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011a6:	89 d8                	mov    %ebx,%eax
  8011a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5f                   	pop    %edi
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 14             	sub    $0x14,%esp
  8011b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011bd:	50                   	push   %eax
  8011be:	53                   	push   %ebx
  8011bf:	e8 ad fc ff ff       	call   800e71 <fd_lookup>
  8011c4:	83 c4 08             	add    $0x8,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 3a                	js     801205 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d1:	50                   	push   %eax
  8011d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d5:	ff 30                	pushl  (%eax)
  8011d7:	e8 eb fc ff ff       	call   800ec7 <dev_lookup>
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	78 22                	js     801205 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011ea:	74 1e                	je     80120a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ef:	8b 52 0c             	mov    0xc(%edx),%edx
  8011f2:	85 d2                	test   %edx,%edx
  8011f4:	74 35                	je     80122b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	ff 75 10             	pushl  0x10(%ebp)
  8011fc:	ff 75 0c             	pushl  0xc(%ebp)
  8011ff:	50                   	push   %eax
  801200:	ff d2                	call   *%edx
  801202:	83 c4 10             	add    $0x10,%esp
}
  801205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801208:	c9                   	leave  
  801209:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80120a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80120f:	8b 40 48             	mov    0x48(%eax),%eax
  801212:	83 ec 04             	sub    $0x4,%esp
  801215:	53                   	push   %ebx
  801216:	50                   	push   %eax
  801217:	68 c9 26 80 00       	push   $0x8026c9
  80121c:	e8 34 ef ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801229:	eb da                	jmp    801205 <write+0x55>
		return -E_NOT_SUPP;
  80122b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801230:	eb d3                	jmp    801205 <write+0x55>

00801232 <seek>:

int
seek(int fdnum, off_t offset)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801238:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80123b:	50                   	push   %eax
  80123c:	ff 75 08             	pushl  0x8(%ebp)
  80123f:	e8 2d fc ff ff       	call   800e71 <fd_lookup>
  801244:	83 c4 08             	add    $0x8,%esp
  801247:	85 c0                	test   %eax,%eax
  801249:	78 0e                	js     801259 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80124b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801251:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801254:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	53                   	push   %ebx
  80125f:	83 ec 14             	sub    $0x14,%esp
  801262:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801265:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	53                   	push   %ebx
  80126a:	e8 02 fc ff ff       	call   800e71 <fd_lookup>
  80126f:	83 c4 08             	add    $0x8,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 37                	js     8012ad <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127c:	50                   	push   %eax
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801280:	ff 30                	pushl  (%eax)
  801282:	e8 40 fc ff ff       	call   800ec7 <dev_lookup>
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 1f                	js     8012ad <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801291:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801295:	74 1b                	je     8012b2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129a:	8b 52 18             	mov    0x18(%edx),%edx
  80129d:	85 d2                	test   %edx,%edx
  80129f:	74 32                	je     8012d3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	50                   	push   %eax
  8012a8:	ff d2                	call   *%edx
  8012aa:	83 c4 10             	add    $0x10,%esp
}
  8012ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012b2:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012b7:	8b 40 48             	mov    0x48(%eax),%eax
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	53                   	push   %ebx
  8012be:	50                   	push   %eax
  8012bf:	68 8c 26 80 00       	push   $0x80268c
  8012c4:	e8 8c ee ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d1:	eb da                	jmp    8012ad <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d8:	eb d3                	jmp    8012ad <ftruncate+0x52>

008012da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 14             	sub    $0x14,%esp
  8012e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e7:	50                   	push   %eax
  8012e8:	ff 75 08             	pushl  0x8(%ebp)
  8012eb:	e8 81 fb ff ff       	call   800e71 <fd_lookup>
  8012f0:	83 c4 08             	add    $0x8,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 4b                	js     801342 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f7:	83 ec 08             	sub    $0x8,%esp
  8012fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fd:	50                   	push   %eax
  8012fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801301:	ff 30                	pushl  (%eax)
  801303:	e8 bf fb ff ff       	call   800ec7 <dev_lookup>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	85 c0                	test   %eax,%eax
  80130d:	78 33                	js     801342 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80130f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801312:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801316:	74 2f                	je     801347 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801318:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80131b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801322:	00 00 00 
	stat->st_isdir = 0;
  801325:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80132c:	00 00 00 
	stat->st_dev = dev;
  80132f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	53                   	push   %ebx
  801339:	ff 75 f0             	pushl  -0x10(%ebp)
  80133c:	ff 50 14             	call   *0x14(%eax)
  80133f:	83 c4 10             	add    $0x10,%esp
}
  801342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801345:	c9                   	leave  
  801346:	c3                   	ret    
		return -E_NOT_SUPP;
  801347:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80134c:	eb f4                	jmp    801342 <fstat+0x68>

0080134e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	56                   	push   %esi
  801352:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801353:	83 ec 08             	sub    $0x8,%esp
  801356:	6a 00                	push   $0x0
  801358:	ff 75 08             	pushl  0x8(%ebp)
  80135b:	e8 26 02 00 00       	call   801586 <open>
  801360:	89 c3                	mov    %eax,%ebx
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	85 c0                	test   %eax,%eax
  801367:	78 1b                	js     801384 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801369:	83 ec 08             	sub    $0x8,%esp
  80136c:	ff 75 0c             	pushl  0xc(%ebp)
  80136f:	50                   	push   %eax
  801370:	e8 65 ff ff ff       	call   8012da <fstat>
  801375:	89 c6                	mov    %eax,%esi
	close(fd);
  801377:	89 1c 24             	mov    %ebx,(%esp)
  80137a:	e8 27 fc ff ff       	call   800fa6 <close>
	return r;
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	89 f3                	mov    %esi,%ebx
}
  801384:	89 d8                	mov    %ebx,%eax
  801386:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801389:	5b                   	pop    %ebx
  80138a:	5e                   	pop    %esi
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
  801392:	89 c6                	mov    %eax,%esi
  801394:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801396:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80139d:	74 27                	je     8013c6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80139f:	6a 07                	push   $0x7
  8013a1:	68 00 50 80 00       	push   $0x805000
  8013a6:	56                   	push   %esi
  8013a7:	ff 35 00 40 80 00    	pushl  0x804000
  8013ad:	e8 57 0c 00 00       	call   802009 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013b2:	83 c4 0c             	add    $0xc,%esp
  8013b5:	6a 00                	push   $0x0
  8013b7:	53                   	push   %ebx
  8013b8:	6a 00                	push   $0x0
  8013ba:	e8 e1 0b 00 00       	call   801fa0 <ipc_recv>
}
  8013bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013c6:	83 ec 0c             	sub    $0xc,%esp
  8013c9:	6a 01                	push   $0x1
  8013cb:	e8 92 0c 00 00       	call   802062 <ipc_find_env>
  8013d0:	a3 00 40 80 00       	mov    %eax,0x804000
  8013d5:	83 c4 10             	add    $0x10,%esp
  8013d8:	eb c5                	jmp    80139f <fsipc+0x12>

008013da <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ee:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f8:	b8 02 00 00 00       	mov    $0x2,%eax
  8013fd:	e8 8b ff ff ff       	call   80138d <fsipc>
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <devfile_flush>:
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8b 40 0c             	mov    0xc(%eax),%eax
  801410:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801415:	ba 00 00 00 00       	mov    $0x0,%edx
  80141a:	b8 06 00 00 00       	mov    $0x6,%eax
  80141f:	e8 69 ff ff ff       	call   80138d <fsipc>
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <devfile_stat>:
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	53                   	push   %ebx
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8b 40 0c             	mov    0xc(%eax),%eax
  801436:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80143b:	ba 00 00 00 00       	mov    $0x0,%edx
  801440:	b8 05 00 00 00       	mov    $0x5,%eax
  801445:	e8 43 ff ff ff       	call   80138d <fsipc>
  80144a:	85 c0                	test   %eax,%eax
  80144c:	78 2c                	js     80147a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	68 00 50 80 00       	push   $0x805000
  801456:	53                   	push   %ebx
  801457:	e8 96 f3 ff ff       	call   8007f2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80145c:	a1 80 50 80 00       	mov    0x805080,%eax
  801461:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801467:	a1 84 50 80 00       	mov    0x805084,%eax
  80146c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <devfile_write>:
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	53                   	push   %ebx
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8b 40 0c             	mov    0xc(%eax),%eax
  80148f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801494:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80149a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8014a0:	77 30                	ja     8014d2 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	53                   	push   %ebx
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	68 08 50 80 00       	push   $0x805008
  8014ae:	e8 cd f4 ff ff       	call   800980 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b8:	b8 04 00 00 00       	mov    $0x4,%eax
  8014bd:	e8 cb fe ff ff       	call   80138d <fsipc>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 04                	js     8014cd <devfile_write+0x4e>
	assert(r <= n);
  8014c9:	39 d8                	cmp    %ebx,%eax
  8014cb:	77 1e                	ja     8014eb <devfile_write+0x6c>
}
  8014cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014d2:	68 fc 26 80 00       	push   $0x8026fc
  8014d7:	68 29 27 80 00       	push   $0x802729
  8014dc:	68 94 00 00 00       	push   $0x94
  8014e1:	68 3e 27 80 00       	push   $0x80273e
  8014e6:	e8 6f 0a 00 00       	call   801f5a <_panic>
	assert(r <= n);
  8014eb:	68 49 27 80 00       	push   $0x802749
  8014f0:	68 29 27 80 00       	push   $0x802729
  8014f5:	68 98 00 00 00       	push   $0x98
  8014fa:	68 3e 27 80 00       	push   $0x80273e
  8014ff:	e8 56 0a 00 00       	call   801f5a <_panic>

00801504 <devfile_read>:
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8b 40 0c             	mov    0xc(%eax),%eax
  801512:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801517:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80151d:	ba 00 00 00 00       	mov    $0x0,%edx
  801522:	b8 03 00 00 00       	mov    $0x3,%eax
  801527:	e8 61 fe ff ff       	call   80138d <fsipc>
  80152c:	89 c3                	mov    %eax,%ebx
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 1f                	js     801551 <devfile_read+0x4d>
	assert(r <= n);
  801532:	39 f0                	cmp    %esi,%eax
  801534:	77 24                	ja     80155a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801536:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80153b:	7f 33                	jg     801570 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80153d:	83 ec 04             	sub    $0x4,%esp
  801540:	50                   	push   %eax
  801541:	68 00 50 80 00       	push   $0x805000
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	e8 32 f4 ff ff       	call   800980 <memmove>
	return r;
  80154e:	83 c4 10             	add    $0x10,%esp
}
  801551:	89 d8                	mov    %ebx,%eax
  801553:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801556:	5b                   	pop    %ebx
  801557:	5e                   	pop    %esi
  801558:	5d                   	pop    %ebp
  801559:	c3                   	ret    
	assert(r <= n);
  80155a:	68 49 27 80 00       	push   $0x802749
  80155f:	68 29 27 80 00       	push   $0x802729
  801564:	6a 7c                	push   $0x7c
  801566:	68 3e 27 80 00       	push   $0x80273e
  80156b:	e8 ea 09 00 00       	call   801f5a <_panic>
	assert(r <= PGSIZE);
  801570:	68 50 27 80 00       	push   $0x802750
  801575:	68 29 27 80 00       	push   $0x802729
  80157a:	6a 7d                	push   $0x7d
  80157c:	68 3e 27 80 00       	push   $0x80273e
  801581:	e8 d4 09 00 00       	call   801f5a <_panic>

00801586 <open>:
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	83 ec 1c             	sub    $0x1c,%esp
  80158e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801591:	56                   	push   %esi
  801592:	e8 24 f2 ff ff       	call   8007bb <strlen>
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80159f:	7f 6c                	jg     80160d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	e8 75 f8 ff ff       	call   800e22 <fd_alloc>
  8015ad:	89 c3                	mov    %eax,%ebx
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	78 3c                	js     8015f2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015b6:	83 ec 08             	sub    $0x8,%esp
  8015b9:	56                   	push   %esi
  8015ba:	68 00 50 80 00       	push   $0x805000
  8015bf:	e8 2e f2 ff ff       	call   8007f2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d4:	e8 b4 fd ff ff       	call   80138d <fsipc>
  8015d9:	89 c3                	mov    %eax,%ebx
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 19                	js     8015fb <open+0x75>
	return fd2num(fd);
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e8:	e8 0e f8 ff ff       	call   800dfb <fd2num>
  8015ed:	89 c3                	mov    %eax,%ebx
  8015ef:	83 c4 10             	add    $0x10,%esp
}
  8015f2:	89 d8                	mov    %ebx,%eax
  8015f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f7:	5b                   	pop    %ebx
  8015f8:	5e                   	pop    %esi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    
		fd_close(fd, 0);
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	6a 00                	push   $0x0
  801600:	ff 75 f4             	pushl  -0xc(%ebp)
  801603:	e8 15 f9 ff ff       	call   800f1d <fd_close>
		return r;
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	eb e5                	jmp    8015f2 <open+0x6c>
		return -E_BAD_PATH;
  80160d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801612:	eb de                	jmp    8015f2 <open+0x6c>

00801614 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	b8 08 00 00 00       	mov    $0x8,%eax
  801624:	e8 64 fd ff ff       	call   80138d <fsipc>
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	56                   	push   %esi
  80162f:	53                   	push   %ebx
  801630:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 cd f7 ff ff       	call   800e0b <fd2data>
  80163e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801640:	83 c4 08             	add    $0x8,%esp
  801643:	68 5c 27 80 00       	push   $0x80275c
  801648:	53                   	push   %ebx
  801649:	e8 a4 f1 ff ff       	call   8007f2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80164e:	8b 46 04             	mov    0x4(%esi),%eax
  801651:	2b 06                	sub    (%esi),%eax
  801653:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801659:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801660:	00 00 00 
	stat->st_dev = &devpipe;
  801663:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80166a:	30 80 00 
	return 0;
}
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
  801672:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5d                   	pop    %ebp
  801678:	c3                   	ret    

00801679 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	53                   	push   %ebx
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801683:	53                   	push   %ebx
  801684:	6a 00                	push   $0x0
  801686:	e8 e5 f5 ff ff       	call   800c70 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80168b:	89 1c 24             	mov    %ebx,(%esp)
  80168e:	e8 78 f7 ff ff       	call   800e0b <fd2data>
  801693:	83 c4 08             	add    $0x8,%esp
  801696:	50                   	push   %eax
  801697:	6a 00                	push   $0x0
  801699:	e8 d2 f5 ff ff       	call   800c70 <sys_page_unmap>
}
  80169e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <_pipeisclosed>:
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	57                   	push   %edi
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 1c             	sub    $0x1c,%esp
  8016ac:	89 c7                	mov    %eax,%edi
  8016ae:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016b0:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8016b5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016b8:	83 ec 0c             	sub    $0xc,%esp
  8016bb:	57                   	push   %edi
  8016bc:	e8 da 09 00 00       	call   80209b <pageref>
  8016c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016c4:	89 34 24             	mov    %esi,(%esp)
  8016c7:	e8 cf 09 00 00       	call   80209b <pageref>
		nn = thisenv->env_runs;
  8016cc:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8016d2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	39 cb                	cmp    %ecx,%ebx
  8016da:	74 1b                	je     8016f7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016dc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016df:	75 cf                	jne    8016b0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016e1:	8b 42 58             	mov    0x58(%edx),%eax
  8016e4:	6a 01                	push   $0x1
  8016e6:	50                   	push   %eax
  8016e7:	53                   	push   %ebx
  8016e8:	68 63 27 80 00       	push   $0x802763
  8016ed:	e8 63 ea ff ff       	call   800155 <cprintf>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	eb b9                	jmp    8016b0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016f7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016fa:	0f 94 c0             	sete   %al
  8016fd:	0f b6 c0             	movzbl %al,%eax
}
  801700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5f                   	pop    %edi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    

00801708 <devpipe_write>:
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	57                   	push   %edi
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
  80170e:	83 ec 28             	sub    $0x28,%esp
  801711:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801714:	56                   	push   %esi
  801715:	e8 f1 f6 ff ff       	call   800e0b <fd2data>
  80171a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	bf 00 00 00 00       	mov    $0x0,%edi
  801724:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801727:	74 4f                	je     801778 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801729:	8b 43 04             	mov    0x4(%ebx),%eax
  80172c:	8b 0b                	mov    (%ebx),%ecx
  80172e:	8d 51 20             	lea    0x20(%ecx),%edx
  801731:	39 d0                	cmp    %edx,%eax
  801733:	72 14                	jb     801749 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801735:	89 da                	mov    %ebx,%edx
  801737:	89 f0                	mov    %esi,%eax
  801739:	e8 65 ff ff ff       	call   8016a3 <_pipeisclosed>
  80173e:	85 c0                	test   %eax,%eax
  801740:	75 3a                	jne    80177c <devpipe_write+0x74>
			sys_yield();
  801742:	e8 85 f4 ff ff       	call   800bcc <sys_yield>
  801747:	eb e0                	jmp    801729 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801750:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801753:	89 c2                	mov    %eax,%edx
  801755:	c1 fa 1f             	sar    $0x1f,%edx
  801758:	89 d1                	mov    %edx,%ecx
  80175a:	c1 e9 1b             	shr    $0x1b,%ecx
  80175d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801760:	83 e2 1f             	and    $0x1f,%edx
  801763:	29 ca                	sub    %ecx,%edx
  801765:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801769:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80176d:	83 c0 01             	add    $0x1,%eax
  801770:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801773:	83 c7 01             	add    $0x1,%edi
  801776:	eb ac                	jmp    801724 <devpipe_write+0x1c>
	return i;
  801778:	89 f8                	mov    %edi,%eax
  80177a:	eb 05                	jmp    801781 <devpipe_write+0x79>
				return 0;
  80177c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801781:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801784:	5b                   	pop    %ebx
  801785:	5e                   	pop    %esi
  801786:	5f                   	pop    %edi
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    

00801789 <devpipe_read>:
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	57                   	push   %edi
  80178d:	56                   	push   %esi
  80178e:	53                   	push   %ebx
  80178f:	83 ec 18             	sub    $0x18,%esp
  801792:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801795:	57                   	push   %edi
  801796:	e8 70 f6 ff ff       	call   800e0b <fd2data>
  80179b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	be 00 00 00 00       	mov    $0x0,%esi
  8017a5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017a8:	74 47                	je     8017f1 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8017aa:	8b 03                	mov    (%ebx),%eax
  8017ac:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017af:	75 22                	jne    8017d3 <devpipe_read+0x4a>
			if (i > 0)
  8017b1:	85 f6                	test   %esi,%esi
  8017b3:	75 14                	jne    8017c9 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8017b5:	89 da                	mov    %ebx,%edx
  8017b7:	89 f8                	mov    %edi,%eax
  8017b9:	e8 e5 fe ff ff       	call   8016a3 <_pipeisclosed>
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	75 33                	jne    8017f5 <devpipe_read+0x6c>
			sys_yield();
  8017c2:	e8 05 f4 ff ff       	call   800bcc <sys_yield>
  8017c7:	eb e1                	jmp    8017aa <devpipe_read+0x21>
				return i;
  8017c9:	89 f0                	mov    %esi,%eax
}
  8017cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ce:	5b                   	pop    %ebx
  8017cf:	5e                   	pop    %esi
  8017d0:	5f                   	pop    %edi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017d3:	99                   	cltd   
  8017d4:	c1 ea 1b             	shr    $0x1b,%edx
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	83 e0 1f             	and    $0x1f,%eax
  8017dc:	29 d0                	sub    %edx,%eax
  8017de:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017e9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017ec:	83 c6 01             	add    $0x1,%esi
  8017ef:	eb b4                	jmp    8017a5 <devpipe_read+0x1c>
	return i;
  8017f1:	89 f0                	mov    %esi,%eax
  8017f3:	eb d6                	jmp    8017cb <devpipe_read+0x42>
				return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	eb cf                	jmp    8017cb <devpipe_read+0x42>

008017fc <pipe>:
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	56                   	push   %esi
  801800:	53                   	push   %ebx
  801801:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801804:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801807:	50                   	push   %eax
  801808:	e8 15 f6 ff ff       	call   800e22 <fd_alloc>
  80180d:	89 c3                	mov    %eax,%ebx
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	85 c0                	test   %eax,%eax
  801814:	78 5b                	js     801871 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 07 04 00 00       	push   $0x407
  80181e:	ff 75 f4             	pushl  -0xc(%ebp)
  801821:	6a 00                	push   $0x0
  801823:	e8 c3 f3 ff ff       	call   800beb <sys_page_alloc>
  801828:	89 c3                	mov    %eax,%ebx
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	85 c0                	test   %eax,%eax
  80182f:	78 40                	js     801871 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801831:	83 ec 0c             	sub    $0xc,%esp
  801834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801837:	50                   	push   %eax
  801838:	e8 e5 f5 ff ff       	call   800e22 <fd_alloc>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 1b                	js     801861 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	68 07 04 00 00       	push   $0x407
  80184e:	ff 75 f0             	pushl  -0x10(%ebp)
  801851:	6a 00                	push   $0x0
  801853:	e8 93 f3 ff ff       	call   800beb <sys_page_alloc>
  801858:	89 c3                	mov    %eax,%ebx
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	79 19                	jns    80187a <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801861:	83 ec 08             	sub    $0x8,%esp
  801864:	ff 75 f4             	pushl  -0xc(%ebp)
  801867:	6a 00                	push   $0x0
  801869:	e8 02 f4 ff ff       	call   800c70 <sys_page_unmap>
  80186e:	83 c4 10             	add    $0x10,%esp
}
  801871:	89 d8                	mov    %ebx,%eax
  801873:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801876:	5b                   	pop    %ebx
  801877:	5e                   	pop    %esi
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    
	va = fd2data(fd0);
  80187a:	83 ec 0c             	sub    $0xc,%esp
  80187d:	ff 75 f4             	pushl  -0xc(%ebp)
  801880:	e8 86 f5 ff ff       	call   800e0b <fd2data>
  801885:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801887:	83 c4 0c             	add    $0xc,%esp
  80188a:	68 07 04 00 00       	push   $0x407
  80188f:	50                   	push   %eax
  801890:	6a 00                	push   $0x0
  801892:	e8 54 f3 ff ff       	call   800beb <sys_page_alloc>
  801897:	89 c3                	mov    %eax,%ebx
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	0f 88 8c 00 00 00    	js     801930 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018a4:	83 ec 0c             	sub    $0xc,%esp
  8018a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8018aa:	e8 5c f5 ff ff       	call   800e0b <fd2data>
  8018af:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018b6:	50                   	push   %eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	56                   	push   %esi
  8018ba:	6a 00                	push   $0x0
  8018bc:	e8 6d f3 ff ff       	call   800c2e <sys_page_map>
  8018c1:	89 c3                	mov    %eax,%ebx
  8018c3:	83 c4 20             	add    $0x20,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 58                	js     801922 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018d3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8018d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8018df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ed:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018f4:	83 ec 0c             	sub    $0xc,%esp
  8018f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fa:	e8 fc f4 ff ff       	call   800dfb <fd2num>
  8018ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801902:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801904:	83 c4 04             	add    $0x4,%esp
  801907:	ff 75 f0             	pushl  -0x10(%ebp)
  80190a:	e8 ec f4 ff ff       	call   800dfb <fd2num>
  80190f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801912:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	bb 00 00 00 00       	mov    $0x0,%ebx
  80191d:	e9 4f ff ff ff       	jmp    801871 <pipe+0x75>
	sys_page_unmap(0, va);
  801922:	83 ec 08             	sub    $0x8,%esp
  801925:	56                   	push   %esi
  801926:	6a 00                	push   $0x0
  801928:	e8 43 f3 ff ff       	call   800c70 <sys_page_unmap>
  80192d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801930:	83 ec 08             	sub    $0x8,%esp
  801933:	ff 75 f0             	pushl  -0x10(%ebp)
  801936:	6a 00                	push   $0x0
  801938:	e8 33 f3 ff ff       	call   800c70 <sys_page_unmap>
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	e9 1c ff ff ff       	jmp    801861 <pipe+0x65>

00801945 <pipeisclosed>:
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194e:	50                   	push   %eax
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	e8 1a f5 ff ff       	call   800e71 <fd_lookup>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	78 18                	js     801976 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	ff 75 f4             	pushl  -0xc(%ebp)
  801964:	e8 a2 f4 ff ff       	call   800e0b <fd2data>
	return _pipeisclosed(fd, p);
  801969:	89 c2                	mov    %eax,%edx
  80196b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196e:	e8 30 fd ff ff       	call   8016a3 <_pipeisclosed>
  801973:	83 c4 10             	add    $0x10,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80197e:	68 7b 27 80 00       	push   $0x80277b
  801983:	ff 75 0c             	pushl  0xc(%ebp)
  801986:	e8 67 ee ff ff       	call   8007f2 <strcpy>
	return 0;
}
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <devsock_close>:
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	53                   	push   %ebx
  801996:	83 ec 10             	sub    $0x10,%esp
  801999:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80199c:	53                   	push   %ebx
  80199d:	e8 f9 06 00 00       	call   80209b <pageref>
  8019a2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019a5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019aa:	83 f8 01             	cmp    $0x1,%eax
  8019ad:	74 07                	je     8019b6 <devsock_close+0x24>
}
  8019af:	89 d0                	mov    %edx,%eax
  8019b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	ff 73 0c             	pushl  0xc(%ebx)
  8019bc:	e8 b7 02 00 00       	call   801c78 <nsipc_close>
  8019c1:	89 c2                	mov    %eax,%edx
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	eb e7                	jmp    8019af <devsock_close+0x1d>

008019c8 <devsock_write>:
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	ff 75 10             	pushl  0x10(%ebp)
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	ff 70 0c             	pushl  0xc(%eax)
  8019dc:	e8 74 03 00 00       	call   801d55 <nsipc_send>
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <devsock_read>:
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 10             	pushl  0x10(%ebp)
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	ff 70 0c             	pushl  0xc(%eax)
  8019f7:	e8 ed 02 00 00       	call   801ce9 <nsipc_recv>
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <fd2sockid>:
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a04:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a07:	52                   	push   %edx
  801a08:	50                   	push   %eax
  801a09:	e8 63 f4 ff ff       	call   800e71 <fd_lookup>
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	85 c0                	test   %eax,%eax
  801a13:	78 10                	js     801a25 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a18:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a1e:	39 08                	cmp    %ecx,(%eax)
  801a20:	75 05                	jne    801a27 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a22:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    
		return -E_NOT_SUPP;
  801a27:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2c:	eb f7                	jmp    801a25 <fd2sockid+0x27>

00801a2e <alloc_sockfd>:
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	56                   	push   %esi
  801a32:	53                   	push   %ebx
  801a33:	83 ec 1c             	sub    $0x1c,%esp
  801a36:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3b:	50                   	push   %eax
  801a3c:	e8 e1 f3 ff ff       	call   800e22 <fd_alloc>
  801a41:	89 c3                	mov    %eax,%ebx
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	85 c0                	test   %eax,%eax
  801a48:	78 43                	js     801a8d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a4a:	83 ec 04             	sub    $0x4,%esp
  801a4d:	68 07 04 00 00       	push   $0x407
  801a52:	ff 75 f4             	pushl  -0xc(%ebp)
  801a55:	6a 00                	push   $0x0
  801a57:	e8 8f f1 ff ff       	call   800beb <sys_page_alloc>
  801a5c:	89 c3                	mov    %eax,%ebx
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 28                	js     801a8d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a68:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a6e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a73:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a7a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a7d:	83 ec 0c             	sub    $0xc,%esp
  801a80:	50                   	push   %eax
  801a81:	e8 75 f3 ff ff       	call   800dfb <fd2num>
  801a86:	89 c3                	mov    %eax,%ebx
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	eb 0c                	jmp    801a99 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a8d:	83 ec 0c             	sub    $0xc,%esp
  801a90:	56                   	push   %esi
  801a91:	e8 e2 01 00 00       	call   801c78 <nsipc_close>
		return r;
  801a96:	83 c4 10             	add    $0x10,%esp
}
  801a99:	89 d8                	mov    %ebx,%eax
  801a9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9e:	5b                   	pop    %ebx
  801a9f:	5e                   	pop    %esi
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    

00801aa2 <accept>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	e8 4e ff ff ff       	call   8019fe <fd2sockid>
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 1b                	js     801acf <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	ff 75 10             	pushl  0x10(%ebp)
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	50                   	push   %eax
  801abe:	e8 0e 01 00 00       	call   801bd1 <nsipc_accept>
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 05                	js     801acf <accept+0x2d>
	return alloc_sockfd(r);
  801aca:	e8 5f ff ff ff       	call   801a2e <alloc_sockfd>
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <bind>:
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	e8 1f ff ff ff       	call   8019fe <fd2sockid>
  801adf:	85 c0                	test   %eax,%eax
  801ae1:	78 12                	js     801af5 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ae3:	83 ec 04             	sub    $0x4,%esp
  801ae6:	ff 75 10             	pushl  0x10(%ebp)
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	50                   	push   %eax
  801aed:	e8 2f 01 00 00       	call   801c21 <nsipc_bind>
  801af2:	83 c4 10             	add    $0x10,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <shutdown>:
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	e8 f9 fe ff ff       	call   8019fe <fd2sockid>
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 0f                	js     801b18 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b09:	83 ec 08             	sub    $0x8,%esp
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	50                   	push   %eax
  801b10:	e8 41 01 00 00       	call   801c56 <nsipc_shutdown>
  801b15:	83 c4 10             	add    $0x10,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <connect>:
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	e8 d6 fe ff ff       	call   8019fe <fd2sockid>
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 12                	js     801b3e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	ff 75 10             	pushl  0x10(%ebp)
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	50                   	push   %eax
  801b36:	e8 57 01 00 00       	call   801c92 <nsipc_connect>
  801b3b:	83 c4 10             	add    $0x10,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <listen>:
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	e8 b0 fe ff ff       	call   8019fe <fd2sockid>
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 0f                	js     801b61 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b52:	83 ec 08             	sub    $0x8,%esp
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	50                   	push   %eax
  801b59:	e8 69 01 00 00       	call   801cc7 <nsipc_listen>
  801b5e:	83 c4 10             	add    $0x10,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	ff 75 08             	pushl  0x8(%ebp)
  801b72:	e8 3c 02 00 00       	call   801db3 <nsipc_socket>
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 05                	js     801b83 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b7e:	e8 ab fe ff ff       	call   801a2e <alloc_sockfd>
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	53                   	push   %ebx
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b8e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b95:	74 26                	je     801bbd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b97:	6a 07                	push   $0x7
  801b99:	68 00 60 80 00       	push   $0x806000
  801b9e:	53                   	push   %ebx
  801b9f:	ff 35 04 40 80 00    	pushl  0x804004
  801ba5:	e8 5f 04 00 00       	call   802009 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801baa:	83 c4 0c             	add    $0xc,%esp
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	e8 e8 03 00 00       	call   801fa0 <ipc_recv>
}
  801bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	6a 02                	push   $0x2
  801bc2:	e8 9b 04 00 00       	call   802062 <ipc_find_env>
  801bc7:	a3 04 40 80 00       	mov    %eax,0x804004
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	eb c6                	jmp    801b97 <nsipc+0x12>

00801bd1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	56                   	push   %esi
  801bd5:	53                   	push   %ebx
  801bd6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801be1:	8b 06                	mov    (%esi),%eax
  801be3:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801be8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bed:	e8 93 ff ff ff       	call   801b85 <nsipc>
  801bf2:	89 c3                	mov    %eax,%ebx
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 20                	js     801c18 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bf8:	83 ec 04             	sub    $0x4,%esp
  801bfb:	ff 35 10 60 80 00    	pushl  0x806010
  801c01:	68 00 60 80 00       	push   $0x806000
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	e8 72 ed ff ff       	call   800980 <memmove>
		*addrlen = ret->ret_addrlen;
  801c0e:	a1 10 60 80 00       	mov    0x806010,%eax
  801c13:	89 06                	mov    %eax,(%esi)
  801c15:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    

00801c21 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	53                   	push   %ebx
  801c25:	83 ec 08             	sub    $0x8,%esp
  801c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c33:	53                   	push   %ebx
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	68 04 60 80 00       	push   $0x806004
  801c3c:	e8 3f ed ff ff       	call   800980 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c41:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c47:	b8 02 00 00 00       	mov    $0x2,%eax
  801c4c:	e8 34 ff ff ff       	call   801b85 <nsipc>
}
  801c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c67:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c6c:	b8 03 00 00 00       	mov    $0x3,%eax
  801c71:	e8 0f ff ff ff       	call   801b85 <nsipc>
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <nsipc_close>:

int
nsipc_close(int s)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c86:	b8 04 00 00 00       	mov    $0x4,%eax
  801c8b:	e8 f5 fe ff ff       	call   801b85 <nsipc>
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	53                   	push   %ebx
  801c96:	83 ec 08             	sub    $0x8,%esp
  801c99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ca4:	53                   	push   %ebx
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	68 04 60 80 00       	push   $0x806004
  801cad:	e8 ce ec ff ff       	call   800980 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cb2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cb8:	b8 05 00 00 00       	mov    $0x5,%eax
  801cbd:	e8 c3 fe ff ff       	call   801b85 <nsipc>
}
  801cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cdd:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce2:	e8 9e fe ff ff       	call   801b85 <nsipc>
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	56                   	push   %esi
  801ced:	53                   	push   %ebx
  801cee:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cf9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d07:	b8 07 00 00 00       	mov    $0x7,%eax
  801d0c:	e8 74 fe ff ff       	call   801b85 <nsipc>
  801d11:	89 c3                	mov    %eax,%ebx
  801d13:	85 c0                	test   %eax,%eax
  801d15:	78 1f                	js     801d36 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d17:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d1c:	7f 21                	jg     801d3f <nsipc_recv+0x56>
  801d1e:	39 c6                	cmp    %eax,%esi
  801d20:	7c 1d                	jl     801d3f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	50                   	push   %eax
  801d26:	68 00 60 80 00       	push   $0x806000
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	e8 4d ec ff ff       	call   800980 <memmove>
  801d33:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d36:	89 d8                	mov    %ebx,%eax
  801d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d3f:	68 87 27 80 00       	push   $0x802787
  801d44:	68 29 27 80 00       	push   $0x802729
  801d49:	6a 62                	push   $0x62
  801d4b:	68 9c 27 80 00       	push   $0x80279c
  801d50:	e8 05 02 00 00       	call   801f5a <_panic>

00801d55 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	53                   	push   %ebx
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d67:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d6d:	7f 2e                	jg     801d9d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d6f:	83 ec 04             	sub    $0x4,%esp
  801d72:	53                   	push   %ebx
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	68 0c 60 80 00       	push   $0x80600c
  801d7b:	e8 00 ec ff ff       	call   800980 <memmove>
	nsipcbuf.send.req_size = size;
  801d80:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d86:	8b 45 14             	mov    0x14(%ebp),%eax
  801d89:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d8e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d93:	e8 ed fd ff ff       	call   801b85 <nsipc>
}
  801d98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    
	assert(size < 1600);
  801d9d:	68 a8 27 80 00       	push   $0x8027a8
  801da2:	68 29 27 80 00       	push   $0x802729
  801da7:	6a 6d                	push   $0x6d
  801da9:	68 9c 27 80 00       	push   $0x80279c
  801dae:	e8 a7 01 00 00       	call   801f5a <_panic>

00801db3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dd1:	b8 09 00 00 00       	mov    $0x9,%eax
  801dd6:	e8 aa fd ff ff       	call   801b85 <nsipc>
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ded:	68 b4 27 80 00       	push   $0x8027b4
  801df2:	ff 75 0c             	pushl  0xc(%ebp)
  801df5:	e8 f8 e9 ff ff       	call   8007f2 <strcpy>
	return 0;
}
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <devcons_write>:
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	57                   	push   %edi
  801e05:	56                   	push   %esi
  801e06:	53                   	push   %ebx
  801e07:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e0d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e12:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e18:	eb 2f                	jmp    801e49 <devcons_write+0x48>
		m = n - tot;
  801e1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e1d:	29 f3                	sub    %esi,%ebx
  801e1f:	83 fb 7f             	cmp    $0x7f,%ebx
  801e22:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e27:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	53                   	push   %ebx
  801e2e:	89 f0                	mov    %esi,%eax
  801e30:	03 45 0c             	add    0xc(%ebp),%eax
  801e33:	50                   	push   %eax
  801e34:	57                   	push   %edi
  801e35:	e8 46 eb ff ff       	call   800980 <memmove>
		sys_cputs(buf, m);
  801e3a:	83 c4 08             	add    $0x8,%esp
  801e3d:	53                   	push   %ebx
  801e3e:	57                   	push   %edi
  801e3f:	e8 eb ec ff ff       	call   800b2f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e44:	01 de                	add    %ebx,%esi
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e4c:	72 cc                	jb     801e1a <devcons_write+0x19>
}
  801e4e:	89 f0                	mov    %esi,%eax
  801e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    

00801e58 <devcons_read>:
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 08             	sub    $0x8,%esp
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e67:	75 07                	jne    801e70 <devcons_read+0x18>
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    
		sys_yield();
  801e6b:	e8 5c ed ff ff       	call   800bcc <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e70:	e8 d8 ec ff ff       	call   800b4d <sys_cgetc>
  801e75:	85 c0                	test   %eax,%eax
  801e77:	74 f2                	je     801e6b <devcons_read+0x13>
	if (c < 0)
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	78 ec                	js     801e69 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e7d:	83 f8 04             	cmp    $0x4,%eax
  801e80:	74 0c                	je     801e8e <devcons_read+0x36>
	*(char*)vbuf = c;
  801e82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e85:	88 02                	mov    %al,(%edx)
	return 1;
  801e87:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8c:	eb db                	jmp    801e69 <devcons_read+0x11>
		return 0;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	eb d4                	jmp    801e69 <devcons_read+0x11>

00801e95 <cputchar>:
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ea1:	6a 01                	push   $0x1
  801ea3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea6:	50                   	push   %eax
  801ea7:	e8 83 ec ff ff       	call   800b2f <sys_cputs>
}
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <getchar>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801eb7:	6a 01                	push   $0x1
  801eb9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ebc:	50                   	push   %eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	e8 1e f2 ff ff       	call   8010e2 <read>
	if (r < 0)
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	78 08                	js     801ed3 <getchar+0x22>
	if (r < 1)
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	7e 06                	jle    801ed5 <getchar+0x24>
	return c;
  801ecf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    
		return -E_EOF;
  801ed5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801eda:	eb f7                	jmp    801ed3 <getchar+0x22>

00801edc <iscons>:
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ee2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee5:	50                   	push   %eax
  801ee6:	ff 75 08             	pushl  0x8(%ebp)
  801ee9:	e8 83 ef ff ff       	call   800e71 <fd_lookup>
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	78 11                	js     801f06 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801efe:	39 10                	cmp    %edx,(%eax)
  801f00:	0f 94 c0             	sete   %al
  801f03:	0f b6 c0             	movzbl %al,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <opencons>:
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f11:	50                   	push   %eax
  801f12:	e8 0b ef ff ff       	call   800e22 <fd_alloc>
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	78 3a                	js     801f58 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 07 04 00 00       	push   $0x407
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	6a 00                	push   $0x0
  801f2b:	e8 bb ec ff ff       	call   800beb <sys_page_alloc>
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	78 21                	js     801f58 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f40:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f4c:	83 ec 0c             	sub    $0xc,%esp
  801f4f:	50                   	push   %eax
  801f50:	e8 a6 ee ff ff       	call   800dfb <fd2num>
  801f55:	83 c4 10             	add    $0x10,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	56                   	push   %esi
  801f5e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f5f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f62:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f68:	e8 40 ec ff ff       	call   800bad <sys_getenvid>
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	ff 75 08             	pushl  0x8(%ebp)
  801f76:	56                   	push   %esi
  801f77:	50                   	push   %eax
  801f78:	68 c0 27 80 00       	push   $0x8027c0
  801f7d:	e8 d3 e1 ff ff       	call   800155 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f82:	83 c4 18             	add    $0x18,%esp
  801f85:	53                   	push   %ebx
  801f86:	ff 75 10             	pushl  0x10(%ebp)
  801f89:	e8 76 e1 ff ff       	call   800104 <vcprintf>
	cprintf("\n");
  801f8e:	c7 04 24 2c 23 80 00 	movl   $0x80232c,(%esp)
  801f95:	e8 bb e1 ff ff       	call   800155 <cprintf>
  801f9a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f9d:	cc                   	int3   
  801f9e:	eb fd                	jmp    801f9d <_panic+0x43>

00801fa0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	56                   	push   %esi
  801fa4:	53                   	push   %ebx
  801fa5:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801fae:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801fb0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fb5:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801fb8:	83 ec 0c             	sub    $0xc,%esp
  801fbb:	50                   	push   %eax
  801fbc:	e8 da ed ff ff       	call   800d9b <sys_ipc_recv>
  801fc1:	83 c4 10             	add    $0x10,%esp
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	78 2b                	js     801ff3 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fc8:	85 f6                	test   %esi,%esi
  801fca:	74 0a                	je     801fd6 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fcc:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801fd1:	8b 40 74             	mov    0x74(%eax),%eax
  801fd4:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fd6:	85 db                	test   %ebx,%ebx
  801fd8:	74 0a                	je     801fe4 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fda:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801fdf:	8b 40 78             	mov    0x78(%eax),%eax
  801fe2:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fe4:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801fe9:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5d                   	pop    %ebp
  801ff2:	c3                   	ret    
	    if (from_env_store != NULL) {
  801ff3:	85 f6                	test   %esi,%esi
  801ff5:	74 06                	je     801ffd <ipc_recv+0x5d>
	        *from_env_store = 0;
  801ff7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801ffd:	85 db                	test   %ebx,%ebx
  801fff:	74 eb                	je     801fec <ipc_recv+0x4c>
	        *perm_store = 0;
  802001:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802007:	eb e3                	jmp    801fec <ipc_recv+0x4c>

00802009 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	57                   	push   %edi
  80200d:	56                   	push   %esi
  80200e:	53                   	push   %ebx
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	8b 7d 08             	mov    0x8(%ebp),%edi
  802015:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802018:	85 f6                	test   %esi,%esi
  80201a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80201f:	0f 44 f0             	cmove  %eax,%esi
  802022:	eb 09                	jmp    80202d <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802024:	e8 a3 eb ff ff       	call   800bcc <sys_yield>
	} while(r != 0);
  802029:	85 db                	test   %ebx,%ebx
  80202b:	74 2d                	je     80205a <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80202d:	ff 75 14             	pushl  0x14(%ebp)
  802030:	56                   	push   %esi
  802031:	ff 75 0c             	pushl  0xc(%ebp)
  802034:	57                   	push   %edi
  802035:	e8 3e ed ff ff       	call   800d78 <sys_ipc_try_send>
  80203a:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	85 c0                	test   %eax,%eax
  802041:	79 e1                	jns    802024 <ipc_send+0x1b>
  802043:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802046:	74 dc                	je     802024 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802048:	50                   	push   %eax
  802049:	68 e4 27 80 00       	push   $0x8027e4
  80204e:	6a 45                	push   $0x45
  802050:	68 f1 27 80 00       	push   $0x8027f1
  802055:	e8 00 ff ff ff       	call   801f5a <_panic>
}
  80205a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80205d:	5b                   	pop    %ebx
  80205e:	5e                   	pop    %esi
  80205f:	5f                   	pop    %edi
  802060:	5d                   	pop    %ebp
  802061:	c3                   	ret    

00802062 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80206d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802070:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802076:	8b 52 50             	mov    0x50(%edx),%edx
  802079:	39 ca                	cmp    %ecx,%edx
  80207b:	74 11                	je     80208e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80207d:	83 c0 01             	add    $0x1,%eax
  802080:	3d 00 04 00 00       	cmp    $0x400,%eax
  802085:	75 e6                	jne    80206d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
  80208c:	eb 0b                	jmp    802099 <ipc_find_env+0x37>
			return envs[i].env_id;
  80208e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802091:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802096:	8b 40 48             	mov    0x48(%eax),%eax
}
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    

0080209b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020a1:	89 d0                	mov    %edx,%eax
  8020a3:	c1 e8 16             	shr    $0x16,%eax
  8020a6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020b2:	f6 c1 01             	test   $0x1,%cl
  8020b5:	74 1d                	je     8020d4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020b7:	c1 ea 0c             	shr    $0xc,%edx
  8020ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020c1:	f6 c2 01             	test   $0x1,%dl
  8020c4:	74 0e                	je     8020d4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020c6:	c1 ea 0c             	shr    $0xc,%edx
  8020c9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020d0:	ef 
  8020d1:	0f b7 c0             	movzwl %ax,%eax
}
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    
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
