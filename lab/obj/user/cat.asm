
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fe 00 00 00       	call   80012f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 a9 11 00 00       	call   8011f7 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 5e 12 00 00       	call   8012c5 <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 00 25 80 00       	push   $0x802500
  80007a:	6a 0d                	push   $0xd
  80007c:	68 1b 25 80 00       	push   $0x80251b
  800081:	e8 09 01 00 00       	call   80018f <_panic>
	if (n < 0)
  800086:	85 c0                	test   %eax,%eax
  800088:	78 07                	js     800091 <cat+0x5e>
		panic("error reading %s: %e", s, n);
}
  80008a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008d:	5b                   	pop    %ebx
  80008e:	5e                   	pop    %esi
  80008f:	5d                   	pop    %ebp
  800090:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	50                   	push   %eax
  800095:	ff 75 0c             	pushl  0xc(%ebp)
  800098:	68 26 25 80 00       	push   $0x802526
  80009d:	6a 0f                	push   $0xf
  80009f:	68 1b 25 80 00       	push   $0x80251b
  8000a4:	e8 e6 00 00 00       	call   80018f <_panic>

008000a9 <umain>:

void
umain(int argc, char **argv)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	53                   	push   %ebx
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b5:	c7 05 00 30 80 00 3b 	movl   $0x80253b,0x803000
  8000bc:	25 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bf:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c8:	75 31                	jne    8000fb <umain+0x52>
		cat(0, "<stdin>");
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	68 3f 25 80 00       	push   $0x80253f
  8000d2:	6a 00                	push   $0x0
  8000d4:	e8 5a ff ff ff       	call   800033 <cat>
  8000d9:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	50                   	push   %eax
  8000e8:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000eb:	68 47 25 80 00       	push   $0x802547
  8000f0:	e8 4a 17 00 00       	call   80183f <printf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f8:	83 c3 01             	add    $0x1,%ebx
  8000fb:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fe:	7d dc                	jge    8000dc <umain+0x33>
			f = open(argv[i], O_RDONLY);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	6a 00                	push   $0x0
  800105:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800108:	e8 8e 15 00 00       	call   80169b <open>
  80010d:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	85 c0                	test   %eax,%eax
  800114:	78 ce                	js     8000e4 <umain+0x3b>
				cat(f, argv[i]);
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011c:	50                   	push   %eax
  80011d:	e8 11 ff ff ff       	call   800033 <cat>
				close(f);
  800122:	89 34 24             	mov    %esi,(%esp)
  800125:	e8 91 0f 00 00       	call   8010bb <close>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	eb c9                	jmp    8000f8 <umain+0x4f>

0080012f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800137:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80013a:	e8 83 0b 00 00       	call   800cc2 <sys_getenvid>
  80013f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800144:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	85 db                	test   %ebx,%ebx
  800153:	7e 07                	jle    80015c <libmain+0x2d>
		binaryname = argv[0];
  800155:	8b 06                	mov    (%esi),%eax
  800157:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	e8 43 ff ff ff       	call   8000a9 <umain>

	// exit gracefully
	exit();
  800166:	e8 0a 00 00 00       	call   800175 <exit>
}
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5d                   	pop    %ebp
  800174:	c3                   	ret    

00800175 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80017b:	e8 66 0f 00 00       	call   8010e6 <close_all>
	sys_env_destroy(0);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	6a 00                	push   $0x0
  800185:	e8 f7 0a 00 00       	call   800c81 <sys_env_destroy>
}
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800194:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800197:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019d:	e8 20 0b 00 00       	call   800cc2 <sys_getenvid>
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	56                   	push   %esi
  8001ac:	50                   	push   %eax
  8001ad:	68 64 25 80 00       	push   $0x802564
  8001b2:	e8 b3 00 00 00       	call   80026a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b7:	83 c4 18             	add    $0x18,%esp
  8001ba:	53                   	push   %ebx
  8001bb:	ff 75 10             	pushl  0x10(%ebp)
  8001be:	e8 56 00 00 00       	call   800219 <vcprintf>
	cprintf("\n");
  8001c3:	c7 04 24 b7 29 80 00 	movl   $0x8029b7,(%esp)
  8001ca:	e8 9b 00 00 00       	call   80026a <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d2:	cc                   	int3   
  8001d3:	eb fd                	jmp    8001d2 <_panic+0x43>

008001d5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001df:	8b 13                	mov    (%ebx),%edx
  8001e1:	8d 42 01             	lea    0x1(%edx),%eax
  8001e4:	89 03                	mov    %eax,(%ebx)
  8001e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f2:	74 09                	je     8001fd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	68 ff 00 00 00       	push   $0xff
  800205:	8d 43 08             	lea    0x8(%ebx),%eax
  800208:	50                   	push   %eax
  800209:	e8 36 0a 00 00       	call   800c44 <sys_cputs>
		b->idx = 0;
  80020e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	eb db                	jmp    8001f4 <putch+0x1f>

00800219 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800222:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800229:	00 00 00 
	b.cnt = 0;
  80022c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800233:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800242:	50                   	push   %eax
  800243:	68 d5 01 80 00       	push   $0x8001d5
  800248:	e8 1a 01 00 00       	call   800367 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024d:	83 c4 08             	add    $0x8,%esp
  800250:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800256:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 e2 09 00 00       	call   800c44 <sys_cputs>

	return b.cnt;
}
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800270:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800273:	50                   	push   %eax
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	e8 9d ff ff ff       	call   800219 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 1c             	sub    $0x1c,%esp
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 d6                	mov    %edx,%esi
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800294:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800297:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002a5:	39 d3                	cmp    %edx,%ebx
  8002a7:	72 05                	jb     8002ae <printnum+0x30>
  8002a9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002ac:	77 7a                	ja     800328 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 18             	pushl  0x18(%ebp)
  8002b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ba:	53                   	push   %ebx
  8002bb:	ff 75 10             	pushl  0x10(%ebp)
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cd:	e8 ee 1f 00 00       	call   8022c0 <__udivdi3>
  8002d2:	83 c4 18             	add    $0x18,%esp
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	89 f2                	mov    %esi,%edx
  8002d9:	89 f8                	mov    %edi,%eax
  8002db:	e8 9e ff ff ff       	call   80027e <printnum>
  8002e0:	83 c4 20             	add    $0x20,%esp
  8002e3:	eb 13                	jmp    8002f8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	56                   	push   %esi
  8002e9:	ff 75 18             	pushl  0x18(%ebp)
  8002ec:	ff d7                	call   *%edi
  8002ee:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002f1:	83 eb 01             	sub    $0x1,%ebx
  8002f4:	85 db                	test   %ebx,%ebx
  8002f6:	7f ed                	jg     8002e5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f8:	83 ec 08             	sub    $0x8,%esp
  8002fb:	56                   	push   %esi
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800302:	ff 75 e0             	pushl  -0x20(%ebp)
  800305:	ff 75 dc             	pushl  -0x24(%ebp)
  800308:	ff 75 d8             	pushl  -0x28(%ebp)
  80030b:	e8 d0 20 00 00       	call   8023e0 <__umoddi3>
  800310:	83 c4 14             	add    $0x14,%esp
  800313:	0f be 80 87 25 80 00 	movsbl 0x802587(%eax),%eax
  80031a:	50                   	push   %eax
  80031b:	ff d7                	call   *%edi
}
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    
  800328:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80032b:	eb c4                	jmp    8002f1 <printnum+0x73>

0080032d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800333:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800337:	8b 10                	mov    (%eax),%edx
  800339:	3b 50 04             	cmp    0x4(%eax),%edx
  80033c:	73 0a                	jae    800348 <sprintputch+0x1b>
		*b->buf++ = ch;
  80033e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800341:	89 08                	mov    %ecx,(%eax)
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	88 02                	mov    %al,(%edx)
}
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    

0080034a <printfmt>:
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800350:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800353:	50                   	push   %eax
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	ff 75 0c             	pushl  0xc(%ebp)
  80035a:	ff 75 08             	pushl  0x8(%ebp)
  80035d:	e8 05 00 00 00       	call   800367 <vprintfmt>
}
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <vprintfmt>:
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	57                   	push   %edi
  80036b:	56                   	push   %esi
  80036c:	53                   	push   %ebx
  80036d:	83 ec 2c             	sub    $0x2c,%esp
  800370:	8b 75 08             	mov    0x8(%ebp),%esi
  800373:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800376:	8b 7d 10             	mov    0x10(%ebp),%edi
  800379:	e9 21 04 00 00       	jmp    80079f <vprintfmt+0x438>
		padc = ' ';
  80037e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800382:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800389:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800390:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800397:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8d 47 01             	lea    0x1(%edi),%eax
  80039f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a2:	0f b6 17             	movzbl (%edi),%edx
  8003a5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a8:	3c 55                	cmp    $0x55,%al
  8003aa:	0f 87 90 04 00 00    	ja     800840 <vprintfmt+0x4d9>
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	ff 24 85 c0 26 80 00 	jmp    *0x8026c0(,%eax,4)
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003bd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003c1:	eb d9                	jmp    80039c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c6:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003ca:	eb d0                	jmp    80039c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	0f b6 d2             	movzbl %dl,%edx
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003e7:	83 f9 09             	cmp    $0x9,%ecx
  8003ea:	77 55                	ja     800441 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003ec:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ef:	eb e9                	jmp    8003da <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 40 04             	lea    0x4(%eax),%eax
  8003ff:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800405:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800409:	79 91                	jns    80039c <vprintfmt+0x35>
				width = precision, precision = -1;
  80040b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800411:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800418:	eb 82                	jmp    80039c <vprintfmt+0x35>
  80041a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041d:	85 c0                	test   %eax,%eax
  80041f:	ba 00 00 00 00       	mov    $0x0,%edx
  800424:	0f 49 d0             	cmovns %eax,%edx
  800427:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042d:	e9 6a ff ff ff       	jmp    80039c <vprintfmt+0x35>
  800432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800435:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80043c:	e9 5b ff ff ff       	jmp    80039c <vprintfmt+0x35>
  800441:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800444:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800447:	eb bc                	jmp    800405 <vprintfmt+0x9e>
			lflag++;
  800449:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044f:	e9 48 ff ff ff       	jmp    80039c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 78 04             	lea    0x4(%eax),%edi
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	53                   	push   %ebx
  80045e:	ff 30                	pushl  (%eax)
  800460:	ff d6                	call   *%esi
			break;
  800462:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800468:	e9 2f 03 00 00       	jmp    80079c <vprintfmt+0x435>
			err = va_arg(ap, int);
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8d 78 04             	lea    0x4(%eax),%edi
  800473:	8b 00                	mov    (%eax),%eax
  800475:	99                   	cltd   
  800476:	31 d0                	xor    %edx,%eax
  800478:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047a:	83 f8 0f             	cmp    $0xf,%eax
  80047d:	7f 23                	jg     8004a2 <vprintfmt+0x13b>
  80047f:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	74 18                	je     8004a2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80048a:	52                   	push   %edx
  80048b:	68 7e 29 80 00       	push   $0x80297e
  800490:	53                   	push   %ebx
  800491:	56                   	push   %esi
  800492:	e8 b3 fe ff ff       	call   80034a <printfmt>
  800497:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049d:	e9 fa 02 00 00       	jmp    80079c <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8004a2:	50                   	push   %eax
  8004a3:	68 9f 25 80 00       	push   $0x80259f
  8004a8:	53                   	push   %ebx
  8004a9:	56                   	push   %esi
  8004aa:	e8 9b fe ff ff       	call   80034a <printfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b5:	e9 e2 02 00 00       	jmp    80079c <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	83 c0 04             	add    $0x4,%eax
  8004c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004c8:	85 ff                	test   %edi,%edi
  8004ca:	b8 98 25 80 00       	mov    $0x802598,%eax
  8004cf:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d6:	0f 8e bd 00 00 00    	jle    800599 <vprintfmt+0x232>
  8004dc:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004e0:	75 0e                	jne    8004f0 <vprintfmt+0x189>
  8004e2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004eb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ee:	eb 6d                	jmp    80055d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8004f6:	57                   	push   %edi
  8004f7:	e8 ec 03 00 00       	call   8008e8 <strnlen>
  8004fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ff:	29 c1                	sub    %eax,%ecx
  800501:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800507:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80050b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800511:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	eb 0f                	jmp    800524 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	ff 75 e0             	pushl  -0x20(%ebp)
  80051c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80051e:	83 ef 01             	sub    $0x1,%edi
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	85 ff                	test   %edi,%edi
  800526:	7f ed                	jg     800515 <vprintfmt+0x1ae>
  800528:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80052b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80052e:	85 c9                	test   %ecx,%ecx
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 49 c1             	cmovns %ecx,%eax
  800538:	29 c1                	sub    %eax,%ecx
  80053a:	89 75 08             	mov    %esi,0x8(%ebp)
  80053d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800540:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800543:	89 cb                	mov    %ecx,%ebx
  800545:	eb 16                	jmp    80055d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800547:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054b:	75 31                	jne    80057e <vprintfmt+0x217>
					putch(ch, putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	50                   	push   %eax
  800554:	ff 55 08             	call   *0x8(%ebp)
  800557:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055a:	83 eb 01             	sub    $0x1,%ebx
  80055d:	83 c7 01             	add    $0x1,%edi
  800560:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800564:	0f be c2             	movsbl %dl,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	74 59                	je     8005c4 <vprintfmt+0x25d>
  80056b:	85 f6                	test   %esi,%esi
  80056d:	78 d8                	js     800547 <vprintfmt+0x1e0>
  80056f:	83 ee 01             	sub    $0x1,%esi
  800572:	79 d3                	jns    800547 <vprintfmt+0x1e0>
  800574:	89 df                	mov    %ebx,%edi
  800576:	8b 75 08             	mov    0x8(%ebp),%esi
  800579:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057c:	eb 37                	jmp    8005b5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80057e:	0f be d2             	movsbl %dl,%edx
  800581:	83 ea 20             	sub    $0x20,%edx
  800584:	83 fa 5e             	cmp    $0x5e,%edx
  800587:	76 c4                	jbe    80054d <vprintfmt+0x1e6>
					putch('?', putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	6a 3f                	push   $0x3f
  800591:	ff 55 08             	call   *0x8(%ebp)
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	eb c1                	jmp    80055a <vprintfmt+0x1f3>
  800599:	89 75 08             	mov    %esi,0x8(%ebp)
  80059c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80059f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005a5:	eb b6                	jmp    80055d <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	6a 20                	push   $0x20
  8005ad:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005af:	83 ef 01             	sub    $0x1,%edi
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	85 ff                	test   %edi,%edi
  8005b7:	7f ee                	jg     8005a7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	e9 d8 01 00 00       	jmp    80079c <vprintfmt+0x435>
  8005c4:	89 df                	mov    %ebx,%edi
  8005c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005cc:	eb e7                	jmp    8005b5 <vprintfmt+0x24e>
	if (lflag >= 2)
  8005ce:	83 f9 01             	cmp    $0x1,%ecx
  8005d1:	7e 45                	jle    800618 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 50 04             	mov    0x4(%eax),%edx
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 08             	lea    0x8(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005ee:	79 62                	jns    800652 <vprintfmt+0x2eb>
				putch('-', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 2d                	push   $0x2d
  8005f6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005fe:	f7 d8                	neg    %eax
  800600:	83 d2 00             	adc    $0x0,%edx
  800603:	f7 da                	neg    %edx
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800613:	e9 66 01 00 00       	jmp    80077e <vprintfmt+0x417>
	else if (lflag)
  800618:	85 c9                	test   %ecx,%ecx
  80061a:	75 1b                	jne    800637 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 c1                	mov    %eax,%ecx
  800626:	c1 f9 1f             	sar    $0x1f,%ecx
  800629:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
  800635:	eb b3                	jmp    8005ea <vprintfmt+0x283>
		return va_arg(*ap, long);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063f:	89 c1                	mov    %eax,%ecx
  800641:	c1 f9 1f             	sar    $0x1f,%ecx
  800644:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
  800650:	eb 98                	jmp    8005ea <vprintfmt+0x283>
			base = 10;
  800652:	ba 0a 00 00 00       	mov    $0xa,%edx
  800657:	e9 22 01 00 00       	jmp    80077e <vprintfmt+0x417>
	if (lflag >= 2)
  80065c:	83 f9 01             	cmp    $0x1,%ecx
  80065f:	7e 21                	jle    800682 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 50 04             	mov    0x4(%eax),%edx
  800667:	8b 00                	mov    (%eax),%eax
  800669:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8d 40 08             	lea    0x8(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800678:	ba 0a 00 00 00       	mov    $0xa,%edx
  80067d:	e9 fc 00 00 00       	jmp    80077e <vprintfmt+0x417>
	else if (lflag)
  800682:	85 c9                	test   %ecx,%ecx
  800684:	75 23                	jne    8006a9 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800693:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069f:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006a4:	e9 d5 00 00 00       	jmp    80077e <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006c7:	e9 b2 00 00 00       	jmp    80077e <vprintfmt+0x417>
	if (lflag >= 2)
  8006cc:	83 f9 01             	cmp    $0x1,%ecx
  8006cf:	7e 42                	jle    800713 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 50 04             	mov    0x4(%eax),%edx
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 08             	lea    0x8(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e8:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8006ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f1:	0f 89 87 00 00 00    	jns    80077e <vprintfmt+0x417>
				putch('-', putdat);
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	53                   	push   %ebx
  8006fb:	6a 2d                	push   $0x2d
  8006fd:	ff d6                	call   *%esi
				num = -(long long) num;
  8006ff:	f7 5d d8             	negl   -0x28(%ebp)
  800702:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800706:	f7 5d dc             	negl   -0x24(%ebp)
  800709:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80070c:	ba 08 00 00 00       	mov    $0x8,%edx
  800711:	eb 6b                	jmp    80077e <vprintfmt+0x417>
	else if (lflag)
  800713:	85 c9                	test   %ecx,%ecx
  800715:	75 1b                	jne    800732 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	ba 00 00 00 00       	mov    $0x0,%edx
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
  800730:	eb b6                	jmp    8006e8 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	eb 9b                	jmp    8006e8 <vprintfmt+0x381>
			putch('0', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 30                	push   $0x30
  800753:	ff d6                	call   *%esi
			putch('x', putdat);
  800755:	83 c4 08             	add    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 78                	push   $0x78
  80075b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80076d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800779:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80077e:	83 ec 0c             	sub    $0xc,%esp
  800781:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800785:	50                   	push   %eax
  800786:	ff 75 e0             	pushl  -0x20(%ebp)
  800789:	52                   	push   %edx
  80078a:	ff 75 dc             	pushl  -0x24(%ebp)
  80078d:	ff 75 d8             	pushl  -0x28(%ebp)
  800790:	89 da                	mov    %ebx,%edx
  800792:	89 f0                	mov    %esi,%eax
  800794:	e8 e5 fa ff ff       	call   80027e <printnum>
			break;
  800799:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80079c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079f:	83 c7 01             	add    $0x1,%edi
  8007a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a6:	83 f8 25             	cmp    $0x25,%eax
  8007a9:	0f 84 cf fb ff ff    	je     80037e <vprintfmt+0x17>
			if (ch == '\0')
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	0f 84 a9 00 00 00    	je     800860 <vprintfmt+0x4f9>
			putch(ch, putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	53                   	push   %ebx
  8007bb:	50                   	push   %eax
  8007bc:	ff d6                	call   *%esi
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	eb dc                	jmp    80079f <vprintfmt+0x438>
	if (lflag >= 2)
  8007c3:	83 f9 01             	cmp    $0x1,%ecx
  8007c6:	7e 1e                	jle    8007e6 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 08             	lea    0x8(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007df:	ba 10 00 00 00       	mov    $0x10,%edx
  8007e4:	eb 98                	jmp    80077e <vprintfmt+0x417>
	else if (lflag)
  8007e6:	85 c9                	test   %ecx,%ecx
  8007e8:	75 23                	jne    80080d <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800803:	ba 10 00 00 00       	mov    $0x10,%edx
  800808:	e9 71 ff ff ff       	jmp    80077e <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 40 04             	lea    0x4(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800826:	ba 10 00 00 00       	mov    $0x10,%edx
  80082b:	e9 4e ff ff ff       	jmp    80077e <vprintfmt+0x417>
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	6a 25                	push   $0x25
  800836:	ff d6                	call   *%esi
			break;
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	e9 5c ff ff ff       	jmp    80079c <vprintfmt+0x435>
			putch('%', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	53                   	push   %ebx
  800844:	6a 25                	push   $0x25
  800846:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	89 f8                	mov    %edi,%eax
  80084d:	eb 03                	jmp    800852 <vprintfmt+0x4eb>
  80084f:	83 e8 01             	sub    $0x1,%eax
  800852:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800856:	75 f7                	jne    80084f <vprintfmt+0x4e8>
  800858:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80085b:	e9 3c ff ff ff       	jmp    80079c <vprintfmt+0x435>
}
  800860:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800863:	5b                   	pop    %ebx
  800864:	5e                   	pop    %esi
  800865:	5f                   	pop    %edi
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	83 ec 18             	sub    $0x18,%esp
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800874:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800877:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80087b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80087e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800885:	85 c0                	test   %eax,%eax
  800887:	74 26                	je     8008af <vsnprintf+0x47>
  800889:	85 d2                	test   %edx,%edx
  80088b:	7e 22                	jle    8008af <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088d:	ff 75 14             	pushl  0x14(%ebp)
  800890:	ff 75 10             	pushl  0x10(%ebp)
  800893:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800896:	50                   	push   %eax
  800897:	68 2d 03 80 00       	push   $0x80032d
  80089c:	e8 c6 fa ff ff       	call   800367 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008aa:	83 c4 10             	add    $0x10,%esp
}
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    
		return -E_INVAL;
  8008af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b4:	eb f7                	jmp    8008ad <vsnprintf+0x45>

008008b6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008bc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008bf:	50                   	push   %eax
  8008c0:	ff 75 10             	pushl  0x10(%ebp)
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	ff 75 08             	pushl  0x8(%ebp)
  8008c9:	e8 9a ff ff ff       	call   800868 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008db:	eb 03                	jmp    8008e0 <strlen+0x10>
		n++;
  8008dd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e4:	75 f7                	jne    8008dd <strlen+0xd>
	return n;
}
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	eb 03                	jmp    8008fb <strnlen+0x13>
		n++;
  8008f8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fb:	39 d0                	cmp    %edx,%eax
  8008fd:	74 06                	je     800905 <strnlen+0x1d>
  8008ff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800903:	75 f3                	jne    8008f8 <strnlen+0x10>
	return n;
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800911:	89 c2                	mov    %eax,%edx
  800913:	83 c1 01             	add    $0x1,%ecx
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80091d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800920:	84 db                	test   %bl,%bl
  800922:	75 ef                	jne    800913 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800924:	5b                   	pop    %ebx
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	53                   	push   %ebx
  80092b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80092e:	53                   	push   %ebx
  80092f:	e8 9c ff ff ff       	call   8008d0 <strlen>
  800934:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	01 d8                	add    %ebx,%eax
  80093c:	50                   	push   %eax
  80093d:	e8 c5 ff ff ff       	call   800907 <strcpy>
	return dst;
}
  800942:	89 d8                	mov    %ebx,%eax
  800944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800947:	c9                   	leave  
  800948:	c3                   	ret    

00800949 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	8b 75 08             	mov    0x8(%ebp),%esi
  800951:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800954:	89 f3                	mov    %esi,%ebx
  800956:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800959:	89 f2                	mov    %esi,%edx
  80095b:	eb 0f                	jmp    80096c <strncpy+0x23>
		*dst++ = *src;
  80095d:	83 c2 01             	add    $0x1,%edx
  800960:	0f b6 01             	movzbl (%ecx),%eax
  800963:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800966:	80 39 01             	cmpb   $0x1,(%ecx)
  800969:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80096c:	39 da                	cmp    %ebx,%edx
  80096e:	75 ed                	jne    80095d <strncpy+0x14>
	}
	return ret;
}
  800970:	89 f0                	mov    %esi,%eax
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	8b 75 08             	mov    0x8(%ebp),%esi
  80097e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800981:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800984:	89 f0                	mov    %esi,%eax
  800986:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098a:	85 c9                	test   %ecx,%ecx
  80098c:	75 0b                	jne    800999 <strlcpy+0x23>
  80098e:	eb 17                	jmp    8009a7 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800990:	83 c2 01             	add    $0x1,%edx
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800999:	39 d8                	cmp    %ebx,%eax
  80099b:	74 07                	je     8009a4 <strlcpy+0x2e>
  80099d:	0f b6 0a             	movzbl (%edx),%ecx
  8009a0:	84 c9                	test   %cl,%cl
  8009a2:	75 ec                	jne    800990 <strlcpy+0x1a>
		*dst = '\0';
  8009a4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a7:	29 f0                	sub    %esi,%eax
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5e                   	pop    %esi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b6:	eb 06                	jmp    8009be <strcmp+0x11>
		p++, q++;
  8009b8:	83 c1 01             	add    $0x1,%ecx
  8009bb:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009be:	0f b6 01             	movzbl (%ecx),%eax
  8009c1:	84 c0                	test   %al,%al
  8009c3:	74 04                	je     8009c9 <strcmp+0x1c>
  8009c5:	3a 02                	cmp    (%edx),%al
  8009c7:	74 ef                	je     8009b8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c9:	0f b6 c0             	movzbl %al,%eax
  8009cc:	0f b6 12             	movzbl (%edx),%edx
  8009cf:	29 d0                	sub    %edx,%eax
}
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    

008009d3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dd:	89 c3                	mov    %eax,%ebx
  8009df:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e2:	eb 06                	jmp    8009ea <strncmp+0x17>
		n--, p++, q++;
  8009e4:	83 c0 01             	add    $0x1,%eax
  8009e7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ea:	39 d8                	cmp    %ebx,%eax
  8009ec:	74 16                	je     800a04 <strncmp+0x31>
  8009ee:	0f b6 08             	movzbl (%eax),%ecx
  8009f1:	84 c9                	test   %cl,%cl
  8009f3:	74 04                	je     8009f9 <strncmp+0x26>
  8009f5:	3a 0a                	cmp    (%edx),%cl
  8009f7:	74 eb                	je     8009e4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f9:	0f b6 00             	movzbl (%eax),%eax
  8009fc:	0f b6 12             	movzbl (%edx),%edx
  8009ff:	29 d0                	sub    %edx,%eax
}
  800a01:	5b                   	pop    %ebx
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    
		return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
  800a09:	eb f6                	jmp    800a01 <strncmp+0x2e>

00800a0b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	0f b6 10             	movzbl (%eax),%edx
  800a18:	84 d2                	test   %dl,%dl
  800a1a:	74 09                	je     800a25 <strchr+0x1a>
		if (*s == c)
  800a1c:	38 ca                	cmp    %cl,%dl
  800a1e:	74 0a                	je     800a2a <strchr+0x1f>
	for (; *s; s++)
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	eb f0                	jmp    800a15 <strchr+0xa>
			return (char *) s;
	return 0;
  800a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a36:	eb 03                	jmp    800a3b <strfind+0xf>
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a3e:	38 ca                	cmp    %cl,%dl
  800a40:	74 04                	je     800a46 <strfind+0x1a>
  800a42:	84 d2                	test   %dl,%dl
  800a44:	75 f2                	jne    800a38 <strfind+0xc>
			break;
	return (char *) s;
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	57                   	push   %edi
  800a4c:	56                   	push   %esi
  800a4d:	53                   	push   %ebx
  800a4e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a54:	85 c9                	test   %ecx,%ecx
  800a56:	74 13                	je     800a6b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a58:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a5e:	75 05                	jne    800a65 <memset+0x1d>
  800a60:	f6 c1 03             	test   $0x3,%cl
  800a63:	74 0d                	je     800a72 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	fc                   	cld    
  800a69:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6b:	89 f8                	mov    %edi,%eax
  800a6d:	5b                   	pop    %ebx
  800a6e:	5e                   	pop    %esi
  800a6f:	5f                   	pop    %edi
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    
		c &= 0xFF;
  800a72:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a76:	89 d3                	mov    %edx,%ebx
  800a78:	c1 e3 08             	shl    $0x8,%ebx
  800a7b:	89 d0                	mov    %edx,%eax
  800a7d:	c1 e0 18             	shl    $0x18,%eax
  800a80:	89 d6                	mov    %edx,%esi
  800a82:	c1 e6 10             	shl    $0x10,%esi
  800a85:	09 f0                	or     %esi,%eax
  800a87:	09 c2                	or     %eax,%edx
  800a89:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a8b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a8e:	89 d0                	mov    %edx,%eax
  800a90:	fc                   	cld    
  800a91:	f3 ab                	rep stos %eax,%es:(%edi)
  800a93:	eb d6                	jmp    800a6b <memset+0x23>

00800a95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	57                   	push   %edi
  800a99:	56                   	push   %esi
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa3:	39 c6                	cmp    %eax,%esi
  800aa5:	73 35                	jae    800adc <memmove+0x47>
  800aa7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	76 2e                	jbe    800adc <memmove+0x47>
		s += n;
		d += n;
  800aae:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab1:	89 d6                	mov    %edx,%esi
  800ab3:	09 fe                	or     %edi,%esi
  800ab5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800abb:	74 0c                	je     800ac9 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abd:	83 ef 01             	sub    $0x1,%edi
  800ac0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac3:	fd                   	std    
  800ac4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac6:	fc                   	cld    
  800ac7:	eb 21                	jmp    800aea <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac9:	f6 c1 03             	test   $0x3,%cl
  800acc:	75 ef                	jne    800abd <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ace:	83 ef 04             	sub    $0x4,%edi
  800ad1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad7:	fd                   	std    
  800ad8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ada:	eb ea                	jmp    800ac6 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adc:	89 f2                	mov    %esi,%edx
  800ade:	09 c2                	or     %eax,%edx
  800ae0:	f6 c2 03             	test   $0x3,%dl
  800ae3:	74 09                	je     800aee <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae5:	89 c7                	mov    %eax,%edi
  800ae7:	fc                   	cld    
  800ae8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aee:	f6 c1 03             	test   $0x3,%cl
  800af1:	75 f2                	jne    800ae5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800af3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af6:	89 c7                	mov    %eax,%edi
  800af8:	fc                   	cld    
  800af9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afb:	eb ed                	jmp    800aea <memmove+0x55>

00800afd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b00:	ff 75 10             	pushl  0x10(%ebp)
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 87 ff ff ff       	call   800a95 <memmove>
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	56                   	push   %esi
  800b14:	53                   	push   %ebx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 c6                	mov    %eax,%esi
  800b1d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b20:	39 f0                	cmp    %esi,%eax
  800b22:	74 1c                	je     800b40 <memcmp+0x30>
		if (*s1 != *s2)
  800b24:	0f b6 08             	movzbl (%eax),%ecx
  800b27:	0f b6 1a             	movzbl (%edx),%ebx
  800b2a:	38 d9                	cmp    %bl,%cl
  800b2c:	75 08                	jne    800b36 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b2e:	83 c0 01             	add    $0x1,%eax
  800b31:	83 c2 01             	add    $0x1,%edx
  800b34:	eb ea                	jmp    800b20 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b36:	0f b6 c1             	movzbl %cl,%eax
  800b39:	0f b6 db             	movzbl %bl,%ebx
  800b3c:	29 d8                	sub    %ebx,%eax
  800b3e:	eb 05                	jmp    800b45 <memcmp+0x35>
	}

	return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b52:	89 c2                	mov    %eax,%edx
  800b54:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b57:	39 d0                	cmp    %edx,%eax
  800b59:	73 09                	jae    800b64 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5b:	38 08                	cmp    %cl,(%eax)
  800b5d:	74 05                	je     800b64 <memfind+0x1b>
	for (; s < ends; s++)
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	eb f3                	jmp    800b57 <memfind+0xe>
			break;
	return (void *) s;
}
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b72:	eb 03                	jmp    800b77 <strtol+0x11>
		s++;
  800b74:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b77:	0f b6 01             	movzbl (%ecx),%eax
  800b7a:	3c 20                	cmp    $0x20,%al
  800b7c:	74 f6                	je     800b74 <strtol+0xe>
  800b7e:	3c 09                	cmp    $0x9,%al
  800b80:	74 f2                	je     800b74 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b82:	3c 2b                	cmp    $0x2b,%al
  800b84:	74 2e                	je     800bb4 <strtol+0x4e>
	int neg = 0;
  800b86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8b:	3c 2d                	cmp    $0x2d,%al
  800b8d:	74 2f                	je     800bbe <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b95:	75 05                	jne    800b9c <strtol+0x36>
  800b97:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9a:	74 2c                	je     800bc8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b9c:	85 db                	test   %ebx,%ebx
  800b9e:	75 0a                	jne    800baa <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba0:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ba5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba8:	74 28                	je     800bd2 <strtol+0x6c>
		base = 10;
  800baa:	b8 00 00 00 00       	mov    $0x0,%eax
  800baf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb2:	eb 50                	jmp    800c04 <strtol+0x9e>
		s++;
  800bb4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbc:	eb d1                	jmp    800b8f <strtol+0x29>
		s++, neg = 1;
  800bbe:	83 c1 01             	add    $0x1,%ecx
  800bc1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc6:	eb c7                	jmp    800b8f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bcc:	74 0e                	je     800bdc <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bce:	85 db                	test   %ebx,%ebx
  800bd0:	75 d8                	jne    800baa <strtol+0x44>
		s++, base = 8;
  800bd2:	83 c1 01             	add    $0x1,%ecx
  800bd5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bda:	eb ce                	jmp    800baa <strtol+0x44>
		s += 2, base = 16;
  800bdc:	83 c1 02             	add    $0x2,%ecx
  800bdf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be4:	eb c4                	jmp    800baa <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be9:	89 f3                	mov    %esi,%ebx
  800beb:	80 fb 19             	cmp    $0x19,%bl
  800bee:	77 29                	ja     800c19 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bf0:	0f be d2             	movsbl %dl,%edx
  800bf3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf9:	7d 30                	jge    800c2b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bfb:	83 c1 01             	add    $0x1,%ecx
  800bfe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c02:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c04:	0f b6 11             	movzbl (%ecx),%edx
  800c07:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0a:	89 f3                	mov    %esi,%ebx
  800c0c:	80 fb 09             	cmp    $0x9,%bl
  800c0f:	77 d5                	ja     800be6 <strtol+0x80>
			dig = *s - '0';
  800c11:	0f be d2             	movsbl %dl,%edx
  800c14:	83 ea 30             	sub    $0x30,%edx
  800c17:	eb dd                	jmp    800bf6 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c19:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1c:	89 f3                	mov    %esi,%ebx
  800c1e:	80 fb 19             	cmp    $0x19,%bl
  800c21:	77 08                	ja     800c2b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c23:	0f be d2             	movsbl %dl,%edx
  800c26:	83 ea 37             	sub    $0x37,%edx
  800c29:	eb cb                	jmp    800bf6 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2f:	74 05                	je     800c36 <strtol+0xd0>
		*endptr = (char *) s;
  800c31:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c34:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c36:	89 c2                	mov    %eax,%edx
  800c38:	f7 da                	neg    %edx
  800c3a:	85 ff                	test   %edi,%edi
  800c3c:	0f 45 c2             	cmovne %edx,%eax
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c55:	89 c3                	mov    %eax,%ebx
  800c57:	89 c7                	mov    %eax,%edi
  800c59:	89 c6                	mov    %eax,%esi
  800c5b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c68:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c72:	89 d1                	mov    %edx,%ecx
  800c74:	89 d3                	mov    %edx,%ebx
  800c76:	89 d7                	mov    %edx,%edi
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c92:	b8 03 00 00 00       	mov    $0x3,%eax
  800c97:	89 cb                	mov    %ecx,%ebx
  800c99:	89 cf                	mov    %ecx,%edi
  800c9b:	89 ce                	mov    %ecx,%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 03                	push   $0x3
  800cb1:	68 7f 28 80 00       	push   $0x80287f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 9c 28 80 00       	push   $0x80289c
  800cbd:	e8 cd f4 ff ff       	call   80018f <_panic>

00800cc2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccd:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd2:	89 d1                	mov    %edx,%ecx
  800cd4:	89 d3                	mov    %edx,%ebx
  800cd6:	89 d7                	mov    %edx,%edi
  800cd8:	89 d6                	mov    %edx,%esi
  800cda:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <sys_yield>:

void
sys_yield(void)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cec:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	89 d3                	mov    %edx,%ebx
  800cf5:	89 d7                	mov    %edx,%edi
  800cf7:	89 d6                	mov    %edx,%esi
  800cf9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d09:	be 00 00 00 00       	mov    $0x0,%esi
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	b8 04 00 00 00       	mov    $0x4,%eax
  800d19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1c:	89 f7                	mov    %esi,%edi
  800d1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	7f 08                	jg     800d2c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	50                   	push   %eax
  800d30:	6a 04                	push   $0x4
  800d32:	68 7f 28 80 00       	push   $0x80287f
  800d37:	6a 23                	push   $0x23
  800d39:	68 9c 28 80 00       	push   $0x80289c
  800d3e:	e8 4c f4 ff ff       	call   80018f <_panic>

00800d43 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d52:	b8 05 00 00 00       	mov    $0x5,%eax
  800d57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7f 08                	jg     800d6e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	50                   	push   %eax
  800d72:	6a 05                	push   $0x5
  800d74:	68 7f 28 80 00       	push   $0x80287f
  800d79:	6a 23                	push   $0x23
  800d7b:	68 9c 28 80 00       	push   $0x80289c
  800d80:	e8 0a f4 ff ff       	call   80018f <_panic>

00800d85 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9e:	89 df                	mov    %ebx,%edi
  800da0:	89 de                	mov    %ebx,%esi
  800da2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7f 08                	jg     800db0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	50                   	push   %eax
  800db4:	6a 06                	push   $0x6
  800db6:	68 7f 28 80 00       	push   $0x80287f
  800dbb:	6a 23                	push   $0x23
  800dbd:	68 9c 28 80 00       	push   $0x80289c
  800dc2:	e8 c8 f3 ff ff       	call   80018f <_panic>

00800dc7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddb:	b8 08 00 00 00       	mov    $0x8,%eax
  800de0:	89 df                	mov    %ebx,%edi
  800de2:	89 de                	mov    %ebx,%esi
  800de4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7f 08                	jg     800df2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	50                   	push   %eax
  800df6:	6a 08                	push   $0x8
  800df8:	68 7f 28 80 00       	push   $0x80287f
  800dfd:	6a 23                	push   $0x23
  800dff:	68 9c 28 80 00       	push   $0x80289c
  800e04:	e8 86 f3 ff ff       	call   80018f <_panic>

00800e09 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e17:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e22:	89 df                	mov    %ebx,%edi
  800e24:	89 de                	mov    %ebx,%esi
  800e26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	7f 08                	jg     800e34 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	50                   	push   %eax
  800e38:	6a 09                	push   $0x9
  800e3a:	68 7f 28 80 00       	push   $0x80287f
  800e3f:	6a 23                	push   $0x23
  800e41:	68 9c 28 80 00       	push   $0x80289c
  800e46:	e8 44 f3 ff ff       	call   80018f <_panic>

00800e4b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	50                   	push   %eax
  800e7a:	6a 0a                	push   $0xa
  800e7c:	68 7f 28 80 00       	push   $0x80287f
  800e81:	6a 23                	push   $0x23
  800e83:	68 9c 28 80 00       	push   $0x80289c
  800e88:	e8 02 f3 ff ff       	call   80018f <_panic>

00800e8d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9e:	be 00 00 00 00       	mov    $0x0,%esi
  800ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec6:	89 cb                	mov    %ecx,%ebx
  800ec8:	89 cf                	mov    %ecx,%edi
  800eca:	89 ce                	mov    %ecx,%esi
  800ecc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	7f 08                	jg     800eda <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	83 ec 0c             	sub    $0xc,%esp
  800edd:	50                   	push   %eax
  800ede:	6a 0d                	push   $0xd
  800ee0:	68 7f 28 80 00       	push   $0x80287f
  800ee5:	6a 23                	push   $0x23
  800ee7:	68 9c 28 80 00       	push   $0x80289c
  800eec:	e8 9e f2 ff ff       	call   80018f <_panic>

00800ef1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  800efc:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f01:	89 d1                	mov    %edx,%ecx
  800f03:	89 d3                	mov    %edx,%ebx
  800f05:	89 d7                	mov    %edx,%edi
  800f07:	89 d6                	mov    %edx,%esi
  800f09:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	05 00 00 00 30       	add    $0x30000000,%eax
  800f1b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f30:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f3d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f42:	89 c2                	mov    %eax,%edx
  800f44:	c1 ea 16             	shr    $0x16,%edx
  800f47:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4e:	f6 c2 01             	test   $0x1,%dl
  800f51:	74 2a                	je     800f7d <fd_alloc+0x46>
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	c1 ea 0c             	shr    $0xc,%edx
  800f58:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f5f:	f6 c2 01             	test   $0x1,%dl
  800f62:	74 19                	je     800f7d <fd_alloc+0x46>
  800f64:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f69:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f6e:	75 d2                	jne    800f42 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f70:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f76:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f7b:	eb 07                	jmp    800f84 <fd_alloc+0x4d>
			*fd_store = fd;
  800f7d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f8c:	83 f8 1f             	cmp    $0x1f,%eax
  800f8f:	77 36                	ja     800fc7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f91:	c1 e0 0c             	shl    $0xc,%eax
  800f94:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f99:	89 c2                	mov    %eax,%edx
  800f9b:	c1 ea 16             	shr    $0x16,%edx
  800f9e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fa5:	f6 c2 01             	test   $0x1,%dl
  800fa8:	74 24                	je     800fce <fd_lookup+0x48>
  800faa:	89 c2                	mov    %eax,%edx
  800fac:	c1 ea 0c             	shr    $0xc,%edx
  800faf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb6:	f6 c2 01             	test   $0x1,%dl
  800fb9:	74 1a                	je     800fd5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbe:	89 02                	mov    %eax,(%edx)
	return 0;
  800fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    
		return -E_INVAL;
  800fc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fcc:	eb f7                	jmp    800fc5 <fd_lookup+0x3f>
		return -E_INVAL;
  800fce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd3:	eb f0                	jmp    800fc5 <fd_lookup+0x3f>
  800fd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fda:	eb e9                	jmp    800fc5 <fd_lookup+0x3f>

00800fdc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe5:	ba 28 29 80 00       	mov    $0x802928,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fea:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fef:	39 08                	cmp    %ecx,(%eax)
  800ff1:	74 33                	je     801026 <dev_lookup+0x4a>
  800ff3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ff6:	8b 02                	mov    (%edx),%eax
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	75 f3                	jne    800fef <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ffc:	a1 20 60 80 00       	mov    0x806020,%eax
  801001:	8b 40 48             	mov    0x48(%eax),%eax
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	51                   	push   %ecx
  801008:	50                   	push   %eax
  801009:	68 ac 28 80 00       	push   $0x8028ac
  80100e:	e8 57 f2 ff ff       	call   80026a <cprintf>
	*dev = 0;
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    
			*dev = devtab[i];
  801026:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801029:	89 01                	mov    %eax,(%ecx)
			return 0;
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
  801030:	eb f2                	jmp    801024 <dev_lookup+0x48>

00801032 <fd_close>:
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	83 ec 1c             	sub    $0x1c,%esp
  80103b:	8b 75 08             	mov    0x8(%ebp),%esi
  80103e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801041:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801044:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801045:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80104b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80104e:	50                   	push   %eax
  80104f:	e8 32 ff ff ff       	call   800f86 <fd_lookup>
  801054:	89 c3                	mov    %eax,%ebx
  801056:	83 c4 08             	add    $0x8,%esp
  801059:	85 c0                	test   %eax,%eax
  80105b:	78 05                	js     801062 <fd_close+0x30>
	    || fd != fd2)
  80105d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801060:	74 16                	je     801078 <fd_close+0x46>
		return (must_exist ? r : 0);
  801062:	89 f8                	mov    %edi,%eax
  801064:	84 c0                	test   %al,%al
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
  80106b:	0f 44 d8             	cmove  %eax,%ebx
}
  80106e:	89 d8                	mov    %ebx,%eax
  801070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	ff 36                	pushl  (%esi)
  801081:	e8 56 ff ff ff       	call   800fdc <dev_lookup>
  801086:	89 c3                	mov    %eax,%ebx
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	78 15                	js     8010a4 <fd_close+0x72>
		if (dev->dev_close)
  80108f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801092:	8b 40 10             	mov    0x10(%eax),%eax
  801095:	85 c0                	test   %eax,%eax
  801097:	74 1b                	je     8010b4 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801099:	83 ec 0c             	sub    $0xc,%esp
  80109c:	56                   	push   %esi
  80109d:	ff d0                	call   *%eax
  80109f:	89 c3                	mov    %eax,%ebx
  8010a1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	56                   	push   %esi
  8010a8:	6a 00                	push   $0x0
  8010aa:	e8 d6 fc ff ff       	call   800d85 <sys_page_unmap>
	return r;
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	eb ba                	jmp    80106e <fd_close+0x3c>
			r = 0;
  8010b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b9:	eb e9                	jmp    8010a4 <fd_close+0x72>

008010bb <close>:

int
close(int fdnum)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c4:	50                   	push   %eax
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	e8 b9 fe ff ff       	call   800f86 <fd_lookup>
  8010cd:	83 c4 08             	add    $0x8,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 10                	js     8010e4 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	6a 01                	push   $0x1
  8010d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8010dc:	e8 51 ff ff ff       	call   801032 <fd_close>
  8010e1:	83 c4 10             	add    $0x10,%esp
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <close_all>:

void
close_all(void)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	53                   	push   %ebx
  8010ea:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	53                   	push   %ebx
  8010f6:	e8 c0 ff ff ff       	call   8010bb <close>
	for (i = 0; i < MAXFD; i++)
  8010fb:	83 c3 01             	add    $0x1,%ebx
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	83 fb 20             	cmp    $0x20,%ebx
  801104:	75 ec                	jne    8010f2 <close_all+0xc>
}
  801106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801114:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801117:	50                   	push   %eax
  801118:	ff 75 08             	pushl  0x8(%ebp)
  80111b:	e8 66 fe ff ff       	call   800f86 <fd_lookup>
  801120:	89 c3                	mov    %eax,%ebx
  801122:	83 c4 08             	add    $0x8,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	0f 88 81 00 00 00    	js     8011ae <dup+0xa3>
		return r;
	close(newfdnum);
  80112d:	83 ec 0c             	sub    $0xc,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	e8 83 ff ff ff       	call   8010bb <close>

	newfd = INDEX2FD(newfdnum);
  801138:	8b 75 0c             	mov    0xc(%ebp),%esi
  80113b:	c1 e6 0c             	shl    $0xc,%esi
  80113e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801144:	83 c4 04             	add    $0x4,%esp
  801147:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114a:	e8 d1 fd ff ff       	call   800f20 <fd2data>
  80114f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801151:	89 34 24             	mov    %esi,(%esp)
  801154:	e8 c7 fd ff ff       	call   800f20 <fd2data>
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80115e:	89 d8                	mov    %ebx,%eax
  801160:	c1 e8 16             	shr    $0x16,%eax
  801163:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80116a:	a8 01                	test   $0x1,%al
  80116c:	74 11                	je     80117f <dup+0x74>
  80116e:	89 d8                	mov    %ebx,%eax
  801170:	c1 e8 0c             	shr    $0xc,%eax
  801173:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80117a:	f6 c2 01             	test   $0x1,%dl
  80117d:	75 39                	jne    8011b8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80117f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e8 0c             	shr    $0xc,%eax
  801187:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80118e:	83 ec 0c             	sub    $0xc,%esp
  801191:	25 07 0e 00 00       	and    $0xe07,%eax
  801196:	50                   	push   %eax
  801197:	56                   	push   %esi
  801198:	6a 00                	push   $0x0
  80119a:	52                   	push   %edx
  80119b:	6a 00                	push   $0x0
  80119d:	e8 a1 fb ff ff       	call   800d43 <sys_page_map>
  8011a2:	89 c3                	mov    %eax,%ebx
  8011a4:	83 c4 20             	add    $0x20,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	78 31                	js     8011dc <dup+0xd1>
		goto err;

	return newfdnum;
  8011ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011ae:	89 d8                	mov    %ebx,%eax
  8011b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5f                   	pop    %edi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011b8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011bf:	83 ec 0c             	sub    $0xc,%esp
  8011c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8011c7:	50                   	push   %eax
  8011c8:	57                   	push   %edi
  8011c9:	6a 00                	push   $0x0
  8011cb:	53                   	push   %ebx
  8011cc:	6a 00                	push   $0x0
  8011ce:	e8 70 fb ff ff       	call   800d43 <sys_page_map>
  8011d3:	89 c3                	mov    %eax,%ebx
  8011d5:	83 c4 20             	add    $0x20,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	79 a3                	jns    80117f <dup+0x74>
	sys_page_unmap(0, newfd);
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	56                   	push   %esi
  8011e0:	6a 00                	push   $0x0
  8011e2:	e8 9e fb ff ff       	call   800d85 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011e7:	83 c4 08             	add    $0x8,%esp
  8011ea:	57                   	push   %edi
  8011eb:	6a 00                	push   $0x0
  8011ed:	e8 93 fb ff ff       	call   800d85 <sys_page_unmap>
	return r;
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	eb b7                	jmp    8011ae <dup+0xa3>

008011f7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 14             	sub    $0x14,%esp
  8011fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801201:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801204:	50                   	push   %eax
  801205:	53                   	push   %ebx
  801206:	e8 7b fd ff ff       	call   800f86 <fd_lookup>
  80120b:	83 c4 08             	add    $0x8,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 3f                	js     801251 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801212:	83 ec 08             	sub    $0x8,%esp
  801215:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801218:	50                   	push   %eax
  801219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121c:	ff 30                	pushl  (%eax)
  80121e:	e8 b9 fd ff ff       	call   800fdc <dev_lookup>
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	78 27                	js     801251 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80122a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122d:	8b 42 08             	mov    0x8(%edx),%eax
  801230:	83 e0 03             	and    $0x3,%eax
  801233:	83 f8 01             	cmp    $0x1,%eax
  801236:	74 1e                	je     801256 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123b:	8b 40 08             	mov    0x8(%eax),%eax
  80123e:	85 c0                	test   %eax,%eax
  801240:	74 35                	je     801277 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801242:	83 ec 04             	sub    $0x4,%esp
  801245:	ff 75 10             	pushl  0x10(%ebp)
  801248:	ff 75 0c             	pushl  0xc(%ebp)
  80124b:	52                   	push   %edx
  80124c:	ff d0                	call   *%eax
  80124e:	83 c4 10             	add    $0x10,%esp
}
  801251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801254:	c9                   	leave  
  801255:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801256:	a1 20 60 80 00       	mov    0x806020,%eax
  80125b:	8b 40 48             	mov    0x48(%eax),%eax
  80125e:	83 ec 04             	sub    $0x4,%esp
  801261:	53                   	push   %ebx
  801262:	50                   	push   %eax
  801263:	68 ed 28 80 00       	push   $0x8028ed
  801268:	e8 fd ef ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801275:	eb da                	jmp    801251 <read+0x5a>
		return -E_NOT_SUPP;
  801277:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80127c:	eb d3                	jmp    801251 <read+0x5a>

0080127e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	57                   	push   %edi
  801282:	56                   	push   %esi
  801283:	53                   	push   %ebx
  801284:	83 ec 0c             	sub    $0xc,%esp
  801287:	8b 7d 08             	mov    0x8(%ebp),%edi
  80128a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80128d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801292:	39 f3                	cmp    %esi,%ebx
  801294:	73 25                	jae    8012bb <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	89 f0                	mov    %esi,%eax
  80129b:	29 d8                	sub    %ebx,%eax
  80129d:	50                   	push   %eax
  80129e:	89 d8                	mov    %ebx,%eax
  8012a0:	03 45 0c             	add    0xc(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	57                   	push   %edi
  8012a5:	e8 4d ff ff ff       	call   8011f7 <read>
		if (m < 0)
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 08                	js     8012b9 <readn+0x3b>
			return m;
		if (m == 0)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	74 06                	je     8012bb <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012b5:	01 c3                	add    %eax,%ebx
  8012b7:	eb d9                	jmp    801292 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012bb:	89 d8                	mov    %ebx,%eax
  8012bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c0:	5b                   	pop    %ebx
  8012c1:	5e                   	pop    %esi
  8012c2:	5f                   	pop    %edi
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	53                   	push   %ebx
  8012c9:	83 ec 14             	sub    $0x14,%esp
  8012cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d2:	50                   	push   %eax
  8012d3:	53                   	push   %ebx
  8012d4:	e8 ad fc ff ff       	call   800f86 <fd_lookup>
  8012d9:	83 c4 08             	add    $0x8,%esp
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	78 3a                	js     80131a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ea:	ff 30                	pushl  (%eax)
  8012ec:	e8 eb fc ff ff       	call   800fdc <dev_lookup>
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	78 22                	js     80131a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ff:	74 1e                	je     80131f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801304:	8b 52 0c             	mov    0xc(%edx),%edx
  801307:	85 d2                	test   %edx,%edx
  801309:	74 35                	je     801340 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	ff 75 10             	pushl  0x10(%ebp)
  801311:	ff 75 0c             	pushl  0xc(%ebp)
  801314:	50                   	push   %eax
  801315:	ff d2                	call   *%edx
  801317:	83 c4 10             	add    $0x10,%esp
}
  80131a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80131f:	a1 20 60 80 00       	mov    0x806020,%eax
  801324:	8b 40 48             	mov    0x48(%eax),%eax
  801327:	83 ec 04             	sub    $0x4,%esp
  80132a:	53                   	push   %ebx
  80132b:	50                   	push   %eax
  80132c:	68 09 29 80 00       	push   $0x802909
  801331:	e8 34 ef ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133e:	eb da                	jmp    80131a <write+0x55>
		return -E_NOT_SUPP;
  801340:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801345:	eb d3                	jmp    80131a <write+0x55>

00801347 <seek>:

int
seek(int fdnum, off_t offset)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80134d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801350:	50                   	push   %eax
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 2d fc ff ff       	call   800f86 <fd_lookup>
  801359:	83 c4 08             	add    $0x8,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 0e                	js     80136e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801360:	8b 55 0c             	mov    0xc(%ebp),%edx
  801363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801366:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	53                   	push   %ebx
  801374:	83 ec 14             	sub    $0x14,%esp
  801377:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80137d:	50                   	push   %eax
  80137e:	53                   	push   %ebx
  80137f:	e8 02 fc ff ff       	call   800f86 <fd_lookup>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	78 37                	js     8013c2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138b:	83 ec 08             	sub    $0x8,%esp
  80138e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801391:	50                   	push   %eax
  801392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801395:	ff 30                	pushl  (%eax)
  801397:	e8 40 fc ff ff       	call   800fdc <dev_lookup>
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 1f                	js     8013c2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013aa:	74 1b                	je     8013c7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 52 18             	mov    0x18(%edx),%edx
  8013b2:	85 d2                	test   %edx,%edx
  8013b4:	74 32                	je     8013e8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	ff 75 0c             	pushl  0xc(%ebp)
  8013bc:	50                   	push   %eax
  8013bd:	ff d2                	call   *%edx
  8013bf:	83 c4 10             	add    $0x10,%esp
}
  8013c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013c7:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013cc:	8b 40 48             	mov    0x48(%eax),%eax
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	53                   	push   %ebx
  8013d3:	50                   	push   %eax
  8013d4:	68 cc 28 80 00       	push   $0x8028cc
  8013d9:	e8 8c ee ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e6:	eb da                	jmp    8013c2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ed:	eb d3                	jmp    8013c2 <ftruncate+0x52>

008013ef <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	53                   	push   %ebx
  8013f3:	83 ec 14             	sub    $0x14,%esp
  8013f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fc:	50                   	push   %eax
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 81 fb ff ff       	call   800f86 <fd_lookup>
  801405:	83 c4 08             	add    $0x8,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 4b                	js     801457 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	ff 30                	pushl  (%eax)
  801418:	e8 bf fb ff ff       	call   800fdc <dev_lookup>
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	78 33                	js     801457 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801427:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80142b:	74 2f                	je     80145c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80142d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801430:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801437:	00 00 00 
	stat->st_isdir = 0;
  80143a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801441:	00 00 00 
	stat->st_dev = dev;
  801444:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80144a:	83 ec 08             	sub    $0x8,%esp
  80144d:	53                   	push   %ebx
  80144e:	ff 75 f0             	pushl  -0x10(%ebp)
  801451:	ff 50 14             	call   *0x14(%eax)
  801454:	83 c4 10             	add    $0x10,%esp
}
  801457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    
		return -E_NOT_SUPP;
  80145c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801461:	eb f4                	jmp    801457 <fstat+0x68>

00801463 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	56                   	push   %esi
  801467:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801468:	83 ec 08             	sub    $0x8,%esp
  80146b:	6a 00                	push   $0x0
  80146d:	ff 75 08             	pushl  0x8(%ebp)
  801470:	e8 26 02 00 00       	call   80169b <open>
  801475:	89 c3                	mov    %eax,%ebx
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 1b                	js     801499 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	ff 75 0c             	pushl  0xc(%ebp)
  801484:	50                   	push   %eax
  801485:	e8 65 ff ff ff       	call   8013ef <fstat>
  80148a:	89 c6                	mov    %eax,%esi
	close(fd);
  80148c:	89 1c 24             	mov    %ebx,(%esp)
  80148f:	e8 27 fc ff ff       	call   8010bb <close>
	return r;
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	89 f3                	mov    %esi,%ebx
}
  801499:	89 d8                	mov    %ebx,%eax
  80149b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	89 c6                	mov    %eax,%esi
  8014a9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014ab:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014b2:	74 27                	je     8014db <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014b4:	6a 07                	push   $0x7
  8014b6:	68 00 70 80 00       	push   $0x807000
  8014bb:	56                   	push   %esi
  8014bc:	ff 35 00 40 80 00    	pushl  0x804000
  8014c2:	e8 26 0d 00 00       	call   8021ed <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014c7:	83 c4 0c             	add    $0xc,%esp
  8014ca:	6a 00                	push   $0x0
  8014cc:	53                   	push   %ebx
  8014cd:	6a 00                	push   $0x0
  8014cf:	e8 b0 0c 00 00       	call   802184 <ipc_recv>
}
  8014d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d7:	5b                   	pop    %ebx
  8014d8:	5e                   	pop    %esi
  8014d9:	5d                   	pop    %ebp
  8014da:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	6a 01                	push   $0x1
  8014e0:	e8 61 0d 00 00       	call   802246 <ipc_find_env>
  8014e5:	a3 00 40 80 00       	mov    %eax,0x804000
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	eb c5                	jmp    8014b4 <fsipc+0x12>

008014ef <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fb:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801500:	8b 45 0c             	mov    0xc(%ebp),%eax
  801503:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801508:	ba 00 00 00 00       	mov    $0x0,%edx
  80150d:	b8 02 00 00 00       	mov    $0x2,%eax
  801512:	e8 8b ff ff ff       	call   8014a2 <fsipc>
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <devfile_flush>:
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8b 40 0c             	mov    0xc(%eax),%eax
  801525:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  80152a:	ba 00 00 00 00       	mov    $0x0,%edx
  80152f:	b8 06 00 00 00       	mov    $0x6,%eax
  801534:	e8 69 ff ff ff       	call   8014a2 <fsipc>
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <devfile_stat>:
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	53                   	push   %ebx
  80153f:	83 ec 04             	sub    $0x4,%esp
  801542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	8b 40 0c             	mov    0xc(%eax),%eax
  80154b:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801550:	ba 00 00 00 00       	mov    $0x0,%edx
  801555:	b8 05 00 00 00       	mov    $0x5,%eax
  80155a:	e8 43 ff ff ff       	call   8014a2 <fsipc>
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 2c                	js     80158f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	68 00 70 80 00       	push   $0x807000
  80156b:	53                   	push   %ebx
  80156c:	e8 96 f3 ff ff       	call   800907 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801571:	a1 80 70 80 00       	mov    0x807080,%eax
  801576:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80157c:	a1 84 70 80 00       	mov    0x807084,%eax
  801581:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <devfile_write>:
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	53                   	push   %ebx
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a4:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  8015a9:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015af:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015b5:	77 30                	ja     8015e7 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015b7:	83 ec 04             	sub    $0x4,%esp
  8015ba:	53                   	push   %ebx
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	68 08 70 80 00       	push   $0x807008
  8015c3:	e8 cd f4 ff ff       	call   800a95 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cd:	b8 04 00 00 00       	mov    $0x4,%eax
  8015d2:	e8 cb fe ff ff       	call   8014a2 <fsipc>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	78 04                	js     8015e2 <devfile_write+0x4e>
	assert(r <= n);
  8015de:	39 d8                	cmp    %ebx,%eax
  8015e0:	77 1e                	ja     801600 <devfile_write+0x6c>
}
  8015e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015e7:	68 3c 29 80 00       	push   $0x80293c
  8015ec:	68 6c 29 80 00       	push   $0x80296c
  8015f1:	68 94 00 00 00       	push   $0x94
  8015f6:	68 81 29 80 00       	push   $0x802981
  8015fb:	e8 8f eb ff ff       	call   80018f <_panic>
	assert(r <= n);
  801600:	68 8c 29 80 00       	push   $0x80298c
  801605:	68 6c 29 80 00       	push   $0x80296c
  80160a:	68 98 00 00 00       	push   $0x98
  80160f:	68 81 29 80 00       	push   $0x802981
  801614:	e8 76 eb ff ff       	call   80018f <_panic>

00801619 <devfile_read>:
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8b 40 0c             	mov    0xc(%eax),%eax
  801627:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80162c:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801632:	ba 00 00 00 00       	mov    $0x0,%edx
  801637:	b8 03 00 00 00       	mov    $0x3,%eax
  80163c:	e8 61 fe ff ff       	call   8014a2 <fsipc>
  801641:	89 c3                	mov    %eax,%ebx
  801643:	85 c0                	test   %eax,%eax
  801645:	78 1f                	js     801666 <devfile_read+0x4d>
	assert(r <= n);
  801647:	39 f0                	cmp    %esi,%eax
  801649:	77 24                	ja     80166f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80164b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801650:	7f 33                	jg     801685 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	50                   	push   %eax
  801656:	68 00 70 80 00       	push   $0x807000
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	e8 32 f4 ff ff       	call   800a95 <memmove>
	return r;
  801663:	83 c4 10             	add    $0x10,%esp
}
  801666:	89 d8                	mov    %ebx,%eax
  801668:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    
	assert(r <= n);
  80166f:	68 8c 29 80 00       	push   $0x80298c
  801674:	68 6c 29 80 00       	push   $0x80296c
  801679:	6a 7c                	push   $0x7c
  80167b:	68 81 29 80 00       	push   $0x802981
  801680:	e8 0a eb ff ff       	call   80018f <_panic>
	assert(r <= PGSIZE);
  801685:	68 93 29 80 00       	push   $0x802993
  80168a:	68 6c 29 80 00       	push   $0x80296c
  80168f:	6a 7d                	push   $0x7d
  801691:	68 81 29 80 00       	push   $0x802981
  801696:	e8 f4 ea ff ff       	call   80018f <_panic>

0080169b <open>:
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
  8016a0:	83 ec 1c             	sub    $0x1c,%esp
  8016a3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016a6:	56                   	push   %esi
  8016a7:	e8 24 f2 ff ff       	call   8008d0 <strlen>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016b4:	7f 6c                	jg     801722 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bc:	50                   	push   %eax
  8016bd:	e8 75 f8 ff ff       	call   800f37 <fd_alloc>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 3c                	js     801707 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	56                   	push   %esi
  8016cf:	68 00 70 80 00       	push   $0x807000
  8016d4:	e8 2e f2 ff ff       	call   800907 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e9:	e8 b4 fd ff ff       	call   8014a2 <fsipc>
  8016ee:	89 c3                	mov    %eax,%ebx
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 19                	js     801710 <open+0x75>
	return fd2num(fd);
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8016fd:	e8 0e f8 ff ff       	call   800f10 <fd2num>
  801702:	89 c3                	mov    %eax,%ebx
  801704:	83 c4 10             	add    $0x10,%esp
}
  801707:	89 d8                	mov    %ebx,%eax
  801709:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170c:	5b                   	pop    %ebx
  80170d:	5e                   	pop    %esi
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    
		fd_close(fd, 0);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	6a 00                	push   $0x0
  801715:	ff 75 f4             	pushl  -0xc(%ebp)
  801718:	e8 15 f9 ff ff       	call   801032 <fd_close>
		return r;
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	eb e5                	jmp    801707 <open+0x6c>
		return -E_BAD_PATH;
  801722:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801727:	eb de                	jmp    801707 <open+0x6c>

00801729 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	b8 08 00 00 00       	mov    $0x8,%eax
  801739:	e8 64 fd ff ff       	call   8014a2 <fsipc>
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801740:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801744:	7e 38                	jle    80177e <writebuf+0x3e>
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	53                   	push   %ebx
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80174f:	ff 70 04             	pushl  0x4(%eax)
  801752:	8d 40 10             	lea    0x10(%eax),%eax
  801755:	50                   	push   %eax
  801756:	ff 33                	pushl  (%ebx)
  801758:	e8 68 fb ff ff       	call   8012c5 <write>
		if (result > 0)
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	85 c0                	test   %eax,%eax
  801762:	7e 03                	jle    801767 <writebuf+0x27>
			b->result += result;
  801764:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801767:	39 43 04             	cmp    %eax,0x4(%ebx)
  80176a:	74 0d                	je     801779 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80176c:	85 c0                	test   %eax,%eax
  80176e:	ba 00 00 00 00       	mov    $0x0,%edx
  801773:	0f 4f c2             	cmovg  %edx,%eax
  801776:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    
  80177e:	f3 c3                	repz ret 

00801780 <putch>:

static void
putch(int ch, void *thunk)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	53                   	push   %ebx
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80178a:	8b 53 04             	mov    0x4(%ebx),%edx
  80178d:	8d 42 01             	lea    0x1(%edx),%eax
  801790:	89 43 04             	mov    %eax,0x4(%ebx)
  801793:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801796:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80179a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80179f:	74 06                	je     8017a7 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8017a1:	83 c4 04             	add    $0x4,%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    
		writebuf(b);
  8017a7:	89 d8                	mov    %ebx,%eax
  8017a9:	e8 92 ff ff ff       	call   801740 <writebuf>
		b->idx = 0;
  8017ae:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017b5:	eb ea                	jmp    8017a1 <putch+0x21>

008017b7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017c9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8017d0:	00 00 00 
	b.result = 0;
  8017d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017da:	00 00 00 
	b.error = 1;
  8017dd:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8017e4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8017e7:	ff 75 10             	pushl  0x10(%ebp)
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017f3:	50                   	push   %eax
  8017f4:	68 80 17 80 00       	push   $0x801780
  8017f9:	e8 69 eb ff ff       	call   800367 <vprintfmt>
	if (b.idx > 0)
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801808:	7f 11                	jg     80181b <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80180a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801810:	85 c0                	test   %eax,%eax
  801812:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    
		writebuf(&b);
  80181b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801821:	e8 1a ff ff ff       	call   801740 <writebuf>
  801826:	eb e2                	jmp    80180a <vfprintf+0x53>

00801828 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80182e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801831:	50                   	push   %eax
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	ff 75 08             	pushl  0x8(%ebp)
  801838:	e8 7a ff ff ff       	call   8017b7 <vfprintf>
	va_end(ap);

	return cnt;
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <printf>:

int
printf(const char *fmt, ...)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801845:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801848:	50                   	push   %eax
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 01                	push   $0x1
  80184e:	e8 64 ff ff ff       	call   8017b7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80185d:	83 ec 0c             	sub    $0xc,%esp
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 b8 f6 ff ff       	call   800f20 <fd2data>
  801868:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80186a:	83 c4 08             	add    $0x8,%esp
  80186d:	68 9f 29 80 00       	push   $0x80299f
  801872:	53                   	push   %ebx
  801873:	e8 8f f0 ff ff       	call   800907 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801878:	8b 46 04             	mov    0x4(%esi),%eax
  80187b:	2b 06                	sub    (%esi),%eax
  80187d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801883:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80188a:	00 00 00 
	stat->st_dev = &devpipe;
  80188d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801894:	30 80 00 
	return 0;
}
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5e                   	pop    %esi
  8018a1:	5d                   	pop    %ebp
  8018a2:	c3                   	ret    

008018a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018ad:	53                   	push   %ebx
  8018ae:	6a 00                	push   $0x0
  8018b0:	e8 d0 f4 ff ff       	call   800d85 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018b5:	89 1c 24             	mov    %ebx,(%esp)
  8018b8:	e8 63 f6 ff ff       	call   800f20 <fd2data>
  8018bd:	83 c4 08             	add    $0x8,%esp
  8018c0:	50                   	push   %eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	e8 bd f4 ff ff       	call   800d85 <sys_page_unmap>
}
  8018c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <_pipeisclosed>:
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	57                   	push   %edi
  8018d1:	56                   	push   %esi
  8018d2:	53                   	push   %ebx
  8018d3:	83 ec 1c             	sub    $0x1c,%esp
  8018d6:	89 c7                	mov    %eax,%edi
  8018d8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8018da:	a1 20 60 80 00       	mov    0x806020,%eax
  8018df:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	57                   	push   %edi
  8018e6:	e8 94 09 00 00       	call   80227f <pageref>
  8018eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018ee:	89 34 24             	mov    %esi,(%esp)
  8018f1:	e8 89 09 00 00       	call   80227f <pageref>
		nn = thisenv->env_runs;
  8018f6:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8018fc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	39 cb                	cmp    %ecx,%ebx
  801904:	74 1b                	je     801921 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801906:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801909:	75 cf                	jne    8018da <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80190b:	8b 42 58             	mov    0x58(%edx),%eax
  80190e:	6a 01                	push   $0x1
  801910:	50                   	push   %eax
  801911:	53                   	push   %ebx
  801912:	68 a6 29 80 00       	push   $0x8029a6
  801917:	e8 4e e9 ff ff       	call   80026a <cprintf>
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	eb b9                	jmp    8018da <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801921:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801924:	0f 94 c0             	sete   %al
  801927:	0f b6 c0             	movzbl %al,%eax
}
  80192a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5e                   	pop    %esi
  80192f:	5f                   	pop    %edi
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    

00801932 <devpipe_write>:
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	57                   	push   %edi
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	83 ec 28             	sub    $0x28,%esp
  80193b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80193e:	56                   	push   %esi
  80193f:	e8 dc f5 ff ff       	call   800f20 <fd2data>
  801944:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	bf 00 00 00 00       	mov    $0x0,%edi
  80194e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801951:	74 4f                	je     8019a2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801953:	8b 43 04             	mov    0x4(%ebx),%eax
  801956:	8b 0b                	mov    (%ebx),%ecx
  801958:	8d 51 20             	lea    0x20(%ecx),%edx
  80195b:	39 d0                	cmp    %edx,%eax
  80195d:	72 14                	jb     801973 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80195f:	89 da                	mov    %ebx,%edx
  801961:	89 f0                	mov    %esi,%eax
  801963:	e8 65 ff ff ff       	call   8018cd <_pipeisclosed>
  801968:	85 c0                	test   %eax,%eax
  80196a:	75 3a                	jne    8019a6 <devpipe_write+0x74>
			sys_yield();
  80196c:	e8 70 f3 ff ff       	call   800ce1 <sys_yield>
  801971:	eb e0                	jmp    801953 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801973:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801976:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80197a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80197d:	89 c2                	mov    %eax,%edx
  80197f:	c1 fa 1f             	sar    $0x1f,%edx
  801982:	89 d1                	mov    %edx,%ecx
  801984:	c1 e9 1b             	shr    $0x1b,%ecx
  801987:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80198a:	83 e2 1f             	and    $0x1f,%edx
  80198d:	29 ca                	sub    %ecx,%edx
  80198f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801993:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801997:	83 c0 01             	add    $0x1,%eax
  80199a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80199d:	83 c7 01             	add    $0x1,%edi
  8019a0:	eb ac                	jmp    80194e <devpipe_write+0x1c>
	return i;
  8019a2:	89 f8                	mov    %edi,%eax
  8019a4:	eb 05                	jmp    8019ab <devpipe_write+0x79>
				return 0;
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5e                   	pop    %esi
  8019b0:	5f                   	pop    %edi
  8019b1:	5d                   	pop    %ebp
  8019b2:	c3                   	ret    

008019b3 <devpipe_read>:
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	57                   	push   %edi
  8019b7:	56                   	push   %esi
  8019b8:	53                   	push   %ebx
  8019b9:	83 ec 18             	sub    $0x18,%esp
  8019bc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8019bf:	57                   	push   %edi
  8019c0:	e8 5b f5 ff ff       	call   800f20 <fd2data>
  8019c5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	be 00 00 00 00       	mov    $0x0,%esi
  8019cf:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019d2:	74 47                	je     801a1b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8019d4:	8b 03                	mov    (%ebx),%eax
  8019d6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019d9:	75 22                	jne    8019fd <devpipe_read+0x4a>
			if (i > 0)
  8019db:	85 f6                	test   %esi,%esi
  8019dd:	75 14                	jne    8019f3 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8019df:	89 da                	mov    %ebx,%edx
  8019e1:	89 f8                	mov    %edi,%eax
  8019e3:	e8 e5 fe ff ff       	call   8018cd <_pipeisclosed>
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	75 33                	jne    801a1f <devpipe_read+0x6c>
			sys_yield();
  8019ec:	e8 f0 f2 ff ff       	call   800ce1 <sys_yield>
  8019f1:	eb e1                	jmp    8019d4 <devpipe_read+0x21>
				return i;
  8019f3:	89 f0                	mov    %esi,%eax
}
  8019f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5f                   	pop    %edi
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019fd:	99                   	cltd   
  8019fe:	c1 ea 1b             	shr    $0x1b,%edx
  801a01:	01 d0                	add    %edx,%eax
  801a03:	83 e0 1f             	and    $0x1f,%eax
  801a06:	29 d0                	sub    %edx,%eax
  801a08:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a10:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a13:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a16:	83 c6 01             	add    $0x1,%esi
  801a19:	eb b4                	jmp    8019cf <devpipe_read+0x1c>
	return i;
  801a1b:	89 f0                	mov    %esi,%eax
  801a1d:	eb d6                	jmp    8019f5 <devpipe_read+0x42>
				return 0;
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a24:	eb cf                	jmp    8019f5 <devpipe_read+0x42>

00801a26 <pipe>:
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	56                   	push   %esi
  801a2a:	53                   	push   %ebx
  801a2b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a31:	50                   	push   %eax
  801a32:	e8 00 f5 ff ff       	call   800f37 <fd_alloc>
  801a37:	89 c3                	mov    %eax,%ebx
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 5b                	js     801a9b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	68 07 04 00 00       	push   $0x407
  801a48:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4b:	6a 00                	push   $0x0
  801a4d:	e8 ae f2 ff ff       	call   800d00 <sys_page_alloc>
  801a52:	89 c3                	mov    %eax,%ebx
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 40                	js     801a9b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801a5b:	83 ec 0c             	sub    $0xc,%esp
  801a5e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a61:	50                   	push   %eax
  801a62:	e8 d0 f4 ff ff       	call   800f37 <fd_alloc>
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 1b                	js     801a8b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	68 07 04 00 00       	push   $0x407
  801a78:	ff 75 f0             	pushl  -0x10(%ebp)
  801a7b:	6a 00                	push   $0x0
  801a7d:	e8 7e f2 ff ff       	call   800d00 <sys_page_alloc>
  801a82:	89 c3                	mov    %eax,%ebx
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	85 c0                	test   %eax,%eax
  801a89:	79 19                	jns    801aa4 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a91:	6a 00                	push   $0x0
  801a93:	e8 ed f2 ff ff       	call   800d85 <sys_page_unmap>
  801a98:	83 c4 10             	add    $0x10,%esp
}
  801a9b:	89 d8                	mov    %ebx,%eax
  801a9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa0:	5b                   	pop    %ebx
  801aa1:	5e                   	pop    %esi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    
	va = fd2data(fd0);
  801aa4:	83 ec 0c             	sub    $0xc,%esp
  801aa7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aaa:	e8 71 f4 ff ff       	call   800f20 <fd2data>
  801aaf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ab1:	83 c4 0c             	add    $0xc,%esp
  801ab4:	68 07 04 00 00       	push   $0x407
  801ab9:	50                   	push   %eax
  801aba:	6a 00                	push   $0x0
  801abc:	e8 3f f2 ff ff       	call   800d00 <sys_page_alloc>
  801ac1:	89 c3                	mov    %eax,%ebx
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	0f 88 8c 00 00 00    	js     801b5a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ace:	83 ec 0c             	sub    $0xc,%esp
  801ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ad4:	e8 47 f4 ff ff       	call   800f20 <fd2data>
  801ad9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ae0:	50                   	push   %eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	56                   	push   %esi
  801ae4:	6a 00                	push   $0x0
  801ae6:	e8 58 f2 ff ff       	call   800d43 <sys_page_map>
  801aeb:	89 c3                	mov    %eax,%ebx
  801aed:	83 c4 20             	add    $0x20,%esp
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 58                	js     801b4c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801afd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b12:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b17:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b1e:	83 ec 0c             	sub    $0xc,%esp
  801b21:	ff 75 f4             	pushl  -0xc(%ebp)
  801b24:	e8 e7 f3 ff ff       	call   800f10 <fd2num>
  801b29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b2c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b2e:	83 c4 04             	add    $0x4,%esp
  801b31:	ff 75 f0             	pushl  -0x10(%ebp)
  801b34:	e8 d7 f3 ff ff       	call   800f10 <fd2num>
  801b39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b3c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b47:	e9 4f ff ff ff       	jmp    801a9b <pipe+0x75>
	sys_page_unmap(0, va);
  801b4c:	83 ec 08             	sub    $0x8,%esp
  801b4f:	56                   	push   %esi
  801b50:	6a 00                	push   $0x0
  801b52:	e8 2e f2 ff ff       	call   800d85 <sys_page_unmap>
  801b57:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b5a:	83 ec 08             	sub    $0x8,%esp
  801b5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801b60:	6a 00                	push   $0x0
  801b62:	e8 1e f2 ff ff       	call   800d85 <sys_page_unmap>
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	e9 1c ff ff ff       	jmp    801a8b <pipe+0x65>

00801b6f <pipeisclosed>:
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b78:	50                   	push   %eax
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	e8 05 f4 ff ff       	call   800f86 <fd_lookup>
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 18                	js     801ba0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8e:	e8 8d f3 ff ff       	call   800f20 <fd2data>
	return _pipeisclosed(fd, p);
  801b93:	89 c2                	mov    %eax,%edx
  801b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b98:	e8 30 fd ff ff       	call   8018cd <_pipeisclosed>
  801b9d:	83 c4 10             	add    $0x10,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ba8:	68 be 29 80 00       	push   $0x8029be
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	e8 52 ed ff ff       	call   800907 <strcpy>
	return 0;
}
  801bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <devsock_close>:
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 10             	sub    $0x10,%esp
  801bc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bc6:	53                   	push   %ebx
  801bc7:	e8 b3 06 00 00       	call   80227f <pageref>
  801bcc:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bcf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801bd4:	83 f8 01             	cmp    $0x1,%eax
  801bd7:	74 07                	je     801be0 <devsock_close+0x24>
}
  801bd9:	89 d0                	mov    %edx,%eax
  801bdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	ff 73 0c             	pushl  0xc(%ebx)
  801be6:	e8 b7 02 00 00       	call   801ea2 <nsipc_close>
  801beb:	89 c2                	mov    %eax,%edx
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	eb e7                	jmp    801bd9 <devsock_close+0x1d>

00801bf2 <devsock_write>:
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	ff 75 10             	pushl  0x10(%ebp)
  801bfd:	ff 75 0c             	pushl  0xc(%ebp)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	ff 70 0c             	pushl  0xc(%eax)
  801c06:	e8 74 03 00 00       	call   801f7f <nsipc_send>
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <devsock_read>:
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	ff 75 10             	pushl  0x10(%ebp)
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	ff 70 0c             	pushl  0xc(%eax)
  801c21:	e8 ed 02 00 00       	call   801f13 <nsipc_recv>
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <fd2sockid>:
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c2e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	e8 4e f3 ff ff       	call   800f86 <fd_lookup>
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	78 10                	js     801c4f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801c48:	39 08                	cmp    %ecx,(%eax)
  801c4a:	75 05                	jne    801c51 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c4c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    
		return -E_NOT_SUPP;
  801c51:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c56:	eb f7                	jmp    801c4f <fd2sockid+0x27>

00801c58 <alloc_sockfd>:
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	56                   	push   %esi
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 1c             	sub    $0x1c,%esp
  801c60:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c65:	50                   	push   %eax
  801c66:	e8 cc f2 ff ff       	call   800f37 <fd_alloc>
  801c6b:	89 c3                	mov    %eax,%ebx
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	85 c0                	test   %eax,%eax
  801c72:	78 43                	js     801cb7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	68 07 04 00 00       	push   $0x407
  801c7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7f:	6a 00                	push   $0x0
  801c81:	e8 7a f0 ff ff       	call   800d00 <sys_page_alloc>
  801c86:	89 c3                	mov    %eax,%ebx
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	78 28                	js     801cb7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c92:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c98:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ca4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	50                   	push   %eax
  801cab:	e8 60 f2 ff ff       	call   800f10 <fd2num>
  801cb0:	89 c3                	mov    %eax,%ebx
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	eb 0c                	jmp    801cc3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801cb7:	83 ec 0c             	sub    $0xc,%esp
  801cba:	56                   	push   %esi
  801cbb:	e8 e2 01 00 00       	call   801ea2 <nsipc_close>
		return r;
  801cc0:	83 c4 10             	add    $0x10,%esp
}
  801cc3:	89 d8                	mov    %ebx,%eax
  801cc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    

00801ccc <accept>:
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	e8 4e ff ff ff       	call   801c28 <fd2sockid>
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 1b                	js     801cf9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	ff 75 10             	pushl  0x10(%ebp)
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	50                   	push   %eax
  801ce8:	e8 0e 01 00 00       	call   801dfb <nsipc_accept>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 05                	js     801cf9 <accept+0x2d>
	return alloc_sockfd(r);
  801cf4:	e8 5f ff ff ff       	call   801c58 <alloc_sockfd>
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <bind>:
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	e8 1f ff ff ff       	call   801c28 <fd2sockid>
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	78 12                	js     801d1f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	ff 75 10             	pushl  0x10(%ebp)
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	50                   	push   %eax
  801d17:	e8 2f 01 00 00       	call   801e4b <nsipc_bind>
  801d1c:	83 c4 10             	add    $0x10,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <shutdown>:
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	e8 f9 fe ff ff       	call   801c28 <fd2sockid>
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	78 0f                	js     801d42 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	50                   	push   %eax
  801d3a:	e8 41 01 00 00       	call   801e80 <nsipc_shutdown>
  801d3f:	83 c4 10             	add    $0x10,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <connect>:
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	e8 d6 fe ff ff       	call   801c28 <fd2sockid>
  801d52:	85 c0                	test   %eax,%eax
  801d54:	78 12                	js     801d68 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	ff 75 10             	pushl  0x10(%ebp)
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	50                   	push   %eax
  801d60:	e8 57 01 00 00       	call   801ebc <nsipc_connect>
  801d65:	83 c4 10             	add    $0x10,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <listen>:
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	e8 b0 fe ff ff       	call   801c28 <fd2sockid>
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 0f                	js     801d8b <listen+0x21>
	return nsipc_listen(r, backlog);
  801d7c:	83 ec 08             	sub    $0x8,%esp
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	50                   	push   %eax
  801d83:	e8 69 01 00 00       	call   801ef1 <nsipc_listen>
  801d88:	83 c4 10             	add    $0x10,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <socket>:

int
socket(int domain, int type, int protocol)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d93:	ff 75 10             	pushl  0x10(%ebp)
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	ff 75 08             	pushl  0x8(%ebp)
  801d9c:	e8 3c 02 00 00       	call   801fdd <nsipc_socket>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 05                	js     801dad <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801da8:	e8 ab fe ff ff       	call   801c58 <alloc_sockfd>
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	53                   	push   %ebx
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801db8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801dbf:	74 26                	je     801de7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801dc1:	6a 07                	push   $0x7
  801dc3:	68 00 80 80 00       	push   $0x808000
  801dc8:	53                   	push   %ebx
  801dc9:	ff 35 04 40 80 00    	pushl  0x804004
  801dcf:	e8 19 04 00 00       	call   8021ed <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dd4:	83 c4 0c             	add    $0xc,%esp
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	e8 a2 03 00 00       	call   802184 <ipc_recv>
}
  801de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	6a 02                	push   $0x2
  801dec:	e8 55 04 00 00       	call   802246 <ipc_find_env>
  801df1:	a3 04 40 80 00       	mov    %eax,0x804004
  801df6:	83 c4 10             	add    $0x10,%esp
  801df9:	eb c6                	jmp    801dc1 <nsipc+0x12>

00801dfb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e0b:	8b 06                	mov    (%esi),%eax
  801e0d:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	e8 93 ff ff ff       	call   801daf <nsipc>
  801e1c:	89 c3                	mov    %eax,%ebx
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	78 20                	js     801e42 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e22:	83 ec 04             	sub    $0x4,%esp
  801e25:	ff 35 10 80 80 00    	pushl  0x808010
  801e2b:	68 00 80 80 00       	push   $0x808000
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	e8 5d ec ff ff       	call   800a95 <memmove>
		*addrlen = ret->ret_addrlen;
  801e38:	a1 10 80 80 00       	mov    0x808010,%eax
  801e3d:	89 06                	mov    %eax,(%esi)
  801e3f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801e42:	89 d8                	mov    %ebx,%eax
  801e44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	53                   	push   %ebx
  801e4f:	83 ec 08             	sub    $0x8,%esp
  801e52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e5d:	53                   	push   %ebx
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	68 04 80 80 00       	push   $0x808004
  801e66:	e8 2a ec ff ff       	call   800a95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e6b:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801e71:	b8 02 00 00 00       	mov    $0x2,%eax
  801e76:	e8 34 ff ff ff       	call   801daf <nsipc>
}
  801e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e91:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801e96:	b8 03 00 00 00       	mov    $0x3,%eax
  801e9b:	e8 0f ff ff ff       	call   801daf <nsipc>
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <nsipc_close>:

int
nsipc_close(int s)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801eb0:	b8 04 00 00 00       	mov    $0x4,%eax
  801eb5:	e8 f5 fe ff ff       	call   801daf <nsipc>
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	53                   	push   %ebx
  801ec0:	83 ec 08             	sub    $0x8,%esp
  801ec3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ece:	53                   	push   %ebx
  801ecf:	ff 75 0c             	pushl  0xc(%ebp)
  801ed2:	68 04 80 80 00       	push   $0x808004
  801ed7:	e8 b9 eb ff ff       	call   800a95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801edc:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801ee2:	b8 05 00 00 00       	mov    $0x5,%eax
  801ee7:	e8 c3 fe ff ff       	call   801daf <nsipc>
}
  801eec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f02:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801f07:	b8 06 00 00 00       	mov    $0x6,%eax
  801f0c:	e8 9e fe ff ff       	call   801daf <nsipc>
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	56                   	push   %esi
  801f17:	53                   	push   %ebx
  801f18:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801f23:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801f29:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2c:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f31:	b8 07 00 00 00       	mov    $0x7,%eax
  801f36:	e8 74 fe ff ff       	call   801daf <nsipc>
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	78 1f                	js     801f60 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f41:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f46:	7f 21                	jg     801f69 <nsipc_recv+0x56>
  801f48:	39 c6                	cmp    %eax,%esi
  801f4a:	7c 1d                	jl     801f69 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	50                   	push   %eax
  801f50:	68 00 80 80 00       	push   $0x808000
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	e8 38 eb ff ff       	call   800a95 <memmove>
  801f5d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f60:	89 d8                	mov    %ebx,%eax
  801f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f69:	68 ca 29 80 00       	push   $0x8029ca
  801f6e:	68 6c 29 80 00       	push   $0x80296c
  801f73:	6a 62                	push   $0x62
  801f75:	68 df 29 80 00       	push   $0x8029df
  801f7a:	e8 10 e2 ff ff       	call   80018f <_panic>

00801f7f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	53                   	push   %ebx
  801f83:	83 ec 04             	sub    $0x4,%esp
  801f86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801f91:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f97:	7f 2e                	jg     801fc7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f99:	83 ec 04             	sub    $0x4,%esp
  801f9c:	53                   	push   %ebx
  801f9d:	ff 75 0c             	pushl  0xc(%ebp)
  801fa0:	68 0c 80 80 00       	push   $0x80800c
  801fa5:	e8 eb ea ff ff       	call   800a95 <memmove>
	nsipcbuf.send.req_size = size;
  801faa:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb3:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801fb8:	b8 08 00 00 00       	mov    $0x8,%eax
  801fbd:	e8 ed fd ff ff       	call   801daf <nsipc>
}
  801fc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    
	assert(size < 1600);
  801fc7:	68 eb 29 80 00       	push   $0x8029eb
  801fcc:	68 6c 29 80 00       	push   $0x80296c
  801fd1:	6a 6d                	push   $0x6d
  801fd3:	68 df 29 80 00       	push   $0x8029df
  801fd8:	e8 b2 e1 ff ff       	call   80018f <_panic>

00801fdd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fee:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff6:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801ffb:	b8 09 00 00 00       	mov    $0x9,%eax
  802000:	e8 aa fd ff ff       	call   801daf <nsipc>
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    

00802011 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802017:	68 f7 29 80 00       	push   $0x8029f7
  80201c:	ff 75 0c             	pushl  0xc(%ebp)
  80201f:	e8 e3 e8 ff ff       	call   800907 <strcpy>
	return 0;
}
  802024:	b8 00 00 00 00       	mov    $0x0,%eax
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <devcons_write>:
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	57                   	push   %edi
  80202f:	56                   	push   %esi
  802030:	53                   	push   %ebx
  802031:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802037:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80203c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802042:	eb 2f                	jmp    802073 <devcons_write+0x48>
		m = n - tot;
  802044:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802047:	29 f3                	sub    %esi,%ebx
  802049:	83 fb 7f             	cmp    $0x7f,%ebx
  80204c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802051:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	53                   	push   %ebx
  802058:	89 f0                	mov    %esi,%eax
  80205a:	03 45 0c             	add    0xc(%ebp),%eax
  80205d:	50                   	push   %eax
  80205e:	57                   	push   %edi
  80205f:	e8 31 ea ff ff       	call   800a95 <memmove>
		sys_cputs(buf, m);
  802064:	83 c4 08             	add    $0x8,%esp
  802067:	53                   	push   %ebx
  802068:	57                   	push   %edi
  802069:	e8 d6 eb ff ff       	call   800c44 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80206e:	01 de                	add    %ebx,%esi
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	3b 75 10             	cmp    0x10(%ebp),%esi
  802076:	72 cc                	jb     802044 <devcons_write+0x19>
}
  802078:	89 f0                	mov    %esi,%eax
  80207a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80207d:	5b                   	pop    %ebx
  80207e:	5e                   	pop    %esi
  80207f:	5f                   	pop    %edi
  802080:	5d                   	pop    %ebp
  802081:	c3                   	ret    

00802082 <devcons_read>:
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 08             	sub    $0x8,%esp
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80208d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802091:	75 07                	jne    80209a <devcons_read+0x18>
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    
		sys_yield();
  802095:	e8 47 ec ff ff       	call   800ce1 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80209a:	e8 c3 eb ff ff       	call   800c62 <sys_cgetc>
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	74 f2                	je     802095 <devcons_read+0x13>
	if (c < 0)
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 ec                	js     802093 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8020a7:	83 f8 04             	cmp    $0x4,%eax
  8020aa:	74 0c                	je     8020b8 <devcons_read+0x36>
	*(char*)vbuf = c;
  8020ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020af:	88 02                	mov    %al,(%edx)
	return 1;
  8020b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b6:	eb db                	jmp    802093 <devcons_read+0x11>
		return 0;
  8020b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bd:	eb d4                	jmp    802093 <devcons_read+0x11>

008020bf <cputchar>:
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020cb:	6a 01                	push   $0x1
  8020cd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d0:	50                   	push   %eax
  8020d1:	e8 6e eb ff ff       	call   800c44 <sys_cputs>
}
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <getchar>:
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020e1:	6a 01                	push   $0x1
  8020e3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e6:	50                   	push   %eax
  8020e7:	6a 00                	push   $0x0
  8020e9:	e8 09 f1 ff ff       	call   8011f7 <read>
	if (r < 0)
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 08                	js     8020fd <getchar+0x22>
	if (r < 1)
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	7e 06                	jle    8020ff <getchar+0x24>
	return c;
  8020f9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    
		return -E_EOF;
  8020ff:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802104:	eb f7                	jmp    8020fd <getchar+0x22>

00802106 <iscons>:
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210f:	50                   	push   %eax
  802110:	ff 75 08             	pushl  0x8(%ebp)
  802113:	e8 6e ee ff ff       	call   800f86 <fd_lookup>
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	85 c0                	test   %eax,%eax
  80211d:	78 11                	js     802130 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802128:	39 10                	cmp    %edx,(%eax)
  80212a:	0f 94 c0             	sete   %al
  80212d:	0f b6 c0             	movzbl %al,%eax
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <opencons>:
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802138:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213b:	50                   	push   %eax
  80213c:	e8 f6 ed ff ff       	call   800f37 <fd_alloc>
  802141:	83 c4 10             	add    $0x10,%esp
  802144:	85 c0                	test   %eax,%eax
  802146:	78 3a                	js     802182 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	68 07 04 00 00       	push   $0x407
  802150:	ff 75 f4             	pushl  -0xc(%ebp)
  802153:	6a 00                	push   $0x0
  802155:	e8 a6 eb ff ff       	call   800d00 <sys_page_alloc>
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	85 c0                	test   %eax,%eax
  80215f:	78 21                	js     802182 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80216a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802176:	83 ec 0c             	sub    $0xc,%esp
  802179:	50                   	push   %eax
  80217a:	e8 91 ed ff ff       	call   800f10 <fd2num>
  80217f:	83 c4 10             	add    $0x10,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	56                   	push   %esi
  802188:	53                   	push   %ebx
  802189:	8b 75 08             	mov    0x8(%ebp),%esi
  80218c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802192:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802194:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802199:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80219c:	83 ec 0c             	sub    $0xc,%esp
  80219f:	50                   	push   %eax
  8021a0:	e8 0b ed ff ff       	call   800eb0 <sys_ipc_recv>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	78 2b                	js     8021d7 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8021ac:	85 f6                	test   %esi,%esi
  8021ae:	74 0a                	je     8021ba <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8021b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8021b5:	8b 40 74             	mov    0x74(%eax),%eax
  8021b8:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8021ba:	85 db                	test   %ebx,%ebx
  8021bc:	74 0a                	je     8021c8 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8021be:	a1 20 60 80 00       	mov    0x806020,%eax
  8021c3:	8b 40 78             	mov    0x78(%eax),%eax
  8021c6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021c8:	a1 20 60 80 00       	mov    0x806020,%eax
  8021cd:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d3:	5b                   	pop    %ebx
  8021d4:	5e                   	pop    %esi
  8021d5:	5d                   	pop    %ebp
  8021d6:	c3                   	ret    
	    if (from_env_store != NULL) {
  8021d7:	85 f6                	test   %esi,%esi
  8021d9:	74 06                	je     8021e1 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8021db:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8021e1:	85 db                	test   %ebx,%ebx
  8021e3:	74 eb                	je     8021d0 <ipc_recv+0x4c>
	        *perm_store = 0;
  8021e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021eb:	eb e3                	jmp    8021d0 <ipc_recv+0x4c>

008021ed <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	57                   	push   %edi
  8021f1:	56                   	push   %esi
  8021f2:	53                   	push   %ebx
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021f9:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8021fc:	85 f6                	test   %esi,%esi
  8021fe:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802203:	0f 44 f0             	cmove  %eax,%esi
  802206:	eb 09                	jmp    802211 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802208:	e8 d4 ea ff ff       	call   800ce1 <sys_yield>
	} while(r != 0);
  80220d:	85 db                	test   %ebx,%ebx
  80220f:	74 2d                	je     80223e <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802211:	ff 75 14             	pushl  0x14(%ebp)
  802214:	56                   	push   %esi
  802215:	ff 75 0c             	pushl  0xc(%ebp)
  802218:	57                   	push   %edi
  802219:	e8 6f ec ff ff       	call   800e8d <sys_ipc_try_send>
  80221e:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802220:	83 c4 10             	add    $0x10,%esp
  802223:	85 c0                	test   %eax,%eax
  802225:	79 e1                	jns    802208 <ipc_send+0x1b>
  802227:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80222a:	74 dc                	je     802208 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80222c:	50                   	push   %eax
  80222d:	68 03 2a 80 00       	push   $0x802a03
  802232:	6a 45                	push   $0x45
  802234:	68 10 2a 80 00       	push   $0x802a10
  802239:	e8 51 df ff ff       	call   80018f <_panic>
}
  80223e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    

00802246 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802251:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802254:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80225a:	8b 52 50             	mov    0x50(%edx),%edx
  80225d:	39 ca                	cmp    %ecx,%edx
  80225f:	74 11                	je     802272 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802261:	83 c0 01             	add    $0x1,%eax
  802264:	3d 00 04 00 00       	cmp    $0x400,%eax
  802269:	75 e6                	jne    802251 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	eb 0b                	jmp    80227d <ipc_find_env+0x37>
			return envs[i].env_id;
  802272:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802275:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80227a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80227d:	5d                   	pop    %ebp
  80227e:	c3                   	ret    

0080227f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e8 16             	shr    $0x16,%eax
  80228a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802291:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802296:	f6 c1 01             	test   $0x1,%cl
  802299:	74 1d                	je     8022b8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80229b:	c1 ea 0c             	shr    $0xc,%edx
  80229e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022a5:	f6 c2 01             	test   $0x1,%dl
  8022a8:	74 0e                	je     8022b8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022aa:	c1 ea 0c             	shr    $0xc,%edx
  8022ad:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022b4:	ef 
  8022b5:	0f b7 c0             	movzwl %ax,%eax
}
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__udivdi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022d7:	85 d2                	test   %edx,%edx
  8022d9:	75 35                	jne    802310 <__udivdi3+0x50>
  8022db:	39 f3                	cmp    %esi,%ebx
  8022dd:	0f 87 bd 00 00 00    	ja     8023a0 <__udivdi3+0xe0>
  8022e3:	85 db                	test   %ebx,%ebx
  8022e5:	89 d9                	mov    %ebx,%ecx
  8022e7:	75 0b                	jne    8022f4 <__udivdi3+0x34>
  8022e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ee:	31 d2                	xor    %edx,%edx
  8022f0:	f7 f3                	div    %ebx
  8022f2:	89 c1                	mov    %eax,%ecx
  8022f4:	31 d2                	xor    %edx,%edx
  8022f6:	89 f0                	mov    %esi,%eax
  8022f8:	f7 f1                	div    %ecx
  8022fa:	89 c6                	mov    %eax,%esi
  8022fc:	89 e8                	mov    %ebp,%eax
  8022fe:	89 f7                	mov    %esi,%edi
  802300:	f7 f1                	div    %ecx
  802302:	89 fa                	mov    %edi,%edx
  802304:	83 c4 1c             	add    $0x1c,%esp
  802307:	5b                   	pop    %ebx
  802308:	5e                   	pop    %esi
  802309:	5f                   	pop    %edi
  80230a:	5d                   	pop    %ebp
  80230b:	c3                   	ret    
  80230c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802310:	39 f2                	cmp    %esi,%edx
  802312:	77 7c                	ja     802390 <__udivdi3+0xd0>
  802314:	0f bd fa             	bsr    %edx,%edi
  802317:	83 f7 1f             	xor    $0x1f,%edi
  80231a:	0f 84 98 00 00 00    	je     8023b8 <__udivdi3+0xf8>
  802320:	89 f9                	mov    %edi,%ecx
  802322:	b8 20 00 00 00       	mov    $0x20,%eax
  802327:	29 f8                	sub    %edi,%eax
  802329:	d3 e2                	shl    %cl,%edx
  80232b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80232f:	89 c1                	mov    %eax,%ecx
  802331:	89 da                	mov    %ebx,%edx
  802333:	d3 ea                	shr    %cl,%edx
  802335:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802339:	09 d1                	or     %edx,%ecx
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802341:	89 f9                	mov    %edi,%ecx
  802343:	d3 e3                	shl    %cl,%ebx
  802345:	89 c1                	mov    %eax,%ecx
  802347:	d3 ea                	shr    %cl,%edx
  802349:	89 f9                	mov    %edi,%ecx
  80234b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80234f:	d3 e6                	shl    %cl,%esi
  802351:	89 eb                	mov    %ebp,%ebx
  802353:	89 c1                	mov    %eax,%ecx
  802355:	d3 eb                	shr    %cl,%ebx
  802357:	09 de                	or     %ebx,%esi
  802359:	89 f0                	mov    %esi,%eax
  80235b:	f7 74 24 08          	divl   0x8(%esp)
  80235f:	89 d6                	mov    %edx,%esi
  802361:	89 c3                	mov    %eax,%ebx
  802363:	f7 64 24 0c          	mull   0xc(%esp)
  802367:	39 d6                	cmp    %edx,%esi
  802369:	72 0c                	jb     802377 <__udivdi3+0xb7>
  80236b:	89 f9                	mov    %edi,%ecx
  80236d:	d3 e5                	shl    %cl,%ebp
  80236f:	39 c5                	cmp    %eax,%ebp
  802371:	73 5d                	jae    8023d0 <__udivdi3+0x110>
  802373:	39 d6                	cmp    %edx,%esi
  802375:	75 59                	jne    8023d0 <__udivdi3+0x110>
  802377:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80237a:	31 ff                	xor    %edi,%edi
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d 76 00             	lea    0x0(%esi),%esi
  802389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802390:	31 ff                	xor    %edi,%edi
  802392:	31 c0                	xor    %eax,%eax
  802394:	89 fa                	mov    %edi,%edx
  802396:	83 c4 1c             	add    $0x1c,%esp
  802399:	5b                   	pop    %ebx
  80239a:	5e                   	pop    %esi
  80239b:	5f                   	pop    %edi
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    
  80239e:	66 90                	xchg   %ax,%ax
  8023a0:	31 ff                	xor    %edi,%edi
  8023a2:	89 e8                	mov    %ebp,%eax
  8023a4:	89 f2                	mov    %esi,%edx
  8023a6:	f7 f3                	div    %ebx
  8023a8:	89 fa                	mov    %edi,%edx
  8023aa:	83 c4 1c             	add    $0x1c,%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5e                   	pop    %esi
  8023af:	5f                   	pop    %edi
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
  8023b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	72 06                	jb     8023c2 <__udivdi3+0x102>
  8023bc:	31 c0                	xor    %eax,%eax
  8023be:	39 eb                	cmp    %ebp,%ebx
  8023c0:	77 d2                	ja     802394 <__udivdi3+0xd4>
  8023c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c7:	eb cb                	jmp    802394 <__udivdi3+0xd4>
  8023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d0:	89 d8                	mov    %ebx,%eax
  8023d2:	31 ff                	xor    %edi,%edi
  8023d4:	eb be                	jmp    802394 <__udivdi3+0xd4>
  8023d6:	66 90                	xchg   %ax,%ax
  8023d8:	66 90                	xchg   %ax,%ax
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__umoddi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8023eb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023f7:	85 ed                	test   %ebp,%ebp
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	89 da                	mov    %ebx,%edx
  8023fd:	75 19                	jne    802418 <__umoddi3+0x38>
  8023ff:	39 df                	cmp    %ebx,%edi
  802401:	0f 86 b1 00 00 00    	jbe    8024b8 <__umoddi3+0xd8>
  802407:	f7 f7                	div    %edi
  802409:	89 d0                	mov    %edx,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	83 c4 1c             	add    $0x1c,%esp
  802410:	5b                   	pop    %ebx
  802411:	5e                   	pop    %esi
  802412:	5f                   	pop    %edi
  802413:	5d                   	pop    %ebp
  802414:	c3                   	ret    
  802415:	8d 76 00             	lea    0x0(%esi),%esi
  802418:	39 dd                	cmp    %ebx,%ebp
  80241a:	77 f1                	ja     80240d <__umoddi3+0x2d>
  80241c:	0f bd cd             	bsr    %ebp,%ecx
  80241f:	83 f1 1f             	xor    $0x1f,%ecx
  802422:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802426:	0f 84 b4 00 00 00    	je     8024e0 <__umoddi3+0x100>
  80242c:	b8 20 00 00 00       	mov    $0x20,%eax
  802431:	89 c2                	mov    %eax,%edx
  802433:	8b 44 24 04          	mov    0x4(%esp),%eax
  802437:	29 c2                	sub    %eax,%edx
  802439:	89 c1                	mov    %eax,%ecx
  80243b:	89 f8                	mov    %edi,%eax
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	89 d1                	mov    %edx,%ecx
  802441:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802445:	d3 e8                	shr    %cl,%eax
  802447:	09 c5                	or     %eax,%ebp
  802449:	8b 44 24 04          	mov    0x4(%esp),%eax
  80244d:	89 c1                	mov    %eax,%ecx
  80244f:	d3 e7                	shl    %cl,%edi
  802451:	89 d1                	mov    %edx,%ecx
  802453:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802457:	89 df                	mov    %ebx,%edi
  802459:	d3 ef                	shr    %cl,%edi
  80245b:	89 c1                	mov    %eax,%ecx
  80245d:	89 f0                	mov    %esi,%eax
  80245f:	d3 e3                	shl    %cl,%ebx
  802461:	89 d1                	mov    %edx,%ecx
  802463:	89 fa                	mov    %edi,%edx
  802465:	d3 e8                	shr    %cl,%eax
  802467:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80246c:	09 d8                	or     %ebx,%eax
  80246e:	f7 f5                	div    %ebp
  802470:	d3 e6                	shl    %cl,%esi
  802472:	89 d1                	mov    %edx,%ecx
  802474:	f7 64 24 08          	mull   0x8(%esp)
  802478:	39 d1                	cmp    %edx,%ecx
  80247a:	89 c3                	mov    %eax,%ebx
  80247c:	89 d7                	mov    %edx,%edi
  80247e:	72 06                	jb     802486 <__umoddi3+0xa6>
  802480:	75 0e                	jne    802490 <__umoddi3+0xb0>
  802482:	39 c6                	cmp    %eax,%esi
  802484:	73 0a                	jae    802490 <__umoddi3+0xb0>
  802486:	2b 44 24 08          	sub    0x8(%esp),%eax
  80248a:	19 ea                	sbb    %ebp,%edx
  80248c:	89 d7                	mov    %edx,%edi
  80248e:	89 c3                	mov    %eax,%ebx
  802490:	89 ca                	mov    %ecx,%edx
  802492:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802497:	29 de                	sub    %ebx,%esi
  802499:	19 fa                	sbb    %edi,%edx
  80249b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80249f:	89 d0                	mov    %edx,%eax
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 d9                	mov    %ebx,%ecx
  8024a5:	d3 ee                	shr    %cl,%esi
  8024a7:	d3 ea                	shr    %cl,%edx
  8024a9:	09 f0                	or     %esi,%eax
  8024ab:	83 c4 1c             	add    $0x1c,%esp
  8024ae:	5b                   	pop    %ebx
  8024af:	5e                   	pop    %esi
  8024b0:	5f                   	pop    %edi
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    
  8024b3:	90                   	nop
  8024b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	85 ff                	test   %edi,%edi
  8024ba:	89 f9                	mov    %edi,%ecx
  8024bc:	75 0b                	jne    8024c9 <__umoddi3+0xe9>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	31 d2                	xor    %edx,%edx
  8024c5:	f7 f7                	div    %edi
  8024c7:	89 c1                	mov    %eax,%ecx
  8024c9:	89 d8                	mov    %ebx,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	f7 f1                	div    %ecx
  8024cf:	89 f0                	mov    %esi,%eax
  8024d1:	f7 f1                	div    %ecx
  8024d3:	e9 31 ff ff ff       	jmp    802409 <__umoddi3+0x29>
  8024d8:	90                   	nop
  8024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e0:	39 dd                	cmp    %ebx,%ebp
  8024e2:	72 08                	jb     8024ec <__umoddi3+0x10c>
  8024e4:	39 f7                	cmp    %esi,%edi
  8024e6:	0f 87 21 ff ff ff    	ja     80240d <__umoddi3+0x2d>
  8024ec:	89 da                	mov    %ebx,%edx
  8024ee:	89 f0                	mov    %esi,%eax
  8024f0:	29 f8                	sub    %edi,%eax
  8024f2:	19 ea                	sbb    %ebp,%edx
  8024f4:	e9 14 ff ff ff       	jmp    80240d <__umoddi3+0x2d>
