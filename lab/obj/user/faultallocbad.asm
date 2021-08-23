
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
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
  800045:	e8 a6 01 00 00       	call   8001f0 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 28 0c 00 00       	call   800c86 <sys_page_alloc>
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
  80006e:	e8 c9 07 00 00       	call   80083c <snprintf>
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
  800085:	6a 0f                	push   $0xf
  800087:	68 2a 24 80 00       	push   $0x80242a
  80008c:	e8 84 00 00 00       	call   800115 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 f5 0d 00 00       	call   800e96 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 1a 0b 00 00       	call   800bca <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 83 0b 00 00       	call   800c48 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 a5 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800101:	e8 05 10 00 00       	call   80110b <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 f7 0a 00 00       	call   800c07 <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80011a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80011d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800123:	e8 20 0b 00 00       	call   800c48 <sys_getenvid>
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 0c             	pushl  0xc(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	56                   	push   %esi
  800132:	50                   	push   %eax
  800133:	68 98 24 80 00       	push   $0x802498
  800138:	e8 b3 00 00 00       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80013d:	83 c4 18             	add    $0x18,%esp
  800140:	53                   	push   %ebx
  800141:	ff 75 10             	pushl  0x10(%ebp)
  800144:	e8 56 00 00 00       	call   80019f <vcprintf>
	cprintf("\n");
  800149:	c7 04 24 1b 29 80 00 	movl   $0x80291b,(%esp)
  800150:	e8 9b 00 00 00       	call   8001f0 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800158:	cc                   	int3   
  800159:	eb fd                	jmp    800158 <_panic+0x43>

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 36 0a 00 00       	call   800bca <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 1a 01 00 00       	call   8002ed <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 e2 09 00 00       	call   800bca <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800228:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022b:	39 d3                	cmp    %edx,%ebx
  80022d:	72 05                	jb     800234 <printnum+0x30>
  80022f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800232:	77 7a                	ja     8002ae <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	8b 45 14             	mov    0x14(%ebp),%eax
  80023d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800240:	53                   	push   %ebx
  800241:	ff 75 10             	pushl  0x10(%ebp)
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024a:	ff 75 e0             	pushl  -0x20(%ebp)
  80024d:	ff 75 dc             	pushl  -0x24(%ebp)
  800250:	ff 75 d8             	pushl  -0x28(%ebp)
  800253:	e8 78 1f 00 00       	call   8021d0 <__udivdi3>
  800258:	83 c4 18             	add    $0x18,%esp
  80025b:	52                   	push   %edx
  80025c:	50                   	push   %eax
  80025d:	89 f2                	mov    %esi,%edx
  80025f:	89 f8                	mov    %edi,%eax
  800261:	e8 9e ff ff ff       	call   800204 <printnum>
  800266:	83 c4 20             	add    $0x20,%esp
  800269:	eb 13                	jmp    80027e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	56                   	push   %esi
  80026f:	ff 75 18             	pushl  0x18(%ebp)
  800272:	ff d7                	call   *%edi
  800274:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	85 db                	test   %ebx,%ebx
  80027c:	7f ed                	jg     80026b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	56                   	push   %esi
  800282:	83 ec 04             	sub    $0x4,%esp
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	ff 75 dc             	pushl  -0x24(%ebp)
  80028e:	ff 75 d8             	pushl  -0x28(%ebp)
  800291:	e8 5a 20 00 00       	call   8022f0 <__umoddi3>
  800296:	83 c4 14             	add    $0x14,%esp
  800299:	0f be 80 bb 24 80 00 	movsbl 0x8024bb(%eax),%eax
  8002a0:	50                   	push   %eax
  8002a1:	ff d7                	call   *%edi
}
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    
  8002ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b1:	eb c4                	jmp    800277 <printnum+0x73>

008002b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c2:	73 0a                	jae    8002ce <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	88 02                	mov    %al,(%edx)
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <printfmt>:
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d9:	50                   	push   %eax
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 05 00 00 00       	call   8002ed <vprintfmt>
}
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <vprintfmt>:
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 2c             	sub    $0x2c,%esp
  8002f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ff:	e9 21 04 00 00       	jmp    800725 <vprintfmt+0x438>
		padc = ' ';
  800304:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800308:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80030f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800316:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8d 47 01             	lea    0x1(%edi),%eax
  800325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800328:	0f b6 17             	movzbl (%edi),%edx
  80032b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032e:	3c 55                	cmp    $0x55,%al
  800330:	0f 87 90 04 00 00    	ja     8007c6 <vprintfmt+0x4d9>
  800336:	0f b6 c0             	movzbl %al,%eax
  800339:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  800340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800343:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800347:	eb d9                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800350:	eb d0                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800352:	0f b6 d2             	movzbl %dl,%edx
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800360:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800363:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800367:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036d:	83 f9 09             	cmp    $0x9,%ecx
  800370:	77 55                	ja     8003c7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800372:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800375:	eb e9                	jmp    800360 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8d 40 04             	lea    0x4(%eax),%eax
  800385:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	79 91                	jns    800322 <vprintfmt+0x35>
				width = precision, precision = -1;
  800391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800397:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039e:	eb 82                	jmp    800322 <vprintfmt+0x35>
  8003a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a3:	85 c0                	test   %eax,%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	0f 49 d0             	cmovns %eax,%edx
  8003ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	e9 6a ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003bb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003c2:	e9 5b ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003cd:	eb bc                	jmp    80038b <vprintfmt+0x9e>
			lflag++;
  8003cf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d5:	e9 48 ff ff ff       	jmp    800322 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	53                   	push   %ebx
  8003e4:	ff 30                	pushl  (%eax)
  8003e6:	ff d6                	call   *%esi
			break;
  8003e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ee:	e9 2f 03 00 00       	jmp    800722 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 78 04             	lea    0x4(%eax),%edi
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	99                   	cltd   
  8003fc:	31 d0                	xor    %edx,%eax
  8003fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800400:	83 f8 0f             	cmp    $0xf,%eax
  800403:	7f 23                	jg     800428 <vprintfmt+0x13b>
  800405:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  80040c:	85 d2                	test   %edx,%edx
  80040e:	74 18                	je     800428 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800410:	52                   	push   %edx
  800411:	68 e2 28 80 00       	push   $0x8028e2
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 b3 fe ff ff       	call   8002d0 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
  800423:	e9 fa 02 00 00       	jmp    800722 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800428:	50                   	push   %eax
  800429:	68 d3 24 80 00       	push   $0x8024d3
  80042e:	53                   	push   %ebx
  80042f:	56                   	push   %esi
  800430:	e8 9b fe ff ff       	call   8002d0 <printfmt>
  800435:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800438:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043b:	e9 e2 02 00 00       	jmp    800722 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	83 c0 04             	add    $0x4,%eax
  800446:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80044e:	85 ff                	test   %edi,%edi
  800450:	b8 cc 24 80 00       	mov    $0x8024cc,%eax
  800455:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800458:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045c:	0f 8e bd 00 00 00    	jle    80051f <vprintfmt+0x232>
  800462:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800466:	75 0e                	jne    800476 <vprintfmt+0x189>
  800468:	89 75 08             	mov    %esi,0x8(%ebp)
  80046b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800471:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800474:	eb 6d                	jmp    8004e3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 d0             	pushl  -0x30(%ebp)
  80047c:	57                   	push   %edi
  80047d:	e8 ec 03 00 00       	call   80086e <strnlen>
  800482:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800485:	29 c1                	sub    %eax,%ecx
  800487:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80048d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800497:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	eb 0f                	jmp    8004aa <vprintfmt+0x1bd>
					putch(padc, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	83 ef 01             	sub    $0x1,%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	85 ff                	test   %edi,%edi
  8004ac:	7f ed                	jg     80049b <vprintfmt+0x1ae>
  8004ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	0f 49 c1             	cmovns %ecx,%eax
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c9:	89 cb                	mov    %ecx,%ebx
  8004cb:	eb 16                	jmp    8004e3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d1:	75 31                	jne    800504 <vprintfmt+0x217>
					putch(ch, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	ff 55 08             	call   *0x8(%ebp)
  8004dd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e0:	83 eb 01             	sub    $0x1,%ebx
  8004e3:	83 c7 01             	add    $0x1,%edi
  8004e6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ea:	0f be c2             	movsbl %dl,%eax
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	74 59                	je     80054a <vprintfmt+0x25d>
  8004f1:	85 f6                	test   %esi,%esi
  8004f3:	78 d8                	js     8004cd <vprintfmt+0x1e0>
  8004f5:	83 ee 01             	sub    $0x1,%esi
  8004f8:	79 d3                	jns    8004cd <vprintfmt+0x1e0>
  8004fa:	89 df                	mov    %ebx,%edi
  8004fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800502:	eb 37                	jmp    80053b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800504:	0f be d2             	movsbl %dl,%edx
  800507:	83 ea 20             	sub    $0x20,%edx
  80050a:	83 fa 5e             	cmp    $0x5e,%edx
  80050d:	76 c4                	jbe    8004d3 <vprintfmt+0x1e6>
					putch('?', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	6a 3f                	push   $0x3f
  800517:	ff 55 08             	call   *0x8(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	eb c1                	jmp    8004e0 <vprintfmt+0x1f3>
  80051f:	89 75 08             	mov    %esi,0x8(%ebp)
  800522:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800525:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800528:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052b:	eb b6                	jmp    8004e3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 20                	push   $0x20
  800533:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800535:	83 ef 01             	sub    $0x1,%edi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 ff                	test   %edi,%edi
  80053d:	7f ee                	jg     80052d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 d8 01 00 00       	jmp    800722 <vprintfmt+0x435>
  80054a:	89 df                	mov    %ebx,%edi
  80054c:	8b 75 08             	mov    0x8(%ebp),%esi
  80054f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800552:	eb e7                	jmp    80053b <vprintfmt+0x24e>
	if (lflag >= 2)
  800554:	83 f9 01             	cmp    $0x1,%ecx
  800557:	7e 45                	jle    80059e <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 50 04             	mov    0x4(%eax),%edx
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 08             	lea    0x8(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800570:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800574:	79 62                	jns    8005d8 <vprintfmt+0x2eb>
				putch('-', putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	53                   	push   %ebx
  80057a:	6a 2d                	push   $0x2d
  80057c:	ff d6                	call   *%esi
				num = -(long long) num;
  80057e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800581:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800584:	f7 d8                	neg    %eax
  800586:	83 d2 00             	adc    $0x0,%edx
  800589:	f7 da                	neg    %edx
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800591:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800594:	ba 0a 00 00 00       	mov    $0xa,%edx
  800599:	e9 66 01 00 00       	jmp    800704 <vprintfmt+0x417>
	else if (lflag)
  80059e:	85 c9                	test   %ecx,%ecx
  8005a0:	75 1b                	jne    8005bd <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005aa:	89 c1                	mov    %eax,%ecx
  8005ac:	c1 f9 1f             	sar    $0x1f,%ecx
  8005af:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bb:	eb b3                	jmp    800570 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c5:	89 c1                	mov    %eax,%ecx
  8005c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d6:	eb 98                	jmp    800570 <vprintfmt+0x283>
			base = 10;
  8005d8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005dd:	e9 22 01 00 00       	jmp    800704 <vprintfmt+0x417>
	if (lflag >= 2)
  8005e2:	83 f9 01             	cmp    $0x1,%ecx
  8005e5:	7e 21                	jle    800608 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 50 04             	mov    0x4(%eax),%edx
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 40 08             	lea    0x8(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fe:	ba 0a 00 00 00       	mov    $0xa,%edx
  800603:	e9 fc 00 00 00       	jmp    800704 <vprintfmt+0x417>
	else if (lflag)
  800608:	85 c9                	test   %ecx,%ecx
  80060a:	75 23                	jne    80062f <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	ba 00 00 00 00       	mov    $0x0,%edx
  800616:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800619:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800625:	ba 0a 00 00 00       	mov    $0xa,%edx
  80062a:	e9 d5 00 00 00       	jmp    800704 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	ba 00 00 00 00       	mov    $0x0,%edx
  800639:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800648:	ba 0a 00 00 00       	mov    $0xa,%edx
  80064d:	e9 b2 00 00 00       	jmp    800704 <vprintfmt+0x417>
	if (lflag >= 2)
  800652:	83 f9 01             	cmp    $0x1,%ecx
  800655:	7e 42                	jle    800699 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 50 04             	mov    0x4(%eax),%edx
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800662:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 08             	lea    0x8(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066e:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800673:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800677:	0f 89 87 00 00 00    	jns    800704 <vprintfmt+0x417>
				putch('-', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 2d                	push   $0x2d
  800683:	ff d6                	call   *%esi
				num = -(long long) num;
  800685:	f7 5d d8             	negl   -0x28(%ebp)
  800688:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80068c:	f7 5d dc             	negl   -0x24(%ebp)
  80068f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800692:	ba 08 00 00 00       	mov    $0x8,%edx
  800697:	eb 6b                	jmp    800704 <vprintfmt+0x417>
	else if (lflag)
  800699:	85 c9                	test   %ecx,%ecx
  80069b:	75 1b                	jne    8006b8 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b6:	eb b6                	jmp    80066e <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d1:	eb 9b                	jmp    80066e <vprintfmt+0x381>
			putch('0', putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	6a 30                	push   $0x30
  8006d9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006db:	83 c4 08             	add    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	6a 78                	push   $0x78
  8006e1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006f3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ff:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800704:	83 ec 0c             	sub    $0xc,%esp
  800707:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	ff 75 e0             	pushl  -0x20(%ebp)
  80070f:	52                   	push   %edx
  800710:	ff 75 dc             	pushl  -0x24(%ebp)
  800713:	ff 75 d8             	pushl  -0x28(%ebp)
  800716:	89 da                	mov    %ebx,%edx
  800718:	89 f0                	mov    %esi,%eax
  80071a:	e8 e5 fa ff ff       	call   800204 <printnum>
			break;
  80071f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800722:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	83 c7 01             	add    $0x1,%edi
  800728:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072c:	83 f8 25             	cmp    $0x25,%eax
  80072f:	0f 84 cf fb ff ff    	je     800304 <vprintfmt+0x17>
			if (ch == '\0')
  800735:	85 c0                	test   %eax,%eax
  800737:	0f 84 a9 00 00 00    	je     8007e6 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	50                   	push   %eax
  800742:	ff d6                	call   *%esi
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	eb dc                	jmp    800725 <vprintfmt+0x438>
	if (lflag >= 2)
  800749:	83 f9 01             	cmp    $0x1,%ecx
  80074c:	7e 1e                	jle    80076c <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 50 04             	mov    0x4(%eax),%edx
  800754:	8b 00                	mov    (%eax),%eax
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8d 40 08             	lea    0x8(%eax),%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800765:	ba 10 00 00 00       	mov    $0x10,%edx
  80076a:	eb 98                	jmp    800704 <vprintfmt+0x417>
	else if (lflag)
  80076c:	85 c9                	test   %ecx,%ecx
  80076e:	75 23                	jne    800793 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
  80077a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800789:	ba 10 00 00 00       	mov    $0x10,%edx
  80078e:	e9 71 ff ff ff       	jmp    800704 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	ba 00 00 00 00       	mov    $0x0,%edx
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ac:	ba 10 00 00 00       	mov    $0x10,%edx
  8007b1:	e9 4e ff ff ff       	jmp    800704 <vprintfmt+0x417>
			putch(ch, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 25                	push   $0x25
  8007bc:	ff d6                	call   *%esi
			break;
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	e9 5c ff ff ff       	jmp    800722 <vprintfmt+0x435>
			putch('%', putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	6a 25                	push   $0x25
  8007cc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 f8                	mov    %edi,%eax
  8007d3:	eb 03                	jmp    8007d8 <vprintfmt+0x4eb>
  8007d5:	83 e8 01             	sub    $0x1,%eax
  8007d8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007dc:	75 f7                	jne    8007d5 <vprintfmt+0x4e8>
  8007de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e1:	e9 3c ff ff ff       	jmp    800722 <vprintfmt+0x435>
}
  8007e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e9:	5b                   	pop    %ebx
  8007ea:	5e                   	pop    %esi
  8007eb:	5f                   	pop    %edi
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	83 ec 18             	sub    $0x18,%esp
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007fd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800801:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80080b:	85 c0                	test   %eax,%eax
  80080d:	74 26                	je     800835 <vsnprintf+0x47>
  80080f:	85 d2                	test   %edx,%edx
  800811:	7e 22                	jle    800835 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800813:	ff 75 14             	pushl  0x14(%ebp)
  800816:	ff 75 10             	pushl  0x10(%ebp)
  800819:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80081c:	50                   	push   %eax
  80081d:	68 b3 02 80 00       	push   $0x8002b3
  800822:	e8 c6 fa ff ff       	call   8002ed <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800830:	83 c4 10             	add    $0x10,%esp
}
  800833:	c9                   	leave  
  800834:	c3                   	ret    
		return -E_INVAL;
  800835:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083a:	eb f7                	jmp    800833 <vsnprintf+0x45>

0080083c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800842:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800845:	50                   	push   %eax
  800846:	ff 75 10             	pushl  0x10(%ebp)
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 9a ff ff ff       	call   8007ee <vsnprintf>
	va_end(ap);

	return rc;
}
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80085c:	b8 00 00 00 00       	mov    $0x0,%eax
  800861:	eb 03                	jmp    800866 <strlen+0x10>
		n++;
  800863:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800866:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80086a:	75 f7                	jne    800863 <strlen+0xd>
	return n;
}
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800874:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	eb 03                	jmp    800881 <strnlen+0x13>
		n++;
  80087e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800881:	39 d0                	cmp    %edx,%eax
  800883:	74 06                	je     80088b <strnlen+0x1d>
  800885:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800889:	75 f3                	jne    80087e <strnlen+0x10>
	return n;
}
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	53                   	push   %ebx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800897:	89 c2                	mov    %eax,%edx
  800899:	83 c1 01             	add    $0x1,%ecx
  80089c:	83 c2 01             	add    $0x1,%edx
  80089f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008a3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a6:	84 db                	test   %bl,%bl
  8008a8:	75 ef                	jne    800899 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008aa:	5b                   	pop    %ebx
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	53                   	push   %ebx
  8008b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b4:	53                   	push   %ebx
  8008b5:	e8 9c ff ff ff       	call   800856 <strlen>
  8008ba:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	01 d8                	add    %ebx,%eax
  8008c2:	50                   	push   %eax
  8008c3:	e8 c5 ff ff ff       	call   80088d <strcpy>
	return dst;
}
  8008c8:	89 d8                	mov    %ebx,%eax
  8008ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	56                   	push   %esi
  8008d3:	53                   	push   %ebx
  8008d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008da:	89 f3                	mov    %esi,%ebx
  8008dc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008df:	89 f2                	mov    %esi,%edx
  8008e1:	eb 0f                	jmp    8008f2 <strncpy+0x23>
		*dst++ = *src;
  8008e3:	83 c2 01             	add    $0x1,%edx
  8008e6:	0f b6 01             	movzbl (%ecx),%eax
  8008e9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ec:	80 39 01             	cmpb   $0x1,(%ecx)
  8008ef:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008f2:	39 da                	cmp    %ebx,%edx
  8008f4:	75 ed                	jne    8008e3 <strncpy+0x14>
	}
	return ret;
}
  8008f6:	89 f0                	mov    %esi,%eax
  8008f8:	5b                   	pop    %ebx
  8008f9:	5e                   	pop    %esi
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	56                   	push   %esi
  800900:	53                   	push   %ebx
  800901:	8b 75 08             	mov    0x8(%ebp),%esi
  800904:	8b 55 0c             	mov    0xc(%ebp),%edx
  800907:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80090a:	89 f0                	mov    %esi,%eax
  80090c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800910:	85 c9                	test   %ecx,%ecx
  800912:	75 0b                	jne    80091f <strlcpy+0x23>
  800914:	eb 17                	jmp    80092d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	83 c0 01             	add    $0x1,%eax
  80091c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80091f:	39 d8                	cmp    %ebx,%eax
  800921:	74 07                	je     80092a <strlcpy+0x2e>
  800923:	0f b6 0a             	movzbl (%edx),%ecx
  800926:	84 c9                	test   %cl,%cl
  800928:	75 ec                	jne    800916 <strlcpy+0x1a>
		*dst = '\0';
  80092a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80092d:	29 f0                	sub    %esi,%eax
}
  80092f:	5b                   	pop    %ebx
  800930:	5e                   	pop    %esi
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80093c:	eb 06                	jmp    800944 <strcmp+0x11>
		p++, q++;
  80093e:	83 c1 01             	add    $0x1,%ecx
  800941:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800944:	0f b6 01             	movzbl (%ecx),%eax
  800947:	84 c0                	test   %al,%al
  800949:	74 04                	je     80094f <strcmp+0x1c>
  80094b:	3a 02                	cmp    (%edx),%al
  80094d:	74 ef                	je     80093e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80094f:	0f b6 c0             	movzbl %al,%eax
  800952:	0f b6 12             	movzbl (%edx),%edx
  800955:	29 d0                	sub    %edx,%eax
}
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	53                   	push   %ebx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
  800963:	89 c3                	mov    %eax,%ebx
  800965:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800968:	eb 06                	jmp    800970 <strncmp+0x17>
		n--, p++, q++;
  80096a:	83 c0 01             	add    $0x1,%eax
  80096d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800970:	39 d8                	cmp    %ebx,%eax
  800972:	74 16                	je     80098a <strncmp+0x31>
  800974:	0f b6 08             	movzbl (%eax),%ecx
  800977:	84 c9                	test   %cl,%cl
  800979:	74 04                	je     80097f <strncmp+0x26>
  80097b:	3a 0a                	cmp    (%edx),%cl
  80097d:	74 eb                	je     80096a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80097f:	0f b6 00             	movzbl (%eax),%eax
  800982:	0f b6 12             	movzbl (%edx),%edx
  800985:	29 d0                	sub    %edx,%eax
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    
		return 0;
  80098a:	b8 00 00 00 00       	mov    $0x0,%eax
  80098f:	eb f6                	jmp    800987 <strncmp+0x2e>

00800991 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80099b:	0f b6 10             	movzbl (%eax),%edx
  80099e:	84 d2                	test   %dl,%dl
  8009a0:	74 09                	je     8009ab <strchr+0x1a>
		if (*s == c)
  8009a2:	38 ca                	cmp    %cl,%dl
  8009a4:	74 0a                	je     8009b0 <strchr+0x1f>
	for (; *s; s++)
  8009a6:	83 c0 01             	add    $0x1,%eax
  8009a9:	eb f0                	jmp    80099b <strchr+0xa>
			return (char *) s;
	return 0;
  8009ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009bc:	eb 03                	jmp    8009c1 <strfind+0xf>
  8009be:	83 c0 01             	add    $0x1,%eax
  8009c1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009c4:	38 ca                	cmp    %cl,%dl
  8009c6:	74 04                	je     8009cc <strfind+0x1a>
  8009c8:	84 d2                	test   %dl,%dl
  8009ca:	75 f2                	jne    8009be <strfind+0xc>
			break;
	return (char *) s;
}
  8009cc:	5d                   	pop    %ebp
  8009cd:	c3                   	ret    

008009ce <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	57                   	push   %edi
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009da:	85 c9                	test   %ecx,%ecx
  8009dc:	74 13                	je     8009f1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009de:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e4:	75 05                	jne    8009eb <memset+0x1d>
  8009e6:	f6 c1 03             	test   $0x3,%cl
  8009e9:	74 0d                	je     8009f8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ee:	fc                   	cld    
  8009ef:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009f1:	89 f8                	mov    %edi,%eax
  8009f3:	5b                   	pop    %ebx
  8009f4:	5e                   	pop    %esi
  8009f5:	5f                   	pop    %edi
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    
		c &= 0xFF;
  8009f8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009fc:	89 d3                	mov    %edx,%ebx
  8009fe:	c1 e3 08             	shl    $0x8,%ebx
  800a01:	89 d0                	mov    %edx,%eax
  800a03:	c1 e0 18             	shl    $0x18,%eax
  800a06:	89 d6                	mov    %edx,%esi
  800a08:	c1 e6 10             	shl    $0x10,%esi
  800a0b:	09 f0                	or     %esi,%eax
  800a0d:	09 c2                	or     %eax,%edx
  800a0f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a11:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a14:	89 d0                	mov    %edx,%eax
  800a16:	fc                   	cld    
  800a17:	f3 ab                	rep stos %eax,%es:(%edi)
  800a19:	eb d6                	jmp    8009f1 <memset+0x23>

00800a1b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	57                   	push   %edi
  800a1f:	56                   	push   %esi
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a29:	39 c6                	cmp    %eax,%esi
  800a2b:	73 35                	jae    800a62 <memmove+0x47>
  800a2d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	76 2e                	jbe    800a62 <memmove+0x47>
		s += n;
		d += n;
  800a34:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a37:	89 d6                	mov    %edx,%esi
  800a39:	09 fe                	or     %edi,%esi
  800a3b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a41:	74 0c                	je     800a4f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a43:	83 ef 01             	sub    $0x1,%edi
  800a46:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a49:	fd                   	std    
  800a4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a4c:	fc                   	cld    
  800a4d:	eb 21                	jmp    800a70 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4f:	f6 c1 03             	test   $0x3,%cl
  800a52:	75 ef                	jne    800a43 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a54:	83 ef 04             	sub    $0x4,%edi
  800a57:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a5d:	fd                   	std    
  800a5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a60:	eb ea                	jmp    800a4c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a62:	89 f2                	mov    %esi,%edx
  800a64:	09 c2                	or     %eax,%edx
  800a66:	f6 c2 03             	test   $0x3,%dl
  800a69:	74 09                	je     800a74 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a6b:	89 c7                	mov    %eax,%edi
  800a6d:	fc                   	cld    
  800a6e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a70:	5e                   	pop    %esi
  800a71:	5f                   	pop    %edi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a74:	f6 c1 03             	test   $0x3,%cl
  800a77:	75 f2                	jne    800a6b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a7c:	89 c7                	mov    %eax,%edi
  800a7e:	fc                   	cld    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a81:	eb ed                	jmp    800a70 <memmove+0x55>

00800a83 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a86:	ff 75 10             	pushl  0x10(%ebp)
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	ff 75 08             	pushl  0x8(%ebp)
  800a8f:	e8 87 ff ff ff       	call   800a1b <memmove>
}
  800a94:	c9                   	leave  
  800a95:	c3                   	ret    

00800a96 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa1:	89 c6                	mov    %eax,%esi
  800aa3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa6:	39 f0                	cmp    %esi,%eax
  800aa8:	74 1c                	je     800ac6 <memcmp+0x30>
		if (*s1 != *s2)
  800aaa:	0f b6 08             	movzbl (%eax),%ecx
  800aad:	0f b6 1a             	movzbl (%edx),%ebx
  800ab0:	38 d9                	cmp    %bl,%cl
  800ab2:	75 08                	jne    800abc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ab4:	83 c0 01             	add    $0x1,%eax
  800ab7:	83 c2 01             	add    $0x1,%edx
  800aba:	eb ea                	jmp    800aa6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800abc:	0f b6 c1             	movzbl %cl,%eax
  800abf:	0f b6 db             	movzbl %bl,%ebx
  800ac2:	29 d8                	sub    %ebx,%eax
  800ac4:	eb 05                	jmp    800acb <memcmp+0x35>
	}

	return 0;
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acb:	5b                   	pop    %ebx
  800acc:	5e                   	pop    %esi
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad8:	89 c2                	mov    %eax,%edx
  800ada:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800add:	39 d0                	cmp    %edx,%eax
  800adf:	73 09                	jae    800aea <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae1:	38 08                	cmp    %cl,(%eax)
  800ae3:	74 05                	je     800aea <memfind+0x1b>
	for (; s < ends; s++)
  800ae5:	83 c0 01             	add    $0x1,%eax
  800ae8:	eb f3                	jmp    800add <memfind+0xe>
			break;
	return (void *) s;
}
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af8:	eb 03                	jmp    800afd <strtol+0x11>
		s++;
  800afa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800afd:	0f b6 01             	movzbl (%ecx),%eax
  800b00:	3c 20                	cmp    $0x20,%al
  800b02:	74 f6                	je     800afa <strtol+0xe>
  800b04:	3c 09                	cmp    $0x9,%al
  800b06:	74 f2                	je     800afa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b08:	3c 2b                	cmp    $0x2b,%al
  800b0a:	74 2e                	je     800b3a <strtol+0x4e>
	int neg = 0;
  800b0c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b11:	3c 2d                	cmp    $0x2d,%al
  800b13:	74 2f                	je     800b44 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b15:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1b:	75 05                	jne    800b22 <strtol+0x36>
  800b1d:	80 39 30             	cmpb   $0x30,(%ecx)
  800b20:	74 2c                	je     800b4e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b22:	85 db                	test   %ebx,%ebx
  800b24:	75 0a                	jne    800b30 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b26:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b2b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b2e:	74 28                	je     800b58 <strtol+0x6c>
		base = 10;
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b38:	eb 50                	jmp    800b8a <strtol+0x9e>
		s++;
  800b3a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b42:	eb d1                	jmp    800b15 <strtol+0x29>
		s++, neg = 1;
  800b44:	83 c1 01             	add    $0x1,%ecx
  800b47:	bf 01 00 00 00       	mov    $0x1,%edi
  800b4c:	eb c7                	jmp    800b15 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b52:	74 0e                	je     800b62 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b54:	85 db                	test   %ebx,%ebx
  800b56:	75 d8                	jne    800b30 <strtol+0x44>
		s++, base = 8;
  800b58:	83 c1 01             	add    $0x1,%ecx
  800b5b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b60:	eb ce                	jmp    800b30 <strtol+0x44>
		s += 2, base = 16;
  800b62:	83 c1 02             	add    $0x2,%ecx
  800b65:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b6a:	eb c4                	jmp    800b30 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b6f:	89 f3                	mov    %esi,%ebx
  800b71:	80 fb 19             	cmp    $0x19,%bl
  800b74:	77 29                	ja     800b9f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b76:	0f be d2             	movsbl %dl,%edx
  800b79:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b7c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b7f:	7d 30                	jge    800bb1 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b81:	83 c1 01             	add    $0x1,%ecx
  800b84:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b88:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b8a:	0f b6 11             	movzbl (%ecx),%edx
  800b8d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b90:	89 f3                	mov    %esi,%ebx
  800b92:	80 fb 09             	cmp    $0x9,%bl
  800b95:	77 d5                	ja     800b6c <strtol+0x80>
			dig = *s - '0';
  800b97:	0f be d2             	movsbl %dl,%edx
  800b9a:	83 ea 30             	sub    $0x30,%edx
  800b9d:	eb dd                	jmp    800b7c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b9f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba2:	89 f3                	mov    %esi,%ebx
  800ba4:	80 fb 19             	cmp    $0x19,%bl
  800ba7:	77 08                	ja     800bb1 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba9:	0f be d2             	movsbl %dl,%edx
  800bac:	83 ea 37             	sub    $0x37,%edx
  800baf:	eb cb                	jmp    800b7c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb5:	74 05                	je     800bbc <strtol+0xd0>
		*endptr = (char *) s;
  800bb7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bba:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bbc:	89 c2                	mov    %eax,%edx
  800bbe:	f7 da                	neg    %edx
  800bc0:	85 ff                	test   %edi,%edi
  800bc2:	0f 45 c2             	cmovne %edx,%eax
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdb:	89 c3                	mov    %eax,%ebx
  800bdd:	89 c7                	mov    %eax,%edi
  800bdf:	89 c6                	mov    %eax,%esi
  800be1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bee:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf8:	89 d1                	mov    %edx,%ecx
  800bfa:	89 d3                	mov    %edx,%ebx
  800bfc:	89 d7                	mov    %edx,%edi
  800bfe:	89 d6                	mov    %edx,%esi
  800c00:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c15:	8b 55 08             	mov    0x8(%ebp),%edx
  800c18:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1d:	89 cb                	mov    %ecx,%ebx
  800c1f:	89 cf                	mov    %ecx,%edi
  800c21:	89 ce                	mov    %ecx,%esi
  800c23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c25:	85 c0                	test   %eax,%eax
  800c27:	7f 08                	jg     800c31 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2c:	5b                   	pop    %ebx
  800c2d:	5e                   	pop    %esi
  800c2e:	5f                   	pop    %edi
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c31:	83 ec 0c             	sub    $0xc,%esp
  800c34:	50                   	push   %eax
  800c35:	6a 03                	push   $0x3
  800c37:	68 bf 27 80 00       	push   $0x8027bf
  800c3c:	6a 23                	push   $0x23
  800c3e:	68 dc 27 80 00       	push   $0x8027dc
  800c43:	e8 cd f4 ff ff       	call   800115 <_panic>

00800c48 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	b8 02 00 00 00       	mov    $0x2,%eax
  800c58:	89 d1                	mov    %edx,%ecx
  800c5a:	89 d3                	mov    %edx,%ebx
  800c5c:	89 d7                	mov    %edx,%edi
  800c5e:	89 d6                	mov    %edx,%esi
  800c60:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_yield>:

void
sys_yield(void)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c77:	89 d1                	mov    %edx,%ecx
  800c79:	89 d3                	mov    %edx,%ebx
  800c7b:	89 d7                	mov    %edx,%edi
  800c7d:	89 d6                	mov    %edx,%esi
  800c7f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
  800c8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8f:	be 00 00 00 00       	mov    $0x0,%esi
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	89 f7                	mov    %esi,%edi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 04                	push   $0x4
  800cb8:	68 bf 27 80 00       	push   $0x8027bf
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 dc 27 80 00       	push   $0x8027dc
  800cc4:	e8 4c f4 ff ff       	call   800115 <_panic>

00800cc9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	b8 05 00 00 00       	mov    $0x5,%eax
  800cdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	7f 08                	jg     800cf4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	50                   	push   %eax
  800cf8:	6a 05                	push   $0x5
  800cfa:	68 bf 27 80 00       	push   $0x8027bf
  800cff:	6a 23                	push   $0x23
  800d01:	68 dc 27 80 00       	push   $0x8027dc
  800d06:	e8 0a f4 ff ff       	call   800115 <_panic>

00800d0b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	89 de                	mov    %ebx,%esi
  800d28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7f 08                	jg     800d36 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	6a 06                	push   $0x6
  800d3c:	68 bf 27 80 00       	push   $0x8027bf
  800d41:	6a 23                	push   $0x23
  800d43:	68 dc 27 80 00       	push   $0x8027dc
  800d48:	e8 c8 f3 ff ff       	call   800115 <_panic>

00800d4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d61:	b8 08 00 00 00       	mov    $0x8,%eax
  800d66:	89 df                	mov    %ebx,%edi
  800d68:	89 de                	mov    %ebx,%esi
  800d6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7f 08                	jg     800d78 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d78:	83 ec 0c             	sub    $0xc,%esp
  800d7b:	50                   	push   %eax
  800d7c:	6a 08                	push   $0x8
  800d7e:	68 bf 27 80 00       	push   $0x8027bf
  800d83:	6a 23                	push   $0x23
  800d85:	68 dc 27 80 00       	push   $0x8027dc
  800d8a:	e8 86 f3 ff ff       	call   800115 <_panic>

00800d8f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
  800d95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	b8 09 00 00 00       	mov    $0x9,%eax
  800da8:	89 df                	mov    %ebx,%edi
  800daa:	89 de                	mov    %ebx,%esi
  800dac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dae:	85 c0                	test   %eax,%eax
  800db0:	7f 08                	jg     800dba <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	50                   	push   %eax
  800dbe:	6a 09                	push   $0x9
  800dc0:	68 bf 27 80 00       	push   $0x8027bf
  800dc5:	6a 23                	push   $0x23
  800dc7:	68 dc 27 80 00       	push   $0x8027dc
  800dcc:	e8 44 f3 ff ff       	call   800115 <_panic>

00800dd1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dea:	89 df                	mov    %ebx,%edi
  800dec:	89 de                	mov    %ebx,%esi
  800dee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	7f 08                	jg     800dfc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	50                   	push   %eax
  800e00:	6a 0a                	push   $0xa
  800e02:	68 bf 27 80 00       	push   $0x8027bf
  800e07:	6a 23                	push   $0x23
  800e09:	68 dc 27 80 00       	push   $0x8027dc
  800e0e:	e8 02 f3 ff ff       	call   800115 <_panic>

00800e13 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e24:	be 00 00 00 00       	mov    $0x0,%esi
  800e29:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e4c:	89 cb                	mov    %ecx,%ebx
  800e4e:	89 cf                	mov    %ecx,%edi
  800e50:	89 ce                	mov    %ecx,%esi
  800e52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e54:	85 c0                	test   %eax,%eax
  800e56:	7f 08                	jg     800e60 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	50                   	push   %eax
  800e64:	6a 0d                	push   $0xd
  800e66:	68 bf 27 80 00       	push   $0x8027bf
  800e6b:	6a 23                	push   $0x23
  800e6d:	68 dc 27 80 00       	push   $0x8027dc
  800e72:	e8 9e f2 ff ff       	call   800115 <_panic>

00800e77 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e82:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e87:	89 d1                	mov    %edx,%ecx
  800e89:	89 d3                	mov    %edx,%ebx
  800e8b:	89 d7                	mov    %edx,%edi
  800e8d:	89 d6                	mov    %edx,%esi
  800e8f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e9c:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800ea3:	74 0a                	je     800eaf <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800eaf:	a1 08 40 80 00       	mov    0x804008,%eax
  800eb4:	8b 40 48             	mov    0x48(%eax),%eax
  800eb7:	83 ec 04             	sub    $0x4,%esp
  800eba:	6a 07                	push   $0x7
  800ebc:	68 00 f0 bf ee       	push   $0xeebff000
  800ec1:	50                   	push   %eax
  800ec2:	e8 bf fd ff ff       	call   800c86 <sys_page_alloc>
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 2f                	jne    800efd <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  800ece:	a1 08 40 80 00       	mov    0x804008,%eax
  800ed3:	8b 40 48             	mov    0x48(%eax),%eax
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	68 0f 0f 80 00       	push   $0x800f0f
  800ede:	50                   	push   %eax
  800edf:	e8 ed fe ff ff       	call   800dd1 <sys_env_set_pgfault_upcall>
  800ee4:	83 c4 10             	add    $0x10,%esp
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	74 ba                	je     800ea5 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  800eeb:	50                   	push   %eax
  800eec:	68 ea 27 80 00       	push   $0x8027ea
  800ef1:	6a 24                	push   $0x24
  800ef3:	68 02 28 80 00       	push   $0x802802
  800ef8:	e8 18 f2 ff ff       	call   800115 <_panic>
		    panic("set_pgfault_handler: %e", r);
  800efd:	50                   	push   %eax
  800efe:	68 ea 27 80 00       	push   $0x8027ea
  800f03:	6a 21                	push   $0x21
  800f05:	68 02 28 80 00       	push   $0x802802
  800f0a:	e8 06 f2 ff ff       	call   800115 <_panic>

00800f0f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f0f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f10:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f15:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f17:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  800f1a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  800f1e:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  800f21:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  800f25:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  800f29:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  800f2b:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  800f2e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  800f2f:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  800f32:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  800f33:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800f34:	c3                   	ret    

00800f35 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	05 00 00 00 30       	add    $0x30000000,%eax
  800f40:	c1 e8 0c             	shr    $0xc,%eax
}
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f55:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f62:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f67:	89 c2                	mov    %eax,%edx
  800f69:	c1 ea 16             	shr    $0x16,%edx
  800f6c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f73:	f6 c2 01             	test   $0x1,%dl
  800f76:	74 2a                	je     800fa2 <fd_alloc+0x46>
  800f78:	89 c2                	mov    %eax,%edx
  800f7a:	c1 ea 0c             	shr    $0xc,%edx
  800f7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f84:	f6 c2 01             	test   $0x1,%dl
  800f87:	74 19                	je     800fa2 <fd_alloc+0x46>
  800f89:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f8e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f93:	75 d2                	jne    800f67 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f95:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f9b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fa0:	eb 07                	jmp    800fa9 <fd_alloc+0x4d>
			*fd_store = fd;
  800fa2:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fb1:	83 f8 1f             	cmp    $0x1f,%eax
  800fb4:	77 36                	ja     800fec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb6:	c1 e0 0c             	shl    $0xc,%eax
  800fb9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fbe:	89 c2                	mov    %eax,%edx
  800fc0:	c1 ea 16             	shr    $0x16,%edx
  800fc3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fca:	f6 c2 01             	test   $0x1,%dl
  800fcd:	74 24                	je     800ff3 <fd_lookup+0x48>
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	c1 ea 0c             	shr    $0xc,%edx
  800fd4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fdb:	f6 c2 01             	test   $0x1,%dl
  800fde:	74 1a                	je     800ffa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe3:	89 02                	mov    %eax,(%edx)
	return 0;
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		return -E_INVAL;
  800fec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff1:	eb f7                	jmp    800fea <fd_lookup+0x3f>
		return -E_INVAL;
  800ff3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff8:	eb f0                	jmp    800fea <fd_lookup+0x3f>
  800ffa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fff:	eb e9                	jmp    800fea <fd_lookup+0x3f>

00801001 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 08             	sub    $0x8,%esp
  801007:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100a:	ba 8c 28 80 00       	mov    $0x80288c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80100f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801014:	39 08                	cmp    %ecx,(%eax)
  801016:	74 33                	je     80104b <dev_lookup+0x4a>
  801018:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80101b:	8b 02                	mov    (%edx),%eax
  80101d:	85 c0                	test   %eax,%eax
  80101f:	75 f3                	jne    801014 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801021:	a1 08 40 80 00       	mov    0x804008,%eax
  801026:	8b 40 48             	mov    0x48(%eax),%eax
  801029:	83 ec 04             	sub    $0x4,%esp
  80102c:	51                   	push   %ecx
  80102d:	50                   	push   %eax
  80102e:	68 10 28 80 00       	push   $0x802810
  801033:	e8 b8 f1 ff ff       	call   8001f0 <cprintf>
	*dev = 0;
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    
			*dev = devtab[i];
  80104b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
  801055:	eb f2                	jmp    801049 <dev_lookup+0x48>

00801057 <fd_close>:
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	83 ec 1c             	sub    $0x1c,%esp
  801060:	8b 75 08             	mov    0x8(%ebp),%esi
  801063:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801066:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801069:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801070:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801073:	50                   	push   %eax
  801074:	e8 32 ff ff ff       	call   800fab <fd_lookup>
  801079:	89 c3                	mov    %eax,%ebx
  80107b:	83 c4 08             	add    $0x8,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 05                	js     801087 <fd_close+0x30>
	    || fd != fd2)
  801082:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801085:	74 16                	je     80109d <fd_close+0x46>
		return (must_exist ? r : 0);
  801087:	89 f8                	mov    %edi,%eax
  801089:	84 c0                	test   %al,%al
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
  801090:	0f 44 d8             	cmove  %eax,%ebx
}
  801093:	89 d8                	mov    %ebx,%eax
  801095:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010a3:	50                   	push   %eax
  8010a4:	ff 36                	pushl  (%esi)
  8010a6:	e8 56 ff ff ff       	call   801001 <dev_lookup>
  8010ab:	89 c3                	mov    %eax,%ebx
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	78 15                	js     8010c9 <fd_close+0x72>
		if (dev->dev_close)
  8010b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b7:	8b 40 10             	mov    0x10(%eax),%eax
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	74 1b                	je     8010d9 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8010be:	83 ec 0c             	sub    $0xc,%esp
  8010c1:	56                   	push   %esi
  8010c2:	ff d0                	call   *%eax
  8010c4:	89 c3                	mov    %eax,%ebx
  8010c6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	56                   	push   %esi
  8010cd:	6a 00                	push   $0x0
  8010cf:	e8 37 fc ff ff       	call   800d0b <sys_page_unmap>
	return r;
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	eb ba                	jmp    801093 <fd_close+0x3c>
			r = 0;
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	eb e9                	jmp    8010c9 <fd_close+0x72>

008010e0 <close>:

int
close(int fdnum)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e9:	50                   	push   %eax
  8010ea:	ff 75 08             	pushl  0x8(%ebp)
  8010ed:	e8 b9 fe ff ff       	call   800fab <fd_lookup>
  8010f2:	83 c4 08             	add    $0x8,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	78 10                	js     801109 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	6a 01                	push   $0x1
  8010fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801101:	e8 51 ff ff ff       	call   801057 <fd_close>
  801106:	83 c4 10             	add    $0x10,%esp
}
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <close_all>:

void
close_all(void)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	53                   	push   %ebx
  80110f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801112:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	53                   	push   %ebx
  80111b:	e8 c0 ff ff ff       	call   8010e0 <close>
	for (i = 0; i < MAXFD; i++)
  801120:	83 c3 01             	add    $0x1,%ebx
  801123:	83 c4 10             	add    $0x10,%esp
  801126:	83 fb 20             	cmp    $0x20,%ebx
  801129:	75 ec                	jne    801117 <close_all+0xc>
}
  80112b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	57                   	push   %edi
  801134:	56                   	push   %esi
  801135:	53                   	push   %ebx
  801136:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801139:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80113c:	50                   	push   %eax
  80113d:	ff 75 08             	pushl  0x8(%ebp)
  801140:	e8 66 fe ff ff       	call   800fab <fd_lookup>
  801145:	89 c3                	mov    %eax,%ebx
  801147:	83 c4 08             	add    $0x8,%esp
  80114a:	85 c0                	test   %eax,%eax
  80114c:	0f 88 81 00 00 00    	js     8011d3 <dup+0xa3>
		return r;
	close(newfdnum);
  801152:	83 ec 0c             	sub    $0xc,%esp
  801155:	ff 75 0c             	pushl  0xc(%ebp)
  801158:	e8 83 ff ff ff       	call   8010e0 <close>

	newfd = INDEX2FD(newfdnum);
  80115d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801160:	c1 e6 0c             	shl    $0xc,%esi
  801163:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801169:	83 c4 04             	add    $0x4,%esp
  80116c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80116f:	e8 d1 fd ff ff       	call   800f45 <fd2data>
  801174:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801176:	89 34 24             	mov    %esi,(%esp)
  801179:	e8 c7 fd ff ff       	call   800f45 <fd2data>
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801183:	89 d8                	mov    %ebx,%eax
  801185:	c1 e8 16             	shr    $0x16,%eax
  801188:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80118f:	a8 01                	test   $0x1,%al
  801191:	74 11                	je     8011a4 <dup+0x74>
  801193:	89 d8                	mov    %ebx,%eax
  801195:	c1 e8 0c             	shr    $0xc,%eax
  801198:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80119f:	f6 c2 01             	test   $0x1,%dl
  8011a2:	75 39                	jne    8011dd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011a7:	89 d0                	mov    %edx,%eax
  8011a9:	c1 e8 0c             	shr    $0xc,%eax
  8011ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b3:	83 ec 0c             	sub    $0xc,%esp
  8011b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bb:	50                   	push   %eax
  8011bc:	56                   	push   %esi
  8011bd:	6a 00                	push   $0x0
  8011bf:	52                   	push   %edx
  8011c0:	6a 00                	push   $0x0
  8011c2:	e8 02 fb ff ff       	call   800cc9 <sys_page_map>
  8011c7:	89 c3                	mov    %eax,%ebx
  8011c9:	83 c4 20             	add    $0x20,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 31                	js     801201 <dup+0xd1>
		goto err;

	return newfdnum;
  8011d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011d3:	89 d8                	mov    %ebx,%eax
  8011d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5f                   	pop    %edi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ec:	50                   	push   %eax
  8011ed:	57                   	push   %edi
  8011ee:	6a 00                	push   $0x0
  8011f0:	53                   	push   %ebx
  8011f1:	6a 00                	push   $0x0
  8011f3:	e8 d1 fa ff ff       	call   800cc9 <sys_page_map>
  8011f8:	89 c3                	mov    %eax,%ebx
  8011fa:	83 c4 20             	add    $0x20,%esp
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	79 a3                	jns    8011a4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	56                   	push   %esi
  801205:	6a 00                	push   $0x0
  801207:	e8 ff fa ff ff       	call   800d0b <sys_page_unmap>
	sys_page_unmap(0, nva);
  80120c:	83 c4 08             	add    $0x8,%esp
  80120f:	57                   	push   %edi
  801210:	6a 00                	push   $0x0
  801212:	e8 f4 fa ff ff       	call   800d0b <sys_page_unmap>
	return r;
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	eb b7                	jmp    8011d3 <dup+0xa3>

0080121c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	53                   	push   %ebx
  801220:	83 ec 14             	sub    $0x14,%esp
  801223:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801226:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801229:	50                   	push   %eax
  80122a:	53                   	push   %ebx
  80122b:	e8 7b fd ff ff       	call   800fab <fd_lookup>
  801230:	83 c4 08             	add    $0x8,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	78 3f                	js     801276 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80123d:	50                   	push   %eax
  80123e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801241:	ff 30                	pushl  (%eax)
  801243:	e8 b9 fd ff ff       	call   801001 <dev_lookup>
  801248:	83 c4 10             	add    $0x10,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	78 27                	js     801276 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80124f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801252:	8b 42 08             	mov    0x8(%edx),%eax
  801255:	83 e0 03             	and    $0x3,%eax
  801258:	83 f8 01             	cmp    $0x1,%eax
  80125b:	74 1e                	je     80127b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80125d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801260:	8b 40 08             	mov    0x8(%eax),%eax
  801263:	85 c0                	test   %eax,%eax
  801265:	74 35                	je     80129c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	ff 75 10             	pushl  0x10(%ebp)
  80126d:	ff 75 0c             	pushl  0xc(%ebp)
  801270:	52                   	push   %edx
  801271:	ff d0                	call   *%eax
  801273:	83 c4 10             	add    $0x10,%esp
}
  801276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801279:	c9                   	leave  
  80127a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80127b:	a1 08 40 80 00       	mov    0x804008,%eax
  801280:	8b 40 48             	mov    0x48(%eax),%eax
  801283:	83 ec 04             	sub    $0x4,%esp
  801286:	53                   	push   %ebx
  801287:	50                   	push   %eax
  801288:	68 51 28 80 00       	push   $0x802851
  80128d:	e8 5e ef ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129a:	eb da                	jmp    801276 <read+0x5a>
		return -E_NOT_SUPP;
  80129c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a1:	eb d3                	jmp    801276 <read+0x5a>

008012a3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012af:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b7:	39 f3                	cmp    %esi,%ebx
  8012b9:	73 25                	jae    8012e0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012bb:	83 ec 04             	sub    $0x4,%esp
  8012be:	89 f0                	mov    %esi,%eax
  8012c0:	29 d8                	sub    %ebx,%eax
  8012c2:	50                   	push   %eax
  8012c3:	89 d8                	mov    %ebx,%eax
  8012c5:	03 45 0c             	add    0xc(%ebp),%eax
  8012c8:	50                   	push   %eax
  8012c9:	57                   	push   %edi
  8012ca:	e8 4d ff ff ff       	call   80121c <read>
		if (m < 0)
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 08                	js     8012de <readn+0x3b>
			return m;
		if (m == 0)
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	74 06                	je     8012e0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012da:	01 c3                	add    %eax,%ebx
  8012dc:	eb d9                	jmp    8012b7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012de:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012e0:	89 d8                	mov    %ebx,%eax
  8012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 14             	sub    $0x14,%esp
  8012f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f7:	50                   	push   %eax
  8012f8:	53                   	push   %ebx
  8012f9:	e8 ad fc ff ff       	call   800fab <fd_lookup>
  8012fe:	83 c4 08             	add    $0x8,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 3a                	js     80133f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130b:	50                   	push   %eax
  80130c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130f:	ff 30                	pushl  (%eax)
  801311:	e8 eb fc ff ff       	call   801001 <dev_lookup>
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	78 22                	js     80133f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80131d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801320:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801324:	74 1e                	je     801344 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801329:	8b 52 0c             	mov    0xc(%edx),%edx
  80132c:	85 d2                	test   %edx,%edx
  80132e:	74 35                	je     801365 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801330:	83 ec 04             	sub    $0x4,%esp
  801333:	ff 75 10             	pushl  0x10(%ebp)
  801336:	ff 75 0c             	pushl  0xc(%ebp)
  801339:	50                   	push   %eax
  80133a:	ff d2                	call   *%edx
  80133c:	83 c4 10             	add    $0x10,%esp
}
  80133f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801342:	c9                   	leave  
  801343:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801344:	a1 08 40 80 00       	mov    0x804008,%eax
  801349:	8b 40 48             	mov    0x48(%eax),%eax
  80134c:	83 ec 04             	sub    $0x4,%esp
  80134f:	53                   	push   %ebx
  801350:	50                   	push   %eax
  801351:	68 6d 28 80 00       	push   $0x80286d
  801356:	e8 95 ee ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801363:	eb da                	jmp    80133f <write+0x55>
		return -E_NOT_SUPP;
  801365:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136a:	eb d3                	jmp    80133f <write+0x55>

0080136c <seek>:

int
seek(int fdnum, off_t offset)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801372:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	ff 75 08             	pushl  0x8(%ebp)
  801379:	e8 2d fc ff ff       	call   800fab <fd_lookup>
  80137e:	83 c4 08             	add    $0x8,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	78 0e                	js     801393 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	53                   	push   %ebx
  801399:	83 ec 14             	sub    $0x14,%esp
  80139c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a2:	50                   	push   %eax
  8013a3:	53                   	push   %ebx
  8013a4:	e8 02 fc ff ff       	call   800fab <fd_lookup>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	78 37                	js     8013e7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b6:	50                   	push   %eax
  8013b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ba:	ff 30                	pushl  (%eax)
  8013bc:	e8 40 fc ff ff       	call   801001 <dev_lookup>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 1f                	js     8013e7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013cf:	74 1b                	je     8013ec <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d4:	8b 52 18             	mov    0x18(%edx),%edx
  8013d7:	85 d2                	test   %edx,%edx
  8013d9:	74 32                	je     80140d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	ff 75 0c             	pushl  0xc(%ebp)
  8013e1:	50                   	push   %eax
  8013e2:	ff d2                	call   *%edx
  8013e4:	83 c4 10             	add    $0x10,%esp
}
  8013e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013ec:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013f1:	8b 40 48             	mov    0x48(%eax),%eax
  8013f4:	83 ec 04             	sub    $0x4,%esp
  8013f7:	53                   	push   %ebx
  8013f8:	50                   	push   %eax
  8013f9:	68 30 28 80 00       	push   $0x802830
  8013fe:	e8 ed ed ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140b:	eb da                	jmp    8013e7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80140d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801412:	eb d3                	jmp    8013e7 <ftruncate+0x52>

00801414 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	53                   	push   %ebx
  801418:	83 ec 14             	sub    $0x14,%esp
  80141b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801421:	50                   	push   %eax
  801422:	ff 75 08             	pushl  0x8(%ebp)
  801425:	e8 81 fb ff ff       	call   800fab <fd_lookup>
  80142a:	83 c4 08             	add    $0x8,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 4b                	js     80147c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801431:	83 ec 08             	sub    $0x8,%esp
  801434:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143b:	ff 30                	pushl  (%eax)
  80143d:	e8 bf fb ff ff       	call   801001 <dev_lookup>
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 33                	js     80147c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801450:	74 2f                	je     801481 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801452:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801455:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80145c:	00 00 00 
	stat->st_isdir = 0;
  80145f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801466:	00 00 00 
	stat->st_dev = dev;
  801469:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	53                   	push   %ebx
  801473:	ff 75 f0             	pushl  -0x10(%ebp)
  801476:	ff 50 14             	call   *0x14(%eax)
  801479:	83 c4 10             	add    $0x10,%esp
}
  80147c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147f:	c9                   	leave  
  801480:	c3                   	ret    
		return -E_NOT_SUPP;
  801481:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801486:	eb f4                	jmp    80147c <fstat+0x68>

00801488 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	56                   	push   %esi
  80148c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	6a 00                	push   $0x0
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	e8 26 02 00 00       	call   8016c0 <open>
  80149a:	89 c3                	mov    %eax,%ebx
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 1b                	js     8014be <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	e8 65 ff ff ff       	call   801414 <fstat>
  8014af:	89 c6                	mov    %eax,%esi
	close(fd);
  8014b1:	89 1c 24             	mov    %ebx,(%esp)
  8014b4:	e8 27 fc ff ff       	call   8010e0 <close>
	return r;
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	89 f3                	mov    %esi,%ebx
}
  8014be:	89 d8                	mov    %ebx,%eax
  8014c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c3:	5b                   	pop    %ebx
  8014c4:	5e                   	pop    %esi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
  8014cc:	89 c6                	mov    %eax,%esi
  8014ce:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014d0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014d7:	74 27                	je     801500 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014d9:	6a 07                	push   $0x7
  8014db:	68 00 50 80 00       	push   $0x805000
  8014e0:	56                   	push   %esi
  8014e1:	ff 35 00 40 80 00    	pushl  0x804000
  8014e7:	e8 11 0c 00 00       	call   8020fd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014ec:	83 c4 0c             	add    $0xc,%esp
  8014ef:	6a 00                	push   $0x0
  8014f1:	53                   	push   %ebx
  8014f2:	6a 00                	push   $0x0
  8014f4:	e8 9b 0b 00 00       	call   802094 <ipc_recv>
}
  8014f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fc:	5b                   	pop    %ebx
  8014fd:	5e                   	pop    %esi
  8014fe:	5d                   	pop    %ebp
  8014ff:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801500:	83 ec 0c             	sub    $0xc,%esp
  801503:	6a 01                	push   $0x1
  801505:	e8 4c 0c 00 00       	call   802156 <ipc_find_env>
  80150a:	a3 00 40 80 00       	mov    %eax,0x804000
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	eb c5                	jmp    8014d9 <fsipc+0x12>

00801514 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8b 40 0c             	mov    0xc(%eax),%eax
  801520:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80152d:	ba 00 00 00 00       	mov    $0x0,%edx
  801532:	b8 02 00 00 00       	mov    $0x2,%eax
  801537:	e8 8b ff ff ff       	call   8014c7 <fsipc>
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <devfile_flush>:
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8b 40 0c             	mov    0xc(%eax),%eax
  80154a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80154f:	ba 00 00 00 00       	mov    $0x0,%edx
  801554:	b8 06 00 00 00       	mov    $0x6,%eax
  801559:	e8 69 ff ff ff       	call   8014c7 <fsipc>
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <devfile_stat>:
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	53                   	push   %ebx
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8b 40 0c             	mov    0xc(%eax),%eax
  801570:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	b8 05 00 00 00       	mov    $0x5,%eax
  80157f:	e8 43 ff ff ff       	call   8014c7 <fsipc>
  801584:	85 c0                	test   %eax,%eax
  801586:	78 2c                	js     8015b4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	68 00 50 80 00       	push   $0x805000
  801590:	53                   	push   %ebx
  801591:	e8 f7 f2 ff ff       	call   80088d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801596:	a1 80 50 80 00       	mov    0x805080,%eax
  80159b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015a1:	a1 84 50 80 00       	mov    0x805084,%eax
  8015a6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <devfile_write>:
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8015ce:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015d4:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015da:	77 30                	ja     80160c <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	53                   	push   %ebx
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	68 08 50 80 00       	push   $0x805008
  8015e8:	e8 2e f4 ff ff       	call   800a1b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8015f7:	e8 cb fe ff ff       	call   8014c7 <fsipc>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 04                	js     801607 <devfile_write+0x4e>
	assert(r <= n);
  801603:	39 d8                	cmp    %ebx,%eax
  801605:	77 1e                	ja     801625 <devfile_write+0x6c>
}
  801607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80160c:	68 a0 28 80 00       	push   $0x8028a0
  801611:	68 d0 28 80 00       	push   $0x8028d0
  801616:	68 94 00 00 00       	push   $0x94
  80161b:	68 e5 28 80 00       	push   $0x8028e5
  801620:	e8 f0 ea ff ff       	call   800115 <_panic>
	assert(r <= n);
  801625:	68 f0 28 80 00       	push   $0x8028f0
  80162a:	68 d0 28 80 00       	push   $0x8028d0
  80162f:	68 98 00 00 00       	push   $0x98
  801634:	68 e5 28 80 00       	push   $0x8028e5
  801639:	e8 d7 ea ff ff       	call   800115 <_panic>

0080163e <devfile_read>:
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	56                   	push   %esi
  801642:	53                   	push   %ebx
  801643:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8b 40 0c             	mov    0xc(%eax),%eax
  80164c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801651:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801657:	ba 00 00 00 00       	mov    $0x0,%edx
  80165c:	b8 03 00 00 00       	mov    $0x3,%eax
  801661:	e8 61 fe ff ff       	call   8014c7 <fsipc>
  801666:	89 c3                	mov    %eax,%ebx
  801668:	85 c0                	test   %eax,%eax
  80166a:	78 1f                	js     80168b <devfile_read+0x4d>
	assert(r <= n);
  80166c:	39 f0                	cmp    %esi,%eax
  80166e:	77 24                	ja     801694 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801670:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801675:	7f 33                	jg     8016aa <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	50                   	push   %eax
  80167b:	68 00 50 80 00       	push   $0x805000
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	e8 93 f3 ff ff       	call   800a1b <memmove>
	return r;
  801688:	83 c4 10             	add    $0x10,%esp
}
  80168b:	89 d8                	mov    %ebx,%eax
  80168d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801690:	5b                   	pop    %ebx
  801691:	5e                   	pop    %esi
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    
	assert(r <= n);
  801694:	68 f0 28 80 00       	push   $0x8028f0
  801699:	68 d0 28 80 00       	push   $0x8028d0
  80169e:	6a 7c                	push   $0x7c
  8016a0:	68 e5 28 80 00       	push   $0x8028e5
  8016a5:	e8 6b ea ff ff       	call   800115 <_panic>
	assert(r <= PGSIZE);
  8016aa:	68 f7 28 80 00       	push   $0x8028f7
  8016af:	68 d0 28 80 00       	push   $0x8028d0
  8016b4:	6a 7d                	push   $0x7d
  8016b6:	68 e5 28 80 00       	push   $0x8028e5
  8016bb:	e8 55 ea ff ff       	call   800115 <_panic>

008016c0 <open>:
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
  8016c5:	83 ec 1c             	sub    $0x1c,%esp
  8016c8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016cb:	56                   	push   %esi
  8016cc:	e8 85 f1 ff ff       	call   800856 <strlen>
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016d9:	7f 6c                	jg     801747 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016db:	83 ec 0c             	sub    $0xc,%esp
  8016de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e1:	50                   	push   %eax
  8016e2:	e8 75 f8 ff ff       	call   800f5c <fd_alloc>
  8016e7:	89 c3                	mov    %eax,%ebx
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 3c                	js     80172c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	56                   	push   %esi
  8016f4:	68 00 50 80 00       	push   $0x805000
  8016f9:	e8 8f f1 ff ff       	call   80088d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801709:	b8 01 00 00 00       	mov    $0x1,%eax
  80170e:	e8 b4 fd ff ff       	call   8014c7 <fsipc>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 19                	js     801735 <open+0x75>
	return fd2num(fd);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	ff 75 f4             	pushl  -0xc(%ebp)
  801722:	e8 0e f8 ff ff       	call   800f35 <fd2num>
  801727:	89 c3                	mov    %eax,%ebx
  801729:	83 c4 10             	add    $0x10,%esp
}
  80172c:	89 d8                	mov    %ebx,%eax
  80172e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    
		fd_close(fd, 0);
  801735:	83 ec 08             	sub    $0x8,%esp
  801738:	6a 00                	push   $0x0
  80173a:	ff 75 f4             	pushl  -0xc(%ebp)
  80173d:	e8 15 f9 ff ff       	call   801057 <fd_close>
		return r;
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	eb e5                	jmp    80172c <open+0x6c>
		return -E_BAD_PATH;
  801747:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80174c:	eb de                	jmp    80172c <open+0x6c>

0080174e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	b8 08 00 00 00       	mov    $0x8,%eax
  80175e:	e8 64 fd ff ff       	call   8014c7 <fsipc>
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
  80176a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80176d:	83 ec 0c             	sub    $0xc,%esp
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	e8 cd f7 ff ff       	call   800f45 <fd2data>
  801778:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80177a:	83 c4 08             	add    $0x8,%esp
  80177d:	68 03 29 80 00       	push   $0x802903
  801782:	53                   	push   %ebx
  801783:	e8 05 f1 ff ff       	call   80088d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801788:	8b 46 04             	mov    0x4(%esi),%eax
  80178b:	2b 06                	sub    (%esi),%eax
  80178d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801793:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80179a:	00 00 00 
	stat->st_dev = &devpipe;
  80179d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017a4:	30 80 00 
	return 0;
}
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 0c             	sub    $0xc,%esp
  8017ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017bd:	53                   	push   %ebx
  8017be:	6a 00                	push   $0x0
  8017c0:	e8 46 f5 ff ff       	call   800d0b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017c5:	89 1c 24             	mov    %ebx,(%esp)
  8017c8:	e8 78 f7 ff ff       	call   800f45 <fd2data>
  8017cd:	83 c4 08             	add    $0x8,%esp
  8017d0:	50                   	push   %eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	e8 33 f5 ff ff       	call   800d0b <sys_page_unmap>
}
  8017d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <_pipeisclosed>:
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	57                   	push   %edi
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 1c             	sub    $0x1c,%esp
  8017e6:	89 c7                	mov    %eax,%edi
  8017e8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8017ef:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	57                   	push   %edi
  8017f6:	e8 94 09 00 00       	call   80218f <pageref>
  8017fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017fe:	89 34 24             	mov    %esi,(%esp)
  801801:	e8 89 09 00 00       	call   80218f <pageref>
		nn = thisenv->env_runs;
  801806:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80180c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	39 cb                	cmp    %ecx,%ebx
  801814:	74 1b                	je     801831 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801816:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801819:	75 cf                	jne    8017ea <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80181b:	8b 42 58             	mov    0x58(%edx),%eax
  80181e:	6a 01                	push   $0x1
  801820:	50                   	push   %eax
  801821:	53                   	push   %ebx
  801822:	68 0a 29 80 00       	push   $0x80290a
  801827:	e8 c4 e9 ff ff       	call   8001f0 <cprintf>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	eb b9                	jmp    8017ea <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801831:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801834:	0f 94 c0             	sete   %al
  801837:	0f b6 c0             	movzbl %al,%eax
}
  80183a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5e                   	pop    %esi
  80183f:	5f                   	pop    %edi
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    

00801842 <devpipe_write>:
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	57                   	push   %edi
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	83 ec 28             	sub    $0x28,%esp
  80184b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80184e:	56                   	push   %esi
  80184f:	e8 f1 f6 ff ff       	call   800f45 <fd2data>
  801854:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	bf 00 00 00 00       	mov    $0x0,%edi
  80185e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801861:	74 4f                	je     8018b2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801863:	8b 43 04             	mov    0x4(%ebx),%eax
  801866:	8b 0b                	mov    (%ebx),%ecx
  801868:	8d 51 20             	lea    0x20(%ecx),%edx
  80186b:	39 d0                	cmp    %edx,%eax
  80186d:	72 14                	jb     801883 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80186f:	89 da                	mov    %ebx,%edx
  801871:	89 f0                	mov    %esi,%eax
  801873:	e8 65 ff ff ff       	call   8017dd <_pipeisclosed>
  801878:	85 c0                	test   %eax,%eax
  80187a:	75 3a                	jne    8018b6 <devpipe_write+0x74>
			sys_yield();
  80187c:	e8 e6 f3 ff ff       	call   800c67 <sys_yield>
  801881:	eb e0                	jmp    801863 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801883:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801886:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80188a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80188d:	89 c2                	mov    %eax,%edx
  80188f:	c1 fa 1f             	sar    $0x1f,%edx
  801892:	89 d1                	mov    %edx,%ecx
  801894:	c1 e9 1b             	shr    $0x1b,%ecx
  801897:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80189a:	83 e2 1f             	and    $0x1f,%edx
  80189d:	29 ca                	sub    %ecx,%edx
  80189f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018a3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018a7:	83 c0 01             	add    $0x1,%eax
  8018aa:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018ad:	83 c7 01             	add    $0x1,%edi
  8018b0:	eb ac                	jmp    80185e <devpipe_write+0x1c>
	return i;
  8018b2:	89 f8                	mov    %edi,%eax
  8018b4:	eb 05                	jmp    8018bb <devpipe_write+0x79>
				return 0;
  8018b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5e                   	pop    %esi
  8018c0:	5f                   	pop    %edi
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    

008018c3 <devpipe_read>:
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	57                   	push   %edi
  8018c7:	56                   	push   %esi
  8018c8:	53                   	push   %ebx
  8018c9:	83 ec 18             	sub    $0x18,%esp
  8018cc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018cf:	57                   	push   %edi
  8018d0:	e8 70 f6 ff ff       	call   800f45 <fd2data>
  8018d5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	be 00 00 00 00       	mov    $0x0,%esi
  8018df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018e2:	74 47                	je     80192b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8018e4:	8b 03                	mov    (%ebx),%eax
  8018e6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018e9:	75 22                	jne    80190d <devpipe_read+0x4a>
			if (i > 0)
  8018eb:	85 f6                	test   %esi,%esi
  8018ed:	75 14                	jne    801903 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8018ef:	89 da                	mov    %ebx,%edx
  8018f1:	89 f8                	mov    %edi,%eax
  8018f3:	e8 e5 fe ff ff       	call   8017dd <_pipeisclosed>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	75 33                	jne    80192f <devpipe_read+0x6c>
			sys_yield();
  8018fc:	e8 66 f3 ff ff       	call   800c67 <sys_yield>
  801901:	eb e1                	jmp    8018e4 <devpipe_read+0x21>
				return i;
  801903:	89 f0                	mov    %esi,%eax
}
  801905:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801908:	5b                   	pop    %ebx
  801909:	5e                   	pop    %esi
  80190a:	5f                   	pop    %edi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80190d:	99                   	cltd   
  80190e:	c1 ea 1b             	shr    $0x1b,%edx
  801911:	01 d0                	add    %edx,%eax
  801913:	83 e0 1f             	and    $0x1f,%eax
  801916:	29 d0                	sub    %edx,%eax
  801918:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80191d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801920:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801923:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801926:	83 c6 01             	add    $0x1,%esi
  801929:	eb b4                	jmp    8018df <devpipe_read+0x1c>
	return i;
  80192b:	89 f0                	mov    %esi,%eax
  80192d:	eb d6                	jmp    801905 <devpipe_read+0x42>
				return 0;
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
  801934:	eb cf                	jmp    801905 <devpipe_read+0x42>

00801936 <pipe>:
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	56                   	push   %esi
  80193a:	53                   	push   %ebx
  80193b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80193e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801941:	50                   	push   %eax
  801942:	e8 15 f6 ff ff       	call   800f5c <fd_alloc>
  801947:	89 c3                	mov    %eax,%ebx
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 5b                	js     8019ab <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	68 07 04 00 00       	push   $0x407
  801958:	ff 75 f4             	pushl  -0xc(%ebp)
  80195b:	6a 00                	push   $0x0
  80195d:	e8 24 f3 ff ff       	call   800c86 <sys_page_alloc>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	78 40                	js     8019ab <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801971:	50                   	push   %eax
  801972:	e8 e5 f5 ff ff       	call   800f5c <fd_alloc>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 1b                	js     80199b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	68 07 04 00 00       	push   $0x407
  801988:	ff 75 f0             	pushl  -0x10(%ebp)
  80198b:	6a 00                	push   $0x0
  80198d:	e8 f4 f2 ff ff       	call   800c86 <sys_page_alloc>
  801992:	89 c3                	mov    %eax,%ebx
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	79 19                	jns    8019b4 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80199b:	83 ec 08             	sub    $0x8,%esp
  80199e:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a1:	6a 00                	push   $0x0
  8019a3:	e8 63 f3 ff ff       	call   800d0b <sys_page_unmap>
  8019a8:	83 c4 10             	add    $0x10,%esp
}
  8019ab:	89 d8                	mov    %ebx,%eax
  8019ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b0:	5b                   	pop    %ebx
  8019b1:	5e                   	pop    %esi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    
	va = fd2data(fd0);
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ba:	e8 86 f5 ff ff       	call   800f45 <fd2data>
  8019bf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019c1:	83 c4 0c             	add    $0xc,%esp
  8019c4:	68 07 04 00 00       	push   $0x407
  8019c9:	50                   	push   %eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	e8 b5 f2 ff ff       	call   800c86 <sys_page_alloc>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	0f 88 8c 00 00 00    	js     801a6a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e4:	e8 5c f5 ff ff       	call   800f45 <fd2data>
  8019e9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019f0:	50                   	push   %eax
  8019f1:	6a 00                	push   $0x0
  8019f3:	56                   	push   %esi
  8019f4:	6a 00                	push   $0x0
  8019f6:	e8 ce f2 ff ff       	call   800cc9 <sys_page_map>
  8019fb:	89 c3                	mov    %eax,%ebx
  8019fd:	83 c4 20             	add    $0x20,%esp
  801a00:	85 c0                	test   %eax,%eax
  801a02:	78 58                	js     801a5c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a07:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a0d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a22:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a27:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a2e:	83 ec 0c             	sub    $0xc,%esp
  801a31:	ff 75 f4             	pushl  -0xc(%ebp)
  801a34:	e8 fc f4 ff ff       	call   800f35 <fd2num>
  801a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a3e:	83 c4 04             	add    $0x4,%esp
  801a41:	ff 75 f0             	pushl  -0x10(%ebp)
  801a44:	e8 ec f4 ff ff       	call   800f35 <fd2num>
  801a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a4c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a57:	e9 4f ff ff ff       	jmp    8019ab <pipe+0x75>
	sys_page_unmap(0, va);
  801a5c:	83 ec 08             	sub    $0x8,%esp
  801a5f:	56                   	push   %esi
  801a60:	6a 00                	push   $0x0
  801a62:	e8 a4 f2 ff ff       	call   800d0b <sys_page_unmap>
  801a67:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801a70:	6a 00                	push   $0x0
  801a72:	e8 94 f2 ff ff       	call   800d0b <sys_page_unmap>
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	e9 1c ff ff ff       	jmp    80199b <pipe+0x65>

00801a7f <pipeisclosed>:
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a88:	50                   	push   %eax
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	e8 1a f5 ff ff       	call   800fab <fd_lookup>
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	78 18                	js     801ab0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9e:	e8 a2 f4 ff ff       	call   800f45 <fd2data>
	return _pipeisclosed(fd, p);
  801aa3:	89 c2                	mov    %eax,%edx
  801aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa8:	e8 30 fd ff ff       	call   8017dd <_pipeisclosed>
  801aad:	83 c4 10             	add    $0x10,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ab8:	68 22 29 80 00       	push   $0x802922
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	e8 c8 ed ff ff       	call   80088d <strcpy>
	return 0;
}
  801ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <devsock_close>:
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 10             	sub    $0x10,%esp
  801ad3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ad6:	53                   	push   %ebx
  801ad7:	e8 b3 06 00 00       	call   80218f <pageref>
  801adc:	83 c4 10             	add    $0x10,%esp
		return 0;
  801adf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ae4:	83 f8 01             	cmp    $0x1,%eax
  801ae7:	74 07                	je     801af0 <devsock_close+0x24>
}
  801ae9:	89 d0                	mov    %edx,%eax
  801aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801af0:	83 ec 0c             	sub    $0xc,%esp
  801af3:	ff 73 0c             	pushl  0xc(%ebx)
  801af6:	e8 b7 02 00 00       	call   801db2 <nsipc_close>
  801afb:	89 c2                	mov    %eax,%edx
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	eb e7                	jmp    801ae9 <devsock_close+0x1d>

00801b02 <devsock_write>:
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 10             	pushl  0x10(%ebp)
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	ff 70 0c             	pushl  0xc(%eax)
  801b16:	e8 74 03 00 00       	call   801e8f <nsipc_send>
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <devsock_read>:
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 10             	pushl  0x10(%ebp)
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	ff 70 0c             	pushl  0xc(%eax)
  801b31:	e8 ed 02 00 00       	call   801e23 <nsipc_recv>
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <fd2sockid>:
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b3e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b41:	52                   	push   %edx
  801b42:	50                   	push   %eax
  801b43:	e8 63 f4 ff ff       	call   800fab <fd_lookup>
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 10                	js     801b5f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b52:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801b58:	39 08                	cmp    %ecx,(%eax)
  801b5a:	75 05                	jne    801b61 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b5c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    
		return -E_NOT_SUPP;
  801b61:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b66:	eb f7                	jmp    801b5f <fd2sockid+0x27>

00801b68 <alloc_sockfd>:
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	83 ec 1c             	sub    $0x1c,%esp
  801b70:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b75:	50                   	push   %eax
  801b76:	e8 e1 f3 ff ff       	call   800f5c <fd_alloc>
  801b7b:	89 c3                	mov    %eax,%ebx
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	85 c0                	test   %eax,%eax
  801b82:	78 43                	js     801bc7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	68 07 04 00 00       	push   $0x407
  801b8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8f:	6a 00                	push   $0x0
  801b91:	e8 f0 f0 ff ff       	call   800c86 <sys_page_alloc>
  801b96:	89 c3                	mov    %eax,%ebx
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	78 28                	js     801bc7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ba8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bad:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bb4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bb7:	83 ec 0c             	sub    $0xc,%esp
  801bba:	50                   	push   %eax
  801bbb:	e8 75 f3 ff ff       	call   800f35 <fd2num>
  801bc0:	89 c3                	mov    %eax,%ebx
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	eb 0c                	jmp    801bd3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bc7:	83 ec 0c             	sub    $0xc,%esp
  801bca:	56                   	push   %esi
  801bcb:	e8 e2 01 00 00       	call   801db2 <nsipc_close>
		return r;
  801bd0:	83 c4 10             	add    $0x10,%esp
}
  801bd3:	89 d8                	mov    %ebx,%eax
  801bd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd8:	5b                   	pop    %ebx
  801bd9:	5e                   	pop    %esi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <accept>:
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	e8 4e ff ff ff       	call   801b38 <fd2sockid>
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 1b                	js     801c09 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	ff 75 10             	pushl  0x10(%ebp)
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	50                   	push   %eax
  801bf8:	e8 0e 01 00 00       	call   801d0b <nsipc_accept>
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 05                	js     801c09 <accept+0x2d>
	return alloc_sockfd(r);
  801c04:	e8 5f ff ff ff       	call   801b68 <alloc_sockfd>
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <bind>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	e8 1f ff ff ff       	call   801b38 <fd2sockid>
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	78 12                	js     801c2f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	ff 75 10             	pushl  0x10(%ebp)
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	50                   	push   %eax
  801c27:	e8 2f 01 00 00       	call   801d5b <nsipc_bind>
  801c2c:	83 c4 10             	add    $0x10,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <shutdown>:
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	e8 f9 fe ff ff       	call   801b38 <fd2sockid>
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 0f                	js     801c52 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c43:	83 ec 08             	sub    $0x8,%esp
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	50                   	push   %eax
  801c4a:	e8 41 01 00 00       	call   801d90 <nsipc_shutdown>
  801c4f:	83 c4 10             	add    $0x10,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <connect>:
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	e8 d6 fe ff ff       	call   801b38 <fd2sockid>
  801c62:	85 c0                	test   %eax,%eax
  801c64:	78 12                	js     801c78 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	ff 75 10             	pushl  0x10(%ebp)
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	50                   	push   %eax
  801c70:	e8 57 01 00 00       	call   801dcc <nsipc_connect>
  801c75:	83 c4 10             	add    $0x10,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <listen>:
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	e8 b0 fe ff ff       	call   801b38 <fd2sockid>
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	78 0f                	js     801c9b <listen+0x21>
	return nsipc_listen(r, backlog);
  801c8c:	83 ec 08             	sub    $0x8,%esp
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	50                   	push   %eax
  801c93:	e8 69 01 00 00       	call   801e01 <nsipc_listen>
  801c98:	83 c4 10             	add    $0x10,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <socket>:

int
socket(int domain, int type, int protocol)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ca3:	ff 75 10             	pushl  0x10(%ebp)
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	ff 75 08             	pushl  0x8(%ebp)
  801cac:	e8 3c 02 00 00       	call   801eed <nsipc_socket>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 05                	js     801cbd <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cb8:	e8 ab fe ff ff       	call   801b68 <alloc_sockfd>
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	53                   	push   %ebx
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cc8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ccf:	74 26                	je     801cf7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cd1:	6a 07                	push   $0x7
  801cd3:	68 00 60 80 00       	push   $0x806000
  801cd8:	53                   	push   %ebx
  801cd9:	ff 35 04 40 80 00    	pushl  0x804004
  801cdf:	e8 19 04 00 00       	call   8020fd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ce4:	83 c4 0c             	add    $0xc,%esp
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	e8 a2 03 00 00       	call   802094 <ipc_recv>
}
  801cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	6a 02                	push   $0x2
  801cfc:	e8 55 04 00 00       	call   802156 <ipc_find_env>
  801d01:	a3 04 40 80 00       	mov    %eax,0x804004
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	eb c6                	jmp    801cd1 <nsipc+0x12>

00801d0b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d1b:	8b 06                	mov    (%esi),%eax
  801d1d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
  801d27:	e8 93 ff ff ff       	call   801cbf <nsipc>
  801d2c:	89 c3                	mov    %eax,%ebx
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	78 20                	js     801d52 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d32:	83 ec 04             	sub    $0x4,%esp
  801d35:	ff 35 10 60 80 00    	pushl  0x806010
  801d3b:	68 00 60 80 00       	push   $0x806000
  801d40:	ff 75 0c             	pushl  0xc(%ebp)
  801d43:	e8 d3 ec ff ff       	call   800a1b <memmove>
		*addrlen = ret->ret_addrlen;
  801d48:	a1 10 60 80 00       	mov    0x806010,%eax
  801d4d:	89 06                	mov    %eax,(%esi)
  801d4f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801d52:	89 d8                	mov    %ebx,%eax
  801d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    

00801d5b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	53                   	push   %ebx
  801d5f:	83 ec 08             	sub    $0x8,%esp
  801d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d6d:	53                   	push   %ebx
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	68 04 60 80 00       	push   $0x806004
  801d76:	e8 a0 ec ff ff       	call   800a1b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d7b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d81:	b8 02 00 00 00       	mov    $0x2,%eax
  801d86:	e8 34 ff ff ff       	call   801cbf <nsipc>
}
  801d8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801da6:	b8 03 00 00 00       	mov    $0x3,%eax
  801dab:	e8 0f ff ff ff       	call   801cbf <nsipc>
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <nsipc_close>:

int
nsipc_close(int s)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dc0:	b8 04 00 00 00       	mov    $0x4,%eax
  801dc5:	e8 f5 fe ff ff       	call   801cbf <nsipc>
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 08             	sub    $0x8,%esp
  801dd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dde:	53                   	push   %ebx
  801ddf:	ff 75 0c             	pushl  0xc(%ebp)
  801de2:	68 04 60 80 00       	push   $0x806004
  801de7:	e8 2f ec ff ff       	call   800a1b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dec:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801df2:	b8 05 00 00 00       	mov    $0x5,%eax
  801df7:	e8 c3 fe ff ff       	call   801cbf <nsipc>
}
  801dfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e12:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e17:	b8 06 00 00 00       	mov    $0x6,%eax
  801e1c:	e8 9e fe ff ff       	call   801cbf <nsipc>
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	56                   	push   %esi
  801e27:	53                   	push   %ebx
  801e28:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e33:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e39:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3c:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e41:	b8 07 00 00 00       	mov    $0x7,%eax
  801e46:	e8 74 fe ff ff       	call   801cbf <nsipc>
  801e4b:	89 c3                	mov    %eax,%ebx
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	78 1f                	js     801e70 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e51:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e56:	7f 21                	jg     801e79 <nsipc_recv+0x56>
  801e58:	39 c6                	cmp    %eax,%esi
  801e5a:	7c 1d                	jl     801e79 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	50                   	push   %eax
  801e60:	68 00 60 80 00       	push   $0x806000
  801e65:	ff 75 0c             	pushl  0xc(%ebp)
  801e68:	e8 ae eb ff ff       	call   800a1b <memmove>
  801e6d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e70:	89 d8                	mov    %ebx,%eax
  801e72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5e                   	pop    %esi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e79:	68 2e 29 80 00       	push   $0x80292e
  801e7e:	68 d0 28 80 00       	push   $0x8028d0
  801e83:	6a 62                	push   $0x62
  801e85:	68 43 29 80 00       	push   $0x802943
  801e8a:	e8 86 e2 ff ff       	call   800115 <_panic>

00801e8f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	53                   	push   %ebx
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ea1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ea7:	7f 2e                	jg     801ed7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	53                   	push   %ebx
  801ead:	ff 75 0c             	pushl  0xc(%ebp)
  801eb0:	68 0c 60 80 00       	push   $0x80600c
  801eb5:	e8 61 eb ff ff       	call   800a1b <memmove>
	nsipcbuf.send.req_size = size;
  801eba:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ec8:	b8 08 00 00 00       	mov    $0x8,%eax
  801ecd:	e8 ed fd ff ff       	call   801cbf <nsipc>
}
  801ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    
	assert(size < 1600);
  801ed7:	68 4f 29 80 00       	push   $0x80294f
  801edc:	68 d0 28 80 00       	push   $0x8028d0
  801ee1:	6a 6d                	push   $0x6d
  801ee3:	68 43 29 80 00       	push   $0x802943
  801ee8:	e8 28 e2 ff ff       	call   800115 <_panic>

00801eed <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efe:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f03:	8b 45 10             	mov    0x10(%ebp),%eax
  801f06:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f0b:	b8 09 00 00 00       	mov    $0x9,%eax
  801f10:	e8 aa fd ff ff       	call   801cbf <nsipc>
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1f:	5d                   	pop    %ebp
  801f20:	c3                   	ret    

00801f21 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f27:	68 5b 29 80 00       	push   $0x80295b
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	e8 59 e9 ff ff       	call   80088d <strcpy>
	return 0;
}
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <devcons_write>:
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	57                   	push   %edi
  801f3f:	56                   	push   %esi
  801f40:	53                   	push   %ebx
  801f41:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f47:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f4c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f52:	eb 2f                	jmp    801f83 <devcons_write+0x48>
		m = n - tot;
  801f54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f57:	29 f3                	sub    %esi,%ebx
  801f59:	83 fb 7f             	cmp    $0x7f,%ebx
  801f5c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f61:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	53                   	push   %ebx
  801f68:	89 f0                	mov    %esi,%eax
  801f6a:	03 45 0c             	add    0xc(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	57                   	push   %edi
  801f6f:	e8 a7 ea ff ff       	call   800a1b <memmove>
		sys_cputs(buf, m);
  801f74:	83 c4 08             	add    $0x8,%esp
  801f77:	53                   	push   %ebx
  801f78:	57                   	push   %edi
  801f79:	e8 4c ec ff ff       	call   800bca <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f7e:	01 de                	add    %ebx,%esi
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f86:	72 cc                	jb     801f54 <devcons_write+0x19>
}
  801f88:	89 f0                	mov    %esi,%eax
  801f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8d:	5b                   	pop    %ebx
  801f8e:	5e                   	pop    %esi
  801f8f:	5f                   	pop    %edi
  801f90:	5d                   	pop    %ebp
  801f91:	c3                   	ret    

00801f92 <devcons_read>:
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 08             	sub    $0x8,%esp
  801f98:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fa1:	75 07                	jne    801faa <devcons_read+0x18>
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    
		sys_yield();
  801fa5:	e8 bd ec ff ff       	call   800c67 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801faa:	e8 39 ec ff ff       	call   800be8 <sys_cgetc>
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	74 f2                	je     801fa5 <devcons_read+0x13>
	if (c < 0)
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	78 ec                	js     801fa3 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801fb7:	83 f8 04             	cmp    $0x4,%eax
  801fba:	74 0c                	je     801fc8 <devcons_read+0x36>
	*(char*)vbuf = c;
  801fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbf:	88 02                	mov    %al,(%edx)
	return 1;
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc6:	eb db                	jmp    801fa3 <devcons_read+0x11>
		return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcd:	eb d4                	jmp    801fa3 <devcons_read+0x11>

00801fcf <cputchar>:
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fdb:	6a 01                	push   $0x1
  801fdd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fe0:	50                   	push   %eax
  801fe1:	e8 e4 eb ff ff       	call   800bca <sys_cputs>
}
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <getchar>:
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ff1:	6a 01                	push   $0x1
  801ff3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff6:	50                   	push   %eax
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 1e f2 ff ff       	call   80121c <read>
	if (r < 0)
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	85 c0                	test   %eax,%eax
  802003:	78 08                	js     80200d <getchar+0x22>
	if (r < 1)
  802005:	85 c0                	test   %eax,%eax
  802007:	7e 06                	jle    80200f <getchar+0x24>
	return c;
  802009:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    
		return -E_EOF;
  80200f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802014:	eb f7                	jmp    80200d <getchar+0x22>

00802016 <iscons>:
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201f:	50                   	push   %eax
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	e8 83 ef ff ff       	call   800fab <fd_lookup>
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	85 c0                	test   %eax,%eax
  80202d:	78 11                	js     802040 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802038:	39 10                	cmp    %edx,(%eax)
  80203a:	0f 94 c0             	sete   %al
  80203d:	0f b6 c0             	movzbl %al,%eax
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <opencons>:
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802048:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204b:	50                   	push   %eax
  80204c:	e8 0b ef ff ff       	call   800f5c <fd_alloc>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	85 c0                	test   %eax,%eax
  802056:	78 3a                	js     802092 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	68 07 04 00 00       	push   $0x407
  802060:	ff 75 f4             	pushl  -0xc(%ebp)
  802063:	6a 00                	push   $0x0
  802065:	e8 1c ec ff ff       	call   800c86 <sys_page_alloc>
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	85 c0                	test   %eax,%eax
  80206f:	78 21                	js     802092 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80207a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802086:	83 ec 0c             	sub    $0xc,%esp
  802089:	50                   	push   %eax
  80208a:	e8 a6 ee ff ff       	call   800f35 <fd2num>
  80208f:	83 c4 10             	add    $0x10,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	56                   	push   %esi
  802098:	53                   	push   %ebx
  802099:	8b 75 08             	mov    0x8(%ebp),%esi
  80209c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8020a2:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8020a4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020a9:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	50                   	push   %eax
  8020b0:	e8 81 ed ff ff       	call   800e36 <sys_ipc_recv>
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	78 2b                	js     8020e7 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8020bc:	85 f6                	test   %esi,%esi
  8020be:	74 0a                	je     8020ca <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8020c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8020c5:	8b 40 74             	mov    0x74(%eax),%eax
  8020c8:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8020ca:	85 db                	test   %ebx,%ebx
  8020cc:	74 0a                	je     8020d8 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8020ce:	a1 08 40 80 00       	mov    0x804008,%eax
  8020d3:	8b 40 78             	mov    0x78(%eax),%eax
  8020d6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8020d8:	a1 08 40 80 00       	mov    0x804008,%eax
  8020dd:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    
	    if (from_env_store != NULL) {
  8020e7:	85 f6                	test   %esi,%esi
  8020e9:	74 06                	je     8020f1 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8020eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8020f1:	85 db                	test   %ebx,%ebx
  8020f3:	74 eb                	je     8020e0 <ipc_recv+0x4c>
	        *perm_store = 0;
  8020f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020fb:	eb e3                	jmp    8020e0 <ipc_recv+0x4c>

008020fd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	57                   	push   %edi
  802101:	56                   	push   %esi
  802102:	53                   	push   %ebx
  802103:	83 ec 0c             	sub    $0xc,%esp
  802106:	8b 7d 08             	mov    0x8(%ebp),%edi
  802109:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80210c:	85 f6                	test   %esi,%esi
  80210e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802113:	0f 44 f0             	cmove  %eax,%esi
  802116:	eb 09                	jmp    802121 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802118:	e8 4a eb ff ff       	call   800c67 <sys_yield>
	} while(r != 0);
  80211d:	85 db                	test   %ebx,%ebx
  80211f:	74 2d                	je     80214e <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802121:	ff 75 14             	pushl  0x14(%ebp)
  802124:	56                   	push   %esi
  802125:	ff 75 0c             	pushl  0xc(%ebp)
  802128:	57                   	push   %edi
  802129:	e8 e5 ec ff ff       	call   800e13 <sys_ipc_try_send>
  80212e:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	79 e1                	jns    802118 <ipc_send+0x1b>
  802137:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80213a:	74 dc                	je     802118 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80213c:	50                   	push   %eax
  80213d:	68 67 29 80 00       	push   $0x802967
  802142:	6a 45                	push   $0x45
  802144:	68 74 29 80 00       	push   $0x802974
  802149:	e8 c7 df ff ff       	call   800115 <_panic>
}
  80214e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    

00802156 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802161:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802164:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80216a:	8b 52 50             	mov    0x50(%edx),%edx
  80216d:	39 ca                	cmp    %ecx,%edx
  80216f:	74 11                	je     802182 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802171:	83 c0 01             	add    $0x1,%eax
  802174:	3d 00 04 00 00       	cmp    $0x400,%eax
  802179:	75 e6                	jne    802161 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	eb 0b                	jmp    80218d <ipc_find_env+0x37>
			return envs[i].env_id;
  802182:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802185:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80218a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802195:	89 d0                	mov    %edx,%eax
  802197:	c1 e8 16             	shr    $0x16,%eax
  80219a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021a6:	f6 c1 01             	test   $0x1,%cl
  8021a9:	74 1d                	je     8021c8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021ab:	c1 ea 0c             	shr    $0xc,%edx
  8021ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021b5:	f6 c2 01             	test   $0x1,%dl
  8021b8:	74 0e                	je     8021c8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021ba:	c1 ea 0c             	shr    $0xc,%edx
  8021bd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021c4:	ef 
  8021c5:	0f b7 c0             	movzwl %ax,%eax
}
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__udivdi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021e7:	85 d2                	test   %edx,%edx
  8021e9:	75 35                	jne    802220 <__udivdi3+0x50>
  8021eb:	39 f3                	cmp    %esi,%ebx
  8021ed:	0f 87 bd 00 00 00    	ja     8022b0 <__udivdi3+0xe0>
  8021f3:	85 db                	test   %ebx,%ebx
  8021f5:	89 d9                	mov    %ebx,%ecx
  8021f7:	75 0b                	jne    802204 <__udivdi3+0x34>
  8021f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fe:	31 d2                	xor    %edx,%edx
  802200:	f7 f3                	div    %ebx
  802202:	89 c1                	mov    %eax,%ecx
  802204:	31 d2                	xor    %edx,%edx
  802206:	89 f0                	mov    %esi,%eax
  802208:	f7 f1                	div    %ecx
  80220a:	89 c6                	mov    %eax,%esi
  80220c:	89 e8                	mov    %ebp,%eax
  80220e:	89 f7                	mov    %esi,%edi
  802210:	f7 f1                	div    %ecx
  802212:	89 fa                	mov    %edi,%edx
  802214:	83 c4 1c             	add    $0x1c,%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5f                   	pop    %edi
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    
  80221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802220:	39 f2                	cmp    %esi,%edx
  802222:	77 7c                	ja     8022a0 <__udivdi3+0xd0>
  802224:	0f bd fa             	bsr    %edx,%edi
  802227:	83 f7 1f             	xor    $0x1f,%edi
  80222a:	0f 84 98 00 00 00    	je     8022c8 <__udivdi3+0xf8>
  802230:	89 f9                	mov    %edi,%ecx
  802232:	b8 20 00 00 00       	mov    $0x20,%eax
  802237:	29 f8                	sub    %edi,%eax
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	89 da                	mov    %ebx,%edx
  802243:	d3 ea                	shr    %cl,%edx
  802245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802249:	09 d1                	or     %edx,%ecx
  80224b:	89 f2                	mov    %esi,%edx
  80224d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802251:	89 f9                	mov    %edi,%ecx
  802253:	d3 e3                	shl    %cl,%ebx
  802255:	89 c1                	mov    %eax,%ecx
  802257:	d3 ea                	shr    %cl,%edx
  802259:	89 f9                	mov    %edi,%ecx
  80225b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80225f:	d3 e6                	shl    %cl,%esi
  802261:	89 eb                	mov    %ebp,%ebx
  802263:	89 c1                	mov    %eax,%ecx
  802265:	d3 eb                	shr    %cl,%ebx
  802267:	09 de                	or     %ebx,%esi
  802269:	89 f0                	mov    %esi,%eax
  80226b:	f7 74 24 08          	divl   0x8(%esp)
  80226f:	89 d6                	mov    %edx,%esi
  802271:	89 c3                	mov    %eax,%ebx
  802273:	f7 64 24 0c          	mull   0xc(%esp)
  802277:	39 d6                	cmp    %edx,%esi
  802279:	72 0c                	jb     802287 <__udivdi3+0xb7>
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	39 c5                	cmp    %eax,%ebp
  802281:	73 5d                	jae    8022e0 <__udivdi3+0x110>
  802283:	39 d6                	cmp    %edx,%esi
  802285:	75 59                	jne    8022e0 <__udivdi3+0x110>
  802287:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80228a:	31 ff                	xor    %edi,%edi
  80228c:	89 fa                	mov    %edi,%edx
  80228e:	83 c4 1c             	add    $0x1c,%esp
  802291:	5b                   	pop    %ebx
  802292:	5e                   	pop    %esi
  802293:	5f                   	pop    %edi
  802294:	5d                   	pop    %ebp
  802295:	c3                   	ret    
  802296:	8d 76 00             	lea    0x0(%esi),%esi
  802299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8022a0:	31 ff                	xor    %edi,%edi
  8022a2:	31 c0                	xor    %eax,%eax
  8022a4:	89 fa                	mov    %edi,%edx
  8022a6:	83 c4 1c             	add    $0x1c,%esp
  8022a9:	5b                   	pop    %ebx
  8022aa:	5e                   	pop    %esi
  8022ab:	5f                   	pop    %edi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    
  8022ae:	66 90                	xchg   %ax,%ax
  8022b0:	31 ff                	xor    %edi,%edi
  8022b2:	89 e8                	mov    %ebp,%eax
  8022b4:	89 f2                	mov    %esi,%edx
  8022b6:	f7 f3                	div    %ebx
  8022b8:	89 fa                	mov    %edi,%edx
  8022ba:	83 c4 1c             	add    $0x1c,%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5f                   	pop    %edi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    
  8022c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022c8:	39 f2                	cmp    %esi,%edx
  8022ca:	72 06                	jb     8022d2 <__udivdi3+0x102>
  8022cc:	31 c0                	xor    %eax,%eax
  8022ce:	39 eb                	cmp    %ebp,%ebx
  8022d0:	77 d2                	ja     8022a4 <__udivdi3+0xd4>
  8022d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d7:	eb cb                	jmp    8022a4 <__udivdi3+0xd4>
  8022d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e0:	89 d8                	mov    %ebx,%eax
  8022e2:	31 ff                	xor    %edi,%edi
  8022e4:	eb be                	jmp    8022a4 <__udivdi3+0xd4>
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	66 90                	xchg   %ax,%ax
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__umoddi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8022fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802307:	85 ed                	test   %ebp,%ebp
  802309:	89 f0                	mov    %esi,%eax
  80230b:	89 da                	mov    %ebx,%edx
  80230d:	75 19                	jne    802328 <__umoddi3+0x38>
  80230f:	39 df                	cmp    %ebx,%edi
  802311:	0f 86 b1 00 00 00    	jbe    8023c8 <__umoddi3+0xd8>
  802317:	f7 f7                	div    %edi
  802319:	89 d0                	mov    %edx,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	83 c4 1c             	add    $0x1c,%esp
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5f                   	pop    %edi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	39 dd                	cmp    %ebx,%ebp
  80232a:	77 f1                	ja     80231d <__umoddi3+0x2d>
  80232c:	0f bd cd             	bsr    %ebp,%ecx
  80232f:	83 f1 1f             	xor    $0x1f,%ecx
  802332:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802336:	0f 84 b4 00 00 00    	je     8023f0 <__umoddi3+0x100>
  80233c:	b8 20 00 00 00       	mov    $0x20,%eax
  802341:	89 c2                	mov    %eax,%edx
  802343:	8b 44 24 04          	mov    0x4(%esp),%eax
  802347:	29 c2                	sub    %eax,%edx
  802349:	89 c1                	mov    %eax,%ecx
  80234b:	89 f8                	mov    %edi,%eax
  80234d:	d3 e5                	shl    %cl,%ebp
  80234f:	89 d1                	mov    %edx,%ecx
  802351:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802355:	d3 e8                	shr    %cl,%eax
  802357:	09 c5                	or     %eax,%ebp
  802359:	8b 44 24 04          	mov    0x4(%esp),%eax
  80235d:	89 c1                	mov    %eax,%ecx
  80235f:	d3 e7                	shl    %cl,%edi
  802361:	89 d1                	mov    %edx,%ecx
  802363:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802367:	89 df                	mov    %ebx,%edi
  802369:	d3 ef                	shr    %cl,%edi
  80236b:	89 c1                	mov    %eax,%ecx
  80236d:	89 f0                	mov    %esi,%eax
  80236f:	d3 e3                	shl    %cl,%ebx
  802371:	89 d1                	mov    %edx,%ecx
  802373:	89 fa                	mov    %edi,%edx
  802375:	d3 e8                	shr    %cl,%eax
  802377:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80237c:	09 d8                	or     %ebx,%eax
  80237e:	f7 f5                	div    %ebp
  802380:	d3 e6                	shl    %cl,%esi
  802382:	89 d1                	mov    %edx,%ecx
  802384:	f7 64 24 08          	mull   0x8(%esp)
  802388:	39 d1                	cmp    %edx,%ecx
  80238a:	89 c3                	mov    %eax,%ebx
  80238c:	89 d7                	mov    %edx,%edi
  80238e:	72 06                	jb     802396 <__umoddi3+0xa6>
  802390:	75 0e                	jne    8023a0 <__umoddi3+0xb0>
  802392:	39 c6                	cmp    %eax,%esi
  802394:	73 0a                	jae    8023a0 <__umoddi3+0xb0>
  802396:	2b 44 24 08          	sub    0x8(%esp),%eax
  80239a:	19 ea                	sbb    %ebp,%edx
  80239c:	89 d7                	mov    %edx,%edi
  80239e:	89 c3                	mov    %eax,%ebx
  8023a0:	89 ca                	mov    %ecx,%edx
  8023a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8023a7:	29 de                	sub    %ebx,%esi
  8023a9:	19 fa                	sbb    %edi,%edx
  8023ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8023af:	89 d0                	mov    %edx,%eax
  8023b1:	d3 e0                	shl    %cl,%eax
  8023b3:	89 d9                	mov    %ebx,%ecx
  8023b5:	d3 ee                	shr    %cl,%esi
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	09 f0                	or     %esi,%eax
  8023bb:	83 c4 1c             	add    $0x1c,%esp
  8023be:	5b                   	pop    %ebx
  8023bf:	5e                   	pop    %esi
  8023c0:	5f                   	pop    %edi
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    
  8023c3:	90                   	nop
  8023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	85 ff                	test   %edi,%edi
  8023ca:	89 f9                	mov    %edi,%ecx
  8023cc:	75 0b                	jne    8023d9 <__umoddi3+0xe9>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f7                	div    %edi
  8023d7:	89 c1                	mov    %eax,%ecx
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	f7 f1                	div    %ecx
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	f7 f1                	div    %ecx
  8023e3:	e9 31 ff ff ff       	jmp    802319 <__umoddi3+0x29>
  8023e8:	90                   	nop
  8023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f0:	39 dd                	cmp    %ebx,%ebp
  8023f2:	72 08                	jb     8023fc <__umoddi3+0x10c>
  8023f4:	39 f7                	cmp    %esi,%edi
  8023f6:	0f 87 21 ff ff ff    	ja     80231d <__umoddi3+0x2d>
  8023fc:	89 da                	mov    %ebx,%edx
  8023fe:	89 f0                	mov    %esi,%eax
  802400:	29 f8                	sub    %edi,%eax
  802402:	19 ea                	sbb    %ebp,%edx
  802404:	e9 14 ff ff ff       	jmp    80231d <__umoddi3+0x2d>
