
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
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
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 40 80 00 e0 	movl   $0x8029e0,0x804000
  800045:	29 80 00 

	cprintf("icode startup\n");
  800048:	68 e6 29 80 00       	push   $0x8029e6
  80004d:	e8 1d 02 00 00       	call   80026f <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 f5 29 80 00 	movl   $0x8029f5,(%esp)
  800059:	e8 11 02 00 00       	call   80026f <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 08 2a 80 00       	push   $0x802a08
  800068:	e8 33 16 00 00       	call   8016a0 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 18                	js     80008e <umain+0x5b>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 31 2a 80 00       	push   $0x802a31
  80007e:	e8 ec 01 00 00       	call   80026f <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	eb 1f                	jmp    8000ad <umain+0x7a>
		panic("icode: open /motd: %e", fd);
  80008e:	50                   	push   %eax
  80008f:	68 0e 2a 80 00       	push   $0x802a0e
  800094:	6a 0f                	push   $0xf
  800096:	68 24 2a 80 00       	push   $0x802a24
  80009b:	e8 f4 00 00 00       	call   800194 <_panic>
		sys_cputs(buf, n);
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	50                   	push   %eax
  8000a4:	53                   	push   %ebx
  8000a5:	e8 9f 0b 00 00       	call   800c49 <sys_cputs>
  8000aa:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	68 00 02 00 00       	push   $0x200
  8000b5:	53                   	push   %ebx
  8000b6:	56                   	push   %esi
  8000b7:	e8 40 11 00 00       	call   8011fc <read>
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	7f dd                	jg     8000a0 <umain+0x6d>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 44 2a 80 00       	push   $0x802a44
  8000cb:	e8 9f 01 00 00       	call   80026f <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 e8 0f 00 00       	call   8010c0 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 58 2a 80 00 	movl   $0x802a58,(%esp)
  8000df:	e8 8b 01 00 00       	call   80026f <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 6c 2a 80 00       	push   $0x802a6c
  8000f0:	68 75 2a 80 00       	push   $0x802a75
  8000f5:	68 7f 2a 80 00       	push   $0x802a7f
  8000fa:	68 7e 2a 80 00       	push   $0x802a7e
  8000ff:	e8 b9 1b 00 00       	call   801cbd <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 9b 2a 80 00       	push   $0x802a9b
  800113:	e8 57 01 00 00       	call   80026f <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 84 2a 80 00       	push   $0x802a84
  800128:	6a 1a                	push   $0x1a
  80012a:	68 24 2a 80 00       	push   $0x802a24
  80012f:	e8 60 00 00 00       	call   800194 <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80013f:	e8 83 0b 00 00       	call   800cc7 <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800151:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	85 db                	test   %ebx,%ebx
  800158:	7e 07                	jle    800161 <libmain+0x2d>
		binaryname = argv[0];
  80015a:	8b 06                	mov    (%esi),%eax
  80015c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	e8 c8 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016b:	e8 0a 00 00 00       	call   80017a <exit>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800180:	e8 66 0f 00 00       	call   8010eb <close_all>
	sys_env_destroy(0);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	6a 00                	push   $0x0
  80018a:	e8 f7 0a 00 00       	call   800c86 <sys_env_destroy>
}
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800199:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80019c:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001a2:	e8 20 0b 00 00       	call   800cc7 <sys_getenvid>
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	56                   	push   %esi
  8001b1:	50                   	push   %eax
  8001b2:	68 b8 2a 80 00       	push   $0x802ab8
  8001b7:	e8 b3 00 00 00       	call   80026f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001bc:	83 c4 18             	add    $0x18,%esp
  8001bf:	53                   	push   %ebx
  8001c0:	ff 75 10             	pushl  0x10(%ebp)
  8001c3:	e8 56 00 00 00       	call   80021e <vcprintf>
	cprintf("\n");
  8001c8:	c7 04 24 c8 2f 80 00 	movl   $0x802fc8,(%esp)
  8001cf:	e8 9b 00 00 00       	call   80026f <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d7:	cc                   	int3   
  8001d8:	eb fd                	jmp    8001d7 <_panic+0x43>

008001da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	53                   	push   %ebx
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e4:	8b 13                	mov    (%ebx),%edx
  8001e6:	8d 42 01             	lea    0x1(%edx),%eax
  8001e9:	89 03                	mov    %eax,(%ebx)
  8001eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f7:	74 09                	je     800202 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800200:	c9                   	leave  
  800201:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	68 ff 00 00 00       	push   $0xff
  80020a:	8d 43 08             	lea    0x8(%ebx),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 36 0a 00 00       	call   800c49 <sys_cputs>
		b->idx = 0;
  800213:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb db                	jmp    8001f9 <putch+0x1f>

0080021e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800227:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022e:	00 00 00 
	b.cnt = 0;
  800231:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800238:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800247:	50                   	push   %eax
  800248:	68 da 01 80 00       	push   $0x8001da
  80024d:	e8 1a 01 00 00       	call   80036c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800252:	83 c4 08             	add    $0x8,%esp
  800255:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800261:	50                   	push   %eax
  800262:	e8 e2 09 00 00       	call   800c49 <sys_cputs>

	return b.cnt;
}
  800267:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800275:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 9d ff ff ff       	call   80021e <vcprintf>
	va_end(ap);

	return cnt;
}
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	57                   	push   %edi
  800287:	56                   	push   %esi
  800288:	53                   	push   %ebx
  800289:	83 ec 1c             	sub    $0x1c,%esp
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	89 d6                	mov    %edx,%esi
  800290:	8b 45 08             	mov    0x8(%ebp),%eax
  800293:	8b 55 0c             	mov    0xc(%ebp),%edx
  800296:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800299:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002aa:	39 d3                	cmp    %edx,%ebx
  8002ac:	72 05                	jb     8002b3 <printnum+0x30>
  8002ae:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b1:	77 7a                	ja     80032d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	ff 75 18             	pushl  0x18(%ebp)
  8002b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002bf:	53                   	push   %ebx
  8002c0:	ff 75 10             	pushl  0x10(%ebp)
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d2:	e8 c9 24 00 00       	call   8027a0 <__udivdi3>
  8002d7:	83 c4 18             	add    $0x18,%esp
  8002da:	52                   	push   %edx
  8002db:	50                   	push   %eax
  8002dc:	89 f2                	mov    %esi,%edx
  8002de:	89 f8                	mov    %edi,%eax
  8002e0:	e8 9e ff ff ff       	call   800283 <printnum>
  8002e5:	83 c4 20             	add    $0x20,%esp
  8002e8:	eb 13                	jmp    8002fd <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	56                   	push   %esi
  8002ee:	ff 75 18             	pushl  0x18(%ebp)
  8002f1:	ff d7                	call   *%edi
  8002f3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002f6:	83 eb 01             	sub    $0x1,%ebx
  8002f9:	85 db                	test   %ebx,%ebx
  8002fb:	7f ed                	jg     8002ea <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	56                   	push   %esi
  800301:	83 ec 04             	sub    $0x4,%esp
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	ff 75 e0             	pushl  -0x20(%ebp)
  80030a:	ff 75 dc             	pushl  -0x24(%ebp)
  80030d:	ff 75 d8             	pushl  -0x28(%ebp)
  800310:	e8 ab 25 00 00       	call   8028c0 <__umoddi3>
  800315:	83 c4 14             	add    $0x14,%esp
  800318:	0f be 80 db 2a 80 00 	movsbl 0x802adb(%eax),%eax
  80031f:	50                   	push   %eax
  800320:	ff d7                	call   *%edi
}
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800328:	5b                   	pop    %ebx
  800329:	5e                   	pop    %esi
  80032a:	5f                   	pop    %edi
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    
  80032d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800330:	eb c4                	jmp    8002f6 <printnum+0x73>

00800332 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800338:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	3b 50 04             	cmp    0x4(%eax),%edx
  800341:	73 0a                	jae    80034d <sprintputch+0x1b>
		*b->buf++ = ch;
  800343:	8d 4a 01             	lea    0x1(%edx),%ecx
  800346:	89 08                	mov    %ecx,(%eax)
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	88 02                	mov    %al,(%edx)
}
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <printfmt>:
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800355:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800358:	50                   	push   %eax
  800359:	ff 75 10             	pushl  0x10(%ebp)
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	e8 05 00 00 00       	call   80036c <vprintfmt>
}
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <vprintfmt>:
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	57                   	push   %edi
  800370:	56                   	push   %esi
  800371:	53                   	push   %ebx
  800372:	83 ec 2c             	sub    $0x2c,%esp
  800375:	8b 75 08             	mov    0x8(%ebp),%esi
  800378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037e:	e9 21 04 00 00       	jmp    8007a4 <vprintfmt+0x438>
		padc = ' ';
  800383:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800387:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80038e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800395:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80039c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8d 47 01             	lea    0x1(%edi),%eax
  8003a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a7:	0f b6 17             	movzbl (%edi),%edx
  8003aa:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ad:	3c 55                	cmp    $0x55,%al
  8003af:	0f 87 90 04 00 00    	ja     800845 <vprintfmt+0x4d9>
  8003b5:	0f b6 c0             	movzbl %al,%eax
  8003b8:	ff 24 85 20 2c 80 00 	jmp    *0x802c20(,%eax,4)
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003c2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003c6:	eb d9                	jmp    8003a1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003cb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003cf:	eb d0                	jmp    8003a1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	0f b6 d2             	movzbl %dl,%edx
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003df:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003e2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ec:	83 f9 09             	cmp    $0x9,%ecx
  8003ef:	77 55                	ja     800446 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003f1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f4:	eb e9                	jmp    8003df <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8d 40 04             	lea    0x4(%eax),%eax
  800404:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80040a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040e:	79 91                	jns    8003a1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800410:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800413:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800416:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80041d:	eb 82                	jmp    8003a1 <vprintfmt+0x35>
  80041f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800422:	85 c0                	test   %eax,%eax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	0f 49 d0             	cmovns %eax,%edx
  80042c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800432:	e9 6a ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
  800437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800441:	e9 5b ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
  800446:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800449:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80044c:	eb bc                	jmp    80040a <vprintfmt+0x9e>
			lflag++;
  80044e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800454:	e9 48 ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800459:	8b 45 14             	mov    0x14(%ebp),%eax
  80045c:	8d 78 04             	lea    0x4(%eax),%edi
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	ff 30                	pushl  (%eax)
  800465:	ff d6                	call   *%esi
			break;
  800467:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80046a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80046d:	e9 2f 03 00 00       	jmp    8007a1 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800472:	8b 45 14             	mov    0x14(%ebp),%eax
  800475:	8d 78 04             	lea    0x4(%eax),%edi
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	99                   	cltd   
  80047b:	31 d0                	xor    %edx,%eax
  80047d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047f:	83 f8 0f             	cmp    $0xf,%eax
  800482:	7f 23                	jg     8004a7 <vprintfmt+0x13b>
  800484:	8b 14 85 80 2d 80 00 	mov    0x802d80(,%eax,4),%edx
  80048b:	85 d2                	test   %edx,%edx
  80048d:	74 18                	je     8004a7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80048f:	52                   	push   %edx
  800490:	68 db 2e 80 00       	push   $0x802edb
  800495:	53                   	push   %ebx
  800496:	56                   	push   %esi
  800497:	e8 b3 fe ff ff       	call   80034f <printfmt>
  80049c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049f:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004a2:	e9 fa 02 00 00       	jmp    8007a1 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8004a7:	50                   	push   %eax
  8004a8:	68 f3 2a 80 00       	push   $0x802af3
  8004ad:	53                   	push   %ebx
  8004ae:	56                   	push   %esi
  8004af:	e8 9b fe ff ff       	call   80034f <printfmt>
  8004b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ba:	e9 e2 02 00 00       	jmp    8007a1 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	83 c0 04             	add    $0x4,%eax
  8004c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004cd:	85 ff                	test   %edi,%edi
  8004cf:	b8 ec 2a 80 00       	mov    $0x802aec,%eax
  8004d4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004db:	0f 8e bd 00 00 00    	jle    80059e <vprintfmt+0x232>
  8004e1:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004e5:	75 0e                	jne    8004f5 <vprintfmt+0x189>
  8004e7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f3:	eb 6d                	jmp    800562 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	ff 75 d0             	pushl  -0x30(%ebp)
  8004fb:	57                   	push   %edi
  8004fc:	e8 ec 03 00 00       	call   8008ed <strnlen>
  800501:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800504:	29 c1                	sub    %eax,%ecx
  800506:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800509:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80050c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800510:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800513:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800516:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	eb 0f                	jmp    800529 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	53                   	push   %ebx
  80051e:	ff 75 e0             	pushl  -0x20(%ebp)
  800521:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800523:	83 ef 01             	sub    $0x1,%edi
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	85 ff                	test   %edi,%edi
  80052b:	7f ed                	jg     80051a <vprintfmt+0x1ae>
  80052d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800530:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800533:	85 c9                	test   %ecx,%ecx
  800535:	b8 00 00 00 00       	mov    $0x0,%eax
  80053a:	0f 49 c1             	cmovns %ecx,%eax
  80053d:	29 c1                	sub    %eax,%ecx
  80053f:	89 75 08             	mov    %esi,0x8(%ebp)
  800542:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800545:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800548:	89 cb                	mov    %ecx,%ebx
  80054a:	eb 16                	jmp    800562 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80054c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800550:	75 31                	jne    800583 <vprintfmt+0x217>
					putch(ch, putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	50                   	push   %eax
  800559:	ff 55 08             	call   *0x8(%ebp)
  80055c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055f:	83 eb 01             	sub    $0x1,%ebx
  800562:	83 c7 01             	add    $0x1,%edi
  800565:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800569:	0f be c2             	movsbl %dl,%eax
  80056c:	85 c0                	test   %eax,%eax
  80056e:	74 59                	je     8005c9 <vprintfmt+0x25d>
  800570:	85 f6                	test   %esi,%esi
  800572:	78 d8                	js     80054c <vprintfmt+0x1e0>
  800574:	83 ee 01             	sub    $0x1,%esi
  800577:	79 d3                	jns    80054c <vprintfmt+0x1e0>
  800579:	89 df                	mov    %ebx,%edi
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800581:	eb 37                	jmp    8005ba <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800583:	0f be d2             	movsbl %dl,%edx
  800586:	83 ea 20             	sub    $0x20,%edx
  800589:	83 fa 5e             	cmp    $0x5e,%edx
  80058c:	76 c4                	jbe    800552 <vprintfmt+0x1e6>
					putch('?', putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 0c             	pushl  0xc(%ebp)
  800594:	6a 3f                	push   $0x3f
  800596:	ff 55 08             	call   *0x8(%ebp)
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb c1                	jmp    80055f <vprintfmt+0x1f3>
  80059e:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005aa:	eb b6                	jmp    800562 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 20                	push   $0x20
  8005b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ee                	jg     8005ac <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 d8 01 00 00       	jmp    8007a1 <vprintfmt+0x435>
  8005c9:	89 df                	mov    %ebx,%edi
  8005cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d1:	eb e7                	jmp    8005ba <vprintfmt+0x24e>
	if (lflag >= 2)
  8005d3:	83 f9 01             	cmp    $0x1,%ecx
  8005d6:	7e 45                	jle    80061d <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 50 04             	mov    0x4(%eax),%edx
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f3:	79 62                	jns    800657 <vprintfmt+0x2eb>
				putch('-', putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	53                   	push   %ebx
  8005f9:	6a 2d                	push   $0x2d
  8005fb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800600:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800603:	f7 d8                	neg    %eax
  800605:	83 d2 00             	adc    $0x0,%edx
  800608:	f7 da                	neg    %edx
  80060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800610:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800613:	ba 0a 00 00 00       	mov    $0xa,%edx
  800618:	e9 66 01 00 00       	jmp    800783 <vprintfmt+0x417>
	else if (lflag)
  80061d:	85 c9                	test   %ecx,%ecx
  80061f:	75 1b                	jne    80063c <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800629:	89 c1                	mov    %eax,%ecx
  80062b:	c1 f9 1f             	sar    $0x1f,%ecx
  80062e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 40 04             	lea    0x4(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
  80063a:	eb b3                	jmp    8005ef <vprintfmt+0x283>
		return va_arg(*ap, long);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	89 c1                	mov    %eax,%ecx
  800646:	c1 f9 1f             	sar    $0x1f,%ecx
  800649:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
  800655:	eb 98                	jmp    8005ef <vprintfmt+0x283>
			base = 10;
  800657:	ba 0a 00 00 00       	mov    $0xa,%edx
  80065c:	e9 22 01 00 00       	jmp    800783 <vprintfmt+0x417>
	if (lflag >= 2)
  800661:	83 f9 01             	cmp    $0x1,%ecx
  800664:	7e 21                	jle    800687 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 50 04             	mov    0x4(%eax),%edx
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800671:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 40 08             	lea    0x8(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800682:	e9 fc 00 00 00       	jmp    800783 <vprintfmt+0x417>
	else if (lflag)
  800687:	85 c9                	test   %ecx,%ecx
  800689:	75 23                	jne    8006ae <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006a9:	e9 d5 00 00 00       	jmp    800783 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 40 04             	lea    0x4(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006cc:	e9 b2 00 00 00       	jmp    800783 <vprintfmt+0x417>
	if (lflag >= 2)
  8006d1:	83 f9 01             	cmp    $0x1,%ecx
  8006d4:	7e 42                	jle    800718 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 50 04             	mov    0x4(%eax),%edx
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ed:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8006f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f6:	0f 89 87 00 00 00    	jns    800783 <vprintfmt+0x417>
				putch('-', putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	53                   	push   %ebx
  800700:	6a 2d                	push   $0x2d
  800702:	ff d6                	call   *%esi
				num = -(long long) num;
  800704:	f7 5d d8             	negl   -0x28(%ebp)
  800707:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80070b:	f7 5d dc             	negl   -0x24(%ebp)
  80070e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800711:	ba 08 00 00 00       	mov    $0x8,%edx
  800716:	eb 6b                	jmp    800783 <vprintfmt+0x417>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	75 1b                	jne    800737 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	eb b6                	jmp    8006ed <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	ba 00 00 00 00       	mov    $0x0,%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 04             	lea    0x4(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
  800750:	eb 9b                	jmp    8006ed <vprintfmt+0x381>
			putch('0', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 30                	push   $0x30
  800758:	ff d6                	call   *%esi
			putch('x', putdat);
  80075a:	83 c4 08             	add    $0x8,%esp
  80075d:	53                   	push   %ebx
  80075e:	6a 78                	push   $0x78
  800760:	ff d6                	call   *%esi
			num = (unsigned long long)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	ba 00 00 00 00       	mov    $0x0,%edx
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800772:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8d 40 04             	lea    0x4(%eax),%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077e:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800783:	83 ec 0c             	sub    $0xc,%esp
  800786:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	ff 75 e0             	pushl  -0x20(%ebp)
  80078e:	52                   	push   %edx
  80078f:	ff 75 dc             	pushl  -0x24(%ebp)
  800792:	ff 75 d8             	pushl  -0x28(%ebp)
  800795:	89 da                	mov    %ebx,%edx
  800797:	89 f0                	mov    %esi,%eax
  800799:	e8 e5 fa ff ff       	call   800283 <printnum>
			break;
  80079e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a4:	83 c7 01             	add    $0x1,%edi
  8007a7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ab:	83 f8 25             	cmp    $0x25,%eax
  8007ae:	0f 84 cf fb ff ff    	je     800383 <vprintfmt+0x17>
			if (ch == '\0')
  8007b4:	85 c0                	test   %eax,%eax
  8007b6:	0f 84 a9 00 00 00    	je     800865 <vprintfmt+0x4f9>
			putch(ch, putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	50                   	push   %eax
  8007c1:	ff d6                	call   *%esi
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	eb dc                	jmp    8007a4 <vprintfmt+0x438>
	if (lflag >= 2)
  8007c8:	83 f9 01             	cmp    $0x1,%ecx
  8007cb:	7e 1e                	jle    8007eb <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 50 04             	mov    0x4(%eax),%edx
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8d 40 08             	lea    0x8(%eax),%eax
  8007e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e4:	ba 10 00 00 00       	mov    $0x10,%edx
  8007e9:	eb 98                	jmp    800783 <vprintfmt+0x417>
	else if (lflag)
  8007eb:	85 c9                	test   %ecx,%ecx
  8007ed:	75 23                	jne    800812 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8d 40 04             	lea    0x4(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800808:	ba 10 00 00 00       	mov    $0x10,%edx
  80080d:	e9 71 ff ff ff       	jmp    800783 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
  80081c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8d 40 04             	lea    0x4(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082b:	ba 10 00 00 00       	mov    $0x10,%edx
  800830:	e9 4e ff ff ff       	jmp    800783 <vprintfmt+0x417>
			putch(ch, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	6a 25                	push   $0x25
  80083b:	ff d6                	call   *%esi
			break;
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	e9 5c ff ff ff       	jmp    8007a1 <vprintfmt+0x435>
			putch('%', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	6a 25                	push   $0x25
  80084b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	89 f8                	mov    %edi,%eax
  800852:	eb 03                	jmp    800857 <vprintfmt+0x4eb>
  800854:	83 e8 01             	sub    $0x1,%eax
  800857:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085b:	75 f7                	jne    800854 <vprintfmt+0x4e8>
  80085d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800860:	e9 3c ff ff ff       	jmp    8007a1 <vprintfmt+0x435>
}
  800865:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800868:	5b                   	pop    %ebx
  800869:	5e                   	pop    %esi
  80086a:	5f                   	pop    %edi
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	83 ec 18             	sub    $0x18,%esp
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800880:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 26                	je     8008b4 <vsnprintf+0x47>
  80088e:	85 d2                	test   %edx,%edx
  800890:	7e 22                	jle    8008b4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800892:	ff 75 14             	pushl  0x14(%ebp)
  800895:	ff 75 10             	pushl  0x10(%ebp)
  800898:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089b:	50                   	push   %eax
  80089c:	68 32 03 80 00       	push   $0x800332
  8008a1:	e8 c6 fa ff ff       	call   80036c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008af:	83 c4 10             	add    $0x10,%esp
}
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    
		return -E_INVAL;
  8008b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b9:	eb f7                	jmp    8008b2 <vsnprintf+0x45>

008008bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c4:	50                   	push   %eax
  8008c5:	ff 75 10             	pushl  0x10(%ebp)
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 9a ff ff ff       	call   80086d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	eb 03                	jmp    8008e5 <strlen+0x10>
		n++;
  8008e2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008e5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e9:	75 f7                	jne    8008e2 <strlen+0xd>
	return n;
}
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	eb 03                	jmp    800900 <strnlen+0x13>
		n++;
  8008fd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800900:	39 d0                	cmp    %edx,%eax
  800902:	74 06                	je     80090a <strnlen+0x1d>
  800904:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800908:	75 f3                	jne    8008fd <strnlen+0x10>
	return n;
}
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	53                   	push   %ebx
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800916:	89 c2                	mov    %eax,%edx
  800918:	83 c1 01             	add    $0x1,%ecx
  80091b:	83 c2 01             	add    $0x1,%edx
  80091e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800922:	88 5a ff             	mov    %bl,-0x1(%edx)
  800925:	84 db                	test   %bl,%bl
  800927:	75 ef                	jne    800918 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800929:	5b                   	pop    %ebx
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	53                   	push   %ebx
  800930:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800933:	53                   	push   %ebx
  800934:	e8 9c ff ff ff       	call   8008d5 <strlen>
  800939:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	01 d8                	add    %ebx,%eax
  800941:	50                   	push   %eax
  800942:	e8 c5 ff ff ff       	call   80090c <strcpy>
	return dst;
}
  800947:	89 d8                	mov    %ebx,%eax
  800949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	56                   	push   %esi
  800952:	53                   	push   %ebx
  800953:	8b 75 08             	mov    0x8(%ebp),%esi
  800956:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800959:	89 f3                	mov    %esi,%ebx
  80095b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80095e:	89 f2                	mov    %esi,%edx
  800960:	eb 0f                	jmp    800971 <strncpy+0x23>
		*dst++ = *src;
  800962:	83 c2 01             	add    $0x1,%edx
  800965:	0f b6 01             	movzbl (%ecx),%eax
  800968:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80096b:	80 39 01             	cmpb   $0x1,(%ecx)
  80096e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800971:	39 da                	cmp    %ebx,%edx
  800973:	75 ed                	jne    800962 <strncpy+0x14>
	}
	return ret;
}
  800975:	89 f0                	mov    %esi,%eax
  800977:	5b                   	pop    %ebx
  800978:	5e                   	pop    %esi
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	56                   	push   %esi
  80097f:	53                   	push   %ebx
  800980:	8b 75 08             	mov    0x8(%ebp),%esi
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800989:	89 f0                	mov    %esi,%eax
  80098b:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098f:	85 c9                	test   %ecx,%ecx
  800991:	75 0b                	jne    80099e <strlcpy+0x23>
  800993:	eb 17                	jmp    8009ac <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800995:	83 c2 01             	add    $0x1,%edx
  800998:	83 c0 01             	add    $0x1,%eax
  80099b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80099e:	39 d8                	cmp    %ebx,%eax
  8009a0:	74 07                	je     8009a9 <strlcpy+0x2e>
  8009a2:	0f b6 0a             	movzbl (%edx),%ecx
  8009a5:	84 c9                	test   %cl,%cl
  8009a7:	75 ec                	jne    800995 <strlcpy+0x1a>
		*dst = '\0';
  8009a9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ac:	29 f0                	sub    %esi,%eax
}
  8009ae:	5b                   	pop    %ebx
  8009af:	5e                   	pop    %esi
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009bb:	eb 06                	jmp    8009c3 <strcmp+0x11>
		p++, q++;
  8009bd:	83 c1 01             	add    $0x1,%ecx
  8009c0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009c3:	0f b6 01             	movzbl (%ecx),%eax
  8009c6:	84 c0                	test   %al,%al
  8009c8:	74 04                	je     8009ce <strcmp+0x1c>
  8009ca:	3a 02                	cmp    (%edx),%al
  8009cc:	74 ef                	je     8009bd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ce:	0f b6 c0             	movzbl %al,%eax
  8009d1:	0f b6 12             	movzbl (%edx),%edx
  8009d4:	29 d0                	sub    %edx,%eax
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	53                   	push   %ebx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e2:	89 c3                	mov    %eax,%ebx
  8009e4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e7:	eb 06                	jmp    8009ef <strncmp+0x17>
		n--, p++, q++;
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ef:	39 d8                	cmp    %ebx,%eax
  8009f1:	74 16                	je     800a09 <strncmp+0x31>
  8009f3:	0f b6 08             	movzbl (%eax),%ecx
  8009f6:	84 c9                	test   %cl,%cl
  8009f8:	74 04                	je     8009fe <strncmp+0x26>
  8009fa:	3a 0a                	cmp    (%edx),%cl
  8009fc:	74 eb                	je     8009e9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fe:	0f b6 00             	movzbl (%eax),%eax
  800a01:	0f b6 12             	movzbl (%edx),%edx
  800a04:	29 d0                	sub    %edx,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    
		return 0;
  800a09:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0e:	eb f6                	jmp    800a06 <strncmp+0x2e>

00800a10 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1a:	0f b6 10             	movzbl (%eax),%edx
  800a1d:	84 d2                	test   %dl,%dl
  800a1f:	74 09                	je     800a2a <strchr+0x1a>
		if (*s == c)
  800a21:	38 ca                	cmp    %cl,%dl
  800a23:	74 0a                	je     800a2f <strchr+0x1f>
	for (; *s; s++)
  800a25:	83 c0 01             	add    $0x1,%eax
  800a28:	eb f0                	jmp    800a1a <strchr+0xa>
			return (char *) s;
	return 0;
  800a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3b:	eb 03                	jmp    800a40 <strfind+0xf>
  800a3d:	83 c0 01             	add    $0x1,%eax
  800a40:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a43:	38 ca                	cmp    %cl,%dl
  800a45:	74 04                	je     800a4b <strfind+0x1a>
  800a47:	84 d2                	test   %dl,%dl
  800a49:	75 f2                	jne    800a3d <strfind+0xc>
			break;
	return (char *) s;
}
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	57                   	push   %edi
  800a51:	56                   	push   %esi
  800a52:	53                   	push   %ebx
  800a53:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a59:	85 c9                	test   %ecx,%ecx
  800a5b:	74 13                	je     800a70 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a5d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a63:	75 05                	jne    800a6a <memset+0x1d>
  800a65:	f6 c1 03             	test   $0x3,%cl
  800a68:	74 0d                	je     800a77 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	fc                   	cld    
  800a6e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a70:	89 f8                	mov    %edi,%eax
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5f                   	pop    %edi
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    
		c &= 0xFF;
  800a77:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a7b:	89 d3                	mov    %edx,%ebx
  800a7d:	c1 e3 08             	shl    $0x8,%ebx
  800a80:	89 d0                	mov    %edx,%eax
  800a82:	c1 e0 18             	shl    $0x18,%eax
  800a85:	89 d6                	mov    %edx,%esi
  800a87:	c1 e6 10             	shl    $0x10,%esi
  800a8a:	09 f0                	or     %esi,%eax
  800a8c:	09 c2                	or     %eax,%edx
  800a8e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a90:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a93:	89 d0                	mov    %edx,%eax
  800a95:	fc                   	cld    
  800a96:	f3 ab                	rep stos %eax,%es:(%edi)
  800a98:	eb d6                	jmp    800a70 <memset+0x23>

00800a9a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	57                   	push   %edi
  800a9e:	56                   	push   %esi
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa8:	39 c6                	cmp    %eax,%esi
  800aaa:	73 35                	jae    800ae1 <memmove+0x47>
  800aac:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aaf:	39 c2                	cmp    %eax,%edx
  800ab1:	76 2e                	jbe    800ae1 <memmove+0x47>
		s += n;
		d += n;
  800ab3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab6:	89 d6                	mov    %edx,%esi
  800ab8:	09 fe                	or     %edi,%esi
  800aba:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac0:	74 0c                	je     800ace <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac2:	83 ef 01             	sub    $0x1,%edi
  800ac5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac8:	fd                   	std    
  800ac9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800acb:	fc                   	cld    
  800acc:	eb 21                	jmp    800aef <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ace:	f6 c1 03             	test   $0x3,%cl
  800ad1:	75 ef                	jne    800ac2 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad3:	83 ef 04             	sub    $0x4,%edi
  800ad6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800adc:	fd                   	std    
  800add:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800adf:	eb ea                	jmp    800acb <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae1:	89 f2                	mov    %esi,%edx
  800ae3:	09 c2                	or     %eax,%edx
  800ae5:	f6 c2 03             	test   $0x3,%dl
  800ae8:	74 09                	je     800af3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aea:	89 c7                	mov    %eax,%edi
  800aec:	fc                   	cld    
  800aed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aef:	5e                   	pop    %esi
  800af0:	5f                   	pop    %edi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af3:	f6 c1 03             	test   $0x3,%cl
  800af6:	75 f2                	jne    800aea <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800af8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800afb:	89 c7                	mov    %eax,%edi
  800afd:	fc                   	cld    
  800afe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b00:	eb ed                	jmp    800aef <memmove+0x55>

00800b02 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b05:	ff 75 10             	pushl  0x10(%ebp)
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	ff 75 08             	pushl  0x8(%ebp)
  800b0e:	e8 87 ff ff ff       	call   800a9a <memmove>
}
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b20:	89 c6                	mov    %eax,%esi
  800b22:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b25:	39 f0                	cmp    %esi,%eax
  800b27:	74 1c                	je     800b45 <memcmp+0x30>
		if (*s1 != *s2)
  800b29:	0f b6 08             	movzbl (%eax),%ecx
  800b2c:	0f b6 1a             	movzbl (%edx),%ebx
  800b2f:	38 d9                	cmp    %bl,%cl
  800b31:	75 08                	jne    800b3b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	83 c2 01             	add    $0x1,%edx
  800b39:	eb ea                	jmp    800b25 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b3b:	0f b6 c1             	movzbl %cl,%eax
  800b3e:	0f b6 db             	movzbl %bl,%ebx
  800b41:	29 d8                	sub    %ebx,%eax
  800b43:	eb 05                	jmp    800b4a <memcmp+0x35>
	}

	return 0;
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5c:	39 d0                	cmp    %edx,%eax
  800b5e:	73 09                	jae    800b69 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b60:	38 08                	cmp    %cl,(%eax)
  800b62:	74 05                	je     800b69 <memfind+0x1b>
	for (; s < ends; s++)
  800b64:	83 c0 01             	add    $0x1,%eax
  800b67:	eb f3                	jmp    800b5c <memfind+0xe>
			break;
	return (void *) s;
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b77:	eb 03                	jmp    800b7c <strtol+0x11>
		s++;
  800b79:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b7c:	0f b6 01             	movzbl (%ecx),%eax
  800b7f:	3c 20                	cmp    $0x20,%al
  800b81:	74 f6                	je     800b79 <strtol+0xe>
  800b83:	3c 09                	cmp    $0x9,%al
  800b85:	74 f2                	je     800b79 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b87:	3c 2b                	cmp    $0x2b,%al
  800b89:	74 2e                	je     800bb9 <strtol+0x4e>
	int neg = 0;
  800b8b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b90:	3c 2d                	cmp    $0x2d,%al
  800b92:	74 2f                	je     800bc3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b94:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b9a:	75 05                	jne    800ba1 <strtol+0x36>
  800b9c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9f:	74 2c                	je     800bcd <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	75 0a                	jne    800baf <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba5:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800baa:	80 39 30             	cmpb   $0x30,(%ecx)
  800bad:	74 28                	je     800bd7 <strtol+0x6c>
		base = 10;
  800baf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb7:	eb 50                	jmp    800c09 <strtol+0x9e>
		s++;
  800bb9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bbc:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc1:	eb d1                	jmp    800b94 <strtol+0x29>
		s++, neg = 1;
  800bc3:	83 c1 01             	add    $0x1,%ecx
  800bc6:	bf 01 00 00 00       	mov    $0x1,%edi
  800bcb:	eb c7                	jmp    800b94 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bd1:	74 0e                	je     800be1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bd3:	85 db                	test   %ebx,%ebx
  800bd5:	75 d8                	jne    800baf <strtol+0x44>
		s++, base = 8;
  800bd7:	83 c1 01             	add    $0x1,%ecx
  800bda:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bdf:	eb ce                	jmp    800baf <strtol+0x44>
		s += 2, base = 16;
  800be1:	83 c1 02             	add    $0x2,%ecx
  800be4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be9:	eb c4                	jmp    800baf <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800beb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bee:	89 f3                	mov    %esi,%ebx
  800bf0:	80 fb 19             	cmp    $0x19,%bl
  800bf3:	77 29                	ja     800c1e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bf5:	0f be d2             	movsbl %dl,%edx
  800bf8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bfb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bfe:	7d 30                	jge    800c30 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c00:	83 c1 01             	add    $0x1,%ecx
  800c03:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c07:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c09:	0f b6 11             	movzbl (%ecx),%edx
  800c0c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0f:	89 f3                	mov    %esi,%ebx
  800c11:	80 fb 09             	cmp    $0x9,%bl
  800c14:	77 d5                	ja     800beb <strtol+0x80>
			dig = *s - '0';
  800c16:	0f be d2             	movsbl %dl,%edx
  800c19:	83 ea 30             	sub    $0x30,%edx
  800c1c:	eb dd                	jmp    800bfb <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c1e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c21:	89 f3                	mov    %esi,%ebx
  800c23:	80 fb 19             	cmp    $0x19,%bl
  800c26:	77 08                	ja     800c30 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c28:	0f be d2             	movsbl %dl,%edx
  800c2b:	83 ea 37             	sub    $0x37,%edx
  800c2e:	eb cb                	jmp    800bfb <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c34:	74 05                	je     800c3b <strtol+0xd0>
		*endptr = (char *) s;
  800c36:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c39:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	f7 da                	neg    %edx
  800c3f:	85 ff                	test   %edi,%edi
  800c41:	0f 45 c2             	cmovne %edx,%eax
}
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5a:	89 c3                	mov    %eax,%ebx
  800c5c:	89 c7                	mov    %eax,%edi
  800c5e:	89 c6                	mov    %eax,%esi
  800c60:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	b8 01 00 00 00       	mov    $0x1,%eax
  800c77:	89 d1                	mov    %edx,%ecx
  800c79:	89 d3                	mov    %edx,%ebx
  800c7b:	89 d7                	mov    %edx,%edi
  800c7d:	89 d6                	mov    %edx,%esi
  800c7f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
  800c8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9c:	89 cb                	mov    %ecx,%ebx
  800c9e:	89 cf                	mov    %ecx,%edi
  800ca0:	89 ce                	mov    %ecx,%esi
  800ca2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	7f 08                	jg     800cb0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb0:	83 ec 0c             	sub    $0xc,%esp
  800cb3:	50                   	push   %eax
  800cb4:	6a 03                	push   $0x3
  800cb6:	68 df 2d 80 00       	push   $0x802ddf
  800cbb:	6a 23                	push   $0x23
  800cbd:	68 fc 2d 80 00       	push   $0x802dfc
  800cc2:	e8 cd f4 ff ff       	call   800194 <_panic>

00800cc7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd7:	89 d1                	mov    %edx,%ecx
  800cd9:	89 d3                	mov    %edx,%ebx
  800cdb:	89 d7                	mov    %edx,%edi
  800cdd:	89 d6                	mov    %edx,%esi
  800cdf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <sys_yield>:

void
sys_yield(void)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	57                   	push   %edi
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cec:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf6:	89 d1                	mov    %edx,%ecx
  800cf8:	89 d3                	mov    %edx,%ebx
  800cfa:	89 d7                	mov    %edx,%edi
  800cfc:	89 d6                	mov    %edx,%esi
  800cfe:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
  800d0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0e:	be 00 00 00 00       	mov    $0x0,%esi
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	b8 04 00 00 00       	mov    $0x4,%eax
  800d1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d21:	89 f7                	mov    %esi,%edi
  800d23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 04                	push   $0x4
  800d37:	68 df 2d 80 00       	push   $0x802ddf
  800d3c:	6a 23                	push   $0x23
  800d3e:	68 fc 2d 80 00       	push   $0x802dfc
  800d43:	e8 4c f4 ff ff       	call   800194 <_panic>

00800d48 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d57:	b8 05 00 00 00       	mov    $0x5,%eax
  800d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d62:	8b 75 18             	mov    0x18(%ebp),%esi
  800d65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7f 08                	jg     800d73 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	50                   	push   %eax
  800d77:	6a 05                	push   $0x5
  800d79:	68 df 2d 80 00       	push   $0x802ddf
  800d7e:	6a 23                	push   $0x23
  800d80:	68 fc 2d 80 00       	push   $0x802dfc
  800d85:	e8 0a f4 ff ff       	call   800194 <_panic>

00800d8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	b8 06 00 00 00       	mov    $0x6,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 06                	push   $0x6
  800dbb:	68 df 2d 80 00       	push   $0x802ddf
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 fc 2d 80 00       	push   $0x802dfc
  800dc7:	e8 c8 f3 ff ff       	call   800194 <_panic>

00800dcc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
  800dd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 08 00 00 00       	mov    $0x8,%eax
  800de5:	89 df                	mov    %ebx,%edi
  800de7:	89 de                	mov    %ebx,%esi
  800de9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7f 08                	jg     800df7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	50                   	push   %eax
  800dfb:	6a 08                	push   $0x8
  800dfd:	68 df 2d 80 00       	push   $0x802ddf
  800e02:	6a 23                	push   $0x23
  800e04:	68 fc 2d 80 00       	push   $0x802dfc
  800e09:	e8 86 f3 ff ff       	call   800194 <_panic>

00800e0e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 09 00 00 00       	mov    $0x9,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 09                	push   $0x9
  800e3f:	68 df 2d 80 00       	push   $0x802ddf
  800e44:	6a 23                	push   $0x23
  800e46:	68 fc 2d 80 00       	push   $0x802dfc
  800e4b:	e8 44 f3 ff ff       	call   800194 <_panic>

00800e50 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e69:	89 df                	mov    %ebx,%edi
  800e6b:	89 de                	mov    %ebx,%esi
  800e6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 0a                	push   $0xa
  800e81:	68 df 2d 80 00       	push   $0x802ddf
  800e86:	6a 23                	push   $0x23
  800e88:	68 fc 2d 80 00       	push   $0x802dfc
  800e8d:	e8 02 f3 ff ff       	call   800194 <_panic>

00800e92 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea3:	be 00 00 00 00       	mov    $0x0,%esi
  800ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eab:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eae:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
  800ebb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ecb:	89 cb                	mov    %ecx,%ebx
  800ecd:	89 cf                	mov    %ecx,%edi
  800ecf:	89 ce                	mov    %ecx,%esi
  800ed1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	7f 08                	jg     800edf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	50                   	push   %eax
  800ee3:	6a 0d                	push   $0xd
  800ee5:	68 df 2d 80 00       	push   $0x802ddf
  800eea:	6a 23                	push   $0x23
  800eec:	68 fc 2d 80 00       	push   $0x802dfc
  800ef1:	e8 9e f2 ff ff       	call   800194 <_panic>

00800ef6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efc:	ba 00 00 00 00       	mov    $0x0,%edx
  800f01:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f06:	89 d1                	mov    %edx,%ecx
  800f08:	89 d3                	mov    %edx,%ebx
  800f0a:	89 d7                	mov    %edx,%edi
  800f0c:	89 d6                	mov    %edx,%esi
  800f0e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	05 00 00 00 30       	add    $0x30000000,%eax
  800f20:	c1 e8 0c             	shr    $0xc,%eax
}
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    

00800f25 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f35:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f42:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f47:	89 c2                	mov    %eax,%edx
  800f49:	c1 ea 16             	shr    $0x16,%edx
  800f4c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f53:	f6 c2 01             	test   $0x1,%dl
  800f56:	74 2a                	je     800f82 <fd_alloc+0x46>
  800f58:	89 c2                	mov    %eax,%edx
  800f5a:	c1 ea 0c             	shr    $0xc,%edx
  800f5d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f64:	f6 c2 01             	test   $0x1,%dl
  800f67:	74 19                	je     800f82 <fd_alloc+0x46>
  800f69:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f6e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f73:	75 d2                	jne    800f47 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f75:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f7b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f80:	eb 07                	jmp    800f89 <fd_alloc+0x4d>
			*fd_store = fd;
  800f82:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f91:	83 f8 1f             	cmp    $0x1f,%eax
  800f94:	77 36                	ja     800fcc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f96:	c1 e0 0c             	shl    $0xc,%eax
  800f99:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f9e:	89 c2                	mov    %eax,%edx
  800fa0:	c1 ea 16             	shr    $0x16,%edx
  800fa3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800faa:	f6 c2 01             	test   $0x1,%dl
  800fad:	74 24                	je     800fd3 <fd_lookup+0x48>
  800faf:	89 c2                	mov    %eax,%edx
  800fb1:	c1 ea 0c             	shr    $0xc,%edx
  800fb4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fbb:	f6 c2 01             	test   $0x1,%dl
  800fbe:	74 1a                	je     800fda <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	89 02                	mov    %eax,(%edx)
	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    
		return -E_INVAL;
  800fcc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd1:	eb f7                	jmp    800fca <fd_lookup+0x3f>
		return -E_INVAL;
  800fd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd8:	eb f0                	jmp    800fca <fd_lookup+0x3f>
  800fda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fdf:	eb e9                	jmp    800fca <fd_lookup+0x3f>

00800fe1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 08             	sub    $0x8,%esp
  800fe7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fea:	ba 88 2e 80 00       	mov    $0x802e88,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fef:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ff4:	39 08                	cmp    %ecx,(%eax)
  800ff6:	74 33                	je     80102b <dev_lookup+0x4a>
  800ff8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ffb:	8b 02                	mov    (%edx),%eax
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 f3                	jne    800ff4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801001:	a1 08 50 80 00       	mov    0x805008,%eax
  801006:	8b 40 48             	mov    0x48(%eax),%eax
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	51                   	push   %ecx
  80100d:	50                   	push   %eax
  80100e:	68 0c 2e 80 00       	push   $0x802e0c
  801013:	e8 57 f2 ff ff       	call   80026f <cprintf>
	*dev = 0;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801021:	83 c4 10             	add    $0x10,%esp
  801024:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    
			*dev = devtab[i];
  80102b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801030:	b8 00 00 00 00       	mov    $0x0,%eax
  801035:	eb f2                	jmp    801029 <dev_lookup+0x48>

00801037 <fd_close>:
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	57                   	push   %edi
  80103b:	56                   	push   %esi
  80103c:	53                   	push   %ebx
  80103d:	83 ec 1c             	sub    $0x1c,%esp
  801040:	8b 75 08             	mov    0x8(%ebp),%esi
  801043:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801046:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801049:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80104a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801050:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801053:	50                   	push   %eax
  801054:	e8 32 ff ff ff       	call   800f8b <fd_lookup>
  801059:	89 c3                	mov    %eax,%ebx
  80105b:	83 c4 08             	add    $0x8,%esp
  80105e:	85 c0                	test   %eax,%eax
  801060:	78 05                	js     801067 <fd_close+0x30>
	    || fd != fd2)
  801062:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801065:	74 16                	je     80107d <fd_close+0x46>
		return (must_exist ? r : 0);
  801067:	89 f8                	mov    %edi,%eax
  801069:	84 c0                	test   %al,%al
  80106b:	b8 00 00 00 00       	mov    $0x0,%eax
  801070:	0f 44 d8             	cmove  %eax,%ebx
}
  801073:	89 d8                	mov    %ebx,%eax
  801075:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80107d:	83 ec 08             	sub    $0x8,%esp
  801080:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801083:	50                   	push   %eax
  801084:	ff 36                	pushl  (%esi)
  801086:	e8 56 ff ff ff       	call   800fe1 <dev_lookup>
  80108b:	89 c3                	mov    %eax,%ebx
  80108d:	83 c4 10             	add    $0x10,%esp
  801090:	85 c0                	test   %eax,%eax
  801092:	78 15                	js     8010a9 <fd_close+0x72>
		if (dev->dev_close)
  801094:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801097:	8b 40 10             	mov    0x10(%eax),%eax
  80109a:	85 c0                	test   %eax,%eax
  80109c:	74 1b                	je     8010b9 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80109e:	83 ec 0c             	sub    $0xc,%esp
  8010a1:	56                   	push   %esi
  8010a2:	ff d0                	call   *%eax
  8010a4:	89 c3                	mov    %eax,%ebx
  8010a6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	56                   	push   %esi
  8010ad:	6a 00                	push   $0x0
  8010af:	e8 d6 fc ff ff       	call   800d8a <sys_page_unmap>
	return r;
  8010b4:	83 c4 10             	add    $0x10,%esp
  8010b7:	eb ba                	jmp    801073 <fd_close+0x3c>
			r = 0;
  8010b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010be:	eb e9                	jmp    8010a9 <fd_close+0x72>

008010c0 <close>:

int
close(int fdnum)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c9:	50                   	push   %eax
  8010ca:	ff 75 08             	pushl  0x8(%ebp)
  8010cd:	e8 b9 fe ff ff       	call   800f8b <fd_lookup>
  8010d2:	83 c4 08             	add    $0x8,%esp
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	78 10                	js     8010e9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010d9:	83 ec 08             	sub    $0x8,%esp
  8010dc:	6a 01                	push   $0x1
  8010de:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e1:	e8 51 ff ff ff       	call   801037 <fd_close>
  8010e6:	83 c4 10             	add    $0x10,%esp
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <close_all>:

void
close_all(void)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	53                   	push   %ebx
  8010ef:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010f2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	53                   	push   %ebx
  8010fb:	e8 c0 ff ff ff       	call   8010c0 <close>
	for (i = 0; i < MAXFD; i++)
  801100:	83 c3 01             	add    $0x1,%ebx
  801103:	83 c4 10             	add    $0x10,%esp
  801106:	83 fb 20             	cmp    $0x20,%ebx
  801109:	75 ec                	jne    8010f7 <close_all+0xc>
}
  80110b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	57                   	push   %edi
  801114:	56                   	push   %esi
  801115:	53                   	push   %ebx
  801116:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801119:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80111c:	50                   	push   %eax
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	e8 66 fe ff ff       	call   800f8b <fd_lookup>
  801125:	89 c3                	mov    %eax,%ebx
  801127:	83 c4 08             	add    $0x8,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	0f 88 81 00 00 00    	js     8011b3 <dup+0xa3>
		return r;
	close(newfdnum);
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	e8 83 ff ff ff       	call   8010c0 <close>

	newfd = INDEX2FD(newfdnum);
  80113d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801140:	c1 e6 0c             	shl    $0xc,%esi
  801143:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801149:	83 c4 04             	add    $0x4,%esp
  80114c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114f:	e8 d1 fd ff ff       	call   800f25 <fd2data>
  801154:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801156:	89 34 24             	mov    %esi,(%esp)
  801159:	e8 c7 fd ff ff       	call   800f25 <fd2data>
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801163:	89 d8                	mov    %ebx,%eax
  801165:	c1 e8 16             	shr    $0x16,%eax
  801168:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80116f:	a8 01                	test   $0x1,%al
  801171:	74 11                	je     801184 <dup+0x74>
  801173:	89 d8                	mov    %ebx,%eax
  801175:	c1 e8 0c             	shr    $0xc,%eax
  801178:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80117f:	f6 c2 01             	test   $0x1,%dl
  801182:	75 39                	jne    8011bd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801184:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801187:	89 d0                	mov    %edx,%eax
  801189:	c1 e8 0c             	shr    $0xc,%eax
  80118c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801193:	83 ec 0c             	sub    $0xc,%esp
  801196:	25 07 0e 00 00       	and    $0xe07,%eax
  80119b:	50                   	push   %eax
  80119c:	56                   	push   %esi
  80119d:	6a 00                	push   $0x0
  80119f:	52                   	push   %edx
  8011a0:	6a 00                	push   $0x0
  8011a2:	e8 a1 fb ff ff       	call   800d48 <sys_page_map>
  8011a7:	89 c3                	mov    %eax,%ebx
  8011a9:	83 c4 20             	add    $0x20,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 31                	js     8011e1 <dup+0xd1>
		goto err;

	return newfdnum;
  8011b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011b3:	89 d8                	mov    %ebx,%eax
  8011b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5f                   	pop    %edi
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011c4:	83 ec 0c             	sub    $0xc,%esp
  8011c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011cc:	50                   	push   %eax
  8011cd:	57                   	push   %edi
  8011ce:	6a 00                	push   $0x0
  8011d0:	53                   	push   %ebx
  8011d1:	6a 00                	push   $0x0
  8011d3:	e8 70 fb ff ff       	call   800d48 <sys_page_map>
  8011d8:	89 c3                	mov    %eax,%ebx
  8011da:	83 c4 20             	add    $0x20,%esp
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	79 a3                	jns    801184 <dup+0x74>
	sys_page_unmap(0, newfd);
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	56                   	push   %esi
  8011e5:	6a 00                	push   $0x0
  8011e7:	e8 9e fb ff ff       	call   800d8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011ec:	83 c4 08             	add    $0x8,%esp
  8011ef:	57                   	push   %edi
  8011f0:	6a 00                	push   $0x0
  8011f2:	e8 93 fb ff ff       	call   800d8a <sys_page_unmap>
	return r;
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	eb b7                	jmp    8011b3 <dup+0xa3>

008011fc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	53                   	push   %ebx
  801200:	83 ec 14             	sub    $0x14,%esp
  801203:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801206:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801209:	50                   	push   %eax
  80120a:	53                   	push   %ebx
  80120b:	e8 7b fd ff ff       	call   800f8b <fd_lookup>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	78 3f                	js     801256 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121d:	50                   	push   %eax
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801221:	ff 30                	pushl  (%eax)
  801223:	e8 b9 fd ff ff       	call   800fe1 <dev_lookup>
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	78 27                	js     801256 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80122f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801232:	8b 42 08             	mov    0x8(%edx),%eax
  801235:	83 e0 03             	and    $0x3,%eax
  801238:	83 f8 01             	cmp    $0x1,%eax
  80123b:	74 1e                	je     80125b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80123d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801240:	8b 40 08             	mov    0x8(%eax),%eax
  801243:	85 c0                	test   %eax,%eax
  801245:	74 35                	je     80127c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801247:	83 ec 04             	sub    $0x4,%esp
  80124a:	ff 75 10             	pushl  0x10(%ebp)
  80124d:	ff 75 0c             	pushl  0xc(%ebp)
  801250:	52                   	push   %edx
  801251:	ff d0                	call   *%eax
  801253:	83 c4 10             	add    $0x10,%esp
}
  801256:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801259:	c9                   	leave  
  80125a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80125b:	a1 08 50 80 00       	mov    0x805008,%eax
  801260:	8b 40 48             	mov    0x48(%eax),%eax
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	53                   	push   %ebx
  801267:	50                   	push   %eax
  801268:	68 4d 2e 80 00       	push   $0x802e4d
  80126d:	e8 fd ef ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127a:	eb da                	jmp    801256 <read+0x5a>
		return -E_NOT_SUPP;
  80127c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801281:	eb d3                	jmp    801256 <read+0x5a>

00801283 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	57                   	push   %edi
  801287:	56                   	push   %esi
  801288:	53                   	push   %ebx
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80128f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801292:	bb 00 00 00 00       	mov    $0x0,%ebx
  801297:	39 f3                	cmp    %esi,%ebx
  801299:	73 25                	jae    8012c0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80129b:	83 ec 04             	sub    $0x4,%esp
  80129e:	89 f0                	mov    %esi,%eax
  8012a0:	29 d8                	sub    %ebx,%eax
  8012a2:	50                   	push   %eax
  8012a3:	89 d8                	mov    %ebx,%eax
  8012a5:	03 45 0c             	add    0xc(%ebp),%eax
  8012a8:	50                   	push   %eax
  8012a9:	57                   	push   %edi
  8012aa:	e8 4d ff ff ff       	call   8011fc <read>
		if (m < 0)
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 08                	js     8012be <readn+0x3b>
			return m;
		if (m == 0)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	74 06                	je     8012c0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012ba:	01 c3                	add    %eax,%ebx
  8012bc:	eb d9                	jmp    801297 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012be:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012c0:	89 d8                	mov    %ebx,%eax
  8012c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5f                   	pop    %edi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    

008012ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	53                   	push   %ebx
  8012ce:	83 ec 14             	sub    $0x14,%esp
  8012d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	53                   	push   %ebx
  8012d9:	e8 ad fc ff ff       	call   800f8b <fd_lookup>
  8012de:	83 c4 08             	add    $0x8,%esp
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	78 3a                	js     80131f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ef:	ff 30                	pushl  (%eax)
  8012f1:	e8 eb fc ff ff       	call   800fe1 <dev_lookup>
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	78 22                	js     80131f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801300:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801304:	74 1e                	je     801324 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801309:	8b 52 0c             	mov    0xc(%edx),%edx
  80130c:	85 d2                	test   %edx,%edx
  80130e:	74 35                	je     801345 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801310:	83 ec 04             	sub    $0x4,%esp
  801313:	ff 75 10             	pushl  0x10(%ebp)
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	50                   	push   %eax
  80131a:	ff d2                	call   *%edx
  80131c:	83 c4 10             	add    $0x10,%esp
}
  80131f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801322:	c9                   	leave  
  801323:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801324:	a1 08 50 80 00       	mov    0x805008,%eax
  801329:	8b 40 48             	mov    0x48(%eax),%eax
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	53                   	push   %ebx
  801330:	50                   	push   %eax
  801331:	68 69 2e 80 00       	push   $0x802e69
  801336:	e8 34 ef ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801343:	eb da                	jmp    80131f <write+0x55>
		return -E_NOT_SUPP;
  801345:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80134a:	eb d3                	jmp    80131f <write+0x55>

0080134c <seek>:

int
seek(int fdnum, off_t offset)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801352:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801355:	50                   	push   %eax
  801356:	ff 75 08             	pushl  0x8(%ebp)
  801359:	e8 2d fc ff ff       	call   800f8b <fd_lookup>
  80135e:	83 c4 08             	add    $0x8,%esp
  801361:	85 c0                	test   %eax,%eax
  801363:	78 0e                	js     801373 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801365:	8b 55 0c             	mov    0xc(%ebp),%edx
  801368:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80136e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	53                   	push   %ebx
  801379:	83 ec 14             	sub    $0x14,%esp
  80137c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	53                   	push   %ebx
  801384:	e8 02 fc ff ff       	call   800f8b <fd_lookup>
  801389:	83 c4 08             	add    $0x8,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 37                	js     8013c7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801396:	50                   	push   %eax
  801397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139a:	ff 30                	pushl  (%eax)
  80139c:	e8 40 fc ff ff       	call   800fe1 <dev_lookup>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 1f                	js     8013c7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ab:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013af:	74 1b                	je     8013cc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b4:	8b 52 18             	mov    0x18(%edx),%edx
  8013b7:	85 d2                	test   %edx,%edx
  8013b9:	74 32                	je     8013ed <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	50                   	push   %eax
  8013c2:	ff d2                	call   *%edx
  8013c4:	83 c4 10             	add    $0x10,%esp
}
  8013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013cc:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013d1:	8b 40 48             	mov    0x48(%eax),%eax
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	53                   	push   %ebx
  8013d8:	50                   	push   %eax
  8013d9:	68 2c 2e 80 00       	push   $0x802e2c
  8013de:	e8 8c ee ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013eb:	eb da                	jmp    8013c7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f2:	eb d3                	jmp    8013c7 <ftruncate+0x52>

008013f4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	53                   	push   %ebx
  8013f8:	83 ec 14             	sub    $0x14,%esp
  8013fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801401:	50                   	push   %eax
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	e8 81 fb ff ff       	call   800f8b <fd_lookup>
  80140a:	83 c4 08             	add    $0x8,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 4b                	js     80145c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801411:	83 ec 08             	sub    $0x8,%esp
  801414:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801417:	50                   	push   %eax
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	ff 30                	pushl  (%eax)
  80141d:	e8 bf fb ff ff       	call   800fe1 <dev_lookup>
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	78 33                	js     80145c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801430:	74 2f                	je     801461 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801432:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801435:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80143c:	00 00 00 
	stat->st_isdir = 0;
  80143f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801446:	00 00 00 
	stat->st_dev = dev;
  801449:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	53                   	push   %ebx
  801453:	ff 75 f0             	pushl  -0x10(%ebp)
  801456:	ff 50 14             	call   *0x14(%eax)
  801459:	83 c4 10             	add    $0x10,%esp
}
  80145c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145f:	c9                   	leave  
  801460:	c3                   	ret    
		return -E_NOT_SUPP;
  801461:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801466:	eb f4                	jmp    80145c <fstat+0x68>

00801468 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	56                   	push   %esi
  80146c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	6a 00                	push   $0x0
  801472:	ff 75 08             	pushl  0x8(%ebp)
  801475:	e8 26 02 00 00       	call   8016a0 <open>
  80147a:	89 c3                	mov    %eax,%ebx
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 1b                	js     80149e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	50                   	push   %eax
  80148a:	e8 65 ff ff ff       	call   8013f4 <fstat>
  80148f:	89 c6                	mov    %eax,%esi
	close(fd);
  801491:	89 1c 24             	mov    %ebx,(%esp)
  801494:	e8 27 fc ff ff       	call   8010c0 <close>
	return r;
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	89 f3                	mov    %esi,%ebx
}
  80149e:	89 d8                	mov    %ebx,%eax
  8014a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a3:	5b                   	pop    %ebx
  8014a4:	5e                   	pop    %esi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	56                   	push   %esi
  8014ab:	53                   	push   %ebx
  8014ac:	89 c6                	mov    %eax,%esi
  8014ae:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014b0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8014b7:	74 27                	je     8014e0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014b9:	6a 07                	push   $0x7
  8014bb:	68 00 60 80 00       	push   $0x806000
  8014c0:	56                   	push   %esi
  8014c1:	ff 35 00 50 80 00    	pushl  0x805000
  8014c7:	e8 06 12 00 00       	call   8026d2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014cc:	83 c4 0c             	add    $0xc,%esp
  8014cf:	6a 00                	push   $0x0
  8014d1:	53                   	push   %ebx
  8014d2:	6a 00                	push   $0x0
  8014d4:	e8 90 11 00 00       	call   802669 <ipc_recv>
}
  8014d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014dc:	5b                   	pop    %ebx
  8014dd:	5e                   	pop    %esi
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	6a 01                	push   $0x1
  8014e5:	e8 41 12 00 00       	call   80272b <ipc_find_env>
  8014ea:	a3 00 50 80 00       	mov    %eax,0x805000
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	eb c5                	jmp    8014b9 <fsipc+0x12>

008014f4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801500:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80150d:	ba 00 00 00 00       	mov    $0x0,%edx
  801512:	b8 02 00 00 00       	mov    $0x2,%eax
  801517:	e8 8b ff ff ff       	call   8014a7 <fsipc>
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <devfile_flush>:
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8b 40 0c             	mov    0xc(%eax),%eax
  80152a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80152f:	ba 00 00 00 00       	mov    $0x0,%edx
  801534:	b8 06 00 00 00       	mov    $0x6,%eax
  801539:	e8 69 ff ff ff       	call   8014a7 <fsipc>
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <devfile_stat>:
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	53                   	push   %ebx
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8b 40 0c             	mov    0xc(%eax),%eax
  801550:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801555:	ba 00 00 00 00       	mov    $0x0,%edx
  80155a:	b8 05 00 00 00       	mov    $0x5,%eax
  80155f:	e8 43 ff ff ff       	call   8014a7 <fsipc>
  801564:	85 c0                	test   %eax,%eax
  801566:	78 2c                	js     801594 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801568:	83 ec 08             	sub    $0x8,%esp
  80156b:	68 00 60 80 00       	push   $0x806000
  801570:	53                   	push   %ebx
  801571:	e8 96 f3 ff ff       	call   80090c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801576:	a1 80 60 80 00       	mov    0x806080,%eax
  80157b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801581:	a1 84 60 80 00       	mov    0x806084,%eax
  801586:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801594:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <devfile_write>:
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	53                   	push   %ebx
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8015ae:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015b4:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015ba:	77 30                	ja     8015ec <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	53                   	push   %ebx
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	68 08 60 80 00       	push   $0x806008
  8015c8:	e8 cd f4 ff ff       	call   800a9a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d2:	b8 04 00 00 00       	mov    $0x4,%eax
  8015d7:	e8 cb fe ff ff       	call   8014a7 <fsipc>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 04                	js     8015e7 <devfile_write+0x4e>
	assert(r <= n);
  8015e3:	39 d8                	cmp    %ebx,%eax
  8015e5:	77 1e                	ja     801605 <devfile_write+0x6c>
}
  8015e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015ec:	68 9c 2e 80 00       	push   $0x802e9c
  8015f1:	68 c9 2e 80 00       	push   $0x802ec9
  8015f6:	68 94 00 00 00       	push   $0x94
  8015fb:	68 de 2e 80 00       	push   $0x802ede
  801600:	e8 8f eb ff ff       	call   800194 <_panic>
	assert(r <= n);
  801605:	68 e9 2e 80 00       	push   $0x802ee9
  80160a:	68 c9 2e 80 00       	push   $0x802ec9
  80160f:	68 98 00 00 00       	push   $0x98
  801614:	68 de 2e 80 00       	push   $0x802ede
  801619:	e8 76 eb ff ff       	call   800194 <_panic>

0080161e <devfile_read>:
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
  801623:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8b 40 0c             	mov    0xc(%eax),%eax
  80162c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801631:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801637:	ba 00 00 00 00       	mov    $0x0,%edx
  80163c:	b8 03 00 00 00       	mov    $0x3,%eax
  801641:	e8 61 fe ff ff       	call   8014a7 <fsipc>
  801646:	89 c3                	mov    %eax,%ebx
  801648:	85 c0                	test   %eax,%eax
  80164a:	78 1f                	js     80166b <devfile_read+0x4d>
	assert(r <= n);
  80164c:	39 f0                	cmp    %esi,%eax
  80164e:	77 24                	ja     801674 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801650:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801655:	7f 33                	jg     80168a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	50                   	push   %eax
  80165b:	68 00 60 80 00       	push   $0x806000
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 32 f4 ff ff       	call   800a9a <memmove>
	return r;
  801668:	83 c4 10             	add    $0x10,%esp
}
  80166b:	89 d8                	mov    %ebx,%eax
  80166d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801670:	5b                   	pop    %ebx
  801671:	5e                   	pop    %esi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    
	assert(r <= n);
  801674:	68 e9 2e 80 00       	push   $0x802ee9
  801679:	68 c9 2e 80 00       	push   $0x802ec9
  80167e:	6a 7c                	push   $0x7c
  801680:	68 de 2e 80 00       	push   $0x802ede
  801685:	e8 0a eb ff ff       	call   800194 <_panic>
	assert(r <= PGSIZE);
  80168a:	68 f0 2e 80 00       	push   $0x802ef0
  80168f:	68 c9 2e 80 00       	push   $0x802ec9
  801694:	6a 7d                	push   $0x7d
  801696:	68 de 2e 80 00       	push   $0x802ede
  80169b:	e8 f4 ea ff ff       	call   800194 <_panic>

008016a0 <open>:
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	56                   	push   %esi
  8016a4:	53                   	push   %ebx
  8016a5:	83 ec 1c             	sub    $0x1c,%esp
  8016a8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016ab:	56                   	push   %esi
  8016ac:	e8 24 f2 ff ff       	call   8008d5 <strlen>
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016b9:	7f 6c                	jg     801727 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016bb:	83 ec 0c             	sub    $0xc,%esp
  8016be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c1:	50                   	push   %eax
  8016c2:	e8 75 f8 ff ff       	call   800f3c <fd_alloc>
  8016c7:	89 c3                	mov    %eax,%ebx
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 3c                	js     80170c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	56                   	push   %esi
  8016d4:	68 00 60 80 00       	push   $0x806000
  8016d9:	e8 2e f2 ff ff       	call   80090c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ee:	e8 b4 fd ff ff       	call   8014a7 <fsipc>
  8016f3:	89 c3                	mov    %eax,%ebx
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	78 19                	js     801715 <open+0x75>
	return fd2num(fd);
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801702:	e8 0e f8 ff ff       	call   800f15 <fd2num>
  801707:	89 c3                	mov    %eax,%ebx
  801709:	83 c4 10             	add    $0x10,%esp
}
  80170c:	89 d8                	mov    %ebx,%eax
  80170e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    
		fd_close(fd, 0);
  801715:	83 ec 08             	sub    $0x8,%esp
  801718:	6a 00                	push   $0x0
  80171a:	ff 75 f4             	pushl  -0xc(%ebp)
  80171d:	e8 15 f9 ff ff       	call   801037 <fd_close>
		return r;
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	eb e5                	jmp    80170c <open+0x6c>
		return -E_BAD_PATH;
  801727:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80172c:	eb de                	jmp    80170c <open+0x6c>

0080172e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	b8 08 00 00 00       	mov    $0x8,%eax
  80173e:	e8 64 fd ff ff       	call   8014a7 <fsipc>
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	57                   	push   %edi
  801749:	56                   	push   %esi
  80174a:	53                   	push   %ebx
  80174b:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801751:	6a 00                	push   $0x0
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	e8 45 ff ff ff       	call   8016a0 <open>
  80175b:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	0f 88 40 03 00 00    	js     801aac <spawn+0x367>
  80176c:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	68 00 02 00 00       	push   $0x200
  801776:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80177c:	50                   	push   %eax
  80177d:	52                   	push   %edx
  80177e:	e8 00 fb ff ff       	call   801283 <readn>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	3d 00 02 00 00       	cmp    $0x200,%eax
  80178b:	75 5d                	jne    8017ea <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  80178d:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801794:	45 4c 46 
  801797:	75 51                	jne    8017ea <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801799:	b8 07 00 00 00       	mov    $0x7,%eax
  80179e:	cd 30                	int    $0x30
  8017a0:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8017a6:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	0f 88 b6 04 00 00    	js     801c6a <spawn+0x525>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8017b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017b9:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8017bc:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8017c2:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8017c8:	b9 11 00 00 00       	mov    $0x11,%ecx
  8017cd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8017cf:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8017d5:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8017db:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8017e0:	be 00 00 00 00       	mov    $0x0,%esi
  8017e5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8017e8:	eb 4b                	jmp    801835 <spawn+0xf0>
		close(fd);
  8017ea:	83 ec 0c             	sub    $0xc,%esp
  8017ed:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8017f3:	e8 c8 f8 ff ff       	call   8010c0 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8017f8:	83 c4 0c             	add    $0xc,%esp
  8017fb:	68 7f 45 4c 46       	push   $0x464c457f
  801800:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801806:	68 fc 2e 80 00       	push   $0x802efc
  80180b:	e8 5f ea ff ff       	call   80026f <cprintf>
		return -E_NOT_EXEC;
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  80181a:	ff ff ff 
  80181d:	e9 8a 02 00 00       	jmp    801aac <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801822:	83 ec 0c             	sub    $0xc,%esp
  801825:	50                   	push   %eax
  801826:	e8 aa f0 ff ff       	call   8008d5 <strlen>
  80182b:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80182f:	83 c3 01             	add    $0x1,%ebx
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80183c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80183f:	85 c0                	test   %eax,%eax
  801841:	75 df                	jne    801822 <spawn+0xdd>
  801843:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801849:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80184f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801854:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801856:	89 fa                	mov    %edi,%edx
  801858:	83 e2 fc             	and    $0xfffffffc,%edx
  80185b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801862:	29 c2                	sub    %eax,%edx
  801864:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80186a:	8d 42 f8             	lea    -0x8(%edx),%eax
  80186d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801872:	0f 86 03 04 00 00    	jbe    801c7b <spawn+0x536>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	6a 07                	push   $0x7
  80187d:	68 00 00 40 00       	push   $0x400000
  801882:	6a 00                	push   $0x0
  801884:	e8 7c f4 ff ff       	call   800d05 <sys_page_alloc>
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	0f 88 ec 03 00 00    	js     801c80 <spawn+0x53b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801894:	be 00 00 00 00       	mov    $0x0,%esi
  801899:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80189f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018a2:	eb 30                	jmp    8018d4 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  8018a4:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8018aa:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8018b0:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  8018b3:	83 ec 08             	sub    $0x8,%esp
  8018b6:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018b9:	57                   	push   %edi
  8018ba:	e8 4d f0 ff ff       	call   80090c <strcpy>
		string_store += strlen(argv[i]) + 1;
  8018bf:	83 c4 04             	add    $0x4,%esp
  8018c2:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018c5:	e8 0b f0 ff ff       	call   8008d5 <strlen>
  8018ca:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8018ce:	83 c6 01             	add    $0x1,%esi
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8018da:	7f c8                	jg     8018a4 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  8018dc:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8018e2:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8018e8:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018ef:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8018f5:	0f 85 8c 00 00 00    	jne    801987 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8018fb:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801901:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801907:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  80190a:	89 f8                	mov    %edi,%eax
  80190c:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801912:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801915:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80191a:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801920:	83 ec 0c             	sub    $0xc,%esp
  801923:	6a 07                	push   $0x7
  801925:	68 00 d0 bf ee       	push   $0xeebfd000
  80192a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801930:	68 00 00 40 00       	push   $0x400000
  801935:	6a 00                	push   $0x0
  801937:	e8 0c f4 ff ff       	call   800d48 <sys_page_map>
  80193c:	89 c3                	mov    %eax,%ebx
  80193e:	83 c4 20             	add    $0x20,%esp
  801941:	85 c0                	test   %eax,%eax
  801943:	0f 88 57 03 00 00    	js     801ca0 <spawn+0x55b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801949:	83 ec 08             	sub    $0x8,%esp
  80194c:	68 00 00 40 00       	push   $0x400000
  801951:	6a 00                	push   $0x0
  801953:	e8 32 f4 ff ff       	call   800d8a <sys_page_unmap>
  801958:	89 c3                	mov    %eax,%ebx
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	0f 88 3b 03 00 00    	js     801ca0 <spawn+0x55b>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801965:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80196b:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801972:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801978:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  80197f:	00 00 00 
  801982:	e9 56 01 00 00       	jmp    801add <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801987:	68 88 2f 80 00       	push   $0x802f88
  80198c:	68 c9 2e 80 00       	push   $0x802ec9
  801991:	68 f2 00 00 00       	push   $0xf2
  801996:	68 16 2f 80 00       	push   $0x802f16
  80199b:	e8 f4 e7 ff ff       	call   800194 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	6a 07                	push   $0x7
  8019a5:	68 00 00 40 00       	push   $0x400000
  8019aa:	6a 00                	push   $0x0
  8019ac:	e8 54 f3 ff ff       	call   800d05 <sys_page_alloc>
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	0f 88 cf 02 00 00    	js     801c8b <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8019bc:	83 ec 08             	sub    $0x8,%esp
  8019bf:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8019c5:	01 f0                	add    %esi,%eax
  8019c7:	50                   	push   %eax
  8019c8:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8019ce:	e8 79 f9 ff ff       	call   80134c <seek>
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	0f 88 b4 02 00 00    	js     801c92 <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8019e7:	29 f0                	sub    %esi,%eax
  8019e9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ee:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8019f3:	0f 47 c1             	cmova  %ecx,%eax
  8019f6:	50                   	push   %eax
  8019f7:	68 00 00 40 00       	push   $0x400000
  8019fc:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801a02:	e8 7c f8 ff ff       	call   801283 <readn>
  801a07:	83 c4 10             	add    $0x10,%esp
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	0f 88 87 02 00 00    	js     801c99 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801a12:	83 ec 0c             	sub    $0xc,%esp
  801a15:	57                   	push   %edi
  801a16:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801a1c:	56                   	push   %esi
  801a1d:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801a23:	68 00 00 40 00       	push   $0x400000
  801a28:	6a 00                	push   $0x0
  801a2a:	e8 19 f3 ff ff       	call   800d48 <sys_page_map>
  801a2f:	83 c4 20             	add    $0x20,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	0f 88 80 00 00 00    	js     801aba <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	68 00 00 40 00       	push   $0x400000
  801a42:	6a 00                	push   $0x0
  801a44:	e8 41 f3 ff ff       	call   800d8a <sys_page_unmap>
  801a49:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801a4c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a52:	89 de                	mov    %ebx,%esi
  801a54:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801a5a:	76 73                	jbe    801acf <spawn+0x38a>
		if (i >= filesz) {
  801a5c:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801a62:	0f 87 38 ff ff ff    	ja     8019a0 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	57                   	push   %edi
  801a6c:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801a72:	56                   	push   %esi
  801a73:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801a79:	e8 87 f2 ff ff       	call   800d05 <sys_page_alloc>
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	79 c7                	jns    801a4c <spawn+0x307>
  801a85:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a90:	e8 f1 f1 ff ff       	call   800c86 <sys_env_destroy>
	close(fd);
  801a95:	83 c4 04             	add    $0x4,%esp
  801a98:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801a9e:	e8 1d f6 ff ff       	call   8010c0 <close>
	return r;
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801aac:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ab2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab5:	5b                   	pop    %ebx
  801ab6:	5e                   	pop    %esi
  801ab7:	5f                   	pop    %edi
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801aba:	50                   	push   %eax
  801abb:	68 22 2f 80 00       	push   $0x802f22
  801ac0:	68 25 01 00 00       	push   $0x125
  801ac5:	68 16 2f 80 00       	push   $0x802f16
  801aca:	e8 c5 e6 ff ff       	call   800194 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801acf:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801ad6:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801add:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ae4:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801aea:	7e 71                	jle    801b5d <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801aec:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801af2:	83 39 01             	cmpl   $0x1,(%ecx)
  801af5:	75 d8                	jne    801acf <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801af7:	8b 41 18             	mov    0x18(%ecx),%eax
  801afa:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801afd:	83 f8 01             	cmp    $0x1,%eax
  801b00:	19 ff                	sbb    %edi,%edi
  801b02:	83 e7 fe             	and    $0xfffffffe,%edi
  801b05:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b08:	8b 71 04             	mov    0x4(%ecx),%esi
  801b0b:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801b11:	8b 59 10             	mov    0x10(%ecx),%ebx
  801b14:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801b1a:	8b 41 14             	mov    0x14(%ecx),%eax
  801b1d:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801b23:	8b 51 08             	mov    0x8(%ecx),%edx
  801b26:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  801b2c:	89 d0                	mov    %edx,%eax
  801b2e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b33:	74 1e                	je     801b53 <spawn+0x40e>
		va -= i;
  801b35:	29 c2                	sub    %eax,%edx
  801b37:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  801b3d:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801b43:	01 c3                	add    %eax,%ebx
  801b45:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801b4b:	29 c6                	sub    %eax,%esi
  801b4d:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801b53:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b58:	e9 f5 fe ff ff       	jmp    801a52 <spawn+0x30d>
	close(fd);
  801b5d:	83 ec 0c             	sub    $0xc,%esp
  801b60:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b66:	e8 55 f5 ff ff       	call   8010c0 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	envid_t parent_envid = sys_getenvid();
  801b6b:	e8 57 f1 ff ff       	call   800cc7 <sys_getenvid>
  801b70:	89 c6                	mov    %eax,%esi
  801b72:	83 c4 10             	add    $0x10,%esp
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801b75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b7a:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801b80:	eb 0e                	jmp    801b90 <spawn+0x44b>
  801b82:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b88:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801b8e:	74 62                	je     801bf2 <spawn+0x4ad>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_SHARE) == PTE_SHARE) {
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	c1 e8 16             	shr    $0x16,%eax
  801b95:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b9c:	a8 01                	test   $0x1,%al
  801b9e:	74 e2                	je     801b82 <spawn+0x43d>
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	c1 e8 0c             	shr    $0xc,%eax
  801ba5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bac:	f6 c2 01             	test   $0x1,%dl
  801baf:	74 d1                	je     801b82 <spawn+0x43d>
  801bb1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bb8:	f6 c6 04             	test   $0x4,%dh
  801bbb:	74 c5                	je     801b82 <spawn+0x43d>
	        if ((r = sys_page_map(parent_envid, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
  801bbd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	25 07 0e 00 00       	and    $0xe07,%eax
  801bcc:	50                   	push   %eax
  801bcd:	53                   	push   %ebx
  801bce:	57                   	push   %edi
  801bcf:	53                   	push   %ebx
  801bd0:	56                   	push   %esi
  801bd1:	e8 72 f1 ff ff       	call   800d48 <sys_page_map>
  801bd6:	83 c4 20             	add    $0x20,%esp
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	74 a5                	je     801b82 <spawn+0x43d>
	            panic("copy_shared_pages: %e", r);
  801bdd:	50                   	push   %eax
  801bde:	68 3f 2f 80 00       	push   $0x802f3f
  801be3:	68 38 01 00 00       	push   $0x138
  801be8:	68 16 2f 80 00       	push   $0x802f16
  801bed:	e8 a2 e5 ff ff       	call   800194 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801bf2:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801bf9:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801c05:	50                   	push   %eax
  801c06:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c0c:	e8 fd f1 ff ff       	call   800e0e <sys_env_set_trapframe>
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	85 c0                	test   %eax,%eax
  801c16:	78 28                	js     801c40 <spawn+0x4fb>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	6a 02                	push   $0x2
  801c1d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c23:	e8 a4 f1 ff ff       	call   800dcc <sys_env_set_status>
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 26                	js     801c55 <spawn+0x510>
	return child;
  801c2f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c35:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801c3b:	e9 6c fe ff ff       	jmp    801aac <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  801c40:	50                   	push   %eax
  801c41:	68 55 2f 80 00       	push   $0x802f55
  801c46:	68 86 00 00 00       	push   $0x86
  801c4b:	68 16 2f 80 00       	push   $0x802f16
  801c50:	e8 3f e5 ff ff       	call   800194 <_panic>
		panic("sys_env_set_status: %e", r);
  801c55:	50                   	push   %eax
  801c56:	68 6f 2f 80 00       	push   $0x802f6f
  801c5b:	68 89 00 00 00       	push   $0x89
  801c60:	68 16 2f 80 00       	push   $0x802f16
  801c65:	e8 2a e5 ff ff       	call   800194 <_panic>
		return r;
  801c6a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c70:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801c76:	e9 31 fe ff ff       	jmp    801aac <spawn+0x367>
		return -E_NO_MEM;
  801c7b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801c80:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801c86:	e9 21 fe ff ff       	jmp    801aac <spawn+0x367>
  801c8b:	89 c7                	mov    %eax,%edi
  801c8d:	e9 f5 fd ff ff       	jmp    801a87 <spawn+0x342>
  801c92:	89 c7                	mov    %eax,%edi
  801c94:	e9 ee fd ff ff       	jmp    801a87 <spawn+0x342>
  801c99:	89 c7                	mov    %eax,%edi
  801c9b:	e9 e7 fd ff ff       	jmp    801a87 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  801ca0:	83 ec 08             	sub    $0x8,%esp
  801ca3:	68 00 00 40 00       	push   $0x400000
  801ca8:	6a 00                	push   $0x0
  801caa:	e8 db f0 ff ff       	call   800d8a <sys_page_unmap>
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801cb8:	e9 ef fd ff ff       	jmp    801aac <spawn+0x367>

00801cbd <spawnl>:
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	57                   	push   %edi
  801cc1:	56                   	push   %esi
  801cc2:	53                   	push   %ebx
  801cc3:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801cc6:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801cce:	eb 05                	jmp    801cd5 <spawnl+0x18>
		argc++;
  801cd0:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801cd3:	89 ca                	mov    %ecx,%edx
  801cd5:	8d 4a 04             	lea    0x4(%edx),%ecx
  801cd8:	83 3a 00             	cmpl   $0x0,(%edx)
  801cdb:	75 f3                	jne    801cd0 <spawnl+0x13>
	const char *argv[argc+2];
  801cdd:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801ce4:	83 e2 f0             	and    $0xfffffff0,%edx
  801ce7:	29 d4                	sub    %edx,%esp
  801ce9:	8d 54 24 03          	lea    0x3(%esp),%edx
  801ced:	c1 ea 02             	shr    $0x2,%edx
  801cf0:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801cf7:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cfc:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801d03:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d0a:	00 
	va_start(vl, arg0);
  801d0b:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801d0e:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
  801d15:	eb 0b                	jmp    801d22 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801d17:	83 c0 01             	add    $0x1,%eax
  801d1a:	8b 39                	mov    (%ecx),%edi
  801d1c:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801d1f:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d22:	39 d0                	cmp    %edx,%eax
  801d24:	75 f1                	jne    801d17 <spawnl+0x5a>
	return spawn(prog, argv);
  801d26:	83 ec 08             	sub    $0x8,%esp
  801d29:	56                   	push   %esi
  801d2a:	ff 75 08             	pushl  0x8(%ebp)
  801d2d:	e8 13 fa ff ff       	call   801745 <spawn>
}
  801d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    

00801d3a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	56                   	push   %esi
  801d3e:	53                   	push   %ebx
  801d3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	e8 d8 f1 ff ff       	call   800f25 <fd2data>
  801d4d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d4f:	83 c4 08             	add    $0x8,%esp
  801d52:	68 b0 2f 80 00       	push   $0x802fb0
  801d57:	53                   	push   %ebx
  801d58:	e8 af eb ff ff       	call   80090c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d5d:	8b 46 04             	mov    0x4(%esi),%eax
  801d60:	2b 06                	sub    (%esi),%eax
  801d62:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d68:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d6f:	00 00 00 
	stat->st_dev = &devpipe;
  801d72:	c7 83 88 00 00 00 20 	movl   $0x804020,0x88(%ebx)
  801d79:	40 80 00 
	return 0;
}
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    

00801d88 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	53                   	push   %ebx
  801d8c:	83 ec 0c             	sub    $0xc,%esp
  801d8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d92:	53                   	push   %ebx
  801d93:	6a 00                	push   $0x0
  801d95:	e8 f0 ef ff ff       	call   800d8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d9a:	89 1c 24             	mov    %ebx,(%esp)
  801d9d:	e8 83 f1 ff ff       	call   800f25 <fd2data>
  801da2:	83 c4 08             	add    $0x8,%esp
  801da5:	50                   	push   %eax
  801da6:	6a 00                	push   $0x0
  801da8:	e8 dd ef ff ff       	call   800d8a <sys_page_unmap>
}
  801dad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <_pipeisclosed>:
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	89 c7                	mov    %eax,%edi
  801dbd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dbf:	a1 08 50 80 00       	mov    0x805008,%eax
  801dc4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dc7:	83 ec 0c             	sub    $0xc,%esp
  801dca:	57                   	push   %edi
  801dcb:	e8 94 09 00 00       	call   802764 <pageref>
  801dd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd3:	89 34 24             	mov    %esi,(%esp)
  801dd6:	e8 89 09 00 00       	call   802764 <pageref>
		nn = thisenv->env_runs;
  801ddb:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801de1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	39 cb                	cmp    %ecx,%ebx
  801de9:	74 1b                	je     801e06 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801deb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dee:	75 cf                	jne    801dbf <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801df0:	8b 42 58             	mov    0x58(%edx),%eax
  801df3:	6a 01                	push   $0x1
  801df5:	50                   	push   %eax
  801df6:	53                   	push   %ebx
  801df7:	68 b7 2f 80 00       	push   $0x802fb7
  801dfc:	e8 6e e4 ff ff       	call   80026f <cprintf>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	eb b9                	jmp    801dbf <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e06:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e09:	0f 94 c0             	sete   %al
  801e0c:	0f b6 c0             	movzbl %al,%eax
}
  801e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5f                   	pop    %edi
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    

00801e17 <devpipe_write>:
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	57                   	push   %edi
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
  801e1d:	83 ec 28             	sub    $0x28,%esp
  801e20:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e23:	56                   	push   %esi
  801e24:	e8 fc f0 ff ff       	call   800f25 <fd2data>
  801e29:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801e33:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e36:	74 4f                	je     801e87 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e38:	8b 43 04             	mov    0x4(%ebx),%eax
  801e3b:	8b 0b                	mov    (%ebx),%ecx
  801e3d:	8d 51 20             	lea    0x20(%ecx),%edx
  801e40:	39 d0                	cmp    %edx,%eax
  801e42:	72 14                	jb     801e58 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e44:	89 da                	mov    %ebx,%edx
  801e46:	89 f0                	mov    %esi,%eax
  801e48:	e8 65 ff ff ff       	call   801db2 <_pipeisclosed>
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	75 3a                	jne    801e8b <devpipe_write+0x74>
			sys_yield();
  801e51:	e8 90 ee ff ff       	call   800ce6 <sys_yield>
  801e56:	eb e0                	jmp    801e38 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e5b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e5f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e62:	89 c2                	mov    %eax,%edx
  801e64:	c1 fa 1f             	sar    $0x1f,%edx
  801e67:	89 d1                	mov    %edx,%ecx
  801e69:	c1 e9 1b             	shr    $0x1b,%ecx
  801e6c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e6f:	83 e2 1f             	and    $0x1f,%edx
  801e72:	29 ca                	sub    %ecx,%edx
  801e74:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e78:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e7c:	83 c0 01             	add    $0x1,%eax
  801e7f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e82:	83 c7 01             	add    $0x1,%edi
  801e85:	eb ac                	jmp    801e33 <devpipe_write+0x1c>
	return i;
  801e87:	89 f8                	mov    %edi,%eax
  801e89:	eb 05                	jmp    801e90 <devpipe_write+0x79>
				return 0;
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e93:	5b                   	pop    %ebx
  801e94:	5e                   	pop    %esi
  801e95:	5f                   	pop    %edi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    

00801e98 <devpipe_read>:
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	57                   	push   %edi
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	83 ec 18             	sub    $0x18,%esp
  801ea1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ea4:	57                   	push   %edi
  801ea5:	e8 7b f0 ff ff       	call   800f25 <fd2data>
  801eaa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	be 00 00 00 00       	mov    $0x0,%esi
  801eb4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb7:	74 47                	je     801f00 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801eb9:	8b 03                	mov    (%ebx),%eax
  801ebb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ebe:	75 22                	jne    801ee2 <devpipe_read+0x4a>
			if (i > 0)
  801ec0:	85 f6                	test   %esi,%esi
  801ec2:	75 14                	jne    801ed8 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801ec4:	89 da                	mov    %ebx,%edx
  801ec6:	89 f8                	mov    %edi,%eax
  801ec8:	e8 e5 fe ff ff       	call   801db2 <_pipeisclosed>
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	75 33                	jne    801f04 <devpipe_read+0x6c>
			sys_yield();
  801ed1:	e8 10 ee ff ff       	call   800ce6 <sys_yield>
  801ed6:	eb e1                	jmp    801eb9 <devpipe_read+0x21>
				return i;
  801ed8:	89 f0                	mov    %esi,%eax
}
  801eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801edd:	5b                   	pop    %ebx
  801ede:	5e                   	pop    %esi
  801edf:	5f                   	pop    %edi
  801ee0:	5d                   	pop    %ebp
  801ee1:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ee2:	99                   	cltd   
  801ee3:	c1 ea 1b             	shr    $0x1b,%edx
  801ee6:	01 d0                	add    %edx,%eax
  801ee8:	83 e0 1f             	and    $0x1f,%eax
  801eeb:	29 d0                	sub    %edx,%eax
  801eed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ef8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801efb:	83 c6 01             	add    $0x1,%esi
  801efe:	eb b4                	jmp    801eb4 <devpipe_read+0x1c>
	return i;
  801f00:	89 f0                	mov    %esi,%eax
  801f02:	eb d6                	jmp    801eda <devpipe_read+0x42>
				return 0;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	eb cf                	jmp    801eda <devpipe_read+0x42>

00801f0b <pipe>:
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	56                   	push   %esi
  801f0f:	53                   	push   %ebx
  801f10:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f16:	50                   	push   %eax
  801f17:	e8 20 f0 ff ff       	call   800f3c <fd_alloc>
  801f1c:	89 c3                	mov    %eax,%ebx
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 5b                	js     801f80 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	68 07 04 00 00       	push   $0x407
  801f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f30:	6a 00                	push   $0x0
  801f32:	e8 ce ed ff ff       	call   800d05 <sys_page_alloc>
  801f37:	89 c3                	mov    %eax,%ebx
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 40                	js     801f80 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f46:	50                   	push   %eax
  801f47:	e8 f0 ef ff ff       	call   800f3c <fd_alloc>
  801f4c:	89 c3                	mov    %eax,%ebx
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	85 c0                	test   %eax,%eax
  801f53:	78 1b                	js     801f70 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	68 07 04 00 00       	push   $0x407
  801f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f60:	6a 00                	push   $0x0
  801f62:	e8 9e ed ff ff       	call   800d05 <sys_page_alloc>
  801f67:	89 c3                	mov    %eax,%ebx
  801f69:	83 c4 10             	add    $0x10,%esp
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	79 19                	jns    801f89 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801f70:	83 ec 08             	sub    $0x8,%esp
  801f73:	ff 75 f4             	pushl  -0xc(%ebp)
  801f76:	6a 00                	push   $0x0
  801f78:	e8 0d ee ff ff       	call   800d8a <sys_page_unmap>
  801f7d:	83 c4 10             	add    $0x10,%esp
}
  801f80:	89 d8                	mov    %ebx,%eax
  801f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    
	va = fd2data(fd0);
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8f:	e8 91 ef ff ff       	call   800f25 <fd2data>
  801f94:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f96:	83 c4 0c             	add    $0xc,%esp
  801f99:	68 07 04 00 00       	push   $0x407
  801f9e:	50                   	push   %eax
  801f9f:	6a 00                	push   $0x0
  801fa1:	e8 5f ed ff ff       	call   800d05 <sys_page_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	0f 88 8c 00 00 00    	js     80203f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb9:	e8 67 ef ff ff       	call   800f25 <fd2data>
  801fbe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fc5:	50                   	push   %eax
  801fc6:	6a 00                	push   $0x0
  801fc8:	56                   	push   %esi
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 78 ed ff ff       	call   800d48 <sys_page_map>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 20             	add    $0x20,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 58                	js     802031 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fe2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff1:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ff7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	ff 75 f4             	pushl  -0xc(%ebp)
  802009:	e8 07 ef ff ff       	call   800f15 <fd2num>
  80200e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802011:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802013:	83 c4 04             	add    $0x4,%esp
  802016:	ff 75 f0             	pushl  -0x10(%ebp)
  802019:	e8 f7 ee ff ff       	call   800f15 <fd2num>
  80201e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802021:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	bb 00 00 00 00       	mov    $0x0,%ebx
  80202c:	e9 4f ff ff ff       	jmp    801f80 <pipe+0x75>
	sys_page_unmap(0, va);
  802031:	83 ec 08             	sub    $0x8,%esp
  802034:	56                   	push   %esi
  802035:	6a 00                	push   $0x0
  802037:	e8 4e ed ff ff       	call   800d8a <sys_page_unmap>
  80203c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80203f:	83 ec 08             	sub    $0x8,%esp
  802042:	ff 75 f0             	pushl  -0x10(%ebp)
  802045:	6a 00                	push   $0x0
  802047:	e8 3e ed ff ff       	call   800d8a <sys_page_unmap>
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	e9 1c ff ff ff       	jmp    801f70 <pipe+0x65>

00802054 <pipeisclosed>:
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80205a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205d:	50                   	push   %eax
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	e8 25 ef ff ff       	call   800f8b <fd_lookup>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	78 18                	js     802085 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	ff 75 f4             	pushl  -0xc(%ebp)
  802073:	e8 ad ee ff ff       	call   800f25 <fd2data>
	return _pipeisclosed(fd, p);
  802078:	89 c2                	mov    %eax,%edx
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	e8 30 fd ff ff       	call   801db2 <_pipeisclosed>
  802082:	83 c4 10             	add    $0x10,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80208d:	68 cf 2f 80 00       	push   $0x802fcf
  802092:	ff 75 0c             	pushl  0xc(%ebp)
  802095:	e8 72 e8 ff ff       	call   80090c <strcpy>
	return 0;
}
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <devsock_close>:
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	53                   	push   %ebx
  8020a5:	83 ec 10             	sub    $0x10,%esp
  8020a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020ab:	53                   	push   %ebx
  8020ac:	e8 b3 06 00 00       	call   802764 <pageref>
  8020b1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020b4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020b9:	83 f8 01             	cmp    $0x1,%eax
  8020bc:	74 07                	je     8020c5 <devsock_close+0x24>
}
  8020be:	89 d0                	mov    %edx,%eax
  8020c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020c5:	83 ec 0c             	sub    $0xc,%esp
  8020c8:	ff 73 0c             	pushl  0xc(%ebx)
  8020cb:	e8 b7 02 00 00       	call   802387 <nsipc_close>
  8020d0:	89 c2                	mov    %eax,%edx
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	eb e7                	jmp    8020be <devsock_close+0x1d>

008020d7 <devsock_write>:
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020dd:	6a 00                	push   $0x0
  8020df:	ff 75 10             	pushl  0x10(%ebp)
  8020e2:	ff 75 0c             	pushl  0xc(%ebp)
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	ff 70 0c             	pushl  0xc(%eax)
  8020eb:	e8 74 03 00 00       	call   802464 <nsipc_send>
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <devsock_read>:
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	ff 75 10             	pushl  0x10(%ebp)
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	ff 70 0c             	pushl  0xc(%eax)
  802106:	e8 ed 02 00 00       	call   8023f8 <nsipc_recv>
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <fd2sockid>:
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802113:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802116:	52                   	push   %edx
  802117:	50                   	push   %eax
  802118:	e8 6e ee ff ff       	call   800f8b <fd_lookup>
  80211d:	83 c4 10             	add    $0x10,%esp
  802120:	85 c0                	test   %eax,%eax
  802122:	78 10                	js     802134 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  80212d:	39 08                	cmp    %ecx,(%eax)
  80212f:	75 05                	jne    802136 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802131:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    
		return -E_NOT_SUPP;
  802136:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80213b:	eb f7                	jmp    802134 <fd2sockid+0x27>

0080213d <alloc_sockfd>:
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	56                   	push   %esi
  802141:	53                   	push   %ebx
  802142:	83 ec 1c             	sub    $0x1c,%esp
  802145:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802147:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214a:	50                   	push   %eax
  80214b:	e8 ec ed ff ff       	call   800f3c <fd_alloc>
  802150:	89 c3                	mov    %eax,%ebx
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	85 c0                	test   %eax,%eax
  802157:	78 43                	js     80219c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802159:	83 ec 04             	sub    $0x4,%esp
  80215c:	68 07 04 00 00       	push   $0x407
  802161:	ff 75 f4             	pushl  -0xc(%ebp)
  802164:	6a 00                	push   $0x0
  802166:	e8 9a eb ff ff       	call   800d05 <sys_page_alloc>
  80216b:	89 c3                	mov    %eax,%ebx
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 28                	js     80219c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80217d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802189:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80218c:	83 ec 0c             	sub    $0xc,%esp
  80218f:	50                   	push   %eax
  802190:	e8 80 ed ff ff       	call   800f15 <fd2num>
  802195:	89 c3                	mov    %eax,%ebx
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	eb 0c                	jmp    8021a8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80219c:	83 ec 0c             	sub    $0xc,%esp
  80219f:	56                   	push   %esi
  8021a0:	e8 e2 01 00 00       	call   802387 <nsipc_close>
		return r;
  8021a5:	83 c4 10             	add    $0x10,%esp
}
  8021a8:	89 d8                	mov    %ebx,%eax
  8021aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ad:	5b                   	pop    %ebx
  8021ae:	5e                   	pop    %esi
  8021af:	5d                   	pop    %ebp
  8021b0:	c3                   	ret    

008021b1 <accept>:
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	e8 4e ff ff ff       	call   80210d <fd2sockid>
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	78 1b                	js     8021de <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	ff 75 10             	pushl  0x10(%ebp)
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	50                   	push   %eax
  8021cd:	e8 0e 01 00 00       	call   8022e0 <nsipc_accept>
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 05                	js     8021de <accept+0x2d>
	return alloc_sockfd(r);
  8021d9:	e8 5f ff ff ff       	call   80213d <alloc_sockfd>
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <bind>:
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	e8 1f ff ff ff       	call   80210d <fd2sockid>
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	78 12                	js     802204 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	ff 75 10             	pushl  0x10(%ebp)
  8021f8:	ff 75 0c             	pushl  0xc(%ebp)
  8021fb:	50                   	push   %eax
  8021fc:	e8 2f 01 00 00       	call   802330 <nsipc_bind>
  802201:	83 c4 10             	add    $0x10,%esp
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <shutdown>:
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	e8 f9 fe ff ff       	call   80210d <fd2sockid>
  802214:	85 c0                	test   %eax,%eax
  802216:	78 0f                	js     802227 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802218:	83 ec 08             	sub    $0x8,%esp
  80221b:	ff 75 0c             	pushl  0xc(%ebp)
  80221e:	50                   	push   %eax
  80221f:	e8 41 01 00 00       	call   802365 <nsipc_shutdown>
  802224:	83 c4 10             	add    $0x10,%esp
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <connect>:
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	e8 d6 fe ff ff       	call   80210d <fd2sockid>
  802237:	85 c0                	test   %eax,%eax
  802239:	78 12                	js     80224d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	ff 75 10             	pushl  0x10(%ebp)
  802241:	ff 75 0c             	pushl  0xc(%ebp)
  802244:	50                   	push   %eax
  802245:	e8 57 01 00 00       	call   8023a1 <nsipc_connect>
  80224a:	83 c4 10             	add    $0x10,%esp
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <listen>:
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	e8 b0 fe ff ff       	call   80210d <fd2sockid>
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 0f                	js     802270 <listen+0x21>
	return nsipc_listen(r, backlog);
  802261:	83 ec 08             	sub    $0x8,%esp
  802264:	ff 75 0c             	pushl  0xc(%ebp)
  802267:	50                   	push   %eax
  802268:	e8 69 01 00 00       	call   8023d6 <nsipc_listen>
  80226d:	83 c4 10             	add    $0x10,%esp
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <socket>:

int
socket(int domain, int type, int protocol)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802278:	ff 75 10             	pushl  0x10(%ebp)
  80227b:	ff 75 0c             	pushl  0xc(%ebp)
  80227e:	ff 75 08             	pushl  0x8(%ebp)
  802281:	e8 3c 02 00 00       	call   8024c2 <nsipc_socket>
  802286:	83 c4 10             	add    $0x10,%esp
  802289:	85 c0                	test   %eax,%eax
  80228b:	78 05                	js     802292 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80228d:	e8 ab fe ff ff       	call   80213d <alloc_sockfd>
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	53                   	push   %ebx
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80229d:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022a4:	74 26                	je     8022cc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022a6:	6a 07                	push   $0x7
  8022a8:	68 00 70 80 00       	push   $0x807000
  8022ad:	53                   	push   %ebx
  8022ae:	ff 35 04 50 80 00    	pushl  0x805004
  8022b4:	e8 19 04 00 00       	call   8026d2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022b9:	83 c4 0c             	add    $0xc,%esp
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	e8 a2 03 00 00       	call   802669 <ipc_recv>
}
  8022c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022cc:	83 ec 0c             	sub    $0xc,%esp
  8022cf:	6a 02                	push   $0x2
  8022d1:	e8 55 04 00 00       	call   80272b <ipc_find_env>
  8022d6:	a3 04 50 80 00       	mov    %eax,0x805004
  8022db:	83 c4 10             	add    $0x10,%esp
  8022de:	eb c6                	jmp    8022a6 <nsipc+0x12>

008022e0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	56                   	push   %esi
  8022e4:	53                   	push   %ebx
  8022e5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022f0:	8b 06                	mov    (%esi),%eax
  8022f2:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fc:	e8 93 ff ff ff       	call   802294 <nsipc>
  802301:	89 c3                	mov    %eax,%ebx
  802303:	85 c0                	test   %eax,%eax
  802305:	78 20                	js     802327 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802307:	83 ec 04             	sub    $0x4,%esp
  80230a:	ff 35 10 70 80 00    	pushl  0x807010
  802310:	68 00 70 80 00       	push   $0x807000
  802315:	ff 75 0c             	pushl  0xc(%ebp)
  802318:	e8 7d e7 ff ff       	call   800a9a <memmove>
		*addrlen = ret->ret_addrlen;
  80231d:	a1 10 70 80 00       	mov    0x807010,%eax
  802322:	89 06                	mov    %eax,(%esi)
  802324:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802327:	89 d8                	mov    %ebx,%eax
  802329:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5d                   	pop    %ebp
  80232f:	c3                   	ret    

00802330 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	53                   	push   %ebx
  802334:	83 ec 08             	sub    $0x8,%esp
  802337:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802342:	53                   	push   %ebx
  802343:	ff 75 0c             	pushl  0xc(%ebp)
  802346:	68 04 70 80 00       	push   $0x807004
  80234b:	e8 4a e7 ff ff       	call   800a9a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802350:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802356:	b8 02 00 00 00       	mov    $0x2,%eax
  80235b:	e8 34 ff ff ff       	call   802294 <nsipc>
}
  802360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802373:	8b 45 0c             	mov    0xc(%ebp),%eax
  802376:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80237b:	b8 03 00 00 00       	mov    $0x3,%eax
  802380:	e8 0f ff ff ff       	call   802294 <nsipc>
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <nsipc_close>:

int
nsipc_close(int s)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802395:	b8 04 00 00 00       	mov    $0x4,%eax
  80239a:	e8 f5 fe ff ff       	call   802294 <nsipc>
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	53                   	push   %ebx
  8023a5:	83 ec 08             	sub    $0x8,%esp
  8023a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023b3:	53                   	push   %ebx
  8023b4:	ff 75 0c             	pushl  0xc(%ebp)
  8023b7:	68 04 70 80 00       	push   $0x807004
  8023bc:	e8 d9 e6 ff ff       	call   800a9a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023c1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8023cc:	e8 c3 fe ff ff       	call   802294 <nsipc>
}
  8023d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023ec:	b8 06 00 00 00       	mov    $0x6,%eax
  8023f1:	e8 9e fe ff ff       	call   802294 <nsipc>
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802408:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80240e:	8b 45 14             	mov    0x14(%ebp),%eax
  802411:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802416:	b8 07 00 00 00       	mov    $0x7,%eax
  80241b:	e8 74 fe ff ff       	call   802294 <nsipc>
  802420:	89 c3                	mov    %eax,%ebx
  802422:	85 c0                	test   %eax,%eax
  802424:	78 1f                	js     802445 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802426:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80242b:	7f 21                	jg     80244e <nsipc_recv+0x56>
  80242d:	39 c6                	cmp    %eax,%esi
  80242f:	7c 1d                	jl     80244e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	50                   	push   %eax
  802435:	68 00 70 80 00       	push   $0x807000
  80243a:	ff 75 0c             	pushl  0xc(%ebp)
  80243d:	e8 58 e6 ff ff       	call   800a9a <memmove>
  802442:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802445:	89 d8                	mov    %ebx,%eax
  802447:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244a:	5b                   	pop    %ebx
  80244b:	5e                   	pop    %esi
  80244c:	5d                   	pop    %ebp
  80244d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80244e:	68 db 2f 80 00       	push   $0x802fdb
  802453:	68 c9 2e 80 00       	push   $0x802ec9
  802458:	6a 62                	push   $0x62
  80245a:	68 f0 2f 80 00       	push   $0x802ff0
  80245f:	e8 30 dd ff ff       	call   800194 <_panic>

00802464 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	53                   	push   %ebx
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802476:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80247c:	7f 2e                	jg     8024ac <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	53                   	push   %ebx
  802482:	ff 75 0c             	pushl  0xc(%ebp)
  802485:	68 0c 70 80 00       	push   $0x80700c
  80248a:	e8 0b e6 ff ff       	call   800a9a <memmove>
	nsipcbuf.send.req_size = size;
  80248f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802495:	8b 45 14             	mov    0x14(%ebp),%eax
  802498:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80249d:	b8 08 00 00 00       	mov    $0x8,%eax
  8024a2:	e8 ed fd ff ff       	call   802294 <nsipc>
}
  8024a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    
	assert(size < 1600);
  8024ac:	68 fc 2f 80 00       	push   $0x802ffc
  8024b1:	68 c9 2e 80 00       	push   $0x802ec9
  8024b6:	6a 6d                	push   $0x6d
  8024b8:	68 f0 2f 80 00       	push   $0x802ff0
  8024bd:	e8 d2 dc ff ff       	call   800194 <_panic>

008024c2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d3:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024db:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024e0:	b8 09 00 00 00       	mov    $0x9,%eax
  8024e5:	e8 aa fd ff ff       	call   802294 <nsipc>
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    

008024f6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024fc:	68 08 30 80 00       	push   $0x803008
  802501:	ff 75 0c             	pushl  0xc(%ebp)
  802504:	e8 03 e4 ff ff       	call   80090c <strcpy>
	return 0;
}
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <devcons_write>:
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	57                   	push   %edi
  802514:	56                   	push   %esi
  802515:	53                   	push   %ebx
  802516:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80251c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802521:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802527:	eb 2f                	jmp    802558 <devcons_write+0x48>
		m = n - tot;
  802529:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80252c:	29 f3                	sub    %esi,%ebx
  80252e:	83 fb 7f             	cmp    $0x7f,%ebx
  802531:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802536:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802539:	83 ec 04             	sub    $0x4,%esp
  80253c:	53                   	push   %ebx
  80253d:	89 f0                	mov    %esi,%eax
  80253f:	03 45 0c             	add    0xc(%ebp),%eax
  802542:	50                   	push   %eax
  802543:	57                   	push   %edi
  802544:	e8 51 e5 ff ff       	call   800a9a <memmove>
		sys_cputs(buf, m);
  802549:	83 c4 08             	add    $0x8,%esp
  80254c:	53                   	push   %ebx
  80254d:	57                   	push   %edi
  80254e:	e8 f6 e6 ff ff       	call   800c49 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802553:	01 de                	add    %ebx,%esi
  802555:	83 c4 10             	add    $0x10,%esp
  802558:	3b 75 10             	cmp    0x10(%ebp),%esi
  80255b:	72 cc                	jb     802529 <devcons_write+0x19>
}
  80255d:	89 f0                	mov    %esi,%eax
  80255f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802562:	5b                   	pop    %ebx
  802563:	5e                   	pop    %esi
  802564:	5f                   	pop    %edi
  802565:	5d                   	pop    %ebp
  802566:	c3                   	ret    

00802567 <devcons_read>:
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 08             	sub    $0x8,%esp
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802572:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802576:	75 07                	jne    80257f <devcons_read+0x18>
}
  802578:	c9                   	leave  
  802579:	c3                   	ret    
		sys_yield();
  80257a:	e8 67 e7 ff ff       	call   800ce6 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80257f:	e8 e3 e6 ff ff       	call   800c67 <sys_cgetc>
  802584:	85 c0                	test   %eax,%eax
  802586:	74 f2                	je     80257a <devcons_read+0x13>
	if (c < 0)
  802588:	85 c0                	test   %eax,%eax
  80258a:	78 ec                	js     802578 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80258c:	83 f8 04             	cmp    $0x4,%eax
  80258f:	74 0c                	je     80259d <devcons_read+0x36>
	*(char*)vbuf = c;
  802591:	8b 55 0c             	mov    0xc(%ebp),%edx
  802594:	88 02                	mov    %al,(%edx)
	return 1;
  802596:	b8 01 00 00 00       	mov    $0x1,%eax
  80259b:	eb db                	jmp    802578 <devcons_read+0x11>
		return 0;
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	eb d4                	jmp    802578 <devcons_read+0x11>

008025a4 <cputchar>:
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025b0:	6a 01                	push   $0x1
  8025b2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b5:	50                   	push   %eax
  8025b6:	e8 8e e6 ff ff       	call   800c49 <sys_cputs>
}
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <getchar>:
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025c6:	6a 01                	push   $0x1
  8025c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025cb:	50                   	push   %eax
  8025cc:	6a 00                	push   $0x0
  8025ce:	e8 29 ec ff ff       	call   8011fc <read>
	if (r < 0)
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	78 08                	js     8025e2 <getchar+0x22>
	if (r < 1)
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	7e 06                	jle    8025e4 <getchar+0x24>
	return c;
  8025de:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    
		return -E_EOF;
  8025e4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025e9:	eb f7                	jmp    8025e2 <getchar+0x22>

008025eb <iscons>:
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f4:	50                   	push   %eax
  8025f5:	ff 75 08             	pushl  0x8(%ebp)
  8025f8:	e8 8e e9 ff ff       	call   800f8b <fd_lookup>
  8025fd:	83 c4 10             	add    $0x10,%esp
  802600:	85 c0                	test   %eax,%eax
  802602:	78 11                	js     802615 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80260d:	39 10                	cmp    %edx,(%eax)
  80260f:	0f 94 c0             	sete   %al
  802612:	0f b6 c0             	movzbl %al,%eax
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <opencons>:
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80261d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802620:	50                   	push   %eax
  802621:	e8 16 e9 ff ff       	call   800f3c <fd_alloc>
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	85 c0                	test   %eax,%eax
  80262b:	78 3a                	js     802667 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	68 07 04 00 00       	push   $0x407
  802635:	ff 75 f4             	pushl  -0xc(%ebp)
  802638:	6a 00                	push   $0x0
  80263a:	e8 c6 e6 ff ff       	call   800d05 <sys_page_alloc>
  80263f:	83 c4 10             	add    $0x10,%esp
  802642:	85 c0                	test   %eax,%eax
  802644:	78 21                	js     802667 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80264f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80265b:	83 ec 0c             	sub    $0xc,%esp
  80265e:	50                   	push   %eax
  80265f:	e8 b1 e8 ff ff       	call   800f15 <fd2num>
  802664:	83 c4 10             	add    $0x10,%esp
}
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	56                   	push   %esi
  80266d:	53                   	push   %ebx
  80266e:	8b 75 08             	mov    0x8(%ebp),%esi
  802671:	8b 45 0c             	mov    0xc(%ebp),%eax
  802674:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802677:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802679:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80267e:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802681:	83 ec 0c             	sub    $0xc,%esp
  802684:	50                   	push   %eax
  802685:	e8 2b e8 ff ff       	call   800eb5 <sys_ipc_recv>
  80268a:	83 c4 10             	add    $0x10,%esp
  80268d:	85 c0                	test   %eax,%eax
  80268f:	78 2b                	js     8026bc <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802691:	85 f6                	test   %esi,%esi
  802693:	74 0a                	je     80269f <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802695:	a1 08 50 80 00       	mov    0x805008,%eax
  80269a:	8b 40 74             	mov    0x74(%eax),%eax
  80269d:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80269f:	85 db                	test   %ebx,%ebx
  8026a1:	74 0a                	je     8026ad <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8026a3:	a1 08 50 80 00       	mov    0x805008,%eax
  8026a8:	8b 40 78             	mov    0x78(%eax),%eax
  8026ab:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8026ad:	a1 08 50 80 00       	mov    0x805008,%eax
  8026b2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8026b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026b8:	5b                   	pop    %ebx
  8026b9:	5e                   	pop    %esi
  8026ba:	5d                   	pop    %ebp
  8026bb:	c3                   	ret    
	    if (from_env_store != NULL) {
  8026bc:	85 f6                	test   %esi,%esi
  8026be:	74 06                	je     8026c6 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8026c0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8026c6:	85 db                	test   %ebx,%ebx
  8026c8:	74 eb                	je     8026b5 <ipc_recv+0x4c>
	        *perm_store = 0;
  8026ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026d0:	eb e3                	jmp    8026b5 <ipc_recv+0x4c>

008026d2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	57                   	push   %edi
  8026d6:	56                   	push   %esi
  8026d7:	53                   	push   %ebx
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026de:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8026e1:	85 f6                	test   %esi,%esi
  8026e3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026e8:	0f 44 f0             	cmove  %eax,%esi
  8026eb:	eb 09                	jmp    8026f6 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8026ed:	e8 f4 e5 ff ff       	call   800ce6 <sys_yield>
	} while(r != 0);
  8026f2:	85 db                	test   %ebx,%ebx
  8026f4:	74 2d                	je     802723 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8026f6:	ff 75 14             	pushl  0x14(%ebp)
  8026f9:	56                   	push   %esi
  8026fa:	ff 75 0c             	pushl  0xc(%ebp)
  8026fd:	57                   	push   %edi
  8026fe:	e8 8f e7 ff ff       	call   800e92 <sys_ipc_try_send>
  802703:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802705:	83 c4 10             	add    $0x10,%esp
  802708:	85 c0                	test   %eax,%eax
  80270a:	79 e1                	jns    8026ed <ipc_send+0x1b>
  80270c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80270f:	74 dc                	je     8026ed <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802711:	50                   	push   %eax
  802712:	68 14 30 80 00       	push   $0x803014
  802717:	6a 45                	push   $0x45
  802719:	68 21 30 80 00       	push   $0x803021
  80271e:	e8 71 da ff ff       	call   800194 <_panic>
}
  802723:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802726:	5b                   	pop    %ebx
  802727:	5e                   	pop    %esi
  802728:	5f                   	pop    %edi
  802729:	5d                   	pop    %ebp
  80272a:	c3                   	ret    

0080272b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
  80272e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802736:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802739:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80273f:	8b 52 50             	mov    0x50(%edx),%edx
  802742:	39 ca                	cmp    %ecx,%edx
  802744:	74 11                	je     802757 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802746:	83 c0 01             	add    $0x1,%eax
  802749:	3d 00 04 00 00       	cmp    $0x400,%eax
  80274e:	75 e6                	jne    802736 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802750:	b8 00 00 00 00       	mov    $0x0,%eax
  802755:	eb 0b                	jmp    802762 <ipc_find_env+0x37>
			return envs[i].env_id;
  802757:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80275a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80275f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802762:	5d                   	pop    %ebp
  802763:	c3                   	ret    

00802764 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
  802767:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80276a:	89 d0                	mov    %edx,%eax
  80276c:	c1 e8 16             	shr    $0x16,%eax
  80276f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802776:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80277b:	f6 c1 01             	test   $0x1,%cl
  80277e:	74 1d                	je     80279d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802780:	c1 ea 0c             	shr    $0xc,%edx
  802783:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80278a:	f6 c2 01             	test   $0x1,%dl
  80278d:	74 0e                	je     80279d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80278f:	c1 ea 0c             	shr    $0xc,%edx
  802792:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802799:	ef 
  80279a:	0f b7 c0             	movzwl %ax,%eax
}
  80279d:	5d                   	pop    %ebp
  80279e:	c3                   	ret    
  80279f:	90                   	nop

008027a0 <__udivdi3>:
  8027a0:	55                   	push   %ebp
  8027a1:	57                   	push   %edi
  8027a2:	56                   	push   %esi
  8027a3:	53                   	push   %ebx
  8027a4:	83 ec 1c             	sub    $0x1c,%esp
  8027a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027b7:	85 d2                	test   %edx,%edx
  8027b9:	75 35                	jne    8027f0 <__udivdi3+0x50>
  8027bb:	39 f3                	cmp    %esi,%ebx
  8027bd:	0f 87 bd 00 00 00    	ja     802880 <__udivdi3+0xe0>
  8027c3:	85 db                	test   %ebx,%ebx
  8027c5:	89 d9                	mov    %ebx,%ecx
  8027c7:	75 0b                	jne    8027d4 <__udivdi3+0x34>
  8027c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ce:	31 d2                	xor    %edx,%edx
  8027d0:	f7 f3                	div    %ebx
  8027d2:	89 c1                	mov    %eax,%ecx
  8027d4:	31 d2                	xor    %edx,%edx
  8027d6:	89 f0                	mov    %esi,%eax
  8027d8:	f7 f1                	div    %ecx
  8027da:	89 c6                	mov    %eax,%esi
  8027dc:	89 e8                	mov    %ebp,%eax
  8027de:	89 f7                	mov    %esi,%edi
  8027e0:	f7 f1                	div    %ecx
  8027e2:	89 fa                	mov    %edi,%edx
  8027e4:	83 c4 1c             	add    $0x1c,%esp
  8027e7:	5b                   	pop    %ebx
  8027e8:	5e                   	pop    %esi
  8027e9:	5f                   	pop    %edi
  8027ea:	5d                   	pop    %ebp
  8027eb:	c3                   	ret    
  8027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027f0:	39 f2                	cmp    %esi,%edx
  8027f2:	77 7c                	ja     802870 <__udivdi3+0xd0>
  8027f4:	0f bd fa             	bsr    %edx,%edi
  8027f7:	83 f7 1f             	xor    $0x1f,%edi
  8027fa:	0f 84 98 00 00 00    	je     802898 <__udivdi3+0xf8>
  802800:	89 f9                	mov    %edi,%ecx
  802802:	b8 20 00 00 00       	mov    $0x20,%eax
  802807:	29 f8                	sub    %edi,%eax
  802809:	d3 e2                	shl    %cl,%edx
  80280b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80280f:	89 c1                	mov    %eax,%ecx
  802811:	89 da                	mov    %ebx,%edx
  802813:	d3 ea                	shr    %cl,%edx
  802815:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802819:	09 d1                	or     %edx,%ecx
  80281b:	89 f2                	mov    %esi,%edx
  80281d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802821:	89 f9                	mov    %edi,%ecx
  802823:	d3 e3                	shl    %cl,%ebx
  802825:	89 c1                	mov    %eax,%ecx
  802827:	d3 ea                	shr    %cl,%edx
  802829:	89 f9                	mov    %edi,%ecx
  80282b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80282f:	d3 e6                	shl    %cl,%esi
  802831:	89 eb                	mov    %ebp,%ebx
  802833:	89 c1                	mov    %eax,%ecx
  802835:	d3 eb                	shr    %cl,%ebx
  802837:	09 de                	or     %ebx,%esi
  802839:	89 f0                	mov    %esi,%eax
  80283b:	f7 74 24 08          	divl   0x8(%esp)
  80283f:	89 d6                	mov    %edx,%esi
  802841:	89 c3                	mov    %eax,%ebx
  802843:	f7 64 24 0c          	mull   0xc(%esp)
  802847:	39 d6                	cmp    %edx,%esi
  802849:	72 0c                	jb     802857 <__udivdi3+0xb7>
  80284b:	89 f9                	mov    %edi,%ecx
  80284d:	d3 e5                	shl    %cl,%ebp
  80284f:	39 c5                	cmp    %eax,%ebp
  802851:	73 5d                	jae    8028b0 <__udivdi3+0x110>
  802853:	39 d6                	cmp    %edx,%esi
  802855:	75 59                	jne    8028b0 <__udivdi3+0x110>
  802857:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80285a:	31 ff                	xor    %edi,%edi
  80285c:	89 fa                	mov    %edi,%edx
  80285e:	83 c4 1c             	add    $0x1c,%esp
  802861:	5b                   	pop    %ebx
  802862:	5e                   	pop    %esi
  802863:	5f                   	pop    %edi
  802864:	5d                   	pop    %ebp
  802865:	c3                   	ret    
  802866:	8d 76 00             	lea    0x0(%esi),%esi
  802869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802870:	31 ff                	xor    %edi,%edi
  802872:	31 c0                	xor    %eax,%eax
  802874:	89 fa                	mov    %edi,%edx
  802876:	83 c4 1c             	add    $0x1c,%esp
  802879:	5b                   	pop    %ebx
  80287a:	5e                   	pop    %esi
  80287b:	5f                   	pop    %edi
  80287c:	5d                   	pop    %ebp
  80287d:	c3                   	ret    
  80287e:	66 90                	xchg   %ax,%ax
  802880:	31 ff                	xor    %edi,%edi
  802882:	89 e8                	mov    %ebp,%eax
  802884:	89 f2                	mov    %esi,%edx
  802886:	f7 f3                	div    %ebx
  802888:	89 fa                	mov    %edi,%edx
  80288a:	83 c4 1c             	add    $0x1c,%esp
  80288d:	5b                   	pop    %ebx
  80288e:	5e                   	pop    %esi
  80288f:	5f                   	pop    %edi
  802890:	5d                   	pop    %ebp
  802891:	c3                   	ret    
  802892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802898:	39 f2                	cmp    %esi,%edx
  80289a:	72 06                	jb     8028a2 <__udivdi3+0x102>
  80289c:	31 c0                	xor    %eax,%eax
  80289e:	39 eb                	cmp    %ebp,%ebx
  8028a0:	77 d2                	ja     802874 <__udivdi3+0xd4>
  8028a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a7:	eb cb                	jmp    802874 <__udivdi3+0xd4>
  8028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028b0:	89 d8                	mov    %ebx,%eax
  8028b2:	31 ff                	xor    %edi,%edi
  8028b4:	eb be                	jmp    802874 <__udivdi3+0xd4>
  8028b6:	66 90                	xchg   %ax,%ax
  8028b8:	66 90                	xchg   %ax,%ax
  8028ba:	66 90                	xchg   %ax,%ax
  8028bc:	66 90                	xchg   %ax,%ax
  8028be:	66 90                	xchg   %ax,%ax

008028c0 <__umoddi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	57                   	push   %edi
  8028c2:	56                   	push   %esi
  8028c3:	53                   	push   %ebx
  8028c4:	83 ec 1c             	sub    $0x1c,%esp
  8028c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8028cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028d7:	85 ed                	test   %ebp,%ebp
  8028d9:	89 f0                	mov    %esi,%eax
  8028db:	89 da                	mov    %ebx,%edx
  8028dd:	75 19                	jne    8028f8 <__umoddi3+0x38>
  8028df:	39 df                	cmp    %ebx,%edi
  8028e1:	0f 86 b1 00 00 00    	jbe    802998 <__umoddi3+0xd8>
  8028e7:	f7 f7                	div    %edi
  8028e9:	89 d0                	mov    %edx,%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	83 c4 1c             	add    $0x1c,%esp
  8028f0:	5b                   	pop    %ebx
  8028f1:	5e                   	pop    %esi
  8028f2:	5f                   	pop    %edi
  8028f3:	5d                   	pop    %ebp
  8028f4:	c3                   	ret    
  8028f5:	8d 76 00             	lea    0x0(%esi),%esi
  8028f8:	39 dd                	cmp    %ebx,%ebp
  8028fa:	77 f1                	ja     8028ed <__umoddi3+0x2d>
  8028fc:	0f bd cd             	bsr    %ebp,%ecx
  8028ff:	83 f1 1f             	xor    $0x1f,%ecx
  802902:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802906:	0f 84 b4 00 00 00    	je     8029c0 <__umoddi3+0x100>
  80290c:	b8 20 00 00 00       	mov    $0x20,%eax
  802911:	89 c2                	mov    %eax,%edx
  802913:	8b 44 24 04          	mov    0x4(%esp),%eax
  802917:	29 c2                	sub    %eax,%edx
  802919:	89 c1                	mov    %eax,%ecx
  80291b:	89 f8                	mov    %edi,%eax
  80291d:	d3 e5                	shl    %cl,%ebp
  80291f:	89 d1                	mov    %edx,%ecx
  802921:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802925:	d3 e8                	shr    %cl,%eax
  802927:	09 c5                	or     %eax,%ebp
  802929:	8b 44 24 04          	mov    0x4(%esp),%eax
  80292d:	89 c1                	mov    %eax,%ecx
  80292f:	d3 e7                	shl    %cl,%edi
  802931:	89 d1                	mov    %edx,%ecx
  802933:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802937:	89 df                	mov    %ebx,%edi
  802939:	d3 ef                	shr    %cl,%edi
  80293b:	89 c1                	mov    %eax,%ecx
  80293d:	89 f0                	mov    %esi,%eax
  80293f:	d3 e3                	shl    %cl,%ebx
  802941:	89 d1                	mov    %edx,%ecx
  802943:	89 fa                	mov    %edi,%edx
  802945:	d3 e8                	shr    %cl,%eax
  802947:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80294c:	09 d8                	or     %ebx,%eax
  80294e:	f7 f5                	div    %ebp
  802950:	d3 e6                	shl    %cl,%esi
  802952:	89 d1                	mov    %edx,%ecx
  802954:	f7 64 24 08          	mull   0x8(%esp)
  802958:	39 d1                	cmp    %edx,%ecx
  80295a:	89 c3                	mov    %eax,%ebx
  80295c:	89 d7                	mov    %edx,%edi
  80295e:	72 06                	jb     802966 <__umoddi3+0xa6>
  802960:	75 0e                	jne    802970 <__umoddi3+0xb0>
  802962:	39 c6                	cmp    %eax,%esi
  802964:	73 0a                	jae    802970 <__umoddi3+0xb0>
  802966:	2b 44 24 08          	sub    0x8(%esp),%eax
  80296a:	19 ea                	sbb    %ebp,%edx
  80296c:	89 d7                	mov    %edx,%edi
  80296e:	89 c3                	mov    %eax,%ebx
  802970:	89 ca                	mov    %ecx,%edx
  802972:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802977:	29 de                	sub    %ebx,%esi
  802979:	19 fa                	sbb    %edi,%edx
  80297b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80297f:	89 d0                	mov    %edx,%eax
  802981:	d3 e0                	shl    %cl,%eax
  802983:	89 d9                	mov    %ebx,%ecx
  802985:	d3 ee                	shr    %cl,%esi
  802987:	d3 ea                	shr    %cl,%edx
  802989:	09 f0                	or     %esi,%eax
  80298b:	83 c4 1c             	add    $0x1c,%esp
  80298e:	5b                   	pop    %ebx
  80298f:	5e                   	pop    %esi
  802990:	5f                   	pop    %edi
  802991:	5d                   	pop    %ebp
  802992:	c3                   	ret    
  802993:	90                   	nop
  802994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802998:	85 ff                	test   %edi,%edi
  80299a:	89 f9                	mov    %edi,%ecx
  80299c:	75 0b                	jne    8029a9 <__umoddi3+0xe9>
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	31 d2                	xor    %edx,%edx
  8029a5:	f7 f7                	div    %edi
  8029a7:	89 c1                	mov    %eax,%ecx
  8029a9:	89 d8                	mov    %ebx,%eax
  8029ab:	31 d2                	xor    %edx,%edx
  8029ad:	f7 f1                	div    %ecx
  8029af:	89 f0                	mov    %esi,%eax
  8029b1:	f7 f1                	div    %ecx
  8029b3:	e9 31 ff ff ff       	jmp    8028e9 <__umoddi3+0x29>
  8029b8:	90                   	nop
  8029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029c0:	39 dd                	cmp    %ebx,%ebp
  8029c2:	72 08                	jb     8029cc <__umoddi3+0x10c>
  8029c4:	39 f7                	cmp    %esi,%edi
  8029c6:	0f 87 21 ff ff ff    	ja     8028ed <__umoddi3+0x2d>
  8029cc:	89 da                	mov    %ebx,%edx
  8029ce:	89 f0                	mov    %esi,%eax
  8029d0:	29 f8                	sub    %edi,%eax
  8029d2:	19 ea                	sbb    %ebp,%edx
  8029d4:	e9 14 ff ff ff       	jmp    8028ed <__umoddi3+0x2d>
