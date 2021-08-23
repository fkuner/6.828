
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 52 01 00 00       	call   800183 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 1b                	jmp    80005e <num+0x2b>
		if (bol) {
			printf("%5d ", ++line);
			bol = 0;
		}
		if ((r = write(1, &c, 1)) != 1)
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 01                	push   $0x1
  800048:	53                   	push   %ebx
  800049:	6a 01                	push   $0x1
  80004b:	e8 c9 12 00 00       	call   801319 <write>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	83 f8 01             	cmp    $0x1,%eax
  800056:	75 4c                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800058:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  80005c:	74 5e                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	53                   	push   %ebx
  800064:	56                   	push   %esi
  800065:	e8 e1 11 00 00       	call   80124b <read>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	85 c0                	test   %eax,%eax
  80006f:	7e 57                	jle    8000c8 <num+0x95>
		if (bol) {
  800071:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800078:	74 c9                	je     800043 <num+0x10>
			printf("%5d ", ++line);
  80007a:	a1 00 40 80 00       	mov    0x804000,%eax
  80007f:	83 c0 01             	add    $0x1,%eax
  800082:	a3 00 40 80 00       	mov    %eax,0x804000
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	50                   	push   %eax
  80008b:	68 60 25 80 00       	push   $0x802560
  800090:	e8 fe 17 00 00       	call   801893 <printf>
			bol = 0;
  800095:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80009c:	00 00 00 
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 65 25 80 00       	push   $0x802565
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 80 25 80 00       	push   $0x802580
  8000b7:	e8 27 01 00 00       	call   8001e3 <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb 96                	jmp    80005e <num+0x2b>
	}
	if (n < 0)
  8000c8:	85 c0                	test   %eax,%eax
  8000ca:	78 07                	js     8000d3 <num+0xa0>
		panic("error reading %s: %e", s, n);
}
  8000cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	50                   	push   %eax
  8000d7:	ff 75 0c             	pushl  0xc(%ebp)
  8000da:	68 8b 25 80 00       	push   $0x80258b
  8000df:	6a 18                	push   $0x18
  8000e1:	68 80 25 80 00       	push   $0x802580
  8000e6:	e8 f8 00 00 00       	call   8001e3 <_panic>

008000eb <umain>:

void
umain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f4:	c7 05 04 30 80 00 a0 	movl   $0x8025a0,0x803004
  8000fb:	25 80 00 
	if (argc == 1)
  8000fe:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800102:	74 46                	je     80014a <umain+0x5f>
  800104:	8b 45 0c             	mov    0xc(%ebp),%eax
  800107:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80010a:	bf 01 00 00 00       	mov    $0x1,%edi
  80010f:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800112:	7d 48                	jge    80015c <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800114:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	6a 00                	push   $0x0
  80011c:	ff 33                	pushl  (%ebx)
  80011e:	e8 cc 15 00 00       	call   8016ef <open>
  800123:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	85 c0                	test   %eax,%eax
  80012a:	78 3d                	js     800169 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 33                	pushl  (%ebx)
  800131:	50                   	push   %eax
  800132:	e8 fc fe ff ff       	call   800033 <num>
				close(f);
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 d0 0f 00 00       	call   80110f <close>
		for (i = 1; i < argc; i++) {
  80013f:	83 c7 01             	add    $0x1,%edi
  800142:	83 c3 04             	add    $0x4,%ebx
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	eb c5                	jmp    80010f <umain+0x24>
		num(0, "<stdin>");
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	68 a4 25 80 00       	push   $0x8025a4
  800152:	6a 00                	push   $0x0
  800154:	e8 da fe ff ff       	call   800033 <num>
  800159:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015c:	e8 68 00 00 00       	call   8001c9 <exit>
}
  800161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	50                   	push   %eax
  80016d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800170:	ff 30                	pushl  (%eax)
  800172:	68 ac 25 80 00       	push   $0x8025ac
  800177:	6a 27                	push   $0x27
  800179:	68 80 25 80 00       	push   $0x802580
  80017e:	e8 60 00 00 00       	call   8001e3 <_panic>

00800183 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
  800188:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80018b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80018e:	e8 83 0b 00 00       	call   800d16 <sys_getenvid>
  800193:	25 ff 03 00 00       	and    $0x3ff,%eax
  800198:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80019b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a0:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a5:	85 db                	test   %ebx,%ebx
  8001a7:	7e 07                	jle    8001b0 <libmain+0x2d>
		binaryname = argv[0];
  8001a9:	8b 06                	mov    (%esi),%eax
  8001ab:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
  8001b5:	e8 31 ff ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8001ba:	e8 0a 00 00 00       	call   8001c9 <exit>
}
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c5:	5b                   	pop    %ebx
  8001c6:	5e                   	pop    %esi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    

008001c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001cf:	e8 66 0f 00 00       	call   80113a <close_all>
	sys_env_destroy(0);
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	6a 00                	push   $0x0
  8001d9:	e8 f7 0a 00 00       	call   800cd5 <sys_env_destroy>
}
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	56                   	push   %esi
  8001e7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001e8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001eb:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001f1:	e8 20 0b 00 00       	call   800d16 <sys_getenvid>
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	56                   	push   %esi
  800200:	50                   	push   %eax
  800201:	68 c8 25 80 00       	push   $0x8025c8
  800206:	e8 b3 00 00 00       	call   8002be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80020b:	83 c4 18             	add    $0x18,%esp
  80020e:	53                   	push   %ebx
  80020f:	ff 75 10             	pushl  0x10(%ebp)
  800212:	e8 56 00 00 00       	call   80026d <vcprintf>
	cprintf("\n");
  800217:	c7 04 24 17 2a 80 00 	movl   $0x802a17,(%esp)
  80021e:	e8 9b 00 00 00       	call   8002be <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800226:	cc                   	int3   
  800227:	eb fd                	jmp    800226 <_panic+0x43>

00800229 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	53                   	push   %ebx
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800233:	8b 13                	mov    (%ebx),%edx
  800235:	8d 42 01             	lea    0x1(%edx),%eax
  800238:	89 03                	mov    %eax,(%ebx)
  80023a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80023d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800241:	3d ff 00 00 00       	cmp    $0xff,%eax
  800246:	74 09                	je     800251 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800248:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80024c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80024f:	c9                   	leave  
  800250:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	68 ff 00 00 00       	push   $0xff
  800259:	8d 43 08             	lea    0x8(%ebx),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 36 0a 00 00       	call   800c98 <sys_cputs>
		b->idx = 0;
  800262:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	eb db                	jmp    800248 <putch+0x1f>

0080026d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800276:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027d:	00 00 00 
	b.cnt = 0;
  800280:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800287:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028a:	ff 75 0c             	pushl  0xc(%ebp)
  80028d:	ff 75 08             	pushl  0x8(%ebp)
  800290:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800296:	50                   	push   %eax
  800297:	68 29 02 80 00       	push   $0x800229
  80029c:	e8 1a 01 00 00       	call   8003bb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a1:	83 c4 08             	add    $0x8,%esp
  8002a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 e2 09 00 00       	call   800c98 <sys_cputs>

	return b.cnt;
}
  8002b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    

008002be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c7:	50                   	push   %eax
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	e8 9d ff ff ff       	call   80026d <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 1c             	sub    $0x1c,%esp
  8002db:	89 c7                	mov    %eax,%edi
  8002dd:	89 d6                	mov    %edx,%esi
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002f6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002f9:	39 d3                	cmp    %edx,%ebx
  8002fb:	72 05                	jb     800302 <printnum+0x30>
  8002fd:	39 45 10             	cmp    %eax,0x10(%ebp)
  800300:	77 7a                	ja     80037c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	ff 75 18             	pushl  0x18(%ebp)
  800308:	8b 45 14             	mov    0x14(%ebp),%eax
  80030b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80030e:	53                   	push   %ebx
  80030f:	ff 75 10             	pushl  0x10(%ebp)
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	ff 75 e4             	pushl  -0x1c(%ebp)
  800318:	ff 75 e0             	pushl  -0x20(%ebp)
  80031b:	ff 75 dc             	pushl  -0x24(%ebp)
  80031e:	ff 75 d8             	pushl  -0x28(%ebp)
  800321:	e8 ea 1f 00 00       	call   802310 <__udivdi3>
  800326:	83 c4 18             	add    $0x18,%esp
  800329:	52                   	push   %edx
  80032a:	50                   	push   %eax
  80032b:	89 f2                	mov    %esi,%edx
  80032d:	89 f8                	mov    %edi,%eax
  80032f:	e8 9e ff ff ff       	call   8002d2 <printnum>
  800334:	83 c4 20             	add    $0x20,%esp
  800337:	eb 13                	jmp    80034c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	56                   	push   %esi
  80033d:	ff 75 18             	pushl  0x18(%ebp)
  800340:	ff d7                	call   *%edi
  800342:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800345:	83 eb 01             	sub    $0x1,%ebx
  800348:	85 db                	test   %ebx,%ebx
  80034a:	7f ed                	jg     800339 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	56                   	push   %esi
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	ff 75 e0             	pushl  -0x20(%ebp)
  800359:	ff 75 dc             	pushl  -0x24(%ebp)
  80035c:	ff 75 d8             	pushl  -0x28(%ebp)
  80035f:	e8 cc 20 00 00       	call   802430 <__umoddi3>
  800364:	83 c4 14             	add    $0x14,%esp
  800367:	0f be 80 eb 25 80 00 	movsbl 0x8025eb(%eax),%eax
  80036e:	50                   	push   %eax
  80036f:	ff d7                	call   *%edi
}
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800377:	5b                   	pop    %ebx
  800378:	5e                   	pop    %esi
  800379:	5f                   	pop    %edi
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    
  80037c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80037f:	eb c4                	jmp    800345 <printnum+0x73>

00800381 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800387:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038b:	8b 10                	mov    (%eax),%edx
  80038d:	3b 50 04             	cmp    0x4(%eax),%edx
  800390:	73 0a                	jae    80039c <sprintputch+0x1b>
		*b->buf++ = ch;
  800392:	8d 4a 01             	lea    0x1(%edx),%ecx
  800395:	89 08                	mov    %ecx,(%eax)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	88 02                	mov    %al,(%edx)
}
  80039c:	5d                   	pop    %ebp
  80039d:	c3                   	ret    

0080039e <printfmt>:
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a7:	50                   	push   %eax
  8003a8:	ff 75 10             	pushl  0x10(%ebp)
  8003ab:	ff 75 0c             	pushl  0xc(%ebp)
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	e8 05 00 00 00       	call   8003bb <vprintfmt>
}
  8003b6:	83 c4 10             	add    $0x10,%esp
  8003b9:	c9                   	leave  
  8003ba:	c3                   	ret    

008003bb <vprintfmt>:
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	57                   	push   %edi
  8003bf:	56                   	push   %esi
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 2c             	sub    $0x2c,%esp
  8003c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003cd:	e9 21 04 00 00       	jmp    8007f3 <vprintfmt+0x438>
		padc = ' ';
  8003d2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003dd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003eb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8d 47 01             	lea    0x1(%edi),%eax
  8003f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f6:	0f b6 17             	movzbl (%edi),%edx
  8003f9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003fc:	3c 55                	cmp    $0x55,%al
  8003fe:	0f 87 90 04 00 00    	ja     800894 <vprintfmt+0x4d9>
  800404:	0f b6 c0             	movzbl %al,%eax
  800407:	ff 24 85 20 27 80 00 	jmp    *0x802720(,%eax,4)
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800411:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800415:	eb d9                	jmp    8003f0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80041a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80041e:	eb d0                	jmp    8003f0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	0f b6 d2             	movzbl %dl,%edx
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80042e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800431:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800435:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800438:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80043b:	83 f9 09             	cmp    $0x9,%ecx
  80043e:	77 55                	ja     800495 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800440:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800443:	eb e9                	jmp    80042e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800445:	8b 45 14             	mov    0x14(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 40 04             	lea    0x4(%eax),%eax
  800453:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800456:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800459:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045d:	79 91                	jns    8003f0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80045f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800462:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800465:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80046c:	eb 82                	jmp    8003f0 <vprintfmt+0x35>
  80046e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
  800478:	0f 49 d0             	cmovns %eax,%edx
  80047b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800481:	e9 6a ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800489:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800490:	e9 5b ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
  800495:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800498:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049b:	eb bc                	jmp    800459 <vprintfmt+0x9e>
			lflag++;
  80049d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a3:	e9 48 ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 78 04             	lea    0x4(%eax),%edi
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	53                   	push   %ebx
  8004b2:	ff 30                	pushl  (%eax)
  8004b4:	ff d6                	call   *%esi
			break;
  8004b6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004bc:	e9 2f 03 00 00       	jmp    8007f0 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 78 04             	lea    0x4(%eax),%edi
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	31 d0                	xor    %edx,%eax
  8004cc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ce:	83 f8 0f             	cmp    $0xf,%eax
  8004d1:	7f 23                	jg     8004f6 <vprintfmt+0x13b>
  8004d3:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  8004da:	85 d2                	test   %edx,%edx
  8004dc:	74 18                	je     8004f6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004de:	52                   	push   %edx
  8004df:	68 de 29 80 00       	push   $0x8029de
  8004e4:	53                   	push   %ebx
  8004e5:	56                   	push   %esi
  8004e6:	e8 b3 fe ff ff       	call   80039e <printfmt>
  8004eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ee:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f1:	e9 fa 02 00 00       	jmp    8007f0 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8004f6:	50                   	push   %eax
  8004f7:	68 03 26 80 00       	push   $0x802603
  8004fc:	53                   	push   %ebx
  8004fd:	56                   	push   %esi
  8004fe:	e8 9b fe ff ff       	call   80039e <printfmt>
  800503:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800506:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800509:	e9 e2 02 00 00       	jmp    8007f0 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80050e:	8b 45 14             	mov    0x14(%ebp),%eax
  800511:	83 c0 04             	add    $0x4,%eax
  800514:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80051c:	85 ff                	test   %edi,%edi
  80051e:	b8 fc 25 80 00       	mov    $0x8025fc,%eax
  800523:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800526:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052a:	0f 8e bd 00 00 00    	jle    8005ed <vprintfmt+0x232>
  800530:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800534:	75 0e                	jne    800544 <vprintfmt+0x189>
  800536:	89 75 08             	mov    %esi,0x8(%ebp)
  800539:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800542:	eb 6d                	jmp    8005b1 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	ff 75 d0             	pushl  -0x30(%ebp)
  80054a:	57                   	push   %edi
  80054b:	e8 ec 03 00 00       	call   80093c <strnlen>
  800550:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800553:	29 c1                	sub    %eax,%ecx
  800555:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800558:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80055b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800562:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800565:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800567:	eb 0f                	jmp    800578 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	ff 75 e0             	pushl  -0x20(%ebp)
  800570:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800572:	83 ef 01             	sub    $0x1,%edi
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	85 ff                	test   %edi,%edi
  80057a:	7f ed                	jg     800569 <vprintfmt+0x1ae>
  80057c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80057f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800582:	85 c9                	test   %ecx,%ecx
  800584:	b8 00 00 00 00       	mov    $0x0,%eax
  800589:	0f 49 c1             	cmovns %ecx,%eax
  80058c:	29 c1                	sub    %eax,%ecx
  80058e:	89 75 08             	mov    %esi,0x8(%ebp)
  800591:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800594:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800597:	89 cb                	mov    %ecx,%ebx
  800599:	eb 16                	jmp    8005b1 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80059b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80059f:	75 31                	jne    8005d2 <vprintfmt+0x217>
					putch(ch, putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	50                   	push   %eax
  8005a8:	ff 55 08             	call   *0x8(%ebp)
  8005ab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ae:	83 eb 01             	sub    $0x1,%ebx
  8005b1:	83 c7 01             	add    $0x1,%edi
  8005b4:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005b8:	0f be c2             	movsbl %dl,%eax
  8005bb:	85 c0                	test   %eax,%eax
  8005bd:	74 59                	je     800618 <vprintfmt+0x25d>
  8005bf:	85 f6                	test   %esi,%esi
  8005c1:	78 d8                	js     80059b <vprintfmt+0x1e0>
  8005c3:	83 ee 01             	sub    $0x1,%esi
  8005c6:	79 d3                	jns    80059b <vprintfmt+0x1e0>
  8005c8:	89 df                	mov    %ebx,%edi
  8005ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8005cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d0:	eb 37                	jmp    800609 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d2:	0f be d2             	movsbl %dl,%edx
  8005d5:	83 ea 20             	sub    $0x20,%edx
  8005d8:	83 fa 5e             	cmp    $0x5e,%edx
  8005db:	76 c4                	jbe    8005a1 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	6a 3f                	push   $0x3f
  8005e5:	ff 55 08             	call   *0x8(%ebp)
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	eb c1                	jmp    8005ae <vprintfmt+0x1f3>
  8005ed:	89 75 08             	mov    %esi,0x8(%ebp)
  8005f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005f6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f9:	eb b6                	jmp    8005b1 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 20                	push   $0x20
  800601:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800603:	83 ef 01             	sub    $0x1,%edi
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	85 ff                	test   %edi,%edi
  80060b:	7f ee                	jg     8005fb <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80060d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	e9 d8 01 00 00       	jmp    8007f0 <vprintfmt+0x435>
  800618:	89 df                	mov    %ebx,%edi
  80061a:	8b 75 08             	mov    0x8(%ebp),%esi
  80061d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800620:	eb e7                	jmp    800609 <vprintfmt+0x24e>
	if (lflag >= 2)
  800622:	83 f9 01             	cmp    $0x1,%ecx
  800625:	7e 45                	jle    80066c <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 50 04             	mov    0x4(%eax),%edx
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 40 08             	lea    0x8(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80063e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800642:	79 62                	jns    8006a6 <vprintfmt+0x2eb>
				putch('-', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 2d                	push   $0x2d
  80064a:	ff d6                	call   *%esi
				num = -(long long) num;
  80064c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800652:	f7 d8                	neg    %eax
  800654:	83 d2 00             	adc    $0x0,%edx
  800657:	f7 da                	neg    %edx
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800662:	ba 0a 00 00 00       	mov    $0xa,%edx
  800667:	e9 66 01 00 00       	jmp    8007d2 <vprintfmt+0x417>
	else if (lflag)
  80066c:	85 c9                	test   %ecx,%ecx
  80066e:	75 1b                	jne    80068b <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	89 c1                	mov    %eax,%ecx
  80067a:	c1 f9 1f             	sar    $0x1f,%ecx
  80067d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 40 04             	lea    0x4(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
  800689:	eb b3                	jmp    80063e <vprintfmt+0x283>
		return va_arg(*ap, long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800693:	89 c1                	mov    %eax,%ecx
  800695:	c1 f9 1f             	sar    $0x1f,%ecx
  800698:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a4:	eb 98                	jmp    80063e <vprintfmt+0x283>
			base = 10;
  8006a6:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006ab:	e9 22 01 00 00       	jmp    8007d2 <vprintfmt+0x417>
	if (lflag >= 2)
  8006b0:	83 f9 01             	cmp    $0x1,%ecx
  8006b3:	7e 21                	jle    8006d6 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 50 04             	mov    0x4(%eax),%edx
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 08             	lea    0x8(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006d1:	e9 fc 00 00 00       	jmp    8007d2 <vprintfmt+0x417>
	else if (lflag)
  8006d6:	85 c9                	test   %ecx,%ecx
  8006d8:	75 23                	jne    8006fd <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f3:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006f8:	e9 d5 00 00 00       	jmp    8007d2 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
  800707:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800716:	ba 0a 00 00 00       	mov    $0xa,%edx
  80071b:	e9 b2 00 00 00       	jmp    8007d2 <vprintfmt+0x417>
	if (lflag >= 2)
  800720:	83 f9 01             	cmp    $0x1,%ecx
  800723:	7e 42                	jle    800767 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 50 04             	mov    0x4(%eax),%edx
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 08             	lea    0x8(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073c:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800741:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800745:	0f 89 87 00 00 00    	jns    8007d2 <vprintfmt+0x417>
				putch('-', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 2d                	push   $0x2d
  800751:	ff d6                	call   *%esi
				num = -(long long) num;
  800753:	f7 5d d8             	negl   -0x28(%ebp)
  800756:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80075a:	f7 5d dc             	negl   -0x24(%ebp)
  80075d:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800760:	ba 08 00 00 00       	mov    $0x8,%edx
  800765:	eb 6b                	jmp    8007d2 <vprintfmt+0x417>
	else if (lflag)
  800767:	85 c9                	test   %ecx,%ecx
  800769:	75 1b                	jne    800786 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
  800775:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800778:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
  800784:	eb b6                	jmp    80073c <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
  80079f:	eb 9b                	jmp    80073c <vprintfmt+0x381>
			putch('0', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	53                   	push   %ebx
  8007a5:	6a 30                	push   $0x30
  8007a7:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a9:	83 c4 08             	add    $0x8,%esp
  8007ac:	53                   	push   %ebx
  8007ad:	6a 78                	push   $0x78
  8007af:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007be:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007c1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cd:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8007d2:	83 ec 0c             	sub    $0xc,%esp
  8007d5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8007d9:	50                   	push   %eax
  8007da:	ff 75 e0             	pushl  -0x20(%ebp)
  8007dd:	52                   	push   %edx
  8007de:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e4:	89 da                	mov    %ebx,%edx
  8007e6:	89 f0                	mov    %esi,%eax
  8007e8:	e8 e5 fa ff ff       	call   8002d2 <printnum>
			break;
  8007ed:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f3:	83 c7 01             	add    $0x1,%edi
  8007f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007fa:	83 f8 25             	cmp    $0x25,%eax
  8007fd:	0f 84 cf fb ff ff    	je     8003d2 <vprintfmt+0x17>
			if (ch == '\0')
  800803:	85 c0                	test   %eax,%eax
  800805:	0f 84 a9 00 00 00    	je     8008b4 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	53                   	push   %ebx
  80080f:	50                   	push   %eax
  800810:	ff d6                	call   *%esi
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	eb dc                	jmp    8007f3 <vprintfmt+0x438>
	if (lflag >= 2)
  800817:	83 f9 01             	cmp    $0x1,%ecx
  80081a:	7e 1e                	jle    80083a <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 50 04             	mov    0x4(%eax),%edx
  800822:	8b 00                	mov    (%eax),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800827:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8d 40 08             	lea    0x8(%eax),%eax
  800830:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800833:	ba 10 00 00 00       	mov    $0x10,%edx
  800838:	eb 98                	jmp    8007d2 <vprintfmt+0x417>
	else if (lflag)
  80083a:	85 c9                	test   %ecx,%ecx
  80083c:	75 23                	jne    800861 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	ba 00 00 00 00       	mov    $0x0,%edx
  800848:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800857:	ba 10 00 00 00       	mov    $0x10,%edx
  80085c:	e9 71 ff ff ff       	jmp    8007d2 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	ba 00 00 00 00       	mov    $0x0,%edx
  80086b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8d 40 04             	lea    0x4(%eax),%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087a:	ba 10 00 00 00       	mov    $0x10,%edx
  80087f:	e9 4e ff ff ff       	jmp    8007d2 <vprintfmt+0x417>
			putch(ch, putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	6a 25                	push   $0x25
  80088a:	ff d6                	call   *%esi
			break;
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	e9 5c ff ff ff       	jmp    8007f0 <vprintfmt+0x435>
			putch('%', putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	53                   	push   %ebx
  800898:	6a 25                	push   $0x25
  80089a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	89 f8                	mov    %edi,%eax
  8008a1:	eb 03                	jmp    8008a6 <vprintfmt+0x4eb>
  8008a3:	83 e8 01             	sub    $0x1,%eax
  8008a6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008aa:	75 f7                	jne    8008a3 <vprintfmt+0x4e8>
  8008ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008af:	e9 3c ff ff ff       	jmp    8007f0 <vprintfmt+0x435>
}
  8008b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008b7:	5b                   	pop    %ebx
  8008b8:	5e                   	pop    %esi
  8008b9:	5f                   	pop    %edi
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	83 ec 18             	sub    $0x18,%esp
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008cb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008cf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d9:	85 c0                	test   %eax,%eax
  8008db:	74 26                	je     800903 <vsnprintf+0x47>
  8008dd:	85 d2                	test   %edx,%edx
  8008df:	7e 22                	jle    800903 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e1:	ff 75 14             	pushl  0x14(%ebp)
  8008e4:	ff 75 10             	pushl  0x10(%ebp)
  8008e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	68 81 03 80 00       	push   $0x800381
  8008f0:	e8 c6 fa ff ff       	call   8003bb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
}
  800901:	c9                   	leave  
  800902:	c3                   	ret    
		return -E_INVAL;
  800903:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800908:	eb f7                	jmp    800901 <vsnprintf+0x45>

0080090a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800910:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800913:	50                   	push   %eax
  800914:	ff 75 10             	pushl  0x10(%ebp)
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	ff 75 08             	pushl  0x8(%ebp)
  80091d:	e8 9a ff ff ff       	call   8008bc <vsnprintf>
	va_end(ap);

	return rc;
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80092a:	b8 00 00 00 00       	mov    $0x0,%eax
  80092f:	eb 03                	jmp    800934 <strlen+0x10>
		n++;
  800931:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800934:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800938:	75 f7                	jne    800931 <strlen+0xd>
	return n;
}
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	eb 03                	jmp    80094f <strnlen+0x13>
		n++;
  80094c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094f:	39 d0                	cmp    %edx,%eax
  800951:	74 06                	je     800959 <strnlen+0x1d>
  800953:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800957:	75 f3                	jne    80094c <strnlen+0x10>
	return n;
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800965:	89 c2                	mov    %eax,%edx
  800967:	83 c1 01             	add    $0x1,%ecx
  80096a:	83 c2 01             	add    $0x1,%edx
  80096d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800971:	88 5a ff             	mov    %bl,-0x1(%edx)
  800974:	84 db                	test   %bl,%bl
  800976:	75 ef                	jne    800967 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800978:	5b                   	pop    %ebx
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	53                   	push   %ebx
  80097f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800982:	53                   	push   %ebx
  800983:	e8 9c ff ff ff       	call   800924 <strlen>
  800988:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	01 d8                	add    %ebx,%eax
  800990:	50                   	push   %eax
  800991:	e8 c5 ff ff ff       	call   80095b <strcpy>
	return dst;
}
  800996:	89 d8                	mov    %ebx,%eax
  800998:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a8:	89 f3                	mov    %esi,%ebx
  8009aa:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ad:	89 f2                	mov    %esi,%edx
  8009af:	eb 0f                	jmp    8009c0 <strncpy+0x23>
		*dst++ = *src;
  8009b1:	83 c2 01             	add    $0x1,%edx
  8009b4:	0f b6 01             	movzbl (%ecx),%eax
  8009b7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ba:	80 39 01             	cmpb   $0x1,(%ecx)
  8009bd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009c0:	39 da                	cmp    %ebx,%edx
  8009c2:	75 ed                	jne    8009b1 <strncpy+0x14>
	}
	return ret;
}
  8009c4:	89 f0                	mov    %esi,%eax
  8009c6:	5b                   	pop    %ebx
  8009c7:	5e                   	pop    %esi
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	56                   	push   %esi
  8009ce:	53                   	push   %ebx
  8009cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009d8:	89 f0                	mov    %esi,%eax
  8009da:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009de:	85 c9                	test   %ecx,%ecx
  8009e0:	75 0b                	jne    8009ed <strlcpy+0x23>
  8009e2:	eb 17                	jmp    8009fb <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009e4:	83 c2 01             	add    $0x1,%edx
  8009e7:	83 c0 01             	add    $0x1,%eax
  8009ea:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009ed:	39 d8                	cmp    %ebx,%eax
  8009ef:	74 07                	je     8009f8 <strlcpy+0x2e>
  8009f1:	0f b6 0a             	movzbl (%edx),%ecx
  8009f4:	84 c9                	test   %cl,%cl
  8009f6:	75 ec                	jne    8009e4 <strlcpy+0x1a>
		*dst = '\0';
  8009f8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fb:	29 f0                	sub    %esi,%eax
}
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a07:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a0a:	eb 06                	jmp    800a12 <strcmp+0x11>
		p++, q++;
  800a0c:	83 c1 01             	add    $0x1,%ecx
  800a0f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a12:	0f b6 01             	movzbl (%ecx),%eax
  800a15:	84 c0                	test   %al,%al
  800a17:	74 04                	je     800a1d <strcmp+0x1c>
  800a19:	3a 02                	cmp    (%edx),%al
  800a1b:	74 ef                	je     800a0c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1d:	0f b6 c0             	movzbl %al,%eax
  800a20:	0f b6 12             	movzbl (%edx),%edx
  800a23:	29 d0                	sub    %edx,%eax
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a31:	89 c3                	mov    %eax,%ebx
  800a33:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a36:	eb 06                	jmp    800a3e <strncmp+0x17>
		n--, p++, q++;
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3e:	39 d8                	cmp    %ebx,%eax
  800a40:	74 16                	je     800a58 <strncmp+0x31>
  800a42:	0f b6 08             	movzbl (%eax),%ecx
  800a45:	84 c9                	test   %cl,%cl
  800a47:	74 04                	je     800a4d <strncmp+0x26>
  800a49:	3a 0a                	cmp    (%edx),%cl
  800a4b:	74 eb                	je     800a38 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4d:	0f b6 00             	movzbl (%eax),%eax
  800a50:	0f b6 12             	movzbl (%edx),%edx
  800a53:	29 d0                	sub    %edx,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    
		return 0;
  800a58:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5d:	eb f6                	jmp    800a55 <strncmp+0x2e>

00800a5f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a69:	0f b6 10             	movzbl (%eax),%edx
  800a6c:	84 d2                	test   %dl,%dl
  800a6e:	74 09                	je     800a79 <strchr+0x1a>
		if (*s == c)
  800a70:	38 ca                	cmp    %cl,%dl
  800a72:	74 0a                	je     800a7e <strchr+0x1f>
	for (; *s; s++)
  800a74:	83 c0 01             	add    $0x1,%eax
  800a77:	eb f0                	jmp    800a69 <strchr+0xa>
			return (char *) s;
	return 0;
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8a:	eb 03                	jmp    800a8f <strfind+0xf>
  800a8c:	83 c0 01             	add    $0x1,%eax
  800a8f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a92:	38 ca                	cmp    %cl,%dl
  800a94:	74 04                	je     800a9a <strfind+0x1a>
  800a96:	84 d2                	test   %dl,%dl
  800a98:	75 f2                	jne    800a8c <strfind+0xc>
			break;
	return (char *) s;
}
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	57                   	push   %edi
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa8:	85 c9                	test   %ecx,%ecx
  800aaa:	74 13                	je     800abf <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aac:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ab2:	75 05                	jne    800ab9 <memset+0x1d>
  800ab4:	f6 c1 03             	test   $0x3,%cl
  800ab7:	74 0d                	je     800ac6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	fc                   	cld    
  800abd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abf:	89 f8                	mov    %edi,%eax
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    
		c &= 0xFF;
  800ac6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aca:	89 d3                	mov    %edx,%ebx
  800acc:	c1 e3 08             	shl    $0x8,%ebx
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	c1 e0 18             	shl    $0x18,%eax
  800ad4:	89 d6                	mov    %edx,%esi
  800ad6:	c1 e6 10             	shl    $0x10,%esi
  800ad9:	09 f0                	or     %esi,%eax
  800adb:	09 c2                	or     %eax,%edx
  800add:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800adf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	fc                   	cld    
  800ae5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae7:	eb d6                	jmp    800abf <memset+0x23>

00800ae9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	57                   	push   %edi
  800aed:	56                   	push   %esi
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af7:	39 c6                	cmp    %eax,%esi
  800af9:	73 35                	jae    800b30 <memmove+0x47>
  800afb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afe:	39 c2                	cmp    %eax,%edx
  800b00:	76 2e                	jbe    800b30 <memmove+0x47>
		s += n;
		d += n;
  800b02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b05:	89 d6                	mov    %edx,%esi
  800b07:	09 fe                	or     %edi,%esi
  800b09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0f:	74 0c                	je     800b1d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b11:	83 ef 01             	sub    $0x1,%edi
  800b14:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b17:	fd                   	std    
  800b18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1a:	fc                   	cld    
  800b1b:	eb 21                	jmp    800b3e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1d:	f6 c1 03             	test   $0x3,%cl
  800b20:	75 ef                	jne    800b11 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b22:	83 ef 04             	sub    $0x4,%edi
  800b25:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b2b:	fd                   	std    
  800b2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2e:	eb ea                	jmp    800b1a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b30:	89 f2                	mov    %esi,%edx
  800b32:	09 c2                	or     %eax,%edx
  800b34:	f6 c2 03             	test   $0x3,%dl
  800b37:	74 09                	je     800b42 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	fc                   	cld    
  800b3c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3e:	5e                   	pop    %esi
  800b3f:	5f                   	pop    %edi
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b42:	f6 c1 03             	test   $0x3,%cl
  800b45:	75 f2                	jne    800b39 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b47:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b4a:	89 c7                	mov    %eax,%edi
  800b4c:	fc                   	cld    
  800b4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4f:	eb ed                	jmp    800b3e <memmove+0x55>

00800b51 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b54:	ff 75 10             	pushl  0x10(%ebp)
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	ff 75 08             	pushl  0x8(%ebp)
  800b5d:	e8 87 ff ff ff       	call   800ae9 <memmove>
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6f:	89 c6                	mov    %eax,%esi
  800b71:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b74:	39 f0                	cmp    %esi,%eax
  800b76:	74 1c                	je     800b94 <memcmp+0x30>
		if (*s1 != *s2)
  800b78:	0f b6 08             	movzbl (%eax),%ecx
  800b7b:	0f b6 1a             	movzbl (%edx),%ebx
  800b7e:	38 d9                	cmp    %bl,%cl
  800b80:	75 08                	jne    800b8a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	83 c2 01             	add    $0x1,%edx
  800b88:	eb ea                	jmp    800b74 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b8a:	0f b6 c1             	movzbl %cl,%eax
  800b8d:	0f b6 db             	movzbl %bl,%ebx
  800b90:	29 d8                	sub    %ebx,%eax
  800b92:	eb 05                	jmp    800b99 <memcmp+0x35>
	}

	return 0;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba6:	89 c2                	mov    %eax,%edx
  800ba8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bab:	39 d0                	cmp    %edx,%eax
  800bad:	73 09                	jae    800bb8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800baf:	38 08                	cmp    %cl,(%eax)
  800bb1:	74 05                	je     800bb8 <memfind+0x1b>
	for (; s < ends; s++)
  800bb3:	83 c0 01             	add    $0x1,%eax
  800bb6:	eb f3                	jmp    800bab <memfind+0xe>
			break;
	return (void *) s;
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
  800bc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc6:	eb 03                	jmp    800bcb <strtol+0x11>
		s++;
  800bc8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bcb:	0f b6 01             	movzbl (%ecx),%eax
  800bce:	3c 20                	cmp    $0x20,%al
  800bd0:	74 f6                	je     800bc8 <strtol+0xe>
  800bd2:	3c 09                	cmp    $0x9,%al
  800bd4:	74 f2                	je     800bc8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bd6:	3c 2b                	cmp    $0x2b,%al
  800bd8:	74 2e                	je     800c08 <strtol+0x4e>
	int neg = 0;
  800bda:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bdf:	3c 2d                	cmp    $0x2d,%al
  800be1:	74 2f                	je     800c12 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be9:	75 05                	jne    800bf0 <strtol+0x36>
  800beb:	80 39 30             	cmpb   $0x30,(%ecx)
  800bee:	74 2c                	je     800c1c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf0:	85 db                	test   %ebx,%ebx
  800bf2:	75 0a                	jne    800bfe <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bf9:	80 39 30             	cmpb   $0x30,(%ecx)
  800bfc:	74 28                	je     800c26 <strtol+0x6c>
		base = 10;
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c06:	eb 50                	jmp    800c58 <strtol+0x9e>
		s++;
  800c08:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c10:	eb d1                	jmp    800be3 <strtol+0x29>
		s++, neg = 1;
  800c12:	83 c1 01             	add    $0x1,%ecx
  800c15:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1a:	eb c7                	jmp    800be3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c20:	74 0e                	je     800c30 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c22:	85 db                	test   %ebx,%ebx
  800c24:	75 d8                	jne    800bfe <strtol+0x44>
		s++, base = 8;
  800c26:	83 c1 01             	add    $0x1,%ecx
  800c29:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2e:	eb ce                	jmp    800bfe <strtol+0x44>
		s += 2, base = 16;
  800c30:	83 c1 02             	add    $0x2,%ecx
  800c33:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c38:	eb c4                	jmp    800bfe <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c3a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c3d:	89 f3                	mov    %esi,%ebx
  800c3f:	80 fb 19             	cmp    $0x19,%bl
  800c42:	77 29                	ja     800c6d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c44:	0f be d2             	movsbl %dl,%edx
  800c47:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c4a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4d:	7d 30                	jge    800c7f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c4f:	83 c1 01             	add    $0x1,%ecx
  800c52:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c56:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c58:	0f b6 11             	movzbl (%ecx),%edx
  800c5b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5e:	89 f3                	mov    %esi,%ebx
  800c60:	80 fb 09             	cmp    $0x9,%bl
  800c63:	77 d5                	ja     800c3a <strtol+0x80>
			dig = *s - '0';
  800c65:	0f be d2             	movsbl %dl,%edx
  800c68:	83 ea 30             	sub    $0x30,%edx
  800c6b:	eb dd                	jmp    800c4a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c6d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c70:	89 f3                	mov    %esi,%ebx
  800c72:	80 fb 19             	cmp    $0x19,%bl
  800c75:	77 08                	ja     800c7f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c77:	0f be d2             	movsbl %dl,%edx
  800c7a:	83 ea 37             	sub    $0x37,%edx
  800c7d:	eb cb                	jmp    800c4a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c83:	74 05                	je     800c8a <strtol+0xd0>
		*endptr = (char *) s;
  800c85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c88:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8a:	89 c2                	mov    %eax,%edx
  800c8c:	f7 da                	neg    %edx
  800c8e:	85 ff                	test   %edi,%edi
  800c90:	0f 45 c2             	cmovne %edx,%eax
}
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	89 c3                	mov    %eax,%ebx
  800cab:	89 c7                	mov    %eax,%edi
  800cad:	89 c6                	mov    %eax,%esi
  800caf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	57                   	push   %edi
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc1:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc6:	89 d1                	mov    %edx,%ecx
  800cc8:	89 d3                	mov    %edx,%ebx
  800cca:	89 d7                	mov    %edx,%edi
  800ccc:	89 d6                	mov    %edx,%esi
  800cce:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
  800cdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cde:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	b8 03 00 00 00       	mov    $0x3,%eax
  800ceb:	89 cb                	mov    %ecx,%ebx
  800ced:	89 cf                	mov    %ecx,%edi
  800cef:	89 ce                	mov    %ecx,%esi
  800cf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	50                   	push   %eax
  800d03:	6a 03                	push   $0x3
  800d05:	68 df 28 80 00       	push   $0x8028df
  800d0a:	6a 23                	push   $0x23
  800d0c:	68 fc 28 80 00       	push   $0x8028fc
  800d11:	e8 cd f4 ff ff       	call   8001e3 <_panic>

00800d16 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d21:	b8 02 00 00 00       	mov    $0x2,%eax
  800d26:	89 d1                	mov    %edx,%ecx
  800d28:	89 d3                	mov    %edx,%ebx
  800d2a:	89 d7                	mov    %edx,%edi
  800d2c:	89 d6                	mov    %edx,%esi
  800d2e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_yield>:

void
sys_yield(void)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d40:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d45:	89 d1                	mov    %edx,%ecx
  800d47:	89 d3                	mov    %edx,%ebx
  800d49:	89 d7                	mov    %edx,%edi
  800d4b:	89 d6                	mov    %edx,%esi
  800d4d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5d:	be 00 00 00 00       	mov    $0x0,%esi
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	b8 04 00 00 00       	mov    $0x4,%eax
  800d6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d70:	89 f7                	mov    %esi,%edi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d84:	6a 04                	push   $0x4
  800d86:	68 df 28 80 00       	push   $0x8028df
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 fc 28 80 00       	push   $0x8028fc
  800d92:	e8 4c f4 ff ff       	call   8001e3 <_panic>

00800d97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	b8 05 00 00 00       	mov    $0x5,%eax
  800dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db1:	8b 75 18             	mov    0x18(%ebp),%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800dc6:	6a 05                	push   $0x5
  800dc8:	68 df 28 80 00       	push   $0x8028df
  800dcd:	6a 23                	push   $0x23
  800dcf:	68 fc 28 80 00       	push   $0x8028fc
  800dd4:	e8 0a f4 ff ff       	call   8001e3 <_panic>

00800dd9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ded:	b8 06 00 00 00       	mov    $0x6,%eax
  800df2:	89 df                	mov    %ebx,%edi
  800df4:	89 de                	mov    %ebx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 06                	push   $0x6
  800e0a:	68 df 28 80 00       	push   $0x8028df
  800e0f:	6a 23                	push   $0x23
  800e11:	68 fc 28 80 00       	push   $0x8028fc
  800e16:	e8 c8 f3 ff ff       	call   8001e3 <_panic>

00800e1b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7f 08                	jg     800e46 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	50                   	push   %eax
  800e4a:	6a 08                	push   $0x8
  800e4c:	68 df 28 80 00       	push   $0x8028df
  800e51:	6a 23                	push   $0x23
  800e53:	68 fc 28 80 00       	push   $0x8028fc
  800e58:	e8 86 f3 ff ff       	call   8001e3 <_panic>

00800e5d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	b8 09 00 00 00       	mov    $0x9,%eax
  800e76:	89 df                	mov    %ebx,%edi
  800e78:	89 de                	mov    %ebx,%esi
  800e7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7f 08                	jg     800e88 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e88:	83 ec 0c             	sub    $0xc,%esp
  800e8b:	50                   	push   %eax
  800e8c:	6a 09                	push   $0x9
  800e8e:	68 df 28 80 00       	push   $0x8028df
  800e93:	6a 23                	push   $0x23
  800e95:	68 fc 28 80 00       	push   $0x8028fc
  800e9a:	e8 44 f3 ff ff       	call   8001e3 <_panic>

00800e9f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 0a                	push   $0xa
  800ed0:	68 df 28 80 00       	push   $0x8028df
  800ed5:	6a 23                	push   $0x23
  800ed7:	68 fc 28 80 00       	push   $0x8028fc
  800edc:	e8 02 f3 ff ff       	call   8001e3 <_panic>

00800ee1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef2:	be 00 00 00 00       	mov    $0x0,%esi
  800ef7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efa:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
  800f0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f12:	8b 55 08             	mov    0x8(%ebp),%edx
  800f15:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1a:	89 cb                	mov    %ecx,%ebx
  800f1c:	89 cf                	mov    %ecx,%edi
  800f1e:	89 ce                	mov    %ecx,%esi
  800f20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7f 08                	jg     800f2e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	50                   	push   %eax
  800f32:	6a 0d                	push   $0xd
  800f34:	68 df 28 80 00       	push   $0x8028df
  800f39:	6a 23                	push   $0x23
  800f3b:	68 fc 28 80 00       	push   $0x8028fc
  800f40:	e8 9e f2 ff ff       	call   8001e3 <_panic>

00800f45 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f50:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f55:	89 d1                	mov    %edx,%ecx
  800f57:	89 d3                	mov    %edx,%ebx
  800f59:	89 d7                	mov    %edx,%edi
  800f5b:	89 d6                	mov    %edx,%esi
  800f5d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5f                   	pop    %edi
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	05 00 00 00 30       	add    $0x30000000,%eax
  800f6f:	c1 e8 0c             	shr    $0xc,%eax
}
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f84:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f91:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f96:	89 c2                	mov    %eax,%edx
  800f98:	c1 ea 16             	shr    $0x16,%edx
  800f9b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fa2:	f6 c2 01             	test   $0x1,%dl
  800fa5:	74 2a                	je     800fd1 <fd_alloc+0x46>
  800fa7:	89 c2                	mov    %eax,%edx
  800fa9:	c1 ea 0c             	shr    $0xc,%edx
  800fac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb3:	f6 c2 01             	test   $0x1,%dl
  800fb6:	74 19                	je     800fd1 <fd_alloc+0x46>
  800fb8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fbd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fc2:	75 d2                	jne    800f96 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fc4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fca:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fcf:	eb 07                	jmp    800fd8 <fd_alloc+0x4d>
			*fd_store = fd;
  800fd1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fe0:	83 f8 1f             	cmp    $0x1f,%eax
  800fe3:	77 36                	ja     80101b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fe5:	c1 e0 0c             	shl    $0xc,%eax
  800fe8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	c1 ea 16             	shr    $0x16,%edx
  800ff2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff9:	f6 c2 01             	test   $0x1,%dl
  800ffc:	74 24                	je     801022 <fd_lookup+0x48>
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	c1 ea 0c             	shr    $0xc,%edx
  801003:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80100a:	f6 c2 01             	test   $0x1,%dl
  80100d:	74 1a                	je     801029 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80100f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801012:	89 02                	mov    %eax,(%edx)
	return 0;
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    
		return -E_INVAL;
  80101b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801020:	eb f7                	jmp    801019 <fd_lookup+0x3f>
		return -E_INVAL;
  801022:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801027:	eb f0                	jmp    801019 <fd_lookup+0x3f>
  801029:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102e:	eb e9                	jmp    801019 <fd_lookup+0x3f>

00801030 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 08             	sub    $0x8,%esp
  801036:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801039:	ba 88 29 80 00       	mov    $0x802988,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80103e:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801043:	39 08                	cmp    %ecx,(%eax)
  801045:	74 33                	je     80107a <dev_lookup+0x4a>
  801047:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80104a:	8b 02                	mov    (%edx),%eax
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 f3                	jne    801043 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801050:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801055:	8b 40 48             	mov    0x48(%eax),%eax
  801058:	83 ec 04             	sub    $0x4,%esp
  80105b:	51                   	push   %ecx
  80105c:	50                   	push   %eax
  80105d:	68 0c 29 80 00       	push   $0x80290c
  801062:	e8 57 f2 ff ff       	call   8002be <cprintf>
	*dev = 0;
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    
			*dev = devtab[i];
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80107f:	b8 00 00 00 00       	mov    $0x0,%eax
  801084:	eb f2                	jmp    801078 <dev_lookup+0x48>

00801086 <fd_close>:
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	57                   	push   %edi
  80108a:	56                   	push   %esi
  80108b:	53                   	push   %ebx
  80108c:	83 ec 1c             	sub    $0x1c,%esp
  80108f:	8b 75 08             	mov    0x8(%ebp),%esi
  801092:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801095:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801098:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801099:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80109f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010a2:	50                   	push   %eax
  8010a3:	e8 32 ff ff ff       	call   800fda <fd_lookup>
  8010a8:	89 c3                	mov    %eax,%ebx
  8010aa:	83 c4 08             	add    $0x8,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 05                	js     8010b6 <fd_close+0x30>
	    || fd != fd2)
  8010b1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010b4:	74 16                	je     8010cc <fd_close+0x46>
		return (must_exist ? r : 0);
  8010b6:	89 f8                	mov    %edi,%eax
  8010b8:	84 c0                	test   %al,%al
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bf:	0f 44 d8             	cmove  %eax,%ebx
}
  8010c2:	89 d8                	mov    %ebx,%eax
  8010c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 36                	pushl  (%esi)
  8010d5:	e8 56 ff ff ff       	call   801030 <dev_lookup>
  8010da:	89 c3                	mov    %eax,%ebx
  8010dc:	83 c4 10             	add    $0x10,%esp
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	78 15                	js     8010f8 <fd_close+0x72>
		if (dev->dev_close)
  8010e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010e6:	8b 40 10             	mov    0x10(%eax),%eax
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	74 1b                	je     801108 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	56                   	push   %esi
  8010f1:	ff d0                	call   *%eax
  8010f3:	89 c3                	mov    %eax,%ebx
  8010f5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	56                   	push   %esi
  8010fc:	6a 00                	push   $0x0
  8010fe:	e8 d6 fc ff ff       	call   800dd9 <sys_page_unmap>
	return r;
  801103:	83 c4 10             	add    $0x10,%esp
  801106:	eb ba                	jmp    8010c2 <fd_close+0x3c>
			r = 0;
  801108:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110d:	eb e9                	jmp    8010f8 <fd_close+0x72>

0080110f <close>:

int
close(int fdnum)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801115:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801118:	50                   	push   %eax
  801119:	ff 75 08             	pushl  0x8(%ebp)
  80111c:	e8 b9 fe ff ff       	call   800fda <fd_lookup>
  801121:	83 c4 08             	add    $0x8,%esp
  801124:	85 c0                	test   %eax,%eax
  801126:	78 10                	js     801138 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	6a 01                	push   $0x1
  80112d:	ff 75 f4             	pushl  -0xc(%ebp)
  801130:	e8 51 ff ff ff       	call   801086 <fd_close>
  801135:	83 c4 10             	add    $0x10,%esp
}
  801138:	c9                   	leave  
  801139:	c3                   	ret    

0080113a <close_all>:

void
close_all(void)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	53                   	push   %ebx
  80113e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801141:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	53                   	push   %ebx
  80114a:	e8 c0 ff ff ff       	call   80110f <close>
	for (i = 0; i < MAXFD; i++)
  80114f:	83 c3 01             	add    $0x1,%ebx
  801152:	83 c4 10             	add    $0x10,%esp
  801155:	83 fb 20             	cmp    $0x20,%ebx
  801158:	75 ec                	jne    801146 <close_all+0xc>
}
  80115a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	57                   	push   %edi
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
  801165:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801168:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80116b:	50                   	push   %eax
  80116c:	ff 75 08             	pushl  0x8(%ebp)
  80116f:	e8 66 fe ff ff       	call   800fda <fd_lookup>
  801174:	89 c3                	mov    %eax,%ebx
  801176:	83 c4 08             	add    $0x8,%esp
  801179:	85 c0                	test   %eax,%eax
  80117b:	0f 88 81 00 00 00    	js     801202 <dup+0xa3>
		return r;
	close(newfdnum);
  801181:	83 ec 0c             	sub    $0xc,%esp
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	e8 83 ff ff ff       	call   80110f <close>

	newfd = INDEX2FD(newfdnum);
  80118c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80118f:	c1 e6 0c             	shl    $0xc,%esi
  801192:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80119e:	e8 d1 fd ff ff       	call   800f74 <fd2data>
  8011a3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011a5:	89 34 24             	mov    %esi,(%esp)
  8011a8:	e8 c7 fd ff ff       	call   800f74 <fd2data>
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011b2:	89 d8                	mov    %ebx,%eax
  8011b4:	c1 e8 16             	shr    $0x16,%eax
  8011b7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011be:	a8 01                	test   $0x1,%al
  8011c0:	74 11                	je     8011d3 <dup+0x74>
  8011c2:	89 d8                	mov    %ebx,%eax
  8011c4:	c1 e8 0c             	shr    $0xc,%eax
  8011c7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011ce:	f6 c2 01             	test   $0x1,%dl
  8011d1:	75 39                	jne    80120c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011d6:	89 d0                	mov    %edx,%eax
  8011d8:	c1 e8 0c             	shr    $0xc,%eax
  8011db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ea:	50                   	push   %eax
  8011eb:	56                   	push   %esi
  8011ec:	6a 00                	push   $0x0
  8011ee:	52                   	push   %edx
  8011ef:	6a 00                	push   $0x0
  8011f1:	e8 a1 fb ff ff       	call   800d97 <sys_page_map>
  8011f6:	89 c3                	mov    %eax,%ebx
  8011f8:	83 c4 20             	add    $0x20,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	78 31                	js     801230 <dup+0xd1>
		goto err;

	return newfdnum;
  8011ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801202:	89 d8                	mov    %ebx,%eax
  801204:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80120c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	25 07 0e 00 00       	and    $0xe07,%eax
  80121b:	50                   	push   %eax
  80121c:	57                   	push   %edi
  80121d:	6a 00                	push   $0x0
  80121f:	53                   	push   %ebx
  801220:	6a 00                	push   $0x0
  801222:	e8 70 fb ff ff       	call   800d97 <sys_page_map>
  801227:	89 c3                	mov    %eax,%ebx
  801229:	83 c4 20             	add    $0x20,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	79 a3                	jns    8011d3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801230:	83 ec 08             	sub    $0x8,%esp
  801233:	56                   	push   %esi
  801234:	6a 00                	push   $0x0
  801236:	e8 9e fb ff ff       	call   800dd9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80123b:	83 c4 08             	add    $0x8,%esp
  80123e:	57                   	push   %edi
  80123f:	6a 00                	push   $0x0
  801241:	e8 93 fb ff ff       	call   800dd9 <sys_page_unmap>
	return r;
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	eb b7                	jmp    801202 <dup+0xa3>

0080124b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	53                   	push   %ebx
  80124f:	83 ec 14             	sub    $0x14,%esp
  801252:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801255:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801258:	50                   	push   %eax
  801259:	53                   	push   %ebx
  80125a:	e8 7b fd ff ff       	call   800fda <fd_lookup>
  80125f:	83 c4 08             	add    $0x8,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	78 3f                	js     8012a5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801266:	83 ec 08             	sub    $0x8,%esp
  801269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126c:	50                   	push   %eax
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801270:	ff 30                	pushl  (%eax)
  801272:	e8 b9 fd ff ff       	call   801030 <dev_lookup>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 27                	js     8012a5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80127e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801281:	8b 42 08             	mov    0x8(%edx),%eax
  801284:	83 e0 03             	and    $0x3,%eax
  801287:	83 f8 01             	cmp    $0x1,%eax
  80128a:	74 1e                	je     8012aa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	8b 40 08             	mov    0x8(%eax),%eax
  801292:	85 c0                	test   %eax,%eax
  801294:	74 35                	je     8012cb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	ff 75 10             	pushl  0x10(%ebp)
  80129c:	ff 75 0c             	pushl  0xc(%ebp)
  80129f:	52                   	push   %edx
  8012a0:	ff d0                	call   *%eax
  8012a2:	83 c4 10             	add    $0x10,%esp
}
  8012a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012aa:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012af:	8b 40 48             	mov    0x48(%eax),%eax
  8012b2:	83 ec 04             	sub    $0x4,%esp
  8012b5:	53                   	push   %ebx
  8012b6:	50                   	push   %eax
  8012b7:	68 4d 29 80 00       	push   $0x80294d
  8012bc:	e8 fd ef ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c9:	eb da                	jmp    8012a5 <read+0x5a>
		return -E_NOT_SUPP;
  8012cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d0:	eb d3                	jmp    8012a5 <read+0x5a>

008012d2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012de:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e6:	39 f3                	cmp    %esi,%ebx
  8012e8:	73 25                	jae    80130f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	89 f0                	mov    %esi,%eax
  8012ef:	29 d8                	sub    %ebx,%eax
  8012f1:	50                   	push   %eax
  8012f2:	89 d8                	mov    %ebx,%eax
  8012f4:	03 45 0c             	add    0xc(%ebp),%eax
  8012f7:	50                   	push   %eax
  8012f8:	57                   	push   %edi
  8012f9:	e8 4d ff ff ff       	call   80124b <read>
		if (m < 0)
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 08                	js     80130d <readn+0x3b>
			return m;
		if (m == 0)
  801305:	85 c0                	test   %eax,%eax
  801307:	74 06                	je     80130f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801309:	01 c3                	add    %eax,%ebx
  80130b:	eb d9                	jmp    8012e6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80130d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80130f:	89 d8                	mov    %ebx,%eax
  801311:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801314:	5b                   	pop    %ebx
  801315:	5e                   	pop    %esi
  801316:	5f                   	pop    %edi
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	53                   	push   %ebx
  80131d:	83 ec 14             	sub    $0x14,%esp
  801320:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801323:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801326:	50                   	push   %eax
  801327:	53                   	push   %ebx
  801328:	e8 ad fc ff ff       	call   800fda <fd_lookup>
  80132d:	83 c4 08             	add    $0x8,%esp
  801330:	85 c0                	test   %eax,%eax
  801332:	78 3a                	js     80136e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133e:	ff 30                	pushl  (%eax)
  801340:	e8 eb fc ff ff       	call   801030 <dev_lookup>
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	78 22                	js     80136e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801353:	74 1e                	je     801373 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801355:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801358:	8b 52 0c             	mov    0xc(%edx),%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	74 35                	je     801394 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80135f:	83 ec 04             	sub    $0x4,%esp
  801362:	ff 75 10             	pushl  0x10(%ebp)
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	50                   	push   %eax
  801369:	ff d2                	call   *%edx
  80136b:	83 c4 10             	add    $0x10,%esp
}
  80136e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801371:	c9                   	leave  
  801372:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801373:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801378:	8b 40 48             	mov    0x48(%eax),%eax
  80137b:	83 ec 04             	sub    $0x4,%esp
  80137e:	53                   	push   %ebx
  80137f:	50                   	push   %eax
  801380:	68 69 29 80 00       	push   $0x802969
  801385:	e8 34 ef ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801392:	eb da                	jmp    80136e <write+0x55>
		return -E_NOT_SUPP;
  801394:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801399:	eb d3                	jmp    80136e <write+0x55>

0080139b <seek>:

int
seek(int fdnum, off_t offset)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a1:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	ff 75 08             	pushl  0x8(%ebp)
  8013a8:	e8 2d fc ff ff       	call   800fda <fd_lookup>
  8013ad:	83 c4 08             	add    $0x8,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 0e                	js     8013c2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ba:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	53                   	push   %ebx
  8013c8:	83 ec 14             	sub    $0x14,%esp
  8013cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d1:	50                   	push   %eax
  8013d2:	53                   	push   %ebx
  8013d3:	e8 02 fc ff ff       	call   800fda <fd_lookup>
  8013d8:	83 c4 08             	add    $0x8,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 37                	js     801416 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e5:	50                   	push   %eax
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e9:	ff 30                	pushl  (%eax)
  8013eb:	e8 40 fc ff ff       	call   801030 <dev_lookup>
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 1f                	js     801416 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013fe:	74 1b                	je     80141b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801403:	8b 52 18             	mov    0x18(%edx),%edx
  801406:	85 d2                	test   %edx,%edx
  801408:	74 32                	je     80143c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80140a:	83 ec 08             	sub    $0x8,%esp
  80140d:	ff 75 0c             	pushl  0xc(%ebp)
  801410:	50                   	push   %eax
  801411:	ff d2                	call   *%edx
  801413:	83 c4 10             	add    $0x10,%esp
}
  801416:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801419:	c9                   	leave  
  80141a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80141b:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801420:	8b 40 48             	mov    0x48(%eax),%eax
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	53                   	push   %ebx
  801427:	50                   	push   %eax
  801428:	68 2c 29 80 00       	push   $0x80292c
  80142d:	e8 8c ee ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  801432:	83 c4 10             	add    $0x10,%esp
  801435:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80143a:	eb da                	jmp    801416 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80143c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801441:	eb d3                	jmp    801416 <ftruncate+0x52>

00801443 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	53                   	push   %ebx
  801447:	83 ec 14             	sub    $0x14,%esp
  80144a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801450:	50                   	push   %eax
  801451:	ff 75 08             	pushl  0x8(%ebp)
  801454:	e8 81 fb ff ff       	call   800fda <fd_lookup>
  801459:	83 c4 08             	add    $0x8,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 4b                	js     8014ab <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146a:	ff 30                	pushl  (%eax)
  80146c:	e8 bf fb ff ff       	call   801030 <dev_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 33                	js     8014ab <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80147f:	74 2f                	je     8014b0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801481:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801484:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80148b:	00 00 00 
	stat->st_isdir = 0;
  80148e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801495:	00 00 00 
	stat->st_dev = dev;
  801498:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	53                   	push   %ebx
  8014a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8014a5:	ff 50 14             	call   *0x14(%eax)
  8014a8:	83 c4 10             	add    $0x10,%esp
}
  8014ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    
		return -E_NOT_SUPP;
  8014b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b5:	eb f4                	jmp    8014ab <fstat+0x68>

008014b7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	6a 00                	push   $0x0
  8014c1:	ff 75 08             	pushl  0x8(%ebp)
  8014c4:	e8 26 02 00 00       	call   8016ef <open>
  8014c9:	89 c3                	mov    %eax,%ebx
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 1b                	js     8014ed <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	ff 75 0c             	pushl  0xc(%ebp)
  8014d8:	50                   	push   %eax
  8014d9:	e8 65 ff ff ff       	call   801443 <fstat>
  8014de:	89 c6                	mov    %eax,%esi
	close(fd);
  8014e0:	89 1c 24             	mov    %ebx,(%esp)
  8014e3:	e8 27 fc ff ff       	call   80110f <close>
	return r;
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	89 f3                	mov    %esi,%ebx
}
  8014ed:	89 d8                	mov    %ebx,%eax
  8014ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f2:	5b                   	pop    %ebx
  8014f3:	5e                   	pop    %esi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    

008014f6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	56                   	push   %esi
  8014fa:	53                   	push   %ebx
  8014fb:	89 c6                	mov    %eax,%esi
  8014fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014ff:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801506:	74 27                	je     80152f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801508:	6a 07                	push   $0x7
  80150a:	68 00 50 80 00       	push   $0x805000
  80150f:	56                   	push   %esi
  801510:	ff 35 04 40 80 00    	pushl  0x804004
  801516:	e8 26 0d 00 00       	call   802241 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80151b:	83 c4 0c             	add    $0xc,%esp
  80151e:	6a 00                	push   $0x0
  801520:	53                   	push   %ebx
  801521:	6a 00                	push   $0x0
  801523:	e8 b0 0c 00 00       	call   8021d8 <ipc_recv>
}
  801528:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152b:	5b                   	pop    %ebx
  80152c:	5e                   	pop    %esi
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80152f:	83 ec 0c             	sub    $0xc,%esp
  801532:	6a 01                	push   $0x1
  801534:	e8 61 0d 00 00       	call   80229a <ipc_find_env>
  801539:	a3 04 40 80 00       	mov    %eax,0x804004
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	eb c5                	jmp    801508 <fsipc+0x12>

00801543 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	8b 40 0c             	mov    0xc(%eax),%eax
  80154f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80155c:	ba 00 00 00 00       	mov    $0x0,%edx
  801561:	b8 02 00 00 00       	mov    $0x2,%eax
  801566:	e8 8b ff ff ff       	call   8014f6 <fsipc>
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <devfile_flush>:
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8b 40 0c             	mov    0xc(%eax),%eax
  801579:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80157e:	ba 00 00 00 00       	mov    $0x0,%edx
  801583:	b8 06 00 00 00       	mov    $0x6,%eax
  801588:	e8 69 ff ff ff       	call   8014f6 <fsipc>
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <devfile_stat>:
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	53                   	push   %ebx
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8b 40 0c             	mov    0xc(%eax),%eax
  80159f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8015ae:	e8 43 ff ff ff       	call   8014f6 <fsipc>
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 2c                	js     8015e3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015b7:	83 ec 08             	sub    $0x8,%esp
  8015ba:	68 00 50 80 00       	push   $0x805000
  8015bf:	53                   	push   %ebx
  8015c0:	e8 96 f3 ff ff       	call   80095b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015c5:	a1 80 50 80 00       	mov    0x805080,%eax
  8015ca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015d0:	a1 84 50 80 00       	mov    0x805084,%eax
  8015d5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <devfile_write>:
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	53                   	push   %ebx
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8015fd:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801603:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801609:	77 30                	ja     80163b <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	53                   	push   %ebx
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	68 08 50 80 00       	push   $0x805008
  801617:	e8 cd f4 ff ff       	call   800ae9 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80161c:	ba 00 00 00 00       	mov    $0x0,%edx
  801621:	b8 04 00 00 00       	mov    $0x4,%eax
  801626:	e8 cb fe ff ff       	call   8014f6 <fsipc>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 04                	js     801636 <devfile_write+0x4e>
	assert(r <= n);
  801632:	39 d8                	cmp    %ebx,%eax
  801634:	77 1e                	ja     801654 <devfile_write+0x6c>
}
  801636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801639:	c9                   	leave  
  80163a:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80163b:	68 9c 29 80 00       	push   $0x80299c
  801640:	68 cc 29 80 00       	push   $0x8029cc
  801645:	68 94 00 00 00       	push   $0x94
  80164a:	68 e1 29 80 00       	push   $0x8029e1
  80164f:	e8 8f eb ff ff       	call   8001e3 <_panic>
	assert(r <= n);
  801654:	68 ec 29 80 00       	push   $0x8029ec
  801659:	68 cc 29 80 00       	push   $0x8029cc
  80165e:	68 98 00 00 00       	push   $0x98
  801663:	68 e1 29 80 00       	push   $0x8029e1
  801668:	e8 76 eb ff ff       	call   8001e3 <_panic>

0080166d <devfile_read>:
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
  801672:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8b 40 0c             	mov    0xc(%eax),%eax
  80167b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801680:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	b8 03 00 00 00       	mov    $0x3,%eax
  801690:	e8 61 fe ff ff       	call   8014f6 <fsipc>
  801695:	89 c3                	mov    %eax,%ebx
  801697:	85 c0                	test   %eax,%eax
  801699:	78 1f                	js     8016ba <devfile_read+0x4d>
	assert(r <= n);
  80169b:	39 f0                	cmp    %esi,%eax
  80169d:	77 24                	ja     8016c3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80169f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016a4:	7f 33                	jg     8016d9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	50                   	push   %eax
  8016aa:	68 00 50 80 00       	push   $0x805000
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	e8 32 f4 ff ff       	call   800ae9 <memmove>
	return r;
  8016b7:	83 c4 10             	add    $0x10,%esp
}
  8016ba:	89 d8                	mov    %ebx,%eax
  8016bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016bf:	5b                   	pop    %ebx
  8016c0:	5e                   	pop    %esi
  8016c1:	5d                   	pop    %ebp
  8016c2:	c3                   	ret    
	assert(r <= n);
  8016c3:	68 ec 29 80 00       	push   $0x8029ec
  8016c8:	68 cc 29 80 00       	push   $0x8029cc
  8016cd:	6a 7c                	push   $0x7c
  8016cf:	68 e1 29 80 00       	push   $0x8029e1
  8016d4:	e8 0a eb ff ff       	call   8001e3 <_panic>
	assert(r <= PGSIZE);
  8016d9:	68 f3 29 80 00       	push   $0x8029f3
  8016de:	68 cc 29 80 00       	push   $0x8029cc
  8016e3:	6a 7d                	push   $0x7d
  8016e5:	68 e1 29 80 00       	push   $0x8029e1
  8016ea:	e8 f4 ea ff ff       	call   8001e3 <_panic>

008016ef <open>:
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	56                   	push   %esi
  8016f3:	53                   	push   %ebx
  8016f4:	83 ec 1c             	sub    $0x1c,%esp
  8016f7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016fa:	56                   	push   %esi
  8016fb:	e8 24 f2 ff ff       	call   800924 <strlen>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801708:	7f 6c                	jg     801776 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80170a:	83 ec 0c             	sub    $0xc,%esp
  80170d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801710:	50                   	push   %eax
  801711:	e8 75 f8 ff ff       	call   800f8b <fd_alloc>
  801716:	89 c3                	mov    %eax,%ebx
  801718:	83 c4 10             	add    $0x10,%esp
  80171b:	85 c0                	test   %eax,%eax
  80171d:	78 3c                	js     80175b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	56                   	push   %esi
  801723:	68 00 50 80 00       	push   $0x805000
  801728:	e8 2e f2 ff ff       	call   80095b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80172d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801730:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801738:	b8 01 00 00 00       	mov    $0x1,%eax
  80173d:	e8 b4 fd ff ff       	call   8014f6 <fsipc>
  801742:	89 c3                	mov    %eax,%ebx
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	85 c0                	test   %eax,%eax
  801749:	78 19                	js     801764 <open+0x75>
	return fd2num(fd);
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	ff 75 f4             	pushl  -0xc(%ebp)
  801751:	e8 0e f8 ff ff       	call   800f64 <fd2num>
  801756:	89 c3                	mov    %eax,%ebx
  801758:	83 c4 10             	add    $0x10,%esp
}
  80175b:	89 d8                	mov    %ebx,%eax
  80175d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    
		fd_close(fd, 0);
  801764:	83 ec 08             	sub    $0x8,%esp
  801767:	6a 00                	push   $0x0
  801769:	ff 75 f4             	pushl  -0xc(%ebp)
  80176c:	e8 15 f9 ff ff       	call   801086 <fd_close>
		return r;
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	eb e5                	jmp    80175b <open+0x6c>
		return -E_BAD_PATH;
  801776:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80177b:	eb de                	jmp    80175b <open+0x6c>

0080177d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801783:	ba 00 00 00 00       	mov    $0x0,%edx
  801788:	b8 08 00 00 00       	mov    $0x8,%eax
  80178d:	e8 64 fd ff ff       	call   8014f6 <fsipc>
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801794:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801798:	7e 38                	jle    8017d2 <writebuf+0x3e>
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	53                   	push   %ebx
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8017a3:	ff 70 04             	pushl  0x4(%eax)
  8017a6:	8d 40 10             	lea    0x10(%eax),%eax
  8017a9:	50                   	push   %eax
  8017aa:	ff 33                	pushl  (%ebx)
  8017ac:	e8 68 fb ff ff       	call   801319 <write>
		if (result > 0)
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	7e 03                	jle    8017bb <writebuf+0x27>
			b->result += result;
  8017b8:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017bb:	39 43 04             	cmp    %eax,0x4(%ebx)
  8017be:	74 0d                	je     8017cd <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	0f 4f c2             	cmovg  %edx,%eax
  8017ca:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    
  8017d2:	f3 c3                	repz ret 

008017d4 <putch>:

static void
putch(int ch, void *thunk)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	53                   	push   %ebx
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017de:	8b 53 04             	mov    0x4(%ebx),%edx
  8017e1:	8d 42 01             	lea    0x1(%edx),%eax
  8017e4:	89 43 04             	mov    %eax,0x4(%ebx)
  8017e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ea:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017ee:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017f3:	74 06                	je     8017fb <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8017f5:	83 c4 04             	add    $0x4,%esp
  8017f8:	5b                   	pop    %ebx
  8017f9:	5d                   	pop    %ebp
  8017fa:	c3                   	ret    
		writebuf(b);
  8017fb:	89 d8                	mov    %ebx,%eax
  8017fd:	e8 92 ff ff ff       	call   801794 <writebuf>
		b->idx = 0;
  801802:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801809:	eb ea                	jmp    8017f5 <putch+0x21>

0080180b <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80181d:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801824:	00 00 00 
	b.result = 0;
  801827:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80182e:	00 00 00 
	b.error = 1;
  801831:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801838:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80183b:	ff 75 10             	pushl  0x10(%ebp)
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801847:	50                   	push   %eax
  801848:	68 d4 17 80 00       	push   $0x8017d4
  80184d:	e8 69 eb ff ff       	call   8003bb <vprintfmt>
	if (b.idx > 0)
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80185c:	7f 11                	jg     80186f <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80185e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801864:	85 c0                	test   %eax,%eax
  801866:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    
		writebuf(&b);
  80186f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801875:	e8 1a ff ff ff       	call   801794 <writebuf>
  80187a:	eb e2                	jmp    80185e <vfprintf+0x53>

0080187c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801882:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801885:	50                   	push   %eax
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	ff 75 08             	pushl  0x8(%ebp)
  80188c:	e8 7a ff ff ff       	call   80180b <vfprintf>
	va_end(ap);

	return cnt;
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <printf>:

int
printf(const char *fmt, ...)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801899:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80189c:	50                   	push   %eax
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	6a 01                	push   $0x1
  8018a2:	e8 64 ff ff ff       	call   80180b <vfprintf>
	va_end(ap);

	return cnt;
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	56                   	push   %esi
  8018ad:	53                   	push   %ebx
  8018ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018b1:	83 ec 0c             	sub    $0xc,%esp
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 b8 f6 ff ff       	call   800f74 <fd2data>
  8018bc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018be:	83 c4 08             	add    $0x8,%esp
  8018c1:	68 ff 29 80 00       	push   $0x8029ff
  8018c6:	53                   	push   %ebx
  8018c7:	e8 8f f0 ff ff       	call   80095b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018cc:	8b 46 04             	mov    0x4(%esi),%eax
  8018cf:	2b 06                	sub    (%esi),%eax
  8018d1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018d7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018de:	00 00 00 
	stat->st_dev = &devpipe;
  8018e1:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  8018e8:	30 80 00 
	return 0;
}
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5e                   	pop    %esi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 0c             	sub    $0xc,%esp
  8018fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801901:	53                   	push   %ebx
  801902:	6a 00                	push   $0x0
  801904:	e8 d0 f4 ff ff       	call   800dd9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801909:	89 1c 24             	mov    %ebx,(%esp)
  80190c:	e8 63 f6 ff ff       	call   800f74 <fd2data>
  801911:	83 c4 08             	add    $0x8,%esp
  801914:	50                   	push   %eax
  801915:	6a 00                	push   $0x0
  801917:	e8 bd f4 ff ff       	call   800dd9 <sys_page_unmap>
}
  80191c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <_pipeisclosed>:
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	57                   	push   %edi
  801925:	56                   	push   %esi
  801926:	53                   	push   %ebx
  801927:	83 ec 1c             	sub    $0x1c,%esp
  80192a:	89 c7                	mov    %eax,%edi
  80192c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80192e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801933:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801936:	83 ec 0c             	sub    $0xc,%esp
  801939:	57                   	push   %edi
  80193a:	e8 94 09 00 00       	call   8022d3 <pageref>
  80193f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801942:	89 34 24             	mov    %esi,(%esp)
  801945:	e8 89 09 00 00       	call   8022d3 <pageref>
		nn = thisenv->env_runs;
  80194a:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801950:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	39 cb                	cmp    %ecx,%ebx
  801958:	74 1b                	je     801975 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80195a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80195d:	75 cf                	jne    80192e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80195f:	8b 42 58             	mov    0x58(%edx),%eax
  801962:	6a 01                	push   $0x1
  801964:	50                   	push   %eax
  801965:	53                   	push   %ebx
  801966:	68 06 2a 80 00       	push   $0x802a06
  80196b:	e8 4e e9 ff ff       	call   8002be <cprintf>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	eb b9                	jmp    80192e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801975:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801978:	0f 94 c0             	sete   %al
  80197b:	0f b6 c0             	movzbl %al,%eax
}
  80197e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5f                   	pop    %edi
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    

00801986 <devpipe_write>:
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	57                   	push   %edi
  80198a:	56                   	push   %esi
  80198b:	53                   	push   %ebx
  80198c:	83 ec 28             	sub    $0x28,%esp
  80198f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801992:	56                   	push   %esi
  801993:	e8 dc f5 ff ff       	call   800f74 <fd2data>
  801998:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	bf 00 00 00 00       	mov    $0x0,%edi
  8019a2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019a5:	74 4f                	je     8019f6 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019a7:	8b 43 04             	mov    0x4(%ebx),%eax
  8019aa:	8b 0b                	mov    (%ebx),%ecx
  8019ac:	8d 51 20             	lea    0x20(%ecx),%edx
  8019af:	39 d0                	cmp    %edx,%eax
  8019b1:	72 14                	jb     8019c7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8019b3:	89 da                	mov    %ebx,%edx
  8019b5:	89 f0                	mov    %esi,%eax
  8019b7:	e8 65 ff ff ff       	call   801921 <_pipeisclosed>
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	75 3a                	jne    8019fa <devpipe_write+0x74>
			sys_yield();
  8019c0:	e8 70 f3 ff ff       	call   800d35 <sys_yield>
  8019c5:	eb e0                	jmp    8019a7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019d1:	89 c2                	mov    %eax,%edx
  8019d3:	c1 fa 1f             	sar    $0x1f,%edx
  8019d6:	89 d1                	mov    %edx,%ecx
  8019d8:	c1 e9 1b             	shr    $0x1b,%ecx
  8019db:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019de:	83 e2 1f             	and    $0x1f,%edx
  8019e1:	29 ca                	sub    %ecx,%edx
  8019e3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019e7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019eb:	83 c0 01             	add    $0x1,%eax
  8019ee:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019f1:	83 c7 01             	add    $0x1,%edi
  8019f4:	eb ac                	jmp    8019a2 <devpipe_write+0x1c>
	return i;
  8019f6:	89 f8                	mov    %edi,%eax
  8019f8:	eb 05                	jmp    8019ff <devpipe_write+0x79>
				return 0;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5e                   	pop    %esi
  801a04:	5f                   	pop    %edi
  801a05:	5d                   	pop    %ebp
  801a06:	c3                   	ret    

00801a07 <devpipe_read>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	57                   	push   %edi
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
  801a0d:	83 ec 18             	sub    $0x18,%esp
  801a10:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a13:	57                   	push   %edi
  801a14:	e8 5b f5 ff ff       	call   800f74 <fd2data>
  801a19:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	be 00 00 00 00       	mov    $0x0,%esi
  801a23:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a26:	74 47                	je     801a6f <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801a28:	8b 03                	mov    (%ebx),%eax
  801a2a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a2d:	75 22                	jne    801a51 <devpipe_read+0x4a>
			if (i > 0)
  801a2f:	85 f6                	test   %esi,%esi
  801a31:	75 14                	jne    801a47 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801a33:	89 da                	mov    %ebx,%edx
  801a35:	89 f8                	mov    %edi,%eax
  801a37:	e8 e5 fe ff ff       	call   801921 <_pipeisclosed>
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	75 33                	jne    801a73 <devpipe_read+0x6c>
			sys_yield();
  801a40:	e8 f0 f2 ff ff       	call   800d35 <sys_yield>
  801a45:	eb e1                	jmp    801a28 <devpipe_read+0x21>
				return i;
  801a47:	89 f0                	mov    %esi,%eax
}
  801a49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a51:	99                   	cltd   
  801a52:	c1 ea 1b             	shr    $0x1b,%edx
  801a55:	01 d0                	add    %edx,%eax
  801a57:	83 e0 1f             	and    $0x1f,%eax
  801a5a:	29 d0                	sub    %edx,%eax
  801a5c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a64:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a67:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a6a:	83 c6 01             	add    $0x1,%esi
  801a6d:	eb b4                	jmp    801a23 <devpipe_read+0x1c>
	return i;
  801a6f:	89 f0                	mov    %esi,%eax
  801a71:	eb d6                	jmp    801a49 <devpipe_read+0x42>
				return 0;
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
  801a78:	eb cf                	jmp    801a49 <devpipe_read+0x42>

00801a7a <pipe>:
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	56                   	push   %esi
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 00 f5 ff ff       	call   800f8b <fd_alloc>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 5b                	js     801aef <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	68 07 04 00 00       	push   $0x407
  801a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9f:	6a 00                	push   $0x0
  801aa1:	e8 ae f2 ff ff       	call   800d54 <sys_page_alloc>
  801aa6:	89 c3                	mov    %eax,%ebx
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 40                	js     801aef <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801aaf:	83 ec 0c             	sub    $0xc,%esp
  801ab2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ab5:	50                   	push   %eax
  801ab6:	e8 d0 f4 ff ff       	call   800f8b <fd_alloc>
  801abb:	89 c3                	mov    %eax,%ebx
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 1b                	js     801adf <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 07 04 00 00       	push   $0x407
  801acc:	ff 75 f0             	pushl  -0x10(%ebp)
  801acf:	6a 00                	push   $0x0
  801ad1:	e8 7e f2 ff ff       	call   800d54 <sys_page_alloc>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	79 19                	jns    801af8 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801adf:	83 ec 08             	sub    $0x8,%esp
  801ae2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae5:	6a 00                	push   $0x0
  801ae7:	e8 ed f2 ff ff       	call   800dd9 <sys_page_unmap>
  801aec:	83 c4 10             	add    $0x10,%esp
}
  801aef:	89 d8                	mov    %ebx,%eax
  801af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
	va = fd2data(fd0);
  801af8:	83 ec 0c             	sub    $0xc,%esp
  801afb:	ff 75 f4             	pushl  -0xc(%ebp)
  801afe:	e8 71 f4 ff ff       	call   800f74 <fd2data>
  801b03:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b05:	83 c4 0c             	add    $0xc,%esp
  801b08:	68 07 04 00 00       	push   $0x407
  801b0d:	50                   	push   %eax
  801b0e:	6a 00                	push   $0x0
  801b10:	e8 3f f2 ff ff       	call   800d54 <sys_page_alloc>
  801b15:	89 c3                	mov    %eax,%ebx
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	0f 88 8c 00 00 00    	js     801bae <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	ff 75 f0             	pushl  -0x10(%ebp)
  801b28:	e8 47 f4 ff ff       	call   800f74 <fd2data>
  801b2d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b34:	50                   	push   %eax
  801b35:	6a 00                	push   $0x0
  801b37:	56                   	push   %esi
  801b38:	6a 00                	push   $0x0
  801b3a:	e8 58 f2 ff ff       	call   800d97 <sys_page_map>
  801b3f:	89 c3                	mov    %eax,%ebx
  801b41:	83 c4 20             	add    $0x20,%esp
  801b44:	85 c0                	test   %eax,%eax
  801b46:	78 58                	js     801ba0 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4b:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801b51:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b60:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801b66:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b72:	83 ec 0c             	sub    $0xc,%esp
  801b75:	ff 75 f4             	pushl  -0xc(%ebp)
  801b78:	e8 e7 f3 ff ff       	call   800f64 <fd2num>
  801b7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b80:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b82:	83 c4 04             	add    $0x4,%esp
  801b85:	ff 75 f0             	pushl  -0x10(%ebp)
  801b88:	e8 d7 f3 ff ff       	call   800f64 <fd2num>
  801b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b90:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b9b:	e9 4f ff ff ff       	jmp    801aef <pipe+0x75>
	sys_page_unmap(0, va);
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	56                   	push   %esi
  801ba4:	6a 00                	push   $0x0
  801ba6:	e8 2e f2 ff ff       	call   800dd9 <sys_page_unmap>
  801bab:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	ff 75 f0             	pushl  -0x10(%ebp)
  801bb4:	6a 00                	push   $0x0
  801bb6:	e8 1e f2 ff ff       	call   800dd9 <sys_page_unmap>
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	e9 1c ff ff ff       	jmp    801adf <pipe+0x65>

00801bc3 <pipeisclosed>:
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bcc:	50                   	push   %eax
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 05 f4 ff ff       	call   800fda <fd_lookup>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 18                	js     801bf4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801bdc:	83 ec 0c             	sub    $0xc,%esp
  801bdf:	ff 75 f4             	pushl  -0xc(%ebp)
  801be2:	e8 8d f3 ff ff       	call   800f74 <fd2data>
	return _pipeisclosed(fd, p);
  801be7:	89 c2                	mov    %eax,%edx
  801be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bec:	e8 30 fd ff ff       	call   801921 <_pipeisclosed>
  801bf1:	83 c4 10             	add    $0x10,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801bfc:	68 1e 2a 80 00       	push   $0x802a1e
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	e8 52 ed ff ff       	call   80095b <strcpy>
	return 0;
}
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <devsock_close>:
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	53                   	push   %ebx
  801c14:	83 ec 10             	sub    $0x10,%esp
  801c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c1a:	53                   	push   %ebx
  801c1b:	e8 b3 06 00 00       	call   8022d3 <pageref>
  801c20:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c23:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801c28:	83 f8 01             	cmp    $0x1,%eax
  801c2b:	74 07                	je     801c34 <devsock_close+0x24>
}
  801c2d:	89 d0                	mov    %edx,%eax
  801c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c34:	83 ec 0c             	sub    $0xc,%esp
  801c37:	ff 73 0c             	pushl  0xc(%ebx)
  801c3a:	e8 b7 02 00 00       	call   801ef6 <nsipc_close>
  801c3f:	89 c2                	mov    %eax,%edx
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	eb e7                	jmp    801c2d <devsock_close+0x1d>

00801c46 <devsock_write>:
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	ff 75 10             	pushl  0x10(%ebp)
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	ff 70 0c             	pushl  0xc(%eax)
  801c5a:	e8 74 03 00 00       	call   801fd3 <nsipc_send>
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <devsock_read>:
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 10             	pushl  0x10(%ebp)
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	ff 70 0c             	pushl  0xc(%eax)
  801c75:	e8 ed 02 00 00       	call   801f67 <nsipc_recv>
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <fd2sockid>:
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c82:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c85:	52                   	push   %edx
  801c86:	50                   	push   %eax
  801c87:	e8 4e f3 ff ff       	call   800fda <fd_lookup>
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	78 10                	js     801ca3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c96:	8b 0d 40 30 80 00    	mov    0x803040,%ecx
  801c9c:	39 08                	cmp    %ecx,(%eax)
  801c9e:	75 05                	jne    801ca5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ca0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    
		return -E_NOT_SUPP;
  801ca5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801caa:	eb f7                	jmp    801ca3 <fd2sockid+0x27>

00801cac <alloc_sockfd>:
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	56                   	push   %esi
  801cb0:	53                   	push   %ebx
  801cb1:	83 ec 1c             	sub    $0x1c,%esp
  801cb4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801cb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb9:	50                   	push   %eax
  801cba:	e8 cc f2 ff ff       	call   800f8b <fd_alloc>
  801cbf:	89 c3                	mov    %eax,%ebx
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	78 43                	js     801d0b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	68 07 04 00 00       	push   $0x407
  801cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd3:	6a 00                	push   $0x0
  801cd5:	e8 7a f0 ff ff       	call   800d54 <sys_page_alloc>
  801cda:	89 c3                	mov    %eax,%ebx
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 28                	js     801d0b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce6:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801cec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cf8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cfb:	83 ec 0c             	sub    $0xc,%esp
  801cfe:	50                   	push   %eax
  801cff:	e8 60 f2 ff ff       	call   800f64 <fd2num>
  801d04:	89 c3                	mov    %eax,%ebx
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	eb 0c                	jmp    801d17 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	56                   	push   %esi
  801d0f:	e8 e2 01 00 00       	call   801ef6 <nsipc_close>
		return r;
  801d14:	83 c4 10             	add    $0x10,%esp
}
  801d17:	89 d8                	mov    %ebx,%eax
  801d19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    

00801d20 <accept>:
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	e8 4e ff ff ff       	call   801c7c <fd2sockid>
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	78 1b                	js     801d4d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d32:	83 ec 04             	sub    $0x4,%esp
  801d35:	ff 75 10             	pushl  0x10(%ebp)
  801d38:	ff 75 0c             	pushl  0xc(%ebp)
  801d3b:	50                   	push   %eax
  801d3c:	e8 0e 01 00 00       	call   801e4f <nsipc_accept>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 05                	js     801d4d <accept+0x2d>
	return alloc_sockfd(r);
  801d48:	e8 5f ff ff ff       	call   801cac <alloc_sockfd>
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <bind>:
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	e8 1f ff ff ff       	call   801c7c <fd2sockid>
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	78 12                	js     801d73 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801d61:	83 ec 04             	sub    $0x4,%esp
  801d64:	ff 75 10             	pushl  0x10(%ebp)
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	50                   	push   %eax
  801d6b:	e8 2f 01 00 00       	call   801e9f <nsipc_bind>
  801d70:	83 c4 10             	add    $0x10,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <shutdown>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	e8 f9 fe ff ff       	call   801c7c <fd2sockid>
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 0f                	js     801d96 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801d87:	83 ec 08             	sub    $0x8,%esp
  801d8a:	ff 75 0c             	pushl  0xc(%ebp)
  801d8d:	50                   	push   %eax
  801d8e:	e8 41 01 00 00       	call   801ed4 <nsipc_shutdown>
  801d93:	83 c4 10             	add    $0x10,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <connect>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	e8 d6 fe ff ff       	call   801c7c <fd2sockid>
  801da6:	85 c0                	test   %eax,%eax
  801da8:	78 12                	js     801dbc <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	ff 75 10             	pushl  0x10(%ebp)
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	50                   	push   %eax
  801db4:	e8 57 01 00 00       	call   801f10 <nsipc_connect>
  801db9:	83 c4 10             	add    $0x10,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <listen>:
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	e8 b0 fe ff ff       	call   801c7c <fd2sockid>
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	78 0f                	js     801ddf <listen+0x21>
	return nsipc_listen(r, backlog);
  801dd0:	83 ec 08             	sub    $0x8,%esp
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	50                   	push   %eax
  801dd7:	e8 69 01 00 00       	call   801f45 <nsipc_listen>
  801ddc:	83 c4 10             	add    $0x10,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801de7:	ff 75 10             	pushl  0x10(%ebp)
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	ff 75 08             	pushl  0x8(%ebp)
  801df0:	e8 3c 02 00 00       	call   802031 <nsipc_socket>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 05                	js     801e01 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801dfc:	e8 ab fe ff ff       	call   801cac <alloc_sockfd>
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	53                   	push   %ebx
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e0c:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801e13:	74 26                	je     801e3b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e15:	6a 07                	push   $0x7
  801e17:	68 00 60 80 00       	push   $0x806000
  801e1c:	53                   	push   %ebx
  801e1d:	ff 35 08 40 80 00    	pushl  0x804008
  801e23:	e8 19 04 00 00       	call   802241 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e28:	83 c4 0c             	add    $0xc,%esp
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	e8 a2 03 00 00       	call   8021d8 <ipc_recv>
}
  801e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	6a 02                	push   $0x2
  801e40:	e8 55 04 00 00       	call   80229a <ipc_find_env>
  801e45:	a3 08 40 80 00       	mov    %eax,0x804008
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	eb c6                	jmp    801e15 <nsipc+0x12>

00801e4f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e5f:	8b 06                	mov    (%esi),%eax
  801e61:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e66:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6b:	e8 93 ff ff ff       	call   801e03 <nsipc>
  801e70:	89 c3                	mov    %eax,%ebx
  801e72:	85 c0                	test   %eax,%eax
  801e74:	78 20                	js     801e96 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e76:	83 ec 04             	sub    $0x4,%esp
  801e79:	ff 35 10 60 80 00    	pushl  0x806010
  801e7f:	68 00 60 80 00       	push   $0x806000
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	e8 5d ec ff ff       	call   800ae9 <memmove>
		*addrlen = ret->ret_addrlen;
  801e8c:	a1 10 60 80 00       	mov    0x806010,%eax
  801e91:	89 06                	mov    %eax,(%esi)
  801e93:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801e96:	89 d8                	mov    %ebx,%eax
  801e98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5d                   	pop    %ebp
  801e9e:	c3                   	ret    

00801e9f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	53                   	push   %ebx
  801ea3:	83 ec 08             	sub    $0x8,%esp
  801ea6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801eb1:	53                   	push   %ebx
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	68 04 60 80 00       	push   $0x806004
  801eba:	e8 2a ec ff ff       	call   800ae9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ebf:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ec5:	b8 02 00 00 00       	mov    $0x2,%eax
  801eca:	e8 34 ff ff ff       	call   801e03 <nsipc>
}
  801ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801eea:	b8 03 00 00 00       	mov    $0x3,%eax
  801eef:	e8 0f ff ff ff       	call   801e03 <nsipc>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <nsipc_close>:

int
nsipc_close(int s)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f04:	b8 04 00 00 00       	mov    $0x4,%eax
  801f09:	e8 f5 fe ff ff       	call   801e03 <nsipc>
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	53                   	push   %ebx
  801f14:	83 ec 08             	sub    $0x8,%esp
  801f17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f22:	53                   	push   %ebx
  801f23:	ff 75 0c             	pushl  0xc(%ebp)
  801f26:	68 04 60 80 00       	push   $0x806004
  801f2b:	e8 b9 eb ff ff       	call   800ae9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f30:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f36:	b8 05 00 00 00       	mov    $0x5,%eax
  801f3b:	e8 c3 fe ff ff       	call   801e03 <nsipc>
}
  801f40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f56:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f5b:	b8 06 00 00 00       	mov    $0x6,%eax
  801f60:	e8 9e fe ff ff       	call   801e03 <nsipc>
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	56                   	push   %esi
  801f6b:	53                   	push   %ebx
  801f6c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f77:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f80:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f85:	b8 07 00 00 00       	mov    $0x7,%eax
  801f8a:	e8 74 fe ff ff       	call   801e03 <nsipc>
  801f8f:	89 c3                	mov    %eax,%ebx
  801f91:	85 c0                	test   %eax,%eax
  801f93:	78 1f                	js     801fb4 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f95:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f9a:	7f 21                	jg     801fbd <nsipc_recv+0x56>
  801f9c:	39 c6                	cmp    %eax,%esi
  801f9e:	7c 1d                	jl     801fbd <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fa0:	83 ec 04             	sub    $0x4,%esp
  801fa3:	50                   	push   %eax
  801fa4:	68 00 60 80 00       	push   $0x806000
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	e8 38 eb ff ff       	call   800ae9 <memmove>
  801fb1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801fb4:	89 d8                	mov    %ebx,%eax
  801fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb9:	5b                   	pop    %ebx
  801fba:	5e                   	pop    %esi
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801fbd:	68 2a 2a 80 00       	push   $0x802a2a
  801fc2:	68 cc 29 80 00       	push   $0x8029cc
  801fc7:	6a 62                	push   $0x62
  801fc9:	68 3f 2a 80 00       	push   $0x802a3f
  801fce:	e8 10 e2 ff ff       	call   8001e3 <_panic>

00801fd3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	53                   	push   %ebx
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fe5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801feb:	7f 2e                	jg     80201b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fed:	83 ec 04             	sub    $0x4,%esp
  801ff0:	53                   	push   %ebx
  801ff1:	ff 75 0c             	pushl  0xc(%ebp)
  801ff4:	68 0c 60 80 00       	push   $0x80600c
  801ff9:	e8 eb ea ff ff       	call   800ae9 <memmove>
	nsipcbuf.send.req_size = size;
  801ffe:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802004:	8b 45 14             	mov    0x14(%ebp),%eax
  802007:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80200c:	b8 08 00 00 00       	mov    $0x8,%eax
  802011:	e8 ed fd ff ff       	call   801e03 <nsipc>
}
  802016:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802019:	c9                   	leave  
  80201a:	c3                   	ret    
	assert(size < 1600);
  80201b:	68 4b 2a 80 00       	push   $0x802a4b
  802020:	68 cc 29 80 00       	push   $0x8029cc
  802025:	6a 6d                	push   $0x6d
  802027:	68 3f 2a 80 00       	push   $0x802a3f
  80202c:	e8 b2 e1 ff ff       	call   8001e3 <_panic>

00802031 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80203f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802042:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802047:	8b 45 10             	mov    0x10(%ebp),%eax
  80204a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80204f:	b8 09 00 00 00       	mov    $0x9,%eax
  802054:	e8 aa fd ff ff       	call   801e03 <nsipc>
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    

00802065 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80206b:	68 57 2a 80 00       	push   $0x802a57
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	e8 e3 e8 ff ff       	call   80095b <strcpy>
	return 0;
}
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <devcons_write>:
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	57                   	push   %edi
  802083:	56                   	push   %esi
  802084:	53                   	push   %ebx
  802085:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80208b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802090:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802096:	eb 2f                	jmp    8020c7 <devcons_write+0x48>
		m = n - tot;
  802098:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80209b:	29 f3                	sub    %esi,%ebx
  80209d:	83 fb 7f             	cmp    $0x7f,%ebx
  8020a0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020a5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	53                   	push   %ebx
  8020ac:	89 f0                	mov    %esi,%eax
  8020ae:	03 45 0c             	add    0xc(%ebp),%eax
  8020b1:	50                   	push   %eax
  8020b2:	57                   	push   %edi
  8020b3:	e8 31 ea ff ff       	call   800ae9 <memmove>
		sys_cputs(buf, m);
  8020b8:	83 c4 08             	add    $0x8,%esp
  8020bb:	53                   	push   %ebx
  8020bc:	57                   	push   %edi
  8020bd:	e8 d6 eb ff ff       	call   800c98 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020c2:	01 de                	add    %ebx,%esi
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020ca:	72 cc                	jb     802098 <devcons_write+0x19>
}
  8020cc:	89 f0                	mov    %esi,%eax
  8020ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    

008020d6 <devcons_read>:
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 08             	sub    $0x8,%esp
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e5:	75 07                	jne    8020ee <devcons_read+0x18>
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    
		sys_yield();
  8020e9:	e8 47 ec ff ff       	call   800d35 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8020ee:	e8 c3 eb ff ff       	call   800cb6 <sys_cgetc>
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	74 f2                	je     8020e9 <devcons_read+0x13>
	if (c < 0)
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	78 ec                	js     8020e7 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8020fb:	83 f8 04             	cmp    $0x4,%eax
  8020fe:	74 0c                	je     80210c <devcons_read+0x36>
	*(char*)vbuf = c;
  802100:	8b 55 0c             	mov    0xc(%ebp),%edx
  802103:	88 02                	mov    %al,(%edx)
	return 1;
  802105:	b8 01 00 00 00       	mov    $0x1,%eax
  80210a:	eb db                	jmp    8020e7 <devcons_read+0x11>
		return 0;
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
  802111:	eb d4                	jmp    8020e7 <devcons_read+0x11>

00802113 <cputchar>:
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80211f:	6a 01                	push   $0x1
  802121:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802124:	50                   	push   %eax
  802125:	e8 6e eb ff ff       	call   800c98 <sys_cputs>
}
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <getchar>:
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802135:	6a 01                	push   $0x1
  802137:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80213a:	50                   	push   %eax
  80213b:	6a 00                	push   $0x0
  80213d:	e8 09 f1 ff ff       	call   80124b <read>
	if (r < 0)
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	85 c0                	test   %eax,%eax
  802147:	78 08                	js     802151 <getchar+0x22>
	if (r < 1)
  802149:	85 c0                	test   %eax,%eax
  80214b:	7e 06                	jle    802153 <getchar+0x24>
	return c;
  80214d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    
		return -E_EOF;
  802153:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802158:	eb f7                	jmp    802151 <getchar+0x22>

0080215a <iscons>:
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802160:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802163:	50                   	push   %eax
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	e8 6e ee ff ff       	call   800fda <fd_lookup>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 11                	js     802184 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80217c:	39 10                	cmp    %edx,(%eax)
  80217e:	0f 94 c0             	sete   %al
  802181:	0f b6 c0             	movzbl %al,%eax
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <opencons>:
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80218c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80218f:	50                   	push   %eax
  802190:	e8 f6 ed ff ff       	call   800f8b <fd_alloc>
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	85 c0                	test   %eax,%eax
  80219a:	78 3a                	js     8021d6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80219c:	83 ec 04             	sub    $0x4,%esp
  80219f:	68 07 04 00 00       	push   $0x407
  8021a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a7:	6a 00                	push   $0x0
  8021a9:	e8 a6 eb ff ff       	call   800d54 <sys_page_alloc>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	78 21                	js     8021d6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8021be:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	50                   	push   %eax
  8021ce:	e8 91 ed ff ff       	call   800f64 <fd2num>
  8021d3:	83 c4 10             	add    $0x10,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	56                   	push   %esi
  8021dc:	53                   	push   %ebx
  8021dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8021e6:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8021e8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ed:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	50                   	push   %eax
  8021f4:	e8 0b ed ff ff       	call   800f04 <sys_ipc_recv>
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	78 2b                	js     80222b <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802200:	85 f6                	test   %esi,%esi
  802202:	74 0a                	je     80220e <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802204:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802209:	8b 40 74             	mov    0x74(%eax),%eax
  80220c:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80220e:	85 db                	test   %ebx,%ebx
  802210:	74 0a                	je     80221c <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802212:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802217:	8b 40 78             	mov    0x78(%eax),%eax
  80221a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80221c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802221:	8b 40 70             	mov    0x70(%eax),%eax
}
  802224:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5d                   	pop    %ebp
  80222a:	c3                   	ret    
	    if (from_env_store != NULL) {
  80222b:	85 f6                	test   %esi,%esi
  80222d:	74 06                	je     802235 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80222f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802235:	85 db                	test   %ebx,%ebx
  802237:	74 eb                	je     802224 <ipc_recv+0x4c>
	        *perm_store = 0;
  802239:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80223f:	eb e3                	jmp    802224 <ipc_recv+0x4c>

00802241 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	57                   	push   %edi
  802245:	56                   	push   %esi
  802246:	53                   	push   %ebx
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80224d:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802250:	85 f6                	test   %esi,%esi
  802252:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802257:	0f 44 f0             	cmove  %eax,%esi
  80225a:	eb 09                	jmp    802265 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80225c:	e8 d4 ea ff ff       	call   800d35 <sys_yield>
	} while(r != 0);
  802261:	85 db                	test   %ebx,%ebx
  802263:	74 2d                	je     802292 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802265:	ff 75 14             	pushl  0x14(%ebp)
  802268:	56                   	push   %esi
  802269:	ff 75 0c             	pushl  0xc(%ebp)
  80226c:	57                   	push   %edi
  80226d:	e8 6f ec ff ff       	call   800ee1 <sys_ipc_try_send>
  802272:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	85 c0                	test   %eax,%eax
  802279:	79 e1                	jns    80225c <ipc_send+0x1b>
  80227b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80227e:	74 dc                	je     80225c <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802280:	50                   	push   %eax
  802281:	68 63 2a 80 00       	push   $0x802a63
  802286:	6a 45                	push   $0x45
  802288:	68 70 2a 80 00       	push   $0x802a70
  80228d:	e8 51 df ff ff       	call   8001e3 <_panic>
}
  802292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802295:	5b                   	pop    %ebx
  802296:	5e                   	pop    %esi
  802297:	5f                   	pop    %edi
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    

0080229a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022a0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022a8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022ae:	8b 52 50             	mov    0x50(%edx),%edx
  8022b1:	39 ca                	cmp    %ecx,%edx
  8022b3:	74 11                	je     8022c6 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8022b5:	83 c0 01             	add    $0x1,%eax
  8022b8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022bd:	75 e6                	jne    8022a5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	eb 0b                	jmp    8022d1 <ipc_find_env+0x37>
			return envs[i].env_id;
  8022c6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022c9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022ce:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    

008022d3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d9:	89 d0                	mov    %edx,%eax
  8022db:	c1 e8 16             	shr    $0x16,%eax
  8022de:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022e5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022ea:	f6 c1 01             	test   $0x1,%cl
  8022ed:	74 1d                	je     80230c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022ef:	c1 ea 0c             	shr    $0xc,%edx
  8022f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022f9:	f6 c2 01             	test   $0x1,%dl
  8022fc:	74 0e                	je     80230c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022fe:	c1 ea 0c             	shr    $0xc,%edx
  802301:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802308:	ef 
  802309:	0f b7 c0             	movzwl %ax,%eax
}
  80230c:	5d                   	pop    %ebp
  80230d:	c3                   	ret    
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__udivdi3>:
  802310:	55                   	push   %ebp
  802311:	57                   	push   %edi
  802312:	56                   	push   %esi
  802313:	53                   	push   %ebx
  802314:	83 ec 1c             	sub    $0x1c,%esp
  802317:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80231f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802323:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802327:	85 d2                	test   %edx,%edx
  802329:	75 35                	jne    802360 <__udivdi3+0x50>
  80232b:	39 f3                	cmp    %esi,%ebx
  80232d:	0f 87 bd 00 00 00    	ja     8023f0 <__udivdi3+0xe0>
  802333:	85 db                	test   %ebx,%ebx
  802335:	89 d9                	mov    %ebx,%ecx
  802337:	75 0b                	jne    802344 <__udivdi3+0x34>
  802339:	b8 01 00 00 00       	mov    $0x1,%eax
  80233e:	31 d2                	xor    %edx,%edx
  802340:	f7 f3                	div    %ebx
  802342:	89 c1                	mov    %eax,%ecx
  802344:	31 d2                	xor    %edx,%edx
  802346:	89 f0                	mov    %esi,%eax
  802348:	f7 f1                	div    %ecx
  80234a:	89 c6                	mov    %eax,%esi
  80234c:	89 e8                	mov    %ebp,%eax
  80234e:	89 f7                	mov    %esi,%edi
  802350:	f7 f1                	div    %ecx
  802352:	89 fa                	mov    %edi,%edx
  802354:	83 c4 1c             	add    $0x1c,%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5f                   	pop    %edi
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    
  80235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802360:	39 f2                	cmp    %esi,%edx
  802362:	77 7c                	ja     8023e0 <__udivdi3+0xd0>
  802364:	0f bd fa             	bsr    %edx,%edi
  802367:	83 f7 1f             	xor    $0x1f,%edi
  80236a:	0f 84 98 00 00 00    	je     802408 <__udivdi3+0xf8>
  802370:	89 f9                	mov    %edi,%ecx
  802372:	b8 20 00 00 00       	mov    $0x20,%eax
  802377:	29 f8                	sub    %edi,%eax
  802379:	d3 e2                	shl    %cl,%edx
  80237b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 da                	mov    %ebx,%edx
  802383:	d3 ea                	shr    %cl,%edx
  802385:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802389:	09 d1                	or     %edx,%ecx
  80238b:	89 f2                	mov    %esi,%edx
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 f9                	mov    %edi,%ecx
  802393:	d3 e3                	shl    %cl,%ebx
  802395:	89 c1                	mov    %eax,%ecx
  802397:	d3 ea                	shr    %cl,%edx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80239f:	d3 e6                	shl    %cl,%esi
  8023a1:	89 eb                	mov    %ebp,%ebx
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	d3 eb                	shr    %cl,%ebx
  8023a7:	09 de                	or     %ebx,%esi
  8023a9:	89 f0                	mov    %esi,%eax
  8023ab:	f7 74 24 08          	divl   0x8(%esp)
  8023af:	89 d6                	mov    %edx,%esi
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	f7 64 24 0c          	mull   0xc(%esp)
  8023b7:	39 d6                	cmp    %edx,%esi
  8023b9:	72 0c                	jb     8023c7 <__udivdi3+0xb7>
  8023bb:	89 f9                	mov    %edi,%ecx
  8023bd:	d3 e5                	shl    %cl,%ebp
  8023bf:	39 c5                	cmp    %eax,%ebp
  8023c1:	73 5d                	jae    802420 <__udivdi3+0x110>
  8023c3:	39 d6                	cmp    %edx,%esi
  8023c5:	75 59                	jne    802420 <__udivdi3+0x110>
  8023c7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023ca:	31 ff                	xor    %edi,%edi
  8023cc:	89 fa                	mov    %edi,%edx
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d 76 00             	lea    0x0(%esi),%esi
  8023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8023e0:	31 ff                	xor    %edi,%edi
  8023e2:	31 c0                	xor    %eax,%eax
  8023e4:	89 fa                	mov    %edi,%edx
  8023e6:	83 c4 1c             	add    $0x1c,%esp
  8023e9:	5b                   	pop    %ebx
  8023ea:	5e                   	pop    %esi
  8023eb:	5f                   	pop    %edi
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    
  8023ee:	66 90                	xchg   %ax,%ax
  8023f0:	31 ff                	xor    %edi,%edi
  8023f2:	89 e8                	mov    %ebp,%eax
  8023f4:	89 f2                	mov    %esi,%edx
  8023f6:	f7 f3                	div    %ebx
  8023f8:	89 fa                	mov    %edi,%edx
  8023fa:	83 c4 1c             	add    $0x1c,%esp
  8023fd:	5b                   	pop    %ebx
  8023fe:	5e                   	pop    %esi
  8023ff:	5f                   	pop    %edi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    
  802402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802408:	39 f2                	cmp    %esi,%edx
  80240a:	72 06                	jb     802412 <__udivdi3+0x102>
  80240c:	31 c0                	xor    %eax,%eax
  80240e:	39 eb                	cmp    %ebp,%ebx
  802410:	77 d2                	ja     8023e4 <__udivdi3+0xd4>
  802412:	b8 01 00 00 00       	mov    $0x1,%eax
  802417:	eb cb                	jmp    8023e4 <__udivdi3+0xd4>
  802419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802420:	89 d8                	mov    %ebx,%eax
  802422:	31 ff                	xor    %edi,%edi
  802424:	eb be                	jmp    8023e4 <__udivdi3+0xd4>
  802426:	66 90                	xchg   %ax,%ax
  802428:	66 90                	xchg   %ax,%ax
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	66 90                	xchg   %ax,%ax
  80242e:	66 90                	xchg   %ax,%ax

00802430 <__umoddi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80243b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80243f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802447:	85 ed                	test   %ebp,%ebp
  802449:	89 f0                	mov    %esi,%eax
  80244b:	89 da                	mov    %ebx,%edx
  80244d:	75 19                	jne    802468 <__umoddi3+0x38>
  80244f:	39 df                	cmp    %ebx,%edi
  802451:	0f 86 b1 00 00 00    	jbe    802508 <__umoddi3+0xd8>
  802457:	f7 f7                	div    %edi
  802459:	89 d0                	mov    %edx,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	83 c4 1c             	add    $0x1c,%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	39 dd                	cmp    %ebx,%ebp
  80246a:	77 f1                	ja     80245d <__umoddi3+0x2d>
  80246c:	0f bd cd             	bsr    %ebp,%ecx
  80246f:	83 f1 1f             	xor    $0x1f,%ecx
  802472:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802476:	0f 84 b4 00 00 00    	je     802530 <__umoddi3+0x100>
  80247c:	b8 20 00 00 00       	mov    $0x20,%eax
  802481:	89 c2                	mov    %eax,%edx
  802483:	8b 44 24 04          	mov    0x4(%esp),%eax
  802487:	29 c2                	sub    %eax,%edx
  802489:	89 c1                	mov    %eax,%ecx
  80248b:	89 f8                	mov    %edi,%eax
  80248d:	d3 e5                	shl    %cl,%ebp
  80248f:	89 d1                	mov    %edx,%ecx
  802491:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802495:	d3 e8                	shr    %cl,%eax
  802497:	09 c5                	or     %eax,%ebp
  802499:	8b 44 24 04          	mov    0x4(%esp),%eax
  80249d:	89 c1                	mov    %eax,%ecx
  80249f:	d3 e7                	shl    %cl,%edi
  8024a1:	89 d1                	mov    %edx,%ecx
  8024a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024a7:	89 df                	mov    %ebx,%edi
  8024a9:	d3 ef                	shr    %cl,%edi
  8024ab:	89 c1                	mov    %eax,%ecx
  8024ad:	89 f0                	mov    %esi,%eax
  8024af:	d3 e3                	shl    %cl,%ebx
  8024b1:	89 d1                	mov    %edx,%ecx
  8024b3:	89 fa                	mov    %edi,%edx
  8024b5:	d3 e8                	shr    %cl,%eax
  8024b7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024bc:	09 d8                	or     %ebx,%eax
  8024be:	f7 f5                	div    %ebp
  8024c0:	d3 e6                	shl    %cl,%esi
  8024c2:	89 d1                	mov    %edx,%ecx
  8024c4:	f7 64 24 08          	mull   0x8(%esp)
  8024c8:	39 d1                	cmp    %edx,%ecx
  8024ca:	89 c3                	mov    %eax,%ebx
  8024cc:	89 d7                	mov    %edx,%edi
  8024ce:	72 06                	jb     8024d6 <__umoddi3+0xa6>
  8024d0:	75 0e                	jne    8024e0 <__umoddi3+0xb0>
  8024d2:	39 c6                	cmp    %eax,%esi
  8024d4:	73 0a                	jae    8024e0 <__umoddi3+0xb0>
  8024d6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8024da:	19 ea                	sbb    %ebp,%edx
  8024dc:	89 d7                	mov    %edx,%edi
  8024de:	89 c3                	mov    %eax,%ebx
  8024e0:	89 ca                	mov    %ecx,%edx
  8024e2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8024e7:	29 de                	sub    %ebx,%esi
  8024e9:	19 fa                	sbb    %edi,%edx
  8024eb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8024ef:	89 d0                	mov    %edx,%eax
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 d9                	mov    %ebx,%ecx
  8024f5:	d3 ee                	shr    %cl,%esi
  8024f7:	d3 ea                	shr    %cl,%edx
  8024f9:	09 f0                	or     %esi,%eax
  8024fb:	83 c4 1c             	add    $0x1c,%esp
  8024fe:	5b                   	pop    %ebx
  8024ff:	5e                   	pop    %esi
  802500:	5f                   	pop    %edi
  802501:	5d                   	pop    %ebp
  802502:	c3                   	ret    
  802503:	90                   	nop
  802504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802508:	85 ff                	test   %edi,%edi
  80250a:	89 f9                	mov    %edi,%ecx
  80250c:	75 0b                	jne    802519 <__umoddi3+0xe9>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	f7 f7                	div    %edi
  802517:	89 c1                	mov    %eax,%ecx
  802519:	89 d8                	mov    %ebx,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	f7 f1                	div    %ecx
  80251f:	89 f0                	mov    %esi,%eax
  802521:	f7 f1                	div    %ecx
  802523:	e9 31 ff ff ff       	jmp    802459 <__umoddi3+0x29>
  802528:	90                   	nop
  802529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802530:	39 dd                	cmp    %ebx,%ebp
  802532:	72 08                	jb     80253c <__umoddi3+0x10c>
  802534:	39 f7                	cmp    %esi,%edi
  802536:	0f 87 21 ff ff ff    	ja     80245d <__umoddi3+0x2d>
  80253c:	89 da                	mov    %ebx,%edx
  80253e:	89 f0                	mov    %esi,%eax
  802540:	29 f8                	sub    %edi,%eax
  802542:	19 ea                	sbb    %ebp,%edx
  802544:	e9 14 ff ff ff       	jmp    80245d <__umoddi3+0x2d>
