
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 20 24 80 00       	push   $0x802420
  800045:	e8 bb 01 00 00       	call   800205 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 3d 0c 00 00       	call   800c9b <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 6c 24 80 00       	push   $0x80246c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 de 07 00 00       	call   800851 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 40 24 80 00       	push   $0x802440
  800085:	6a 0e                	push   $0xe
  800087:	68 2a 24 80 00       	push   $0x80242a
  80008c:	e8 99 00 00 00       	call   80012a <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 0a 0e 00 00       	call   800eab <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 3c 24 80 00       	push   $0x80243c
  8000ae:	e8 52 01 00 00       	call   800205 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 3c 24 80 00       	push   $0x80243c
  8000c0:	e8 40 01 00 00       	call   800205 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 83 0b 00 00       	call   800c5d <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e7:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ec:	85 db                	test   %ebx,%ebx
  8000ee:	7e 07                	jle    8000f7 <libmain+0x2d>
		binaryname = argv[0];
  8000f0:	8b 06                	mov    (%esi),%eax
  8000f2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	e8 90 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800101:	e8 0a 00 00 00       	call   800110 <exit>
}
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800116:	e8 05 10 00 00       	call   801120 <close_all>
	sys_env_destroy(0);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	6a 00                	push   $0x0
  800120:	e8 f7 0a 00 00       	call   800c1c <sys_env_destroy>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	c9                   	leave  
  800129:	c3                   	ret    

0080012a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	56                   	push   %esi
  80012e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800132:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800138:	e8 20 0b 00 00       	call   800c5d <sys_getenvid>
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 0c             	pushl  0xc(%ebp)
  800143:	ff 75 08             	pushl  0x8(%ebp)
  800146:	56                   	push   %esi
  800147:	50                   	push   %eax
  800148:	68 98 24 80 00       	push   $0x802498
  80014d:	e8 b3 00 00 00       	call   800205 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800152:	83 c4 18             	add    $0x18,%esp
  800155:	53                   	push   %ebx
  800156:	ff 75 10             	pushl  0x10(%ebp)
  800159:	e8 56 00 00 00       	call   8001b4 <vcprintf>
	cprintf("\n");
  80015e:	c7 04 24 1b 29 80 00 	movl   $0x80291b,(%esp)
  800165:	e8 9b 00 00 00       	call   800205 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80016d:	cc                   	int3   
  80016e:	eb fd                	jmp    80016d <_panic+0x43>

00800170 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	53                   	push   %ebx
  800174:	83 ec 04             	sub    $0x4,%esp
  800177:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017a:	8b 13                	mov    (%ebx),%edx
  80017c:	8d 42 01             	lea    0x1(%edx),%eax
  80017f:	89 03                	mov    %eax,(%ebx)
  800181:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800184:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800188:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018d:	74 09                	je     800198 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800196:	c9                   	leave  
  800197:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	68 ff 00 00 00       	push   $0xff
  8001a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 36 0a 00 00       	call   800bdf <sys_cputs>
		b->idx = 0;
  8001a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	eb db                	jmp    80018f <putch+0x1f>

008001b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c4:	00 00 00 
	b.cnt = 0;
  8001c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d1:	ff 75 0c             	pushl  0xc(%ebp)
  8001d4:	ff 75 08             	pushl  0x8(%ebp)
  8001d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	68 70 01 80 00       	push   $0x800170
  8001e3:	e8 1a 01 00 00       	call   800302 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e8:	83 c4 08             	add    $0x8,%esp
  8001eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f7:	50                   	push   %eax
  8001f8:	e8 e2 09 00 00       	call   800bdf <sys_cputs>

	return b.cnt;
}
  8001fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020e:	50                   	push   %eax
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	e8 9d ff ff ff       	call   8001b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 1c             	sub    $0x1c,%esp
  800222:	89 c7                	mov    %eax,%edi
  800224:	89 d6                	mov    %edx,%esi
  800226:	8b 45 08             	mov    0x8(%ebp),%eax
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800232:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800240:	39 d3                	cmp    %edx,%ebx
  800242:	72 05                	jb     800249 <printnum+0x30>
  800244:	39 45 10             	cmp    %eax,0x10(%ebp)
  800247:	77 7a                	ja     8002c3 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	ff 75 18             	pushl  0x18(%ebp)
  80024f:	8b 45 14             	mov    0x14(%ebp),%eax
  800252:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800255:	53                   	push   %ebx
  800256:	ff 75 10             	pushl  0x10(%ebp)
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	ff 75 e0             	pushl  -0x20(%ebp)
  800262:	ff 75 dc             	pushl  -0x24(%ebp)
  800265:	ff 75 d8             	pushl  -0x28(%ebp)
  800268:	e8 73 1f 00 00       	call   8021e0 <__udivdi3>
  80026d:	83 c4 18             	add    $0x18,%esp
  800270:	52                   	push   %edx
  800271:	50                   	push   %eax
  800272:	89 f2                	mov    %esi,%edx
  800274:	89 f8                	mov    %edi,%eax
  800276:	e8 9e ff ff ff       	call   800219 <printnum>
  80027b:	83 c4 20             	add    $0x20,%esp
  80027e:	eb 13                	jmp    800293 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	56                   	push   %esi
  800284:	ff 75 18             	pushl  0x18(%ebp)
  800287:	ff d7                	call   *%edi
  800289:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80028c:	83 eb 01             	sub    $0x1,%ebx
  80028f:	85 db                	test   %ebx,%ebx
  800291:	7f ed                	jg     800280 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	56                   	push   %esi
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 55 20 00 00       	call   802300 <__umoddi3>
  8002ab:	83 c4 14             	add    $0x14,%esp
  8002ae:	0f be 80 bb 24 80 00 	movsbl 0x8024bb(%eax),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff d7                	call   *%edi
}
  8002b8:	83 c4 10             	add    $0x10,%esp
  8002bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002be:	5b                   	pop    %ebx
  8002bf:	5e                   	pop    %esi
  8002c0:	5f                   	pop    %edi
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    
  8002c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c6:	eb c4                	jmp    80028c <printnum+0x73>

008002c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d2:	8b 10                	mov    (%eax),%edx
  8002d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d7:	73 0a                	jae    8002e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dc:	89 08                	mov    %ecx,(%eax)
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	88 02                	mov    %al,(%edx)
}
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <printfmt>:
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ee:	50                   	push   %eax
  8002ef:	ff 75 10             	pushl  0x10(%ebp)
  8002f2:	ff 75 0c             	pushl  0xc(%ebp)
  8002f5:	ff 75 08             	pushl  0x8(%ebp)
  8002f8:	e8 05 00 00 00       	call   800302 <vprintfmt>
}
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <vprintfmt>:
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 2c             	sub    $0x2c,%esp
  80030b:	8b 75 08             	mov    0x8(%ebp),%esi
  80030e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800311:	8b 7d 10             	mov    0x10(%ebp),%edi
  800314:	e9 21 04 00 00       	jmp    80073a <vprintfmt+0x438>
		padc = ' ';
  800319:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80031d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800324:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80032b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8d 47 01             	lea    0x1(%edi),%eax
  80033a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033d:	0f b6 17             	movzbl (%edi),%edx
  800340:	8d 42 dd             	lea    -0x23(%edx),%eax
  800343:	3c 55                	cmp    $0x55,%al
  800345:	0f 87 90 04 00 00    	ja     8007db <vprintfmt+0x4d9>
  80034b:	0f b6 c0             	movzbl %al,%eax
  80034e:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800358:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80035c:	eb d9                	jmp    800337 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800361:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800365:	eb d0                	jmp    800337 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800367:	0f b6 d2             	movzbl %dl,%edx
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80036d:	b8 00 00 00 00       	mov    $0x0,%eax
  800372:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800375:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800378:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80037c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80037f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800382:	83 f9 09             	cmp    $0x9,%ecx
  800385:	77 55                	ja     8003dc <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800387:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038a:	eb e9                	jmp    800375 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8d 40 04             	lea    0x4(%eax),%eax
  80039a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a4:	79 91                	jns    800337 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ac:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b3:	eb 82                	jmp    800337 <vprintfmt+0x35>
  8003b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bf:	0f 49 d0             	cmovns %eax,%edx
  8003c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c8:	e9 6a ff ff ff       	jmp    800337 <vprintfmt+0x35>
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d7:	e9 5b ff ff ff       	jmp    800337 <vprintfmt+0x35>
  8003dc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e2:	eb bc                	jmp    8003a0 <vprintfmt+0x9e>
			lflag++;
  8003e4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ea:	e9 48 ff ff ff       	jmp    800337 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8d 78 04             	lea    0x4(%eax),%edi
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	53                   	push   %ebx
  8003f9:	ff 30                	pushl  (%eax)
  8003fb:	ff d6                	call   *%esi
			break;
  8003fd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800400:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800403:	e9 2f 03 00 00       	jmp    800737 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	8d 78 04             	lea    0x4(%eax),%edi
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	99                   	cltd   
  800411:	31 d0                	xor    %edx,%eax
  800413:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800415:	83 f8 0f             	cmp    $0xf,%eax
  800418:	7f 23                	jg     80043d <vprintfmt+0x13b>
  80041a:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  800421:	85 d2                	test   %edx,%edx
  800423:	74 18                	je     80043d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800425:	52                   	push   %edx
  800426:	68 e2 28 80 00       	push   $0x8028e2
  80042b:	53                   	push   %ebx
  80042c:	56                   	push   %esi
  80042d:	e8 b3 fe ff ff       	call   8002e5 <printfmt>
  800432:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800435:	89 7d 14             	mov    %edi,0x14(%ebp)
  800438:	e9 fa 02 00 00       	jmp    800737 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80043d:	50                   	push   %eax
  80043e:	68 d3 24 80 00       	push   $0x8024d3
  800443:	53                   	push   %ebx
  800444:	56                   	push   %esi
  800445:	e8 9b fe ff ff       	call   8002e5 <printfmt>
  80044a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800450:	e9 e2 02 00 00       	jmp    800737 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	83 c0 04             	add    $0x4,%eax
  80045b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800463:	85 ff                	test   %edi,%edi
  800465:	b8 cc 24 80 00       	mov    $0x8024cc,%eax
  80046a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80046d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800471:	0f 8e bd 00 00 00    	jle    800534 <vprintfmt+0x232>
  800477:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80047b:	75 0e                	jne    80048b <vprintfmt+0x189>
  80047d:	89 75 08             	mov    %esi,0x8(%ebp)
  800480:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800483:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800486:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800489:	eb 6d                	jmp    8004f8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	ff 75 d0             	pushl  -0x30(%ebp)
  800491:	57                   	push   %edi
  800492:	e8 ec 03 00 00       	call   800883 <strnlen>
  800497:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049a:	29 c1                	sub    %eax,%ecx
  80049c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80049f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ac:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ae:	eb 0f                	jmp    8004bf <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	53                   	push   %ebx
  8004b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ef 01             	sub    $0x1,%edi
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 ff                	test   %edi,%edi
  8004c1:	7f ed                	jg     8004b0 <vprintfmt+0x1ae>
  8004c3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004c9:	85 c9                	test   %ecx,%ecx
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 49 c1             	cmovns %ecx,%eax
  8004d3:	29 c1                	sub    %eax,%ecx
  8004d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004db:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004de:	89 cb                	mov    %ecx,%ebx
  8004e0:	eb 16                	jmp    8004f8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e6:	75 31                	jne    800519 <vprintfmt+0x217>
					putch(ch, putdat);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	50                   	push   %eax
  8004ef:	ff 55 08             	call   *0x8(%ebp)
  8004f2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 eb 01             	sub    $0x1,%ebx
  8004f8:	83 c7 01             	add    $0x1,%edi
  8004fb:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ff:	0f be c2             	movsbl %dl,%eax
  800502:	85 c0                	test   %eax,%eax
  800504:	74 59                	je     80055f <vprintfmt+0x25d>
  800506:	85 f6                	test   %esi,%esi
  800508:	78 d8                	js     8004e2 <vprintfmt+0x1e0>
  80050a:	83 ee 01             	sub    $0x1,%esi
  80050d:	79 d3                	jns    8004e2 <vprintfmt+0x1e0>
  80050f:	89 df                	mov    %ebx,%edi
  800511:	8b 75 08             	mov    0x8(%ebp),%esi
  800514:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800517:	eb 37                	jmp    800550 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800519:	0f be d2             	movsbl %dl,%edx
  80051c:	83 ea 20             	sub    $0x20,%edx
  80051f:	83 fa 5e             	cmp    $0x5e,%edx
  800522:	76 c4                	jbe    8004e8 <vprintfmt+0x1e6>
					putch('?', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	6a 3f                	push   $0x3f
  80052c:	ff 55 08             	call   *0x8(%ebp)
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	eb c1                	jmp    8004f5 <vprintfmt+0x1f3>
  800534:	89 75 08             	mov    %esi,0x8(%ebp)
  800537:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800540:	eb b6                	jmp    8004f8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	6a 20                	push   $0x20
  800548:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054a:	83 ef 01             	sub    $0x1,%edi
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	85 ff                	test   %edi,%edi
  800552:	7f ee                	jg     800542 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	e9 d8 01 00 00       	jmp    800737 <vprintfmt+0x435>
  80055f:	89 df                	mov    %ebx,%edi
  800561:	8b 75 08             	mov    0x8(%ebp),%esi
  800564:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800567:	eb e7                	jmp    800550 <vprintfmt+0x24e>
	if (lflag >= 2)
  800569:	83 f9 01             	cmp    $0x1,%ecx
  80056c:	7e 45                	jle    8005b3 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8b 50 04             	mov    0x4(%eax),%edx
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 08             	lea    0x8(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800585:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800589:	79 62                	jns    8005ed <vprintfmt+0x2eb>
				putch('-', putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	53                   	push   %ebx
  80058f:	6a 2d                	push   $0x2d
  800591:	ff d6                	call   *%esi
				num = -(long long) num;
  800593:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800596:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800599:	f7 d8                	neg    %eax
  80059b:	83 d2 00             	adc    $0x0,%edx
  80059e:	f7 da                	neg    %edx
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005ae:	e9 66 01 00 00       	jmp    800719 <vprintfmt+0x417>
	else if (lflag)
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	75 1b                	jne    8005d2 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	eb b3                	jmp    800585 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005da:	89 c1                	mov    %eax,%ecx
  8005dc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005df:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb 98                	jmp    800585 <vprintfmt+0x283>
			base = 10;
  8005ed:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005f2:	e9 22 01 00 00       	jmp    800719 <vprintfmt+0x417>
	if (lflag >= 2)
  8005f7:	83 f9 01             	cmp    $0x1,%ecx
  8005fa:	7e 21                	jle    80061d <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 50 04             	mov    0x4(%eax),%edx
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800607:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8d 40 08             	lea    0x8(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800613:	ba 0a 00 00 00       	mov    $0xa,%edx
  800618:	e9 fc 00 00 00       	jmp    800719 <vprintfmt+0x417>
	else if (lflag)
  80061d:	85 c9                	test   %ecx,%ecx
  80061f:	75 23                	jne    800644 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	ba 00 00 00 00       	mov    $0x0,%edx
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 40 04             	lea    0x4(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80063f:	e9 d5 00 00 00       	jmp    800719 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 40 04             	lea    0x4(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800662:	e9 b2 00 00 00       	jmp    800719 <vprintfmt+0x417>
	if (lflag >= 2)
  800667:	83 f9 01             	cmp    $0x1,%ecx
  80066a:	7e 42                	jle    8006ae <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 50 04             	mov    0x4(%eax),%edx
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 08             	lea    0x8(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800683:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800688:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068c:	0f 89 87 00 00 00    	jns    800719 <vprintfmt+0x417>
				putch('-', putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	6a 2d                	push   $0x2d
  800698:	ff d6                	call   *%esi
				num = -(long long) num;
  80069a:	f7 5d d8             	negl   -0x28(%ebp)
  80069d:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8006a1:	f7 5d dc             	negl   -0x24(%ebp)
  8006a4:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006a7:	ba 08 00 00 00       	mov    $0x8,%edx
  8006ac:	eb 6b                	jmp    800719 <vprintfmt+0x417>
	else if (lflag)
  8006ae:	85 c9                	test   %ecx,%ecx
  8006b0:	75 1b                	jne    8006cd <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cb:	eb b6                	jmp    800683 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e6:	eb 9b                	jmp    800683 <vprintfmt+0x381>
			putch('0', putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	53                   	push   %ebx
  8006ec:	6a 30                	push   $0x30
  8006ee:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f0:	83 c4 08             	add    $0x8,%esp
  8006f3:	53                   	push   %ebx
  8006f4:	6a 78                	push   $0x78
  8006f6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800702:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800705:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800708:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800714:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800719:	83 ec 0c             	sub    $0xc,%esp
  80071c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800720:	50                   	push   %eax
  800721:	ff 75 e0             	pushl  -0x20(%ebp)
  800724:	52                   	push   %edx
  800725:	ff 75 dc             	pushl  -0x24(%ebp)
  800728:	ff 75 d8             	pushl  -0x28(%ebp)
  80072b:	89 da                	mov    %ebx,%edx
  80072d:	89 f0                	mov    %esi,%eax
  80072f:	e8 e5 fa ff ff       	call   800219 <printnum>
			break;
  800734:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800737:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073a:	83 c7 01             	add    $0x1,%edi
  80073d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800741:	83 f8 25             	cmp    $0x25,%eax
  800744:	0f 84 cf fb ff ff    	je     800319 <vprintfmt+0x17>
			if (ch == '\0')
  80074a:	85 c0                	test   %eax,%eax
  80074c:	0f 84 a9 00 00 00    	je     8007fb <vprintfmt+0x4f9>
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	50                   	push   %eax
  800757:	ff d6                	call   *%esi
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	eb dc                	jmp    80073a <vprintfmt+0x438>
	if (lflag >= 2)
  80075e:	83 f9 01             	cmp    $0x1,%ecx
  800761:	7e 1e                	jle    800781 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 50 04             	mov    0x4(%eax),%edx
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8d 40 08             	lea    0x8(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077a:	ba 10 00 00 00       	mov    $0x10,%edx
  80077f:	eb 98                	jmp    800719 <vprintfmt+0x417>
	else if (lflag)
  800781:	85 c9                	test   %ecx,%ecx
  800783:	75 23                	jne    8007a8 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	ba 00 00 00 00       	mov    $0x0,%edx
  80078f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800792:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 40 04             	lea    0x4(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079e:	ba 10 00 00 00       	mov    $0x10,%edx
  8007a3:	e9 71 ff ff ff       	jmp    800719 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c1:	ba 10 00 00 00       	mov    $0x10,%edx
  8007c6:	e9 4e ff ff ff       	jmp    800719 <vprintfmt+0x417>
			putch(ch, putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	6a 25                	push   $0x25
  8007d1:	ff d6                	call   *%esi
			break;
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	e9 5c ff ff ff       	jmp    800737 <vprintfmt+0x435>
			putch('%', putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	53                   	push   %ebx
  8007df:	6a 25                	push   $0x25
  8007e1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	89 f8                	mov    %edi,%eax
  8007e8:	eb 03                	jmp    8007ed <vprintfmt+0x4eb>
  8007ea:	83 e8 01             	sub    $0x1,%eax
  8007ed:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007f1:	75 f7                	jne    8007ea <vprintfmt+0x4e8>
  8007f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f6:	e9 3c ff ff ff       	jmp    800737 <vprintfmt+0x435>
}
  8007fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007fe:	5b                   	pop    %ebx
  8007ff:	5e                   	pop    %esi
  800800:	5f                   	pop    %edi
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 18             	sub    $0x18,%esp
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80080f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800812:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800816:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800819:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800820:	85 c0                	test   %eax,%eax
  800822:	74 26                	je     80084a <vsnprintf+0x47>
  800824:	85 d2                	test   %edx,%edx
  800826:	7e 22                	jle    80084a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800828:	ff 75 14             	pushl  0x14(%ebp)
  80082b:	ff 75 10             	pushl  0x10(%ebp)
  80082e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800831:	50                   	push   %eax
  800832:	68 c8 02 80 00       	push   $0x8002c8
  800837:	e8 c6 fa ff ff       	call   800302 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80083c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800845:	83 c4 10             	add    $0x10,%esp
}
  800848:	c9                   	leave  
  800849:	c3                   	ret    
		return -E_INVAL;
  80084a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084f:	eb f7                	jmp    800848 <vsnprintf+0x45>

00800851 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800857:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80085a:	50                   	push   %eax
  80085b:	ff 75 10             	pushl  0x10(%ebp)
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	ff 75 08             	pushl  0x8(%ebp)
  800864:	e8 9a ff ff ff       	call   800803 <vsnprintf>
	va_end(ap);

	return rc;
}
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
  800876:	eb 03                	jmp    80087b <strlen+0x10>
		n++;
  800878:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80087b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80087f:	75 f7                	jne    800878 <strlen+0xd>
	return n;
}
  800881:	5d                   	pop    %ebp
  800882:	c3                   	ret    

00800883 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800889:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088c:	b8 00 00 00 00       	mov    $0x0,%eax
  800891:	eb 03                	jmp    800896 <strnlen+0x13>
		n++;
  800893:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800896:	39 d0                	cmp    %edx,%eax
  800898:	74 06                	je     8008a0 <strnlen+0x1d>
  80089a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80089e:	75 f3                	jne    800893 <strnlen+0x10>
	return n;
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ac:	89 c2                	mov    %eax,%edx
  8008ae:	83 c1 01             	add    $0x1,%ecx
  8008b1:	83 c2 01             	add    $0x1,%edx
  8008b4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008b8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008bb:	84 db                	test   %bl,%bl
  8008bd:	75 ef                	jne    8008ae <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008bf:	5b                   	pop    %ebx
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	53                   	push   %ebx
  8008c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c9:	53                   	push   %ebx
  8008ca:	e8 9c ff ff ff       	call   80086b <strlen>
  8008cf:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	01 d8                	add    %ebx,%eax
  8008d7:	50                   	push   %eax
  8008d8:	e8 c5 ff ff ff       	call   8008a2 <strcpy>
	return dst;
}
  8008dd:	89 d8                	mov    %ebx,%eax
  8008df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ef:	89 f3                	mov    %esi,%ebx
  8008f1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f4:	89 f2                	mov    %esi,%edx
  8008f6:	eb 0f                	jmp    800907 <strncpy+0x23>
		*dst++ = *src;
  8008f8:	83 c2 01             	add    $0x1,%edx
  8008fb:	0f b6 01             	movzbl (%ecx),%eax
  8008fe:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800901:	80 39 01             	cmpb   $0x1,(%ecx)
  800904:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800907:	39 da                	cmp    %ebx,%edx
  800909:	75 ed                	jne    8008f8 <strncpy+0x14>
	}
	return ret;
}
  80090b:	89 f0                	mov    %esi,%eax
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	56                   	push   %esi
  800915:	53                   	push   %ebx
  800916:	8b 75 08             	mov    0x8(%ebp),%esi
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80091f:	89 f0                	mov    %esi,%eax
  800921:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800925:	85 c9                	test   %ecx,%ecx
  800927:	75 0b                	jne    800934 <strlcpy+0x23>
  800929:	eb 17                	jmp    800942 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80092b:	83 c2 01             	add    $0x1,%edx
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800934:	39 d8                	cmp    %ebx,%eax
  800936:	74 07                	je     80093f <strlcpy+0x2e>
  800938:	0f b6 0a             	movzbl (%edx),%ecx
  80093b:	84 c9                	test   %cl,%cl
  80093d:	75 ec                	jne    80092b <strlcpy+0x1a>
		*dst = '\0';
  80093f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800942:	29 f0                	sub    %esi,%eax
}
  800944:	5b                   	pop    %ebx
  800945:	5e                   	pop    %esi
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800951:	eb 06                	jmp    800959 <strcmp+0x11>
		p++, q++;
  800953:	83 c1 01             	add    $0x1,%ecx
  800956:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800959:	0f b6 01             	movzbl (%ecx),%eax
  80095c:	84 c0                	test   %al,%al
  80095e:	74 04                	je     800964 <strcmp+0x1c>
  800960:	3a 02                	cmp    (%edx),%al
  800962:	74 ef                	je     800953 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800964:	0f b6 c0             	movzbl %al,%eax
  800967:	0f b6 12             	movzbl (%edx),%edx
  80096a:	29 d0                	sub    %edx,%eax
}
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	53                   	push   %ebx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 55 0c             	mov    0xc(%ebp),%edx
  800978:	89 c3                	mov    %eax,%ebx
  80097a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80097d:	eb 06                	jmp    800985 <strncmp+0x17>
		n--, p++, q++;
  80097f:	83 c0 01             	add    $0x1,%eax
  800982:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800985:	39 d8                	cmp    %ebx,%eax
  800987:	74 16                	je     80099f <strncmp+0x31>
  800989:	0f b6 08             	movzbl (%eax),%ecx
  80098c:	84 c9                	test   %cl,%cl
  80098e:	74 04                	je     800994 <strncmp+0x26>
  800990:	3a 0a                	cmp    (%edx),%cl
  800992:	74 eb                	je     80097f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800994:	0f b6 00             	movzbl (%eax),%eax
  800997:	0f b6 12             	movzbl (%edx),%edx
  80099a:	29 d0                	sub    %edx,%eax
}
  80099c:	5b                   	pop    %ebx
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    
		return 0;
  80099f:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a4:	eb f6                	jmp    80099c <strncmp+0x2e>

008009a6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b0:	0f b6 10             	movzbl (%eax),%edx
  8009b3:	84 d2                	test   %dl,%dl
  8009b5:	74 09                	je     8009c0 <strchr+0x1a>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	74 0a                	je     8009c5 <strchr+0x1f>
	for (; *s; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	eb f0                	jmp    8009b0 <strchr+0xa>
			return (char *) s;
	return 0;
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d1:	eb 03                	jmp    8009d6 <strfind+0xf>
  8009d3:	83 c0 01             	add    $0x1,%eax
  8009d6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009d9:	38 ca                	cmp    %cl,%dl
  8009db:	74 04                	je     8009e1 <strfind+0x1a>
  8009dd:	84 d2                	test   %dl,%dl
  8009df:	75 f2                	jne    8009d3 <strfind+0xc>
			break;
	return (char *) s;
}
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	57                   	push   %edi
  8009e7:	56                   	push   %esi
  8009e8:	53                   	push   %ebx
  8009e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ef:	85 c9                	test   %ecx,%ecx
  8009f1:	74 13                	je     800a06 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f3:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009f9:	75 05                	jne    800a00 <memset+0x1d>
  8009fb:	f6 c1 03             	test   $0x3,%cl
  8009fe:	74 0d                	je     800a0d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	fc                   	cld    
  800a04:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a06:	89 f8                	mov    %edi,%eax
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5f                   	pop    %edi
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    
		c &= 0xFF;
  800a0d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a11:	89 d3                	mov    %edx,%ebx
  800a13:	c1 e3 08             	shl    $0x8,%ebx
  800a16:	89 d0                	mov    %edx,%eax
  800a18:	c1 e0 18             	shl    $0x18,%eax
  800a1b:	89 d6                	mov    %edx,%esi
  800a1d:	c1 e6 10             	shl    $0x10,%esi
  800a20:	09 f0                	or     %esi,%eax
  800a22:	09 c2                	or     %eax,%edx
  800a24:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a26:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a29:	89 d0                	mov    %edx,%eax
  800a2b:	fc                   	cld    
  800a2c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a2e:	eb d6                	jmp    800a06 <memset+0x23>

00800a30 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	57                   	push   %edi
  800a34:	56                   	push   %esi
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a3e:	39 c6                	cmp    %eax,%esi
  800a40:	73 35                	jae    800a77 <memmove+0x47>
  800a42:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a45:	39 c2                	cmp    %eax,%edx
  800a47:	76 2e                	jbe    800a77 <memmove+0x47>
		s += n;
		d += n;
  800a49:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4c:	89 d6                	mov    %edx,%esi
  800a4e:	09 fe                	or     %edi,%esi
  800a50:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a56:	74 0c                	je     800a64 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a58:	83 ef 01             	sub    $0x1,%edi
  800a5b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a5e:	fd                   	std    
  800a5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a61:	fc                   	cld    
  800a62:	eb 21                	jmp    800a85 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a64:	f6 c1 03             	test   $0x3,%cl
  800a67:	75 ef                	jne    800a58 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a69:	83 ef 04             	sub    $0x4,%edi
  800a6c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a6f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a72:	fd                   	std    
  800a73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a75:	eb ea                	jmp    800a61 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a77:	89 f2                	mov    %esi,%edx
  800a79:	09 c2                	or     %eax,%edx
  800a7b:	f6 c2 03             	test   $0x3,%dl
  800a7e:	74 09                	je     800a89 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a80:	89 c7                	mov    %eax,%edi
  800a82:	fc                   	cld    
  800a83:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a85:	5e                   	pop    %esi
  800a86:	5f                   	pop    %edi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a89:	f6 c1 03             	test   $0x3,%cl
  800a8c:	75 f2                	jne    800a80 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a8e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a91:	89 c7                	mov    %eax,%edi
  800a93:	fc                   	cld    
  800a94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a96:	eb ed                	jmp    800a85 <memmove+0x55>

00800a98 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a9b:	ff 75 10             	pushl  0x10(%ebp)
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 08             	pushl  0x8(%ebp)
  800aa4:	e8 87 ff ff ff       	call   800a30 <memmove>
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	56                   	push   %esi
  800aaf:	53                   	push   %ebx
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab6:	89 c6                	mov    %eax,%esi
  800ab8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abb:	39 f0                	cmp    %esi,%eax
  800abd:	74 1c                	je     800adb <memcmp+0x30>
		if (*s1 != *s2)
  800abf:	0f b6 08             	movzbl (%eax),%ecx
  800ac2:	0f b6 1a             	movzbl (%edx),%ebx
  800ac5:	38 d9                	cmp    %bl,%cl
  800ac7:	75 08                	jne    800ad1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ac9:	83 c0 01             	add    $0x1,%eax
  800acc:	83 c2 01             	add    $0x1,%edx
  800acf:	eb ea                	jmp    800abb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ad1:	0f b6 c1             	movzbl %cl,%eax
  800ad4:	0f b6 db             	movzbl %bl,%ebx
  800ad7:	29 d8                	sub    %ebx,%eax
  800ad9:	eb 05                	jmp    800ae0 <memcmp+0x35>
	}

	return 0;
  800adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aed:	89 c2                	mov    %eax,%edx
  800aef:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af2:	39 d0                	cmp    %edx,%eax
  800af4:	73 09                	jae    800aff <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af6:	38 08                	cmp    %cl,(%eax)
  800af8:	74 05                	je     800aff <memfind+0x1b>
	for (; s < ends; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	eb f3                	jmp    800af2 <memfind+0xe>
			break;
	return (void *) s;
}
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	57                   	push   %edi
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0d:	eb 03                	jmp    800b12 <strtol+0x11>
		s++;
  800b0f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b12:	0f b6 01             	movzbl (%ecx),%eax
  800b15:	3c 20                	cmp    $0x20,%al
  800b17:	74 f6                	je     800b0f <strtol+0xe>
  800b19:	3c 09                	cmp    $0x9,%al
  800b1b:	74 f2                	je     800b0f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b1d:	3c 2b                	cmp    $0x2b,%al
  800b1f:	74 2e                	je     800b4f <strtol+0x4e>
	int neg = 0;
  800b21:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b26:	3c 2d                	cmp    $0x2d,%al
  800b28:	74 2f                	je     800b59 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b30:	75 05                	jne    800b37 <strtol+0x36>
  800b32:	80 39 30             	cmpb   $0x30,(%ecx)
  800b35:	74 2c                	je     800b63 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b37:	85 db                	test   %ebx,%ebx
  800b39:	75 0a                	jne    800b45 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b3b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b40:	80 39 30             	cmpb   $0x30,(%ecx)
  800b43:	74 28                	je     800b6d <strtol+0x6c>
		base = 10;
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b4d:	eb 50                	jmp    800b9f <strtol+0x9e>
		s++;
  800b4f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b52:	bf 00 00 00 00       	mov    $0x0,%edi
  800b57:	eb d1                	jmp    800b2a <strtol+0x29>
		s++, neg = 1;
  800b59:	83 c1 01             	add    $0x1,%ecx
  800b5c:	bf 01 00 00 00       	mov    $0x1,%edi
  800b61:	eb c7                	jmp    800b2a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b63:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b67:	74 0e                	je     800b77 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b69:	85 db                	test   %ebx,%ebx
  800b6b:	75 d8                	jne    800b45 <strtol+0x44>
		s++, base = 8;
  800b6d:	83 c1 01             	add    $0x1,%ecx
  800b70:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b75:	eb ce                	jmp    800b45 <strtol+0x44>
		s += 2, base = 16;
  800b77:	83 c1 02             	add    $0x2,%ecx
  800b7a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b7f:	eb c4                	jmp    800b45 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b81:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b84:	89 f3                	mov    %esi,%ebx
  800b86:	80 fb 19             	cmp    $0x19,%bl
  800b89:	77 29                	ja     800bb4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b8b:	0f be d2             	movsbl %dl,%edx
  800b8e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b91:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b94:	7d 30                	jge    800bc6 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b96:	83 c1 01             	add    $0x1,%ecx
  800b99:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b9d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b9f:	0f b6 11             	movzbl (%ecx),%edx
  800ba2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ba5:	89 f3                	mov    %esi,%ebx
  800ba7:	80 fb 09             	cmp    $0x9,%bl
  800baa:	77 d5                	ja     800b81 <strtol+0x80>
			dig = *s - '0';
  800bac:	0f be d2             	movsbl %dl,%edx
  800baf:	83 ea 30             	sub    $0x30,%edx
  800bb2:	eb dd                	jmp    800b91 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bb4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bb7:	89 f3                	mov    %esi,%ebx
  800bb9:	80 fb 19             	cmp    $0x19,%bl
  800bbc:	77 08                	ja     800bc6 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bbe:	0f be d2             	movsbl %dl,%edx
  800bc1:	83 ea 37             	sub    $0x37,%edx
  800bc4:	eb cb                	jmp    800b91 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bca:	74 05                	je     800bd1 <strtol+0xd0>
		*endptr = (char *) s;
  800bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcf:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bd1:	89 c2                	mov    %eax,%edx
  800bd3:	f7 da                	neg    %edx
  800bd5:	85 ff                	test   %edi,%edi
  800bd7:	0f 45 c2             	cmovne %edx,%eax
}
  800bda:	5b                   	pop    %ebx
  800bdb:	5e                   	pop    %esi
  800bdc:	5f                   	pop    %edi
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	57                   	push   %edi
  800be3:	56                   	push   %esi
  800be4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	8b 55 08             	mov    0x8(%ebp),%edx
  800bed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf0:	89 c3                	mov    %eax,%ebx
  800bf2:	89 c7                	mov    %eax,%edi
  800bf4:	89 c6                	mov    %eax,%esi
  800bf6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf8:	5b                   	pop    %ebx
  800bf9:	5e                   	pop    %esi
  800bfa:	5f                   	pop    %edi
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    

00800bfd <sys_cgetc>:

int
sys_cgetc(void)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	57                   	push   %edi
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c03:	ba 00 00 00 00       	mov    $0x0,%edx
  800c08:	b8 01 00 00 00       	mov    $0x1,%eax
  800c0d:	89 d1                	mov    %edx,%ecx
  800c0f:	89 d3                	mov    %edx,%ebx
  800c11:	89 d7                	mov    %edx,%edi
  800c13:	89 d6                	mov    %edx,%esi
  800c15:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c32:	89 cb                	mov    %ecx,%ebx
  800c34:	89 cf                	mov    %ecx,%edi
  800c36:	89 ce                	mov    %ecx,%esi
  800c38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3a:	85 c0                	test   %eax,%eax
  800c3c:	7f 08                	jg     800c46 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c41:	5b                   	pop    %ebx
  800c42:	5e                   	pop    %esi
  800c43:	5f                   	pop    %edi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	50                   	push   %eax
  800c4a:	6a 03                	push   $0x3
  800c4c:	68 bf 27 80 00       	push   $0x8027bf
  800c51:	6a 23                	push   $0x23
  800c53:	68 dc 27 80 00       	push   $0x8027dc
  800c58:	e8 cd f4 ff ff       	call   80012a <_panic>

00800c5d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	57                   	push   %edi
  800c61:	56                   	push   %esi
  800c62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c63:	ba 00 00 00 00       	mov    $0x0,%edx
  800c68:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6d:	89 d1                	mov    %edx,%ecx
  800c6f:	89 d3                	mov    %edx,%ebx
  800c71:	89 d7                	mov    %edx,%edi
  800c73:	89 d6                	mov    %edx,%esi
  800c75:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c77:	5b                   	pop    %ebx
  800c78:	5e                   	pop    %esi
  800c79:	5f                   	pop    %edi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <sys_yield>:

void
sys_yield(void)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	57                   	push   %edi
  800c80:	56                   	push   %esi
  800c81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c82:	ba 00 00 00 00       	mov    $0x0,%edx
  800c87:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8c:	89 d1                	mov    %edx,%ecx
  800c8e:	89 d3                	mov    %edx,%ebx
  800c90:	89 d7                	mov    %edx,%edi
  800c92:	89 d6                	mov    %edx,%esi
  800c94:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	be 00 00 00 00       	mov    $0x0,%esi
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb7:	89 f7                	mov    %esi,%edi
  800cb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	50                   	push   %eax
  800ccb:	6a 04                	push   $0x4
  800ccd:	68 bf 27 80 00       	push   $0x8027bf
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 dc 27 80 00       	push   $0x8027dc
  800cd9:	e8 4c f4 ff ff       	call   80012a <_panic>

00800cde <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ced:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf8:	8b 75 18             	mov    0x18(%ebp),%esi
  800cfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	7f 08                	jg     800d09 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d09:	83 ec 0c             	sub    $0xc,%esp
  800d0c:	50                   	push   %eax
  800d0d:	6a 05                	push   $0x5
  800d0f:	68 bf 27 80 00       	push   $0x8027bf
  800d14:	6a 23                	push   $0x23
  800d16:	68 dc 27 80 00       	push   $0x8027dc
  800d1b:	e8 0a f4 ff ff       	call   80012a <_panic>

00800d20 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
  800d26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d34:	b8 06 00 00 00       	mov    $0x6,%eax
  800d39:	89 df                	mov    %ebx,%edi
  800d3b:	89 de                	mov    %ebx,%esi
  800d3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	7f 08                	jg     800d4b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4b:	83 ec 0c             	sub    $0xc,%esp
  800d4e:	50                   	push   %eax
  800d4f:	6a 06                	push   $0x6
  800d51:	68 bf 27 80 00       	push   $0x8027bf
  800d56:	6a 23                	push   $0x23
  800d58:	68 dc 27 80 00       	push   $0x8027dc
  800d5d:	e8 c8 f3 ff ff       	call   80012a <_panic>

00800d62 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d76:	b8 08 00 00 00       	mov    $0x8,%eax
  800d7b:	89 df                	mov    %ebx,%edi
  800d7d:	89 de                	mov    %ebx,%esi
  800d7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	7f 08                	jg     800d8d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8d:	83 ec 0c             	sub    $0xc,%esp
  800d90:	50                   	push   %eax
  800d91:	6a 08                	push   $0x8
  800d93:	68 bf 27 80 00       	push   $0x8027bf
  800d98:	6a 23                	push   $0x23
  800d9a:	68 dc 27 80 00       	push   $0x8027dc
  800d9f:	e8 86 f3 ff ff       	call   80012a <_panic>

00800da4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
  800daa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	b8 09 00 00 00       	mov    $0x9,%eax
  800dbd:	89 df                	mov    %ebx,%edi
  800dbf:	89 de                	mov    %ebx,%esi
  800dc1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	7f 08                	jg     800dcf <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	50                   	push   %eax
  800dd3:	6a 09                	push   $0x9
  800dd5:	68 bf 27 80 00       	push   $0x8027bf
  800dda:	6a 23                	push   $0x23
  800ddc:	68 dc 27 80 00       	push   $0x8027dc
  800de1:	e8 44 f3 ff ff       	call   80012a <_panic>

00800de6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
  800dec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800def:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dff:	89 df                	mov    %ebx,%edi
  800e01:	89 de                	mov    %ebx,%esi
  800e03:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e05:	85 c0                	test   %eax,%eax
  800e07:	7f 08                	jg     800e11 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0c:	5b                   	pop    %ebx
  800e0d:	5e                   	pop    %esi
  800e0e:	5f                   	pop    %edi
  800e0f:	5d                   	pop    %ebp
  800e10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e11:	83 ec 0c             	sub    $0xc,%esp
  800e14:	50                   	push   %eax
  800e15:	6a 0a                	push   $0xa
  800e17:	68 bf 27 80 00       	push   $0x8027bf
  800e1c:	6a 23                	push   $0x23
  800e1e:	68 dc 27 80 00       	push   $0x8027dc
  800e23:	e8 02 f3 ff ff       	call   80012a <_panic>

00800e28 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e39:	be 00 00 00 00       	mov    $0x0,%esi
  800e3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e41:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e44:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e46:	5b                   	pop    %ebx
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e61:	89 cb                	mov    %ecx,%ebx
  800e63:	89 cf                	mov    %ecx,%edi
  800e65:	89 ce                	mov    %ecx,%esi
  800e67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7f 08                	jg     800e75 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	83 ec 0c             	sub    $0xc,%esp
  800e78:	50                   	push   %eax
  800e79:	6a 0d                	push   $0xd
  800e7b:	68 bf 27 80 00       	push   $0x8027bf
  800e80:	6a 23                	push   $0x23
  800e82:	68 dc 27 80 00       	push   $0x8027dc
  800e87:	e8 9e f2 ff ff       	call   80012a <_panic>

00800e8c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e92:	ba 00 00 00 00       	mov    $0x0,%edx
  800e97:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e9c:	89 d1                	mov    %edx,%ecx
  800e9e:	89 d3                	mov    %edx,%ebx
  800ea0:	89 d7                	mov    %edx,%edi
  800ea2:	89 d6                	mov    %edx,%esi
  800ea4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800eb1:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800eb8:	74 0a                	je     800ec4 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800ec4:	a1 08 40 80 00       	mov    0x804008,%eax
  800ec9:	8b 40 48             	mov    0x48(%eax),%eax
  800ecc:	83 ec 04             	sub    $0x4,%esp
  800ecf:	6a 07                	push   $0x7
  800ed1:	68 00 f0 bf ee       	push   $0xeebff000
  800ed6:	50                   	push   %eax
  800ed7:	e8 bf fd ff ff       	call   800c9b <sys_page_alloc>
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	75 2f                	jne    800f12 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  800ee3:	a1 08 40 80 00       	mov    0x804008,%eax
  800ee8:	8b 40 48             	mov    0x48(%eax),%eax
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	68 24 0f 80 00       	push   $0x800f24
  800ef3:	50                   	push   %eax
  800ef4:	e8 ed fe ff ff       	call   800de6 <sys_env_set_pgfault_upcall>
  800ef9:	83 c4 10             	add    $0x10,%esp
  800efc:	85 c0                	test   %eax,%eax
  800efe:	74 ba                	je     800eba <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  800f00:	50                   	push   %eax
  800f01:	68 ea 27 80 00       	push   $0x8027ea
  800f06:	6a 24                	push   $0x24
  800f08:	68 02 28 80 00       	push   $0x802802
  800f0d:	e8 18 f2 ff ff       	call   80012a <_panic>
		    panic("set_pgfault_handler: %e", r);
  800f12:	50                   	push   %eax
  800f13:	68 ea 27 80 00       	push   $0x8027ea
  800f18:	6a 21                	push   $0x21
  800f1a:	68 02 28 80 00       	push   $0x802802
  800f1f:	e8 06 f2 ff ff       	call   80012a <_panic>

00800f24 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f24:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f25:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f2a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f2c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  800f2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  800f33:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  800f36:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  800f3a:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  800f3e:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  800f40:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  800f43:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  800f44:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  800f47:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  800f48:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800f49:	c3                   	ret    

00800f4a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	05 00 00 00 30       	add    $0x30000000,%eax
  800f55:	c1 e8 0c             	shr    $0xc,%eax
}
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f6a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f77:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f7c:	89 c2                	mov    %eax,%edx
  800f7e:	c1 ea 16             	shr    $0x16,%edx
  800f81:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f88:	f6 c2 01             	test   $0x1,%dl
  800f8b:	74 2a                	je     800fb7 <fd_alloc+0x46>
  800f8d:	89 c2                	mov    %eax,%edx
  800f8f:	c1 ea 0c             	shr    $0xc,%edx
  800f92:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f99:	f6 c2 01             	test   $0x1,%dl
  800f9c:	74 19                	je     800fb7 <fd_alloc+0x46>
  800f9e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fa3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fa8:	75 d2                	jne    800f7c <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800faa:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fb0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fb5:	eb 07                	jmp    800fbe <fd_alloc+0x4d>
			*fd_store = fd;
  800fb7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fc6:	83 f8 1f             	cmp    $0x1f,%eax
  800fc9:	77 36                	ja     801001 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fcb:	c1 e0 0c             	shl    $0xc,%eax
  800fce:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	c1 ea 16             	shr    $0x16,%edx
  800fd8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fdf:	f6 c2 01             	test   $0x1,%dl
  800fe2:	74 24                	je     801008 <fd_lookup+0x48>
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	c1 ea 0c             	shr    $0xc,%edx
  800fe9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ff0:	f6 c2 01             	test   $0x1,%dl
  800ff3:	74 1a                	je     80100f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff8:	89 02                	mov    %eax,(%edx)
	return 0;
  800ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
		return -E_INVAL;
  801001:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801006:	eb f7                	jmp    800fff <fd_lookup+0x3f>
		return -E_INVAL;
  801008:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100d:	eb f0                	jmp    800fff <fd_lookup+0x3f>
  80100f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801014:	eb e9                	jmp    800fff <fd_lookup+0x3f>

00801016 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101f:	ba 8c 28 80 00       	mov    $0x80288c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801024:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801029:	39 08                	cmp    %ecx,(%eax)
  80102b:	74 33                	je     801060 <dev_lookup+0x4a>
  80102d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801030:	8b 02                	mov    (%edx),%eax
  801032:	85 c0                	test   %eax,%eax
  801034:	75 f3                	jne    801029 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801036:	a1 08 40 80 00       	mov    0x804008,%eax
  80103b:	8b 40 48             	mov    0x48(%eax),%eax
  80103e:	83 ec 04             	sub    $0x4,%esp
  801041:	51                   	push   %ecx
  801042:	50                   	push   %eax
  801043:	68 10 28 80 00       	push   $0x802810
  801048:	e8 b8 f1 ff ff       	call   800205 <cprintf>
	*dev = 0;
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801056:	83 c4 10             	add    $0x10,%esp
  801059:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    
			*dev = devtab[i];
  801060:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801063:	89 01                	mov    %eax,(%ecx)
			return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	eb f2                	jmp    80105e <dev_lookup+0x48>

0080106c <fd_close>:
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	57                   	push   %edi
  801070:	56                   	push   %esi
  801071:	53                   	push   %ebx
  801072:	83 ec 1c             	sub    $0x1c,%esp
  801075:	8b 75 08             	mov    0x8(%ebp),%esi
  801078:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80107b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80107e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80107f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801085:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801088:	50                   	push   %eax
  801089:	e8 32 ff ff ff       	call   800fc0 <fd_lookup>
  80108e:	89 c3                	mov    %eax,%ebx
  801090:	83 c4 08             	add    $0x8,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 05                	js     80109c <fd_close+0x30>
	    || fd != fd2)
  801097:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80109a:	74 16                	je     8010b2 <fd_close+0x46>
		return (must_exist ? r : 0);
  80109c:	89 f8                	mov    %edi,%eax
  80109e:	84 c0                	test   %al,%al
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a5:	0f 44 d8             	cmove  %eax,%ebx
}
  8010a8:	89 d8                	mov    %ebx,%eax
  8010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010b8:	50                   	push   %eax
  8010b9:	ff 36                	pushl  (%esi)
  8010bb:	e8 56 ff ff ff       	call   801016 <dev_lookup>
  8010c0:	89 c3                	mov    %eax,%ebx
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 15                	js     8010de <fd_close+0x72>
		if (dev->dev_close)
  8010c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010cc:	8b 40 10             	mov    0x10(%eax),%eax
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	74 1b                	je     8010ee <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8010d3:	83 ec 0c             	sub    $0xc,%esp
  8010d6:	56                   	push   %esi
  8010d7:	ff d0                	call   *%eax
  8010d9:	89 c3                	mov    %eax,%ebx
  8010db:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	56                   	push   %esi
  8010e2:	6a 00                	push   $0x0
  8010e4:	e8 37 fc ff ff       	call   800d20 <sys_page_unmap>
	return r;
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	eb ba                	jmp    8010a8 <fd_close+0x3c>
			r = 0;
  8010ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f3:	eb e9                	jmp    8010de <fd_close+0x72>

008010f5 <close>:

int
close(int fdnum)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010fe:	50                   	push   %eax
  8010ff:	ff 75 08             	pushl  0x8(%ebp)
  801102:	e8 b9 fe ff ff       	call   800fc0 <fd_lookup>
  801107:	83 c4 08             	add    $0x8,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	78 10                	js     80111e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	6a 01                	push   $0x1
  801113:	ff 75 f4             	pushl  -0xc(%ebp)
  801116:	e8 51 ff ff ff       	call   80106c <fd_close>
  80111b:	83 c4 10             	add    $0x10,%esp
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <close_all>:

void
close_all(void)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	53                   	push   %ebx
  801124:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801127:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80112c:	83 ec 0c             	sub    $0xc,%esp
  80112f:	53                   	push   %ebx
  801130:	e8 c0 ff ff ff       	call   8010f5 <close>
	for (i = 0; i < MAXFD; i++)
  801135:	83 c3 01             	add    $0x1,%ebx
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	83 fb 20             	cmp    $0x20,%ebx
  80113e:	75 ec                	jne    80112c <close_all+0xc>
}
  801140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
  80114b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80114e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801151:	50                   	push   %eax
  801152:	ff 75 08             	pushl  0x8(%ebp)
  801155:	e8 66 fe ff ff       	call   800fc0 <fd_lookup>
  80115a:	89 c3                	mov    %eax,%ebx
  80115c:	83 c4 08             	add    $0x8,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	0f 88 81 00 00 00    	js     8011e8 <dup+0xa3>
		return r;
	close(newfdnum);
  801167:	83 ec 0c             	sub    $0xc,%esp
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 83 ff ff ff       	call   8010f5 <close>

	newfd = INDEX2FD(newfdnum);
  801172:	8b 75 0c             	mov    0xc(%ebp),%esi
  801175:	c1 e6 0c             	shl    $0xc,%esi
  801178:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80117e:	83 c4 04             	add    $0x4,%esp
  801181:	ff 75 e4             	pushl  -0x1c(%ebp)
  801184:	e8 d1 fd ff ff       	call   800f5a <fd2data>
  801189:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80118b:	89 34 24             	mov    %esi,(%esp)
  80118e:	e8 c7 fd ff ff       	call   800f5a <fd2data>
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801198:	89 d8                	mov    %ebx,%eax
  80119a:	c1 e8 16             	shr    $0x16,%eax
  80119d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011a4:	a8 01                	test   $0x1,%al
  8011a6:	74 11                	je     8011b9 <dup+0x74>
  8011a8:	89 d8                	mov    %ebx,%eax
  8011aa:	c1 e8 0c             	shr    $0xc,%eax
  8011ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011b4:	f6 c2 01             	test   $0x1,%dl
  8011b7:	75 39                	jne    8011f2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011bc:	89 d0                	mov    %edx,%eax
  8011be:	c1 e8 0c             	shr    $0xc,%eax
  8011c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011c8:	83 ec 0c             	sub    $0xc,%esp
  8011cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8011d0:	50                   	push   %eax
  8011d1:	56                   	push   %esi
  8011d2:	6a 00                	push   $0x0
  8011d4:	52                   	push   %edx
  8011d5:	6a 00                	push   $0x0
  8011d7:	e8 02 fb ff ff       	call   800cde <sys_page_map>
  8011dc:	89 c3                	mov    %eax,%ebx
  8011de:	83 c4 20             	add    $0x20,%esp
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	78 31                	js     801216 <dup+0xd1>
		goto err;

	return newfdnum;
  8011e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011e8:	89 d8                	mov    %ebx,%eax
  8011ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ed:	5b                   	pop    %ebx
  8011ee:	5e                   	pop    %esi
  8011ef:	5f                   	pop    %edi
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011f2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	25 07 0e 00 00       	and    $0xe07,%eax
  801201:	50                   	push   %eax
  801202:	57                   	push   %edi
  801203:	6a 00                	push   $0x0
  801205:	53                   	push   %ebx
  801206:	6a 00                	push   $0x0
  801208:	e8 d1 fa ff ff       	call   800cde <sys_page_map>
  80120d:	89 c3                	mov    %eax,%ebx
  80120f:	83 c4 20             	add    $0x20,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	79 a3                	jns    8011b9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	56                   	push   %esi
  80121a:	6a 00                	push   $0x0
  80121c:	e8 ff fa ff ff       	call   800d20 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801221:	83 c4 08             	add    $0x8,%esp
  801224:	57                   	push   %edi
  801225:	6a 00                	push   $0x0
  801227:	e8 f4 fa ff ff       	call   800d20 <sys_page_unmap>
	return r;
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	eb b7                	jmp    8011e8 <dup+0xa3>

00801231 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	53                   	push   %ebx
  801235:	83 ec 14             	sub    $0x14,%esp
  801238:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80123b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80123e:	50                   	push   %eax
  80123f:	53                   	push   %ebx
  801240:	e8 7b fd ff ff       	call   800fc0 <fd_lookup>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 3f                	js     80128b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801256:	ff 30                	pushl  (%eax)
  801258:	e8 b9 fd ff ff       	call   801016 <dev_lookup>
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	78 27                	js     80128b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801264:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801267:	8b 42 08             	mov    0x8(%edx),%eax
  80126a:	83 e0 03             	and    $0x3,%eax
  80126d:	83 f8 01             	cmp    $0x1,%eax
  801270:	74 1e                	je     801290 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801275:	8b 40 08             	mov    0x8(%eax),%eax
  801278:	85 c0                	test   %eax,%eax
  80127a:	74 35                	je     8012b1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	ff 75 10             	pushl  0x10(%ebp)
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	52                   	push   %edx
  801286:	ff d0                	call   *%eax
  801288:	83 c4 10             	add    $0x10,%esp
}
  80128b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801290:	a1 08 40 80 00       	mov    0x804008,%eax
  801295:	8b 40 48             	mov    0x48(%eax),%eax
  801298:	83 ec 04             	sub    $0x4,%esp
  80129b:	53                   	push   %ebx
  80129c:	50                   	push   %eax
  80129d:	68 51 28 80 00       	push   $0x802851
  8012a2:	e8 5e ef ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012af:	eb da                	jmp    80128b <read+0x5a>
		return -E_NOT_SUPP;
  8012b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012b6:	eb d3                	jmp    80128b <read+0x5a>

008012b8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	57                   	push   %edi
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012c4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012cc:	39 f3                	cmp    %esi,%ebx
  8012ce:	73 25                	jae    8012f5 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	89 f0                	mov    %esi,%eax
  8012d5:	29 d8                	sub    %ebx,%eax
  8012d7:	50                   	push   %eax
  8012d8:	89 d8                	mov    %ebx,%eax
  8012da:	03 45 0c             	add    0xc(%ebp),%eax
  8012dd:	50                   	push   %eax
  8012de:	57                   	push   %edi
  8012df:	e8 4d ff ff ff       	call   801231 <read>
		if (m < 0)
  8012e4:	83 c4 10             	add    $0x10,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	78 08                	js     8012f3 <readn+0x3b>
			return m;
		if (m == 0)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	74 06                	je     8012f5 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012ef:	01 c3                	add    %eax,%ebx
  8012f1:	eb d9                	jmp    8012cc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012f3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012f5:	89 d8                	mov    %ebx,%eax
  8012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	53                   	push   %ebx
  801303:	83 ec 14             	sub    $0x14,%esp
  801306:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801309:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	53                   	push   %ebx
  80130e:	e8 ad fc ff ff       	call   800fc0 <fd_lookup>
  801313:	83 c4 08             	add    $0x8,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	78 3a                	js     801354 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801320:	50                   	push   %eax
  801321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801324:	ff 30                	pushl  (%eax)
  801326:	e8 eb fc ff ff       	call   801016 <dev_lookup>
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 22                	js     801354 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801335:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801339:	74 1e                	je     801359 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80133b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133e:	8b 52 0c             	mov    0xc(%edx),%edx
  801341:	85 d2                	test   %edx,%edx
  801343:	74 35                	je     80137a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	ff 75 10             	pushl  0x10(%ebp)
  80134b:	ff 75 0c             	pushl  0xc(%ebp)
  80134e:	50                   	push   %eax
  80134f:	ff d2                	call   *%edx
  801351:	83 c4 10             	add    $0x10,%esp
}
  801354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801357:	c9                   	leave  
  801358:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801359:	a1 08 40 80 00       	mov    0x804008,%eax
  80135e:	8b 40 48             	mov    0x48(%eax),%eax
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	53                   	push   %ebx
  801365:	50                   	push   %eax
  801366:	68 6d 28 80 00       	push   $0x80286d
  80136b:	e8 95 ee ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801378:	eb da                	jmp    801354 <write+0x55>
		return -E_NOT_SUPP;
  80137a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80137f:	eb d3                	jmp    801354 <write+0x55>

00801381 <seek>:

int
seek(int fdnum, off_t offset)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801387:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80138a:	50                   	push   %eax
  80138b:	ff 75 08             	pushl  0x8(%ebp)
  80138e:	e8 2d fc ff ff       	call   800fc0 <fd_lookup>
  801393:	83 c4 08             	add    $0x8,%esp
  801396:	85 c0                	test   %eax,%eax
  801398:	78 0e                	js     8013a8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80139a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 14             	sub    $0x14,%esp
  8013b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b7:	50                   	push   %eax
  8013b8:	53                   	push   %ebx
  8013b9:	e8 02 fc ff ff       	call   800fc0 <fd_lookup>
  8013be:	83 c4 08             	add    $0x8,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	78 37                	js     8013fc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cb:	50                   	push   %eax
  8013cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cf:	ff 30                	pushl  (%eax)
  8013d1:	e8 40 fc ff ff       	call   801016 <dev_lookup>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 1f                	js     8013fc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e4:	74 1b                	je     801401 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e9:	8b 52 18             	mov    0x18(%edx),%edx
  8013ec:	85 d2                	test   %edx,%edx
  8013ee:	74 32                	je     801422 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	50                   	push   %eax
  8013f7:	ff d2                	call   *%edx
  8013f9:	83 c4 10             	add    $0x10,%esp
}
  8013fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    
			thisenv->env_id, fdnum);
  801401:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801406:	8b 40 48             	mov    0x48(%eax),%eax
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	53                   	push   %ebx
  80140d:	50                   	push   %eax
  80140e:	68 30 28 80 00       	push   $0x802830
  801413:	e8 ed ed ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801420:	eb da                	jmp    8013fc <ftruncate+0x52>
		return -E_NOT_SUPP;
  801422:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801427:	eb d3                	jmp    8013fc <ftruncate+0x52>

00801429 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	53                   	push   %ebx
  80142d:	83 ec 14             	sub    $0x14,%esp
  801430:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801433:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801436:	50                   	push   %eax
  801437:	ff 75 08             	pushl  0x8(%ebp)
  80143a:	e8 81 fb ff ff       	call   800fc0 <fd_lookup>
  80143f:	83 c4 08             	add    $0x8,%esp
  801442:	85 c0                	test   %eax,%eax
  801444:	78 4b                	js     801491 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144c:	50                   	push   %eax
  80144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801450:	ff 30                	pushl  (%eax)
  801452:	e8 bf fb ff ff       	call   801016 <dev_lookup>
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 33                	js     801491 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801461:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801465:	74 2f                	je     801496 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801467:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80146a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801471:	00 00 00 
	stat->st_isdir = 0;
  801474:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80147b:	00 00 00 
	stat->st_dev = dev;
  80147e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	53                   	push   %ebx
  801488:	ff 75 f0             	pushl  -0x10(%ebp)
  80148b:	ff 50 14             	call   *0x14(%eax)
  80148e:	83 c4 10             	add    $0x10,%esp
}
  801491:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801494:	c9                   	leave  
  801495:	c3                   	ret    
		return -E_NOT_SUPP;
  801496:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149b:	eb f4                	jmp    801491 <fstat+0x68>

0080149d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	6a 00                	push   $0x0
  8014a7:	ff 75 08             	pushl  0x8(%ebp)
  8014aa:	e8 26 02 00 00       	call   8016d5 <open>
  8014af:	89 c3                	mov    %eax,%ebx
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 1b                	js     8014d3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	50                   	push   %eax
  8014bf:	e8 65 ff ff ff       	call   801429 <fstat>
  8014c4:	89 c6                	mov    %eax,%esi
	close(fd);
  8014c6:	89 1c 24             	mov    %ebx,(%esp)
  8014c9:	e8 27 fc ff ff       	call   8010f5 <close>
	return r;
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	89 f3                	mov    %esi,%ebx
}
  8014d3:	89 d8                	mov    %ebx,%eax
  8014d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d8:	5b                   	pop    %ebx
  8014d9:	5e                   	pop    %esi
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    

008014dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	56                   	push   %esi
  8014e0:	53                   	push   %ebx
  8014e1:	89 c6                	mov    %eax,%esi
  8014e3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014e5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014ec:	74 27                	je     801515 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ee:	6a 07                	push   $0x7
  8014f0:	68 00 50 80 00       	push   $0x805000
  8014f5:	56                   	push   %esi
  8014f6:	ff 35 00 40 80 00    	pushl  0x804000
  8014fc:	e8 11 0c 00 00       	call   802112 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801501:	83 c4 0c             	add    $0xc,%esp
  801504:	6a 00                	push   $0x0
  801506:	53                   	push   %ebx
  801507:	6a 00                	push   $0x0
  801509:	e8 9b 0b 00 00       	call   8020a9 <ipc_recv>
}
  80150e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5d                   	pop    %ebp
  801514:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801515:	83 ec 0c             	sub    $0xc,%esp
  801518:	6a 01                	push   $0x1
  80151a:	e8 4c 0c 00 00       	call   80216b <ipc_find_env>
  80151f:	a3 00 40 80 00       	mov    %eax,0x804000
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	eb c5                	jmp    8014ee <fsipc+0x12>

00801529 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8b 40 0c             	mov    0xc(%eax),%eax
  801535:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801542:	ba 00 00 00 00       	mov    $0x0,%edx
  801547:	b8 02 00 00 00       	mov    $0x2,%eax
  80154c:	e8 8b ff ff ff       	call   8014dc <fsipc>
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <devfile_flush>:
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8b 40 0c             	mov    0xc(%eax),%eax
  80155f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801564:	ba 00 00 00 00       	mov    $0x0,%edx
  801569:	b8 06 00 00 00       	mov    $0x6,%eax
  80156e:	e8 69 ff ff ff       	call   8014dc <fsipc>
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <devfile_stat>:
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	53                   	push   %ebx
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8b 40 0c             	mov    0xc(%eax),%eax
  801585:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
  80158f:	b8 05 00 00 00       	mov    $0x5,%eax
  801594:	e8 43 ff ff ff       	call   8014dc <fsipc>
  801599:	85 c0                	test   %eax,%eax
  80159b:	78 2c                	js     8015c9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	68 00 50 80 00       	push   $0x805000
  8015a5:	53                   	push   %ebx
  8015a6:	e8 f7 f2 ff ff       	call   8008a2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015ab:	a1 80 50 80 00       	mov    0x805080,%eax
  8015b0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015b6:	a1 84 50 80 00       	mov    0x805084,%eax
  8015bb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <devfile_write>:
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	8b 40 0c             	mov    0xc(%eax),%eax
  8015de:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8015e3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015e9:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015ef:	77 30                	ja     801621 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	53                   	push   %ebx
  8015f5:	ff 75 0c             	pushl  0xc(%ebp)
  8015f8:	68 08 50 80 00       	push   $0x805008
  8015fd:	e8 2e f4 ff ff       	call   800a30 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801602:	ba 00 00 00 00       	mov    $0x0,%edx
  801607:	b8 04 00 00 00       	mov    $0x4,%eax
  80160c:	e8 cb fe ff ff       	call   8014dc <fsipc>
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	85 c0                	test   %eax,%eax
  801616:	78 04                	js     80161c <devfile_write+0x4e>
	assert(r <= n);
  801618:	39 d8                	cmp    %ebx,%eax
  80161a:	77 1e                	ja     80163a <devfile_write+0x6c>
}
  80161c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161f:	c9                   	leave  
  801620:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801621:	68 a0 28 80 00       	push   $0x8028a0
  801626:	68 d0 28 80 00       	push   $0x8028d0
  80162b:	68 94 00 00 00       	push   $0x94
  801630:	68 e5 28 80 00       	push   $0x8028e5
  801635:	e8 f0 ea ff ff       	call   80012a <_panic>
	assert(r <= n);
  80163a:	68 f0 28 80 00       	push   $0x8028f0
  80163f:	68 d0 28 80 00       	push   $0x8028d0
  801644:	68 98 00 00 00       	push   $0x98
  801649:	68 e5 28 80 00       	push   $0x8028e5
  80164e:	e8 d7 ea ff ff       	call   80012a <_panic>

00801653 <devfile_read>:
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	8b 40 0c             	mov    0xc(%eax),%eax
  801661:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801666:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80166c:	ba 00 00 00 00       	mov    $0x0,%edx
  801671:	b8 03 00 00 00       	mov    $0x3,%eax
  801676:	e8 61 fe ff ff       	call   8014dc <fsipc>
  80167b:	89 c3                	mov    %eax,%ebx
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 1f                	js     8016a0 <devfile_read+0x4d>
	assert(r <= n);
  801681:	39 f0                	cmp    %esi,%eax
  801683:	77 24                	ja     8016a9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801685:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80168a:	7f 33                	jg     8016bf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	50                   	push   %eax
  801690:	68 00 50 80 00       	push   $0x805000
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	e8 93 f3 ff ff       	call   800a30 <memmove>
	return r;
  80169d:	83 c4 10             	add    $0x10,%esp
}
  8016a0:	89 d8                	mov    %ebx,%eax
  8016a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    
	assert(r <= n);
  8016a9:	68 f0 28 80 00       	push   $0x8028f0
  8016ae:	68 d0 28 80 00       	push   $0x8028d0
  8016b3:	6a 7c                	push   $0x7c
  8016b5:	68 e5 28 80 00       	push   $0x8028e5
  8016ba:	e8 6b ea ff ff       	call   80012a <_panic>
	assert(r <= PGSIZE);
  8016bf:	68 f7 28 80 00       	push   $0x8028f7
  8016c4:	68 d0 28 80 00       	push   $0x8028d0
  8016c9:	6a 7d                	push   $0x7d
  8016cb:	68 e5 28 80 00       	push   $0x8028e5
  8016d0:	e8 55 ea ff ff       	call   80012a <_panic>

008016d5 <open>:
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	56                   	push   %esi
  8016d9:	53                   	push   %ebx
  8016da:	83 ec 1c             	sub    $0x1c,%esp
  8016dd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016e0:	56                   	push   %esi
  8016e1:	e8 85 f1 ff ff       	call   80086b <strlen>
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016ee:	7f 6c                	jg     80175c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016f0:	83 ec 0c             	sub    $0xc,%esp
  8016f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f6:	50                   	push   %eax
  8016f7:	e8 75 f8 ff ff       	call   800f71 <fd_alloc>
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	78 3c                	js     801741 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801705:	83 ec 08             	sub    $0x8,%esp
  801708:	56                   	push   %esi
  801709:	68 00 50 80 00       	push   $0x805000
  80170e:	e8 8f f1 ff ff       	call   8008a2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801713:	8b 45 0c             	mov    0xc(%ebp),%eax
  801716:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80171b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171e:	b8 01 00 00 00       	mov    $0x1,%eax
  801723:	e8 b4 fd ff ff       	call   8014dc <fsipc>
  801728:	89 c3                	mov    %eax,%ebx
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 19                	js     80174a <open+0x75>
	return fd2num(fd);
  801731:	83 ec 0c             	sub    $0xc,%esp
  801734:	ff 75 f4             	pushl  -0xc(%ebp)
  801737:	e8 0e f8 ff ff       	call   800f4a <fd2num>
  80173c:	89 c3                	mov    %eax,%ebx
  80173e:	83 c4 10             	add    $0x10,%esp
}
  801741:	89 d8                	mov    %ebx,%eax
  801743:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    
		fd_close(fd, 0);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	6a 00                	push   $0x0
  80174f:	ff 75 f4             	pushl  -0xc(%ebp)
  801752:	e8 15 f9 ff ff       	call   80106c <fd_close>
		return r;
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	eb e5                	jmp    801741 <open+0x6c>
		return -E_BAD_PATH;
  80175c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801761:	eb de                	jmp    801741 <open+0x6c>

00801763 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801769:	ba 00 00 00 00       	mov    $0x0,%edx
  80176e:	b8 08 00 00 00       	mov    $0x8,%eax
  801773:	e8 64 fd ff ff       	call   8014dc <fsipc>
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	56                   	push   %esi
  80177e:	53                   	push   %ebx
  80177f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	ff 75 08             	pushl  0x8(%ebp)
  801788:	e8 cd f7 ff ff       	call   800f5a <fd2data>
  80178d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80178f:	83 c4 08             	add    $0x8,%esp
  801792:	68 03 29 80 00       	push   $0x802903
  801797:	53                   	push   %ebx
  801798:	e8 05 f1 ff ff       	call   8008a2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80179d:	8b 46 04             	mov    0x4(%esi),%eax
  8017a0:	2b 06                	sub    (%esi),%eax
  8017a2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017a8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017af:	00 00 00 
	stat->st_dev = &devpipe;
  8017b2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017b9:	30 80 00 
	return 0;
}
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    

008017c8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 0c             	sub    $0xc,%esp
  8017cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017d2:	53                   	push   %ebx
  8017d3:	6a 00                	push   $0x0
  8017d5:	e8 46 f5 ff ff       	call   800d20 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017da:	89 1c 24             	mov    %ebx,(%esp)
  8017dd:	e8 78 f7 ff ff       	call   800f5a <fd2data>
  8017e2:	83 c4 08             	add    $0x8,%esp
  8017e5:	50                   	push   %eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	e8 33 f5 ff ff       	call   800d20 <sys_page_unmap>
}
  8017ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <_pipeisclosed>:
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	57                   	push   %edi
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 1c             	sub    $0x1c,%esp
  8017fb:	89 c7                	mov    %eax,%edi
  8017fd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017ff:	a1 08 40 80 00       	mov    0x804008,%eax
  801804:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801807:	83 ec 0c             	sub    $0xc,%esp
  80180a:	57                   	push   %edi
  80180b:	e8 94 09 00 00       	call   8021a4 <pageref>
  801810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801813:	89 34 24             	mov    %esi,(%esp)
  801816:	e8 89 09 00 00       	call   8021a4 <pageref>
		nn = thisenv->env_runs;
  80181b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801821:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	39 cb                	cmp    %ecx,%ebx
  801829:	74 1b                	je     801846 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80182b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80182e:	75 cf                	jne    8017ff <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801830:	8b 42 58             	mov    0x58(%edx),%eax
  801833:	6a 01                	push   $0x1
  801835:	50                   	push   %eax
  801836:	53                   	push   %ebx
  801837:	68 0a 29 80 00       	push   $0x80290a
  80183c:	e8 c4 e9 ff ff       	call   800205 <cprintf>
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	eb b9                	jmp    8017ff <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801846:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801849:	0f 94 c0             	sete   %al
  80184c:	0f b6 c0             	movzbl %al,%eax
}
  80184f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801852:	5b                   	pop    %ebx
  801853:	5e                   	pop    %esi
  801854:	5f                   	pop    %edi
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <devpipe_write>:
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	57                   	push   %edi
  80185b:	56                   	push   %esi
  80185c:	53                   	push   %ebx
  80185d:	83 ec 28             	sub    $0x28,%esp
  801860:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801863:	56                   	push   %esi
  801864:	e8 f1 f6 ff ff       	call   800f5a <fd2data>
  801869:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	bf 00 00 00 00       	mov    $0x0,%edi
  801873:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801876:	74 4f                	je     8018c7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801878:	8b 43 04             	mov    0x4(%ebx),%eax
  80187b:	8b 0b                	mov    (%ebx),%ecx
  80187d:	8d 51 20             	lea    0x20(%ecx),%edx
  801880:	39 d0                	cmp    %edx,%eax
  801882:	72 14                	jb     801898 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801884:	89 da                	mov    %ebx,%edx
  801886:	89 f0                	mov    %esi,%eax
  801888:	e8 65 ff ff ff       	call   8017f2 <_pipeisclosed>
  80188d:	85 c0                	test   %eax,%eax
  80188f:	75 3a                	jne    8018cb <devpipe_write+0x74>
			sys_yield();
  801891:	e8 e6 f3 ff ff       	call   800c7c <sys_yield>
  801896:	eb e0                	jmp    801878 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801898:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80189b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80189f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	c1 fa 1f             	sar    $0x1f,%edx
  8018a7:	89 d1                	mov    %edx,%ecx
  8018a9:	c1 e9 1b             	shr    $0x1b,%ecx
  8018ac:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018af:	83 e2 1f             	and    $0x1f,%edx
  8018b2:	29 ca                	sub    %ecx,%edx
  8018b4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018b8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018bc:	83 c0 01             	add    $0x1,%eax
  8018bf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018c2:	83 c7 01             	add    $0x1,%edi
  8018c5:	eb ac                	jmp    801873 <devpipe_write+0x1c>
	return i;
  8018c7:	89 f8                	mov    %edi,%eax
  8018c9:	eb 05                	jmp    8018d0 <devpipe_write+0x79>
				return 0;
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5e                   	pop    %esi
  8018d5:	5f                   	pop    %edi
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    

008018d8 <devpipe_read>:
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	57                   	push   %edi
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 18             	sub    $0x18,%esp
  8018e1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018e4:	57                   	push   %edi
  8018e5:	e8 70 f6 ff ff       	call   800f5a <fd2data>
  8018ea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	be 00 00 00 00       	mov    $0x0,%esi
  8018f4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018f7:	74 47                	je     801940 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8018f9:	8b 03                	mov    (%ebx),%eax
  8018fb:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018fe:	75 22                	jne    801922 <devpipe_read+0x4a>
			if (i > 0)
  801900:	85 f6                	test   %esi,%esi
  801902:	75 14                	jne    801918 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801904:	89 da                	mov    %ebx,%edx
  801906:	89 f8                	mov    %edi,%eax
  801908:	e8 e5 fe ff ff       	call   8017f2 <_pipeisclosed>
  80190d:	85 c0                	test   %eax,%eax
  80190f:	75 33                	jne    801944 <devpipe_read+0x6c>
			sys_yield();
  801911:	e8 66 f3 ff ff       	call   800c7c <sys_yield>
  801916:	eb e1                	jmp    8018f9 <devpipe_read+0x21>
				return i;
  801918:	89 f0                	mov    %esi,%eax
}
  80191a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80191d:	5b                   	pop    %ebx
  80191e:	5e                   	pop    %esi
  80191f:	5f                   	pop    %edi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801922:	99                   	cltd   
  801923:	c1 ea 1b             	shr    $0x1b,%edx
  801926:	01 d0                	add    %edx,%eax
  801928:	83 e0 1f             	and    $0x1f,%eax
  80192b:	29 d0                	sub    %edx,%eax
  80192d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801935:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801938:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80193b:	83 c6 01             	add    $0x1,%esi
  80193e:	eb b4                	jmp    8018f4 <devpipe_read+0x1c>
	return i;
  801940:	89 f0                	mov    %esi,%eax
  801942:	eb d6                	jmp    80191a <devpipe_read+0x42>
				return 0;
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
  801949:	eb cf                	jmp    80191a <devpipe_read+0x42>

0080194b <pipe>:
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801953:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801956:	50                   	push   %eax
  801957:	e8 15 f6 ff ff       	call   800f71 <fd_alloc>
  80195c:	89 c3                	mov    %eax,%ebx
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	85 c0                	test   %eax,%eax
  801963:	78 5b                	js     8019c0 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	68 07 04 00 00       	push   $0x407
  80196d:	ff 75 f4             	pushl  -0xc(%ebp)
  801970:	6a 00                	push   $0x0
  801972:	e8 24 f3 ff ff       	call   800c9b <sys_page_alloc>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 40                	js     8019c0 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801986:	50                   	push   %eax
  801987:	e8 e5 f5 ff ff       	call   800f71 <fd_alloc>
  80198c:	89 c3                	mov    %eax,%ebx
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	85 c0                	test   %eax,%eax
  801993:	78 1b                	js     8019b0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	68 07 04 00 00       	push   $0x407
  80199d:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a0:	6a 00                	push   $0x0
  8019a2:	e8 f4 f2 ff ff       	call   800c9b <sys_page_alloc>
  8019a7:	89 c3                	mov    %eax,%ebx
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	79 19                	jns    8019c9 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b6:	6a 00                	push   $0x0
  8019b8:	e8 63 f3 ff ff       	call   800d20 <sys_page_unmap>
  8019bd:	83 c4 10             	add    $0x10,%esp
}
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5d                   	pop    %ebp
  8019c8:	c3                   	ret    
	va = fd2data(fd0);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cf:	e8 86 f5 ff ff       	call   800f5a <fd2data>
  8019d4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d6:	83 c4 0c             	add    $0xc,%esp
  8019d9:	68 07 04 00 00       	push   $0x407
  8019de:	50                   	push   %eax
  8019df:	6a 00                	push   $0x0
  8019e1:	e8 b5 f2 ff ff       	call   800c9b <sys_page_alloc>
  8019e6:	89 c3                	mov    %eax,%ebx
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	0f 88 8c 00 00 00    	js     801a7f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f3:	83 ec 0c             	sub    $0xc,%esp
  8019f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f9:	e8 5c f5 ff ff       	call   800f5a <fd2data>
  8019fe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a05:	50                   	push   %eax
  801a06:	6a 00                	push   $0x0
  801a08:	56                   	push   %esi
  801a09:	6a 00                	push   $0x0
  801a0b:	e8 ce f2 ff ff       	call   800cde <sys_page_map>
  801a10:	89 c3                	mov    %eax,%ebx
  801a12:	83 c4 20             	add    $0x20,%esp
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 58                	js     801a71 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a22:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a37:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a43:	83 ec 0c             	sub    $0xc,%esp
  801a46:	ff 75 f4             	pushl  -0xc(%ebp)
  801a49:	e8 fc f4 ff ff       	call   800f4a <fd2num>
  801a4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a51:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a53:	83 c4 04             	add    $0x4,%esp
  801a56:	ff 75 f0             	pushl  -0x10(%ebp)
  801a59:	e8 ec f4 ff ff       	call   800f4a <fd2num>
  801a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a61:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a6c:	e9 4f ff ff ff       	jmp    8019c0 <pipe+0x75>
	sys_page_unmap(0, va);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	56                   	push   %esi
  801a75:	6a 00                	push   $0x0
  801a77:	e8 a4 f2 ff ff       	call   800d20 <sys_page_unmap>
  801a7c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	ff 75 f0             	pushl  -0x10(%ebp)
  801a85:	6a 00                	push   $0x0
  801a87:	e8 94 f2 ff ff       	call   800d20 <sys_page_unmap>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	e9 1c ff ff ff       	jmp    8019b0 <pipe+0x65>

00801a94 <pipeisclosed>:
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9d:	50                   	push   %eax
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	e8 1a f5 ff ff       	call   800fc0 <fd_lookup>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 18                	js     801ac5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab3:	e8 a2 f4 ff ff       	call   800f5a <fd2data>
	return _pipeisclosed(fd, p);
  801ab8:	89 c2                	mov    %eax,%edx
  801aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abd:	e8 30 fd ff ff       	call   8017f2 <_pipeisclosed>
  801ac2:	83 c4 10             	add    $0x10,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801acd:	68 22 29 80 00       	push   $0x802922
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	e8 c8 ed ff ff       	call   8008a2 <strcpy>
	return 0;
}
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <devsock_close>:
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	53                   	push   %ebx
  801ae5:	83 ec 10             	sub    $0x10,%esp
  801ae8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801aeb:	53                   	push   %ebx
  801aec:	e8 b3 06 00 00       	call   8021a4 <pageref>
  801af1:	83 c4 10             	add    $0x10,%esp
		return 0;
  801af4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801af9:	83 f8 01             	cmp    $0x1,%eax
  801afc:	74 07                	je     801b05 <devsock_close+0x24>
}
  801afe:	89 d0                	mov    %edx,%eax
  801b00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b05:	83 ec 0c             	sub    $0xc,%esp
  801b08:	ff 73 0c             	pushl  0xc(%ebx)
  801b0b:	e8 b7 02 00 00       	call   801dc7 <nsipc_close>
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	eb e7                	jmp    801afe <devsock_close+0x1d>

00801b17 <devsock_write>:
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	ff 75 10             	pushl  0x10(%ebp)
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	ff 70 0c             	pushl  0xc(%eax)
  801b2b:	e8 74 03 00 00       	call   801ea4 <nsipc_send>
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <devsock_read>:
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 10             	pushl  0x10(%ebp)
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	ff 70 0c             	pushl  0xc(%eax)
  801b46:	e8 ed 02 00 00       	call   801e38 <nsipc_recv>
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <fd2sockid>:
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b53:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b56:	52                   	push   %edx
  801b57:	50                   	push   %eax
  801b58:	e8 63 f4 ff ff       	call   800fc0 <fd_lookup>
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	78 10                	js     801b74 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b67:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801b6d:	39 08                	cmp    %ecx,(%eax)
  801b6f:	75 05                	jne    801b76 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b71:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    
		return -E_NOT_SUPP;
  801b76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b7b:	eb f7                	jmp    801b74 <fd2sockid+0x27>

00801b7d <alloc_sockfd>:
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	56                   	push   %esi
  801b81:	53                   	push   %ebx
  801b82:	83 ec 1c             	sub    $0x1c,%esp
  801b85:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8a:	50                   	push   %eax
  801b8b:	e8 e1 f3 ff ff       	call   800f71 <fd_alloc>
  801b90:	89 c3                	mov    %eax,%ebx
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 43                	js     801bdc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	68 07 04 00 00       	push   $0x407
  801ba1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba4:	6a 00                	push   $0x0
  801ba6:	e8 f0 f0 ff ff       	call   800c9b <sys_page_alloc>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	78 28                	js     801bdc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bbd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bc9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	50                   	push   %eax
  801bd0:	e8 75 f3 ff ff       	call   800f4a <fd2num>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	eb 0c                	jmp    801be8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bdc:	83 ec 0c             	sub    $0xc,%esp
  801bdf:	56                   	push   %esi
  801be0:	e8 e2 01 00 00       	call   801dc7 <nsipc_close>
		return r;
  801be5:	83 c4 10             	add    $0x10,%esp
}
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bed:	5b                   	pop    %ebx
  801bee:	5e                   	pop    %esi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    

00801bf1 <accept>:
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	e8 4e ff ff ff       	call   801b4d <fd2sockid>
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 1b                	js     801c1e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	ff 75 10             	pushl  0x10(%ebp)
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	50                   	push   %eax
  801c0d:	e8 0e 01 00 00       	call   801d20 <nsipc_accept>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 05                	js     801c1e <accept+0x2d>
	return alloc_sockfd(r);
  801c19:	e8 5f ff ff ff       	call   801b7d <alloc_sockfd>
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <bind>:
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	e8 1f ff ff ff       	call   801b4d <fd2sockid>
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 12                	js     801c44 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	ff 75 10             	pushl  0x10(%ebp)
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	50                   	push   %eax
  801c3c:	e8 2f 01 00 00       	call   801d70 <nsipc_bind>
  801c41:	83 c4 10             	add    $0x10,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <shutdown>:
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	e8 f9 fe ff ff       	call   801b4d <fd2sockid>
  801c54:	85 c0                	test   %eax,%eax
  801c56:	78 0f                	js     801c67 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c58:	83 ec 08             	sub    $0x8,%esp
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	50                   	push   %eax
  801c5f:	e8 41 01 00 00       	call   801da5 <nsipc_shutdown>
  801c64:	83 c4 10             	add    $0x10,%esp
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <connect>:
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	e8 d6 fe ff ff       	call   801b4d <fd2sockid>
  801c77:	85 c0                	test   %eax,%eax
  801c79:	78 12                	js     801c8d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	ff 75 10             	pushl  0x10(%ebp)
  801c81:	ff 75 0c             	pushl  0xc(%ebp)
  801c84:	50                   	push   %eax
  801c85:	e8 57 01 00 00       	call   801de1 <nsipc_connect>
  801c8a:	83 c4 10             	add    $0x10,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <listen>:
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	e8 b0 fe ff ff       	call   801b4d <fd2sockid>
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	78 0f                	js     801cb0 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ca1:	83 ec 08             	sub    $0x8,%esp
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	50                   	push   %eax
  801ca8:	e8 69 01 00 00       	call   801e16 <nsipc_listen>
  801cad:	83 c4 10             	add    $0x10,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cb8:	ff 75 10             	pushl  0x10(%ebp)
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	e8 3c 02 00 00       	call   801f02 <nsipc_socket>
  801cc6:	83 c4 10             	add    $0x10,%esp
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	78 05                	js     801cd2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ccd:	e8 ab fe ff ff       	call   801b7d <alloc_sockfd>
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cdd:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ce4:	74 26                	je     801d0c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ce6:	6a 07                	push   $0x7
  801ce8:	68 00 60 80 00       	push   $0x806000
  801ced:	53                   	push   %ebx
  801cee:	ff 35 04 40 80 00    	pushl  0x804004
  801cf4:	e8 19 04 00 00       	call   802112 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cf9:	83 c4 0c             	add    $0xc,%esp
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	e8 a2 03 00 00       	call   8020a9 <ipc_recv>
}
  801d07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d0c:	83 ec 0c             	sub    $0xc,%esp
  801d0f:	6a 02                	push   $0x2
  801d11:	e8 55 04 00 00       	call   80216b <ipc_find_env>
  801d16:	a3 04 40 80 00       	mov    %eax,0x804004
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	eb c6                	jmp    801ce6 <nsipc+0x12>

00801d20 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	56                   	push   %esi
  801d24:	53                   	push   %ebx
  801d25:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d30:	8b 06                	mov    (%esi),%eax
  801d32:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d37:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3c:	e8 93 ff ff ff       	call   801cd4 <nsipc>
  801d41:	89 c3                	mov    %eax,%ebx
  801d43:	85 c0                	test   %eax,%eax
  801d45:	78 20                	js     801d67 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	ff 35 10 60 80 00    	pushl  0x806010
  801d50:	68 00 60 80 00       	push   $0x806000
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	e8 d3 ec ff ff       	call   800a30 <memmove>
		*addrlen = ret->ret_addrlen;
  801d5d:	a1 10 60 80 00       	mov    0x806010,%eax
  801d62:	89 06                	mov    %eax,(%esi)
  801d64:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801d67:	89 d8                	mov    %ebx,%eax
  801d69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    

00801d70 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	53                   	push   %ebx
  801d74:	83 ec 08             	sub    $0x8,%esp
  801d77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d82:	53                   	push   %ebx
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	68 04 60 80 00       	push   $0x806004
  801d8b:	e8 a0 ec ff ff       	call   800a30 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d90:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d96:	b8 02 00 00 00       	mov    $0x2,%eax
  801d9b:	e8 34 ff ff ff       	call   801cd4 <nsipc>
}
  801da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801dbb:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc0:	e8 0f ff ff ff       	call   801cd4 <nsipc>
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <nsipc_close>:

int
nsipc_close(int s)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dd5:	b8 04 00 00 00       	mov    $0x4,%eax
  801dda:	e8 f5 fe ff ff       	call   801cd4 <nsipc>
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	53                   	push   %ebx
  801de5:	83 ec 08             	sub    $0x8,%esp
  801de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801df3:	53                   	push   %ebx
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	68 04 60 80 00       	push   $0x806004
  801dfc:	e8 2f ec ff ff       	call   800a30 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e01:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e07:	b8 05 00 00 00       	mov    $0x5,%eax
  801e0c:	e8 c3 fe ff ff       	call   801cd4 <nsipc>
}
  801e11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e2c:	b8 06 00 00 00       	mov    $0x6,%eax
  801e31:	e8 9e fe ff ff       	call   801cd4 <nsipc>
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	56                   	push   %esi
  801e3c:	53                   	push   %ebx
  801e3d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e48:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e51:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e56:	b8 07 00 00 00       	mov    $0x7,%eax
  801e5b:	e8 74 fe ff ff       	call   801cd4 <nsipc>
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	85 c0                	test   %eax,%eax
  801e64:	78 1f                	js     801e85 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e66:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e6b:	7f 21                	jg     801e8e <nsipc_recv+0x56>
  801e6d:	39 c6                	cmp    %eax,%esi
  801e6f:	7c 1d                	jl     801e8e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	50                   	push   %eax
  801e75:	68 00 60 80 00       	push   $0x806000
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	e8 ae eb ff ff       	call   800a30 <memmove>
  801e82:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e85:	89 d8                	mov    %ebx,%eax
  801e87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8a:	5b                   	pop    %ebx
  801e8b:	5e                   	pop    %esi
  801e8c:	5d                   	pop    %ebp
  801e8d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e8e:	68 2e 29 80 00       	push   $0x80292e
  801e93:	68 d0 28 80 00       	push   $0x8028d0
  801e98:	6a 62                	push   $0x62
  801e9a:	68 43 29 80 00       	push   $0x802943
  801e9f:	e8 86 e2 ff ff       	call   80012a <_panic>

00801ea4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	53                   	push   %ebx
  801ea8:	83 ec 04             	sub    $0x4,%esp
  801eab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801eb6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ebc:	7f 2e                	jg     801eec <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	53                   	push   %ebx
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	68 0c 60 80 00       	push   $0x80600c
  801eca:	e8 61 eb ff ff       	call   800a30 <memmove>
	nsipcbuf.send.req_size = size;
  801ecf:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801edd:	b8 08 00 00 00       	mov    $0x8,%eax
  801ee2:	e8 ed fd ff ff       	call   801cd4 <nsipc>
}
  801ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    
	assert(size < 1600);
  801eec:	68 4f 29 80 00       	push   $0x80294f
  801ef1:	68 d0 28 80 00       	push   $0x8028d0
  801ef6:	6a 6d                	push   $0x6d
  801ef8:	68 43 29 80 00       	push   $0x802943
  801efd:	e8 28 e2 ff ff       	call   80012a <_panic>

00801f02 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f13:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f18:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f20:	b8 09 00 00 00       	mov    $0x9,%eax
  801f25:	e8 aa fd ff ff       	call   801cd4 <nsipc>
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    

00801f36 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f3c:	68 5b 29 80 00       	push   $0x80295b
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	e8 59 e9 ff ff       	call   8008a2 <strcpy>
	return 0;
}
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <devcons_write>:
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	57                   	push   %edi
  801f54:	56                   	push   %esi
  801f55:	53                   	push   %ebx
  801f56:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f5c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f61:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f67:	eb 2f                	jmp    801f98 <devcons_write+0x48>
		m = n - tot;
  801f69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f6c:	29 f3                	sub    %esi,%ebx
  801f6e:	83 fb 7f             	cmp    $0x7f,%ebx
  801f71:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f76:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	53                   	push   %ebx
  801f7d:	89 f0                	mov    %esi,%eax
  801f7f:	03 45 0c             	add    0xc(%ebp),%eax
  801f82:	50                   	push   %eax
  801f83:	57                   	push   %edi
  801f84:	e8 a7 ea ff ff       	call   800a30 <memmove>
		sys_cputs(buf, m);
  801f89:	83 c4 08             	add    $0x8,%esp
  801f8c:	53                   	push   %ebx
  801f8d:	57                   	push   %edi
  801f8e:	e8 4c ec ff ff       	call   800bdf <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f93:	01 de                	add    %ebx,%esi
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f9b:	72 cc                	jb     801f69 <devcons_write+0x19>
}
  801f9d:	89 f0                	mov    %esi,%eax
  801f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa2:	5b                   	pop    %ebx
  801fa3:	5e                   	pop    %esi
  801fa4:	5f                   	pop    %edi
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    

00801fa7 <devcons_read>:
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 08             	sub    $0x8,%esp
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb6:	75 07                	jne    801fbf <devcons_read+0x18>
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    
		sys_yield();
  801fba:	e8 bd ec ff ff       	call   800c7c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801fbf:	e8 39 ec ff ff       	call   800bfd <sys_cgetc>
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	74 f2                	je     801fba <devcons_read+0x13>
	if (c < 0)
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 ec                	js     801fb8 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801fcc:	83 f8 04             	cmp    $0x4,%eax
  801fcf:	74 0c                	je     801fdd <devcons_read+0x36>
	*(char*)vbuf = c;
  801fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd4:	88 02                	mov    %al,(%edx)
	return 1;
  801fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdb:	eb db                	jmp    801fb8 <devcons_read+0x11>
		return 0;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe2:	eb d4                	jmp    801fb8 <devcons_read+0x11>

00801fe4 <cputchar>:
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ff0:	6a 01                	push   $0x1
  801ff2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff5:	50                   	push   %eax
  801ff6:	e8 e4 eb ff ff       	call   800bdf <sys_cputs>
}
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <getchar>:
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802006:	6a 01                	push   $0x1
  802008:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80200b:	50                   	push   %eax
  80200c:	6a 00                	push   $0x0
  80200e:	e8 1e f2 ff ff       	call   801231 <read>
	if (r < 0)
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	85 c0                	test   %eax,%eax
  802018:	78 08                	js     802022 <getchar+0x22>
	if (r < 1)
  80201a:	85 c0                	test   %eax,%eax
  80201c:	7e 06                	jle    802024 <getchar+0x24>
	return c;
  80201e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    
		return -E_EOF;
  802024:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802029:	eb f7                	jmp    802022 <getchar+0x22>

0080202b <iscons>:
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802031:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802034:	50                   	push   %eax
  802035:	ff 75 08             	pushl  0x8(%ebp)
  802038:	e8 83 ef ff ff       	call   800fc0 <fd_lookup>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	85 c0                	test   %eax,%eax
  802042:	78 11                	js     802055 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80204d:	39 10                	cmp    %edx,(%eax)
  80204f:	0f 94 c0             	sete   %al
  802052:	0f b6 c0             	movzbl %al,%eax
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <opencons>:
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80205d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802060:	50                   	push   %eax
  802061:	e8 0b ef ff ff       	call   800f71 <fd_alloc>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	78 3a                	js     8020a7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	68 07 04 00 00       	push   $0x407
  802075:	ff 75 f4             	pushl  -0xc(%ebp)
  802078:	6a 00                	push   $0x0
  80207a:	e8 1c ec ff ff       	call   800c9b <sys_page_alloc>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	78 21                	js     8020a7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80208f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80209b:	83 ec 0c             	sub    $0xc,%esp
  80209e:	50                   	push   %eax
  80209f:	e8 a6 ee ff ff       	call   800f4a <fd2num>
  8020a4:	83 c4 10             	add    $0x10,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	56                   	push   %esi
  8020ad:	53                   	push   %ebx
  8020ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8020b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8020b7:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8020b9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020be:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	50                   	push   %eax
  8020c5:	e8 81 ed ff ff       	call   800e4b <sys_ipc_recv>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 2b                	js     8020fc <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8020d1:	85 f6                	test   %esi,%esi
  8020d3:	74 0a                	je     8020df <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8020d5:	a1 08 40 80 00       	mov    0x804008,%eax
  8020da:	8b 40 74             	mov    0x74(%eax),%eax
  8020dd:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8020df:	85 db                	test   %ebx,%ebx
  8020e1:	74 0a                	je     8020ed <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8020e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8020e8:	8b 40 78             	mov    0x78(%eax),%eax
  8020eb:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8020ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f8:	5b                   	pop    %ebx
  8020f9:	5e                   	pop    %esi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
	    if (from_env_store != NULL) {
  8020fc:	85 f6                	test   %esi,%esi
  8020fe:	74 06                	je     802106 <ipc_recv+0x5d>
	        *from_env_store = 0;
  802100:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802106:	85 db                	test   %ebx,%ebx
  802108:	74 eb                	je     8020f5 <ipc_recv+0x4c>
	        *perm_store = 0;
  80210a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802110:	eb e3                	jmp    8020f5 <ipc_recv+0x4c>

00802112 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	57                   	push   %edi
  802116:	56                   	push   %esi
  802117:	53                   	push   %ebx
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80211e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802121:	85 f6                	test   %esi,%esi
  802123:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802128:	0f 44 f0             	cmove  %eax,%esi
  80212b:	eb 09                	jmp    802136 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80212d:	e8 4a eb ff ff       	call   800c7c <sys_yield>
	} while(r != 0);
  802132:	85 db                	test   %ebx,%ebx
  802134:	74 2d                	je     802163 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802136:	ff 75 14             	pushl  0x14(%ebp)
  802139:	56                   	push   %esi
  80213a:	ff 75 0c             	pushl  0xc(%ebp)
  80213d:	57                   	push   %edi
  80213e:	e8 e5 ec ff ff       	call   800e28 <sys_ipc_try_send>
  802143:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	85 c0                	test   %eax,%eax
  80214a:	79 e1                	jns    80212d <ipc_send+0x1b>
  80214c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80214f:	74 dc                	je     80212d <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802151:	50                   	push   %eax
  802152:	68 67 29 80 00       	push   $0x802967
  802157:	6a 45                	push   $0x45
  802159:	68 74 29 80 00       	push   $0x802974
  80215e:	e8 c7 df ff ff       	call   80012a <_panic>
}
  802163:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802166:	5b                   	pop    %ebx
  802167:	5e                   	pop    %esi
  802168:	5f                   	pop    %edi
  802169:	5d                   	pop    %ebp
  80216a:	c3                   	ret    

0080216b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802176:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802179:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80217f:	8b 52 50             	mov    0x50(%edx),%edx
  802182:	39 ca                	cmp    %ecx,%edx
  802184:	74 11                	je     802197 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802186:	83 c0 01             	add    $0x1,%eax
  802189:	3d 00 04 00 00       	cmp    $0x400,%eax
  80218e:	75 e6                	jne    802176 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	eb 0b                	jmp    8021a2 <ipc_find_env+0x37>
			return envs[i].env_id;
  802197:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80219a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80219f:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    

008021a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021aa:	89 d0                	mov    %edx,%eax
  8021ac:	c1 e8 16             	shr    $0x16,%eax
  8021af:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021bb:	f6 c1 01             	test   $0x1,%cl
  8021be:	74 1d                	je     8021dd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021c0:	c1 ea 0c             	shr    $0xc,%edx
  8021c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021ca:	f6 c2 01             	test   $0x1,%dl
  8021cd:	74 0e                	je     8021dd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021cf:	c1 ea 0c             	shr    $0xc,%edx
  8021d2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021d9:	ef 
  8021da:	0f b7 c0             	movzwl %ax,%eax
}
  8021dd:	5d                   	pop    %ebp
  8021de:	c3                   	ret    
  8021df:	90                   	nop

008021e0 <__udivdi3>:
  8021e0:	55                   	push   %ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 1c             	sub    $0x1c,%esp
  8021e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021f7:	85 d2                	test   %edx,%edx
  8021f9:	75 35                	jne    802230 <__udivdi3+0x50>
  8021fb:	39 f3                	cmp    %esi,%ebx
  8021fd:	0f 87 bd 00 00 00    	ja     8022c0 <__udivdi3+0xe0>
  802203:	85 db                	test   %ebx,%ebx
  802205:	89 d9                	mov    %ebx,%ecx
  802207:	75 0b                	jne    802214 <__udivdi3+0x34>
  802209:	b8 01 00 00 00       	mov    $0x1,%eax
  80220e:	31 d2                	xor    %edx,%edx
  802210:	f7 f3                	div    %ebx
  802212:	89 c1                	mov    %eax,%ecx
  802214:	31 d2                	xor    %edx,%edx
  802216:	89 f0                	mov    %esi,%eax
  802218:	f7 f1                	div    %ecx
  80221a:	89 c6                	mov    %eax,%esi
  80221c:	89 e8                	mov    %ebp,%eax
  80221e:	89 f7                	mov    %esi,%edi
  802220:	f7 f1                	div    %ecx
  802222:	89 fa                	mov    %edi,%edx
  802224:	83 c4 1c             	add    $0x1c,%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5f                   	pop    %edi
  80222a:	5d                   	pop    %ebp
  80222b:	c3                   	ret    
  80222c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802230:	39 f2                	cmp    %esi,%edx
  802232:	77 7c                	ja     8022b0 <__udivdi3+0xd0>
  802234:	0f bd fa             	bsr    %edx,%edi
  802237:	83 f7 1f             	xor    $0x1f,%edi
  80223a:	0f 84 98 00 00 00    	je     8022d8 <__udivdi3+0xf8>
  802240:	89 f9                	mov    %edi,%ecx
  802242:	b8 20 00 00 00       	mov    $0x20,%eax
  802247:	29 f8                	sub    %edi,%eax
  802249:	d3 e2                	shl    %cl,%edx
  80224b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	89 da                	mov    %ebx,%edx
  802253:	d3 ea                	shr    %cl,%edx
  802255:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802259:	09 d1                	or     %edx,%ecx
  80225b:	89 f2                	mov    %esi,%edx
  80225d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802261:	89 f9                	mov    %edi,%ecx
  802263:	d3 e3                	shl    %cl,%ebx
  802265:	89 c1                	mov    %eax,%ecx
  802267:	d3 ea                	shr    %cl,%edx
  802269:	89 f9                	mov    %edi,%ecx
  80226b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80226f:	d3 e6                	shl    %cl,%esi
  802271:	89 eb                	mov    %ebp,%ebx
  802273:	89 c1                	mov    %eax,%ecx
  802275:	d3 eb                	shr    %cl,%ebx
  802277:	09 de                	or     %ebx,%esi
  802279:	89 f0                	mov    %esi,%eax
  80227b:	f7 74 24 08          	divl   0x8(%esp)
  80227f:	89 d6                	mov    %edx,%esi
  802281:	89 c3                	mov    %eax,%ebx
  802283:	f7 64 24 0c          	mull   0xc(%esp)
  802287:	39 d6                	cmp    %edx,%esi
  802289:	72 0c                	jb     802297 <__udivdi3+0xb7>
  80228b:	89 f9                	mov    %edi,%ecx
  80228d:	d3 e5                	shl    %cl,%ebp
  80228f:	39 c5                	cmp    %eax,%ebp
  802291:	73 5d                	jae    8022f0 <__udivdi3+0x110>
  802293:	39 d6                	cmp    %edx,%esi
  802295:	75 59                	jne    8022f0 <__udivdi3+0x110>
  802297:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80229a:	31 ff                	xor    %edi,%edi
  80229c:	89 fa                	mov    %edi,%edx
  80229e:	83 c4 1c             	add    $0x1c,%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5f                   	pop    %edi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
  8022a6:	8d 76 00             	lea    0x0(%esi),%esi
  8022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8022b0:	31 ff                	xor    %edi,%edi
  8022b2:	31 c0                	xor    %eax,%eax
  8022b4:	89 fa                	mov    %edi,%edx
  8022b6:	83 c4 1c             	add    $0x1c,%esp
  8022b9:	5b                   	pop    %ebx
  8022ba:	5e                   	pop    %esi
  8022bb:	5f                   	pop    %edi
  8022bc:	5d                   	pop    %ebp
  8022bd:	c3                   	ret    
  8022be:	66 90                	xchg   %ax,%ax
  8022c0:	31 ff                	xor    %edi,%edi
  8022c2:	89 e8                	mov    %ebp,%eax
  8022c4:	89 f2                	mov    %esi,%edx
  8022c6:	f7 f3                	div    %ebx
  8022c8:	89 fa                	mov    %edi,%edx
  8022ca:	83 c4 1c             	add    $0x1c,%esp
  8022cd:	5b                   	pop    %ebx
  8022ce:	5e                   	pop    %esi
  8022cf:	5f                   	pop    %edi
  8022d0:	5d                   	pop    %ebp
  8022d1:	c3                   	ret    
  8022d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022d8:	39 f2                	cmp    %esi,%edx
  8022da:	72 06                	jb     8022e2 <__udivdi3+0x102>
  8022dc:	31 c0                	xor    %eax,%eax
  8022de:	39 eb                	cmp    %ebp,%ebx
  8022e0:	77 d2                	ja     8022b4 <__udivdi3+0xd4>
  8022e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e7:	eb cb                	jmp    8022b4 <__udivdi3+0xd4>
  8022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	89 d8                	mov    %ebx,%eax
  8022f2:	31 ff                	xor    %edi,%edi
  8022f4:	eb be                	jmp    8022b4 <__udivdi3+0xd4>
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	66 90                	xchg   %ax,%ax
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <__umoddi3>:
  802300:	55                   	push   %ebp
  802301:	57                   	push   %edi
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
  802307:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80230b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80230f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802313:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802317:	85 ed                	test   %ebp,%ebp
  802319:	89 f0                	mov    %esi,%eax
  80231b:	89 da                	mov    %ebx,%edx
  80231d:	75 19                	jne    802338 <__umoddi3+0x38>
  80231f:	39 df                	cmp    %ebx,%edi
  802321:	0f 86 b1 00 00 00    	jbe    8023d8 <__umoddi3+0xd8>
  802327:	f7 f7                	div    %edi
  802329:	89 d0                	mov    %edx,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	83 c4 1c             	add    $0x1c,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	39 dd                	cmp    %ebx,%ebp
  80233a:	77 f1                	ja     80232d <__umoddi3+0x2d>
  80233c:	0f bd cd             	bsr    %ebp,%ecx
  80233f:	83 f1 1f             	xor    $0x1f,%ecx
  802342:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802346:	0f 84 b4 00 00 00    	je     802400 <__umoddi3+0x100>
  80234c:	b8 20 00 00 00       	mov    $0x20,%eax
  802351:	89 c2                	mov    %eax,%edx
  802353:	8b 44 24 04          	mov    0x4(%esp),%eax
  802357:	29 c2                	sub    %eax,%edx
  802359:	89 c1                	mov    %eax,%ecx
  80235b:	89 f8                	mov    %edi,%eax
  80235d:	d3 e5                	shl    %cl,%ebp
  80235f:	89 d1                	mov    %edx,%ecx
  802361:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802365:	d3 e8                	shr    %cl,%eax
  802367:	09 c5                	or     %eax,%ebp
  802369:	8b 44 24 04          	mov    0x4(%esp),%eax
  80236d:	89 c1                	mov    %eax,%ecx
  80236f:	d3 e7                	shl    %cl,%edi
  802371:	89 d1                	mov    %edx,%ecx
  802373:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802377:	89 df                	mov    %ebx,%edi
  802379:	d3 ef                	shr    %cl,%edi
  80237b:	89 c1                	mov    %eax,%ecx
  80237d:	89 f0                	mov    %esi,%eax
  80237f:	d3 e3                	shl    %cl,%ebx
  802381:	89 d1                	mov    %edx,%ecx
  802383:	89 fa                	mov    %edi,%edx
  802385:	d3 e8                	shr    %cl,%eax
  802387:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80238c:	09 d8                	or     %ebx,%eax
  80238e:	f7 f5                	div    %ebp
  802390:	d3 e6                	shl    %cl,%esi
  802392:	89 d1                	mov    %edx,%ecx
  802394:	f7 64 24 08          	mull   0x8(%esp)
  802398:	39 d1                	cmp    %edx,%ecx
  80239a:	89 c3                	mov    %eax,%ebx
  80239c:	89 d7                	mov    %edx,%edi
  80239e:	72 06                	jb     8023a6 <__umoddi3+0xa6>
  8023a0:	75 0e                	jne    8023b0 <__umoddi3+0xb0>
  8023a2:	39 c6                	cmp    %eax,%esi
  8023a4:	73 0a                	jae    8023b0 <__umoddi3+0xb0>
  8023a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8023aa:	19 ea                	sbb    %ebp,%edx
  8023ac:	89 d7                	mov    %edx,%edi
  8023ae:	89 c3                	mov    %eax,%ebx
  8023b0:	89 ca                	mov    %ecx,%edx
  8023b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8023b7:	29 de                	sub    %ebx,%esi
  8023b9:	19 fa                	sbb    %edi,%edx
  8023bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8023bf:	89 d0                	mov    %edx,%eax
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 d9                	mov    %ebx,%ecx
  8023c5:	d3 ee                	shr    %cl,%esi
  8023c7:	d3 ea                	shr    %cl,%edx
  8023c9:	09 f0                	or     %esi,%eax
  8023cb:	83 c4 1c             	add    $0x1c,%esp
  8023ce:	5b                   	pop    %ebx
  8023cf:	5e                   	pop    %esi
  8023d0:	5f                   	pop    %edi
  8023d1:	5d                   	pop    %ebp
  8023d2:	c3                   	ret    
  8023d3:	90                   	nop
  8023d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	85 ff                	test   %edi,%edi
  8023da:	89 f9                	mov    %edi,%ecx
  8023dc:	75 0b                	jne    8023e9 <__umoddi3+0xe9>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f7                	div    %edi
  8023e7:	89 c1                	mov    %eax,%ecx
  8023e9:	89 d8                	mov    %ebx,%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	f7 f1                	div    %ecx
  8023ef:	89 f0                	mov    %esi,%eax
  8023f1:	f7 f1                	div    %ecx
  8023f3:	e9 31 ff ff ff       	jmp    802329 <__umoddi3+0x29>
  8023f8:	90                   	nop
  8023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802400:	39 dd                	cmp    %ebx,%ebp
  802402:	72 08                	jb     80240c <__umoddi3+0x10c>
  802404:	39 f7                	cmp    %esi,%edi
  802406:	0f 87 21 ff ff ff    	ja     80232d <__umoddi3+0x2d>
  80240c:	89 da                	mov    %ebx,%edx
  80240e:	89 f0                	mov    %esi,%eax
  802410:	29 f8                	sub    %edi,%eax
  802412:	19 ea                	sbb    %ebp,%edx
  802414:	e9 14 ff ff ff       	jmp    80232d <__umoddi3+0x2d>
