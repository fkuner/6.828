
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  80003a:	e8 77 0e 00 00       	call   800eb6 <sys_time_msec>
	unsigned end = now + sec * 1000;
  80003f:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800046:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800048:	85 c0                	test   %eax,%eax
  80004a:	79 05                	jns    800051 <sleep+0x1e>
  80004c:	83 f8 f1             	cmp    $0xfffffff1,%eax
  80004f:	7d 18                	jge    800069 <sleep+0x36>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800051:	39 d8                	cmp    %ebx,%eax
  800053:	76 2b                	jbe    800080 <sleep+0x4d>
		panic("sleep: wrap");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 e2 23 80 00       	push   $0x8023e2
  80005d:	6a 0d                	push   $0xd
  80005f:	68 d2 23 80 00       	push   $0x8023d2
  800064:	e8 eb 00 00 00       	call   800154 <_panic>
		panic("sys_time_msec: %e", (int)now);
  800069:	50                   	push   %eax
  80006a:	68 c0 23 80 00       	push   $0x8023c0
  80006f:	6a 0b                	push   $0xb
  800071:	68 d2 23 80 00       	push   $0x8023d2
  800076:	e8 d9 00 00 00       	call   800154 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  80007b:	e8 26 0c 00 00       	call   800ca6 <sys_yield>
	while (sys_time_msec() < end)
  800080:	e8 31 0e 00 00       	call   800eb6 <sys_time_msec>
  800085:	39 d8                	cmp    %ebx,%eax
  800087:	72 f2                	jb     80007b <sleep+0x48>
}
  800089:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008c:	c9                   	leave  
  80008d:	c3                   	ret    

0080008e <umain>:

void
umain(int argc, char **argv)
{
  80008e:	55                   	push   %ebp
  80008f:	89 e5                	mov    %esp,%ebp
  800091:	53                   	push   %ebx
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  80009a:	e8 07 0c 00 00       	call   800ca6 <sys_yield>
	for (i = 0; i < 50; i++)
  80009f:	83 eb 01             	sub    $0x1,%ebx
  8000a2:	75 f6                	jne    80009a <umain+0xc>

	cprintf("starting count down: ");
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	68 ee 23 80 00       	push   $0x8023ee
  8000ac:	e8 7e 01 00 00       	call   80022f <cprintf>
  8000b1:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b4:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	53                   	push   %ebx
  8000bd:	68 04 24 80 00       	push   $0x802404
  8000c2:	e8 68 01 00 00       	call   80022f <cprintf>
		sleep(1);
  8000c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ce:	e8 60 ff ff ff       	call   800033 <sleep>
	for (i = 5; i >= 0; i--) {
  8000d3:	83 eb 01             	sub    $0x1,%ebx
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000dc:	75 db                	jne    8000b9 <umain+0x2b>
	}
	cprintf("\n");
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	68 77 28 80 00       	push   $0x802877
  8000e6:	e8 44 01 00 00       	call   80022f <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8000eb:	cc                   	int3   
	breakpoint();
}
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000ff:	e8 83 0b 00 00       	call   800c87 <sys_getenvid>
  800104:	25 ff 03 00 00       	and    $0x3ff,%eax
  800109:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800111:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800116:	85 db                	test   %ebx,%ebx
  800118:	7e 07                	jle    800121 <libmain+0x2d>
		binaryname = argv[0];
  80011a:	8b 06                	mov    (%esi),%eax
  80011c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800121:	83 ec 08             	sub    $0x8,%esp
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
  800126:	e8 63 ff ff ff       	call   80008e <umain>

	// exit gracefully
	exit();
  80012b:	e8 0a 00 00 00       	call   80013a <exit>
}
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5d                   	pop    %ebp
  800139:	c3                   	ret    

0080013a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800140:	e8 66 0f 00 00       	call   8010ab <close_all>
	sys_env_destroy(0);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	6a 00                	push   $0x0
  80014a:	e8 f7 0a 00 00       	call   800c46 <sys_env_destroy>
}
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	56                   	push   %esi
  800158:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800159:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800162:	e8 20 0b 00 00       	call   800c87 <sys_getenvid>
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	ff 75 0c             	pushl  0xc(%ebp)
  80016d:	ff 75 08             	pushl  0x8(%ebp)
  800170:	56                   	push   %esi
  800171:	50                   	push   %eax
  800172:	68 14 24 80 00       	push   $0x802414
  800177:	e8 b3 00 00 00       	call   80022f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017c:	83 c4 18             	add    $0x18,%esp
  80017f:	53                   	push   %ebx
  800180:	ff 75 10             	pushl  0x10(%ebp)
  800183:	e8 56 00 00 00       	call   8001de <vcprintf>
	cprintf("\n");
  800188:	c7 04 24 77 28 80 00 	movl   $0x802877,(%esp)
  80018f:	e8 9b 00 00 00       	call   80022f <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800197:	cc                   	int3   
  800198:	eb fd                	jmp    800197 <_panic+0x43>

0080019a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	53                   	push   %ebx
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a4:	8b 13                	mov    (%ebx),%edx
  8001a6:	8d 42 01             	lea    0x1(%edx),%eax
  8001a9:	89 03                	mov    %eax,(%ebx)
  8001ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b7:	74 09                	je     8001c2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 ff 00 00 00       	push   $0xff
  8001ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cd:	50                   	push   %eax
  8001ce:	e8 36 0a 00 00       	call   800c09 <sys_cputs>
		b->idx = 0;
  8001d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d9:	83 c4 10             	add    $0x10,%esp
  8001dc:	eb db                	jmp    8001b9 <putch+0x1f>

008001de <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ee:	00 00 00 
	b.cnt = 0;
  8001f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fb:	ff 75 0c             	pushl  0xc(%ebp)
  8001fe:	ff 75 08             	pushl  0x8(%ebp)
  800201:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800207:	50                   	push   %eax
  800208:	68 9a 01 80 00       	push   $0x80019a
  80020d:	e8 1a 01 00 00       	call   80032c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800212:	83 c4 08             	add    $0x8,%esp
  800215:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	e8 e2 09 00 00       	call   800c09 <sys_cputs>

	return b.cnt;
}
  800227:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800235:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800238:	50                   	push   %eax
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	e8 9d ff ff ff       	call   8001de <vcprintf>
	va_end(ap);

	return cnt;
}
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	57                   	push   %edi
  800247:	56                   	push   %esi
  800248:	53                   	push   %ebx
  800249:	83 ec 1c             	sub    $0x1c,%esp
  80024c:	89 c7                	mov    %eax,%edi
  80024e:	89 d6                	mov    %edx,%esi
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	8b 55 0c             	mov    0xc(%ebp),%edx
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800259:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80025f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800264:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800267:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80026a:	39 d3                	cmp    %edx,%ebx
  80026c:	72 05                	jb     800273 <printnum+0x30>
  80026e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800271:	77 7a                	ja     8002ed <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	8b 45 14             	mov    0x14(%ebp),%eax
  80027c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80027f:	53                   	push   %ebx
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	ff 75 e0             	pushl  -0x20(%ebp)
  80028c:	ff 75 dc             	pushl  -0x24(%ebp)
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 d9 1e 00 00       	call   802170 <__udivdi3>
  800297:	83 c4 18             	add    $0x18,%esp
  80029a:	52                   	push   %edx
  80029b:	50                   	push   %eax
  80029c:	89 f2                	mov    %esi,%edx
  80029e:	89 f8                	mov    %edi,%eax
  8002a0:	e8 9e ff ff ff       	call   800243 <printnum>
  8002a5:	83 c4 20             	add    $0x20,%esp
  8002a8:	eb 13                	jmp    8002bd <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	56                   	push   %esi
  8002ae:	ff 75 18             	pushl  0x18(%ebp)
  8002b1:	ff d7                	call   *%edi
  8002b3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b6:	83 eb 01             	sub    $0x1,%ebx
  8002b9:	85 db                	test   %ebx,%ebx
  8002bb:	7f ed                	jg     8002aa <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	56                   	push   %esi
  8002c1:	83 ec 04             	sub    $0x4,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d0:	e8 bb 1f 00 00       	call   802290 <__umoddi3>
  8002d5:	83 c4 14             	add    $0x14,%esp
  8002d8:	0f be 80 37 24 80 00 	movsbl 0x802437(%eax),%eax
  8002df:	50                   	push   %eax
  8002e0:	ff d7                	call   *%edi
}
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e8:	5b                   	pop    %ebx
  8002e9:	5e                   	pop    %esi
  8002ea:	5f                   	pop    %edi
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    
  8002ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002f0:	eb c4                	jmp    8002b6 <printnum+0x73>

008002f2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fc:	8b 10                	mov    (%eax),%edx
  8002fe:	3b 50 04             	cmp    0x4(%eax),%edx
  800301:	73 0a                	jae    80030d <sprintputch+0x1b>
		*b->buf++ = ch;
  800303:	8d 4a 01             	lea    0x1(%edx),%ecx
  800306:	89 08                	mov    %ecx,(%eax)
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	88 02                	mov    %al,(%edx)
}
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <printfmt>:
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800315:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800318:	50                   	push   %eax
  800319:	ff 75 10             	pushl  0x10(%ebp)
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	e8 05 00 00 00       	call   80032c <vprintfmt>
}
  800327:	83 c4 10             	add    $0x10,%esp
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <vprintfmt>:
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	57                   	push   %edi
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
  800332:	83 ec 2c             	sub    $0x2c,%esp
  800335:	8b 75 08             	mov    0x8(%ebp),%esi
  800338:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033e:	e9 21 04 00 00       	jmp    800764 <vprintfmt+0x438>
		padc = ' ';
  800343:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800347:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80034e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800355:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80035c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8d 47 01             	lea    0x1(%edi),%eax
  800364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800367:	0f b6 17             	movzbl (%edi),%edx
  80036a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036d:	3c 55                	cmp    $0x55,%al
  80036f:	0f 87 90 04 00 00    	ja     800805 <vprintfmt+0x4d9>
  800375:	0f b6 c0             	movzbl %al,%eax
  800378:	ff 24 85 80 25 80 00 	jmp    *0x802580(,%eax,4)
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800382:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800386:	eb d9                	jmp    800361 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80038f:	eb d0                	jmp    800361 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800391:	0f b6 d2             	movzbl %dl,%edx
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800397:	b8 00 00 00 00       	mov    $0x0,%eax
  80039c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ac:	83 f9 09             	cmp    $0x9,%ecx
  8003af:	77 55                	ja     800406 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003b1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b4:	eb e9                	jmp    80039f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 40 04             	lea    0x4(%eax),%eax
  8003c4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ce:	79 91                	jns    800361 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003dd:	eb 82                	jmp    800361 <vprintfmt+0x35>
  8003df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e9:	0f 49 d0             	cmovns %eax,%edx
  8003ec:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f2:	e9 6a ff ff ff       	jmp    800361 <vprintfmt+0x35>
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fa:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800401:	e9 5b ff ff ff       	jmp    800361 <vprintfmt+0x35>
  800406:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800409:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80040c:	eb bc                	jmp    8003ca <vprintfmt+0x9e>
			lflag++;
  80040e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800414:	e9 48 ff ff ff       	jmp    800361 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	53                   	push   %ebx
  800423:	ff 30                	pushl  (%eax)
  800425:	ff d6                	call   *%esi
			break;
  800427:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042d:	e9 2f 03 00 00       	jmp    800761 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 78 04             	lea    0x4(%eax),%edi
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	99                   	cltd   
  80043b:	31 d0                	xor    %edx,%eax
  80043d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043f:	83 f8 0f             	cmp    $0xf,%eax
  800442:	7f 23                	jg     800467 <vprintfmt+0x13b>
  800444:	8b 14 85 e0 26 80 00 	mov    0x8026e0(,%eax,4),%edx
  80044b:	85 d2                	test   %edx,%edx
  80044d:	74 18                	je     800467 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80044f:	52                   	push   %edx
  800450:	68 3e 28 80 00       	push   $0x80283e
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 b3 fe ff ff       	call   80030f <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800462:	e9 fa 02 00 00       	jmp    800761 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800467:	50                   	push   %eax
  800468:	68 4f 24 80 00       	push   $0x80244f
  80046d:	53                   	push   %ebx
  80046e:	56                   	push   %esi
  80046f:	e8 9b fe ff ff       	call   80030f <printfmt>
  800474:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800477:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047a:	e9 e2 02 00 00       	jmp    800761 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	83 c0 04             	add    $0x4,%eax
  800485:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80048d:	85 ff                	test   %edi,%edi
  80048f:	b8 48 24 80 00       	mov    $0x802448,%eax
  800494:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800497:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049b:	0f 8e bd 00 00 00    	jle    80055e <vprintfmt+0x232>
  8004a1:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004a5:	75 0e                	jne    8004b5 <vprintfmt+0x189>
  8004a7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004aa:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ad:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b3:	eb 6d                	jmp    800522 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 d0             	pushl  -0x30(%ebp)
  8004bb:	57                   	push   %edi
  8004bc:	e8 ec 03 00 00       	call   8008ad <strnlen>
  8004c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c4:	29 c1                	sub    %eax,%ecx
  8004c6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004c9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004cc:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004d6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d8:	eb 0f                	jmp    8004e9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	53                   	push   %ebx
  8004de:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e3:	83 ef 01             	sub    $0x1,%edi
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 ff                	test   %edi,%edi
  8004eb:	7f ed                	jg     8004da <vprintfmt+0x1ae>
  8004ed:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004f3:	85 c9                	test   %ecx,%ecx
  8004f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fa:	0f 49 c1             	cmovns %ecx,%eax
  8004fd:	29 c1                	sub    %eax,%ecx
  8004ff:	89 75 08             	mov    %esi,0x8(%ebp)
  800502:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800505:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800508:	89 cb                	mov    %ecx,%ebx
  80050a:	eb 16                	jmp    800522 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80050c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800510:	75 31                	jne    800543 <vprintfmt+0x217>
					putch(ch, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	50                   	push   %eax
  800519:	ff 55 08             	call   *0x8(%ebp)
  80051c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 eb 01             	sub    $0x1,%ebx
  800522:	83 c7 01             	add    $0x1,%edi
  800525:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800529:	0f be c2             	movsbl %dl,%eax
  80052c:	85 c0                	test   %eax,%eax
  80052e:	74 59                	je     800589 <vprintfmt+0x25d>
  800530:	85 f6                	test   %esi,%esi
  800532:	78 d8                	js     80050c <vprintfmt+0x1e0>
  800534:	83 ee 01             	sub    $0x1,%esi
  800537:	79 d3                	jns    80050c <vprintfmt+0x1e0>
  800539:	89 df                	mov    %ebx,%edi
  80053b:	8b 75 08             	mov    0x8(%ebp),%esi
  80053e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800541:	eb 37                	jmp    80057a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800543:	0f be d2             	movsbl %dl,%edx
  800546:	83 ea 20             	sub    $0x20,%edx
  800549:	83 fa 5e             	cmp    $0x5e,%edx
  80054c:	76 c4                	jbe    800512 <vprintfmt+0x1e6>
					putch('?', putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	ff 75 0c             	pushl  0xc(%ebp)
  800554:	6a 3f                	push   $0x3f
  800556:	ff 55 08             	call   *0x8(%ebp)
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	eb c1                	jmp    80051f <vprintfmt+0x1f3>
  80055e:	89 75 08             	mov    %esi,0x8(%ebp)
  800561:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800564:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800567:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80056a:	eb b6                	jmp    800522 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	53                   	push   %ebx
  800570:	6a 20                	push   $0x20
  800572:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800574:	83 ef 01             	sub    $0x1,%edi
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	85 ff                	test   %edi,%edi
  80057c:	7f ee                	jg     80056c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
  800584:	e9 d8 01 00 00       	jmp    800761 <vprintfmt+0x435>
  800589:	89 df                	mov    %ebx,%edi
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800591:	eb e7                	jmp    80057a <vprintfmt+0x24e>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7e 45                	jle    8005dd <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b3:	79 62                	jns    800617 <vprintfmt+0x2eb>
				putch('-', putdat);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	53                   	push   %ebx
  8005b9:	6a 2d                	push   $0x2d
  8005bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005c3:	f7 d8                	neg    %eax
  8005c5:	83 d2 00             	adc    $0x0,%edx
  8005c8:	f7 da                	neg    %edx
  8005ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d3:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005d8:	e9 66 01 00 00       	jmp    800743 <vprintfmt+0x417>
	else if (lflag)
  8005dd:	85 c9                	test   %ecx,%ecx
  8005df:	75 1b                	jne    8005fc <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	89 c1                	mov    %eax,%ecx
  8005eb:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ee:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8d 40 04             	lea    0x4(%eax),%eax
  8005f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fa:	eb b3                	jmp    8005af <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	89 c1                	mov    %eax,%ecx
  800606:	c1 f9 1f             	sar    $0x1f,%ecx
  800609:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 40 04             	lea    0x4(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	eb 98                	jmp    8005af <vprintfmt+0x283>
			base = 10;
  800617:	ba 0a 00 00 00       	mov    $0xa,%edx
  80061c:	e9 22 01 00 00       	jmp    800743 <vprintfmt+0x417>
	if (lflag >= 2)
  800621:	83 f9 01             	cmp    $0x1,%ecx
  800624:	7e 21                	jle    800647 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 50 04             	mov    0x4(%eax),%edx
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800631:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 40 08             	lea    0x8(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800642:	e9 fc 00 00 00       	jmp    800743 <vprintfmt+0x417>
	else if (lflag)
  800647:	85 c9                	test   %ecx,%ecx
  800649:	75 23                	jne    80066e <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800664:	ba 0a 00 00 00       	mov    $0xa,%edx
  800669:	e9 d5 00 00 00       	jmp    800743 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	ba 00 00 00 00       	mov    $0x0,%edx
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800687:	ba 0a 00 00 00       	mov    $0xa,%edx
  80068c:	e9 b2 00 00 00       	jmp    800743 <vprintfmt+0x417>
	if (lflag >= 2)
  800691:	83 f9 01             	cmp    $0x1,%ecx
  800694:	7e 42                	jle    8006d8 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 50 04             	mov    0x4(%eax),%edx
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 40 08             	lea    0x8(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ad:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8006b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b6:	0f 89 87 00 00 00    	jns    800743 <vprintfmt+0x417>
				putch('-', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 2d                	push   $0x2d
  8006c2:	ff d6                	call   *%esi
				num = -(long long) num;
  8006c4:	f7 5d d8             	negl   -0x28(%ebp)
  8006c7:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8006cb:	f7 5d dc             	negl   -0x24(%ebp)
  8006ce:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006d1:	ba 08 00 00 00       	mov    $0x8,%edx
  8006d6:	eb 6b                	jmp    800743 <vprintfmt+0x417>
	else if (lflag)
  8006d8:	85 c9                	test   %ecx,%ecx
  8006da:	75 1b                	jne    8006f7 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f5:	eb b6                	jmp    8006ad <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800701:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800704:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8d 40 04             	lea    0x4(%eax),%eax
  80070d:	89 45 14             	mov    %eax,0x14(%ebp)
  800710:	eb 9b                	jmp    8006ad <vprintfmt+0x381>
			putch('0', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	53                   	push   %ebx
  800716:	6a 30                	push   $0x30
  800718:	ff d6                	call   *%esi
			putch('x', putdat);
  80071a:	83 c4 08             	add    $0x8,%esp
  80071d:	53                   	push   %ebx
  80071e:	6a 78                	push   $0x78
  800720:	ff d6                	call   *%esi
			num = (unsigned long long)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800732:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073e:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80074a:	50                   	push   %eax
  80074b:	ff 75 e0             	pushl  -0x20(%ebp)
  80074e:	52                   	push   %edx
  80074f:	ff 75 dc             	pushl  -0x24(%ebp)
  800752:	ff 75 d8             	pushl  -0x28(%ebp)
  800755:	89 da                	mov    %ebx,%edx
  800757:	89 f0                	mov    %esi,%eax
  800759:	e8 e5 fa ff ff       	call   800243 <printnum>
			break;
  80075e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	83 c7 01             	add    $0x1,%edi
  800767:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076b:	83 f8 25             	cmp    $0x25,%eax
  80076e:	0f 84 cf fb ff ff    	je     800343 <vprintfmt+0x17>
			if (ch == '\0')
  800774:	85 c0                	test   %eax,%eax
  800776:	0f 84 a9 00 00 00    	je     800825 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	50                   	push   %eax
  800781:	ff d6                	call   *%esi
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	eb dc                	jmp    800764 <vprintfmt+0x438>
	if (lflag >= 2)
  800788:	83 f9 01             	cmp    $0x1,%ecx
  80078b:	7e 1e                	jle    8007ab <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 50 04             	mov    0x4(%eax),%edx
  800793:	8b 00                	mov    (%eax),%eax
  800795:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800798:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8d 40 08             	lea    0x8(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a4:	ba 10 00 00 00       	mov    $0x10,%edx
  8007a9:	eb 98                	jmp    800743 <vprintfmt+0x417>
	else if (lflag)
  8007ab:	85 c9                	test   %ecx,%ecx
  8007ad:	75 23                	jne    8007d2 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c8:	ba 10 00 00 00       	mov    $0x10,%edx
  8007cd:	e9 71 ff ff ff       	jmp    800743 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8d 40 04             	lea    0x4(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007eb:	ba 10 00 00 00       	mov    $0x10,%edx
  8007f0:	e9 4e ff ff ff       	jmp    800743 <vprintfmt+0x417>
			putch(ch, putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 25                	push   $0x25
  8007fb:	ff d6                	call   *%esi
			break;
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	e9 5c ff ff ff       	jmp    800761 <vprintfmt+0x435>
			putch('%', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	6a 25                	push   $0x25
  80080b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080d:	83 c4 10             	add    $0x10,%esp
  800810:	89 f8                	mov    %edi,%eax
  800812:	eb 03                	jmp    800817 <vprintfmt+0x4eb>
  800814:	83 e8 01             	sub    $0x1,%eax
  800817:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80081b:	75 f7                	jne    800814 <vprintfmt+0x4e8>
  80081d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800820:	e9 3c ff ff ff       	jmp    800761 <vprintfmt+0x435>
}
  800825:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800828:	5b                   	pop    %ebx
  800829:	5e                   	pop    %esi
  80082a:	5f                   	pop    %edi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 18             	sub    $0x18,%esp
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800839:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80083c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800840:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800843:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084a:	85 c0                	test   %eax,%eax
  80084c:	74 26                	je     800874 <vsnprintf+0x47>
  80084e:	85 d2                	test   %edx,%edx
  800850:	7e 22                	jle    800874 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800852:	ff 75 14             	pushl  0x14(%ebp)
  800855:	ff 75 10             	pushl  0x10(%ebp)
  800858:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80085b:	50                   	push   %eax
  80085c:	68 f2 02 80 00       	push   $0x8002f2
  800861:	e8 c6 fa ff ff       	call   80032c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800869:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80086c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086f:	83 c4 10             	add    $0x10,%esp
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    
		return -E_INVAL;
  800874:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800879:	eb f7                	jmp    800872 <vsnprintf+0x45>

0080087b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800881:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800884:	50                   	push   %eax
  800885:	ff 75 10             	pushl  0x10(%ebp)
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	e8 9a ff ff ff       	call   80082d <vsnprintf>
	va_end(ap);

	return rc;
}
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a0:	eb 03                	jmp    8008a5 <strlen+0x10>
		n++;
  8008a2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008a5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a9:	75 f7                	jne    8008a2 <strlen+0xd>
	return n;
}
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb 03                	jmp    8008c0 <strnlen+0x13>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c0:	39 d0                	cmp    %edx,%eax
  8008c2:	74 06                	je     8008ca <strnlen+0x1d>
  8008c4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008c8:	75 f3                	jne    8008bd <strnlen+0x10>
	return n;
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	53                   	push   %ebx
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d6:	89 c2                	mov    %eax,%edx
  8008d8:	83 c1 01             	add    $0x1,%ecx
  8008db:	83 c2 01             	add    $0x1,%edx
  8008de:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008e2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e5:	84 db                	test   %bl,%bl
  8008e7:	75 ef                	jne    8008d8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008e9:	5b                   	pop    %ebx
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	53                   	push   %ebx
  8008f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f3:	53                   	push   %ebx
  8008f4:	e8 9c ff ff ff       	call   800895 <strlen>
  8008f9:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	01 d8                	add    %ebx,%eax
  800901:	50                   	push   %eax
  800902:	e8 c5 ff ff ff       	call   8008cc <strcpy>
	return dst;
}
  800907:	89 d8                	mov    %ebx,%eax
  800909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    

0080090e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	56                   	push   %esi
  800912:	53                   	push   %ebx
  800913:	8b 75 08             	mov    0x8(%ebp),%esi
  800916:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800919:	89 f3                	mov    %esi,%ebx
  80091b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091e:	89 f2                	mov    %esi,%edx
  800920:	eb 0f                	jmp    800931 <strncpy+0x23>
		*dst++ = *src;
  800922:	83 c2 01             	add    $0x1,%edx
  800925:	0f b6 01             	movzbl (%ecx),%eax
  800928:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80092b:	80 39 01             	cmpb   $0x1,(%ecx)
  80092e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800931:	39 da                	cmp    %ebx,%edx
  800933:	75 ed                	jne    800922 <strncpy+0x14>
	}
	return ret;
}
  800935:	89 f0                	mov    %esi,%eax
  800937:	5b                   	pop    %ebx
  800938:	5e                   	pop    %esi
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
  800940:	8b 75 08             	mov    0x8(%ebp),%esi
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
  800946:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800949:	89 f0                	mov    %esi,%eax
  80094b:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80094f:	85 c9                	test   %ecx,%ecx
  800951:	75 0b                	jne    80095e <strlcpy+0x23>
  800953:	eb 17                	jmp    80096c <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800955:	83 c2 01             	add    $0x1,%edx
  800958:	83 c0 01             	add    $0x1,%eax
  80095b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80095e:	39 d8                	cmp    %ebx,%eax
  800960:	74 07                	je     800969 <strlcpy+0x2e>
  800962:	0f b6 0a             	movzbl (%edx),%ecx
  800965:	84 c9                	test   %cl,%cl
  800967:	75 ec                	jne    800955 <strlcpy+0x1a>
		*dst = '\0';
  800969:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80096c:	29 f0                	sub    %esi,%eax
}
  80096e:	5b                   	pop    %ebx
  80096f:	5e                   	pop    %esi
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80097b:	eb 06                	jmp    800983 <strcmp+0x11>
		p++, q++;
  80097d:	83 c1 01             	add    $0x1,%ecx
  800980:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800983:	0f b6 01             	movzbl (%ecx),%eax
  800986:	84 c0                	test   %al,%al
  800988:	74 04                	je     80098e <strcmp+0x1c>
  80098a:	3a 02                	cmp    (%edx),%al
  80098c:	74 ef                	je     80097d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80098e:	0f b6 c0             	movzbl %al,%eax
  800991:	0f b6 12             	movzbl (%edx),%edx
  800994:	29 d0                	sub    %edx,%eax
}
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	53                   	push   %ebx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a2:	89 c3                	mov    %eax,%ebx
  8009a4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009a7:	eb 06                	jmp    8009af <strncmp+0x17>
		n--, p++, q++;
  8009a9:	83 c0 01             	add    $0x1,%eax
  8009ac:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009af:	39 d8                	cmp    %ebx,%eax
  8009b1:	74 16                	je     8009c9 <strncmp+0x31>
  8009b3:	0f b6 08             	movzbl (%eax),%ecx
  8009b6:	84 c9                	test   %cl,%cl
  8009b8:	74 04                	je     8009be <strncmp+0x26>
  8009ba:	3a 0a                	cmp    (%edx),%cl
  8009bc:	74 eb                	je     8009a9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009be:	0f b6 00             	movzbl (%eax),%eax
  8009c1:	0f b6 12             	movzbl (%edx),%edx
  8009c4:	29 d0                	sub    %edx,%eax
}
  8009c6:	5b                   	pop    %ebx
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    
		return 0;
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	eb f6                	jmp    8009c6 <strncmp+0x2e>

008009d0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009da:	0f b6 10             	movzbl (%eax),%edx
  8009dd:	84 d2                	test   %dl,%dl
  8009df:	74 09                	je     8009ea <strchr+0x1a>
		if (*s == c)
  8009e1:	38 ca                	cmp    %cl,%dl
  8009e3:	74 0a                	je     8009ef <strchr+0x1f>
	for (; *s; s++)
  8009e5:	83 c0 01             	add    $0x1,%eax
  8009e8:	eb f0                	jmp    8009da <strchr+0xa>
			return (char *) s;
	return 0;
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fb:	eb 03                	jmp    800a00 <strfind+0xf>
  8009fd:	83 c0 01             	add    $0x1,%eax
  800a00:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a03:	38 ca                	cmp    %cl,%dl
  800a05:	74 04                	je     800a0b <strfind+0x1a>
  800a07:	84 d2                	test   %dl,%dl
  800a09:	75 f2                	jne    8009fd <strfind+0xc>
			break;
	return (char *) s;
}
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	57                   	push   %edi
  800a11:	56                   	push   %esi
  800a12:	53                   	push   %ebx
  800a13:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a16:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a19:	85 c9                	test   %ecx,%ecx
  800a1b:	74 13                	je     800a30 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a1d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a23:	75 05                	jne    800a2a <memset+0x1d>
  800a25:	f6 c1 03             	test   $0x3,%cl
  800a28:	74 0d                	je     800a37 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	fc                   	cld    
  800a2e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a30:	89 f8                	mov    %edi,%eax
  800a32:	5b                   	pop    %ebx
  800a33:	5e                   	pop    %esi
  800a34:	5f                   	pop    %edi
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    
		c &= 0xFF;
  800a37:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a3b:	89 d3                	mov    %edx,%ebx
  800a3d:	c1 e3 08             	shl    $0x8,%ebx
  800a40:	89 d0                	mov    %edx,%eax
  800a42:	c1 e0 18             	shl    $0x18,%eax
  800a45:	89 d6                	mov    %edx,%esi
  800a47:	c1 e6 10             	shl    $0x10,%esi
  800a4a:	09 f0                	or     %esi,%eax
  800a4c:	09 c2                	or     %eax,%edx
  800a4e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a50:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a53:	89 d0                	mov    %edx,%eax
  800a55:	fc                   	cld    
  800a56:	f3 ab                	rep stos %eax,%es:(%edi)
  800a58:	eb d6                	jmp    800a30 <memset+0x23>

00800a5a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	57                   	push   %edi
  800a5e:	56                   	push   %esi
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a65:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a68:	39 c6                	cmp    %eax,%esi
  800a6a:	73 35                	jae    800aa1 <memmove+0x47>
  800a6c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a6f:	39 c2                	cmp    %eax,%edx
  800a71:	76 2e                	jbe    800aa1 <memmove+0x47>
		s += n;
		d += n;
  800a73:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a76:	89 d6                	mov    %edx,%esi
  800a78:	09 fe                	or     %edi,%esi
  800a7a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a80:	74 0c                	je     800a8e <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a82:	83 ef 01             	sub    $0x1,%edi
  800a85:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a88:	fd                   	std    
  800a89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8b:	fc                   	cld    
  800a8c:	eb 21                	jmp    800aaf <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8e:	f6 c1 03             	test   $0x3,%cl
  800a91:	75 ef                	jne    800a82 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a93:	83 ef 04             	sub    $0x4,%edi
  800a96:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a9c:	fd                   	std    
  800a9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9f:	eb ea                	jmp    800a8b <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa1:	89 f2                	mov    %esi,%edx
  800aa3:	09 c2                	or     %eax,%edx
  800aa5:	f6 c2 03             	test   $0x3,%dl
  800aa8:	74 09                	je     800ab3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aaa:	89 c7                	mov    %eax,%edi
  800aac:	fc                   	cld    
  800aad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aaf:	5e                   	pop    %esi
  800ab0:	5f                   	pop    %edi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab3:	f6 c1 03             	test   $0x3,%cl
  800ab6:	75 f2                	jne    800aaa <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800abb:	89 c7                	mov    %eax,%edi
  800abd:	fc                   	cld    
  800abe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac0:	eb ed                	jmp    800aaf <memmove+0x55>

00800ac2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ac5:	ff 75 10             	pushl  0x10(%ebp)
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 87 ff ff ff       	call   800a5a <memmove>
}
  800ad3:	c9                   	leave  
  800ad4:	c3                   	ret    

00800ad5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae0:	89 c6                	mov    %eax,%esi
  800ae2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae5:	39 f0                	cmp    %esi,%eax
  800ae7:	74 1c                	je     800b05 <memcmp+0x30>
		if (*s1 != *s2)
  800ae9:	0f b6 08             	movzbl (%eax),%ecx
  800aec:	0f b6 1a             	movzbl (%edx),%ebx
  800aef:	38 d9                	cmp    %bl,%cl
  800af1:	75 08                	jne    800afb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800af3:	83 c0 01             	add    $0x1,%eax
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	eb ea                	jmp    800ae5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800afb:	0f b6 c1             	movzbl %cl,%eax
  800afe:	0f b6 db             	movzbl %bl,%ebx
  800b01:	29 d8                	sub    %ebx,%eax
  800b03:	eb 05                	jmp    800b0a <memcmp+0x35>
	}

	return 0;
  800b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0a:	5b                   	pop    %ebx
  800b0b:	5e                   	pop    %esi
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b17:	89 c2                	mov    %eax,%edx
  800b19:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b1c:	39 d0                	cmp    %edx,%eax
  800b1e:	73 09                	jae    800b29 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b20:	38 08                	cmp    %cl,(%eax)
  800b22:	74 05                	je     800b29 <memfind+0x1b>
	for (; s < ends; s++)
  800b24:	83 c0 01             	add    $0x1,%eax
  800b27:	eb f3                	jmp    800b1c <memfind+0xe>
			break;
	return (void *) s;
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	57                   	push   %edi
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b37:	eb 03                	jmp    800b3c <strtol+0x11>
		s++;
  800b39:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3c:	0f b6 01             	movzbl (%ecx),%eax
  800b3f:	3c 20                	cmp    $0x20,%al
  800b41:	74 f6                	je     800b39 <strtol+0xe>
  800b43:	3c 09                	cmp    $0x9,%al
  800b45:	74 f2                	je     800b39 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b47:	3c 2b                	cmp    $0x2b,%al
  800b49:	74 2e                	je     800b79 <strtol+0x4e>
	int neg = 0;
  800b4b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b50:	3c 2d                	cmp    $0x2d,%al
  800b52:	74 2f                	je     800b83 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b54:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b5a:	75 05                	jne    800b61 <strtol+0x36>
  800b5c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5f:	74 2c                	je     800b8d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b61:	85 db                	test   %ebx,%ebx
  800b63:	75 0a                	jne    800b6f <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b65:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b6a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b6d:	74 28                	je     800b97 <strtol+0x6c>
		base = 10;
  800b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b74:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b77:	eb 50                	jmp    800bc9 <strtol+0x9e>
		s++;
  800b79:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b81:	eb d1                	jmp    800b54 <strtol+0x29>
		s++, neg = 1;
  800b83:	83 c1 01             	add    $0x1,%ecx
  800b86:	bf 01 00 00 00       	mov    $0x1,%edi
  800b8b:	eb c7                	jmp    800b54 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b91:	74 0e                	je     800ba1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	75 d8                	jne    800b6f <strtol+0x44>
		s++, base = 8;
  800b97:	83 c1 01             	add    $0x1,%ecx
  800b9a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b9f:	eb ce                	jmp    800b6f <strtol+0x44>
		s += 2, base = 16;
  800ba1:	83 c1 02             	add    $0x2,%ecx
  800ba4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba9:	eb c4                	jmp    800b6f <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bab:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bae:	89 f3                	mov    %esi,%ebx
  800bb0:	80 fb 19             	cmp    $0x19,%bl
  800bb3:	77 29                	ja     800bde <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bb5:	0f be d2             	movsbl %dl,%edx
  800bb8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bbb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bbe:	7d 30                	jge    800bf0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bc0:	83 c1 01             	add    $0x1,%ecx
  800bc3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bc7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bc9:	0f b6 11             	movzbl (%ecx),%edx
  800bcc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bcf:	89 f3                	mov    %esi,%ebx
  800bd1:	80 fb 09             	cmp    $0x9,%bl
  800bd4:	77 d5                	ja     800bab <strtol+0x80>
			dig = *s - '0';
  800bd6:	0f be d2             	movsbl %dl,%edx
  800bd9:	83 ea 30             	sub    $0x30,%edx
  800bdc:	eb dd                	jmp    800bbb <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bde:	8d 72 bf             	lea    -0x41(%edx),%esi
  800be1:	89 f3                	mov    %esi,%ebx
  800be3:	80 fb 19             	cmp    $0x19,%bl
  800be6:	77 08                	ja     800bf0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800be8:	0f be d2             	movsbl %dl,%edx
  800beb:	83 ea 37             	sub    $0x37,%edx
  800bee:	eb cb                	jmp    800bbb <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 05                	je     800bfb <strtol+0xd0>
		*endptr = (char *) s;
  800bf6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bfb:	89 c2                	mov    %eax,%edx
  800bfd:	f7 da                	neg    %edx
  800bff:	85 ff                	test   %edi,%edi
  800c01:	0f 45 c2             	cmovne %edx,%eax
}
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1a:	89 c3                	mov    %eax,%ebx
  800c1c:	89 c7                	mov    %eax,%edi
  800c1e:	89 c6                	mov    %eax,%esi
  800c20:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5f                   	pop    %edi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c32:	b8 01 00 00 00       	mov    $0x1,%eax
  800c37:	89 d1                	mov    %edx,%ecx
  800c39:	89 d3                	mov    %edx,%ebx
  800c3b:	89 d7                	mov    %edx,%edi
  800c3d:	89 d6                	mov    %edx,%esi
  800c3f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c41:	5b                   	pop    %ebx
  800c42:	5e                   	pop    %esi
  800c43:	5f                   	pop    %edi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	57                   	push   %edi
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
  800c4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5c:	89 cb                	mov    %ecx,%ebx
  800c5e:	89 cf                	mov    %ecx,%edi
  800c60:	89 ce                	mov    %ecx,%esi
  800c62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c64:	85 c0                	test   %eax,%eax
  800c66:	7f 08                	jg     800c70 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	50                   	push   %eax
  800c74:	6a 03                	push   $0x3
  800c76:	68 3f 27 80 00       	push   $0x80273f
  800c7b:	6a 23                	push   $0x23
  800c7d:	68 5c 27 80 00       	push   $0x80275c
  800c82:	e8 cd f4 ff ff       	call   800154 <_panic>

00800c87 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	b8 02 00 00 00       	mov    $0x2,%eax
  800c97:	89 d1                	mov    %edx,%ecx
  800c99:	89 d3                	mov    %edx,%ebx
  800c9b:	89 d7                	mov    %edx,%edi
  800c9d:	89 d6                	mov    %edx,%esi
  800c9f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_yield>:

void
sys_yield(void)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cac:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb6:	89 d1                	mov    %edx,%ecx
  800cb8:	89 d3                	mov    %edx,%ebx
  800cba:	89 d7                	mov    %edx,%edi
  800cbc:	89 d6                	mov    %edx,%esi
  800cbe:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cce:	be 00 00 00 00       	mov    $0x0,%esi
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd9:	b8 04 00 00 00       	mov    $0x4,%eax
  800cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce1:	89 f7                	mov    %esi,%edi
  800ce3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	7f 08                	jg     800cf1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf1:	83 ec 0c             	sub    $0xc,%esp
  800cf4:	50                   	push   %eax
  800cf5:	6a 04                	push   $0x4
  800cf7:	68 3f 27 80 00       	push   $0x80273f
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 5c 27 80 00       	push   $0x80275c
  800d03:	e8 4c f4 ff ff       	call   800154 <_panic>

00800d08 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d11:	8b 55 08             	mov    0x8(%ebp),%edx
  800d14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d17:	b8 05 00 00 00       	mov    $0x5,%eax
  800d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d22:	8b 75 18             	mov    0x18(%ebp),%esi
  800d25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	7f 08                	jg     800d33 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	50                   	push   %eax
  800d37:	6a 05                	push   $0x5
  800d39:	68 3f 27 80 00       	push   $0x80273f
  800d3e:	6a 23                	push   $0x23
  800d40:	68 5c 27 80 00       	push   $0x80275c
  800d45:	e8 0a f4 ff ff       	call   800154 <_panic>

00800d4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d63:	89 df                	mov    %ebx,%edi
  800d65:	89 de                	mov    %ebx,%esi
  800d67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7f 08                	jg     800d75 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	50                   	push   %eax
  800d79:	6a 06                	push   $0x6
  800d7b:	68 3f 27 80 00       	push   $0x80273f
  800d80:	6a 23                	push   $0x23
  800d82:	68 5c 27 80 00       	push   $0x80275c
  800d87:	e8 c8 f3 ff ff       	call   800154 <_panic>

00800d8c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da0:	b8 08 00 00 00       	mov    $0x8,%eax
  800da5:	89 df                	mov    %ebx,%edi
  800da7:	89 de                	mov    %ebx,%esi
  800da9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	7f 08                	jg     800db7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db7:	83 ec 0c             	sub    $0xc,%esp
  800dba:	50                   	push   %eax
  800dbb:	6a 08                	push   $0x8
  800dbd:	68 3f 27 80 00       	push   $0x80273f
  800dc2:	6a 23                	push   $0x23
  800dc4:	68 5c 27 80 00       	push   $0x80275c
  800dc9:	e8 86 f3 ff ff       	call   800154 <_panic>

00800dce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de2:	b8 09 00 00 00       	mov    $0x9,%eax
  800de7:	89 df                	mov    %ebx,%edi
  800de9:	89 de                	mov    %ebx,%esi
  800deb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ded:	85 c0                	test   %eax,%eax
  800def:	7f 08                	jg     800df9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df9:	83 ec 0c             	sub    $0xc,%esp
  800dfc:	50                   	push   %eax
  800dfd:	6a 09                	push   $0x9
  800dff:	68 3f 27 80 00       	push   $0x80273f
  800e04:	6a 23                	push   $0x23
  800e06:	68 5c 27 80 00       	push   $0x80275c
  800e0b:	e8 44 f3 ff ff       	call   800154 <_panic>

00800e10 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e24:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e29:	89 df                	mov    %ebx,%edi
  800e2b:	89 de                	mov    %ebx,%esi
  800e2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	7f 08                	jg     800e3b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	6a 0a                	push   $0xa
  800e41:	68 3f 27 80 00       	push   $0x80273f
  800e46:	6a 23                	push   $0x23
  800e48:	68 5c 27 80 00       	push   $0x80275c
  800e4d:	e8 02 f3 ff ff       	call   800154 <_panic>

00800e52 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e58:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e63:	be 00 00 00 00       	mov    $0x0,%esi
  800e68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e6e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8b:	89 cb                	mov    %ecx,%ebx
  800e8d:	89 cf                	mov    %ecx,%edi
  800e8f:	89 ce                	mov    %ecx,%esi
  800e91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	7f 08                	jg     800e9f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	50                   	push   %eax
  800ea3:	6a 0d                	push   $0xd
  800ea5:	68 3f 27 80 00       	push   $0x80273f
  800eaa:	6a 23                	push   $0x23
  800eac:	68 5c 27 80 00       	push   $0x80275c
  800eb1:	e8 9e f2 ff ff       	call   800154 <_panic>

00800eb6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec1:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ec6:	89 d1                	mov    %edx,%ecx
  800ec8:	89 d3                	mov    %edx,%ebx
  800eca:	89 d7                	mov    %edx,%edi
  800ecc:	89 d6                	mov    %edx,%esi
  800ece:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	05 00 00 00 30       	add    $0x30000000,%eax
  800ee0:	c1 e8 0c             	shr    $0xc,%eax
}
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ef0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ef5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f02:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f07:	89 c2                	mov    %eax,%edx
  800f09:	c1 ea 16             	shr    $0x16,%edx
  800f0c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f13:	f6 c2 01             	test   $0x1,%dl
  800f16:	74 2a                	je     800f42 <fd_alloc+0x46>
  800f18:	89 c2                	mov    %eax,%edx
  800f1a:	c1 ea 0c             	shr    $0xc,%edx
  800f1d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f24:	f6 c2 01             	test   $0x1,%dl
  800f27:	74 19                	je     800f42 <fd_alloc+0x46>
  800f29:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f2e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f33:	75 d2                	jne    800f07 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f35:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f3b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f40:	eb 07                	jmp    800f49 <fd_alloc+0x4d>
			*fd_store = fd;
  800f42:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    

00800f4b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f51:	83 f8 1f             	cmp    $0x1f,%eax
  800f54:	77 36                	ja     800f8c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f56:	c1 e0 0c             	shl    $0xc,%eax
  800f59:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f5e:	89 c2                	mov    %eax,%edx
  800f60:	c1 ea 16             	shr    $0x16,%edx
  800f63:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f6a:	f6 c2 01             	test   $0x1,%dl
  800f6d:	74 24                	je     800f93 <fd_lookup+0x48>
  800f6f:	89 c2                	mov    %eax,%edx
  800f71:	c1 ea 0c             	shr    $0xc,%edx
  800f74:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f7b:	f6 c2 01             	test   $0x1,%dl
  800f7e:	74 1a                	je     800f9a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	89 02                	mov    %eax,(%edx)
	return 0;
  800f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    
		return -E_INVAL;
  800f8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f91:	eb f7                	jmp    800f8a <fd_lookup+0x3f>
		return -E_INVAL;
  800f93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f98:	eb f0                	jmp    800f8a <fd_lookup+0x3f>
  800f9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f9f:	eb e9                	jmp    800f8a <fd_lookup+0x3f>

00800fa1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 08             	sub    $0x8,%esp
  800fa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800faa:	ba e8 27 80 00       	mov    $0x8027e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800faf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fb4:	39 08                	cmp    %ecx,(%eax)
  800fb6:	74 33                	je     800feb <dev_lookup+0x4a>
  800fb8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fbb:	8b 02                	mov    (%edx),%eax
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 f3                	jne    800fb4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fc1:	a1 08 40 80 00       	mov    0x804008,%eax
  800fc6:	8b 40 48             	mov    0x48(%eax),%eax
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	51                   	push   %ecx
  800fcd:	50                   	push   %eax
  800fce:	68 6c 27 80 00       	push   $0x80276c
  800fd3:	e8 57 f2 ff ff       	call   80022f <cprintf>
	*dev = 0;
  800fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    
			*dev = devtab[i];
  800feb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fee:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff5:	eb f2                	jmp    800fe9 <dev_lookup+0x48>

00800ff7 <fd_close>:
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
  800ffd:	83 ec 1c             	sub    $0x1c,%esp
  801000:	8b 75 08             	mov    0x8(%ebp),%esi
  801003:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801006:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801009:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80100a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801010:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801013:	50                   	push   %eax
  801014:	e8 32 ff ff ff       	call   800f4b <fd_lookup>
  801019:	89 c3                	mov    %eax,%ebx
  80101b:	83 c4 08             	add    $0x8,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	78 05                	js     801027 <fd_close+0x30>
	    || fd != fd2)
  801022:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801025:	74 16                	je     80103d <fd_close+0x46>
		return (must_exist ? r : 0);
  801027:	89 f8                	mov    %edi,%eax
  801029:	84 c0                	test   %al,%al
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
  801030:	0f 44 d8             	cmove  %eax,%ebx
}
  801033:	89 d8                	mov    %ebx,%eax
  801035:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80103d:	83 ec 08             	sub    $0x8,%esp
  801040:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801043:	50                   	push   %eax
  801044:	ff 36                	pushl  (%esi)
  801046:	e8 56 ff ff ff       	call   800fa1 <dev_lookup>
  80104b:	89 c3                	mov    %eax,%ebx
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	78 15                	js     801069 <fd_close+0x72>
		if (dev->dev_close)
  801054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801057:	8b 40 10             	mov    0x10(%eax),%eax
  80105a:	85 c0                	test   %eax,%eax
  80105c:	74 1b                	je     801079 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	56                   	push   %esi
  801062:	ff d0                	call   *%eax
  801064:	89 c3                	mov    %eax,%ebx
  801066:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	56                   	push   %esi
  80106d:	6a 00                	push   $0x0
  80106f:	e8 d6 fc ff ff       	call   800d4a <sys_page_unmap>
	return r;
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	eb ba                	jmp    801033 <fd_close+0x3c>
			r = 0;
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	eb e9                	jmp    801069 <fd_close+0x72>

00801080 <close>:

int
close(int fdnum)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801086:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801089:	50                   	push   %eax
  80108a:	ff 75 08             	pushl  0x8(%ebp)
  80108d:	e8 b9 fe ff ff       	call   800f4b <fd_lookup>
  801092:	83 c4 08             	add    $0x8,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	78 10                	js     8010a9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801099:	83 ec 08             	sub    $0x8,%esp
  80109c:	6a 01                	push   $0x1
  80109e:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a1:	e8 51 ff ff ff       	call   800ff7 <fd_close>
  8010a6:	83 c4 10             	add    $0x10,%esp
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <close_all>:

void
close_all(void)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	53                   	push   %ebx
  8010af:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010b2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010b7:	83 ec 0c             	sub    $0xc,%esp
  8010ba:	53                   	push   %ebx
  8010bb:	e8 c0 ff ff ff       	call   801080 <close>
	for (i = 0; i < MAXFD; i++)
  8010c0:	83 c3 01             	add    $0x1,%ebx
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	83 fb 20             	cmp    $0x20,%ebx
  8010c9:	75 ec                	jne    8010b7 <close_all+0xc>
}
  8010cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	ff 75 08             	pushl  0x8(%ebp)
  8010e0:	e8 66 fe ff ff       	call   800f4b <fd_lookup>
  8010e5:	89 c3                	mov    %eax,%ebx
  8010e7:	83 c4 08             	add    $0x8,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	0f 88 81 00 00 00    	js     801173 <dup+0xa3>
		return r;
	close(newfdnum);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	e8 83 ff ff ff       	call   801080 <close>

	newfd = INDEX2FD(newfdnum);
  8010fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  801100:	c1 e6 0c             	shl    $0xc,%esi
  801103:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801109:	83 c4 04             	add    $0x4,%esp
  80110c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110f:	e8 d1 fd ff ff       	call   800ee5 <fd2data>
  801114:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801116:	89 34 24             	mov    %esi,(%esp)
  801119:	e8 c7 fd ff ff       	call   800ee5 <fd2data>
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801123:	89 d8                	mov    %ebx,%eax
  801125:	c1 e8 16             	shr    $0x16,%eax
  801128:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112f:	a8 01                	test   $0x1,%al
  801131:	74 11                	je     801144 <dup+0x74>
  801133:	89 d8                	mov    %ebx,%eax
  801135:	c1 e8 0c             	shr    $0xc,%eax
  801138:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80113f:	f6 c2 01             	test   $0x1,%dl
  801142:	75 39                	jne    80117d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801147:	89 d0                	mov    %edx,%eax
  801149:	c1 e8 0c             	shr    $0xc,%eax
  80114c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	25 07 0e 00 00       	and    $0xe07,%eax
  80115b:	50                   	push   %eax
  80115c:	56                   	push   %esi
  80115d:	6a 00                	push   $0x0
  80115f:	52                   	push   %edx
  801160:	6a 00                	push   $0x0
  801162:	e8 a1 fb ff ff       	call   800d08 <sys_page_map>
  801167:	89 c3                	mov    %eax,%ebx
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	78 31                	js     8011a1 <dup+0xd1>
		goto err;

	return newfdnum;
  801170:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801173:	89 d8                	mov    %ebx,%eax
  801175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80117d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	25 07 0e 00 00       	and    $0xe07,%eax
  80118c:	50                   	push   %eax
  80118d:	57                   	push   %edi
  80118e:	6a 00                	push   $0x0
  801190:	53                   	push   %ebx
  801191:	6a 00                	push   $0x0
  801193:	e8 70 fb ff ff       	call   800d08 <sys_page_map>
  801198:	89 c3                	mov    %eax,%ebx
  80119a:	83 c4 20             	add    $0x20,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	79 a3                	jns    801144 <dup+0x74>
	sys_page_unmap(0, newfd);
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	56                   	push   %esi
  8011a5:	6a 00                	push   $0x0
  8011a7:	e8 9e fb ff ff       	call   800d4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	57                   	push   %edi
  8011b0:	6a 00                	push   $0x0
  8011b2:	e8 93 fb ff ff       	call   800d4a <sys_page_unmap>
	return r;
  8011b7:	83 c4 10             	add    $0x10,%esp
  8011ba:	eb b7                	jmp    801173 <dup+0xa3>

008011bc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 14             	sub    $0x14,%esp
  8011c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c9:	50                   	push   %eax
  8011ca:	53                   	push   %ebx
  8011cb:	e8 7b fd ff ff       	call   800f4b <fd_lookup>
  8011d0:	83 c4 08             	add    $0x8,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	78 3f                	js     801216 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011dd:	50                   	push   %eax
  8011de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e1:	ff 30                	pushl  (%eax)
  8011e3:	e8 b9 fd ff ff       	call   800fa1 <dev_lookup>
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	78 27                	js     801216 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011f2:	8b 42 08             	mov    0x8(%edx),%eax
  8011f5:	83 e0 03             	and    $0x3,%eax
  8011f8:	83 f8 01             	cmp    $0x1,%eax
  8011fb:	74 1e                	je     80121b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801200:	8b 40 08             	mov    0x8(%eax),%eax
  801203:	85 c0                	test   %eax,%eax
  801205:	74 35                	je     80123c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	ff 75 10             	pushl  0x10(%ebp)
  80120d:	ff 75 0c             	pushl  0xc(%ebp)
  801210:	52                   	push   %edx
  801211:	ff d0                	call   *%eax
  801213:	83 c4 10             	add    $0x10,%esp
}
  801216:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801219:	c9                   	leave  
  80121a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80121b:	a1 08 40 80 00       	mov    0x804008,%eax
  801220:	8b 40 48             	mov    0x48(%eax),%eax
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	53                   	push   %ebx
  801227:	50                   	push   %eax
  801228:	68 ad 27 80 00       	push   $0x8027ad
  80122d:	e8 fd ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123a:	eb da                	jmp    801216 <read+0x5a>
		return -E_NOT_SUPP;
  80123c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801241:	eb d3                	jmp    801216 <read+0x5a>

00801243 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	57                   	push   %edi
  801247:	56                   	push   %esi
  801248:	53                   	push   %ebx
  801249:	83 ec 0c             	sub    $0xc,%esp
  80124c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80124f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801252:	bb 00 00 00 00       	mov    $0x0,%ebx
  801257:	39 f3                	cmp    %esi,%ebx
  801259:	73 25                	jae    801280 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80125b:	83 ec 04             	sub    $0x4,%esp
  80125e:	89 f0                	mov    %esi,%eax
  801260:	29 d8                	sub    %ebx,%eax
  801262:	50                   	push   %eax
  801263:	89 d8                	mov    %ebx,%eax
  801265:	03 45 0c             	add    0xc(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	57                   	push   %edi
  80126a:	e8 4d ff ff ff       	call   8011bc <read>
		if (m < 0)
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 08                	js     80127e <readn+0x3b>
			return m;
		if (m == 0)
  801276:	85 c0                	test   %eax,%eax
  801278:	74 06                	je     801280 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80127a:	01 c3                	add    %eax,%ebx
  80127c:	eb d9                	jmp    801257 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80127e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801280:	89 d8                	mov    %ebx,%eax
  801282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801285:	5b                   	pop    %ebx
  801286:	5e                   	pop    %esi
  801287:	5f                   	pop    %edi
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	53                   	push   %ebx
  80128e:	83 ec 14             	sub    $0x14,%esp
  801291:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801294:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801297:	50                   	push   %eax
  801298:	53                   	push   %ebx
  801299:	e8 ad fc ff ff       	call   800f4b <fd_lookup>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	78 3a                	js     8012df <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012a5:	83 ec 08             	sub    $0x8,%esp
  8012a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ab:	50                   	push   %eax
  8012ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012af:	ff 30                	pushl  (%eax)
  8012b1:	e8 eb fc ff ff       	call   800fa1 <dev_lookup>
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	78 22                	js     8012df <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012c4:	74 1e                	je     8012e4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8012cc:	85 d2                	test   %edx,%edx
  8012ce:	74 35                	je     801305 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	ff 75 10             	pushl  0x10(%ebp)
  8012d6:	ff 75 0c             	pushl  0xc(%ebp)
  8012d9:	50                   	push   %eax
  8012da:	ff d2                	call   *%edx
  8012dc:	83 c4 10             	add    $0x10,%esp
}
  8012df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8012e9:	8b 40 48             	mov    0x48(%eax),%eax
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	53                   	push   %ebx
  8012f0:	50                   	push   %eax
  8012f1:	68 c9 27 80 00       	push   $0x8027c9
  8012f6:	e8 34 ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801303:	eb da                	jmp    8012df <write+0x55>
		return -E_NOT_SUPP;
  801305:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80130a:	eb d3                	jmp    8012df <write+0x55>

0080130c <seek>:

int
seek(int fdnum, off_t offset)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801312:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801315:	50                   	push   %eax
  801316:	ff 75 08             	pushl  0x8(%ebp)
  801319:	e8 2d fc ff ff       	call   800f4b <fd_lookup>
  80131e:	83 c4 08             	add    $0x8,%esp
  801321:	85 c0                	test   %eax,%eax
  801323:	78 0e                	js     801333 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801325:	8b 55 0c             	mov    0xc(%ebp),%edx
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80132e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	53                   	push   %ebx
  801339:	83 ec 14             	sub    $0x14,%esp
  80133c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801342:	50                   	push   %eax
  801343:	53                   	push   %ebx
  801344:	e8 02 fc ff ff       	call   800f4b <fd_lookup>
  801349:	83 c4 08             	add    $0x8,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 37                	js     801387 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801350:	83 ec 08             	sub    $0x8,%esp
  801353:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801356:	50                   	push   %eax
  801357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135a:	ff 30                	pushl  (%eax)
  80135c:	e8 40 fc ff ff       	call   800fa1 <dev_lookup>
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	78 1f                	js     801387 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80136f:	74 1b                	je     80138c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801371:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801374:	8b 52 18             	mov    0x18(%edx),%edx
  801377:	85 d2                	test   %edx,%edx
  801379:	74 32                	je     8013ad <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	ff 75 0c             	pushl  0xc(%ebp)
  801381:	50                   	push   %eax
  801382:	ff d2                	call   *%edx
  801384:	83 c4 10             	add    $0x10,%esp
}
  801387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80138c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801391:	8b 40 48             	mov    0x48(%eax),%eax
  801394:	83 ec 04             	sub    $0x4,%esp
  801397:	53                   	push   %ebx
  801398:	50                   	push   %eax
  801399:	68 8c 27 80 00       	push   $0x80278c
  80139e:	e8 8c ee ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ab:	eb da                	jmp    801387 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b2:	eb d3                	jmp    801387 <ftruncate+0x52>

008013b4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	53                   	push   %ebx
  8013b8:	83 ec 14             	sub    $0x14,%esp
  8013bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c1:	50                   	push   %eax
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	e8 81 fb ff ff       	call   800f4b <fd_lookup>
  8013ca:	83 c4 08             	add    $0x8,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 4b                	js     80141c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d1:	83 ec 08             	sub    $0x8,%esp
  8013d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d7:	50                   	push   %eax
  8013d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013db:	ff 30                	pushl  (%eax)
  8013dd:	e8 bf fb ff ff       	call   800fa1 <dev_lookup>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 33                	js     80141c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ec:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013f0:	74 2f                	je     801421 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013f2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013f5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013fc:	00 00 00 
	stat->st_isdir = 0;
  8013ff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801406:	00 00 00 
	stat->st_dev = dev;
  801409:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	53                   	push   %ebx
  801413:	ff 75 f0             	pushl  -0x10(%ebp)
  801416:	ff 50 14             	call   *0x14(%eax)
  801419:	83 c4 10             	add    $0x10,%esp
}
  80141c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80141f:	c9                   	leave  
  801420:	c3                   	ret    
		return -E_NOT_SUPP;
  801421:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801426:	eb f4                	jmp    80141c <fstat+0x68>

00801428 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	56                   	push   %esi
  80142c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	6a 00                	push   $0x0
  801432:	ff 75 08             	pushl  0x8(%ebp)
  801435:	e8 26 02 00 00       	call   801660 <open>
  80143a:	89 c3                	mov    %eax,%ebx
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 1b                	js     80145e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801443:	83 ec 08             	sub    $0x8,%esp
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	50                   	push   %eax
  80144a:	e8 65 ff ff ff       	call   8013b4 <fstat>
  80144f:	89 c6                	mov    %eax,%esi
	close(fd);
  801451:	89 1c 24             	mov    %ebx,(%esp)
  801454:	e8 27 fc ff ff       	call   801080 <close>
	return r;
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	89 f3                	mov    %esi,%ebx
}
  80145e:	89 d8                	mov    %ebx,%eax
  801460:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801463:	5b                   	pop    %ebx
  801464:	5e                   	pop    %esi
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	56                   	push   %esi
  80146b:	53                   	push   %ebx
  80146c:	89 c6                	mov    %eax,%esi
  80146e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801470:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801477:	74 27                	je     8014a0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801479:	6a 07                	push   $0x7
  80147b:	68 00 50 80 00       	push   $0x805000
  801480:	56                   	push   %esi
  801481:	ff 35 00 40 80 00    	pushl  0x804000
  801487:	e8 11 0c 00 00       	call   80209d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80148c:	83 c4 0c             	add    $0xc,%esp
  80148f:	6a 00                	push   $0x0
  801491:	53                   	push   %ebx
  801492:	6a 00                	push   $0x0
  801494:	e8 9b 0b 00 00       	call   802034 <ipc_recv>
}
  801499:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149c:	5b                   	pop    %ebx
  80149d:	5e                   	pop    %esi
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	6a 01                	push   $0x1
  8014a5:	e8 4c 0c 00 00       	call   8020f6 <ipc_find_env>
  8014aa:	a3 00 40 80 00       	mov    %eax,0x804000
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	eb c5                	jmp    801479 <fsipc+0x12>

008014b4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8014d7:	e8 8b ff ff ff       	call   801467 <fsipc>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <devfile_flush>:
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ea:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8014f9:	e8 69 ff ff ff       	call   801467 <fsipc>
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <devfile_stat>:
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	53                   	push   %ebx
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8b 40 0c             	mov    0xc(%eax),%eax
  801510:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801515:	ba 00 00 00 00       	mov    $0x0,%edx
  80151a:	b8 05 00 00 00       	mov    $0x5,%eax
  80151f:	e8 43 ff ff ff       	call   801467 <fsipc>
  801524:	85 c0                	test   %eax,%eax
  801526:	78 2c                	js     801554 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	68 00 50 80 00       	push   $0x805000
  801530:	53                   	push   %ebx
  801531:	e8 96 f3 ff ff       	call   8008cc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801536:	a1 80 50 80 00       	mov    0x805080,%eax
  80153b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801541:	a1 84 50 80 00       	mov    0x805084,%eax
  801546:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801554:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <devfile_write>:
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	53                   	push   %ebx
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8b 40 0c             	mov    0xc(%eax),%eax
  801569:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80156e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801574:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80157a:	77 30                	ja     8015ac <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	53                   	push   %ebx
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	68 08 50 80 00       	push   $0x805008
  801588:	e8 cd f4 ff ff       	call   800a5a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80158d:	ba 00 00 00 00       	mov    $0x0,%edx
  801592:	b8 04 00 00 00       	mov    $0x4,%eax
  801597:	e8 cb fe ff ff       	call   801467 <fsipc>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 04                	js     8015a7 <devfile_write+0x4e>
	assert(r <= n);
  8015a3:	39 d8                	cmp    %ebx,%eax
  8015a5:	77 1e                	ja     8015c5 <devfile_write+0x6c>
}
  8015a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015ac:	68 fc 27 80 00       	push   $0x8027fc
  8015b1:	68 2c 28 80 00       	push   $0x80282c
  8015b6:	68 94 00 00 00       	push   $0x94
  8015bb:	68 41 28 80 00       	push   $0x802841
  8015c0:	e8 8f eb ff ff       	call   800154 <_panic>
	assert(r <= n);
  8015c5:	68 4c 28 80 00       	push   $0x80284c
  8015ca:	68 2c 28 80 00       	push   $0x80282c
  8015cf:	68 98 00 00 00       	push   $0x98
  8015d4:	68 41 28 80 00       	push   $0x802841
  8015d9:	e8 76 eb ff ff       	call   800154 <_panic>

008015de <devfile_read>:
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ec:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015f1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fc:	b8 03 00 00 00       	mov    $0x3,%eax
  801601:	e8 61 fe ff ff       	call   801467 <fsipc>
  801606:	89 c3                	mov    %eax,%ebx
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 1f                	js     80162b <devfile_read+0x4d>
	assert(r <= n);
  80160c:	39 f0                	cmp    %esi,%eax
  80160e:	77 24                	ja     801634 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801610:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801615:	7f 33                	jg     80164a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	50                   	push   %eax
  80161b:	68 00 50 80 00       	push   $0x805000
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	e8 32 f4 ff ff       	call   800a5a <memmove>
	return r;
  801628:	83 c4 10             	add    $0x10,%esp
}
  80162b:	89 d8                	mov    %ebx,%eax
  80162d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801630:	5b                   	pop    %ebx
  801631:	5e                   	pop    %esi
  801632:	5d                   	pop    %ebp
  801633:	c3                   	ret    
	assert(r <= n);
  801634:	68 4c 28 80 00       	push   $0x80284c
  801639:	68 2c 28 80 00       	push   $0x80282c
  80163e:	6a 7c                	push   $0x7c
  801640:	68 41 28 80 00       	push   $0x802841
  801645:	e8 0a eb ff ff       	call   800154 <_panic>
	assert(r <= PGSIZE);
  80164a:	68 53 28 80 00       	push   $0x802853
  80164f:	68 2c 28 80 00       	push   $0x80282c
  801654:	6a 7d                	push   $0x7d
  801656:	68 41 28 80 00       	push   $0x802841
  80165b:	e8 f4 ea ff ff       	call   800154 <_panic>

00801660 <open>:
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	83 ec 1c             	sub    $0x1c,%esp
  801668:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80166b:	56                   	push   %esi
  80166c:	e8 24 f2 ff ff       	call   800895 <strlen>
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801679:	7f 6c                	jg     8016e7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80167b:	83 ec 0c             	sub    $0xc,%esp
  80167e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801681:	50                   	push   %eax
  801682:	e8 75 f8 ff ff       	call   800efc <fd_alloc>
  801687:	89 c3                	mov    %eax,%ebx
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 3c                	js     8016cc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	56                   	push   %esi
  801694:	68 00 50 80 00       	push   $0x805000
  801699:	e8 2e f2 ff ff       	call   8008cc <strcpy>
	fsipcbuf.open.req_omode = mode;
  80169e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a1:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ae:	e8 b4 fd ff ff       	call   801467 <fsipc>
  8016b3:	89 c3                	mov    %eax,%ebx
  8016b5:	83 c4 10             	add    $0x10,%esp
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	78 19                	js     8016d5 <open+0x75>
	return fd2num(fd);
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c2:	e8 0e f8 ff ff       	call   800ed5 <fd2num>
  8016c7:	89 c3                	mov    %eax,%ebx
  8016c9:	83 c4 10             	add    $0x10,%esp
}
  8016cc:	89 d8                	mov    %ebx,%eax
  8016ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    
		fd_close(fd, 0);
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 f4             	pushl  -0xc(%ebp)
  8016dd:	e8 15 f9 ff ff       	call   800ff7 <fd_close>
		return r;
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	eb e5                	jmp    8016cc <open+0x6c>
		return -E_BAD_PATH;
  8016e7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016ec:	eb de                	jmp    8016cc <open+0x6c>

008016ee <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8016fe:	e8 64 fd ff ff       	call   801467 <fsipc>
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	56                   	push   %esi
  801709:	53                   	push   %ebx
  80170a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	ff 75 08             	pushl  0x8(%ebp)
  801713:	e8 cd f7 ff ff       	call   800ee5 <fd2data>
  801718:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80171a:	83 c4 08             	add    $0x8,%esp
  80171d:	68 5f 28 80 00       	push   $0x80285f
  801722:	53                   	push   %ebx
  801723:	e8 a4 f1 ff ff       	call   8008cc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801728:	8b 46 04             	mov    0x4(%esi),%eax
  80172b:	2b 06                	sub    (%esi),%eax
  80172d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801733:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80173a:	00 00 00 
	stat->st_dev = &devpipe;
  80173d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801744:	30 80 00 
	return 0;
}
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	53                   	push   %ebx
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80175d:	53                   	push   %ebx
  80175e:	6a 00                	push   $0x0
  801760:	e8 e5 f5 ff ff       	call   800d4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801765:	89 1c 24             	mov    %ebx,(%esp)
  801768:	e8 78 f7 ff ff       	call   800ee5 <fd2data>
  80176d:	83 c4 08             	add    $0x8,%esp
  801770:	50                   	push   %eax
  801771:	6a 00                	push   $0x0
  801773:	e8 d2 f5 ff ff       	call   800d4a <sys_page_unmap>
}
  801778:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <_pipeisclosed>:
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	57                   	push   %edi
  801781:	56                   	push   %esi
  801782:	53                   	push   %ebx
  801783:	83 ec 1c             	sub    $0x1c,%esp
  801786:	89 c7                	mov    %eax,%edi
  801788:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80178a:	a1 08 40 80 00       	mov    0x804008,%eax
  80178f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801792:	83 ec 0c             	sub    $0xc,%esp
  801795:	57                   	push   %edi
  801796:	e8 94 09 00 00       	call   80212f <pageref>
  80179b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80179e:	89 34 24             	mov    %esi,(%esp)
  8017a1:	e8 89 09 00 00       	call   80212f <pageref>
		nn = thisenv->env_runs;
  8017a6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8017ac:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	39 cb                	cmp    %ecx,%ebx
  8017b4:	74 1b                	je     8017d1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8017b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017b9:	75 cf                	jne    80178a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017bb:	8b 42 58             	mov    0x58(%edx),%eax
  8017be:	6a 01                	push   $0x1
  8017c0:	50                   	push   %eax
  8017c1:	53                   	push   %ebx
  8017c2:	68 66 28 80 00       	push   $0x802866
  8017c7:	e8 63 ea ff ff       	call   80022f <cprintf>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	eb b9                	jmp    80178a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017d1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017d4:	0f 94 c0             	sete   %al
  8017d7:	0f b6 c0             	movzbl %al,%eax
}
  8017da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5f                   	pop    %edi
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    

008017e2 <devpipe_write>:
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	57                   	push   %edi
  8017e6:	56                   	push   %esi
  8017e7:	53                   	push   %ebx
  8017e8:	83 ec 28             	sub    $0x28,%esp
  8017eb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017ee:	56                   	push   %esi
  8017ef:	e8 f1 f6 ff ff       	call   800ee5 <fd2data>
  8017f4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8017fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801801:	74 4f                	je     801852 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801803:	8b 43 04             	mov    0x4(%ebx),%eax
  801806:	8b 0b                	mov    (%ebx),%ecx
  801808:	8d 51 20             	lea    0x20(%ecx),%edx
  80180b:	39 d0                	cmp    %edx,%eax
  80180d:	72 14                	jb     801823 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80180f:	89 da                	mov    %ebx,%edx
  801811:	89 f0                	mov    %esi,%eax
  801813:	e8 65 ff ff ff       	call   80177d <_pipeisclosed>
  801818:	85 c0                	test   %eax,%eax
  80181a:	75 3a                	jne    801856 <devpipe_write+0x74>
			sys_yield();
  80181c:	e8 85 f4 ff ff       	call   800ca6 <sys_yield>
  801821:	eb e0                	jmp    801803 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801826:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80182a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80182d:	89 c2                	mov    %eax,%edx
  80182f:	c1 fa 1f             	sar    $0x1f,%edx
  801832:	89 d1                	mov    %edx,%ecx
  801834:	c1 e9 1b             	shr    $0x1b,%ecx
  801837:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80183a:	83 e2 1f             	and    $0x1f,%edx
  80183d:	29 ca                	sub    %ecx,%edx
  80183f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801843:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801847:	83 c0 01             	add    $0x1,%eax
  80184a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80184d:	83 c7 01             	add    $0x1,%edi
  801850:	eb ac                	jmp    8017fe <devpipe_write+0x1c>
	return i;
  801852:	89 f8                	mov    %edi,%eax
  801854:	eb 05                	jmp    80185b <devpipe_write+0x79>
				return 0;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5e                   	pop    %esi
  801860:	5f                   	pop    %edi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    

00801863 <devpipe_read>:
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	57                   	push   %edi
  801867:	56                   	push   %esi
  801868:	53                   	push   %ebx
  801869:	83 ec 18             	sub    $0x18,%esp
  80186c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80186f:	57                   	push   %edi
  801870:	e8 70 f6 ff ff       	call   800ee5 <fd2data>
  801875:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	be 00 00 00 00       	mov    $0x0,%esi
  80187f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801882:	74 47                	je     8018cb <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801884:	8b 03                	mov    (%ebx),%eax
  801886:	3b 43 04             	cmp    0x4(%ebx),%eax
  801889:	75 22                	jne    8018ad <devpipe_read+0x4a>
			if (i > 0)
  80188b:	85 f6                	test   %esi,%esi
  80188d:	75 14                	jne    8018a3 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80188f:	89 da                	mov    %ebx,%edx
  801891:	89 f8                	mov    %edi,%eax
  801893:	e8 e5 fe ff ff       	call   80177d <_pipeisclosed>
  801898:	85 c0                	test   %eax,%eax
  80189a:	75 33                	jne    8018cf <devpipe_read+0x6c>
			sys_yield();
  80189c:	e8 05 f4 ff ff       	call   800ca6 <sys_yield>
  8018a1:	eb e1                	jmp    801884 <devpipe_read+0x21>
				return i;
  8018a3:	89 f0                	mov    %esi,%eax
}
  8018a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a8:	5b                   	pop    %ebx
  8018a9:	5e                   	pop    %esi
  8018aa:	5f                   	pop    %edi
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018ad:	99                   	cltd   
  8018ae:	c1 ea 1b             	shr    $0x1b,%edx
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	83 e0 1f             	and    $0x1f,%eax
  8018b6:	29 d0                	sub    %edx,%eax
  8018b8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018c3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8018c6:	83 c6 01             	add    $0x1,%esi
  8018c9:	eb b4                	jmp    80187f <devpipe_read+0x1c>
	return i;
  8018cb:	89 f0                	mov    %esi,%eax
  8018cd:	eb d6                	jmp    8018a5 <devpipe_read+0x42>
				return 0;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d4:	eb cf                	jmp    8018a5 <devpipe_read+0x42>

008018d6 <pipe>:
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	56                   	push   %esi
  8018da:	53                   	push   %ebx
  8018db:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e1:	50                   	push   %eax
  8018e2:	e8 15 f6 ff ff       	call   800efc <fd_alloc>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 5b                	js     80194b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	68 07 04 00 00       	push   $0x407
  8018f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fb:	6a 00                	push   $0x0
  8018fd:	e8 c3 f3 ff ff       	call   800cc5 <sys_page_alloc>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 40                	js     80194b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801911:	50                   	push   %eax
  801912:	e8 e5 f5 ff ff       	call   800efc <fd_alloc>
  801917:	89 c3                	mov    %eax,%ebx
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 1b                	js     80193b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	68 07 04 00 00       	push   $0x407
  801928:	ff 75 f0             	pushl  -0x10(%ebp)
  80192b:	6a 00                	push   $0x0
  80192d:	e8 93 f3 ff ff       	call   800cc5 <sys_page_alloc>
  801932:	89 c3                	mov    %eax,%ebx
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	85 c0                	test   %eax,%eax
  801939:	79 19                	jns    801954 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80193b:	83 ec 08             	sub    $0x8,%esp
  80193e:	ff 75 f4             	pushl  -0xc(%ebp)
  801941:	6a 00                	push   $0x0
  801943:	e8 02 f4 ff ff       	call   800d4a <sys_page_unmap>
  801948:	83 c4 10             	add    $0x10,%esp
}
  80194b:	89 d8                	mov    %ebx,%eax
  80194d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    
	va = fd2data(fd0);
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	ff 75 f4             	pushl  -0xc(%ebp)
  80195a:	e8 86 f5 ff ff       	call   800ee5 <fd2data>
  80195f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801961:	83 c4 0c             	add    $0xc,%esp
  801964:	68 07 04 00 00       	push   $0x407
  801969:	50                   	push   %eax
  80196a:	6a 00                	push   $0x0
  80196c:	e8 54 f3 ff ff       	call   800cc5 <sys_page_alloc>
  801971:	89 c3                	mov    %eax,%ebx
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	85 c0                	test   %eax,%eax
  801978:	0f 88 8c 00 00 00    	js     801a0a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	ff 75 f0             	pushl  -0x10(%ebp)
  801984:	e8 5c f5 ff ff       	call   800ee5 <fd2data>
  801989:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801990:	50                   	push   %eax
  801991:	6a 00                	push   $0x0
  801993:	56                   	push   %esi
  801994:	6a 00                	push   $0x0
  801996:	e8 6d f3 ff ff       	call   800d08 <sys_page_map>
  80199b:	89 c3                	mov    %eax,%ebx
  80199d:	83 c4 20             	add    $0x20,%esp
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	78 58                	js     8019fc <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8019a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8019b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8019c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019ce:	83 ec 0c             	sub    $0xc,%esp
  8019d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d4:	e8 fc f4 ff ff       	call   800ed5 <fd2num>
  8019d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019de:	83 c4 04             	add    $0x4,%esp
  8019e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e4:	e8 ec f4 ff ff       	call   800ed5 <fd2num>
  8019e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f7:	e9 4f ff ff ff       	jmp    80194b <pipe+0x75>
	sys_page_unmap(0, va);
  8019fc:	83 ec 08             	sub    $0x8,%esp
  8019ff:	56                   	push   %esi
  801a00:	6a 00                	push   $0x0
  801a02:	e8 43 f3 ff ff       	call   800d4a <sys_page_unmap>
  801a07:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801a10:	6a 00                	push   $0x0
  801a12:	e8 33 f3 ff ff       	call   800d4a <sys_page_unmap>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	e9 1c ff ff ff       	jmp    80193b <pipe+0x65>

00801a1f <pipeisclosed>:
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a28:	50                   	push   %eax
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	e8 1a f5 ff ff       	call   800f4b <fd_lookup>
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 18                	js     801a50 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a38:	83 ec 0c             	sub    $0xc,%esp
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	e8 a2 f4 ff ff       	call   800ee5 <fd2data>
	return _pipeisclosed(fd, p);
  801a43:	89 c2                	mov    %eax,%edx
  801a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a48:	e8 30 fd ff ff       	call   80177d <_pipeisclosed>
  801a4d:	83 c4 10             	add    $0x10,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a58:	68 7e 28 80 00       	push   $0x80287e
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	e8 67 ee ff ff       	call   8008cc <strcpy>
	return 0;
}
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <devsock_close>:
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	53                   	push   %ebx
  801a70:	83 ec 10             	sub    $0x10,%esp
  801a73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a76:	53                   	push   %ebx
  801a77:	e8 b3 06 00 00       	call   80212f <pageref>
  801a7c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a7f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a84:	83 f8 01             	cmp    $0x1,%eax
  801a87:	74 07                	je     801a90 <devsock_close+0x24>
}
  801a89:	89 d0                	mov    %edx,%eax
  801a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a90:	83 ec 0c             	sub    $0xc,%esp
  801a93:	ff 73 0c             	pushl  0xc(%ebx)
  801a96:	e8 b7 02 00 00       	call   801d52 <nsipc_close>
  801a9b:	89 c2                	mov    %eax,%edx
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	eb e7                	jmp    801a89 <devsock_close+0x1d>

00801aa2 <devsock_write>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 10             	pushl  0x10(%ebp)
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	ff 70 0c             	pushl  0xc(%eax)
  801ab6:	e8 74 03 00 00       	call   801e2f <nsipc_send>
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <devsock_read>:
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	ff 75 10             	pushl  0x10(%ebp)
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	ff 70 0c             	pushl  0xc(%eax)
  801ad1:	e8 ed 02 00 00       	call   801dc3 <nsipc_recv>
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <fd2sockid>:
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ade:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	e8 63 f4 ff ff       	call   800f4b <fd_lookup>
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 10                	js     801aff <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af2:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801af8:	39 08                	cmp    %ecx,(%eax)
  801afa:	75 05                	jne    801b01 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801afc:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    
		return -E_NOT_SUPP;
  801b01:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b06:	eb f7                	jmp    801aff <fd2sockid+0x27>

00801b08 <alloc_sockfd>:
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	83 ec 1c             	sub    $0x1c,%esp
  801b10:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b15:	50                   	push   %eax
  801b16:	e8 e1 f3 ff ff       	call   800efc <fd_alloc>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	78 43                	js     801b67 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b24:	83 ec 04             	sub    $0x4,%esp
  801b27:	68 07 04 00 00       	push   $0x407
  801b2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2f:	6a 00                	push   $0x0
  801b31:	e8 8f f1 ff ff       	call   800cc5 <sys_page_alloc>
  801b36:	89 c3                	mov    %eax,%ebx
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 28                	js     801b67 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b42:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b48:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b54:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	50                   	push   %eax
  801b5b:	e8 75 f3 ff ff       	call   800ed5 <fd2num>
  801b60:	89 c3                	mov    %eax,%ebx
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	eb 0c                	jmp    801b73 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b67:	83 ec 0c             	sub    $0xc,%esp
  801b6a:	56                   	push   %esi
  801b6b:	e8 e2 01 00 00       	call   801d52 <nsipc_close>
		return r;
  801b70:	83 c4 10             	add    $0x10,%esp
}
  801b73:	89 d8                	mov    %ebx,%eax
  801b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <accept>:
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	e8 4e ff ff ff       	call   801ad8 <fd2sockid>
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	78 1b                	js     801ba9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	ff 75 10             	pushl  0x10(%ebp)
  801b94:	ff 75 0c             	pushl  0xc(%ebp)
  801b97:	50                   	push   %eax
  801b98:	e8 0e 01 00 00       	call   801cab <nsipc_accept>
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	78 05                	js     801ba9 <accept+0x2d>
	return alloc_sockfd(r);
  801ba4:	e8 5f ff ff ff       	call   801b08 <alloc_sockfd>
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <bind>:
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	e8 1f ff ff ff       	call   801ad8 <fd2sockid>
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 12                	js     801bcf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	ff 75 10             	pushl  0x10(%ebp)
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	50                   	push   %eax
  801bc7:	e8 2f 01 00 00       	call   801cfb <nsipc_bind>
  801bcc:	83 c4 10             	add    $0x10,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <shutdown>:
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	e8 f9 fe ff ff       	call   801ad8 <fd2sockid>
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 0f                	js     801bf2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	50                   	push   %eax
  801bea:	e8 41 01 00 00       	call   801d30 <nsipc_shutdown>
  801bef:	83 c4 10             	add    $0x10,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <connect>:
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	e8 d6 fe ff ff       	call   801ad8 <fd2sockid>
  801c02:	85 c0                	test   %eax,%eax
  801c04:	78 12                	js     801c18 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	ff 75 10             	pushl  0x10(%ebp)
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	50                   	push   %eax
  801c10:	e8 57 01 00 00       	call   801d6c <nsipc_connect>
  801c15:	83 c4 10             	add    $0x10,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <listen>:
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	e8 b0 fe ff ff       	call   801ad8 <fd2sockid>
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 0f                	js     801c3b <listen+0x21>
	return nsipc_listen(r, backlog);
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	50                   	push   %eax
  801c33:	e8 69 01 00 00       	call   801da1 <nsipc_listen>
  801c38:	83 c4 10             	add    $0x10,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <socket>:

int
socket(int domain, int type, int protocol)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c43:	ff 75 10             	pushl  0x10(%ebp)
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	ff 75 08             	pushl  0x8(%ebp)
  801c4c:	e8 3c 02 00 00       	call   801e8d <nsipc_socket>
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	85 c0                	test   %eax,%eax
  801c56:	78 05                	js     801c5d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c58:	e8 ab fe ff ff       	call   801b08 <alloc_sockfd>
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	53                   	push   %ebx
  801c63:	83 ec 04             	sub    $0x4,%esp
  801c66:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c68:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c6f:	74 26                	je     801c97 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c71:	6a 07                	push   $0x7
  801c73:	68 00 60 80 00       	push   $0x806000
  801c78:	53                   	push   %ebx
  801c79:	ff 35 04 40 80 00    	pushl  0x804004
  801c7f:	e8 19 04 00 00       	call   80209d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c84:	83 c4 0c             	add    $0xc,%esp
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	e8 a2 03 00 00       	call   802034 <ipc_recv>
}
  801c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	6a 02                	push   $0x2
  801c9c:	e8 55 04 00 00       	call   8020f6 <ipc_find_env>
  801ca1:	a3 04 40 80 00       	mov    %eax,0x804004
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	eb c6                	jmp    801c71 <nsipc+0x12>

00801cab <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cbb:	8b 06                	mov    (%esi),%eax
  801cbd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc7:	e8 93 ff ff ff       	call   801c5f <nsipc>
  801ccc:	89 c3                	mov    %eax,%ebx
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	78 20                	js     801cf2 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	ff 35 10 60 80 00    	pushl  0x806010
  801cdb:	68 00 60 80 00       	push   $0x806000
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	e8 72 ed ff ff       	call   800a5a <memmove>
		*addrlen = ret->ret_addrlen;
  801ce8:	a1 10 60 80 00       	mov    0x806010,%eax
  801ced:	89 06                	mov    %eax,(%esi)
  801cef:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	53                   	push   %ebx
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d0d:	53                   	push   %ebx
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	68 04 60 80 00       	push   $0x806004
  801d16:	e8 3f ed ff ff       	call   800a5a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d1b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d21:	b8 02 00 00 00       	mov    $0x2,%eax
  801d26:	e8 34 ff ff ff       	call   801c5f <nsipc>
}
  801d2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d41:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d46:	b8 03 00 00 00       	mov    $0x3,%eax
  801d4b:	e8 0f ff ff ff       	call   801c5f <nsipc>
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <nsipc_close>:

int
nsipc_close(int s)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d60:	b8 04 00 00 00       	mov    $0x4,%eax
  801d65:	e8 f5 fe ff ff       	call   801c5f <nsipc>
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d7e:	53                   	push   %ebx
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	68 04 60 80 00       	push   $0x806004
  801d87:	e8 ce ec ff ff       	call   800a5a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d8c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d92:	b8 05 00 00 00       	mov    $0x5,%eax
  801d97:	e8 c3 fe ff ff       	call   801c5f <nsipc>
}
  801d9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801db7:	b8 06 00 00 00       	mov    $0x6,%eax
  801dbc:	e8 9e fe ff ff       	call   801c5f <nsipc>
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dd3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddc:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801de1:	b8 07 00 00 00       	mov    $0x7,%eax
  801de6:	e8 74 fe ff ff       	call   801c5f <nsipc>
  801deb:	89 c3                	mov    %eax,%ebx
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 1f                	js     801e10 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801df1:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801df6:	7f 21                	jg     801e19 <nsipc_recv+0x56>
  801df8:	39 c6                	cmp    %eax,%esi
  801dfa:	7c 1d                	jl     801e19 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dfc:	83 ec 04             	sub    $0x4,%esp
  801dff:	50                   	push   %eax
  801e00:	68 00 60 80 00       	push   $0x806000
  801e05:	ff 75 0c             	pushl  0xc(%ebp)
  801e08:	e8 4d ec ff ff       	call   800a5a <memmove>
  801e0d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e10:	89 d8                	mov    %ebx,%eax
  801e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e19:	68 8a 28 80 00       	push   $0x80288a
  801e1e:	68 2c 28 80 00       	push   $0x80282c
  801e23:	6a 62                	push   $0x62
  801e25:	68 9f 28 80 00       	push   $0x80289f
  801e2a:	e8 25 e3 ff ff       	call   800154 <_panic>

00801e2f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	53                   	push   %ebx
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e41:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e47:	7f 2e                	jg     801e77 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	53                   	push   %ebx
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	68 0c 60 80 00       	push   $0x80600c
  801e55:	e8 00 ec ff ff       	call   800a5a <memmove>
	nsipcbuf.send.req_size = size;
  801e5a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e60:	8b 45 14             	mov    0x14(%ebp),%eax
  801e63:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e68:	b8 08 00 00 00       	mov    $0x8,%eax
  801e6d:	e8 ed fd ff ff       	call   801c5f <nsipc>
}
  801e72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    
	assert(size < 1600);
  801e77:	68 ab 28 80 00       	push   $0x8028ab
  801e7c:	68 2c 28 80 00       	push   $0x80282c
  801e81:	6a 6d                	push   $0x6d
  801e83:	68 9f 28 80 00       	push   $0x80289f
  801e88:	e8 c7 e2 ff ff       	call   800154 <_panic>

00801e8d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9e:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801eab:	b8 09 00 00 00       	mov    $0x9,%eax
  801eb0:	e8 aa fd ff ff       	call   801c5f <nsipc>
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801eba:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ec7:	68 b7 28 80 00       	push   $0x8028b7
  801ecc:	ff 75 0c             	pushl  0xc(%ebp)
  801ecf:	e8 f8 e9 ff ff       	call   8008cc <strcpy>
	return 0;
}
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <devcons_write>:
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	57                   	push   %edi
  801edf:	56                   	push   %esi
  801ee0:	53                   	push   %ebx
  801ee1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ee7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801eec:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ef2:	eb 2f                	jmp    801f23 <devcons_write+0x48>
		m = n - tot;
  801ef4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ef7:	29 f3                	sub    %esi,%ebx
  801ef9:	83 fb 7f             	cmp    $0x7f,%ebx
  801efc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f01:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	53                   	push   %ebx
  801f08:	89 f0                	mov    %esi,%eax
  801f0a:	03 45 0c             	add    0xc(%ebp),%eax
  801f0d:	50                   	push   %eax
  801f0e:	57                   	push   %edi
  801f0f:	e8 46 eb ff ff       	call   800a5a <memmove>
		sys_cputs(buf, m);
  801f14:	83 c4 08             	add    $0x8,%esp
  801f17:	53                   	push   %ebx
  801f18:	57                   	push   %edi
  801f19:	e8 eb ec ff ff       	call   800c09 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f1e:	01 de                	add    %ebx,%esi
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f26:	72 cc                	jb     801ef4 <devcons_write+0x19>
}
  801f28:	89 f0                	mov    %esi,%eax
  801f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5f                   	pop    %edi
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    

00801f32 <devcons_read>:
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 08             	sub    $0x8,%esp
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f41:	75 07                	jne    801f4a <devcons_read+0x18>
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    
		sys_yield();
  801f45:	e8 5c ed ff ff       	call   800ca6 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f4a:	e8 d8 ec ff ff       	call   800c27 <sys_cgetc>
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 f2                	je     801f45 <devcons_read+0x13>
	if (c < 0)
  801f53:	85 c0                	test   %eax,%eax
  801f55:	78 ec                	js     801f43 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f57:	83 f8 04             	cmp    $0x4,%eax
  801f5a:	74 0c                	je     801f68 <devcons_read+0x36>
	*(char*)vbuf = c;
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	88 02                	mov    %al,(%edx)
	return 1;
  801f61:	b8 01 00 00 00       	mov    $0x1,%eax
  801f66:	eb db                	jmp    801f43 <devcons_read+0x11>
		return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6d:	eb d4                	jmp    801f43 <devcons_read+0x11>

00801f6f <cputchar>:
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f7b:	6a 01                	push   $0x1
  801f7d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f80:	50                   	push   %eax
  801f81:	e8 83 ec ff ff       	call   800c09 <sys_cputs>
}
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <getchar>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f91:	6a 01                	push   $0x1
  801f93:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f96:	50                   	push   %eax
  801f97:	6a 00                	push   $0x0
  801f99:	e8 1e f2 ff ff       	call   8011bc <read>
	if (r < 0)
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	78 08                	js     801fad <getchar+0x22>
	if (r < 1)
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	7e 06                	jle    801faf <getchar+0x24>
	return c;
  801fa9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    
		return -E_EOF;
  801faf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fb4:	eb f7                	jmp    801fad <getchar+0x22>

00801fb6 <iscons>:
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbf:	50                   	push   %eax
  801fc0:	ff 75 08             	pushl  0x8(%ebp)
  801fc3:	e8 83 ef ff ff       	call   800f4b <fd_lookup>
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 11                	js     801fe0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fd8:	39 10                	cmp    %edx,(%eax)
  801fda:	0f 94 c0             	sete   %al
  801fdd:	0f b6 c0             	movzbl %al,%eax
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <opencons>:
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fe8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801feb:	50                   	push   %eax
  801fec:	e8 0b ef ff ff       	call   800efc <fd_alloc>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 3a                	js     802032 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 07 04 00 00       	push   $0x407
  802000:	ff 75 f4             	pushl  -0xc(%ebp)
  802003:	6a 00                	push   $0x0
  802005:	e8 bb ec ff ff       	call   800cc5 <sys_page_alloc>
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 21                	js     802032 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80201a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	50                   	push   %eax
  80202a:	e8 a6 ee ff ff       	call   800ed5 <fd2num>
  80202f:	83 c4 10             	add    $0x10,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	56                   	push   %esi
  802038:	53                   	push   %ebx
  802039:	8b 75 08             	mov    0x8(%ebp),%esi
  80203c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802042:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802044:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802049:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80204c:	83 ec 0c             	sub    $0xc,%esp
  80204f:	50                   	push   %eax
  802050:	e8 20 ee ff ff       	call   800e75 <sys_ipc_recv>
  802055:	83 c4 10             	add    $0x10,%esp
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 2b                	js     802087 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80205c:	85 f6                	test   %esi,%esi
  80205e:	74 0a                	je     80206a <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802060:	a1 08 40 80 00       	mov    0x804008,%eax
  802065:	8b 40 74             	mov    0x74(%eax),%eax
  802068:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80206a:	85 db                	test   %ebx,%ebx
  80206c:	74 0a                	je     802078 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80206e:	a1 08 40 80 00       	mov    0x804008,%eax
  802073:	8b 40 78             	mov    0x78(%eax),%eax
  802076:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802078:	a1 08 40 80 00       	mov    0x804008,%eax
  80207d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802083:	5b                   	pop    %ebx
  802084:	5e                   	pop    %esi
  802085:	5d                   	pop    %ebp
  802086:	c3                   	ret    
	    if (from_env_store != NULL) {
  802087:	85 f6                	test   %esi,%esi
  802089:	74 06                	je     802091 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80208b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802091:	85 db                	test   %ebx,%ebx
  802093:	74 eb                	je     802080 <ipc_recv+0x4c>
	        *perm_store = 0;
  802095:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80209b:	eb e3                	jmp    802080 <ipc_recv+0x4c>

0080209d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	57                   	push   %edi
  8020a1:	56                   	push   %esi
  8020a2:	53                   	push   %ebx
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a9:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8020ac:	85 f6                	test   %esi,%esi
  8020ae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020b3:	0f 44 f0             	cmove  %eax,%esi
  8020b6:	eb 09                	jmp    8020c1 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8020b8:	e8 e9 eb ff ff       	call   800ca6 <sys_yield>
	} while(r != 0);
  8020bd:	85 db                	test   %ebx,%ebx
  8020bf:	74 2d                	je     8020ee <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8020c1:	ff 75 14             	pushl  0x14(%ebp)
  8020c4:	56                   	push   %esi
  8020c5:	ff 75 0c             	pushl  0xc(%ebp)
  8020c8:	57                   	push   %edi
  8020c9:	e8 84 ed ff ff       	call   800e52 <sys_ipc_try_send>
  8020ce:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	79 e1                	jns    8020b8 <ipc_send+0x1b>
  8020d7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020da:	74 dc                	je     8020b8 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8020dc:	50                   	push   %eax
  8020dd:	68 c3 28 80 00       	push   $0x8028c3
  8020e2:	6a 45                	push   $0x45
  8020e4:	68 d0 28 80 00       	push   $0x8028d0
  8020e9:	e8 66 e0 ff ff       	call   800154 <_panic>
}
  8020ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5f                   	pop    %edi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    

008020f6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802101:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802104:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80210a:	8b 52 50             	mov    0x50(%edx),%edx
  80210d:	39 ca                	cmp    %ecx,%edx
  80210f:	74 11                	je     802122 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802111:	83 c0 01             	add    $0x1,%eax
  802114:	3d 00 04 00 00       	cmp    $0x400,%eax
  802119:	75 e6                	jne    802101 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	eb 0b                	jmp    80212d <ipc_find_env+0x37>
			return envs[i].env_id;
  802122:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802125:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80212a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    

0080212f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802135:	89 d0                	mov    %edx,%eax
  802137:	c1 e8 16             	shr    $0x16,%eax
  80213a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802146:	f6 c1 01             	test   $0x1,%cl
  802149:	74 1d                	je     802168 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80214b:	c1 ea 0c             	shr    $0xc,%edx
  80214e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802155:	f6 c2 01             	test   $0x1,%dl
  802158:	74 0e                	je     802168 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80215a:	c1 ea 0c             	shr    $0xc,%edx
  80215d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802164:	ef 
  802165:	0f b7 c0             	movzwl %ax,%eax
}
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    
  80216a:	66 90                	xchg   %ax,%ax
  80216c:	66 90                	xchg   %ax,%ax
  80216e:	66 90                	xchg   %ax,%ax

00802170 <__udivdi3>:
  802170:	55                   	push   %ebp
  802171:	57                   	push   %edi
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	83 ec 1c             	sub    $0x1c,%esp
  802177:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80217b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80217f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802183:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802187:	85 d2                	test   %edx,%edx
  802189:	75 35                	jne    8021c0 <__udivdi3+0x50>
  80218b:	39 f3                	cmp    %esi,%ebx
  80218d:	0f 87 bd 00 00 00    	ja     802250 <__udivdi3+0xe0>
  802193:	85 db                	test   %ebx,%ebx
  802195:	89 d9                	mov    %ebx,%ecx
  802197:	75 0b                	jne    8021a4 <__udivdi3+0x34>
  802199:	b8 01 00 00 00       	mov    $0x1,%eax
  80219e:	31 d2                	xor    %edx,%edx
  8021a0:	f7 f3                	div    %ebx
  8021a2:	89 c1                	mov    %eax,%ecx
  8021a4:	31 d2                	xor    %edx,%edx
  8021a6:	89 f0                	mov    %esi,%eax
  8021a8:	f7 f1                	div    %ecx
  8021aa:	89 c6                	mov    %eax,%esi
  8021ac:	89 e8                	mov    %ebp,%eax
  8021ae:	89 f7                	mov    %esi,%edi
  8021b0:	f7 f1                	div    %ecx
  8021b2:	89 fa                	mov    %edi,%edx
  8021b4:	83 c4 1c             	add    $0x1c,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    
  8021bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	39 f2                	cmp    %esi,%edx
  8021c2:	77 7c                	ja     802240 <__udivdi3+0xd0>
  8021c4:	0f bd fa             	bsr    %edx,%edi
  8021c7:	83 f7 1f             	xor    $0x1f,%edi
  8021ca:	0f 84 98 00 00 00    	je     802268 <__udivdi3+0xf8>
  8021d0:	89 f9                	mov    %edi,%ecx
  8021d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021d7:	29 f8                	sub    %edi,%eax
  8021d9:	d3 e2                	shl    %cl,%edx
  8021db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021df:	89 c1                	mov    %eax,%ecx
  8021e1:	89 da                	mov    %ebx,%edx
  8021e3:	d3 ea                	shr    %cl,%edx
  8021e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021e9:	09 d1                	or     %edx,%ecx
  8021eb:	89 f2                	mov    %esi,%edx
  8021ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f1:	89 f9                	mov    %edi,%ecx
  8021f3:	d3 e3                	shl    %cl,%ebx
  8021f5:	89 c1                	mov    %eax,%ecx
  8021f7:	d3 ea                	shr    %cl,%edx
  8021f9:	89 f9                	mov    %edi,%ecx
  8021fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ff:	d3 e6                	shl    %cl,%esi
  802201:	89 eb                	mov    %ebp,%ebx
  802203:	89 c1                	mov    %eax,%ecx
  802205:	d3 eb                	shr    %cl,%ebx
  802207:	09 de                	or     %ebx,%esi
  802209:	89 f0                	mov    %esi,%eax
  80220b:	f7 74 24 08          	divl   0x8(%esp)
  80220f:	89 d6                	mov    %edx,%esi
  802211:	89 c3                	mov    %eax,%ebx
  802213:	f7 64 24 0c          	mull   0xc(%esp)
  802217:	39 d6                	cmp    %edx,%esi
  802219:	72 0c                	jb     802227 <__udivdi3+0xb7>
  80221b:	89 f9                	mov    %edi,%ecx
  80221d:	d3 e5                	shl    %cl,%ebp
  80221f:	39 c5                	cmp    %eax,%ebp
  802221:	73 5d                	jae    802280 <__udivdi3+0x110>
  802223:	39 d6                	cmp    %edx,%esi
  802225:	75 59                	jne    802280 <__udivdi3+0x110>
  802227:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80222a:	31 ff                	xor    %edi,%edi
  80222c:	89 fa                	mov    %edi,%edx
  80222e:	83 c4 1c             	add    $0x1c,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	8d 76 00             	lea    0x0(%esi),%esi
  802239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802240:	31 ff                	xor    %edi,%edi
  802242:	31 c0                	xor    %eax,%eax
  802244:	89 fa                	mov    %edi,%edx
  802246:	83 c4 1c             	add    $0x1c,%esp
  802249:	5b                   	pop    %ebx
  80224a:	5e                   	pop    %esi
  80224b:	5f                   	pop    %edi
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    
  80224e:	66 90                	xchg   %ax,%ax
  802250:	31 ff                	xor    %edi,%edi
  802252:	89 e8                	mov    %ebp,%eax
  802254:	89 f2                	mov    %esi,%edx
  802256:	f7 f3                	div    %ebx
  802258:	89 fa                	mov    %edi,%edx
  80225a:	83 c4 1c             	add    $0x1c,%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	5f                   	pop    %edi
  802260:	5d                   	pop    %ebp
  802261:	c3                   	ret    
  802262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	72 06                	jb     802272 <__udivdi3+0x102>
  80226c:	31 c0                	xor    %eax,%eax
  80226e:	39 eb                	cmp    %ebp,%ebx
  802270:	77 d2                	ja     802244 <__udivdi3+0xd4>
  802272:	b8 01 00 00 00       	mov    $0x1,%eax
  802277:	eb cb                	jmp    802244 <__udivdi3+0xd4>
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 d8                	mov    %ebx,%eax
  802282:	31 ff                	xor    %edi,%edi
  802284:	eb be                	jmp    802244 <__udivdi3+0xd4>
  802286:	66 90                	xchg   %ax,%ax
  802288:	66 90                	xchg   %ax,%ax
  80228a:	66 90                	xchg   %ax,%ax
  80228c:	66 90                	xchg   %ax,%ax
  80228e:	66 90                	xchg   %ax,%ax

00802290 <__umoddi3>:
  802290:	55                   	push   %ebp
  802291:	57                   	push   %edi
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	83 ec 1c             	sub    $0x1c,%esp
  802297:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80229b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80229f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022a7:	85 ed                	test   %ebp,%ebp
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	89 da                	mov    %ebx,%edx
  8022ad:	75 19                	jne    8022c8 <__umoddi3+0x38>
  8022af:	39 df                	cmp    %ebx,%edi
  8022b1:	0f 86 b1 00 00 00    	jbe    802368 <__umoddi3+0xd8>
  8022b7:	f7 f7                	div    %edi
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	83 c4 1c             	add    $0x1c,%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    
  8022c5:	8d 76 00             	lea    0x0(%esi),%esi
  8022c8:	39 dd                	cmp    %ebx,%ebp
  8022ca:	77 f1                	ja     8022bd <__umoddi3+0x2d>
  8022cc:	0f bd cd             	bsr    %ebp,%ecx
  8022cf:	83 f1 1f             	xor    $0x1f,%ecx
  8022d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022d6:	0f 84 b4 00 00 00    	je     802390 <__umoddi3+0x100>
  8022dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8022e1:	89 c2                	mov    %eax,%edx
  8022e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022e7:	29 c2                	sub    %eax,%edx
  8022e9:	89 c1                	mov    %eax,%ecx
  8022eb:	89 f8                	mov    %edi,%eax
  8022ed:	d3 e5                	shl    %cl,%ebp
  8022ef:	89 d1                	mov    %edx,%ecx
  8022f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022f5:	d3 e8                	shr    %cl,%eax
  8022f7:	09 c5                	or     %eax,%ebp
  8022f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022fd:	89 c1                	mov    %eax,%ecx
  8022ff:	d3 e7                	shl    %cl,%edi
  802301:	89 d1                	mov    %edx,%ecx
  802303:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802307:	89 df                	mov    %ebx,%edi
  802309:	d3 ef                	shr    %cl,%edi
  80230b:	89 c1                	mov    %eax,%ecx
  80230d:	89 f0                	mov    %esi,%eax
  80230f:	d3 e3                	shl    %cl,%ebx
  802311:	89 d1                	mov    %edx,%ecx
  802313:	89 fa                	mov    %edi,%edx
  802315:	d3 e8                	shr    %cl,%eax
  802317:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80231c:	09 d8                	or     %ebx,%eax
  80231e:	f7 f5                	div    %ebp
  802320:	d3 e6                	shl    %cl,%esi
  802322:	89 d1                	mov    %edx,%ecx
  802324:	f7 64 24 08          	mull   0x8(%esp)
  802328:	39 d1                	cmp    %edx,%ecx
  80232a:	89 c3                	mov    %eax,%ebx
  80232c:	89 d7                	mov    %edx,%edi
  80232e:	72 06                	jb     802336 <__umoddi3+0xa6>
  802330:	75 0e                	jne    802340 <__umoddi3+0xb0>
  802332:	39 c6                	cmp    %eax,%esi
  802334:	73 0a                	jae    802340 <__umoddi3+0xb0>
  802336:	2b 44 24 08          	sub    0x8(%esp),%eax
  80233a:	19 ea                	sbb    %ebp,%edx
  80233c:	89 d7                	mov    %edx,%edi
  80233e:	89 c3                	mov    %eax,%ebx
  802340:	89 ca                	mov    %ecx,%edx
  802342:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802347:	29 de                	sub    %ebx,%esi
  802349:	19 fa                	sbb    %edi,%edx
  80234b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80234f:	89 d0                	mov    %edx,%eax
  802351:	d3 e0                	shl    %cl,%eax
  802353:	89 d9                	mov    %ebx,%ecx
  802355:	d3 ee                	shr    %cl,%esi
  802357:	d3 ea                	shr    %cl,%edx
  802359:	09 f0                	or     %esi,%eax
  80235b:	83 c4 1c             	add    $0x1c,%esp
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5f                   	pop    %edi
  802361:	5d                   	pop    %ebp
  802362:	c3                   	ret    
  802363:	90                   	nop
  802364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802368:	85 ff                	test   %edi,%edi
  80236a:	89 f9                	mov    %edi,%ecx
  80236c:	75 0b                	jne    802379 <__umoddi3+0xe9>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f7                	div    %edi
  802377:	89 c1                	mov    %eax,%ecx
  802379:	89 d8                	mov    %ebx,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f1                	div    %ecx
  80237f:	89 f0                	mov    %esi,%eax
  802381:	f7 f1                	div    %ecx
  802383:	e9 31 ff ff ff       	jmp    8022b9 <__umoddi3+0x29>
  802388:	90                   	nop
  802389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802390:	39 dd                	cmp    %ebx,%ebp
  802392:	72 08                	jb     80239c <__umoddi3+0x10c>
  802394:	39 f7                	cmp    %esi,%edi
  802396:	0f 87 21 ff ff ff    	ja     8022bd <__umoddi3+0x2d>
  80239c:	89 da                	mov    %ebx,%edx
  80239e:	89 f0                	mov    %esi,%eax
  8023a0:	29 f8                	sub    %edi,%eax
  8023a2:	19 ea                	sbb    %ebp,%edx
  8023a4:	e9 14 ff ff ff       	jmp    8022bd <__umoddi3+0x2d>
