
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 a0 23 80 00       	push   $0x8023a0
  80003e:	e8 d4 01 00 00       	call   800217 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 e8 23 80 00       	push   $0x8023e8
  800095:	e8 7d 01 00 00       	call   800217 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 47 24 80 00       	push   $0x802447
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 38 24 80 00       	push   $0x802438
  8000b3:	e8 84 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 1b 24 80 00       	push   $0x80241b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 38 24 80 00       	push   $0x802438
  8000c5:	e8 72 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 c0 23 80 00       	push   $0x8023c0
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 38 24 80 00       	push   $0x802438
  8000d7:	e8 60 00 00 00       	call   80013c <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000e7:	e8 83 0b 00 00       	call   800c6f <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f9:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 db                	test   %ebx,%ebx
  800100:	7e 07                	jle    800109 <libmain+0x2d>
		binaryname = argv[0];
  800102:	8b 06                	mov    (%esi),%eax
  800104:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	e8 20 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800113:	e8 0a 00 00 00       	call   800122 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800128:	e8 66 0f 00 00       	call   801093 <close_all>
	sys_env_destroy(0);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	6a 00                	push   $0x0
  800132:	e8 f7 0a 00 00       	call   800c2e <sys_env_destroy>
}
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800141:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800144:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014a:	e8 20 0b 00 00       	call   800c6f <sys_getenvid>
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	ff 75 0c             	pushl  0xc(%ebp)
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	56                   	push   %esi
  800159:	50                   	push   %eax
  80015a:	68 68 24 80 00       	push   $0x802468
  80015f:	e8 b3 00 00 00       	call   800217 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800164:	83 c4 18             	add    $0x18,%esp
  800167:	53                   	push   %ebx
  800168:	ff 75 10             	pushl  0x10(%ebp)
  80016b:	e8 56 00 00 00       	call   8001c6 <vcprintf>
	cprintf("\n");
  800170:	c7 04 24 36 24 80 00 	movl   $0x802436,(%esp)
  800177:	e8 9b 00 00 00       	call   800217 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80017f:	cc                   	int3   
  800180:	eb fd                	jmp    80017f <_panic+0x43>

00800182 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	53                   	push   %ebx
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018c:	8b 13                	mov    (%ebx),%edx
  80018e:	8d 42 01             	lea    0x1(%edx),%eax
  800191:	89 03                	mov    %eax,(%ebx)
  800193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800196:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019f:	74 09                	je     8001aa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	68 ff 00 00 00       	push   $0xff
  8001b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b5:	50                   	push   %eax
  8001b6:	e8 36 0a 00 00       	call   800bf1 <sys_cputs>
		b->idx = 0;
  8001bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	eb db                	jmp    8001a1 <putch+0x1f>

008001c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d6:	00 00 00 
	b.cnt = 0;
  8001d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	68 82 01 80 00       	push   $0x800182
  8001f5:	e8 1a 01 00 00       	call   800314 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fa:	83 c4 08             	add    $0x8,%esp
  8001fd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800203:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800209:	50                   	push   %eax
  80020a:	e8 e2 09 00 00       	call   800bf1 <sys_cputs>

	return b.cnt;
}
  80020f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800220:	50                   	push   %eax
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	e8 9d ff ff ff       	call   8001c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	57                   	push   %edi
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
  800231:	83 ec 1c             	sub    $0x1c,%esp
  800234:	89 c7                	mov    %eax,%edi
  800236:	89 d6                	mov    %edx,%esi
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800241:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800244:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800247:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80024f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800252:	39 d3                	cmp    %edx,%ebx
  800254:	72 05                	jb     80025b <printnum+0x30>
  800256:	39 45 10             	cmp    %eax,0x10(%ebp)
  800259:	77 7a                	ja     8002d5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	ff 75 18             	pushl  0x18(%ebp)
  800261:	8b 45 14             	mov    0x14(%ebp),%eax
  800264:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800267:	53                   	push   %ebx
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800271:	ff 75 e0             	pushl  -0x20(%ebp)
  800274:	ff 75 dc             	pushl  -0x24(%ebp)
  800277:	ff 75 d8             	pushl  -0x28(%ebp)
  80027a:	e8 e1 1e 00 00       	call   802160 <__udivdi3>
  80027f:	83 c4 18             	add    $0x18,%esp
  800282:	52                   	push   %edx
  800283:	50                   	push   %eax
  800284:	89 f2                	mov    %esi,%edx
  800286:	89 f8                	mov    %edi,%eax
  800288:	e8 9e ff ff ff       	call   80022b <printnum>
  80028d:	83 c4 20             	add    $0x20,%esp
  800290:	eb 13                	jmp    8002a5 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	56                   	push   %esi
  800296:	ff 75 18             	pushl  0x18(%ebp)
  800299:	ff d7                	call   *%edi
  80029b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80029e:	83 eb 01             	sub    $0x1,%ebx
  8002a1:	85 db                	test   %ebx,%ebx
  8002a3:	7f ed                	jg     800292 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	56                   	push   %esi
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b8:	e8 c3 1f 00 00       	call   802280 <__umoddi3>
  8002bd:	83 c4 14             	add    $0x14,%esp
  8002c0:	0f be 80 8b 24 80 00 	movsbl 0x80248b(%eax),%eax
  8002c7:	50                   	push   %eax
  8002c8:	ff d7                	call   *%edi
}
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    
  8002d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002d8:	eb c4                	jmp    80029e <printnum+0x73>

008002da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e4:	8b 10                	mov    (%eax),%edx
  8002e6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e9:	73 0a                	jae    8002f5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ee:	89 08                	mov    %ecx,(%eax)
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	88 02                	mov    %al,(%edx)
}
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <printfmt>:
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002fd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800300:	50                   	push   %eax
  800301:	ff 75 10             	pushl  0x10(%ebp)
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	e8 05 00 00 00       	call   800314 <vprintfmt>
}
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <vprintfmt>:
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 2c             	sub    $0x2c,%esp
  80031d:	8b 75 08             	mov    0x8(%ebp),%esi
  800320:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800323:	8b 7d 10             	mov    0x10(%ebp),%edi
  800326:	e9 21 04 00 00       	jmp    80074c <vprintfmt+0x438>
		padc = ' ';
  80032b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80032f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800336:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80033d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800344:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8d 47 01             	lea    0x1(%edi),%eax
  80034c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034f:	0f b6 17             	movzbl (%edi),%edx
  800352:	8d 42 dd             	lea    -0x23(%edx),%eax
  800355:	3c 55                	cmp    $0x55,%al
  800357:	0f 87 90 04 00 00    	ja     8007ed <vprintfmt+0x4d9>
  80035d:	0f b6 c0             	movzbl %al,%eax
  800360:	ff 24 85 c0 25 80 00 	jmp    *0x8025c0(,%eax,4)
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80036e:	eb d9                	jmp    800349 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800373:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800377:	eb d0                	jmp    800349 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b6:	79 91                	jns    800349 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003c5:	eb 82                	jmp    800349 <vprintfmt+0x35>
  8003c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	0f 49 d0             	cmovns %eax,%edx
  8003d4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003da:	e9 6a ff ff ff       	jmp    800349 <vprintfmt+0x35>
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003e9:	e9 5b ff ff ff       	jmp    800349 <vprintfmt+0x35>
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0x9e>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 48 ff ff ff       	jmp    800349 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 2f 03 00 00       	jmp    800749 <vprintfmt+0x435>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x13b>
  80042c:	8b 14 85 20 27 80 00 	mov    0x802720(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 7e 28 80 00       	push   $0x80287e
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 b3 fe ff ff       	call   8002f7 <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 fa 02 00 00       	jmp    800749 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 a3 24 80 00       	push   $0x8024a3
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 9b fe ff ff       	call   8002f7 <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 e2 02 00 00       	jmp    800749 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800475:	85 ff                	test   %edi,%edi
  800477:	b8 9c 24 80 00       	mov    $0x80249c,%eax
  80047c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80047f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800483:	0f 8e bd 00 00 00    	jle    800546 <vprintfmt+0x232>
  800489:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80048d:	75 0e                	jne    80049d <vprintfmt+0x189>
  80048f:	89 75 08             	mov    %esi,0x8(%ebp)
  800492:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800495:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800498:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049b:	eb 6d                	jmp    80050a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a3:	57                   	push   %edi
  8004a4:	e8 ec 03 00 00       	call   800895 <strnlen>
  8004a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ac:	29 c1                	sub    %eax,%ecx
  8004ae:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004be:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c0:	eb 0f                	jmp    8004d1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	53                   	push   %ebx
  8004c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cb:	83 ef 01             	sub    $0x1,%edi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	85 ff                	test   %edi,%edi
  8004d3:	7f ed                	jg     8004c2 <vprintfmt+0x1ae>
  8004d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004d8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004db:	85 c9                	test   %ecx,%ecx
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	0f 49 c1             	cmovns %ecx,%eax
  8004e5:	29 c1                	sub    %eax,%ecx
  8004e7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f0:	89 cb                	mov    %ecx,%ebx
  8004f2:	eb 16                	jmp    80050a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f8:	75 31                	jne    80052b <vprintfmt+0x217>
					putch(ch, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	50                   	push   %eax
  800501:	ff 55 08             	call   *0x8(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 eb 01             	sub    $0x1,%ebx
  80050a:	83 c7 01             	add    $0x1,%edi
  80050d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800511:	0f be c2             	movsbl %dl,%eax
  800514:	85 c0                	test   %eax,%eax
  800516:	74 59                	je     800571 <vprintfmt+0x25d>
  800518:	85 f6                	test   %esi,%esi
  80051a:	78 d8                	js     8004f4 <vprintfmt+0x1e0>
  80051c:	83 ee 01             	sub    $0x1,%esi
  80051f:	79 d3                	jns    8004f4 <vprintfmt+0x1e0>
  800521:	89 df                	mov    %ebx,%edi
  800523:	8b 75 08             	mov    0x8(%ebp),%esi
  800526:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800529:	eb 37                	jmp    800562 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80052b:	0f be d2             	movsbl %dl,%edx
  80052e:	83 ea 20             	sub    $0x20,%edx
  800531:	83 fa 5e             	cmp    $0x5e,%edx
  800534:	76 c4                	jbe    8004fa <vprintfmt+0x1e6>
					putch('?', putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	ff 75 0c             	pushl  0xc(%ebp)
  80053c:	6a 3f                	push   $0x3f
  80053e:	ff 55 08             	call   *0x8(%ebp)
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	eb c1                	jmp    800507 <vprintfmt+0x1f3>
  800546:	89 75 08             	mov    %esi,0x8(%ebp)
  800549:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80054f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800552:	eb b6                	jmp    80050a <vprintfmt+0x1f6>
				putch(' ', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 20                	push   $0x20
  80055a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ee                	jg     800554 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	e9 d8 01 00 00       	jmp    800749 <vprintfmt+0x435>
  800571:	89 df                	mov    %ebx,%edi
  800573:	8b 75 08             	mov    0x8(%ebp),%esi
  800576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800579:	eb e7                	jmp    800562 <vprintfmt+0x24e>
	if (lflag >= 2)
  80057b:	83 f9 01             	cmp    $0x1,%ecx
  80057e:	7e 45                	jle    8005c5 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 50 04             	mov    0x4(%eax),%edx
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8d 40 08             	lea    0x8(%eax),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800597:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059b:	79 62                	jns    8005ff <vprintfmt+0x2eb>
				putch('-', putdat);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	53                   	push   %ebx
  8005a1:	6a 2d                	push   $0x2d
  8005a3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005ab:	f7 d8                	neg    %eax
  8005ad:	83 d2 00             	adc    $0x0,%edx
  8005b0:	f7 da                	neg    %edx
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005bb:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005c0:	e9 66 01 00 00       	jmp    80072b <vprintfmt+0x417>
	else if (lflag)
  8005c5:	85 c9                	test   %ecx,%ecx
  8005c7:	75 1b                	jne    8005e4 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	89 c1                	mov    %eax,%ecx
  8005d3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 40 04             	lea    0x4(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	eb b3                	jmp    800597 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ec:	89 c1                	mov    %eax,%ecx
  8005ee:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	eb 98                	jmp    800597 <vprintfmt+0x283>
			base = 10;
  8005ff:	ba 0a 00 00 00       	mov    $0xa,%edx
  800604:	e9 22 01 00 00       	jmp    80072b <vprintfmt+0x417>
	if (lflag >= 2)
  800609:	83 f9 01             	cmp    $0x1,%ecx
  80060c:	7e 21                	jle    80062f <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 50 04             	mov    0x4(%eax),%edx
  800614:	8b 00                	mov    (%eax),%eax
  800616:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800619:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8d 40 08             	lea    0x8(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800625:	ba 0a 00 00 00       	mov    $0xa,%edx
  80062a:	e9 fc 00 00 00       	jmp    80072b <vprintfmt+0x417>
	else if (lflag)
  80062f:	85 c9                	test   %ecx,%ecx
  800631:	75 23                	jne    800656 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	ba 00 00 00 00       	mov    $0x0,%edx
  80063d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800640:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064c:	ba 0a 00 00 00       	mov    $0xa,%edx
  800651:	e9 d5 00 00 00       	jmp    80072b <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	ba 00 00 00 00       	mov    $0x0,%edx
  800660:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800663:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8d 40 04             	lea    0x4(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066f:	ba 0a 00 00 00       	mov    $0xa,%edx
  800674:	e9 b2 00 00 00       	jmp    80072b <vprintfmt+0x417>
	if (lflag >= 2)
  800679:	83 f9 01             	cmp    $0x1,%ecx
  80067c:	7e 42                	jle    8006c0 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 50 04             	mov    0x4(%eax),%edx
  800684:	8b 00                	mov    (%eax),%eax
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 08             	lea    0x8(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800695:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  80069a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80069e:	0f 89 87 00 00 00    	jns    80072b <vprintfmt+0x417>
				putch('-', putdat);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	53                   	push   %ebx
  8006a8:	6a 2d                	push   $0x2d
  8006aa:	ff d6                	call   *%esi
				num = -(long long) num;
  8006ac:	f7 5d d8             	negl   -0x28(%ebp)
  8006af:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8006b3:	f7 5d dc             	negl   -0x24(%ebp)
  8006b6:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006b9:	ba 08 00 00 00       	mov    $0x8,%edx
  8006be:	eb 6b                	jmp    80072b <vprintfmt+0x417>
	else if (lflag)
  8006c0:	85 c9                	test   %ecx,%ecx
  8006c2:	75 1b                	jne    8006df <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
  8006dd:	eb b6                	jmp    800695 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f8:	eb 9b                	jmp    800695 <vprintfmt+0x381>
			putch('0', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 30                	push   $0x30
  800700:	ff d6                	call   *%esi
			putch('x', putdat);
  800702:	83 c4 08             	add    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 78                	push   $0x78
  800708:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800717:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80071a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800726:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800732:	50                   	push   %eax
  800733:	ff 75 e0             	pushl  -0x20(%ebp)
  800736:	52                   	push   %edx
  800737:	ff 75 dc             	pushl  -0x24(%ebp)
  80073a:	ff 75 d8             	pushl  -0x28(%ebp)
  80073d:	89 da                	mov    %ebx,%edx
  80073f:	89 f0                	mov    %esi,%eax
  800741:	e8 e5 fa ff ff       	call   80022b <printnum>
			break;
  800746:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800749:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	83 c7 01             	add    $0x1,%edi
  80074f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800753:	83 f8 25             	cmp    $0x25,%eax
  800756:	0f 84 cf fb ff ff    	je     80032b <vprintfmt+0x17>
			if (ch == '\0')
  80075c:	85 c0                	test   %eax,%eax
  80075e:	0f 84 a9 00 00 00    	je     80080d <vprintfmt+0x4f9>
			putch(ch, putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	50                   	push   %eax
  800769:	ff d6                	call   *%esi
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	eb dc                	jmp    80074c <vprintfmt+0x438>
	if (lflag >= 2)
  800770:	83 f9 01             	cmp    $0x1,%ecx
  800773:	7e 1e                	jle    800793 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8b 50 04             	mov    0x4(%eax),%edx
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 40 08             	lea    0x8(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078c:	ba 10 00 00 00       	mov    $0x10,%edx
  800791:	eb 98                	jmp    80072b <vprintfmt+0x417>
	else if (lflag)
  800793:	85 c9                	test   %ecx,%ecx
  800795:	75 23                	jne    8007ba <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 40 04             	lea    0x4(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b0:	ba 10 00 00 00       	mov    $0x10,%edx
  8007b5:	e9 71 ff ff ff       	jmp    80072b <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8d 40 04             	lea    0x4(%eax),%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d3:	ba 10 00 00 00       	mov    $0x10,%edx
  8007d8:	e9 4e ff ff ff       	jmp    80072b <vprintfmt+0x417>
			putch(ch, putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	6a 25                	push   $0x25
  8007e3:	ff d6                	call   *%esi
			break;
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	e9 5c ff ff ff       	jmp    800749 <vprintfmt+0x435>
			putch('%', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	6a 25                	push   $0x25
  8007f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	89 f8                	mov    %edi,%eax
  8007fa:	eb 03                	jmp    8007ff <vprintfmt+0x4eb>
  8007fc:	83 e8 01             	sub    $0x1,%eax
  8007ff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800803:	75 f7                	jne    8007fc <vprintfmt+0x4e8>
  800805:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800808:	e9 3c ff ff ff       	jmp    800749 <vprintfmt+0x435>
}
  80080d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800810:	5b                   	pop    %ebx
  800811:	5e                   	pop    %esi
  800812:	5f                   	pop    %edi
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 18             	sub    $0x18,%esp
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800821:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800824:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800828:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80082b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800832:	85 c0                	test   %eax,%eax
  800834:	74 26                	je     80085c <vsnprintf+0x47>
  800836:	85 d2                	test   %edx,%edx
  800838:	7e 22                	jle    80085c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80083a:	ff 75 14             	pushl  0x14(%ebp)
  80083d:	ff 75 10             	pushl  0x10(%ebp)
  800840:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800843:	50                   	push   %eax
  800844:	68 da 02 80 00       	push   $0x8002da
  800849:	e8 c6 fa ff ff       	call   800314 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80084e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800851:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800857:	83 c4 10             	add    $0x10,%esp
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    
		return -E_INVAL;
  80085c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800861:	eb f7                	jmp    80085a <vsnprintf+0x45>

00800863 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800869:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80086c:	50                   	push   %eax
  80086d:	ff 75 10             	pushl  0x10(%ebp)
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 9a ff ff ff       	call   800815 <vsnprintf>
	va_end(ap);

	return rc;
}
  80087b:	c9                   	leave  
  80087c:	c3                   	ret    

0080087d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	eb 03                	jmp    80088d <strlen+0x10>
		n++;
  80088a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80088d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800891:	75 f7                	jne    80088a <strlen+0xd>
	return n;
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089e:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a3:	eb 03                	jmp    8008a8 <strnlen+0x13>
		n++;
  8008a5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a8:	39 d0                	cmp    %edx,%eax
  8008aa:	74 06                	je     8008b2 <strnlen+0x1d>
  8008ac:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008b0:	75 f3                	jne    8008a5 <strnlen+0x10>
	return n;
}
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	53                   	push   %ebx
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008be:	89 c2                	mov    %eax,%edx
  8008c0:	83 c1 01             	add    $0x1,%ecx
  8008c3:	83 c2 01             	add    $0x1,%edx
  8008c6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ca:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008cd:	84 db                	test   %bl,%bl
  8008cf:	75 ef                	jne    8008c0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	53                   	push   %ebx
  8008d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008db:	53                   	push   %ebx
  8008dc:	e8 9c ff ff ff       	call   80087d <strlen>
  8008e1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	01 d8                	add    %ebx,%eax
  8008e9:	50                   	push   %eax
  8008ea:	e8 c5 ff ff ff       	call   8008b4 <strcpy>
	return dst;
}
  8008ef:	89 d8                	mov    %ebx,%eax
  8008f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f4:	c9                   	leave  
  8008f5:	c3                   	ret    

008008f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	56                   	push   %esi
  8008fa:	53                   	push   %ebx
  8008fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800901:	89 f3                	mov    %esi,%ebx
  800903:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800906:	89 f2                	mov    %esi,%edx
  800908:	eb 0f                	jmp    800919 <strncpy+0x23>
		*dst++ = *src;
  80090a:	83 c2 01             	add    $0x1,%edx
  80090d:	0f b6 01             	movzbl (%ecx),%eax
  800910:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800913:	80 39 01             	cmpb   $0x1,(%ecx)
  800916:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800919:	39 da                	cmp    %ebx,%edx
  80091b:	75 ed                	jne    80090a <strncpy+0x14>
	}
	return ret;
}
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	8b 75 08             	mov    0x8(%ebp),%esi
  80092b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800931:	89 f0                	mov    %esi,%eax
  800933:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800937:	85 c9                	test   %ecx,%ecx
  800939:	75 0b                	jne    800946 <strlcpy+0x23>
  80093b:	eb 17                	jmp    800954 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800946:	39 d8                	cmp    %ebx,%eax
  800948:	74 07                	je     800951 <strlcpy+0x2e>
  80094a:	0f b6 0a             	movzbl (%edx),%ecx
  80094d:	84 c9                	test   %cl,%cl
  80094f:	75 ec                	jne    80093d <strlcpy+0x1a>
		*dst = '\0';
  800951:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800954:	29 f0                	sub    %esi,%eax
}
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800963:	eb 06                	jmp    80096b <strcmp+0x11>
		p++, q++;
  800965:	83 c1 01             	add    $0x1,%ecx
  800968:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80096b:	0f b6 01             	movzbl (%ecx),%eax
  80096e:	84 c0                	test   %al,%al
  800970:	74 04                	je     800976 <strcmp+0x1c>
  800972:	3a 02                	cmp    (%edx),%al
  800974:	74 ef                	je     800965 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800976:	0f b6 c0             	movzbl %al,%eax
  800979:	0f b6 12             	movzbl (%edx),%edx
  80097c:	29 d0                	sub    %edx,%eax
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	53                   	push   %ebx
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098a:	89 c3                	mov    %eax,%ebx
  80098c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098f:	eb 06                	jmp    800997 <strncmp+0x17>
		n--, p++, q++;
  800991:	83 c0 01             	add    $0x1,%eax
  800994:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800997:	39 d8                	cmp    %ebx,%eax
  800999:	74 16                	je     8009b1 <strncmp+0x31>
  80099b:	0f b6 08             	movzbl (%eax),%ecx
  80099e:	84 c9                	test   %cl,%cl
  8009a0:	74 04                	je     8009a6 <strncmp+0x26>
  8009a2:	3a 0a                	cmp    (%edx),%cl
  8009a4:	74 eb                	je     800991 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a6:	0f b6 00             	movzbl (%eax),%eax
  8009a9:	0f b6 12             	movzbl (%edx),%edx
  8009ac:	29 d0                	sub    %edx,%eax
}
  8009ae:	5b                   	pop    %ebx
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    
		return 0;
  8009b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b6:	eb f6                	jmp    8009ae <strncmp+0x2e>

008009b8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c2:	0f b6 10             	movzbl (%eax),%edx
  8009c5:	84 d2                	test   %dl,%dl
  8009c7:	74 09                	je     8009d2 <strchr+0x1a>
		if (*s == c)
  8009c9:	38 ca                	cmp    %cl,%dl
  8009cb:	74 0a                	je     8009d7 <strchr+0x1f>
	for (; *s; s++)
  8009cd:	83 c0 01             	add    $0x1,%eax
  8009d0:	eb f0                	jmp    8009c2 <strchr+0xa>
			return (char *) s;
	return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e3:	eb 03                	jmp    8009e8 <strfind+0xf>
  8009e5:	83 c0 01             	add    $0x1,%eax
  8009e8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009eb:	38 ca                	cmp    %cl,%dl
  8009ed:	74 04                	je     8009f3 <strfind+0x1a>
  8009ef:	84 d2                	test   %dl,%dl
  8009f1:	75 f2                	jne    8009e5 <strfind+0xc>
			break;
	return (char *) s;
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	57                   	push   %edi
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a01:	85 c9                	test   %ecx,%ecx
  800a03:	74 13                	je     800a18 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a05:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0b:	75 05                	jne    800a12 <memset+0x1d>
  800a0d:	f6 c1 03             	test   $0x3,%cl
  800a10:	74 0d                	je     800a1f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a15:	fc                   	cld    
  800a16:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a18:	89 f8                	mov    %edi,%eax
  800a1a:	5b                   	pop    %ebx
  800a1b:	5e                   	pop    %esi
  800a1c:	5f                   	pop    %edi
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    
		c &= 0xFF;
  800a1f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a23:	89 d3                	mov    %edx,%ebx
  800a25:	c1 e3 08             	shl    $0x8,%ebx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	c1 e0 18             	shl    $0x18,%eax
  800a2d:	89 d6                	mov    %edx,%esi
  800a2f:	c1 e6 10             	shl    $0x10,%esi
  800a32:	09 f0                	or     %esi,%eax
  800a34:	09 c2                	or     %eax,%edx
  800a36:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a38:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a3b:	89 d0                	mov    %edx,%eax
  800a3d:	fc                   	cld    
  800a3e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a40:	eb d6                	jmp    800a18 <memset+0x23>

00800a42 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	57                   	push   %edi
  800a46:	56                   	push   %esi
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a50:	39 c6                	cmp    %eax,%esi
  800a52:	73 35                	jae    800a89 <memmove+0x47>
  800a54:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a57:	39 c2                	cmp    %eax,%edx
  800a59:	76 2e                	jbe    800a89 <memmove+0x47>
		s += n;
		d += n;
  800a5b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5e:	89 d6                	mov    %edx,%esi
  800a60:	09 fe                	or     %edi,%esi
  800a62:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a68:	74 0c                	je     800a76 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a6a:	83 ef 01             	sub    $0x1,%edi
  800a6d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a70:	fd                   	std    
  800a71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a73:	fc                   	cld    
  800a74:	eb 21                	jmp    800a97 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a76:	f6 c1 03             	test   $0x3,%cl
  800a79:	75 ef                	jne    800a6a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a7b:	83 ef 04             	sub    $0x4,%edi
  800a7e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a81:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a84:	fd                   	std    
  800a85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a87:	eb ea                	jmp    800a73 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a89:	89 f2                	mov    %esi,%edx
  800a8b:	09 c2                	or     %eax,%edx
  800a8d:	f6 c2 03             	test   $0x3,%dl
  800a90:	74 09                	je     800a9b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a92:	89 c7                	mov    %eax,%edi
  800a94:	fc                   	cld    
  800a95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a97:	5e                   	pop    %esi
  800a98:	5f                   	pop    %edi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9b:	f6 c1 03             	test   $0x3,%cl
  800a9e:	75 f2                	jne    800a92 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aa0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aa3:	89 c7                	mov    %eax,%edi
  800aa5:	fc                   	cld    
  800aa6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa8:	eb ed                	jmp    800a97 <memmove+0x55>

00800aaa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800aad:	ff 75 10             	pushl  0x10(%ebp)
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	ff 75 08             	pushl  0x8(%ebp)
  800ab6:	e8 87 ff ff ff       	call   800a42 <memmove>
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 c6                	mov    %eax,%esi
  800aca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acd:	39 f0                	cmp    %esi,%eax
  800acf:	74 1c                	je     800aed <memcmp+0x30>
		if (*s1 != *s2)
  800ad1:	0f b6 08             	movzbl (%eax),%ecx
  800ad4:	0f b6 1a             	movzbl (%edx),%ebx
  800ad7:	38 d9                	cmp    %bl,%cl
  800ad9:	75 08                	jne    800ae3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	83 c2 01             	add    $0x1,%edx
  800ae1:	eb ea                	jmp    800acd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ae3:	0f b6 c1             	movzbl %cl,%eax
  800ae6:	0f b6 db             	movzbl %bl,%ebx
  800ae9:	29 d8                	sub    %ebx,%eax
  800aeb:	eb 05                	jmp    800af2 <memcmp+0x35>
	}

	return 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b04:	39 d0                	cmp    %edx,%eax
  800b06:	73 09                	jae    800b11 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b08:	38 08                	cmp    %cl,(%eax)
  800b0a:	74 05                	je     800b11 <memfind+0x1b>
	for (; s < ends; s++)
  800b0c:	83 c0 01             	add    $0x1,%eax
  800b0f:	eb f3                	jmp    800b04 <memfind+0xe>
			break;
	return (void *) s;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1f:	eb 03                	jmp    800b24 <strtol+0x11>
		s++;
  800b21:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b24:	0f b6 01             	movzbl (%ecx),%eax
  800b27:	3c 20                	cmp    $0x20,%al
  800b29:	74 f6                	je     800b21 <strtol+0xe>
  800b2b:	3c 09                	cmp    $0x9,%al
  800b2d:	74 f2                	je     800b21 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b2f:	3c 2b                	cmp    $0x2b,%al
  800b31:	74 2e                	je     800b61 <strtol+0x4e>
	int neg = 0;
  800b33:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b38:	3c 2d                	cmp    $0x2d,%al
  800b3a:	74 2f                	je     800b6b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b42:	75 05                	jne    800b49 <strtol+0x36>
  800b44:	80 39 30             	cmpb   $0x30,(%ecx)
  800b47:	74 2c                	je     800b75 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b49:	85 db                	test   %ebx,%ebx
  800b4b:	75 0a                	jne    800b57 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b4d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b52:	80 39 30             	cmpb   $0x30,(%ecx)
  800b55:	74 28                	je     800b7f <strtol+0x6c>
		base = 10;
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b5f:	eb 50                	jmp    800bb1 <strtol+0x9e>
		s++;
  800b61:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b64:	bf 00 00 00 00       	mov    $0x0,%edi
  800b69:	eb d1                	jmp    800b3c <strtol+0x29>
		s++, neg = 1;
  800b6b:	83 c1 01             	add    $0x1,%ecx
  800b6e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b73:	eb c7                	jmp    800b3c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b75:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b79:	74 0e                	je     800b89 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b7b:	85 db                	test   %ebx,%ebx
  800b7d:	75 d8                	jne    800b57 <strtol+0x44>
		s++, base = 8;
  800b7f:	83 c1 01             	add    $0x1,%ecx
  800b82:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b87:	eb ce                	jmp    800b57 <strtol+0x44>
		s += 2, base = 16;
  800b89:	83 c1 02             	add    $0x2,%ecx
  800b8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b91:	eb c4                	jmp    800b57 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b93:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b96:	89 f3                	mov    %esi,%ebx
  800b98:	80 fb 19             	cmp    $0x19,%bl
  800b9b:	77 29                	ja     800bc6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b9d:	0f be d2             	movsbl %dl,%edx
  800ba0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba6:	7d 30                	jge    800bd8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ba8:	83 c1 01             	add    $0x1,%ecx
  800bab:	0f af 45 10          	imul   0x10(%ebp),%eax
  800baf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb1:	0f b6 11             	movzbl (%ecx),%edx
  800bb4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bb7:	89 f3                	mov    %esi,%ebx
  800bb9:	80 fb 09             	cmp    $0x9,%bl
  800bbc:	77 d5                	ja     800b93 <strtol+0x80>
			dig = *s - '0';
  800bbe:	0f be d2             	movsbl %dl,%edx
  800bc1:	83 ea 30             	sub    $0x30,%edx
  800bc4:	eb dd                	jmp    800ba3 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bc6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bc9:	89 f3                	mov    %esi,%ebx
  800bcb:	80 fb 19             	cmp    $0x19,%bl
  800bce:	77 08                	ja     800bd8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bd0:	0f be d2             	movsbl %dl,%edx
  800bd3:	83 ea 37             	sub    $0x37,%edx
  800bd6:	eb cb                	jmp    800ba3 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdc:	74 05                	je     800be3 <strtol+0xd0>
		*endptr = (char *) s;
  800bde:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be3:	89 c2                	mov    %eax,%edx
  800be5:	f7 da                	neg    %edx
  800be7:	85 ff                	test   %edi,%edi
  800be9:	0f 45 c2             	cmovne %edx,%eax
}
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5f                   	pop    %edi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c02:	89 c3                	mov    %eax,%ebx
  800c04:	89 c7                	mov    %eax,%edi
  800c06:	89 c6                	mov    %eax,%esi
  800c08:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0a:	5b                   	pop    %ebx
  800c0b:	5e                   	pop    %esi
  800c0c:	5f                   	pop    %edi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c15:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c1f:	89 d1                	mov    %edx,%ecx
  800c21:	89 d3                	mov    %edx,%ebx
  800c23:	89 d7                	mov    %edx,%edi
  800c25:	89 d6                	mov    %edx,%esi
  800c27:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c44:	89 cb                	mov    %ecx,%ebx
  800c46:	89 cf                	mov    %ecx,%edi
  800c48:	89 ce                	mov    %ecx,%esi
  800c4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4c:	85 c0                	test   %eax,%eax
  800c4e:	7f 08                	jg     800c58 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c5c:	6a 03                	push   $0x3
  800c5e:	68 7f 27 80 00       	push   $0x80277f
  800c63:	6a 23                	push   $0x23
  800c65:	68 9c 27 80 00       	push   $0x80279c
  800c6a:	e8 cd f4 ff ff       	call   80013c <_panic>

00800c6f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7f:	89 d1                	mov    %edx,%ecx
  800c81:	89 d3                	mov    %edx,%ebx
  800c83:	89 d7                	mov    %edx,%edi
  800c85:	89 d6                	mov    %edx,%esi
  800c87:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5f                   	pop    %edi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <sys_yield>:

void
sys_yield(void)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c9e:	89 d1                	mov    %edx,%ecx
  800ca0:	89 d3                	mov    %edx,%ebx
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb6:	be 00 00 00 00       	mov    $0x0,%esi
  800cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc9:	89 f7                	mov    %esi,%edi
  800ccb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	7f 08                	jg     800cd9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd9:	83 ec 0c             	sub    $0xc,%esp
  800cdc:	50                   	push   %eax
  800cdd:	6a 04                	push   $0x4
  800cdf:	68 7f 27 80 00       	push   $0x80277f
  800ce4:	6a 23                	push   $0x23
  800ce6:	68 9c 27 80 00       	push   $0x80279c
  800ceb:	e8 4c f4 ff ff       	call   80013c <_panic>

00800cf0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	b8 05 00 00 00       	mov    $0x5,%eax
  800d04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d07:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	7f 08                	jg     800d1b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1b:	83 ec 0c             	sub    $0xc,%esp
  800d1e:	50                   	push   %eax
  800d1f:	6a 05                	push   $0x5
  800d21:	68 7f 27 80 00       	push   $0x80277f
  800d26:	6a 23                	push   $0x23
  800d28:	68 9c 27 80 00       	push   $0x80279c
  800d2d:	e8 0a f4 ff ff       	call   80013c <_panic>

00800d32 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4b:	89 df                	mov    %ebx,%edi
  800d4d:	89 de                	mov    %ebx,%esi
  800d4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7f 08                	jg     800d5d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	50                   	push   %eax
  800d61:	6a 06                	push   $0x6
  800d63:	68 7f 27 80 00       	push   $0x80277f
  800d68:	6a 23                	push   $0x23
  800d6a:	68 9c 27 80 00       	push   $0x80279c
  800d6f:	e8 c8 f3 ff ff       	call   80013c <_panic>

00800d74 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
  800d7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d88:	b8 08 00 00 00       	mov    $0x8,%eax
  800d8d:	89 df                	mov    %ebx,%edi
  800d8f:	89 de                	mov    %ebx,%esi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 08                	push   $0x8
  800da5:	68 7f 27 80 00       	push   $0x80277f
  800daa:	6a 23                	push   $0x23
  800dac:	68 9c 27 80 00       	push   $0x80279c
  800db1:	e8 86 f3 ff ff       	call   80013c <_panic>

00800db6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcf:	89 df                	mov    %ebx,%edi
  800dd1:	89 de                	mov    %ebx,%esi
  800dd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	7f 08                	jg     800de1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	50                   	push   %eax
  800de5:	6a 09                	push   $0x9
  800de7:	68 7f 27 80 00       	push   $0x80277f
  800dec:	6a 23                	push   $0x23
  800dee:	68 9c 27 80 00       	push   $0x80279c
  800df3:	e8 44 f3 ff ff       	call   80013c <_panic>

00800df8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e11:	89 df                	mov    %ebx,%edi
  800e13:	89 de                	mov    %ebx,%esi
  800e15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7f 08                	jg     800e23 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	50                   	push   %eax
  800e27:	6a 0a                	push   $0xa
  800e29:	68 7f 27 80 00       	push   $0x80277f
  800e2e:	6a 23                	push   $0x23
  800e30:	68 9c 27 80 00       	push   $0x80279c
  800e35:	e8 02 f3 ff ff       	call   80013c <_panic>

00800e3a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e4b:	be 00 00 00 00       	mov    $0x0,%esi
  800e50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e53:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e56:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e73:	89 cb                	mov    %ecx,%ebx
  800e75:	89 cf                	mov    %ecx,%edi
  800e77:	89 ce                	mov    %ecx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 0d                	push   $0xd
  800e8d:	68 7f 27 80 00       	push   $0x80277f
  800e92:	6a 23                	push   $0x23
  800e94:	68 9c 27 80 00       	push   $0x80279c
  800e99:	e8 9e f2 ff ff       	call   80013c <_panic>

00800e9e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eae:	89 d1                	mov    %edx,%ecx
  800eb0:	89 d3                	mov    %edx,%ebx
  800eb2:	89 d7                	mov    %edx,%edi
  800eb4:	89 d6                	mov    %edx,%esi
  800eb6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	05 00 00 00 30       	add    $0x30000000,%eax
  800ec8:	c1 e8 0c             	shr    $0xc,%eax
}
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800edd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eea:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	c1 ea 16             	shr    $0x16,%edx
  800ef4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800efb:	f6 c2 01             	test   $0x1,%dl
  800efe:	74 2a                	je     800f2a <fd_alloc+0x46>
  800f00:	89 c2                	mov    %eax,%edx
  800f02:	c1 ea 0c             	shr    $0xc,%edx
  800f05:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f0c:	f6 c2 01             	test   $0x1,%dl
  800f0f:	74 19                	je     800f2a <fd_alloc+0x46>
  800f11:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f16:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f1b:	75 d2                	jne    800eef <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f1d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f23:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f28:	eb 07                	jmp    800f31 <fd_alloc+0x4d>
			*fd_store = fd;
  800f2a:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f39:	83 f8 1f             	cmp    $0x1f,%eax
  800f3c:	77 36                	ja     800f74 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f3e:	c1 e0 0c             	shl    $0xc,%eax
  800f41:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f46:	89 c2                	mov    %eax,%edx
  800f48:	c1 ea 16             	shr    $0x16,%edx
  800f4b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f52:	f6 c2 01             	test   $0x1,%dl
  800f55:	74 24                	je     800f7b <fd_lookup+0x48>
  800f57:	89 c2                	mov    %eax,%edx
  800f59:	c1 ea 0c             	shr    $0xc,%edx
  800f5c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f63:	f6 c2 01             	test   $0x1,%dl
  800f66:	74 1a                	je     800f82 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6b:	89 02                	mov    %eax,(%edx)
	return 0;
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    
		return -E_INVAL;
  800f74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f79:	eb f7                	jmp    800f72 <fd_lookup+0x3f>
		return -E_INVAL;
  800f7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f80:	eb f0                	jmp    800f72 <fd_lookup+0x3f>
  800f82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f87:	eb e9                	jmp    800f72 <fd_lookup+0x3f>

00800f89 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 08             	sub    $0x8,%esp
  800f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f92:	ba 28 28 80 00       	mov    $0x802828,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f97:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f9c:	39 08                	cmp    %ecx,(%eax)
  800f9e:	74 33                	je     800fd3 <dev_lookup+0x4a>
  800fa0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fa3:	8b 02                	mov    (%edx),%eax
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	75 f3                	jne    800f9c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fa9:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800fae:	8b 40 48             	mov    0x48(%eax),%eax
  800fb1:	83 ec 04             	sub    $0x4,%esp
  800fb4:	51                   	push   %ecx
  800fb5:	50                   	push   %eax
  800fb6:	68 ac 27 80 00       	push   $0x8027ac
  800fbb:	e8 57 f2 ff ff       	call   800217 <cprintf>
	*dev = 0;
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fc9:	83 c4 10             	add    $0x10,%esp
  800fcc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    
			*dev = devtab[i];
  800fd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd6:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdd:	eb f2                	jmp    800fd1 <dev_lookup+0x48>

00800fdf <fd_close>:
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	57                   	push   %edi
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
  800fe5:	83 ec 1c             	sub    $0x1c,%esp
  800fe8:	8b 75 08             	mov    0x8(%ebp),%esi
  800feb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ff8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ffb:	50                   	push   %eax
  800ffc:	e8 32 ff ff ff       	call   800f33 <fd_lookup>
  801001:	89 c3                	mov    %eax,%ebx
  801003:	83 c4 08             	add    $0x8,%esp
  801006:	85 c0                	test   %eax,%eax
  801008:	78 05                	js     80100f <fd_close+0x30>
	    || fd != fd2)
  80100a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80100d:	74 16                	je     801025 <fd_close+0x46>
		return (must_exist ? r : 0);
  80100f:	89 f8                	mov    %edi,%eax
  801011:	84 c0                	test   %al,%al
  801013:	b8 00 00 00 00       	mov    $0x0,%eax
  801018:	0f 44 d8             	cmove  %eax,%ebx
}
  80101b:	89 d8                	mov    %ebx,%eax
  80101d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80102b:	50                   	push   %eax
  80102c:	ff 36                	pushl  (%esi)
  80102e:	e8 56 ff ff ff       	call   800f89 <dev_lookup>
  801033:	89 c3                	mov    %eax,%ebx
  801035:	83 c4 10             	add    $0x10,%esp
  801038:	85 c0                	test   %eax,%eax
  80103a:	78 15                	js     801051 <fd_close+0x72>
		if (dev->dev_close)
  80103c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103f:	8b 40 10             	mov    0x10(%eax),%eax
  801042:	85 c0                	test   %eax,%eax
  801044:	74 1b                	je     801061 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	56                   	push   %esi
  80104a:	ff d0                	call   *%eax
  80104c:	89 c3                	mov    %eax,%ebx
  80104e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	56                   	push   %esi
  801055:	6a 00                	push   $0x0
  801057:	e8 d6 fc ff ff       	call   800d32 <sys_page_unmap>
	return r;
  80105c:	83 c4 10             	add    $0x10,%esp
  80105f:	eb ba                	jmp    80101b <fd_close+0x3c>
			r = 0;
  801061:	bb 00 00 00 00       	mov    $0x0,%ebx
  801066:	eb e9                	jmp    801051 <fd_close+0x72>

00801068 <close>:

int
close(int fdnum)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80106e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	ff 75 08             	pushl  0x8(%ebp)
  801075:	e8 b9 fe ff ff       	call   800f33 <fd_lookup>
  80107a:	83 c4 08             	add    $0x8,%esp
  80107d:	85 c0                	test   %eax,%eax
  80107f:	78 10                	js     801091 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	6a 01                	push   $0x1
  801086:	ff 75 f4             	pushl  -0xc(%ebp)
  801089:	e8 51 ff ff ff       	call   800fdf <fd_close>
  80108e:	83 c4 10             	add    $0x10,%esp
}
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <close_all>:

void
close_all(void)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	53                   	push   %ebx
  801097:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80109a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80109f:	83 ec 0c             	sub    $0xc,%esp
  8010a2:	53                   	push   %ebx
  8010a3:	e8 c0 ff ff ff       	call   801068 <close>
	for (i = 0; i < MAXFD; i++)
  8010a8:	83 c3 01             	add    $0x1,%ebx
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	83 fb 20             	cmp    $0x20,%ebx
  8010b1:	75 ec                	jne    80109f <close_all+0xc>
}
  8010b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	57                   	push   %edi
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
  8010be:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c4:	50                   	push   %eax
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	e8 66 fe ff ff       	call   800f33 <fd_lookup>
  8010cd:	89 c3                	mov    %eax,%ebx
  8010cf:	83 c4 08             	add    $0x8,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	0f 88 81 00 00 00    	js     80115b <dup+0xa3>
		return r;
	close(newfdnum);
  8010da:	83 ec 0c             	sub    $0xc,%esp
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	e8 83 ff ff ff       	call   801068 <close>

	newfd = INDEX2FD(newfdnum);
  8010e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e8:	c1 e6 0c             	shl    $0xc,%esi
  8010eb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010f1:	83 c4 04             	add    $0x4,%esp
  8010f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f7:	e8 d1 fd ff ff       	call   800ecd <fd2data>
  8010fc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010fe:	89 34 24             	mov    %esi,(%esp)
  801101:	e8 c7 fd ff ff       	call   800ecd <fd2data>
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	c1 e8 16             	shr    $0x16,%eax
  801110:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 11                	je     80112c <dup+0x74>
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	c1 e8 0c             	shr    $0xc,%eax
  801120:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801127:	f6 c2 01             	test   $0x1,%dl
  80112a:	75 39                	jne    801165 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80112c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80112f:	89 d0                	mov    %edx,%eax
  801131:	c1 e8 0c             	shr    $0xc,%eax
  801134:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113b:	83 ec 0c             	sub    $0xc,%esp
  80113e:	25 07 0e 00 00       	and    $0xe07,%eax
  801143:	50                   	push   %eax
  801144:	56                   	push   %esi
  801145:	6a 00                	push   $0x0
  801147:	52                   	push   %edx
  801148:	6a 00                	push   $0x0
  80114a:	e8 a1 fb ff ff       	call   800cf0 <sys_page_map>
  80114f:	89 c3                	mov    %eax,%ebx
  801151:	83 c4 20             	add    $0x20,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	78 31                	js     801189 <dup+0xd1>
		goto err;

	return newfdnum;
  801158:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801160:	5b                   	pop    %ebx
  801161:	5e                   	pop    %esi
  801162:	5f                   	pop    %edi
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801165:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	25 07 0e 00 00       	and    $0xe07,%eax
  801174:	50                   	push   %eax
  801175:	57                   	push   %edi
  801176:	6a 00                	push   $0x0
  801178:	53                   	push   %ebx
  801179:	6a 00                	push   $0x0
  80117b:	e8 70 fb ff ff       	call   800cf0 <sys_page_map>
  801180:	89 c3                	mov    %eax,%ebx
  801182:	83 c4 20             	add    $0x20,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	79 a3                	jns    80112c <dup+0x74>
	sys_page_unmap(0, newfd);
  801189:	83 ec 08             	sub    $0x8,%esp
  80118c:	56                   	push   %esi
  80118d:	6a 00                	push   $0x0
  80118f:	e8 9e fb ff ff       	call   800d32 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801194:	83 c4 08             	add    $0x8,%esp
  801197:	57                   	push   %edi
  801198:	6a 00                	push   $0x0
  80119a:	e8 93 fb ff ff       	call   800d32 <sys_page_unmap>
	return r;
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	eb b7                	jmp    80115b <dup+0xa3>

008011a4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	53                   	push   %ebx
  8011a8:	83 ec 14             	sub    $0x14,%esp
  8011ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b1:	50                   	push   %eax
  8011b2:	53                   	push   %ebx
  8011b3:	e8 7b fd ff ff       	call   800f33 <fd_lookup>
  8011b8:	83 c4 08             	add    $0x8,%esp
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	78 3f                	js     8011fe <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c5:	50                   	push   %eax
  8011c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c9:	ff 30                	pushl  (%eax)
  8011cb:	e8 b9 fd ff ff       	call   800f89 <dev_lookup>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	78 27                	js     8011fe <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011da:	8b 42 08             	mov    0x8(%edx),%eax
  8011dd:	83 e0 03             	and    $0x3,%eax
  8011e0:	83 f8 01             	cmp    $0x1,%eax
  8011e3:	74 1e                	je     801203 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e8:	8b 40 08             	mov    0x8(%eax),%eax
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	74 35                	je     801224 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011ef:	83 ec 04             	sub    $0x4,%esp
  8011f2:	ff 75 10             	pushl  0x10(%ebp)
  8011f5:	ff 75 0c             	pushl  0xc(%ebp)
  8011f8:	52                   	push   %edx
  8011f9:	ff d0                	call   *%eax
  8011fb:	83 c4 10             	add    $0x10,%esp
}
  8011fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801201:	c9                   	leave  
  801202:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801203:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801208:	8b 40 48             	mov    0x48(%eax),%eax
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	53                   	push   %ebx
  80120f:	50                   	push   %eax
  801210:	68 ed 27 80 00       	push   $0x8027ed
  801215:	e8 fd ef ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801222:	eb da                	jmp    8011fe <read+0x5a>
		return -E_NOT_SUPP;
  801224:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801229:	eb d3                	jmp    8011fe <read+0x5a>

0080122b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	57                   	push   %edi
  80122f:	56                   	push   %esi
  801230:	53                   	push   %ebx
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	8b 7d 08             	mov    0x8(%ebp),%edi
  801237:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80123a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123f:	39 f3                	cmp    %esi,%ebx
  801241:	73 25                	jae    801268 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	89 f0                	mov    %esi,%eax
  801248:	29 d8                	sub    %ebx,%eax
  80124a:	50                   	push   %eax
  80124b:	89 d8                	mov    %ebx,%eax
  80124d:	03 45 0c             	add    0xc(%ebp),%eax
  801250:	50                   	push   %eax
  801251:	57                   	push   %edi
  801252:	e8 4d ff ff ff       	call   8011a4 <read>
		if (m < 0)
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	85 c0                	test   %eax,%eax
  80125c:	78 08                	js     801266 <readn+0x3b>
			return m;
		if (m == 0)
  80125e:	85 c0                	test   %eax,%eax
  801260:	74 06                	je     801268 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801262:	01 c3                	add    %eax,%ebx
  801264:	eb d9                	jmp    80123f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801266:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801268:	89 d8                	mov    %ebx,%eax
  80126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126d:	5b                   	pop    %ebx
  80126e:	5e                   	pop    %esi
  80126f:	5f                   	pop    %edi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	53                   	push   %ebx
  801276:	83 ec 14             	sub    $0x14,%esp
  801279:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80127c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80127f:	50                   	push   %eax
  801280:	53                   	push   %ebx
  801281:	e8 ad fc ff ff       	call   800f33 <fd_lookup>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	78 3a                	js     8012c7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128d:	83 ec 08             	sub    $0x8,%esp
  801290:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801297:	ff 30                	pushl  (%eax)
  801299:	e8 eb fc ff ff       	call   800f89 <dev_lookup>
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	78 22                	js     8012c7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ac:	74 1e                	je     8012cc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8012b4:	85 d2                	test   %edx,%edx
  8012b6:	74 35                	je     8012ed <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	ff 75 10             	pushl  0x10(%ebp)
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff d2                	call   *%edx
  8012c4:	83 c4 10             	add    $0x10,%esp
}
  8012c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012cc:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8012d1:	8b 40 48             	mov    0x48(%eax),%eax
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	53                   	push   %ebx
  8012d8:	50                   	push   %eax
  8012d9:	68 09 28 80 00       	push   $0x802809
  8012de:	e8 34 ef ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012eb:	eb da                	jmp    8012c7 <write+0x55>
		return -E_NOT_SUPP;
  8012ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f2:	eb d3                	jmp    8012c7 <write+0x55>

008012f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012fd:	50                   	push   %eax
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	e8 2d fc ff ff       	call   800f33 <fd_lookup>
  801306:	83 c4 08             	add    $0x8,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 0e                	js     80131b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80130d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	53                   	push   %ebx
  801321:	83 ec 14             	sub    $0x14,%esp
  801324:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801327:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132a:	50                   	push   %eax
  80132b:	53                   	push   %ebx
  80132c:	e8 02 fc ff ff       	call   800f33 <fd_lookup>
  801331:	83 c4 08             	add    $0x8,%esp
  801334:	85 c0                	test   %eax,%eax
  801336:	78 37                	js     80136f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801338:	83 ec 08             	sub    $0x8,%esp
  80133b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801342:	ff 30                	pushl  (%eax)
  801344:	e8 40 fc ff ff       	call   800f89 <dev_lookup>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 1f                	js     80136f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801353:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801357:	74 1b                	je     801374 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801359:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135c:	8b 52 18             	mov    0x18(%edx),%edx
  80135f:	85 d2                	test   %edx,%edx
  801361:	74 32                	je     801395 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	ff 75 0c             	pushl  0xc(%ebp)
  801369:	50                   	push   %eax
  80136a:	ff d2                	call   *%edx
  80136c:	83 c4 10             	add    $0x10,%esp
}
  80136f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801372:	c9                   	leave  
  801373:	c3                   	ret    
			thisenv->env_id, fdnum);
  801374:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801379:	8b 40 48             	mov    0x48(%eax),%eax
  80137c:	83 ec 04             	sub    $0x4,%esp
  80137f:	53                   	push   %ebx
  801380:	50                   	push   %eax
  801381:	68 cc 27 80 00       	push   $0x8027cc
  801386:	e8 8c ee ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801393:	eb da                	jmp    80136f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801395:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139a:	eb d3                	jmp    80136f <ftruncate+0x52>

0080139c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	53                   	push   %ebx
  8013a0:	83 ec 14             	sub    $0x14,%esp
  8013a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	e8 81 fb ff ff       	call   800f33 <fd_lookup>
  8013b2:	83 c4 08             	add    $0x8,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 4b                	js     801404 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	ff 30                	pushl  (%eax)
  8013c5:	e8 bf fb ff ff       	call   800f89 <dev_lookup>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 33                	js     801404 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013d8:	74 2f                	je     801409 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e4:	00 00 00 
	stat->st_isdir = 0;
  8013e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013ee:	00 00 00 
	stat->st_dev = dev;
  8013f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f7:	83 ec 08             	sub    $0x8,%esp
  8013fa:	53                   	push   %ebx
  8013fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8013fe:	ff 50 14             	call   *0x14(%eax)
  801401:	83 c4 10             	add    $0x10,%esp
}
  801404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801407:	c9                   	leave  
  801408:	c3                   	ret    
		return -E_NOT_SUPP;
  801409:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140e:	eb f4                	jmp    801404 <fstat+0x68>

00801410 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	56                   	push   %esi
  801414:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	6a 00                	push   $0x0
  80141a:	ff 75 08             	pushl  0x8(%ebp)
  80141d:	e8 26 02 00 00       	call   801648 <open>
  801422:	89 c3                	mov    %eax,%ebx
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 1b                	js     801446 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	50                   	push   %eax
  801432:	e8 65 ff ff ff       	call   80139c <fstat>
  801437:	89 c6                	mov    %eax,%esi
	close(fd);
  801439:	89 1c 24             	mov    %ebx,(%esp)
  80143c:	e8 27 fc ff ff       	call   801068 <close>
	return r;
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	89 f3                	mov    %esi,%ebx
}
  801446:	89 d8                	mov    %ebx,%eax
  801448:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80144b:	5b                   	pop    %ebx
  80144c:	5e                   	pop    %esi
  80144d:	5d                   	pop    %ebp
  80144e:	c3                   	ret    

0080144f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	56                   	push   %esi
  801453:	53                   	push   %ebx
  801454:	89 c6                	mov    %eax,%esi
  801456:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801458:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80145f:	74 27                	je     801488 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801461:	6a 07                	push   $0x7
  801463:	68 00 50 c0 00       	push   $0xc05000
  801468:	56                   	push   %esi
  801469:	ff 35 00 40 80 00    	pushl  0x804000
  80146f:	e8 11 0c 00 00       	call   802085 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801474:	83 c4 0c             	add    $0xc,%esp
  801477:	6a 00                	push   $0x0
  801479:	53                   	push   %ebx
  80147a:	6a 00                	push   $0x0
  80147c:	e8 9b 0b 00 00       	call   80201c <ipc_recv>
}
  801481:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801484:	5b                   	pop    %ebx
  801485:	5e                   	pop    %esi
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	6a 01                	push   $0x1
  80148d:	e8 4c 0c 00 00       	call   8020de <ipc_find_env>
  801492:	a3 00 40 80 00       	mov    %eax,0x804000
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	eb c5                	jmp    801461 <fsipc+0x12>

0080149c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a8:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8014ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b0:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8014bf:	e8 8b ff ff ff       	call   80144f <fsipc>
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <devfile_flush>:
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d2:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014dc:	b8 06 00 00 00       	mov    $0x6,%eax
  8014e1:	e8 69 ff ff ff       	call   80144f <fsipc>
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <devfile_stat>:
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	53                   	push   %ebx
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f8:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	b8 05 00 00 00       	mov    $0x5,%eax
  801507:	e8 43 ff ff ff       	call   80144f <fsipc>
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 2c                	js     80153c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801510:	83 ec 08             	sub    $0x8,%esp
  801513:	68 00 50 c0 00       	push   $0xc05000
  801518:	53                   	push   %ebx
  801519:	e8 96 f3 ff ff       	call   8008b4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80151e:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801523:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801529:	a1 84 50 c0 00       	mov    0xc05084,%eax
  80152e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <devfile_write>:
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	53                   	push   %ebx
  801545:	83 ec 04             	sub    $0x4,%esp
  801548:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8b 40 0c             	mov    0xc(%eax),%eax
  801551:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.write.req_n = n;
  801556:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80155c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801562:	77 30                	ja     801594 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	53                   	push   %ebx
  801568:	ff 75 0c             	pushl  0xc(%ebp)
  80156b:	68 08 50 c0 00       	push   $0xc05008
  801570:	e8 cd f4 ff ff       	call   800a42 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	b8 04 00 00 00       	mov    $0x4,%eax
  80157f:	e8 cb fe ff ff       	call   80144f <fsipc>
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	85 c0                	test   %eax,%eax
  801589:	78 04                	js     80158f <devfile_write+0x4e>
	assert(r <= n);
  80158b:	39 d8                	cmp    %ebx,%eax
  80158d:	77 1e                	ja     8015ad <devfile_write+0x6c>
}
  80158f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801592:	c9                   	leave  
  801593:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801594:	68 3c 28 80 00       	push   $0x80283c
  801599:	68 6c 28 80 00       	push   $0x80286c
  80159e:	68 94 00 00 00       	push   $0x94
  8015a3:	68 81 28 80 00       	push   $0x802881
  8015a8:	e8 8f eb ff ff       	call   80013c <_panic>
	assert(r <= n);
  8015ad:	68 8c 28 80 00       	push   $0x80288c
  8015b2:	68 6c 28 80 00       	push   $0x80286c
  8015b7:	68 98 00 00 00       	push   $0x98
  8015bc:	68 81 28 80 00       	push   $0x802881
  8015c1:	e8 76 eb ff ff       	call   80013c <_panic>

008015c6 <devfile_read>:
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d4:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8015d9:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015df:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8015e9:	e8 61 fe ff ff       	call   80144f <fsipc>
  8015ee:	89 c3                	mov    %eax,%ebx
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 1f                	js     801613 <devfile_read+0x4d>
	assert(r <= n);
  8015f4:	39 f0                	cmp    %esi,%eax
  8015f6:	77 24                	ja     80161c <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015fd:	7f 33                	jg     801632 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	50                   	push   %eax
  801603:	68 00 50 c0 00       	push   $0xc05000
  801608:	ff 75 0c             	pushl  0xc(%ebp)
  80160b:	e8 32 f4 ff ff       	call   800a42 <memmove>
	return r;
  801610:	83 c4 10             	add    $0x10,%esp
}
  801613:	89 d8                	mov    %ebx,%eax
  801615:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    
	assert(r <= n);
  80161c:	68 8c 28 80 00       	push   $0x80288c
  801621:	68 6c 28 80 00       	push   $0x80286c
  801626:	6a 7c                	push   $0x7c
  801628:	68 81 28 80 00       	push   $0x802881
  80162d:	e8 0a eb ff ff       	call   80013c <_panic>
	assert(r <= PGSIZE);
  801632:	68 93 28 80 00       	push   $0x802893
  801637:	68 6c 28 80 00       	push   $0x80286c
  80163c:	6a 7d                	push   $0x7d
  80163e:	68 81 28 80 00       	push   $0x802881
  801643:	e8 f4 ea ff ff       	call   80013c <_panic>

00801648 <open>:
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	56                   	push   %esi
  80164c:	53                   	push   %ebx
  80164d:	83 ec 1c             	sub    $0x1c,%esp
  801650:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801653:	56                   	push   %esi
  801654:	e8 24 f2 ff ff       	call   80087d <strlen>
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801661:	7f 6c                	jg     8016cf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801663:	83 ec 0c             	sub    $0xc,%esp
  801666:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801669:	50                   	push   %eax
  80166a:	e8 75 f8 ff ff       	call   800ee4 <fd_alloc>
  80166f:	89 c3                	mov    %eax,%ebx
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 3c                	js     8016b4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	56                   	push   %esi
  80167c:	68 00 50 c0 00       	push   $0xc05000
  801681:	e8 2e f2 ff ff       	call   8008b4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80168e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801691:	b8 01 00 00 00       	mov    $0x1,%eax
  801696:	e8 b4 fd ff ff       	call   80144f <fsipc>
  80169b:	89 c3                	mov    %eax,%ebx
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 19                	js     8016bd <open+0x75>
	return fd2num(fd);
  8016a4:	83 ec 0c             	sub    $0xc,%esp
  8016a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016aa:	e8 0e f8 ff ff       	call   800ebd <fd2num>
  8016af:	89 c3                	mov    %eax,%ebx
  8016b1:	83 c4 10             	add    $0x10,%esp
}
  8016b4:	89 d8                	mov    %ebx,%eax
  8016b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b9:	5b                   	pop    %ebx
  8016ba:	5e                   	pop    %esi
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    
		fd_close(fd, 0);
  8016bd:	83 ec 08             	sub    $0x8,%esp
  8016c0:	6a 00                	push   $0x0
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	e8 15 f9 ff ff       	call   800fdf <fd_close>
		return r;
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	eb e5                	jmp    8016b4 <open+0x6c>
		return -E_BAD_PATH;
  8016cf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016d4:	eb de                	jmp    8016b4 <open+0x6c>

008016d6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8016e6:	e8 64 fd ff ff       	call   80144f <fsipc>
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 cd f7 ff ff       	call   800ecd <fd2data>
  801700:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801702:	83 c4 08             	add    $0x8,%esp
  801705:	68 9f 28 80 00       	push   $0x80289f
  80170a:	53                   	push   %ebx
  80170b:	e8 a4 f1 ff ff       	call   8008b4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801710:	8b 46 04             	mov    0x4(%esi),%eax
  801713:	2b 06                	sub    (%esi),%eax
  801715:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80171b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801722:	00 00 00 
	stat->st_dev = &devpipe;
  801725:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80172c:	30 80 00 
	return 0;
}
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
  801734:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    

0080173b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	53                   	push   %ebx
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801745:	53                   	push   %ebx
  801746:	6a 00                	push   $0x0
  801748:	e8 e5 f5 ff ff       	call   800d32 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80174d:	89 1c 24             	mov    %ebx,(%esp)
  801750:	e8 78 f7 ff ff       	call   800ecd <fd2data>
  801755:	83 c4 08             	add    $0x8,%esp
  801758:	50                   	push   %eax
  801759:	6a 00                	push   $0x0
  80175b:	e8 d2 f5 ff ff       	call   800d32 <sys_page_unmap>
}
  801760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <_pipeisclosed>:
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	57                   	push   %edi
  801769:	56                   	push   %esi
  80176a:	53                   	push   %ebx
  80176b:	83 ec 1c             	sub    $0x1c,%esp
  80176e:	89 c7                	mov    %eax,%edi
  801770:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801772:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801777:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	57                   	push   %edi
  80177e:	e8 94 09 00 00       	call   802117 <pageref>
  801783:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801786:	89 34 24             	mov    %esi,(%esp)
  801789:	e8 89 09 00 00       	call   802117 <pageref>
		nn = thisenv->env_runs;
  80178e:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801794:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	39 cb                	cmp    %ecx,%ebx
  80179c:	74 1b                	je     8017b9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80179e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017a1:	75 cf                	jne    801772 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017a3:	8b 42 58             	mov    0x58(%edx),%eax
  8017a6:	6a 01                	push   $0x1
  8017a8:	50                   	push   %eax
  8017a9:	53                   	push   %ebx
  8017aa:	68 a6 28 80 00       	push   $0x8028a6
  8017af:	e8 63 ea ff ff       	call   800217 <cprintf>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	eb b9                	jmp    801772 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017b9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017bc:	0f 94 c0             	sete   %al
  8017bf:	0f b6 c0             	movzbl %al,%eax
}
  8017c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c5:	5b                   	pop    %ebx
  8017c6:	5e                   	pop    %esi
  8017c7:	5f                   	pop    %edi
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <devpipe_write>:
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	57                   	push   %edi
  8017ce:	56                   	push   %esi
  8017cf:	53                   	push   %ebx
  8017d0:	83 ec 28             	sub    $0x28,%esp
  8017d3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017d6:	56                   	push   %esi
  8017d7:	e8 f1 f6 ff ff       	call   800ecd <fd2data>
  8017dc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8017e6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017e9:	74 4f                	je     80183a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8017ee:	8b 0b                	mov    (%ebx),%ecx
  8017f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8017f3:	39 d0                	cmp    %edx,%eax
  8017f5:	72 14                	jb     80180b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8017f7:	89 da                	mov    %ebx,%edx
  8017f9:	89 f0                	mov    %esi,%eax
  8017fb:	e8 65 ff ff ff       	call   801765 <_pipeisclosed>
  801800:	85 c0                	test   %eax,%eax
  801802:	75 3a                	jne    80183e <devpipe_write+0x74>
			sys_yield();
  801804:	e8 85 f4 ff ff       	call   800c8e <sys_yield>
  801809:	eb e0                	jmp    8017eb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80180b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801812:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801815:	89 c2                	mov    %eax,%edx
  801817:	c1 fa 1f             	sar    $0x1f,%edx
  80181a:	89 d1                	mov    %edx,%ecx
  80181c:	c1 e9 1b             	shr    $0x1b,%ecx
  80181f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801822:	83 e2 1f             	and    $0x1f,%edx
  801825:	29 ca                	sub    %ecx,%edx
  801827:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80182b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80182f:	83 c0 01             	add    $0x1,%eax
  801832:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801835:	83 c7 01             	add    $0x1,%edi
  801838:	eb ac                	jmp    8017e6 <devpipe_write+0x1c>
	return i;
  80183a:	89 f8                	mov    %edi,%eax
  80183c:	eb 05                	jmp    801843 <devpipe_write+0x79>
				return 0;
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801843:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801846:	5b                   	pop    %ebx
  801847:	5e                   	pop    %esi
  801848:	5f                   	pop    %edi
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <devpipe_read>:
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	57                   	push   %edi
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 18             	sub    $0x18,%esp
  801854:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801857:	57                   	push   %edi
  801858:	e8 70 f6 ff ff       	call   800ecd <fd2data>
  80185d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	be 00 00 00 00       	mov    $0x0,%esi
  801867:	3b 75 10             	cmp    0x10(%ebp),%esi
  80186a:	74 47                	je     8018b3 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80186c:	8b 03                	mov    (%ebx),%eax
  80186e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801871:	75 22                	jne    801895 <devpipe_read+0x4a>
			if (i > 0)
  801873:	85 f6                	test   %esi,%esi
  801875:	75 14                	jne    80188b <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801877:	89 da                	mov    %ebx,%edx
  801879:	89 f8                	mov    %edi,%eax
  80187b:	e8 e5 fe ff ff       	call   801765 <_pipeisclosed>
  801880:	85 c0                	test   %eax,%eax
  801882:	75 33                	jne    8018b7 <devpipe_read+0x6c>
			sys_yield();
  801884:	e8 05 f4 ff ff       	call   800c8e <sys_yield>
  801889:	eb e1                	jmp    80186c <devpipe_read+0x21>
				return i;
  80188b:	89 f0                	mov    %esi,%eax
}
  80188d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801890:	5b                   	pop    %ebx
  801891:	5e                   	pop    %esi
  801892:	5f                   	pop    %edi
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801895:	99                   	cltd   
  801896:	c1 ea 1b             	shr    $0x1b,%edx
  801899:	01 d0                	add    %edx,%eax
  80189b:	83 e0 1f             	and    $0x1f,%eax
  80189e:	29 d0                	sub    %edx,%eax
  8018a0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018ab:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8018ae:	83 c6 01             	add    $0x1,%esi
  8018b1:	eb b4                	jmp    801867 <devpipe_read+0x1c>
	return i;
  8018b3:	89 f0                	mov    %esi,%eax
  8018b5:	eb d6                	jmp    80188d <devpipe_read+0x42>
				return 0;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	eb cf                	jmp    80188d <devpipe_read+0x42>

008018be <pipe>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c9:	50                   	push   %eax
  8018ca:	e8 15 f6 ff ff       	call   800ee4 <fd_alloc>
  8018cf:	89 c3                	mov    %eax,%ebx
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 5b                	js     801933 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	68 07 04 00 00       	push   $0x407
  8018e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e3:	6a 00                	push   $0x0
  8018e5:	e8 c3 f3 ff ff       	call   800cad <sys_page_alloc>
  8018ea:	89 c3                	mov    %eax,%ebx
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 40                	js     801933 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8018f3:	83 ec 0c             	sub    $0xc,%esp
  8018f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f9:	50                   	push   %eax
  8018fa:	e8 e5 f5 ff ff       	call   800ee4 <fd_alloc>
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	78 1b                	js     801923 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 07 04 00 00       	push   $0x407
  801910:	ff 75 f0             	pushl  -0x10(%ebp)
  801913:	6a 00                	push   $0x0
  801915:	e8 93 f3 ff ff       	call   800cad <sys_page_alloc>
  80191a:	89 c3                	mov    %eax,%ebx
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	85 c0                	test   %eax,%eax
  801921:	79 19                	jns    80193c <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801923:	83 ec 08             	sub    $0x8,%esp
  801926:	ff 75 f4             	pushl  -0xc(%ebp)
  801929:	6a 00                	push   $0x0
  80192b:	e8 02 f4 ff ff       	call   800d32 <sys_page_unmap>
  801930:	83 c4 10             	add    $0x10,%esp
}
  801933:	89 d8                	mov    %ebx,%eax
  801935:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    
	va = fd2data(fd0);
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	ff 75 f4             	pushl  -0xc(%ebp)
  801942:	e8 86 f5 ff ff       	call   800ecd <fd2data>
  801947:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801949:	83 c4 0c             	add    $0xc,%esp
  80194c:	68 07 04 00 00       	push   $0x407
  801951:	50                   	push   %eax
  801952:	6a 00                	push   $0x0
  801954:	e8 54 f3 ff ff       	call   800cad <sys_page_alloc>
  801959:	89 c3                	mov    %eax,%ebx
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	0f 88 8c 00 00 00    	js     8019f2 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801966:	83 ec 0c             	sub    $0xc,%esp
  801969:	ff 75 f0             	pushl  -0x10(%ebp)
  80196c:	e8 5c f5 ff ff       	call   800ecd <fd2data>
  801971:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801978:	50                   	push   %eax
  801979:	6a 00                	push   $0x0
  80197b:	56                   	push   %esi
  80197c:	6a 00                	push   $0x0
  80197e:	e8 6d f3 ff ff       	call   800cf0 <sys_page_map>
  801983:	89 c3                	mov    %eax,%ebx
  801985:	83 c4 20             	add    $0x20,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 58                	js     8019e4 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80198c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801995:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019aa:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8019ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019af:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bc:	e8 fc f4 ff ff       	call   800ebd <fd2num>
  8019c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019c6:	83 c4 04             	add    $0x4,%esp
  8019c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019cc:	e8 ec f4 ff ff       	call   800ebd <fd2num>
  8019d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019d4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019df:	e9 4f ff ff ff       	jmp    801933 <pipe+0x75>
	sys_page_unmap(0, va);
  8019e4:	83 ec 08             	sub    $0x8,%esp
  8019e7:	56                   	push   %esi
  8019e8:	6a 00                	push   $0x0
  8019ea:	e8 43 f3 ff ff       	call   800d32 <sys_page_unmap>
  8019ef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f8:	6a 00                	push   $0x0
  8019fa:	e8 33 f3 ff ff       	call   800d32 <sys_page_unmap>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	e9 1c ff ff ff       	jmp    801923 <pipe+0x65>

00801a07 <pipeisclosed>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a10:	50                   	push   %eax
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	e8 1a f5 ff ff       	call   800f33 <fd_lookup>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 18                	js     801a38 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a20:	83 ec 0c             	sub    $0xc,%esp
  801a23:	ff 75 f4             	pushl  -0xc(%ebp)
  801a26:	e8 a2 f4 ff ff       	call   800ecd <fd2data>
	return _pipeisclosed(fd, p);
  801a2b:	89 c2                	mov    %eax,%edx
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	e8 30 fd ff ff       	call   801765 <_pipeisclosed>
  801a35:	83 c4 10             	add    $0x10,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a40:	68 be 28 80 00       	push   $0x8028be
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	e8 67 ee ff ff       	call   8008b4 <strcpy>
	return 0;
}
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <devsock_close>:
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	53                   	push   %ebx
  801a58:	83 ec 10             	sub    $0x10,%esp
  801a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a5e:	53                   	push   %ebx
  801a5f:	e8 b3 06 00 00       	call   802117 <pageref>
  801a64:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a67:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a6c:	83 f8 01             	cmp    $0x1,%eax
  801a6f:	74 07                	je     801a78 <devsock_close+0x24>
}
  801a71:	89 d0                	mov    %edx,%eax
  801a73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	ff 73 0c             	pushl  0xc(%ebx)
  801a7e:	e8 b7 02 00 00       	call   801d3a <nsipc_close>
  801a83:	89 c2                	mov    %eax,%edx
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	eb e7                	jmp    801a71 <devsock_close+0x1d>

00801a8a <devsock_write>:
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	ff 75 10             	pushl  0x10(%ebp)
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	ff 70 0c             	pushl  0xc(%eax)
  801a9e:	e8 74 03 00 00       	call   801e17 <nsipc_send>
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <devsock_read>:
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 10             	pushl  0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	ff 70 0c             	pushl  0xc(%eax)
  801ab9:	e8 ed 02 00 00       	call   801dab <nsipc_recv>
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <fd2sockid>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ac6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	e8 63 f4 ff ff       	call   800f33 <fd_lookup>
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 10                	js     801ae7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ada:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ae0:	39 08                	cmp    %ecx,(%eax)
  801ae2:	75 05                	jne    801ae9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ae4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    
		return -E_NOT_SUPP;
  801ae9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aee:	eb f7                	jmp    801ae7 <fd2sockid+0x27>

00801af0 <alloc_sockfd>:
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
  801af5:	83 ec 1c             	sub    $0x1c,%esp
  801af8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801afa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afd:	50                   	push   %eax
  801afe:	e8 e1 f3 ff ff       	call   800ee4 <fd_alloc>
  801b03:	89 c3                	mov    %eax,%ebx
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	78 43                	js     801b4f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	68 07 04 00 00       	push   $0x407
  801b14:	ff 75 f4             	pushl  -0xc(%ebp)
  801b17:	6a 00                	push   $0x0
  801b19:	e8 8f f1 ff ff       	call   800cad <sys_page_alloc>
  801b1e:	89 c3                	mov    %eax,%ebx
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 28                	js     801b4f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b30:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b3c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	50                   	push   %eax
  801b43:	e8 75 f3 ff ff       	call   800ebd <fd2num>
  801b48:	89 c3                	mov    %eax,%ebx
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	eb 0c                	jmp    801b5b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	56                   	push   %esi
  801b53:	e8 e2 01 00 00       	call   801d3a <nsipc_close>
		return r;
  801b58:	83 c4 10             	add    $0x10,%esp
}
  801b5b:	89 d8                	mov    %ebx,%eax
  801b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b60:	5b                   	pop    %ebx
  801b61:	5e                   	pop    %esi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    

00801b64 <accept>:
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	e8 4e ff ff ff       	call   801ac0 <fd2sockid>
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 1b                	js     801b91 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	ff 75 10             	pushl  0x10(%ebp)
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	e8 0e 01 00 00       	call   801c93 <nsipc_accept>
  801b85:	83 c4 10             	add    $0x10,%esp
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	78 05                	js     801b91 <accept+0x2d>
	return alloc_sockfd(r);
  801b8c:	e8 5f ff ff ff       	call   801af0 <alloc_sockfd>
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <bind>:
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	e8 1f ff ff ff       	call   801ac0 <fd2sockid>
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	78 12                	js     801bb7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	ff 75 10             	pushl  0x10(%ebp)
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	50                   	push   %eax
  801baf:	e8 2f 01 00 00       	call   801ce3 <nsipc_bind>
  801bb4:	83 c4 10             	add    $0x10,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <shutdown>:
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	e8 f9 fe ff ff       	call   801ac0 <fd2sockid>
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 0f                	js     801bda <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bcb:	83 ec 08             	sub    $0x8,%esp
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	50                   	push   %eax
  801bd2:	e8 41 01 00 00       	call   801d18 <nsipc_shutdown>
  801bd7:	83 c4 10             	add    $0x10,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <connect>:
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	e8 d6 fe ff ff       	call   801ac0 <fd2sockid>
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 12                	js     801c00 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	ff 75 10             	pushl  0x10(%ebp)
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	50                   	push   %eax
  801bf8:	e8 57 01 00 00       	call   801d54 <nsipc_connect>
  801bfd:	83 c4 10             	add    $0x10,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <listen>:
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	e8 b0 fe ff ff       	call   801ac0 <fd2sockid>
  801c10:	85 c0                	test   %eax,%eax
  801c12:	78 0f                	js     801c23 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c14:	83 ec 08             	sub    $0x8,%esp
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	50                   	push   %eax
  801c1b:	e8 69 01 00 00       	call   801d89 <nsipc_listen>
  801c20:	83 c4 10             	add    $0x10,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c2b:	ff 75 10             	pushl  0x10(%ebp)
  801c2e:	ff 75 0c             	pushl  0xc(%ebp)
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	e8 3c 02 00 00       	call   801e75 <nsipc_socket>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 05                	js     801c45 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c40:	e8 ab fe ff ff       	call   801af0 <alloc_sockfd>
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	53                   	push   %ebx
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c50:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c57:	74 26                	je     801c7f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c59:	6a 07                	push   $0x7
  801c5b:	68 00 60 c0 00       	push   $0xc06000
  801c60:	53                   	push   %ebx
  801c61:	ff 35 04 40 80 00    	pushl  0x804004
  801c67:	e8 19 04 00 00       	call   802085 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c6c:	83 c4 0c             	add    $0xc,%esp
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	e8 a2 03 00 00       	call   80201c <ipc_recv>
}
  801c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c7f:	83 ec 0c             	sub    $0xc,%esp
  801c82:	6a 02                	push   $0x2
  801c84:	e8 55 04 00 00       	call   8020de <ipc_find_env>
  801c89:	a3 04 40 80 00       	mov    %eax,0x804004
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	eb c6                	jmp    801c59 <nsipc+0x12>

00801c93 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ca3:	8b 06                	mov    (%esi),%eax
  801ca5:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	e8 93 ff ff ff       	call   801c47 <nsipc>
  801cb4:	89 c3                	mov    %eax,%ebx
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	78 20                	js     801cda <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	ff 35 10 60 c0 00    	pushl  0xc06010
  801cc3:	68 00 60 c0 00       	push   $0xc06000
  801cc8:	ff 75 0c             	pushl  0xc(%ebp)
  801ccb:	e8 72 ed ff ff       	call   800a42 <memmove>
		*addrlen = ret->ret_addrlen;
  801cd0:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801cd5:	89 06                	mov    %eax,(%esi)
  801cd7:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801cda:	89 d8                	mov    %ebx,%eax
  801cdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	53                   	push   %ebx
  801ce7:	83 ec 08             	sub    $0x8,%esp
  801cea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cf5:	53                   	push   %ebx
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	68 04 60 c0 00       	push   $0xc06004
  801cfe:	e8 3f ed ff ff       	call   800a42 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d03:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801d09:	b8 02 00 00 00       	mov    $0x2,%eax
  801d0e:	e8 34 ff ff ff       	call   801c47 <nsipc>
}
  801d13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d29:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801d2e:	b8 03 00 00 00       	mov    $0x3,%eax
  801d33:	e8 0f ff ff ff       	call   801c47 <nsipc>
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <nsipc_close>:

int
nsipc_close(int s)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801d48:	b8 04 00 00 00       	mov    $0x4,%eax
  801d4d:	e8 f5 fe ff ff       	call   801c47 <nsipc>
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	53                   	push   %ebx
  801d58:	83 ec 08             	sub    $0x8,%esp
  801d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d66:	53                   	push   %ebx
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	68 04 60 c0 00       	push   $0xc06004
  801d6f:	e8 ce ec ff ff       	call   800a42 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d74:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801d7a:	b8 05 00 00 00       	mov    $0x5,%eax
  801d7f:	e8 c3 fe ff ff       	call   801c47 <nsipc>
}
  801d84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9a:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801d9f:	b8 06 00 00 00       	mov    $0x6,%eax
  801da4:	e8 9e fe ff ff       	call   801c47 <nsipc>
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801dbb:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801dc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc4:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dc9:	b8 07 00 00 00       	mov    $0x7,%eax
  801dce:	e8 74 fe ff ff       	call   801c47 <nsipc>
  801dd3:	89 c3                	mov    %eax,%ebx
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	78 1f                	js     801df8 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801dd9:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801dde:	7f 21                	jg     801e01 <nsipc_recv+0x56>
  801de0:	39 c6                	cmp    %eax,%esi
  801de2:	7c 1d                	jl     801e01 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801de4:	83 ec 04             	sub    $0x4,%esp
  801de7:	50                   	push   %eax
  801de8:	68 00 60 c0 00       	push   $0xc06000
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	e8 4d ec ff ff       	call   800a42 <memmove>
  801df5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801df8:	89 d8                	mov    %ebx,%eax
  801dfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5e                   	pop    %esi
  801dff:	5d                   	pop    %ebp
  801e00:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e01:	68 ca 28 80 00       	push   $0x8028ca
  801e06:	68 6c 28 80 00       	push   $0x80286c
  801e0b:	6a 62                	push   $0x62
  801e0d:	68 df 28 80 00       	push   $0x8028df
  801e12:	e8 25 e3 ff ff       	call   80013c <_panic>

00801e17 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 04             	sub    $0x4,%esp
  801e1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801e29:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e2f:	7f 2e                	jg     801e5f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	53                   	push   %ebx
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	68 0c 60 c0 00       	push   $0xc0600c
  801e3d:	e8 00 ec ff ff       	call   800a42 <memmove>
	nsipcbuf.send.req_size = size;
  801e42:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801e48:	8b 45 14             	mov    0x14(%ebp),%eax
  801e4b:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801e50:	b8 08 00 00 00       	mov    $0x8,%eax
  801e55:	e8 ed fd ff ff       	call   801c47 <nsipc>
}
  801e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    
	assert(size < 1600);
  801e5f:	68 eb 28 80 00       	push   $0x8028eb
  801e64:	68 6c 28 80 00       	push   $0x80286c
  801e69:	6a 6d                	push   $0x6d
  801e6b:	68 df 28 80 00       	push   $0x8028df
  801e70:	e8 c7 e2 ff ff       	call   80013c <_panic>

00801e75 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e86:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8e:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801e93:	b8 09 00 00 00       	mov    $0x9,%eax
  801e98:	e8 aa fd ff ff       	call   801c47 <nsipc>
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    

00801ea9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801eaf:	68 f7 28 80 00       	push   $0x8028f7
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	e8 f8 e9 ff ff       	call   8008b4 <strcpy>
	return 0;
}
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <devcons_write>:
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	57                   	push   %edi
  801ec7:	56                   	push   %esi
  801ec8:	53                   	push   %ebx
  801ec9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ecf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ed4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801eda:	eb 2f                	jmp    801f0b <devcons_write+0x48>
		m = n - tot;
  801edc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801edf:	29 f3                	sub    %esi,%ebx
  801ee1:	83 fb 7f             	cmp    $0x7f,%ebx
  801ee4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ee9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	53                   	push   %ebx
  801ef0:	89 f0                	mov    %esi,%eax
  801ef2:	03 45 0c             	add    0xc(%ebp),%eax
  801ef5:	50                   	push   %eax
  801ef6:	57                   	push   %edi
  801ef7:	e8 46 eb ff ff       	call   800a42 <memmove>
		sys_cputs(buf, m);
  801efc:	83 c4 08             	add    $0x8,%esp
  801eff:	53                   	push   %ebx
  801f00:	57                   	push   %edi
  801f01:	e8 eb ec ff ff       	call   800bf1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f06:	01 de                	add    %ebx,%esi
  801f08:	83 c4 10             	add    $0x10,%esp
  801f0b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f0e:	72 cc                	jb     801edc <devcons_write+0x19>
}
  801f10:	89 f0                	mov    %esi,%eax
  801f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f15:	5b                   	pop    %ebx
  801f16:	5e                   	pop    %esi
  801f17:	5f                   	pop    %edi
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    

00801f1a <devcons_read>:
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f29:	75 07                	jne    801f32 <devcons_read+0x18>
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    
		sys_yield();
  801f2d:	e8 5c ed ff ff       	call   800c8e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f32:	e8 d8 ec ff ff       	call   800c0f <sys_cgetc>
  801f37:	85 c0                	test   %eax,%eax
  801f39:	74 f2                	je     801f2d <devcons_read+0x13>
	if (c < 0)
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	78 ec                	js     801f2b <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f3f:	83 f8 04             	cmp    $0x4,%eax
  801f42:	74 0c                	je     801f50 <devcons_read+0x36>
	*(char*)vbuf = c;
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	88 02                	mov    %al,(%edx)
	return 1;
  801f49:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4e:	eb db                	jmp    801f2b <devcons_read+0x11>
		return 0;
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
  801f55:	eb d4                	jmp    801f2b <devcons_read+0x11>

00801f57 <cputchar>:
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f63:	6a 01                	push   $0x1
  801f65:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f68:	50                   	push   %eax
  801f69:	e8 83 ec ff ff       	call   800bf1 <sys_cputs>
}
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <getchar>:
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f79:	6a 01                	push   $0x1
  801f7b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f7e:	50                   	push   %eax
  801f7f:	6a 00                	push   $0x0
  801f81:	e8 1e f2 ff ff       	call   8011a4 <read>
	if (r < 0)
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 08                	js     801f95 <getchar+0x22>
	if (r < 1)
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	7e 06                	jle    801f97 <getchar+0x24>
	return c;
  801f91:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    
		return -E_EOF;
  801f97:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f9c:	eb f7                	jmp    801f95 <getchar+0x22>

00801f9e <iscons>:
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa7:	50                   	push   %eax
  801fa8:	ff 75 08             	pushl  0x8(%ebp)
  801fab:	e8 83 ef ff ff       	call   800f33 <fd_lookup>
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	78 11                	js     801fc8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fc0:	39 10                	cmp    %edx,(%eax)
  801fc2:	0f 94 c0             	sete   %al
  801fc5:	0f b6 c0             	movzbl %al,%eax
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <opencons>:
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd3:	50                   	push   %eax
  801fd4:	e8 0b ef ff ff       	call   800ee4 <fd_alloc>
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	78 3a                	js     80201a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 07 04 00 00       	push   $0x407
  801fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  801feb:	6a 00                	push   $0x0
  801fed:	e8 bb ec ff ff       	call   800cad <sys_page_alloc>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 21                	js     80201a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802002:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80200e:	83 ec 0c             	sub    $0xc,%esp
  802011:	50                   	push   %eax
  802012:	e8 a6 ee ff ff       	call   800ebd <fd2num>
  802017:	83 c4 10             	add    $0x10,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	56                   	push   %esi
  802020:	53                   	push   %ebx
  802021:	8b 75 08             	mov    0x8(%ebp),%esi
  802024:	8b 45 0c             	mov    0xc(%ebp),%eax
  802027:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80202a:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  80202c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802031:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	50                   	push   %eax
  802038:	e8 20 ee ff ff       	call   800e5d <sys_ipc_recv>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	85 c0                	test   %eax,%eax
  802042:	78 2b                	js     80206f <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802044:	85 f6                	test   %esi,%esi
  802046:	74 0a                	je     802052 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802048:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80204d:	8b 40 74             	mov    0x74(%eax),%eax
  802050:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802052:	85 db                	test   %ebx,%ebx
  802054:	74 0a                	je     802060 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802056:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80205b:	8b 40 78             	mov    0x78(%eax),%eax
  80205e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802060:	a1 20 40 c0 00       	mov    0xc04020,%eax
  802065:	8b 40 70             	mov    0x70(%eax),%eax
}
  802068:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5d                   	pop    %ebp
  80206e:	c3                   	ret    
	    if (from_env_store != NULL) {
  80206f:	85 f6                	test   %esi,%esi
  802071:	74 06                	je     802079 <ipc_recv+0x5d>
	        *from_env_store = 0;
  802073:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802079:	85 db                	test   %ebx,%ebx
  80207b:	74 eb                	je     802068 <ipc_recv+0x4c>
	        *perm_store = 0;
  80207d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802083:	eb e3                	jmp    802068 <ipc_recv+0x4c>

00802085 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	57                   	push   %edi
  802089:	56                   	push   %esi
  80208a:	53                   	push   %ebx
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802091:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802094:	85 f6                	test   %esi,%esi
  802096:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80209b:	0f 44 f0             	cmove  %eax,%esi
  80209e:	eb 09                	jmp    8020a9 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8020a0:	e8 e9 eb ff ff       	call   800c8e <sys_yield>
	} while(r != 0);
  8020a5:	85 db                	test   %ebx,%ebx
  8020a7:	74 2d                	je     8020d6 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8020a9:	ff 75 14             	pushl  0x14(%ebp)
  8020ac:	56                   	push   %esi
  8020ad:	ff 75 0c             	pushl  0xc(%ebp)
  8020b0:	57                   	push   %edi
  8020b1:	e8 84 ed ff ff       	call   800e3a <sys_ipc_try_send>
  8020b6:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8020b8:	83 c4 10             	add    $0x10,%esp
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	79 e1                	jns    8020a0 <ipc_send+0x1b>
  8020bf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020c2:	74 dc                	je     8020a0 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8020c4:	50                   	push   %eax
  8020c5:	68 03 29 80 00       	push   $0x802903
  8020ca:	6a 45                	push   $0x45
  8020cc:	68 10 29 80 00       	push   $0x802910
  8020d1:	e8 66 e0 ff ff       	call   80013c <_panic>
}
  8020d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d9:	5b                   	pop    %ebx
  8020da:	5e                   	pop    %esi
  8020db:	5f                   	pop    %edi
  8020dc:	5d                   	pop    %ebp
  8020dd:	c3                   	ret    

008020de <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020e4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020e9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020ec:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020f2:	8b 52 50             	mov    0x50(%edx),%edx
  8020f5:	39 ca                	cmp    %ecx,%edx
  8020f7:	74 11                	je     80210a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020f9:	83 c0 01             	add    $0x1,%eax
  8020fc:	3d 00 04 00 00       	cmp    $0x400,%eax
  802101:	75 e6                	jne    8020e9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	eb 0b                	jmp    802115 <ipc_find_env+0x37>
			return envs[i].env_id;
  80210a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80210d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802112:	8b 40 48             	mov    0x48(%eax),%eax
}
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    

00802117 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80211d:	89 d0                	mov    %edx,%eax
  80211f:	c1 e8 16             	shr    $0x16,%eax
  802122:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80212e:	f6 c1 01             	test   $0x1,%cl
  802131:	74 1d                	je     802150 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802133:	c1 ea 0c             	shr    $0xc,%edx
  802136:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80213d:	f6 c2 01             	test   $0x1,%dl
  802140:	74 0e                	je     802150 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802142:	c1 ea 0c             	shr    $0xc,%edx
  802145:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80214c:	ef 
  80214d:	0f b7 c0             	movzwl %ax,%eax
}
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    
  802152:	66 90                	xchg   %ax,%ax
  802154:	66 90                	xchg   %ax,%ax
  802156:	66 90                	xchg   %ax,%ax
  802158:	66 90                	xchg   %ax,%ax
  80215a:	66 90                	xchg   %ax,%ax
  80215c:	66 90                	xchg   %ax,%ax
  80215e:	66 90                	xchg   %ax,%ax

00802160 <__udivdi3>:
  802160:	55                   	push   %ebp
  802161:	57                   	push   %edi
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	83 ec 1c             	sub    $0x1c,%esp
  802167:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80216b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80216f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802173:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802177:	85 d2                	test   %edx,%edx
  802179:	75 35                	jne    8021b0 <__udivdi3+0x50>
  80217b:	39 f3                	cmp    %esi,%ebx
  80217d:	0f 87 bd 00 00 00    	ja     802240 <__udivdi3+0xe0>
  802183:	85 db                	test   %ebx,%ebx
  802185:	89 d9                	mov    %ebx,%ecx
  802187:	75 0b                	jne    802194 <__udivdi3+0x34>
  802189:	b8 01 00 00 00       	mov    $0x1,%eax
  80218e:	31 d2                	xor    %edx,%edx
  802190:	f7 f3                	div    %ebx
  802192:	89 c1                	mov    %eax,%ecx
  802194:	31 d2                	xor    %edx,%edx
  802196:	89 f0                	mov    %esi,%eax
  802198:	f7 f1                	div    %ecx
  80219a:	89 c6                	mov    %eax,%esi
  80219c:	89 e8                	mov    %ebp,%eax
  80219e:	89 f7                	mov    %esi,%edi
  8021a0:	f7 f1                	div    %ecx
  8021a2:	89 fa                	mov    %edi,%edx
  8021a4:	83 c4 1c             	add    $0x1c,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
  8021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	39 f2                	cmp    %esi,%edx
  8021b2:	77 7c                	ja     802230 <__udivdi3+0xd0>
  8021b4:	0f bd fa             	bsr    %edx,%edi
  8021b7:	83 f7 1f             	xor    $0x1f,%edi
  8021ba:	0f 84 98 00 00 00    	je     802258 <__udivdi3+0xf8>
  8021c0:	89 f9                	mov    %edi,%ecx
  8021c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021c7:	29 f8                	sub    %edi,%eax
  8021c9:	d3 e2                	shl    %cl,%edx
  8021cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021cf:	89 c1                	mov    %eax,%ecx
  8021d1:	89 da                	mov    %ebx,%edx
  8021d3:	d3 ea                	shr    %cl,%edx
  8021d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021d9:	09 d1                	or     %edx,%ecx
  8021db:	89 f2                	mov    %esi,%edx
  8021dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021e1:	89 f9                	mov    %edi,%ecx
  8021e3:	d3 e3                	shl    %cl,%ebx
  8021e5:	89 c1                	mov    %eax,%ecx
  8021e7:	d3 ea                	shr    %cl,%edx
  8021e9:	89 f9                	mov    %edi,%ecx
  8021eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ef:	d3 e6                	shl    %cl,%esi
  8021f1:	89 eb                	mov    %ebp,%ebx
  8021f3:	89 c1                	mov    %eax,%ecx
  8021f5:	d3 eb                	shr    %cl,%ebx
  8021f7:	09 de                	or     %ebx,%esi
  8021f9:	89 f0                	mov    %esi,%eax
  8021fb:	f7 74 24 08          	divl   0x8(%esp)
  8021ff:	89 d6                	mov    %edx,%esi
  802201:	89 c3                	mov    %eax,%ebx
  802203:	f7 64 24 0c          	mull   0xc(%esp)
  802207:	39 d6                	cmp    %edx,%esi
  802209:	72 0c                	jb     802217 <__udivdi3+0xb7>
  80220b:	89 f9                	mov    %edi,%ecx
  80220d:	d3 e5                	shl    %cl,%ebp
  80220f:	39 c5                	cmp    %eax,%ebp
  802211:	73 5d                	jae    802270 <__udivdi3+0x110>
  802213:	39 d6                	cmp    %edx,%esi
  802215:	75 59                	jne    802270 <__udivdi3+0x110>
  802217:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80221a:	31 ff                	xor    %edi,%edi
  80221c:	89 fa                	mov    %edi,%edx
  80221e:	83 c4 1c             	add    $0x1c,%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    
  802226:	8d 76 00             	lea    0x0(%esi),%esi
  802229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802230:	31 ff                	xor    %edi,%edi
  802232:	31 c0                	xor    %eax,%eax
  802234:	89 fa                	mov    %edi,%edx
  802236:	83 c4 1c             	add    $0x1c,%esp
  802239:	5b                   	pop    %ebx
  80223a:	5e                   	pop    %esi
  80223b:	5f                   	pop    %edi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    
  80223e:	66 90                	xchg   %ax,%ax
  802240:	31 ff                	xor    %edi,%edi
  802242:	89 e8                	mov    %ebp,%eax
  802244:	89 f2                	mov    %esi,%edx
  802246:	f7 f3                	div    %ebx
  802248:	89 fa                	mov    %edi,%edx
  80224a:	83 c4 1c             	add    $0x1c,%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    
  802252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	72 06                	jb     802262 <__udivdi3+0x102>
  80225c:	31 c0                	xor    %eax,%eax
  80225e:	39 eb                	cmp    %ebp,%ebx
  802260:	77 d2                	ja     802234 <__udivdi3+0xd4>
  802262:	b8 01 00 00 00       	mov    $0x1,%eax
  802267:	eb cb                	jmp    802234 <__udivdi3+0xd4>
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 d8                	mov    %ebx,%eax
  802272:	31 ff                	xor    %edi,%edi
  802274:	eb be                	jmp    802234 <__udivdi3+0xd4>
  802276:	66 90                	xchg   %ax,%ax
  802278:	66 90                	xchg   %ax,%ax
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__umoddi3>:
  802280:	55                   	push   %ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 1c             	sub    $0x1c,%esp
  802287:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80228b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80228f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802297:	85 ed                	test   %ebp,%ebp
  802299:	89 f0                	mov    %esi,%eax
  80229b:	89 da                	mov    %ebx,%edx
  80229d:	75 19                	jne    8022b8 <__umoddi3+0x38>
  80229f:	39 df                	cmp    %ebx,%edi
  8022a1:	0f 86 b1 00 00 00    	jbe    802358 <__umoddi3+0xd8>
  8022a7:	f7 f7                	div    %edi
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	39 dd                	cmp    %ebx,%ebp
  8022ba:	77 f1                	ja     8022ad <__umoddi3+0x2d>
  8022bc:	0f bd cd             	bsr    %ebp,%ecx
  8022bf:	83 f1 1f             	xor    $0x1f,%ecx
  8022c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022c6:	0f 84 b4 00 00 00    	je     802380 <__umoddi3+0x100>
  8022cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8022d1:	89 c2                	mov    %eax,%edx
  8022d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022d7:	29 c2                	sub    %eax,%edx
  8022d9:	89 c1                	mov    %eax,%ecx
  8022db:	89 f8                	mov    %edi,%eax
  8022dd:	d3 e5                	shl    %cl,%ebp
  8022df:	89 d1                	mov    %edx,%ecx
  8022e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022e5:	d3 e8                	shr    %cl,%eax
  8022e7:	09 c5                	or     %eax,%ebp
  8022e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ed:	89 c1                	mov    %eax,%ecx
  8022ef:	d3 e7                	shl    %cl,%edi
  8022f1:	89 d1                	mov    %edx,%ecx
  8022f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8022f7:	89 df                	mov    %ebx,%edi
  8022f9:	d3 ef                	shr    %cl,%edi
  8022fb:	89 c1                	mov    %eax,%ecx
  8022fd:	89 f0                	mov    %esi,%eax
  8022ff:	d3 e3                	shl    %cl,%ebx
  802301:	89 d1                	mov    %edx,%ecx
  802303:	89 fa                	mov    %edi,%edx
  802305:	d3 e8                	shr    %cl,%eax
  802307:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80230c:	09 d8                	or     %ebx,%eax
  80230e:	f7 f5                	div    %ebp
  802310:	d3 e6                	shl    %cl,%esi
  802312:	89 d1                	mov    %edx,%ecx
  802314:	f7 64 24 08          	mull   0x8(%esp)
  802318:	39 d1                	cmp    %edx,%ecx
  80231a:	89 c3                	mov    %eax,%ebx
  80231c:	89 d7                	mov    %edx,%edi
  80231e:	72 06                	jb     802326 <__umoddi3+0xa6>
  802320:	75 0e                	jne    802330 <__umoddi3+0xb0>
  802322:	39 c6                	cmp    %eax,%esi
  802324:	73 0a                	jae    802330 <__umoddi3+0xb0>
  802326:	2b 44 24 08          	sub    0x8(%esp),%eax
  80232a:	19 ea                	sbb    %ebp,%edx
  80232c:	89 d7                	mov    %edx,%edi
  80232e:	89 c3                	mov    %eax,%ebx
  802330:	89 ca                	mov    %ecx,%edx
  802332:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802337:	29 de                	sub    %ebx,%esi
  802339:	19 fa                	sbb    %edi,%edx
  80233b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80233f:	89 d0                	mov    %edx,%eax
  802341:	d3 e0                	shl    %cl,%eax
  802343:	89 d9                	mov    %ebx,%ecx
  802345:	d3 ee                	shr    %cl,%esi
  802347:	d3 ea                	shr    %cl,%edx
  802349:	09 f0                	or     %esi,%eax
  80234b:	83 c4 1c             	add    $0x1c,%esp
  80234e:	5b                   	pop    %ebx
  80234f:	5e                   	pop    %esi
  802350:	5f                   	pop    %edi
  802351:	5d                   	pop    %ebp
  802352:	c3                   	ret    
  802353:	90                   	nop
  802354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802358:	85 ff                	test   %edi,%edi
  80235a:	89 f9                	mov    %edi,%ecx
  80235c:	75 0b                	jne    802369 <__umoddi3+0xe9>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f7                	div    %edi
  802367:	89 c1                	mov    %eax,%ecx
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f1                	div    %ecx
  80236f:	89 f0                	mov    %esi,%eax
  802371:	f7 f1                	div    %ecx
  802373:	e9 31 ff ff ff       	jmp    8022a9 <__umoddi3+0x29>
  802378:	90                   	nop
  802379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802380:	39 dd                	cmp    %ebx,%ebp
  802382:	72 08                	jb     80238c <__umoddi3+0x10c>
  802384:	39 f7                	cmp    %esi,%edi
  802386:	0f 87 21 ff ff ff    	ja     8022ad <__umoddi3+0x2d>
  80238c:	89 da                	mov    %ebx,%edx
  80238e:	89 f0                	mov    %esi,%eax
  802390:	29 f8                	sub    %edi,%eax
  802392:	19 ea                	sbb    %ebp,%edx
  802394:	e9 14 ff ff ff       	jmp    8022ad <__umoddi3+0x2d>
