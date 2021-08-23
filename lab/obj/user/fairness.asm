
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
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
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 ae 0b 00 00       	call   800bee <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 7c 	cmpl   $0xeec0007c,0x804008
  800049:	00 c0 ee 
  80004c:	75 26                	jne    800074 <umain+0x41>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 00                	push   $0x0
  800056:	6a 00                	push   $0x0
  800058:	56                   	push   %esi
  800059:	e8 de 0d 00 00       	call   800e3c <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80005e:	83 c4 0c             	add    $0xc,%esp
  800061:	ff 75 f4             	pushl  -0xc(%ebp)
  800064:	53                   	push   %ebx
  800065:	68 60 23 80 00       	push   $0x802360
  80006a:	e8 27 01 00 00       	call   800196 <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	eb dd                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800074:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 71 23 80 00       	push   $0x802371
  800083:	e8 0e 01 00 00       	call   800196 <cprintf>
  800088:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80008b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	6a 00                	push   $0x0
  800096:	50                   	push   %eax
  800097:	e8 09 0e 00 00       	call   800ea5 <ipc_send>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb ea                	jmp    80008b <umain+0x58>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 3d 0b 00 00       	call   800bee <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x2d>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	e8 5b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d8:	e8 0a 00 00 00       	call   8000e7 <exit>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ed:	e8 1b 10 00 00       	call   80110d <close_all>
	sys_env_destroy(0);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	6a 00                	push   $0x0
  8000f7:	e8 b1 0a 00 00       	call   800bad <sys_env_destroy>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	53                   	push   %ebx
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010b:	8b 13                	mov    (%ebx),%edx
  80010d:	8d 42 01             	lea    0x1(%edx),%eax
  800110:	89 03                	mov    %eax,(%ebx)
  800112:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800115:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800119:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011e:	74 09                	je     800129 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800120:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800124:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800127:	c9                   	leave  
  800128:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	68 ff 00 00 00       	push   $0xff
  800131:	8d 43 08             	lea    0x8(%ebx),%eax
  800134:	50                   	push   %eax
  800135:	e8 36 0a 00 00       	call   800b70 <sys_cputs>
		b->idx = 0;
  80013a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	eb db                	jmp    800120 <putch+0x1f>

00800145 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800155:	00 00 00 
	b.cnt = 0;
  800158:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800162:	ff 75 0c             	pushl  0xc(%ebp)
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016e:	50                   	push   %eax
  80016f:	68 01 01 80 00       	push   $0x800101
  800174:	e8 1a 01 00 00       	call   800293 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800182:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 e2 09 00 00       	call   800b70 <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	50                   	push   %eax
  8001a0:	ff 75 08             	pushl  0x8(%ebp)
  8001a3:	e8 9d ff ff ff       	call   800145 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	57                   	push   %edi
  8001ae:	56                   	push   %esi
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 1c             	sub    $0x1c,%esp
  8001b3:	89 c7                	mov    %eax,%edi
  8001b5:	89 d6                	mov    %edx,%esi
  8001b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ce:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d1:	39 d3                	cmp    %edx,%ebx
  8001d3:	72 05                	jb     8001da <printnum+0x30>
  8001d5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d8:	77 7a                	ja     800254 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 18             	pushl  0x18(%ebp)
  8001e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e6:	53                   	push   %ebx
  8001e7:	ff 75 10             	pushl  0x10(%ebp)
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f9:	e8 22 1f 00 00       	call   802120 <__udivdi3>
  8001fe:	83 c4 18             	add    $0x18,%esp
  800201:	52                   	push   %edx
  800202:	50                   	push   %eax
  800203:	89 f2                	mov    %esi,%edx
  800205:	89 f8                	mov    %edi,%eax
  800207:	e8 9e ff ff ff       	call   8001aa <printnum>
  80020c:	83 c4 20             	add    $0x20,%esp
  80020f:	eb 13                	jmp    800224 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	56                   	push   %esi
  800215:	ff 75 18             	pushl  0x18(%ebp)
  800218:	ff d7                	call   *%edi
  80021a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80021d:	83 eb 01             	sub    $0x1,%ebx
  800220:	85 db                	test   %ebx,%ebx
  800222:	7f ed                	jg     800211 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	56                   	push   %esi
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022e:	ff 75 e0             	pushl  -0x20(%ebp)
  800231:	ff 75 dc             	pushl  -0x24(%ebp)
  800234:	ff 75 d8             	pushl  -0x28(%ebp)
  800237:	e8 04 20 00 00       	call   802240 <__umoddi3>
  80023c:	83 c4 14             	add    $0x14,%esp
  80023f:	0f be 80 92 23 80 00 	movsbl 0x802392(%eax),%eax
  800246:	50                   	push   %eax
  800247:	ff d7                	call   *%edi
}
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024f:	5b                   	pop    %ebx
  800250:	5e                   	pop    %esi
  800251:	5f                   	pop    %edi
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    
  800254:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800257:	eb c4                	jmp    80021d <printnum+0x73>

00800259 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80025f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800263:	8b 10                	mov    (%eax),%edx
  800265:	3b 50 04             	cmp    0x4(%eax),%edx
  800268:	73 0a                	jae    800274 <sprintputch+0x1b>
		*b->buf++ = ch;
  80026a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80026d:	89 08                	mov    %ecx,(%eax)
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	88 02                	mov    %al,(%edx)
}
  800274:	5d                   	pop    %ebp
  800275:	c3                   	ret    

00800276 <printfmt>:
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80027c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027f:	50                   	push   %eax
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 05 00 00 00       	call   800293 <vprintfmt>
}
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <vprintfmt>:
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 2c             	sub    $0x2c,%esp
  80029c:	8b 75 08             	mov    0x8(%ebp),%esi
  80029f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a5:	e9 21 04 00 00       	jmp    8006cb <vprintfmt+0x438>
		padc = ' ';
  8002aa:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002b5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c8:	8d 47 01             	lea    0x1(%edi),%eax
  8002cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ce:	0f b6 17             	movzbl (%edi),%edx
  8002d1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d4:	3c 55                	cmp    $0x55,%al
  8002d6:	0f 87 90 04 00 00    	ja     80076c <vprintfmt+0x4d9>
  8002dc:	0f b6 c0             	movzbl %al,%eax
  8002df:	ff 24 85 e0 24 80 00 	jmp    *0x8024e0(,%eax,4)
  8002e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e9:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ed:	eb d9                	jmp    8002c8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002f6:	eb d0                	jmp    8002c8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f8:	0f b6 d2             	movzbl %dl,%edx
  8002fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800303:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800306:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800309:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800310:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800313:	83 f9 09             	cmp    $0x9,%ecx
  800316:	77 55                	ja     80036d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800318:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80031b:	eb e9                	jmp    800306 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80031d:	8b 45 14             	mov    0x14(%ebp),%eax
  800320:	8b 00                	mov    (%eax),%eax
  800322:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800325:	8b 45 14             	mov    0x14(%ebp),%eax
  800328:	8d 40 04             	lea    0x4(%eax),%eax
  80032b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800331:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800335:	79 91                	jns    8002c8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800337:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80033a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800344:	eb 82                	jmp    8002c8 <vprintfmt+0x35>
  800346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	ba 00 00 00 00       	mov    $0x0,%edx
  800350:	0f 49 d0             	cmovns %eax,%edx
  800353:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800359:	e9 6a ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800361:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800368:	e9 5b ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
  80036d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800370:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800373:	eb bc                	jmp    800331 <vprintfmt+0x9e>
			lflag++;
  800375:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800378:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037b:	e9 48 ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	8d 78 04             	lea    0x4(%eax),%edi
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	53                   	push   %ebx
  80038a:	ff 30                	pushl  (%eax)
  80038c:	ff d6                	call   *%esi
			break;
  80038e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800391:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800394:	e9 2f 03 00 00       	jmp    8006c8 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800399:	8b 45 14             	mov    0x14(%ebp),%eax
  80039c:	8d 78 04             	lea    0x4(%eax),%edi
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	99                   	cltd   
  8003a2:	31 d0                	xor    %edx,%eax
  8003a4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a6:	83 f8 0f             	cmp    $0xf,%eax
  8003a9:	7f 23                	jg     8003ce <vprintfmt+0x13b>
  8003ab:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  8003b2:	85 d2                	test   %edx,%edx
  8003b4:	74 18                	je     8003ce <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003b6:	52                   	push   %edx
  8003b7:	68 b3 27 80 00       	push   $0x8027b3
  8003bc:	53                   	push   %ebx
  8003bd:	56                   	push   %esi
  8003be:	e8 b3 fe ff ff       	call   800276 <printfmt>
  8003c3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c9:	e9 fa 02 00 00       	jmp    8006c8 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8003ce:	50                   	push   %eax
  8003cf:	68 aa 23 80 00       	push   $0x8023aa
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 9b fe ff ff       	call   800276 <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e1:	e9 e2 02 00 00       	jmp    8006c8 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	83 c0 04             	add    $0x4,%eax
  8003ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003f4:	85 ff                	test   %edi,%edi
  8003f6:	b8 a3 23 80 00       	mov    $0x8023a3,%eax
  8003fb:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800402:	0f 8e bd 00 00 00    	jle    8004c5 <vprintfmt+0x232>
  800408:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80040c:	75 0e                	jne    80041c <vprintfmt+0x189>
  80040e:	89 75 08             	mov    %esi,0x8(%ebp)
  800411:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800414:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800417:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80041a:	eb 6d                	jmp    800489 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 d0             	pushl  -0x30(%ebp)
  800422:	57                   	push   %edi
  800423:	e8 ec 03 00 00       	call   800814 <strnlen>
  800428:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042b:	29 c1                	sub    %eax,%ecx
  80042d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800433:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800437:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80043d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043f:	eb 0f                	jmp    800450 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	53                   	push   %ebx
  800445:	ff 75 e0             	pushl  -0x20(%ebp)
  800448:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044a:	83 ef 01             	sub    $0x1,%edi
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 ff                	test   %edi,%edi
  800452:	7f ed                	jg     800441 <vprintfmt+0x1ae>
  800454:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800457:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80045a:	85 c9                	test   %ecx,%ecx
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	0f 49 c1             	cmovns %ecx,%eax
  800464:	29 c1                	sub    %eax,%ecx
  800466:	89 75 08             	mov    %esi,0x8(%ebp)
  800469:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80046f:	89 cb                	mov    %ecx,%ebx
  800471:	eb 16                	jmp    800489 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800473:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800477:	75 31                	jne    8004aa <vprintfmt+0x217>
					putch(ch, putdat);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 0c             	pushl  0xc(%ebp)
  80047f:	50                   	push   %eax
  800480:	ff 55 08             	call   *0x8(%ebp)
  800483:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800486:	83 eb 01             	sub    $0x1,%ebx
  800489:	83 c7 01             	add    $0x1,%edi
  80048c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800490:	0f be c2             	movsbl %dl,%eax
  800493:	85 c0                	test   %eax,%eax
  800495:	74 59                	je     8004f0 <vprintfmt+0x25d>
  800497:	85 f6                	test   %esi,%esi
  800499:	78 d8                	js     800473 <vprintfmt+0x1e0>
  80049b:	83 ee 01             	sub    $0x1,%esi
  80049e:	79 d3                	jns    800473 <vprintfmt+0x1e0>
  8004a0:	89 df                	mov    %ebx,%edi
  8004a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a8:	eb 37                	jmp    8004e1 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004aa:	0f be d2             	movsbl %dl,%edx
  8004ad:	83 ea 20             	sub    $0x20,%edx
  8004b0:	83 fa 5e             	cmp    $0x5e,%edx
  8004b3:	76 c4                	jbe    800479 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	6a 3f                	push   $0x3f
  8004bd:	ff 55 08             	call   *0x8(%ebp)
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	eb c1                	jmp    800486 <vprintfmt+0x1f3>
  8004c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004cb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004d1:	eb b6                	jmp    800489 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	6a 20                	push   $0x20
  8004d9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004db:	83 ef 01             	sub    $0x1,%edi
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	85 ff                	test   %edi,%edi
  8004e3:	7f ee                	jg     8004d3 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004eb:	e9 d8 01 00 00       	jmp    8006c8 <vprintfmt+0x435>
  8004f0:	89 df                	mov    %ebx,%edi
  8004f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f8:	eb e7                	jmp    8004e1 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004fa:	83 f9 01             	cmp    $0x1,%ecx
  8004fd:	7e 45                	jle    800544 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 50 04             	mov    0x4(%eax),%edx
  800505:	8b 00                	mov    (%eax),%eax
  800507:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 40 08             	lea    0x8(%eax),%eax
  800513:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800516:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80051a:	79 62                	jns    80057e <vprintfmt+0x2eb>
				putch('-', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	6a 2d                	push   $0x2d
  800522:	ff d6                	call   *%esi
				num = -(long long) num;
  800524:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800527:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80052a:	f7 d8                	neg    %eax
  80052c:	83 d2 00             	adc    $0x0,%edx
  80052f:	f7 da                	neg    %edx
  800531:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800534:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800537:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80053a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80053f:	e9 66 01 00 00       	jmp    8006aa <vprintfmt+0x417>
	else if (lflag)
  800544:	85 c9                	test   %ecx,%ecx
  800546:	75 1b                	jne    800563 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800550:	89 c1                	mov    %eax,%ecx
  800552:	c1 f9 1f             	sar    $0x1f,%ecx
  800555:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8d 40 04             	lea    0x4(%eax),%eax
  80055e:	89 45 14             	mov    %eax,0x14(%ebp)
  800561:	eb b3                	jmp    800516 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056b:	89 c1                	mov    %eax,%ecx
  80056d:	c1 f9 1f             	sar    $0x1f,%ecx
  800570:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8d 40 04             	lea    0x4(%eax),%eax
  800579:	89 45 14             	mov    %eax,0x14(%ebp)
  80057c:	eb 98                	jmp    800516 <vprintfmt+0x283>
			base = 10;
  80057e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800583:	e9 22 01 00 00       	jmp    8006aa <vprintfmt+0x417>
	if (lflag >= 2)
  800588:	83 f9 01             	cmp    $0x1,%ecx
  80058b:	7e 21                	jle    8005ae <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 50 04             	mov    0x4(%eax),%edx
  800593:	8b 00                	mov    (%eax),%eax
  800595:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800598:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8d 40 08             	lea    0x8(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005a9:	e9 fc 00 00 00       	jmp    8006aa <vprintfmt+0x417>
	else if (lflag)
  8005ae:	85 c9                	test   %ecx,%ecx
  8005b0:	75 23                	jne    8005d5 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cb:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005d0:	e9 d5 00 00 00       	jmp    8006aa <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	ba 00 00 00 00       	mov    $0x0,%edx
  8005df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005f3:	e9 b2 00 00 00       	jmp    8006aa <vprintfmt+0x417>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 42                	jle    80063f <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 50 04             	mov    0x4(%eax),%edx
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800614:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800619:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061d:	0f 89 87 00 00 00    	jns    8006aa <vprintfmt+0x417>
				putch('-', putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	53                   	push   %ebx
  800627:	6a 2d                	push   $0x2d
  800629:	ff d6                	call   *%esi
				num = -(long long) num;
  80062b:	f7 5d d8             	negl   -0x28(%ebp)
  80062e:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800632:	f7 5d dc             	negl   -0x24(%ebp)
  800635:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800638:	ba 08 00 00 00       	mov    $0x8,%edx
  80063d:	eb 6b                	jmp    8006aa <vprintfmt+0x417>
	else if (lflag)
  80063f:	85 c9                	test   %ecx,%ecx
  800641:	75 1b                	jne    80065e <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	ba 00 00 00 00       	mov    $0x0,%edx
  80064d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800650:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8d 40 04             	lea    0x4(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	eb b6                	jmp    800614 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	ba 00 00 00 00       	mov    $0x0,%edx
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 40 04             	lea    0x4(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
  800677:	eb 9b                	jmp    800614 <vprintfmt+0x381>
			putch('0', putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	53                   	push   %ebx
  80067d:	6a 30                	push   $0x30
  80067f:	ff d6                	call   *%esi
			putch('x', putdat);
  800681:	83 c4 08             	add    $0x8,%esp
  800684:	53                   	push   %ebx
  800685:	6a 78                	push   $0x78
  800687:	ff d6                	call   *%esi
			num = (unsigned long long)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	ba 00 00 00 00       	mov    $0x0,%edx
  800693:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800696:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800699:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a5:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b5:	52                   	push   %edx
  8006b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8006b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8006bc:	89 da                	mov    %ebx,%edx
  8006be:	89 f0                	mov    %esi,%eax
  8006c0:	e8 e5 fa ff ff       	call   8001aa <printnum>
			break;
  8006c5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cb:	83 c7 01             	add    $0x1,%edi
  8006ce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d2:	83 f8 25             	cmp    $0x25,%eax
  8006d5:	0f 84 cf fb ff ff    	je     8002aa <vprintfmt+0x17>
			if (ch == '\0')
  8006db:	85 c0                	test   %eax,%eax
  8006dd:	0f 84 a9 00 00 00    	je     80078c <vprintfmt+0x4f9>
			putch(ch, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	50                   	push   %eax
  8006e8:	ff d6                	call   *%esi
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	eb dc                	jmp    8006cb <vprintfmt+0x438>
	if (lflag >= 2)
  8006ef:	83 f9 01             	cmp    $0x1,%ecx
  8006f2:	7e 1e                	jle    800712 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 50 04             	mov    0x4(%eax),%edx
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 08             	lea    0x8(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070b:	ba 10 00 00 00       	mov    $0x10,%edx
  800710:	eb 98                	jmp    8006aa <vprintfmt+0x417>
	else if (lflag)
  800712:	85 c9                	test   %ecx,%ecx
  800714:	75 23                	jne    800739 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800723:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8d 40 04             	lea    0x4(%eax),%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072f:	ba 10 00 00 00       	mov    $0x10,%edx
  800734:	e9 71 ff ff ff       	jmp    8006aa <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	ba 00 00 00 00       	mov    $0x0,%edx
  800743:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800746:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 40 04             	lea    0x4(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800752:	ba 10 00 00 00       	mov    $0x10,%edx
  800757:	e9 4e ff ff ff       	jmp    8006aa <vprintfmt+0x417>
			putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	53                   	push   %ebx
  800760:	6a 25                	push   $0x25
  800762:	ff d6                	call   *%esi
			break;
  800764:	83 c4 10             	add    $0x10,%esp
  800767:	e9 5c ff ff ff       	jmp    8006c8 <vprintfmt+0x435>
			putch('%', putdat);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	53                   	push   %ebx
  800770:	6a 25                	push   $0x25
  800772:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	89 f8                	mov    %edi,%eax
  800779:	eb 03                	jmp    80077e <vprintfmt+0x4eb>
  80077b:	83 e8 01             	sub    $0x1,%eax
  80077e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800782:	75 f7                	jne    80077b <vprintfmt+0x4e8>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800787:	e9 3c ff ff ff       	jmp    8006c8 <vprintfmt+0x435>
}
  80078c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078f:	5b                   	pop    %ebx
  800790:	5e                   	pop    %esi
  800791:	5f                   	pop    %edi
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 18             	sub    $0x18,%esp
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	74 26                	je     8007db <vsnprintf+0x47>
  8007b5:	85 d2                	test   %edx,%edx
  8007b7:	7e 22                	jle    8007db <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b9:	ff 75 14             	pushl  0x14(%ebp)
  8007bc:	ff 75 10             	pushl  0x10(%ebp)
  8007bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	68 59 02 80 00       	push   $0x800259
  8007c8:	e8 c6 fa ff ff       	call   800293 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d6:	83 c4 10             	add    $0x10,%esp
}
  8007d9:	c9                   	leave  
  8007da:	c3                   	ret    
		return -E_INVAL;
  8007db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e0:	eb f7                	jmp    8007d9 <vsnprintf+0x45>

008007e2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007eb:	50                   	push   %eax
  8007ec:	ff 75 10             	pushl  0x10(%ebp)
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	e8 9a ff ff ff       	call   800794 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800802:	b8 00 00 00 00       	mov    $0x0,%eax
  800807:	eb 03                	jmp    80080c <strlen+0x10>
		n++;
  800809:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80080c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800810:	75 f7                	jne    800809 <strlen+0xd>
	return n;
}
  800812:	5d                   	pop    %ebp
  800813:	c3                   	ret    

00800814 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081d:	b8 00 00 00 00       	mov    $0x0,%eax
  800822:	eb 03                	jmp    800827 <strnlen+0x13>
		n++;
  800824:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800827:	39 d0                	cmp    %edx,%eax
  800829:	74 06                	je     800831 <strnlen+0x1d>
  80082b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80082f:	75 f3                	jne    800824 <strnlen+0x10>
	return n;
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80083d:	89 c2                	mov    %eax,%edx
  80083f:	83 c1 01             	add    $0x1,%ecx
  800842:	83 c2 01             	add    $0x1,%edx
  800845:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800849:	88 5a ff             	mov    %bl,-0x1(%edx)
  80084c:	84 db                	test   %bl,%bl
  80084e:	75 ef                	jne    80083f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800850:	5b                   	pop    %ebx
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	53                   	push   %ebx
  800857:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085a:	53                   	push   %ebx
  80085b:	e8 9c ff ff ff       	call   8007fc <strlen>
  800860:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	01 d8                	add    %ebx,%eax
  800868:	50                   	push   %eax
  800869:	e8 c5 ff ff ff       	call   800833 <strcpy>
	return dst;
}
  80086e:	89 d8                	mov    %ebx,%eax
  800870:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800873:	c9                   	leave  
  800874:	c3                   	ret    

00800875 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	56                   	push   %esi
  800879:	53                   	push   %ebx
  80087a:	8b 75 08             	mov    0x8(%ebp),%esi
  80087d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800880:	89 f3                	mov    %esi,%ebx
  800882:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800885:	89 f2                	mov    %esi,%edx
  800887:	eb 0f                	jmp    800898 <strncpy+0x23>
		*dst++ = *src;
  800889:	83 c2 01             	add    $0x1,%edx
  80088c:	0f b6 01             	movzbl (%ecx),%eax
  80088f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800892:	80 39 01             	cmpb   $0x1,(%ecx)
  800895:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800898:	39 da                	cmp    %ebx,%edx
  80089a:	75 ed                	jne    800889 <strncpy+0x14>
	}
	return ret;
}
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	5b                   	pop    %ebx
  80089f:	5e                   	pop    %esi
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	56                   	push   %esi
  8008a6:	53                   	push   %ebx
  8008a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008b0:	89 f0                	mov    %esi,%eax
  8008b2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b6:	85 c9                	test   %ecx,%ecx
  8008b8:	75 0b                	jne    8008c5 <strlcpy+0x23>
  8008ba:	eb 17                	jmp    8008d3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	83 c0 01             	add    $0x1,%eax
  8008c2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008c5:	39 d8                	cmp    %ebx,%eax
  8008c7:	74 07                	je     8008d0 <strlcpy+0x2e>
  8008c9:	0f b6 0a             	movzbl (%edx),%ecx
  8008cc:	84 c9                	test   %cl,%cl
  8008ce:	75 ec                	jne    8008bc <strlcpy+0x1a>
		*dst = '\0';
  8008d0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008d3:	29 f0                	sub    %esi,%eax
}
  8008d5:	5b                   	pop    %ebx
  8008d6:	5e                   	pop    %esi
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e2:	eb 06                	jmp    8008ea <strcmp+0x11>
		p++, q++;
  8008e4:	83 c1 01             	add    $0x1,%ecx
  8008e7:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008ea:	0f b6 01             	movzbl (%ecx),%eax
  8008ed:	84 c0                	test   %al,%al
  8008ef:	74 04                	je     8008f5 <strcmp+0x1c>
  8008f1:	3a 02                	cmp    (%edx),%al
  8008f3:	74 ef                	je     8008e4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f5:	0f b6 c0             	movzbl %al,%eax
  8008f8:	0f b6 12             	movzbl (%edx),%edx
  8008fb:	29 d0                	sub    %edx,%eax
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	53                   	push   %ebx
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
  800909:	89 c3                	mov    %eax,%ebx
  80090b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80090e:	eb 06                	jmp    800916 <strncmp+0x17>
		n--, p++, q++;
  800910:	83 c0 01             	add    $0x1,%eax
  800913:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800916:	39 d8                	cmp    %ebx,%eax
  800918:	74 16                	je     800930 <strncmp+0x31>
  80091a:	0f b6 08             	movzbl (%eax),%ecx
  80091d:	84 c9                	test   %cl,%cl
  80091f:	74 04                	je     800925 <strncmp+0x26>
  800921:	3a 0a                	cmp    (%edx),%cl
  800923:	74 eb                	je     800910 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800925:	0f b6 00             	movzbl (%eax),%eax
  800928:	0f b6 12             	movzbl (%edx),%edx
  80092b:	29 d0                	sub    %edx,%eax
}
  80092d:	5b                   	pop    %ebx
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    
		return 0;
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
  800935:	eb f6                	jmp    80092d <strncmp+0x2e>

00800937 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800941:	0f b6 10             	movzbl (%eax),%edx
  800944:	84 d2                	test   %dl,%dl
  800946:	74 09                	je     800951 <strchr+0x1a>
		if (*s == c)
  800948:	38 ca                	cmp    %cl,%dl
  80094a:	74 0a                	je     800956 <strchr+0x1f>
	for (; *s; s++)
  80094c:	83 c0 01             	add    $0x1,%eax
  80094f:	eb f0                	jmp    800941 <strchr+0xa>
			return (char *) s;
	return 0;
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800962:	eb 03                	jmp    800967 <strfind+0xf>
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80096a:	38 ca                	cmp    %cl,%dl
  80096c:	74 04                	je     800972 <strfind+0x1a>
  80096e:	84 d2                	test   %dl,%dl
  800970:	75 f2                	jne    800964 <strfind+0xc>
			break;
	return (char *) s;
}
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	57                   	push   %edi
  800978:	56                   	push   %esi
  800979:	53                   	push   %ebx
  80097a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80097d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800980:	85 c9                	test   %ecx,%ecx
  800982:	74 13                	je     800997 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800984:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80098a:	75 05                	jne    800991 <memset+0x1d>
  80098c:	f6 c1 03             	test   $0x3,%cl
  80098f:	74 0d                	je     80099e <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	fc                   	cld    
  800995:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800997:	89 f8                	mov    %edi,%eax
  800999:	5b                   	pop    %ebx
  80099a:	5e                   	pop    %esi
  80099b:	5f                   	pop    %edi
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    
		c &= 0xFF;
  80099e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a2:	89 d3                	mov    %edx,%ebx
  8009a4:	c1 e3 08             	shl    $0x8,%ebx
  8009a7:	89 d0                	mov    %edx,%eax
  8009a9:	c1 e0 18             	shl    $0x18,%eax
  8009ac:	89 d6                	mov    %edx,%esi
  8009ae:	c1 e6 10             	shl    $0x10,%esi
  8009b1:	09 f0                	or     %esi,%eax
  8009b3:	09 c2                	or     %eax,%edx
  8009b5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009b7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ba:	89 d0                	mov    %edx,%eax
  8009bc:	fc                   	cld    
  8009bd:	f3 ab                	rep stos %eax,%es:(%edi)
  8009bf:	eb d6                	jmp    800997 <memset+0x23>

008009c1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	57                   	push   %edi
  8009c5:	56                   	push   %esi
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009cf:	39 c6                	cmp    %eax,%esi
  8009d1:	73 35                	jae    800a08 <memmove+0x47>
  8009d3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d6:	39 c2                	cmp    %eax,%edx
  8009d8:	76 2e                	jbe    800a08 <memmove+0x47>
		s += n;
		d += n;
  8009da:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009dd:	89 d6                	mov    %edx,%esi
  8009df:	09 fe                	or     %edi,%esi
  8009e1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e7:	74 0c                	je     8009f5 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e9:	83 ef 01             	sub    $0x1,%edi
  8009ec:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ef:	fd                   	std    
  8009f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f2:	fc                   	cld    
  8009f3:	eb 21                	jmp    800a16 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f5:	f6 c1 03             	test   $0x3,%cl
  8009f8:	75 ef                	jne    8009e9 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009fa:	83 ef 04             	sub    $0x4,%edi
  8009fd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a03:	fd                   	std    
  800a04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a06:	eb ea                	jmp    8009f2 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a08:	89 f2                	mov    %esi,%edx
  800a0a:	09 c2                	or     %eax,%edx
  800a0c:	f6 c2 03             	test   $0x3,%dl
  800a0f:	74 09                	je     800a1a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a11:	89 c7                	mov    %eax,%edi
  800a13:	fc                   	cld    
  800a14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a16:	5e                   	pop    %esi
  800a17:	5f                   	pop    %edi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1a:	f6 c1 03             	test   $0x3,%cl
  800a1d:	75 f2                	jne    800a11 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a22:	89 c7                	mov    %eax,%edi
  800a24:	fc                   	cld    
  800a25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a27:	eb ed                	jmp    800a16 <memmove+0x55>

00800a29 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a2c:	ff 75 10             	pushl  0x10(%ebp)
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	ff 75 08             	pushl  0x8(%ebp)
  800a35:	e8 87 ff ff ff       	call   8009c1 <memmove>
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	56                   	push   %esi
  800a40:	53                   	push   %ebx
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a47:	89 c6                	mov    %eax,%esi
  800a49:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a4c:	39 f0                	cmp    %esi,%eax
  800a4e:	74 1c                	je     800a6c <memcmp+0x30>
		if (*s1 != *s2)
  800a50:	0f b6 08             	movzbl (%eax),%ecx
  800a53:	0f b6 1a             	movzbl (%edx),%ebx
  800a56:	38 d9                	cmp    %bl,%cl
  800a58:	75 08                	jne    800a62 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	83 c2 01             	add    $0x1,%edx
  800a60:	eb ea                	jmp    800a4c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a62:	0f b6 c1             	movzbl %cl,%eax
  800a65:	0f b6 db             	movzbl %bl,%ebx
  800a68:	29 d8                	sub    %ebx,%eax
  800a6a:	eb 05                	jmp    800a71 <memcmp+0x35>
	}

	return 0;
  800a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a71:	5b                   	pop    %ebx
  800a72:	5e                   	pop    %esi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7e:	89 c2                	mov    %eax,%edx
  800a80:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a83:	39 d0                	cmp    %edx,%eax
  800a85:	73 09                	jae    800a90 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a87:	38 08                	cmp    %cl,(%eax)
  800a89:	74 05                	je     800a90 <memfind+0x1b>
	for (; s < ends; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	eb f3                	jmp    800a83 <memfind+0xe>
			break;
	return (void *) s;
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	57                   	push   %edi
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9e:	eb 03                	jmp    800aa3 <strtol+0x11>
		s++;
  800aa0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aa3:	0f b6 01             	movzbl (%ecx),%eax
  800aa6:	3c 20                	cmp    $0x20,%al
  800aa8:	74 f6                	je     800aa0 <strtol+0xe>
  800aaa:	3c 09                	cmp    $0x9,%al
  800aac:	74 f2                	je     800aa0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aae:	3c 2b                	cmp    $0x2b,%al
  800ab0:	74 2e                	je     800ae0 <strtol+0x4e>
	int neg = 0;
  800ab2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ab7:	3c 2d                	cmp    $0x2d,%al
  800ab9:	74 2f                	je     800aea <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac1:	75 05                	jne    800ac8 <strtol+0x36>
  800ac3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac6:	74 2c                	je     800af4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ac8:	85 db                	test   %ebx,%ebx
  800aca:	75 0a                	jne    800ad6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800acc:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ad1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ad4:	74 28                	je     800afe <strtol+0x6c>
		base = 10;
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  800adb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ade:	eb 50                	jmp    800b30 <strtol+0x9e>
		s++;
  800ae0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae8:	eb d1                	jmp    800abb <strtol+0x29>
		s++, neg = 1;
  800aea:	83 c1 01             	add    $0x1,%ecx
  800aed:	bf 01 00 00 00       	mov    $0x1,%edi
  800af2:	eb c7                	jmp    800abb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af8:	74 0e                	je     800b08 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	75 d8                	jne    800ad6 <strtol+0x44>
		s++, base = 8;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b06:	eb ce                	jmp    800ad6 <strtol+0x44>
		s += 2, base = 16;
  800b08:	83 c1 02             	add    $0x2,%ecx
  800b0b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b10:	eb c4                	jmp    800ad6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b12:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b15:	89 f3                	mov    %esi,%ebx
  800b17:	80 fb 19             	cmp    $0x19,%bl
  800b1a:	77 29                	ja     800b45 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b1c:	0f be d2             	movsbl %dl,%edx
  800b1f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b22:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b25:	7d 30                	jge    800b57 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b27:	83 c1 01             	add    $0x1,%ecx
  800b2a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b2e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b30:	0f b6 11             	movzbl (%ecx),%edx
  800b33:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b36:	89 f3                	mov    %esi,%ebx
  800b38:	80 fb 09             	cmp    $0x9,%bl
  800b3b:	77 d5                	ja     800b12 <strtol+0x80>
			dig = *s - '0';
  800b3d:	0f be d2             	movsbl %dl,%edx
  800b40:	83 ea 30             	sub    $0x30,%edx
  800b43:	eb dd                	jmp    800b22 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b45:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b48:	89 f3                	mov    %esi,%ebx
  800b4a:	80 fb 19             	cmp    $0x19,%bl
  800b4d:	77 08                	ja     800b57 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b4f:	0f be d2             	movsbl %dl,%edx
  800b52:	83 ea 37             	sub    $0x37,%edx
  800b55:	eb cb                	jmp    800b22 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	74 05                	je     800b62 <strtol+0xd0>
		*endptr = (char *) s;
  800b5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b60:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b62:	89 c2                	mov    %eax,%edx
  800b64:	f7 da                	neg    %edx
  800b66:	85 ff                	test   %edi,%edi
  800b68:	0f 45 c2             	cmovne %edx,%eax
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b81:	89 c3                	mov    %eax,%ebx
  800b83:	89 c7                	mov    %eax,%edi
  800b85:	89 c6                	mov    %eax,%esi
  800b87:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b89:	5b                   	pop    %ebx
  800b8a:	5e                   	pop    %esi
  800b8b:	5f                   	pop    %edi
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <sys_cgetc>:

int
sys_cgetc(void)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
  800b99:	b8 01 00 00 00       	mov    $0x1,%eax
  800b9e:	89 d1                	mov    %edx,%ecx
  800ba0:	89 d3                	mov    %edx,%ebx
  800ba2:	89 d7                	mov    %edx,%edi
  800ba4:	89 d6                	mov    %edx,%esi
  800ba6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
  800bb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbe:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc3:	89 cb                	mov    %ecx,%ebx
  800bc5:	89 cf                	mov    %ecx,%edi
  800bc7:	89 ce                	mov    %ecx,%esi
  800bc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bcb:	85 c0                	test   %eax,%eax
  800bcd:	7f 08                	jg     800bd7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5f                   	pop    %edi
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd7:	83 ec 0c             	sub    $0xc,%esp
  800bda:	50                   	push   %eax
  800bdb:	6a 03                	push   $0x3
  800bdd:	68 9f 26 80 00       	push   $0x80269f
  800be2:	6a 23                	push   $0x23
  800be4:	68 bc 26 80 00       	push   $0x8026bc
  800be9:	e8 a8 14 00 00       	call   802096 <_panic>

00800bee <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	57                   	push   %edi
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf9:	b8 02 00 00 00       	mov    $0x2,%eax
  800bfe:	89 d1                	mov    %edx,%ecx
  800c00:	89 d3                	mov    %edx,%ebx
  800c02:	89 d7                	mov    %edx,%edi
  800c04:	89 d6                	mov    %edx,%esi
  800c06:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <sys_yield>:

void
sys_yield(void)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c13:	ba 00 00 00 00       	mov    $0x0,%edx
  800c18:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c1d:	89 d1                	mov    %edx,%ecx
  800c1f:	89 d3                	mov    %edx,%ebx
  800c21:	89 d7                	mov    %edx,%edi
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	be 00 00 00 00       	mov    $0x0,%esi
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c40:	b8 04 00 00 00       	mov    $0x4,%eax
  800c45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c48:	89 f7                	mov    %esi,%edi
  800c4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4c:	85 c0                	test   %eax,%eax
  800c4e:	7f 08                	jg     800c58 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c58:	83 ec 0c             	sub    $0xc,%esp
  800c5b:	50                   	push   %eax
  800c5c:	6a 04                	push   $0x4
  800c5e:	68 9f 26 80 00       	push   $0x80269f
  800c63:	6a 23                	push   $0x23
  800c65:	68 bc 26 80 00       	push   $0x8026bc
  800c6a:	e8 27 14 00 00       	call   802096 <_panic>

00800c6f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
  800c75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7e:	b8 05 00 00 00       	mov    $0x5,%eax
  800c83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c89:	8b 75 18             	mov    0x18(%ebp),%esi
  800c8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	7f 08                	jg     800c9a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9a:	83 ec 0c             	sub    $0xc,%esp
  800c9d:	50                   	push   %eax
  800c9e:	6a 05                	push   $0x5
  800ca0:	68 9f 26 80 00       	push   $0x80269f
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 bc 26 80 00       	push   $0x8026bc
  800cac:	e8 e5 13 00 00       	call   802096 <_panic>

00800cb1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cca:	89 df                	mov    %ebx,%edi
  800ccc:	89 de                	mov    %ebx,%esi
  800cce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	7f 08                	jg     800cdc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5f                   	pop    %edi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdc:	83 ec 0c             	sub    $0xc,%esp
  800cdf:	50                   	push   %eax
  800ce0:	6a 06                	push   $0x6
  800ce2:	68 9f 26 80 00       	push   $0x80269f
  800ce7:	6a 23                	push   $0x23
  800ce9:	68 bc 26 80 00       	push   $0x8026bc
  800cee:	e8 a3 13 00 00       	call   802096 <_panic>

00800cf3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d07:	b8 08 00 00 00       	mov    $0x8,%eax
  800d0c:	89 df                	mov    %ebx,%edi
  800d0e:	89 de                	mov    %ebx,%esi
  800d10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d12:	85 c0                	test   %eax,%eax
  800d14:	7f 08                	jg     800d1e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1e:	83 ec 0c             	sub    $0xc,%esp
  800d21:	50                   	push   %eax
  800d22:	6a 08                	push   $0x8
  800d24:	68 9f 26 80 00       	push   $0x80269f
  800d29:	6a 23                	push   $0x23
  800d2b:	68 bc 26 80 00       	push   $0x8026bc
  800d30:	e8 61 13 00 00       	call   802096 <_panic>

00800d35 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d49:	b8 09 00 00 00       	mov    $0x9,%eax
  800d4e:	89 df                	mov    %ebx,%edi
  800d50:	89 de                	mov    %ebx,%esi
  800d52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	50                   	push   %eax
  800d64:	6a 09                	push   $0x9
  800d66:	68 9f 26 80 00       	push   $0x80269f
  800d6b:	6a 23                	push   $0x23
  800d6d:	68 bc 26 80 00       	push   $0x8026bc
  800d72:	e8 1f 13 00 00       	call   802096 <_panic>

00800d77 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d85:	8b 55 08             	mov    0x8(%ebp),%edx
  800d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d90:	89 df                	mov    %ebx,%edi
  800d92:	89 de                	mov    %ebx,%esi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 0a                	push   $0xa
  800da8:	68 9f 26 80 00       	push   $0x80269f
  800dad:	6a 23                	push   $0x23
  800daf:	68 bc 26 80 00       	push   $0x8026bc
  800db4:	e8 dd 12 00 00       	call   802096 <_panic>

00800db9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dca:	be 00 00 00 00       	mov    $0x0,%esi
  800dcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df2:	89 cb                	mov    %ecx,%ebx
  800df4:	89 cf                	mov    %ecx,%edi
  800df6:	89 ce                	mov    %ecx,%esi
  800df8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	7f 08                	jg     800e06 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	83 ec 0c             	sub    $0xc,%esp
  800e09:	50                   	push   %eax
  800e0a:	6a 0d                	push   $0xd
  800e0c:	68 9f 26 80 00       	push   $0x80269f
  800e11:	6a 23                	push   $0x23
  800e13:	68 bc 26 80 00       	push   $0x8026bc
  800e18:	e8 79 12 00 00       	call   802096 <_panic>

00800e1d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	57                   	push   %edi
  800e21:	56                   	push   %esi
  800e22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e23:	ba 00 00 00 00       	mov    $0x0,%edx
  800e28:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2d:	89 d1                	mov    %edx,%ecx
  800e2f:	89 d3                	mov    %edx,%ebx
  800e31:	89 d7                	mov    %edx,%edi
  800e33:	89 d6                	mov    %edx,%esi
  800e35:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	8b 75 08             	mov    0x8(%ebp),%esi
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  800e4a:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  800e4c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800e51:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	50                   	push   %eax
  800e58:	e8 7f ff ff ff       	call   800ddc <sys_ipc_recv>
  800e5d:	83 c4 10             	add    $0x10,%esp
  800e60:	85 c0                	test   %eax,%eax
  800e62:	78 2b                	js     800e8f <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  800e64:	85 f6                	test   %esi,%esi
  800e66:	74 0a                	je     800e72 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  800e68:	a1 08 40 80 00       	mov    0x804008,%eax
  800e6d:	8b 40 74             	mov    0x74(%eax),%eax
  800e70:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  800e72:	85 db                	test   %ebx,%ebx
  800e74:	74 0a                	je     800e80 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  800e76:	a1 08 40 80 00       	mov    0x804008,%eax
  800e7b:	8b 40 78             	mov    0x78(%eax),%eax
  800e7e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  800e80:	a1 08 40 80 00       	mov    0x804008,%eax
  800e85:	8b 40 70             	mov    0x70(%eax),%eax
}
  800e88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
	    if (from_env_store != NULL) {
  800e8f:	85 f6                	test   %esi,%esi
  800e91:	74 06                	je     800e99 <ipc_recv+0x5d>
	        *from_env_store = 0;
  800e93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  800e99:	85 db                	test   %ebx,%ebx
  800e9b:	74 eb                	je     800e88 <ipc_recv+0x4c>
	        *perm_store = 0;
  800e9d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800ea3:	eb e3                	jmp    800e88 <ipc_recv+0x4c>

00800ea5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eb1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  800eb4:	85 f6                	test   %esi,%esi
  800eb6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800ebb:	0f 44 f0             	cmove  %eax,%esi
  800ebe:	eb 09                	jmp    800ec9 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  800ec0:	e8 48 fd ff ff       	call   800c0d <sys_yield>
	} while(r != 0);
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	74 2d                	je     800ef6 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  800ec9:	ff 75 14             	pushl  0x14(%ebp)
  800ecc:	56                   	push   %esi
  800ecd:	ff 75 0c             	pushl  0xc(%ebp)
  800ed0:	57                   	push   %edi
  800ed1:	e8 e3 fe ff ff       	call   800db9 <sys_ipc_try_send>
  800ed6:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  800ed8:	83 c4 10             	add    $0x10,%esp
  800edb:	85 c0                	test   %eax,%eax
  800edd:	79 e1                	jns    800ec0 <ipc_send+0x1b>
  800edf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800ee2:	74 dc                	je     800ec0 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  800ee4:	50                   	push   %eax
  800ee5:	68 ca 26 80 00       	push   $0x8026ca
  800eea:	6a 45                	push   $0x45
  800eec:	68 d7 26 80 00       	push   $0x8026d7
  800ef1:	e8 a0 11 00 00       	call   802096 <_panic>
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800f04:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800f09:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800f0c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800f12:	8b 52 50             	mov    0x50(%edx),%edx
  800f15:	39 ca                	cmp    %ecx,%edx
  800f17:	74 11                	je     800f2a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800f19:	83 c0 01             	add    $0x1,%eax
  800f1c:	3d 00 04 00 00       	cmp    $0x400,%eax
  800f21:	75 e6                	jne    800f09 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800f23:	b8 00 00 00 00       	mov    $0x0,%eax
  800f28:	eb 0b                	jmp    800f35 <ipc_find_env+0x37>
			return envs[i].env_id;
  800f2a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f2d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f32:	8b 40 48             	mov    0x48(%eax),%eax
}
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	05 00 00 00 30       	add    $0x30000000,%eax
  800f42:	c1 e8 0c             	shr    $0xc,%eax
}
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f57:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f64:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	c1 ea 16             	shr    $0x16,%edx
  800f6e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f75:	f6 c2 01             	test   $0x1,%dl
  800f78:	74 2a                	je     800fa4 <fd_alloc+0x46>
  800f7a:	89 c2                	mov    %eax,%edx
  800f7c:	c1 ea 0c             	shr    $0xc,%edx
  800f7f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f86:	f6 c2 01             	test   $0x1,%dl
  800f89:	74 19                	je     800fa4 <fd_alloc+0x46>
  800f8b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f90:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f95:	75 d2                	jne    800f69 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f97:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f9d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fa2:	eb 07                	jmp    800fab <fd_alloc+0x4d>
			*fd_store = fd;
  800fa4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fb3:	83 f8 1f             	cmp    $0x1f,%eax
  800fb6:	77 36                	ja     800fee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb8:	c1 e0 0c             	shl    $0xc,%eax
  800fbb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fc0:	89 c2                	mov    %eax,%edx
  800fc2:	c1 ea 16             	shr    $0x16,%edx
  800fc5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fcc:	f6 c2 01             	test   $0x1,%dl
  800fcf:	74 24                	je     800ff5 <fd_lookup+0x48>
  800fd1:	89 c2                	mov    %eax,%edx
  800fd3:	c1 ea 0c             	shr    $0xc,%edx
  800fd6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fdd:	f6 c2 01             	test   $0x1,%dl
  800fe0:	74 1a                	je     800ffc <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe5:	89 02                	mov    %eax,(%edx)
	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    
		return -E_INVAL;
  800fee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff3:	eb f7                	jmp    800fec <fd_lookup+0x3f>
		return -E_INVAL;
  800ff5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffa:	eb f0                	jmp    800fec <fd_lookup+0x3f>
  800ffc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801001:	eb e9                	jmp    800fec <fd_lookup+0x3f>

00801003 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100c:	ba 60 27 80 00       	mov    $0x802760,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801011:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801016:	39 08                	cmp    %ecx,(%eax)
  801018:	74 33                	je     80104d <dev_lookup+0x4a>
  80101a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80101d:	8b 02                	mov    (%edx),%eax
  80101f:	85 c0                	test   %eax,%eax
  801021:	75 f3                	jne    801016 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801023:	a1 08 40 80 00       	mov    0x804008,%eax
  801028:	8b 40 48             	mov    0x48(%eax),%eax
  80102b:	83 ec 04             	sub    $0x4,%esp
  80102e:	51                   	push   %ecx
  80102f:	50                   	push   %eax
  801030:	68 e4 26 80 00       	push   $0x8026e4
  801035:	e8 5c f1 ff ff       	call   800196 <cprintf>
	*dev = 0;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801043:	83 c4 10             	add    $0x10,%esp
  801046:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    
			*dev = devtab[i];
  80104d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801050:	89 01                	mov    %eax,(%ecx)
			return 0;
  801052:	b8 00 00 00 00       	mov    $0x0,%eax
  801057:	eb f2                	jmp    80104b <dev_lookup+0x48>

00801059 <fd_close>:
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	57                   	push   %edi
  80105d:	56                   	push   %esi
  80105e:	53                   	push   %ebx
  80105f:	83 ec 1c             	sub    $0x1c,%esp
  801062:	8b 75 08             	mov    0x8(%ebp),%esi
  801065:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801068:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80106b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801072:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801075:	50                   	push   %eax
  801076:	e8 32 ff ff ff       	call   800fad <fd_lookup>
  80107b:	89 c3                	mov    %eax,%ebx
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	78 05                	js     801089 <fd_close+0x30>
	    || fd != fd2)
  801084:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801087:	74 16                	je     80109f <fd_close+0x46>
		return (must_exist ? r : 0);
  801089:	89 f8                	mov    %edi,%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	b8 00 00 00 00       	mov    $0x0,%eax
  801092:	0f 44 d8             	cmove  %eax,%ebx
}
  801095:	89 d8                	mov    %ebx,%eax
  801097:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109a:	5b                   	pop    %ebx
  80109b:	5e                   	pop    %esi
  80109c:	5f                   	pop    %edi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010a5:	50                   	push   %eax
  8010a6:	ff 36                	pushl  (%esi)
  8010a8:	e8 56 ff ff ff       	call   801003 <dev_lookup>
  8010ad:	89 c3                	mov    %eax,%ebx
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	78 15                	js     8010cb <fd_close+0x72>
		if (dev->dev_close)
  8010b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b9:	8b 40 10             	mov    0x10(%eax),%eax
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	74 1b                	je     8010db <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	56                   	push   %esi
  8010c4:	ff d0                	call   *%eax
  8010c6:	89 c3                	mov    %eax,%ebx
  8010c8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	56                   	push   %esi
  8010cf:	6a 00                	push   $0x0
  8010d1:	e8 db fb ff ff       	call   800cb1 <sys_page_unmap>
	return r;
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	eb ba                	jmp    801095 <fd_close+0x3c>
			r = 0;
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	eb e9                	jmp    8010cb <fd_close+0x72>

008010e2 <close>:

int
close(int fdnum)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010eb:	50                   	push   %eax
  8010ec:	ff 75 08             	pushl  0x8(%ebp)
  8010ef:	e8 b9 fe ff ff       	call   800fad <fd_lookup>
  8010f4:	83 c4 08             	add    $0x8,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 10                	js     80110b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	6a 01                	push   $0x1
  801100:	ff 75 f4             	pushl  -0xc(%ebp)
  801103:	e8 51 ff ff ff       	call   801059 <fd_close>
  801108:	83 c4 10             	add    $0x10,%esp
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <close_all>:

void
close_all(void)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	53                   	push   %ebx
  801111:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	53                   	push   %ebx
  80111d:	e8 c0 ff ff ff       	call   8010e2 <close>
	for (i = 0; i < MAXFD; i++)
  801122:	83 c3 01             	add    $0x1,%ebx
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	83 fb 20             	cmp    $0x20,%ebx
  80112b:	75 ec                	jne    801119 <close_all+0xc>
}
  80112d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
  801138:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80113b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	ff 75 08             	pushl  0x8(%ebp)
  801142:	e8 66 fe ff ff       	call   800fad <fd_lookup>
  801147:	89 c3                	mov    %eax,%ebx
  801149:	83 c4 08             	add    $0x8,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	0f 88 81 00 00 00    	js     8011d5 <dup+0xa3>
		return r;
	close(newfdnum);
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	e8 83 ff ff ff       	call   8010e2 <close>

	newfd = INDEX2FD(newfdnum);
  80115f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801162:	c1 e6 0c             	shl    $0xc,%esi
  801165:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80116b:	83 c4 04             	add    $0x4,%esp
  80116e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801171:	e8 d1 fd ff ff       	call   800f47 <fd2data>
  801176:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801178:	89 34 24             	mov    %esi,(%esp)
  80117b:	e8 c7 fd ff ff       	call   800f47 <fd2data>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801185:	89 d8                	mov    %ebx,%eax
  801187:	c1 e8 16             	shr    $0x16,%eax
  80118a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801191:	a8 01                	test   $0x1,%al
  801193:	74 11                	je     8011a6 <dup+0x74>
  801195:	89 d8                	mov    %ebx,%eax
  801197:	c1 e8 0c             	shr    $0xc,%eax
  80119a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a1:	f6 c2 01             	test   $0x1,%dl
  8011a4:	75 39                	jne    8011df <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011a9:	89 d0                	mov    %edx,%eax
  8011ab:	c1 e8 0c             	shr    $0xc,%eax
  8011ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bd:	50                   	push   %eax
  8011be:	56                   	push   %esi
  8011bf:	6a 00                	push   $0x0
  8011c1:	52                   	push   %edx
  8011c2:	6a 00                	push   $0x0
  8011c4:	e8 a6 fa ff ff       	call   800c6f <sys_page_map>
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	83 c4 20             	add    $0x20,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 31                	js     801203 <dup+0xd1>
		goto err;

	return newfdnum;
  8011d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011d5:	89 d8                	mov    %ebx,%eax
  8011d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011da:	5b                   	pop    %ebx
  8011db:	5e                   	pop    %esi
  8011dc:	5f                   	pop    %edi
  8011dd:	5d                   	pop    %ebp
  8011de:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ee:	50                   	push   %eax
  8011ef:	57                   	push   %edi
  8011f0:	6a 00                	push   $0x0
  8011f2:	53                   	push   %ebx
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 75 fa ff ff       	call   800c6f <sys_page_map>
  8011fa:	89 c3                	mov    %eax,%ebx
  8011fc:	83 c4 20             	add    $0x20,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	79 a3                	jns    8011a6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	56                   	push   %esi
  801207:	6a 00                	push   $0x0
  801209:	e8 a3 fa ff ff       	call   800cb1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80120e:	83 c4 08             	add    $0x8,%esp
  801211:	57                   	push   %edi
  801212:	6a 00                	push   $0x0
  801214:	e8 98 fa ff ff       	call   800cb1 <sys_page_unmap>
	return r;
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	eb b7                	jmp    8011d5 <dup+0xa3>

0080121e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	53                   	push   %ebx
  801222:	83 ec 14             	sub    $0x14,%esp
  801225:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801228:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80122b:	50                   	push   %eax
  80122c:	53                   	push   %ebx
  80122d:	e8 7b fd ff ff       	call   800fad <fd_lookup>
  801232:	83 c4 08             	add    $0x8,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 3f                	js     801278 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801239:	83 ec 08             	sub    $0x8,%esp
  80123c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80123f:	50                   	push   %eax
  801240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801243:	ff 30                	pushl  (%eax)
  801245:	e8 b9 fd ff ff       	call   801003 <dev_lookup>
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 27                	js     801278 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801251:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801254:	8b 42 08             	mov    0x8(%edx),%eax
  801257:	83 e0 03             	and    $0x3,%eax
  80125a:	83 f8 01             	cmp    $0x1,%eax
  80125d:	74 1e                	je     80127d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80125f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801262:	8b 40 08             	mov    0x8(%eax),%eax
  801265:	85 c0                	test   %eax,%eax
  801267:	74 35                	je     80129e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801269:	83 ec 04             	sub    $0x4,%esp
  80126c:	ff 75 10             	pushl  0x10(%ebp)
  80126f:	ff 75 0c             	pushl  0xc(%ebp)
  801272:	52                   	push   %edx
  801273:	ff d0                	call   *%eax
  801275:	83 c4 10             	add    $0x10,%esp
}
  801278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80127d:	a1 08 40 80 00       	mov    0x804008,%eax
  801282:	8b 40 48             	mov    0x48(%eax),%eax
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	53                   	push   %ebx
  801289:	50                   	push   %eax
  80128a:	68 25 27 80 00       	push   $0x802725
  80128f:	e8 02 ef ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129c:	eb da                	jmp    801278 <read+0x5a>
		return -E_NOT_SUPP;
  80129e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a3:	eb d3                	jmp    801278 <read+0x5a>

008012a5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	57                   	push   %edi
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b9:	39 f3                	cmp    %esi,%ebx
  8012bb:	73 25                	jae    8012e2 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012bd:	83 ec 04             	sub    $0x4,%esp
  8012c0:	89 f0                	mov    %esi,%eax
  8012c2:	29 d8                	sub    %ebx,%eax
  8012c4:	50                   	push   %eax
  8012c5:	89 d8                	mov    %ebx,%eax
  8012c7:	03 45 0c             	add    0xc(%ebp),%eax
  8012ca:	50                   	push   %eax
  8012cb:	57                   	push   %edi
  8012cc:	e8 4d ff ff ff       	call   80121e <read>
		if (m < 0)
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 08                	js     8012e0 <readn+0x3b>
			return m;
		if (m == 0)
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	74 06                	je     8012e2 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012dc:	01 c3                	add    %eax,%ebx
  8012de:	eb d9                	jmp    8012b9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012e2:	89 d8                	mov    %ebx,%eax
  8012e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5f                   	pop    %edi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 14             	sub    $0x14,%esp
  8012f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f9:	50                   	push   %eax
  8012fa:	53                   	push   %ebx
  8012fb:	e8 ad fc ff ff       	call   800fad <fd_lookup>
  801300:	83 c4 08             	add    $0x8,%esp
  801303:	85 c0                	test   %eax,%eax
  801305:	78 3a                	js     801341 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130d:	50                   	push   %eax
  80130e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801311:	ff 30                	pushl  (%eax)
  801313:	e8 eb fc ff ff       	call   801003 <dev_lookup>
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 22                	js     801341 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80131f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801322:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801326:	74 1e                	je     801346 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132b:	8b 52 0c             	mov    0xc(%edx),%edx
  80132e:	85 d2                	test   %edx,%edx
  801330:	74 35                	je     801367 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801332:	83 ec 04             	sub    $0x4,%esp
  801335:	ff 75 10             	pushl  0x10(%ebp)
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	50                   	push   %eax
  80133c:	ff d2                	call   *%edx
  80133e:	83 c4 10             	add    $0x10,%esp
}
  801341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801344:	c9                   	leave  
  801345:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801346:	a1 08 40 80 00       	mov    0x804008,%eax
  80134b:	8b 40 48             	mov    0x48(%eax),%eax
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	53                   	push   %ebx
  801352:	50                   	push   %eax
  801353:	68 41 27 80 00       	push   $0x802741
  801358:	e8 39 ee ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801365:	eb da                	jmp    801341 <write+0x55>
		return -E_NOT_SUPP;
  801367:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136c:	eb d3                	jmp    801341 <write+0x55>

0080136e <seek>:

int
seek(int fdnum, off_t offset)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801374:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801377:	50                   	push   %eax
  801378:	ff 75 08             	pushl  0x8(%ebp)
  80137b:	e8 2d fc ff ff       	call   800fad <fd_lookup>
  801380:	83 c4 08             	add    $0x8,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 0e                	js     801395 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	53                   	push   %ebx
  80139b:	83 ec 14             	sub    $0x14,%esp
  80139e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	53                   	push   %ebx
  8013a6:	e8 02 fc ff ff       	call   800fad <fd_lookup>
  8013ab:	83 c4 08             	add    $0x8,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 37                	js     8013e9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b8:	50                   	push   %eax
  8013b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bc:	ff 30                	pushl  (%eax)
  8013be:	e8 40 fc ff ff       	call   801003 <dev_lookup>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 1f                	js     8013e9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d1:	74 1b                	je     8013ee <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d6:	8b 52 18             	mov    0x18(%edx),%edx
  8013d9:	85 d2                	test   %edx,%edx
  8013db:	74 32                	je     80140f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	50                   	push   %eax
  8013e4:	ff d2                	call   *%edx
  8013e6:	83 c4 10             	add    $0x10,%esp
}
  8013e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013ee:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013f3:	8b 40 48             	mov    0x48(%eax),%eax
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	53                   	push   %ebx
  8013fa:	50                   	push   %eax
  8013fb:	68 04 27 80 00       	push   $0x802704
  801400:	e8 91 ed ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140d:	eb da                	jmp    8013e9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80140f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801414:	eb d3                	jmp    8013e9 <ftruncate+0x52>

00801416 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	53                   	push   %ebx
  80141a:	83 ec 14             	sub    $0x14,%esp
  80141d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801420:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 81 fb ff ff       	call   800fad <fd_lookup>
  80142c:	83 c4 08             	add    $0x8,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 4b                	js     80147e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801439:	50                   	push   %eax
  80143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143d:	ff 30                	pushl  (%eax)
  80143f:	e8 bf fb ff ff       	call   801003 <dev_lookup>
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	78 33                	js     80147e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80144b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801452:	74 2f                	je     801483 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801454:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801457:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80145e:	00 00 00 
	stat->st_isdir = 0;
  801461:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801468:	00 00 00 
	stat->st_dev = dev;
  80146b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	53                   	push   %ebx
  801475:	ff 75 f0             	pushl  -0x10(%ebp)
  801478:	ff 50 14             	call   *0x14(%eax)
  80147b:	83 c4 10             	add    $0x10,%esp
}
  80147e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801481:	c9                   	leave  
  801482:	c3                   	ret    
		return -E_NOT_SUPP;
  801483:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801488:	eb f4                	jmp    80147e <fstat+0x68>

0080148a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	56                   	push   %esi
  80148e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	6a 00                	push   $0x0
  801494:	ff 75 08             	pushl  0x8(%ebp)
  801497:	e8 26 02 00 00       	call   8016c2 <open>
  80149c:	89 c3                	mov    %eax,%ebx
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 1b                	js     8014c0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	50                   	push   %eax
  8014ac:	e8 65 ff ff ff       	call   801416 <fstat>
  8014b1:	89 c6                	mov    %eax,%esi
	close(fd);
  8014b3:	89 1c 24             	mov    %ebx,(%esp)
  8014b6:	e8 27 fc ff ff       	call   8010e2 <close>
	return r;
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 f3                	mov    %esi,%ebx
}
  8014c0:	89 d8                	mov    %ebx,%eax
  8014c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	56                   	push   %esi
  8014cd:	53                   	push   %ebx
  8014ce:	89 c6                	mov    %eax,%esi
  8014d0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014d2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014d9:	74 27                	je     801502 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014db:	6a 07                	push   $0x7
  8014dd:	68 00 50 80 00       	push   $0x805000
  8014e2:	56                   	push   %esi
  8014e3:	ff 35 00 40 80 00    	pushl  0x804000
  8014e9:	e8 b7 f9 ff ff       	call   800ea5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014ee:	83 c4 0c             	add    $0xc,%esp
  8014f1:	6a 00                	push   $0x0
  8014f3:	53                   	push   %ebx
  8014f4:	6a 00                	push   $0x0
  8014f6:	e8 41 f9 ff ff       	call   800e3c <ipc_recv>
}
  8014fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fe:	5b                   	pop    %ebx
  8014ff:	5e                   	pop    %esi
  801500:	5d                   	pop    %ebp
  801501:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	6a 01                	push   $0x1
  801507:	e8 f2 f9 ff ff       	call   800efe <ipc_find_env>
  80150c:	a3 00 40 80 00       	mov    %eax,0x804000
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	eb c5                	jmp    8014db <fsipc+0x12>

00801516 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	8b 40 0c             	mov    0xc(%eax),%eax
  801522:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80152f:	ba 00 00 00 00       	mov    $0x0,%edx
  801534:	b8 02 00 00 00       	mov    $0x2,%eax
  801539:	e8 8b ff ff ff       	call   8014c9 <fsipc>
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <devfile_flush>:
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8b 40 0c             	mov    0xc(%eax),%eax
  80154c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801551:	ba 00 00 00 00       	mov    $0x0,%edx
  801556:	b8 06 00 00 00       	mov    $0x6,%eax
  80155b:	e8 69 ff ff ff       	call   8014c9 <fsipc>
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <devfile_stat>:
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	53                   	push   %ebx
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8b 40 0c             	mov    0xc(%eax),%eax
  801572:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801577:	ba 00 00 00 00       	mov    $0x0,%edx
  80157c:	b8 05 00 00 00       	mov    $0x5,%eax
  801581:	e8 43 ff ff ff       	call   8014c9 <fsipc>
  801586:	85 c0                	test   %eax,%eax
  801588:	78 2c                	js     8015b6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80158a:	83 ec 08             	sub    $0x8,%esp
  80158d:	68 00 50 80 00       	push   $0x805000
  801592:	53                   	push   %ebx
  801593:	e8 9b f2 ff ff       	call   800833 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801598:	a1 80 50 80 00       	mov    0x805080,%eax
  80159d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015a3:	a1 84 50 80 00       	mov    0x805084,%eax
  8015a8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <devfile_write>:
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8015d0:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015d6:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015dc:	77 30                	ja     80160e <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	53                   	push   %ebx
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	68 08 50 80 00       	push   $0x805008
  8015ea:	e8 d2 f3 ff ff       	call   8009c1 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8015f9:	e8 cb fe ff ff       	call   8014c9 <fsipc>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	85 c0                	test   %eax,%eax
  801603:	78 04                	js     801609 <devfile_write+0x4e>
	assert(r <= n);
  801605:	39 d8                	cmp    %ebx,%eax
  801607:	77 1e                	ja     801627 <devfile_write+0x6c>
}
  801609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80160e:	68 74 27 80 00       	push   $0x802774
  801613:	68 a1 27 80 00       	push   $0x8027a1
  801618:	68 94 00 00 00       	push   $0x94
  80161d:	68 b6 27 80 00       	push   $0x8027b6
  801622:	e8 6f 0a 00 00       	call   802096 <_panic>
	assert(r <= n);
  801627:	68 c1 27 80 00       	push   $0x8027c1
  80162c:	68 a1 27 80 00       	push   $0x8027a1
  801631:	68 98 00 00 00       	push   $0x98
  801636:	68 b6 27 80 00       	push   $0x8027b6
  80163b:	e8 56 0a 00 00       	call   802096 <_panic>

00801640 <devfile_read>:
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8b 40 0c             	mov    0xc(%eax),%eax
  80164e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801653:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801659:	ba 00 00 00 00       	mov    $0x0,%edx
  80165e:	b8 03 00 00 00       	mov    $0x3,%eax
  801663:	e8 61 fe ff ff       	call   8014c9 <fsipc>
  801668:	89 c3                	mov    %eax,%ebx
  80166a:	85 c0                	test   %eax,%eax
  80166c:	78 1f                	js     80168d <devfile_read+0x4d>
	assert(r <= n);
  80166e:	39 f0                	cmp    %esi,%eax
  801670:	77 24                	ja     801696 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801672:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801677:	7f 33                	jg     8016ac <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801679:	83 ec 04             	sub    $0x4,%esp
  80167c:	50                   	push   %eax
  80167d:	68 00 50 80 00       	push   $0x805000
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	e8 37 f3 ff ff       	call   8009c1 <memmove>
	return r;
  80168a:	83 c4 10             	add    $0x10,%esp
}
  80168d:	89 d8                	mov    %ebx,%eax
  80168f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801692:	5b                   	pop    %ebx
  801693:	5e                   	pop    %esi
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    
	assert(r <= n);
  801696:	68 c1 27 80 00       	push   $0x8027c1
  80169b:	68 a1 27 80 00       	push   $0x8027a1
  8016a0:	6a 7c                	push   $0x7c
  8016a2:	68 b6 27 80 00       	push   $0x8027b6
  8016a7:	e8 ea 09 00 00       	call   802096 <_panic>
	assert(r <= PGSIZE);
  8016ac:	68 c8 27 80 00       	push   $0x8027c8
  8016b1:	68 a1 27 80 00       	push   $0x8027a1
  8016b6:	6a 7d                	push   $0x7d
  8016b8:	68 b6 27 80 00       	push   $0x8027b6
  8016bd:	e8 d4 09 00 00       	call   802096 <_panic>

008016c2 <open>:
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 1c             	sub    $0x1c,%esp
  8016ca:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016cd:	56                   	push   %esi
  8016ce:	e8 29 f1 ff ff       	call   8007fc <strlen>
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016db:	7f 6c                	jg     801749 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e3:	50                   	push   %eax
  8016e4:	e8 75 f8 ff ff       	call   800f5e <fd_alloc>
  8016e9:	89 c3                	mov    %eax,%ebx
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 3c                	js     80172e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	56                   	push   %esi
  8016f6:	68 00 50 80 00       	push   $0x805000
  8016fb:	e8 33 f1 ff ff       	call   800833 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170b:	b8 01 00 00 00       	mov    $0x1,%eax
  801710:	e8 b4 fd ff ff       	call   8014c9 <fsipc>
  801715:	89 c3                	mov    %eax,%ebx
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 19                	js     801737 <open+0x75>
	return fd2num(fd);
  80171e:	83 ec 0c             	sub    $0xc,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	e8 0e f8 ff ff       	call   800f37 <fd2num>
  801729:	89 c3                	mov    %eax,%ebx
  80172b:	83 c4 10             	add    $0x10,%esp
}
  80172e:	89 d8                	mov    %ebx,%eax
  801730:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    
		fd_close(fd, 0);
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	6a 00                	push   $0x0
  80173c:	ff 75 f4             	pushl  -0xc(%ebp)
  80173f:	e8 15 f9 ff ff       	call   801059 <fd_close>
		return r;
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	eb e5                	jmp    80172e <open+0x6c>
		return -E_BAD_PATH;
  801749:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80174e:	eb de                	jmp    80172e <open+0x6c>

00801750 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801756:	ba 00 00 00 00       	mov    $0x0,%edx
  80175b:	b8 08 00 00 00       	mov    $0x8,%eax
  801760:	e8 64 fd ff ff       	call   8014c9 <fsipc>
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	e8 cd f7 ff ff       	call   800f47 <fd2data>
  80177a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80177c:	83 c4 08             	add    $0x8,%esp
  80177f:	68 d4 27 80 00       	push   $0x8027d4
  801784:	53                   	push   %ebx
  801785:	e8 a9 f0 ff ff       	call   800833 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80178a:	8b 46 04             	mov    0x4(%esi),%eax
  80178d:	2b 06                	sub    (%esi),%eax
  80178f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801795:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80179c:	00 00 00 
	stat->st_dev = &devpipe;
  80179f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017a6:	30 80 00 
	return 0;
}
  8017a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b1:	5b                   	pop    %ebx
  8017b2:	5e                   	pop    %esi
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    

008017b5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 0c             	sub    $0xc,%esp
  8017bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017bf:	53                   	push   %ebx
  8017c0:	6a 00                	push   $0x0
  8017c2:	e8 ea f4 ff ff       	call   800cb1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017c7:	89 1c 24             	mov    %ebx,(%esp)
  8017ca:	e8 78 f7 ff ff       	call   800f47 <fd2data>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	50                   	push   %eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	e8 d7 f4 ff ff       	call   800cb1 <sys_page_unmap>
}
  8017da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <_pipeisclosed>:
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	57                   	push   %edi
  8017e3:	56                   	push   %esi
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 1c             	sub    $0x1c,%esp
  8017e8:	89 c7                	mov    %eax,%edi
  8017ea:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8017f1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017f4:	83 ec 0c             	sub    $0xc,%esp
  8017f7:	57                   	push   %edi
  8017f8:	e8 df 08 00 00       	call   8020dc <pageref>
  8017fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801800:	89 34 24             	mov    %esi,(%esp)
  801803:	e8 d4 08 00 00       	call   8020dc <pageref>
		nn = thisenv->env_runs;
  801808:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80180e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	39 cb                	cmp    %ecx,%ebx
  801816:	74 1b                	je     801833 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801818:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80181b:	75 cf                	jne    8017ec <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80181d:	8b 42 58             	mov    0x58(%edx),%eax
  801820:	6a 01                	push   $0x1
  801822:	50                   	push   %eax
  801823:	53                   	push   %ebx
  801824:	68 db 27 80 00       	push   $0x8027db
  801829:	e8 68 e9 ff ff       	call   800196 <cprintf>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	eb b9                	jmp    8017ec <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801833:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801836:	0f 94 c0             	sete   %al
  801839:	0f b6 c0             	movzbl %al,%eax
}
  80183c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5f                   	pop    %edi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <devpipe_write>:
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	57                   	push   %edi
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	83 ec 28             	sub    $0x28,%esp
  80184d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801850:	56                   	push   %esi
  801851:	e8 f1 f6 ff ff       	call   800f47 <fd2data>
  801856:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	bf 00 00 00 00       	mov    $0x0,%edi
  801860:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801863:	74 4f                	je     8018b4 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801865:	8b 43 04             	mov    0x4(%ebx),%eax
  801868:	8b 0b                	mov    (%ebx),%ecx
  80186a:	8d 51 20             	lea    0x20(%ecx),%edx
  80186d:	39 d0                	cmp    %edx,%eax
  80186f:	72 14                	jb     801885 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801871:	89 da                	mov    %ebx,%edx
  801873:	89 f0                	mov    %esi,%eax
  801875:	e8 65 ff ff ff       	call   8017df <_pipeisclosed>
  80187a:	85 c0                	test   %eax,%eax
  80187c:	75 3a                	jne    8018b8 <devpipe_write+0x74>
			sys_yield();
  80187e:	e8 8a f3 ff ff       	call   800c0d <sys_yield>
  801883:	eb e0                	jmp    801865 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801888:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80188c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80188f:	89 c2                	mov    %eax,%edx
  801891:	c1 fa 1f             	sar    $0x1f,%edx
  801894:	89 d1                	mov    %edx,%ecx
  801896:	c1 e9 1b             	shr    $0x1b,%ecx
  801899:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80189c:	83 e2 1f             	and    $0x1f,%edx
  80189f:	29 ca                	sub    %ecx,%edx
  8018a1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018a5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018a9:	83 c0 01             	add    $0x1,%eax
  8018ac:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018af:	83 c7 01             	add    $0x1,%edi
  8018b2:	eb ac                	jmp    801860 <devpipe_write+0x1c>
	return i;
  8018b4:	89 f8                	mov    %edi,%eax
  8018b6:	eb 05                	jmp    8018bd <devpipe_write+0x79>
				return 0;
  8018b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5f                   	pop    %edi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <devpipe_read>:
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	57                   	push   %edi
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	83 ec 18             	sub    $0x18,%esp
  8018ce:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018d1:	57                   	push   %edi
  8018d2:	e8 70 f6 ff ff       	call   800f47 <fd2data>
  8018d7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	be 00 00 00 00       	mov    $0x0,%esi
  8018e1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018e4:	74 47                	je     80192d <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8018e6:	8b 03                	mov    (%ebx),%eax
  8018e8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018eb:	75 22                	jne    80190f <devpipe_read+0x4a>
			if (i > 0)
  8018ed:	85 f6                	test   %esi,%esi
  8018ef:	75 14                	jne    801905 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8018f1:	89 da                	mov    %ebx,%edx
  8018f3:	89 f8                	mov    %edi,%eax
  8018f5:	e8 e5 fe ff ff       	call   8017df <_pipeisclosed>
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	75 33                	jne    801931 <devpipe_read+0x6c>
			sys_yield();
  8018fe:	e8 0a f3 ff ff       	call   800c0d <sys_yield>
  801903:	eb e1                	jmp    8018e6 <devpipe_read+0x21>
				return i;
  801905:	89 f0                	mov    %esi,%eax
}
  801907:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5f                   	pop    %edi
  80190d:	5d                   	pop    %ebp
  80190e:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80190f:	99                   	cltd   
  801910:	c1 ea 1b             	shr    $0x1b,%edx
  801913:	01 d0                	add    %edx,%eax
  801915:	83 e0 1f             	and    $0x1f,%eax
  801918:	29 d0                	sub    %edx,%eax
  80191a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80191f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801922:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801925:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801928:	83 c6 01             	add    $0x1,%esi
  80192b:	eb b4                	jmp    8018e1 <devpipe_read+0x1c>
	return i;
  80192d:	89 f0                	mov    %esi,%eax
  80192f:	eb d6                	jmp    801907 <devpipe_read+0x42>
				return 0;
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	eb cf                	jmp    801907 <devpipe_read+0x42>

00801938 <pipe>:
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	56                   	push   %esi
  80193c:	53                   	push   %ebx
  80193d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801940:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801943:	50                   	push   %eax
  801944:	e8 15 f6 ff ff       	call   800f5e <fd_alloc>
  801949:	89 c3                	mov    %eax,%ebx
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 5b                	js     8019ad <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	68 07 04 00 00       	push   $0x407
  80195a:	ff 75 f4             	pushl  -0xc(%ebp)
  80195d:	6a 00                	push   $0x0
  80195f:	e8 c8 f2 ff ff       	call   800c2c <sys_page_alloc>
  801964:	89 c3                	mov    %eax,%ebx
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 40                	js     8019ad <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801973:	50                   	push   %eax
  801974:	e8 e5 f5 ff ff       	call   800f5e <fd_alloc>
  801979:	89 c3                	mov    %eax,%ebx
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 1b                	js     80199d <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 07 04 00 00       	push   $0x407
  80198a:	ff 75 f0             	pushl  -0x10(%ebp)
  80198d:	6a 00                	push   $0x0
  80198f:	e8 98 f2 ff ff       	call   800c2c <sys_page_alloc>
  801994:	89 c3                	mov    %eax,%ebx
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	85 c0                	test   %eax,%eax
  80199b:	79 19                	jns    8019b6 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a3:	6a 00                	push   $0x0
  8019a5:	e8 07 f3 ff ff       	call   800cb1 <sys_page_unmap>
  8019aa:	83 c4 10             	add    $0x10,%esp
}
  8019ad:	89 d8                	mov    %ebx,%eax
  8019af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b2:	5b                   	pop    %ebx
  8019b3:	5e                   	pop    %esi
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    
	va = fd2data(fd0);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bc:	e8 86 f5 ff ff       	call   800f47 <fd2data>
  8019c1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019c3:	83 c4 0c             	add    $0xc,%esp
  8019c6:	68 07 04 00 00       	push   $0x407
  8019cb:	50                   	push   %eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	e8 59 f2 ff ff       	call   800c2c <sys_page_alloc>
  8019d3:	89 c3                	mov    %eax,%ebx
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	0f 88 8c 00 00 00    	js     801a6c <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019e0:	83 ec 0c             	sub    $0xc,%esp
  8019e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e6:	e8 5c f5 ff ff       	call   800f47 <fd2data>
  8019eb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019f2:	50                   	push   %eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	56                   	push   %esi
  8019f6:	6a 00                	push   $0x0
  8019f8:	e8 72 f2 ff ff       	call   800c6f <sys_page_map>
  8019fd:	89 c3                	mov    %eax,%ebx
  8019ff:	83 c4 20             	add    $0x20,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 58                	js     801a5e <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a09:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a0f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a24:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a29:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a30:	83 ec 0c             	sub    $0xc,%esp
  801a33:	ff 75 f4             	pushl  -0xc(%ebp)
  801a36:	e8 fc f4 ff ff       	call   800f37 <fd2num>
  801a3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a40:	83 c4 04             	add    $0x4,%esp
  801a43:	ff 75 f0             	pushl  -0x10(%ebp)
  801a46:	e8 ec f4 ff ff       	call   800f37 <fd2num>
  801a4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a4e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a59:	e9 4f ff ff ff       	jmp    8019ad <pipe+0x75>
	sys_page_unmap(0, va);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	56                   	push   %esi
  801a62:	6a 00                	push   $0x0
  801a64:	e8 48 f2 ff ff       	call   800cb1 <sys_page_unmap>
  801a69:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a72:	6a 00                	push   $0x0
  801a74:	e8 38 f2 ff ff       	call   800cb1 <sys_page_unmap>
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	e9 1c ff ff ff       	jmp    80199d <pipe+0x65>

00801a81 <pipeisclosed>:
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8a:	50                   	push   %eax
  801a8b:	ff 75 08             	pushl  0x8(%ebp)
  801a8e:	e8 1a f5 ff ff       	call   800fad <fd_lookup>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 18                	js     801ab2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a9a:	83 ec 0c             	sub    $0xc,%esp
  801a9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa0:	e8 a2 f4 ff ff       	call   800f47 <fd2data>
	return _pipeisclosed(fd, p);
  801aa5:	89 c2                	mov    %eax,%edx
  801aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaa:	e8 30 fd ff ff       	call   8017df <_pipeisclosed>
  801aaf:	83 c4 10             	add    $0x10,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801aba:	68 f3 27 80 00       	push   $0x8027f3
  801abf:	ff 75 0c             	pushl  0xc(%ebp)
  801ac2:	e8 6c ed ff ff       	call   800833 <strcpy>
	return 0;
}
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <devsock_close>:
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 10             	sub    $0x10,%esp
  801ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ad8:	53                   	push   %ebx
  801ad9:	e8 fe 05 00 00       	call   8020dc <pageref>
  801ade:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ae1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ae6:	83 f8 01             	cmp    $0x1,%eax
  801ae9:	74 07                	je     801af2 <devsock_close+0x24>
}
  801aeb:	89 d0                	mov    %edx,%eax
  801aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	ff 73 0c             	pushl  0xc(%ebx)
  801af8:	e8 b7 02 00 00       	call   801db4 <nsipc_close>
  801afd:	89 c2                	mov    %eax,%edx
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	eb e7                	jmp    801aeb <devsock_close+0x1d>

00801b04 <devsock_write>:
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	ff 75 10             	pushl  0x10(%ebp)
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	ff 70 0c             	pushl  0xc(%eax)
  801b18:	e8 74 03 00 00       	call   801e91 <nsipc_send>
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <devsock_read>:
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 10             	pushl  0x10(%ebp)
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	ff 70 0c             	pushl  0xc(%eax)
  801b33:	e8 ed 02 00 00       	call   801e25 <nsipc_recv>
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <fd2sockid>:
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b40:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	e8 63 f4 ff ff       	call   800fad <fd_lookup>
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	78 10                	js     801b61 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b54:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801b5a:	39 08                	cmp    %ecx,(%eax)
  801b5c:	75 05                	jne    801b63 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b5e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    
		return -E_NOT_SUPP;
  801b63:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b68:	eb f7                	jmp    801b61 <fd2sockid+0x27>

00801b6a <alloc_sockfd>:
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	56                   	push   %esi
  801b6e:	53                   	push   %ebx
  801b6f:	83 ec 1c             	sub    $0x1c,%esp
  801b72:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b77:	50                   	push   %eax
  801b78:	e8 e1 f3 ff ff       	call   800f5e <fd_alloc>
  801b7d:	89 c3                	mov    %eax,%ebx
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 43                	js     801bc9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b86:	83 ec 04             	sub    $0x4,%esp
  801b89:	68 07 04 00 00       	push   $0x407
  801b8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b91:	6a 00                	push   $0x0
  801b93:	e8 94 f0 ff ff       	call   800c2c <sys_page_alloc>
  801b98:	89 c3                	mov    %eax,%ebx
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	85 c0                	test   %eax,%eax
  801b9f:	78 28                	js     801bc9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801baa:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bb6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	50                   	push   %eax
  801bbd:	e8 75 f3 ff ff       	call   800f37 <fd2num>
  801bc2:	89 c3                	mov    %eax,%ebx
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	eb 0c                	jmp    801bd5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bc9:	83 ec 0c             	sub    $0xc,%esp
  801bcc:	56                   	push   %esi
  801bcd:	e8 e2 01 00 00       	call   801db4 <nsipc_close>
		return r;
  801bd2:	83 c4 10             	add    $0x10,%esp
}
  801bd5:	89 d8                	mov    %ebx,%eax
  801bd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bda:	5b                   	pop    %ebx
  801bdb:	5e                   	pop    %esi
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    

00801bde <accept>:
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	e8 4e ff ff ff       	call   801b3a <fd2sockid>
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 1b                	js     801c0b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	ff 75 10             	pushl  0x10(%ebp)
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	50                   	push   %eax
  801bfa:	e8 0e 01 00 00       	call   801d0d <nsipc_accept>
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	85 c0                	test   %eax,%eax
  801c04:	78 05                	js     801c0b <accept+0x2d>
	return alloc_sockfd(r);
  801c06:	e8 5f ff ff ff       	call   801b6a <alloc_sockfd>
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <bind>:
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	e8 1f ff ff ff       	call   801b3a <fd2sockid>
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 12                	js     801c31 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	ff 75 10             	pushl  0x10(%ebp)
  801c25:	ff 75 0c             	pushl  0xc(%ebp)
  801c28:	50                   	push   %eax
  801c29:	e8 2f 01 00 00       	call   801d5d <nsipc_bind>
  801c2e:	83 c4 10             	add    $0x10,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <shutdown>:
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	e8 f9 fe ff ff       	call   801b3a <fd2sockid>
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 0f                	js     801c54 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	50                   	push   %eax
  801c4c:	e8 41 01 00 00       	call   801d92 <nsipc_shutdown>
  801c51:	83 c4 10             	add    $0x10,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <connect>:
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	e8 d6 fe ff ff       	call   801b3a <fd2sockid>
  801c64:	85 c0                	test   %eax,%eax
  801c66:	78 12                	js     801c7a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	ff 75 10             	pushl  0x10(%ebp)
  801c6e:	ff 75 0c             	pushl  0xc(%ebp)
  801c71:	50                   	push   %eax
  801c72:	e8 57 01 00 00       	call   801dce <nsipc_connect>
  801c77:	83 c4 10             	add    $0x10,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <listen>:
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	e8 b0 fe ff ff       	call   801b3a <fd2sockid>
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	78 0f                	js     801c9d <listen+0x21>
	return nsipc_listen(r, backlog);
  801c8e:	83 ec 08             	sub    $0x8,%esp
  801c91:	ff 75 0c             	pushl  0xc(%ebp)
  801c94:	50                   	push   %eax
  801c95:	e8 69 01 00 00       	call   801e03 <nsipc_listen>
  801c9a:	83 c4 10             	add    $0x10,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <socket>:

int
socket(int domain, int type, int protocol)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	ff 75 08             	pushl  0x8(%ebp)
  801cae:	e8 3c 02 00 00       	call   801eef <nsipc_socket>
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	78 05                	js     801cbf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cba:	e8 ab fe ff ff       	call   801b6a <alloc_sockfd>
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	53                   	push   %ebx
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cca:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801cd1:	74 26                	je     801cf9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cd3:	6a 07                	push   $0x7
  801cd5:	68 00 60 80 00       	push   $0x806000
  801cda:	53                   	push   %ebx
  801cdb:	ff 35 04 40 80 00    	pushl  0x804004
  801ce1:	e8 bf f1 ff ff       	call   800ea5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ce6:	83 c4 0c             	add    $0xc,%esp
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	e8 48 f1 ff ff       	call   800e3c <ipc_recv>
}
  801cf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	6a 02                	push   $0x2
  801cfe:	e8 fb f1 ff ff       	call   800efe <ipc_find_env>
  801d03:	a3 04 40 80 00       	mov    %eax,0x804004
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	eb c6                	jmp    801cd3 <nsipc+0x12>

00801d0d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	56                   	push   %esi
  801d11:	53                   	push   %ebx
  801d12:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d1d:	8b 06                	mov    (%esi),%eax
  801d1f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d24:	b8 01 00 00 00       	mov    $0x1,%eax
  801d29:	e8 93 ff ff ff       	call   801cc1 <nsipc>
  801d2e:	89 c3                	mov    %eax,%ebx
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 20                	js     801d54 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d34:	83 ec 04             	sub    $0x4,%esp
  801d37:	ff 35 10 60 80 00    	pushl  0x806010
  801d3d:	68 00 60 80 00       	push   $0x806000
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	e8 77 ec ff ff       	call   8009c1 <memmove>
		*addrlen = ret->ret_addrlen;
  801d4a:	a1 10 60 80 00       	mov    0x806010,%eax
  801d4f:	89 06                	mov    %eax,(%esi)
  801d51:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d59:	5b                   	pop    %ebx
  801d5a:	5e                   	pop    %esi
  801d5b:	5d                   	pop    %ebp
  801d5c:	c3                   	ret    

00801d5d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	53                   	push   %ebx
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d6f:	53                   	push   %ebx
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	68 04 60 80 00       	push   $0x806004
  801d78:	e8 44 ec ff ff       	call   8009c1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d7d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d83:	b8 02 00 00 00       	mov    $0x2,%eax
  801d88:	e8 34 ff ff ff       	call   801cc1 <nsipc>
}
  801d8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801da8:	b8 03 00 00 00       	mov    $0x3,%eax
  801dad:	e8 0f ff ff ff       	call   801cc1 <nsipc>
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <nsipc_close>:

int
nsipc_close(int s)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dc2:	b8 04 00 00 00       	mov    $0x4,%eax
  801dc7:	e8 f5 fe ff ff       	call   801cc1 <nsipc>
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	53                   	push   %ebx
  801dd2:	83 ec 08             	sub    $0x8,%esp
  801dd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801de0:	53                   	push   %ebx
  801de1:	ff 75 0c             	pushl  0xc(%ebp)
  801de4:	68 04 60 80 00       	push   $0x806004
  801de9:	e8 d3 eb ff ff       	call   8009c1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dee:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801df4:	b8 05 00 00 00       	mov    $0x5,%eax
  801df9:	e8 c3 fe ff ff       	call   801cc1 <nsipc>
}
  801dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e14:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e19:	b8 06 00 00 00       	mov    $0x6,%eax
  801e1e:	e8 9e fe ff ff       	call   801cc1 <nsipc>
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
  801e2a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e35:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e43:	b8 07 00 00 00       	mov    $0x7,%eax
  801e48:	e8 74 fe ff ff       	call   801cc1 <nsipc>
  801e4d:	89 c3                	mov    %eax,%ebx
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 1f                	js     801e72 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e53:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e58:	7f 21                	jg     801e7b <nsipc_recv+0x56>
  801e5a:	39 c6                	cmp    %eax,%esi
  801e5c:	7c 1d                	jl     801e7b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e5e:	83 ec 04             	sub    $0x4,%esp
  801e61:	50                   	push   %eax
  801e62:	68 00 60 80 00       	push   $0x806000
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	e8 52 eb ff ff       	call   8009c1 <memmove>
  801e6f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e72:	89 d8                	mov    %ebx,%eax
  801e74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e77:	5b                   	pop    %ebx
  801e78:	5e                   	pop    %esi
  801e79:	5d                   	pop    %ebp
  801e7a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e7b:	68 ff 27 80 00       	push   $0x8027ff
  801e80:	68 a1 27 80 00       	push   $0x8027a1
  801e85:	6a 62                	push   $0x62
  801e87:	68 14 28 80 00       	push   $0x802814
  801e8c:	e8 05 02 00 00       	call   802096 <_panic>

00801e91 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	53                   	push   %ebx
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ea3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ea9:	7f 2e                	jg     801ed9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	53                   	push   %ebx
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	68 0c 60 80 00       	push   $0x80600c
  801eb7:	e8 05 eb ff ff       	call   8009c1 <memmove>
	nsipcbuf.send.req_size = size;
  801ebc:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801eca:	b8 08 00 00 00       	mov    $0x8,%eax
  801ecf:	e8 ed fd ff ff       	call   801cc1 <nsipc>
}
  801ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    
	assert(size < 1600);
  801ed9:	68 20 28 80 00       	push   $0x802820
  801ede:	68 a1 27 80 00       	push   $0x8027a1
  801ee3:	6a 6d                	push   $0x6d
  801ee5:	68 14 28 80 00       	push   $0x802814
  801eea:	e8 a7 01 00 00       	call   802096 <_panic>

00801eef <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f00:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f05:	8b 45 10             	mov    0x10(%ebp),%eax
  801f08:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f0d:	b8 09 00 00 00       	mov    $0x9,%eax
  801f12:	e8 aa fd ff ff       	call   801cc1 <nsipc>
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f29:	68 2c 28 80 00       	push   $0x80282c
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	e8 fd e8 ff ff       	call   800833 <strcpy>
	return 0;
}
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <devcons_write>:
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	57                   	push   %edi
  801f41:	56                   	push   %esi
  801f42:	53                   	push   %ebx
  801f43:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f49:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f4e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f54:	eb 2f                	jmp    801f85 <devcons_write+0x48>
		m = n - tot;
  801f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f59:	29 f3                	sub    %esi,%ebx
  801f5b:	83 fb 7f             	cmp    $0x7f,%ebx
  801f5e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f63:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f66:	83 ec 04             	sub    $0x4,%esp
  801f69:	53                   	push   %ebx
  801f6a:	89 f0                	mov    %esi,%eax
  801f6c:	03 45 0c             	add    0xc(%ebp),%eax
  801f6f:	50                   	push   %eax
  801f70:	57                   	push   %edi
  801f71:	e8 4b ea ff ff       	call   8009c1 <memmove>
		sys_cputs(buf, m);
  801f76:	83 c4 08             	add    $0x8,%esp
  801f79:	53                   	push   %ebx
  801f7a:	57                   	push   %edi
  801f7b:	e8 f0 eb ff ff       	call   800b70 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f80:	01 de                	add    %ebx,%esi
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f88:	72 cc                	jb     801f56 <devcons_write+0x19>
}
  801f8a:	89 f0                	mov    %esi,%eax
  801f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    

00801f94 <devcons_read>:
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 08             	sub    $0x8,%esp
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fa3:	75 07                	jne    801fac <devcons_read+0x18>
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    
		sys_yield();
  801fa7:	e8 61 ec ff ff       	call   800c0d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801fac:	e8 dd eb ff ff       	call   800b8e <sys_cgetc>
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 f2                	je     801fa7 <devcons_read+0x13>
	if (c < 0)
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 ec                	js     801fa5 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801fb9:	83 f8 04             	cmp    $0x4,%eax
  801fbc:	74 0c                	je     801fca <devcons_read+0x36>
	*(char*)vbuf = c;
  801fbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc1:	88 02                	mov    %al,(%edx)
	return 1;
  801fc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc8:	eb db                	jmp    801fa5 <devcons_read+0x11>
		return 0;
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	eb d4                	jmp    801fa5 <devcons_read+0x11>

00801fd1 <cputchar>:
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fdd:	6a 01                	push   $0x1
  801fdf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fe2:	50                   	push   %eax
  801fe3:	e8 88 eb ff ff       	call   800b70 <sys_cputs>
}
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <getchar>:
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ff3:	6a 01                	push   $0x1
  801ff5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff8:	50                   	push   %eax
  801ff9:	6a 00                	push   $0x0
  801ffb:	e8 1e f2 ff ff       	call   80121e <read>
	if (r < 0)
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	78 08                	js     80200f <getchar+0x22>
	if (r < 1)
  802007:	85 c0                	test   %eax,%eax
  802009:	7e 06                	jle    802011 <getchar+0x24>
	return c;
  80200b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    
		return -E_EOF;
  802011:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802016:	eb f7                	jmp    80200f <getchar+0x22>

00802018 <iscons>:
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802021:	50                   	push   %eax
  802022:	ff 75 08             	pushl  0x8(%ebp)
  802025:	e8 83 ef ff ff       	call   800fad <fd_lookup>
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 11                	js     802042 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80203a:	39 10                	cmp    %edx,(%eax)
  80203c:	0f 94 c0             	sete   %al
  80203f:	0f b6 c0             	movzbl %al,%eax
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <opencons>:
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80204a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204d:	50                   	push   %eax
  80204e:	e8 0b ef ff ff       	call   800f5e <fd_alloc>
  802053:	83 c4 10             	add    $0x10,%esp
  802056:	85 c0                	test   %eax,%eax
  802058:	78 3a                	js     802094 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	68 07 04 00 00       	push   $0x407
  802062:	ff 75 f4             	pushl  -0xc(%ebp)
  802065:	6a 00                	push   $0x0
  802067:	e8 c0 eb ff ff       	call   800c2c <sys_page_alloc>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 21                	js     802094 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80207c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	50                   	push   %eax
  80208c:	e8 a6 ee ff ff       	call   800f37 <fd2num>
  802091:	83 c4 10             	add    $0x10,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	56                   	push   %esi
  80209a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80209b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80209e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8020a4:	e8 45 eb ff ff       	call   800bee <sys_getenvid>
  8020a9:	83 ec 0c             	sub    $0xc,%esp
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	ff 75 08             	pushl  0x8(%ebp)
  8020b2:	56                   	push   %esi
  8020b3:	50                   	push   %eax
  8020b4:	68 38 28 80 00       	push   $0x802838
  8020b9:	e8 d8 e0 ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020be:	83 c4 18             	add    $0x18,%esp
  8020c1:	53                   	push   %ebx
  8020c2:	ff 75 10             	pushl  0x10(%ebp)
  8020c5:	e8 7b e0 ff ff       	call   800145 <vcprintf>
	cprintf("\n");
  8020ca:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  8020d1:	e8 c0 e0 ff ff       	call   800196 <cprintf>
  8020d6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020d9:	cc                   	int3   
  8020da:	eb fd                	jmp    8020d9 <_panic+0x43>

008020dc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020e2:	89 d0                	mov    %edx,%eax
  8020e4:	c1 e8 16             	shr    $0x16,%eax
  8020e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020f3:	f6 c1 01             	test   $0x1,%cl
  8020f6:	74 1d                	je     802115 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020f8:	c1 ea 0c             	shr    $0xc,%edx
  8020fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802102:	f6 c2 01             	test   $0x1,%dl
  802105:	74 0e                	je     802115 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802107:	c1 ea 0c             	shr    $0xc,%edx
  80210a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802111:	ef 
  802112:	0f b7 c0             	movzwl %ax,%eax
}
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    
  802117:	66 90                	xchg   %ax,%ax
  802119:	66 90                	xchg   %ax,%ax
  80211b:	66 90                	xchg   %ax,%ax
  80211d:	66 90                	xchg   %ax,%ax
  80211f:	90                   	nop

00802120 <__udivdi3>:
  802120:	55                   	push   %ebp
  802121:	57                   	push   %edi
  802122:	56                   	push   %esi
  802123:	53                   	push   %ebx
  802124:	83 ec 1c             	sub    $0x1c,%esp
  802127:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80212b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80212f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802133:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802137:	85 d2                	test   %edx,%edx
  802139:	75 35                	jne    802170 <__udivdi3+0x50>
  80213b:	39 f3                	cmp    %esi,%ebx
  80213d:	0f 87 bd 00 00 00    	ja     802200 <__udivdi3+0xe0>
  802143:	85 db                	test   %ebx,%ebx
  802145:	89 d9                	mov    %ebx,%ecx
  802147:	75 0b                	jne    802154 <__udivdi3+0x34>
  802149:	b8 01 00 00 00       	mov    $0x1,%eax
  80214e:	31 d2                	xor    %edx,%edx
  802150:	f7 f3                	div    %ebx
  802152:	89 c1                	mov    %eax,%ecx
  802154:	31 d2                	xor    %edx,%edx
  802156:	89 f0                	mov    %esi,%eax
  802158:	f7 f1                	div    %ecx
  80215a:	89 c6                	mov    %eax,%esi
  80215c:	89 e8                	mov    %ebp,%eax
  80215e:	89 f7                	mov    %esi,%edi
  802160:	f7 f1                	div    %ecx
  802162:	89 fa                	mov    %edi,%edx
  802164:	83 c4 1c             	add    $0x1c,%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
  80216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802170:	39 f2                	cmp    %esi,%edx
  802172:	77 7c                	ja     8021f0 <__udivdi3+0xd0>
  802174:	0f bd fa             	bsr    %edx,%edi
  802177:	83 f7 1f             	xor    $0x1f,%edi
  80217a:	0f 84 98 00 00 00    	je     802218 <__udivdi3+0xf8>
  802180:	89 f9                	mov    %edi,%ecx
  802182:	b8 20 00 00 00       	mov    $0x20,%eax
  802187:	29 f8                	sub    %edi,%eax
  802189:	d3 e2                	shl    %cl,%edx
  80218b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80218f:	89 c1                	mov    %eax,%ecx
  802191:	89 da                	mov    %ebx,%edx
  802193:	d3 ea                	shr    %cl,%edx
  802195:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802199:	09 d1                	or     %edx,%ecx
  80219b:	89 f2                	mov    %esi,%edx
  80219d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021a1:	89 f9                	mov    %edi,%ecx
  8021a3:	d3 e3                	shl    %cl,%ebx
  8021a5:	89 c1                	mov    %eax,%ecx
  8021a7:	d3 ea                	shr    %cl,%edx
  8021a9:	89 f9                	mov    %edi,%ecx
  8021ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021af:	d3 e6                	shl    %cl,%esi
  8021b1:	89 eb                	mov    %ebp,%ebx
  8021b3:	89 c1                	mov    %eax,%ecx
  8021b5:	d3 eb                	shr    %cl,%ebx
  8021b7:	09 de                	or     %ebx,%esi
  8021b9:	89 f0                	mov    %esi,%eax
  8021bb:	f7 74 24 08          	divl   0x8(%esp)
  8021bf:	89 d6                	mov    %edx,%esi
  8021c1:	89 c3                	mov    %eax,%ebx
  8021c3:	f7 64 24 0c          	mull   0xc(%esp)
  8021c7:	39 d6                	cmp    %edx,%esi
  8021c9:	72 0c                	jb     8021d7 <__udivdi3+0xb7>
  8021cb:	89 f9                	mov    %edi,%ecx
  8021cd:	d3 e5                	shl    %cl,%ebp
  8021cf:	39 c5                	cmp    %eax,%ebp
  8021d1:	73 5d                	jae    802230 <__udivdi3+0x110>
  8021d3:	39 d6                	cmp    %edx,%esi
  8021d5:	75 59                	jne    802230 <__udivdi3+0x110>
  8021d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021da:	31 ff                	xor    %edi,%edi
  8021dc:	89 fa                	mov    %edi,%edx
  8021de:	83 c4 1c             	add    $0x1c,%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5f                   	pop    %edi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    
  8021e6:	8d 76 00             	lea    0x0(%esi),%esi
  8021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021f0:	31 ff                	xor    %edi,%edi
  8021f2:	31 c0                	xor    %eax,%eax
  8021f4:	89 fa                	mov    %edi,%edx
  8021f6:	83 c4 1c             	add    $0x1c,%esp
  8021f9:	5b                   	pop    %ebx
  8021fa:	5e                   	pop    %esi
  8021fb:	5f                   	pop    %edi
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    
  8021fe:	66 90                	xchg   %ax,%ax
  802200:	31 ff                	xor    %edi,%edi
  802202:	89 e8                	mov    %ebp,%eax
  802204:	89 f2                	mov    %esi,%edx
  802206:	f7 f3                	div    %ebx
  802208:	89 fa                	mov    %edi,%edx
  80220a:	83 c4 1c             	add    $0x1c,%esp
  80220d:	5b                   	pop    %ebx
  80220e:	5e                   	pop    %esi
  80220f:	5f                   	pop    %edi
  802210:	5d                   	pop    %ebp
  802211:	c3                   	ret    
  802212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	72 06                	jb     802222 <__udivdi3+0x102>
  80221c:	31 c0                	xor    %eax,%eax
  80221e:	39 eb                	cmp    %ebp,%ebx
  802220:	77 d2                	ja     8021f4 <__udivdi3+0xd4>
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	eb cb                	jmp    8021f4 <__udivdi3+0xd4>
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 d8                	mov    %ebx,%eax
  802232:	31 ff                	xor    %edi,%edi
  802234:	eb be                	jmp    8021f4 <__udivdi3+0xd4>
  802236:	66 90                	xchg   %ax,%ax
  802238:	66 90                	xchg   %ax,%ax
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	66 90                	xchg   %ax,%ax
  80223e:	66 90                	xchg   %ax,%ax

00802240 <__umoddi3>:
  802240:	55                   	push   %ebp
  802241:	57                   	push   %edi
  802242:	56                   	push   %esi
  802243:	53                   	push   %ebx
  802244:	83 ec 1c             	sub    $0x1c,%esp
  802247:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80224b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80224f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802253:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802257:	85 ed                	test   %ebp,%ebp
  802259:	89 f0                	mov    %esi,%eax
  80225b:	89 da                	mov    %ebx,%edx
  80225d:	75 19                	jne    802278 <__umoddi3+0x38>
  80225f:	39 df                	cmp    %ebx,%edi
  802261:	0f 86 b1 00 00 00    	jbe    802318 <__umoddi3+0xd8>
  802267:	f7 f7                	div    %edi
  802269:	89 d0                	mov    %edx,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	83 c4 1c             	add    $0x1c,%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5f                   	pop    %edi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    
  802275:	8d 76 00             	lea    0x0(%esi),%esi
  802278:	39 dd                	cmp    %ebx,%ebp
  80227a:	77 f1                	ja     80226d <__umoddi3+0x2d>
  80227c:	0f bd cd             	bsr    %ebp,%ecx
  80227f:	83 f1 1f             	xor    $0x1f,%ecx
  802282:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802286:	0f 84 b4 00 00 00    	je     802340 <__umoddi3+0x100>
  80228c:	b8 20 00 00 00       	mov    $0x20,%eax
  802291:	89 c2                	mov    %eax,%edx
  802293:	8b 44 24 04          	mov    0x4(%esp),%eax
  802297:	29 c2                	sub    %eax,%edx
  802299:	89 c1                	mov    %eax,%ecx
  80229b:	89 f8                	mov    %edi,%eax
  80229d:	d3 e5                	shl    %cl,%ebp
  80229f:	89 d1                	mov    %edx,%ecx
  8022a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022a5:	d3 e8                	shr    %cl,%eax
  8022a7:	09 c5                	or     %eax,%ebp
  8022a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ad:	89 c1                	mov    %eax,%ecx
  8022af:	d3 e7                	shl    %cl,%edi
  8022b1:	89 d1                	mov    %edx,%ecx
  8022b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8022b7:	89 df                	mov    %ebx,%edi
  8022b9:	d3 ef                	shr    %cl,%edi
  8022bb:	89 c1                	mov    %eax,%ecx
  8022bd:	89 f0                	mov    %esi,%eax
  8022bf:	d3 e3                	shl    %cl,%ebx
  8022c1:	89 d1                	mov    %edx,%ecx
  8022c3:	89 fa                	mov    %edi,%edx
  8022c5:	d3 e8                	shr    %cl,%eax
  8022c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022cc:	09 d8                	or     %ebx,%eax
  8022ce:	f7 f5                	div    %ebp
  8022d0:	d3 e6                	shl    %cl,%esi
  8022d2:	89 d1                	mov    %edx,%ecx
  8022d4:	f7 64 24 08          	mull   0x8(%esp)
  8022d8:	39 d1                	cmp    %edx,%ecx
  8022da:	89 c3                	mov    %eax,%ebx
  8022dc:	89 d7                	mov    %edx,%edi
  8022de:	72 06                	jb     8022e6 <__umoddi3+0xa6>
  8022e0:	75 0e                	jne    8022f0 <__umoddi3+0xb0>
  8022e2:	39 c6                	cmp    %eax,%esi
  8022e4:	73 0a                	jae    8022f0 <__umoddi3+0xb0>
  8022e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022ea:	19 ea                	sbb    %ebp,%edx
  8022ec:	89 d7                	mov    %edx,%edi
  8022ee:	89 c3                	mov    %eax,%ebx
  8022f0:	89 ca                	mov    %ecx,%edx
  8022f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022f7:	29 de                	sub    %ebx,%esi
  8022f9:	19 fa                	sbb    %edi,%edx
  8022fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022ff:	89 d0                	mov    %edx,%eax
  802301:	d3 e0                	shl    %cl,%eax
  802303:	89 d9                	mov    %ebx,%ecx
  802305:	d3 ee                	shr    %cl,%esi
  802307:	d3 ea                	shr    %cl,%edx
  802309:	09 f0                	or     %esi,%eax
  80230b:	83 c4 1c             	add    $0x1c,%esp
  80230e:	5b                   	pop    %ebx
  80230f:	5e                   	pop    %esi
  802310:	5f                   	pop    %edi
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    
  802313:	90                   	nop
  802314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802318:	85 ff                	test   %edi,%edi
  80231a:	89 f9                	mov    %edi,%ecx
  80231c:	75 0b                	jne    802329 <__umoddi3+0xe9>
  80231e:	b8 01 00 00 00       	mov    $0x1,%eax
  802323:	31 d2                	xor    %edx,%edx
  802325:	f7 f7                	div    %edi
  802327:	89 c1                	mov    %eax,%ecx
  802329:	89 d8                	mov    %ebx,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f1                	div    %ecx
  80232f:	89 f0                	mov    %esi,%eax
  802331:	f7 f1                	div    %ecx
  802333:	e9 31 ff ff ff       	jmp    802269 <__umoddi3+0x29>
  802338:	90                   	nop
  802339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802340:	39 dd                	cmp    %ebx,%ebp
  802342:	72 08                	jb     80234c <__umoddi3+0x10c>
  802344:	39 f7                	cmp    %esi,%edi
  802346:	0f 87 21 ff ff ff    	ja     80226d <__umoddi3+0x2d>
  80234c:	89 da                	mov    %ebx,%edx
  80234e:	89 f0                	mov    %esi,%eax
  802350:	29 f8                	sub    %edi,%eax
  802352:	19 ea                	sbb    %ebp,%edx
  802354:	e9 14 ff ff ff       	jmp    80226d <__umoddi3+0x2d>
