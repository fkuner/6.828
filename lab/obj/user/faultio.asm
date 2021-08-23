
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 4e 23 80 00       	push   $0x80234e
  800053:	e8 0c 01 00 00       	call   800164 <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 40 23 80 00       	push   $0x802340
  800065:	e8 fa 00 00 00       	call   800164 <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80007a:	e8 3d 0b 00 00       	call   800bbc <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 db                	test   %ebx,%ebx
  800093:	7e 07                	jle    80009c <libmain+0x2d>
		binaryname = argv[0];
  800095:	8b 06                	mov    (%esi),%eax
  800097:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 0a 00 00 00       	call   8000b5 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b1:	5b                   	pop    %ebx
  8000b2:	5e                   	pop    %esi
  8000b3:	5d                   	pop    %ebp
  8000b4:	c3                   	ret    

008000b5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000bb:	e8 20 0f 00 00       	call   800fe0 <close_all>
	sys_env_destroy(0);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	6a 00                	push   $0x0
  8000c5:	e8 b1 0a 00 00       	call   800b7b <sys_env_destroy>
}
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	c9                   	leave  
  8000ce:	c3                   	ret    

008000cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d9:	8b 13                	mov    (%ebx),%edx
  8000db:	8d 42 01             	lea    0x1(%edx),%eax
  8000de:	89 03                	mov    %eax,(%ebx)
  8000e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ec:	74 09                	je     8000f7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ee:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f5:	c9                   	leave  
  8000f6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	68 ff 00 00 00       	push   $0xff
  8000ff:	8d 43 08             	lea    0x8(%ebx),%eax
  800102:	50                   	push   %eax
  800103:	e8 36 0a 00 00       	call   800b3e <sys_cputs>
		b->idx = 0;
  800108:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	eb db                	jmp    8000ee <putch+0x1f>

00800113 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80011c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800123:	00 00 00 
	b.cnt = 0;
  800126:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80012d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800130:	ff 75 0c             	pushl  0xc(%ebp)
  800133:	ff 75 08             	pushl  0x8(%ebp)
  800136:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013c:	50                   	push   %eax
  80013d:	68 cf 00 80 00       	push   $0x8000cf
  800142:	e8 1a 01 00 00       	call   800261 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800147:	83 c4 08             	add    $0x8,%esp
  80014a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800150:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	e8 e2 09 00 00       	call   800b3e <sys_cputs>

	return b.cnt;
}
  80015c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016d:	50                   	push   %eax
  80016e:	ff 75 08             	pushl  0x8(%ebp)
  800171:	e8 9d ff ff ff       	call   800113 <vcprintf>
	va_end(ap);

	return cnt;
}
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	57                   	push   %edi
  80017c:	56                   	push   %esi
  80017d:	53                   	push   %ebx
  80017e:	83 ec 1c             	sub    $0x1c,%esp
  800181:	89 c7                	mov    %eax,%edi
  800183:	89 d6                	mov    %edx,%esi
  800185:	8b 45 08             	mov    0x8(%ebp),%eax
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800191:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800194:	bb 00 00 00 00       	mov    $0x0,%ebx
  800199:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80019c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80019f:	39 d3                	cmp    %edx,%ebx
  8001a1:	72 05                	jb     8001a8 <printnum+0x30>
  8001a3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001a6:	77 7a                	ja     800222 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	ff 75 18             	pushl  0x18(%ebp)
  8001ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8001b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001b4:	53                   	push   %ebx
  8001b5:	ff 75 10             	pushl  0x10(%ebp)
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001be:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c7:	e8 24 1f 00 00       	call   8020f0 <__udivdi3>
  8001cc:	83 c4 18             	add    $0x18,%esp
  8001cf:	52                   	push   %edx
  8001d0:	50                   	push   %eax
  8001d1:	89 f2                	mov    %esi,%edx
  8001d3:	89 f8                	mov    %edi,%eax
  8001d5:	e8 9e ff ff ff       	call   800178 <printnum>
  8001da:	83 c4 20             	add    $0x20,%esp
  8001dd:	eb 13                	jmp    8001f2 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	56                   	push   %esi
  8001e3:	ff 75 18             	pushl  0x18(%ebp)
  8001e6:	ff d7                	call   *%edi
  8001e8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001eb:	83 eb 01             	sub    $0x1,%ebx
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7f ed                	jg     8001df <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	56                   	push   %esi
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ff:	ff 75 dc             	pushl  -0x24(%ebp)
  800202:	ff 75 d8             	pushl  -0x28(%ebp)
  800205:	e8 06 20 00 00       	call   802210 <__umoddi3>
  80020a:	83 c4 14             	add    $0x14,%esp
  80020d:	0f be 80 72 23 80 00 	movsbl 0x802372(%eax),%eax
  800214:	50                   	push   %eax
  800215:	ff d7                	call   *%edi
}
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021d:	5b                   	pop    %ebx
  80021e:	5e                   	pop    %esi
  80021f:	5f                   	pop    %edi
  800220:	5d                   	pop    %ebp
  800221:	c3                   	ret    
  800222:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800225:	eb c4                	jmp    8001eb <printnum+0x73>

00800227 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80022d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800231:	8b 10                	mov    (%eax),%edx
  800233:	3b 50 04             	cmp    0x4(%eax),%edx
  800236:	73 0a                	jae    800242 <sprintputch+0x1b>
		*b->buf++ = ch;
  800238:	8d 4a 01             	lea    0x1(%edx),%ecx
  80023b:	89 08                	mov    %ecx,(%eax)
  80023d:	8b 45 08             	mov    0x8(%ebp),%eax
  800240:	88 02                	mov    %al,(%edx)
}
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    

00800244 <printfmt>:
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80024a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80024d:	50                   	push   %eax
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 0c             	pushl  0xc(%ebp)
  800254:	ff 75 08             	pushl  0x8(%ebp)
  800257:	e8 05 00 00 00       	call   800261 <vprintfmt>
}
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <vprintfmt>:
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 2c             	sub    $0x2c,%esp
  80026a:	8b 75 08             	mov    0x8(%ebp),%esi
  80026d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800270:	8b 7d 10             	mov    0x10(%ebp),%edi
  800273:	e9 21 04 00 00       	jmp    800699 <vprintfmt+0x438>
		padc = ' ';
  800278:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80027c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800283:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80028a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800291:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800296:	8d 47 01             	lea    0x1(%edi),%eax
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	0f b6 17             	movzbl (%edi),%edx
  80029f:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002a2:	3c 55                	cmp    $0x55,%al
  8002a4:	0f 87 90 04 00 00    	ja     80073a <vprintfmt+0x4d9>
  8002aa:	0f b6 c0             	movzbl %al,%eax
  8002ad:	ff 24 85 c0 24 80 00 	jmp    *0x8024c0(,%eax,4)
  8002b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002b7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002bb:	eb d9                	jmp    800296 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002c0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002c4:	eb d0                	jmp    800296 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002c6:	0f b6 d2             	movzbl %dl,%edx
  8002c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002d4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002db:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002de:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002e1:	83 f9 09             	cmp    $0x9,%ecx
  8002e4:	77 55                	ja     80033b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002e6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e9:	eb e9                	jmp    8002d4 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ee:	8b 00                	mov    (%eax),%eax
  8002f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f6:	8d 40 04             	lea    0x4(%eax),%eax
  8002f9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800303:	79 91                	jns    800296 <vprintfmt+0x35>
				width = precision, precision = -1;
  800305:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800308:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800312:	eb 82                	jmp    800296 <vprintfmt+0x35>
  800314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800317:	85 c0                	test   %eax,%eax
  800319:	ba 00 00 00 00       	mov    $0x0,%edx
  80031e:	0f 49 d0             	cmovns %eax,%edx
  800321:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800327:	e9 6a ff ff ff       	jmp    800296 <vprintfmt+0x35>
  80032c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80032f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800336:	e9 5b ff ff ff       	jmp    800296 <vprintfmt+0x35>
  80033b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800341:	eb bc                	jmp    8002ff <vprintfmt+0x9e>
			lflag++;
  800343:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800349:	e9 48 ff ff ff       	jmp    800296 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	8d 78 04             	lea    0x4(%eax),%edi
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	53                   	push   %ebx
  800358:	ff 30                	pushl  (%eax)
  80035a:	ff d6                	call   *%esi
			break;
  80035c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80035f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800362:	e9 2f 03 00 00       	jmp    800696 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8d 78 04             	lea    0x4(%eax),%edi
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	99                   	cltd   
  800370:	31 d0                	xor    %edx,%eax
  800372:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800374:	83 f8 0f             	cmp    $0xf,%eax
  800377:	7f 23                	jg     80039c <vprintfmt+0x13b>
  800379:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  800380:	85 d2                	test   %edx,%edx
  800382:	74 18                	je     80039c <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800384:	52                   	push   %edx
  800385:	68 7b 27 80 00       	push   $0x80277b
  80038a:	53                   	push   %ebx
  80038b:	56                   	push   %esi
  80038c:	e8 b3 fe ff ff       	call   800244 <printfmt>
  800391:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800394:	89 7d 14             	mov    %edi,0x14(%ebp)
  800397:	e9 fa 02 00 00       	jmp    800696 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80039c:	50                   	push   %eax
  80039d:	68 8a 23 80 00       	push   $0x80238a
  8003a2:	53                   	push   %ebx
  8003a3:	56                   	push   %esi
  8003a4:	e8 9b fe ff ff       	call   800244 <printfmt>
  8003a9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ac:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003af:	e9 e2 02 00 00       	jmp    800696 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	83 c0 04             	add    $0x4,%eax
  8003ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003c2:	85 ff                	test   %edi,%edi
  8003c4:	b8 83 23 80 00       	mov    $0x802383,%eax
  8003c9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d0:	0f 8e bd 00 00 00    	jle    800493 <vprintfmt+0x232>
  8003d6:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003da:	75 0e                	jne    8003ea <vprintfmt+0x189>
  8003dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8003df:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003e2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003e5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003e8:	eb 6d                	jmp    800457 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8003f0:	57                   	push   %edi
  8003f1:	e8 ec 03 00 00       	call   8007e2 <strnlen>
  8003f6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003f9:	29 c1                	sub    %eax,%ecx
  8003fb:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003fe:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800401:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800408:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80040b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80040d:	eb 0f                	jmp    80041e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	53                   	push   %ebx
  800413:	ff 75 e0             	pushl  -0x20(%ebp)
  800416:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800418:	83 ef 01             	sub    $0x1,%edi
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	85 ff                	test   %edi,%edi
  800420:	7f ed                	jg     80040f <vprintfmt+0x1ae>
  800422:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800425:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800428:	85 c9                	test   %ecx,%ecx
  80042a:	b8 00 00 00 00       	mov    $0x0,%eax
  80042f:	0f 49 c1             	cmovns %ecx,%eax
  800432:	29 c1                	sub    %eax,%ecx
  800434:	89 75 08             	mov    %esi,0x8(%ebp)
  800437:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80043a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80043d:	89 cb                	mov    %ecx,%ebx
  80043f:	eb 16                	jmp    800457 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800441:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800445:	75 31                	jne    800478 <vprintfmt+0x217>
					putch(ch, putdat);
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	ff 55 08             	call   *0x8(%ebp)
  800451:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800454:	83 eb 01             	sub    $0x1,%ebx
  800457:	83 c7 01             	add    $0x1,%edi
  80045a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80045e:	0f be c2             	movsbl %dl,%eax
  800461:	85 c0                	test   %eax,%eax
  800463:	74 59                	je     8004be <vprintfmt+0x25d>
  800465:	85 f6                	test   %esi,%esi
  800467:	78 d8                	js     800441 <vprintfmt+0x1e0>
  800469:	83 ee 01             	sub    $0x1,%esi
  80046c:	79 d3                	jns    800441 <vprintfmt+0x1e0>
  80046e:	89 df                	mov    %ebx,%edi
  800470:	8b 75 08             	mov    0x8(%ebp),%esi
  800473:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800476:	eb 37                	jmp    8004af <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800478:	0f be d2             	movsbl %dl,%edx
  80047b:	83 ea 20             	sub    $0x20,%edx
  80047e:	83 fa 5e             	cmp    $0x5e,%edx
  800481:	76 c4                	jbe    800447 <vprintfmt+0x1e6>
					putch('?', putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 0c             	pushl  0xc(%ebp)
  800489:	6a 3f                	push   $0x3f
  80048b:	ff 55 08             	call   *0x8(%ebp)
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	eb c1                	jmp    800454 <vprintfmt+0x1f3>
  800493:	89 75 08             	mov    %esi,0x8(%ebp)
  800496:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800499:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80049c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049f:	eb b6                	jmp    800457 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 20                	push   $0x20
  8004a7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a9:	83 ef 01             	sub    $0x1,%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	85 ff                	test   %edi,%edi
  8004b1:	7f ee                	jg     8004a1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b9:	e9 d8 01 00 00       	jmp    800696 <vprintfmt+0x435>
  8004be:	89 df                	mov    %ebx,%edi
  8004c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c6:	eb e7                	jmp    8004af <vprintfmt+0x24e>
	if (lflag >= 2)
  8004c8:	83 f9 01             	cmp    $0x1,%ecx
  8004cb:	7e 45                	jle    800512 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8b 50 04             	mov    0x4(%eax),%edx
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 08             	lea    0x8(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e8:	79 62                	jns    80054c <vprintfmt+0x2eb>
				putch('-', putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	6a 2d                	push   $0x2d
  8004f0:	ff d6                	call   *%esi
				num = -(long long) num;
  8004f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004f8:	f7 d8                	neg    %eax
  8004fa:	83 d2 00             	adc    $0x0,%edx
  8004fd:	f7 da                	neg    %edx
  8004ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800508:	ba 0a 00 00 00       	mov    $0xa,%edx
  80050d:	e9 66 01 00 00       	jmp    800678 <vprintfmt+0x417>
	else if (lflag)
  800512:	85 c9                	test   %ecx,%ecx
  800514:	75 1b                	jne    800531 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051e:	89 c1                	mov    %eax,%ecx
  800520:	c1 f9 1f             	sar    $0x1f,%ecx
  800523:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 40 04             	lea    0x4(%eax),%eax
  80052c:	89 45 14             	mov    %eax,0x14(%ebp)
  80052f:	eb b3                	jmp    8004e4 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800539:	89 c1                	mov    %eax,%ecx
  80053b:	c1 f9 1f             	sar    $0x1f,%ecx
  80053e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 40 04             	lea    0x4(%eax),%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
  80054a:	eb 98                	jmp    8004e4 <vprintfmt+0x283>
			base = 10;
  80054c:	ba 0a 00 00 00       	mov    $0xa,%edx
  800551:	e9 22 01 00 00       	jmp    800678 <vprintfmt+0x417>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7e 21                	jle    80057c <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 50 04             	mov    0x4(%eax),%edx
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800566:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 40 08             	lea    0x8(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800572:	ba 0a 00 00 00       	mov    $0xa,%edx
  800577:	e9 fc 00 00 00       	jmp    800678 <vprintfmt+0x417>
	else if (lflag)
  80057c:	85 c9                	test   %ecx,%ecx
  80057e:	75 23                	jne    8005a3 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	ba 00 00 00 00       	mov    $0x0,%edx
  80058a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8d 40 04             	lea    0x4(%eax),%eax
  800596:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800599:	ba 0a 00 00 00       	mov    $0xa,%edx
  80059e:	e9 d5 00 00 00       	jmp    800678 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8d 40 04             	lea    0x4(%eax),%eax
  8005b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bc:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005c1:	e9 b2 00 00 00       	jmp    800678 <vprintfmt+0x417>
	if (lflag >= 2)
  8005c6:	83 f9 01             	cmp    $0x1,%ecx
  8005c9:	7e 42                	jle    80060d <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 40 08             	lea    0x8(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e2:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8005e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005eb:	0f 89 87 00 00 00    	jns    800678 <vprintfmt+0x417>
				putch('-', putdat);
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	53                   	push   %ebx
  8005f5:	6a 2d                	push   $0x2d
  8005f7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f9:	f7 5d d8             	negl   -0x28(%ebp)
  8005fc:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800600:	f7 5d dc             	negl   -0x24(%ebp)
  800603:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800606:	ba 08 00 00 00       	mov    $0x8,%edx
  80060b:	eb 6b                	jmp    800678 <vprintfmt+0x417>
	else if (lflag)
  80060d:	85 c9                	test   %ecx,%ecx
  80060f:	75 1b                	jne    80062c <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	ba 00 00 00 00       	mov    $0x0,%edx
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 04             	lea    0x4(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
  80062a:	eb b6                	jmp    8005e2 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	ba 00 00 00 00       	mov    $0x0,%edx
  800636:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800639:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8d 40 04             	lea    0x4(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
  800645:	eb 9b                	jmp    8005e2 <vprintfmt+0x381>
			putch('0', putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	53                   	push   %ebx
  80064b:	6a 30                	push   $0x30
  80064d:	ff d6                	call   *%esi
			putch('x', putdat);
  80064f:	83 c4 08             	add    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	6a 78                	push   $0x78
  800655:	ff d6                	call   *%esi
			num = (unsigned long long)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800667:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 04             	lea    0x4(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800673:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800678:	83 ec 0c             	sub    $0xc,%esp
  80067b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80067f:	50                   	push   %eax
  800680:	ff 75 e0             	pushl  -0x20(%ebp)
  800683:	52                   	push   %edx
  800684:	ff 75 dc             	pushl  -0x24(%ebp)
  800687:	ff 75 d8             	pushl  -0x28(%ebp)
  80068a:	89 da                	mov    %ebx,%edx
  80068c:	89 f0                	mov    %esi,%eax
  80068e:	e8 e5 fa ff ff       	call   800178 <printnum>
			break;
  800693:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800696:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800699:	83 c7 01             	add    $0x1,%edi
  80069c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a0:	83 f8 25             	cmp    $0x25,%eax
  8006a3:	0f 84 cf fb ff ff    	je     800278 <vprintfmt+0x17>
			if (ch == '\0')
  8006a9:	85 c0                	test   %eax,%eax
  8006ab:	0f 84 a9 00 00 00    	je     80075a <vprintfmt+0x4f9>
			putch(ch, putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	50                   	push   %eax
  8006b6:	ff d6                	call   *%esi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	eb dc                	jmp    800699 <vprintfmt+0x438>
	if (lflag >= 2)
  8006bd:	83 f9 01             	cmp    $0x1,%ecx
  8006c0:	7e 1e                	jle    8006e0 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 50 04             	mov    0x4(%eax),%edx
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 40 08             	lea    0x8(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d9:	ba 10 00 00 00       	mov    $0x10,%edx
  8006de:	eb 98                	jmp    800678 <vprintfmt+0x417>
	else if (lflag)
  8006e0:	85 c9                	test   %ecx,%ecx
  8006e2:	75 23                	jne    800707 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fd:	ba 10 00 00 00       	mov    $0x10,%edx
  800702:	e9 71 ff ff ff       	jmp    800678 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	ba 00 00 00 00       	mov    $0x0,%edx
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800720:	ba 10 00 00 00       	mov    $0x10,%edx
  800725:	e9 4e ff ff ff       	jmp    800678 <vprintfmt+0x417>
			putch(ch, putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 25                	push   $0x25
  800730:	ff d6                	call   *%esi
			break;
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	e9 5c ff ff ff       	jmp    800696 <vprintfmt+0x435>
			putch('%', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	6a 25                	push   $0x25
  800740:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	89 f8                	mov    %edi,%eax
  800747:	eb 03                	jmp    80074c <vprintfmt+0x4eb>
  800749:	83 e8 01             	sub    $0x1,%eax
  80074c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800750:	75 f7                	jne    800749 <vprintfmt+0x4e8>
  800752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800755:	e9 3c ff ff ff       	jmp    800696 <vprintfmt+0x435>
}
  80075a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075d:	5b                   	pop    %ebx
  80075e:	5e                   	pop    %esi
  80075f:	5f                   	pop    %edi
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 18             	sub    $0x18,%esp
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800771:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800775:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077f:	85 c0                	test   %eax,%eax
  800781:	74 26                	je     8007a9 <vsnprintf+0x47>
  800783:	85 d2                	test   %edx,%edx
  800785:	7e 22                	jle    8007a9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800787:	ff 75 14             	pushl  0x14(%ebp)
  80078a:	ff 75 10             	pushl  0x10(%ebp)
  80078d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	68 27 02 80 00       	push   $0x800227
  800796:	e8 c6 fa ff ff       	call   800261 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
}
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    
		return -E_INVAL;
  8007a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ae:	eb f7                	jmp    8007a7 <vsnprintf+0x45>

008007b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b9:	50                   	push   %eax
  8007ba:	ff 75 10             	pushl  0x10(%ebp)
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	ff 75 08             	pushl  0x8(%ebp)
  8007c3:	e8 9a ff ff ff       	call   800762 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d5:	eb 03                	jmp    8007da <strlen+0x10>
		n++;
  8007d7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007da:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007de:	75 f7                	jne    8007d7 <strlen+0xd>
	return n;
}
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f0:	eb 03                	jmp    8007f5 <strnlen+0x13>
		n++;
  8007f2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f5:	39 d0                	cmp    %edx,%eax
  8007f7:	74 06                	je     8007ff <strnlen+0x1d>
  8007f9:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007fd:	75 f3                	jne    8007f2 <strnlen+0x10>
	return n;
}
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	53                   	push   %ebx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080b:	89 c2                	mov    %eax,%edx
  80080d:	83 c1 01             	add    $0x1,%ecx
  800810:	83 c2 01             	add    $0x1,%edx
  800813:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800817:	88 5a ff             	mov    %bl,-0x1(%edx)
  80081a:	84 db                	test   %bl,%bl
  80081c:	75 ef                	jne    80080d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80081e:	5b                   	pop    %ebx
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	53                   	push   %ebx
  800825:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800828:	53                   	push   %ebx
  800829:	e8 9c ff ff ff       	call   8007ca <strlen>
  80082e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	01 d8                	add    %ebx,%eax
  800836:	50                   	push   %eax
  800837:	e8 c5 ff ff ff       	call   800801 <strcpy>
	return dst;
}
  80083c:	89 d8                	mov    %ebx,%eax
  80083e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800841:	c9                   	leave  
  800842:	c3                   	ret    

00800843 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	56                   	push   %esi
  800847:	53                   	push   %ebx
  800848:	8b 75 08             	mov    0x8(%ebp),%esi
  80084b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084e:	89 f3                	mov    %esi,%ebx
  800850:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800853:	89 f2                	mov    %esi,%edx
  800855:	eb 0f                	jmp    800866 <strncpy+0x23>
		*dst++ = *src;
  800857:	83 c2 01             	add    $0x1,%edx
  80085a:	0f b6 01             	movzbl (%ecx),%eax
  80085d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800860:	80 39 01             	cmpb   $0x1,(%ecx)
  800863:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800866:	39 da                	cmp    %ebx,%edx
  800868:	75 ed                	jne    800857 <strncpy+0x14>
	}
	return ret;
}
  80086a:	89 f0                	mov    %esi,%eax
  80086c:	5b                   	pop    %ebx
  80086d:	5e                   	pop    %esi
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	56                   	push   %esi
  800874:	53                   	push   %ebx
  800875:	8b 75 08             	mov    0x8(%ebp),%esi
  800878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80087e:	89 f0                	mov    %esi,%eax
  800880:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800884:	85 c9                	test   %ecx,%ecx
  800886:	75 0b                	jne    800893 <strlcpy+0x23>
  800888:	eb 17                	jmp    8008a1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80088a:	83 c2 01             	add    $0x1,%edx
  80088d:	83 c0 01             	add    $0x1,%eax
  800890:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800893:	39 d8                	cmp    %ebx,%eax
  800895:	74 07                	je     80089e <strlcpy+0x2e>
  800897:	0f b6 0a             	movzbl (%edx),%ecx
  80089a:	84 c9                	test   %cl,%cl
  80089c:	75 ec                	jne    80088a <strlcpy+0x1a>
		*dst = '\0';
  80089e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008a1:	29 f0                	sub    %esi,%eax
}
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008b0:	eb 06                	jmp    8008b8 <strcmp+0x11>
		p++, q++;
  8008b2:	83 c1 01             	add    $0x1,%ecx
  8008b5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008b8:	0f b6 01             	movzbl (%ecx),%eax
  8008bb:	84 c0                	test   %al,%al
  8008bd:	74 04                	je     8008c3 <strcmp+0x1c>
  8008bf:	3a 02                	cmp    (%edx),%al
  8008c1:	74 ef                	je     8008b2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	0f b6 12             	movzbl (%edx),%edx
  8008c9:	29 d0                	sub    %edx,%eax
}
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    

008008cd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	53                   	push   %ebx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d7:	89 c3                	mov    %eax,%ebx
  8008d9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008dc:	eb 06                	jmp    8008e4 <strncmp+0x17>
		n--, p++, q++;
  8008de:	83 c0 01             	add    $0x1,%eax
  8008e1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008e4:	39 d8                	cmp    %ebx,%eax
  8008e6:	74 16                	je     8008fe <strncmp+0x31>
  8008e8:	0f b6 08             	movzbl (%eax),%ecx
  8008eb:	84 c9                	test   %cl,%cl
  8008ed:	74 04                	je     8008f3 <strncmp+0x26>
  8008ef:	3a 0a                	cmp    (%edx),%cl
  8008f1:	74 eb                	je     8008de <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f3:	0f b6 00             	movzbl (%eax),%eax
  8008f6:	0f b6 12             	movzbl (%edx),%edx
  8008f9:	29 d0                	sub    %edx,%eax
}
  8008fb:	5b                   	pop    %ebx
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    
		return 0;
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	eb f6                	jmp    8008fb <strncmp+0x2e>

00800905 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090f:	0f b6 10             	movzbl (%eax),%edx
  800912:	84 d2                	test   %dl,%dl
  800914:	74 09                	je     80091f <strchr+0x1a>
		if (*s == c)
  800916:	38 ca                	cmp    %cl,%dl
  800918:	74 0a                	je     800924 <strchr+0x1f>
	for (; *s; s++)
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	eb f0                	jmp    80090f <strchr+0xa>
			return (char *) s;
	return 0;
  80091f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800930:	eb 03                	jmp    800935 <strfind+0xf>
  800932:	83 c0 01             	add    $0x1,%eax
  800935:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800938:	38 ca                	cmp    %cl,%dl
  80093a:	74 04                	je     800940 <strfind+0x1a>
  80093c:	84 d2                	test   %dl,%dl
  80093e:	75 f2                	jne    800932 <strfind+0xc>
			break;
	return (char *) s;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	57                   	push   %edi
  800946:	56                   	push   %esi
  800947:	53                   	push   %ebx
  800948:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094e:	85 c9                	test   %ecx,%ecx
  800950:	74 13                	je     800965 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800952:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800958:	75 05                	jne    80095f <memset+0x1d>
  80095a:	f6 c1 03             	test   $0x3,%cl
  80095d:	74 0d                	je     80096c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800962:	fc                   	cld    
  800963:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800965:	89 f8                	mov    %edi,%eax
  800967:	5b                   	pop    %ebx
  800968:	5e                   	pop    %esi
  800969:	5f                   	pop    %edi
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    
		c &= 0xFF;
  80096c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800970:	89 d3                	mov    %edx,%ebx
  800972:	c1 e3 08             	shl    $0x8,%ebx
  800975:	89 d0                	mov    %edx,%eax
  800977:	c1 e0 18             	shl    $0x18,%eax
  80097a:	89 d6                	mov    %edx,%esi
  80097c:	c1 e6 10             	shl    $0x10,%esi
  80097f:	09 f0                	or     %esi,%eax
  800981:	09 c2                	or     %eax,%edx
  800983:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800985:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800988:	89 d0                	mov    %edx,%eax
  80098a:	fc                   	cld    
  80098b:	f3 ab                	rep stos %eax,%es:(%edi)
  80098d:	eb d6                	jmp    800965 <memset+0x23>

0080098f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	57                   	push   %edi
  800993:	56                   	push   %esi
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80099d:	39 c6                	cmp    %eax,%esi
  80099f:	73 35                	jae    8009d6 <memmove+0x47>
  8009a1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a4:	39 c2                	cmp    %eax,%edx
  8009a6:	76 2e                	jbe    8009d6 <memmove+0x47>
		s += n;
		d += n;
  8009a8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ab:	89 d6                	mov    %edx,%esi
  8009ad:	09 fe                	or     %edi,%esi
  8009af:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b5:	74 0c                	je     8009c3 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b7:	83 ef 01             	sub    $0x1,%edi
  8009ba:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009bd:	fd                   	std    
  8009be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c0:	fc                   	cld    
  8009c1:	eb 21                	jmp    8009e4 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c3:	f6 c1 03             	test   $0x3,%cl
  8009c6:	75 ef                	jne    8009b7 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c8:	83 ef 04             	sub    $0x4,%edi
  8009cb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ce:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009d1:	fd                   	std    
  8009d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d4:	eb ea                	jmp    8009c0 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d6:	89 f2                	mov    %esi,%edx
  8009d8:	09 c2                	or     %eax,%edx
  8009da:	f6 c2 03             	test   $0x3,%dl
  8009dd:	74 09                	je     8009e8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e4:	5e                   	pop    %esi
  8009e5:	5f                   	pop    %edi
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e8:	f6 c1 03             	test   $0x3,%cl
  8009eb:	75 f2                	jne    8009df <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ed:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009f0:	89 c7                	mov    %eax,%edi
  8009f2:	fc                   	cld    
  8009f3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f5:	eb ed                	jmp    8009e4 <memmove+0x55>

008009f7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009fa:	ff 75 10             	pushl  0x10(%ebp)
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	ff 75 08             	pushl  0x8(%ebp)
  800a03:	e8 87 ff ff ff       	call   80098f <memmove>
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	89 c6                	mov    %eax,%esi
  800a17:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1a:	39 f0                	cmp    %esi,%eax
  800a1c:	74 1c                	je     800a3a <memcmp+0x30>
		if (*s1 != *s2)
  800a1e:	0f b6 08             	movzbl (%eax),%ecx
  800a21:	0f b6 1a             	movzbl (%edx),%ebx
  800a24:	38 d9                	cmp    %bl,%cl
  800a26:	75 08                	jne    800a30 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	83 c2 01             	add    $0x1,%edx
  800a2e:	eb ea                	jmp    800a1a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a30:	0f b6 c1             	movzbl %cl,%eax
  800a33:	0f b6 db             	movzbl %bl,%ebx
  800a36:	29 d8                	sub    %ebx,%eax
  800a38:	eb 05                	jmp    800a3f <memcmp+0x35>
	}

	return 0;
  800a3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a4c:	89 c2                	mov    %eax,%edx
  800a4e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a51:	39 d0                	cmp    %edx,%eax
  800a53:	73 09                	jae    800a5e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a55:	38 08                	cmp    %cl,(%eax)
  800a57:	74 05                	je     800a5e <memfind+0x1b>
	for (; s < ends; s++)
  800a59:	83 c0 01             	add    $0x1,%eax
  800a5c:	eb f3                	jmp    800a51 <memfind+0xe>
			break;
	return (void *) s;
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6c:	eb 03                	jmp    800a71 <strtol+0x11>
		s++;
  800a6e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a71:	0f b6 01             	movzbl (%ecx),%eax
  800a74:	3c 20                	cmp    $0x20,%al
  800a76:	74 f6                	je     800a6e <strtol+0xe>
  800a78:	3c 09                	cmp    $0x9,%al
  800a7a:	74 f2                	je     800a6e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a7c:	3c 2b                	cmp    $0x2b,%al
  800a7e:	74 2e                	je     800aae <strtol+0x4e>
	int neg = 0;
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a85:	3c 2d                	cmp    $0x2d,%al
  800a87:	74 2f                	je     800ab8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a89:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8f:	75 05                	jne    800a96 <strtol+0x36>
  800a91:	80 39 30             	cmpb   $0x30,(%ecx)
  800a94:	74 2c                	je     800ac2 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a96:	85 db                	test   %ebx,%ebx
  800a98:	75 0a                	jne    800aa4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a9a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a9f:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa2:	74 28                	je     800acc <strtol+0x6c>
		base = 10;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aac:	eb 50                	jmp    800afe <strtol+0x9e>
		s++;
  800aae:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab6:	eb d1                	jmp    800a89 <strtol+0x29>
		s++, neg = 1;
  800ab8:	83 c1 01             	add    $0x1,%ecx
  800abb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac0:	eb c7                	jmp    800a89 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac6:	74 0e                	je     800ad6 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac8:	85 db                	test   %ebx,%ebx
  800aca:	75 d8                	jne    800aa4 <strtol+0x44>
		s++, base = 8;
  800acc:	83 c1 01             	add    $0x1,%ecx
  800acf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad4:	eb ce                	jmp    800aa4 <strtol+0x44>
		s += 2, base = 16;
  800ad6:	83 c1 02             	add    $0x2,%ecx
  800ad9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ade:	eb c4                	jmp    800aa4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ae0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae3:	89 f3                	mov    %esi,%ebx
  800ae5:	80 fb 19             	cmp    $0x19,%bl
  800ae8:	77 29                	ja     800b13 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aea:	0f be d2             	movsbl %dl,%edx
  800aed:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af3:	7d 30                	jge    800b25 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af5:	83 c1 01             	add    $0x1,%ecx
  800af8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800afc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800afe:	0f b6 11             	movzbl (%ecx),%edx
  800b01:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b04:	89 f3                	mov    %esi,%ebx
  800b06:	80 fb 09             	cmp    $0x9,%bl
  800b09:	77 d5                	ja     800ae0 <strtol+0x80>
			dig = *s - '0';
  800b0b:	0f be d2             	movsbl %dl,%edx
  800b0e:	83 ea 30             	sub    $0x30,%edx
  800b11:	eb dd                	jmp    800af0 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b13:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b16:	89 f3                	mov    %esi,%ebx
  800b18:	80 fb 19             	cmp    $0x19,%bl
  800b1b:	77 08                	ja     800b25 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b1d:	0f be d2             	movsbl %dl,%edx
  800b20:	83 ea 37             	sub    $0x37,%edx
  800b23:	eb cb                	jmp    800af0 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b29:	74 05                	je     800b30 <strtol+0xd0>
		*endptr = (char *) s;
  800b2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b30:	89 c2                	mov    %eax,%edx
  800b32:	f7 da                	neg    %edx
  800b34:	85 ff                	test   %edi,%edi
  800b36:	0f 45 c2             	cmovne %edx,%eax
}
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4f:	89 c3                	mov    %eax,%ebx
  800b51:	89 c7                	mov    %eax,%edi
  800b53:	89 c6                	mov    %eax,%esi
  800b55:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	57                   	push   %edi
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6c:	89 d1                	mov    %edx,%ecx
  800b6e:	89 d3                	mov    %edx,%ebx
  800b70:	89 d7                	mov    %edx,%edi
  800b72:	89 d6                	mov    %edx,%esi
  800b74:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5f                   	pop    %edi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
  800b81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b89:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b91:	89 cb                	mov    %ecx,%ebx
  800b93:	89 cf                	mov    %ecx,%edi
  800b95:	89 ce                	mov    %ecx,%esi
  800b97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b99:	85 c0                	test   %eax,%eax
  800b9b:	7f 08                	jg     800ba5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba5:	83 ec 0c             	sub    $0xc,%esp
  800ba8:	50                   	push   %eax
  800ba9:	6a 03                	push   $0x3
  800bab:	68 7f 26 80 00       	push   $0x80267f
  800bb0:	6a 23                	push   $0x23
  800bb2:	68 9c 26 80 00       	push   $0x80269c
  800bb7:	e8 ad 13 00 00       	call   801f69 <_panic>

00800bbc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc7:	b8 02 00 00 00       	mov    $0x2,%eax
  800bcc:	89 d1                	mov    %edx,%ecx
  800bce:	89 d3                	mov    %edx,%ebx
  800bd0:	89 d7                	mov    %edx,%edi
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <sys_yield>:

void
sys_yield(void)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	57                   	push   %edi
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800beb:	89 d1                	mov    %edx,%ecx
  800bed:	89 d3                	mov    %edx,%ebx
  800bef:	89 d7                	mov    %edx,%edi
  800bf1:	89 d6                	mov    %edx,%esi
  800bf3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
  800c00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c03:	be 00 00 00 00       	mov    $0x0,%esi
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c16:	89 f7                	mov    %esi,%edi
  800c18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7f 08                	jg     800c26 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	50                   	push   %eax
  800c2a:	6a 04                	push   $0x4
  800c2c:	68 7f 26 80 00       	push   $0x80267f
  800c31:	6a 23                	push   $0x23
  800c33:	68 9c 26 80 00       	push   $0x80269c
  800c38:	e8 2c 13 00 00       	call   801f69 <_panic>

00800c3d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
  800c43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c46:	8b 55 08             	mov    0x8(%ebp),%edx
  800c49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4c:	b8 05 00 00 00       	mov    $0x5,%eax
  800c51:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c54:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c57:	8b 75 18             	mov    0x18(%ebp),%esi
  800c5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	7f 08                	jg     800c68 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c68:	83 ec 0c             	sub    $0xc,%esp
  800c6b:	50                   	push   %eax
  800c6c:	6a 05                	push   $0x5
  800c6e:	68 7f 26 80 00       	push   $0x80267f
  800c73:	6a 23                	push   $0x23
  800c75:	68 9c 26 80 00       	push   $0x80269c
  800c7a:	e8 ea 12 00 00       	call   801f69 <_panic>

00800c7f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c93:	b8 06 00 00 00       	mov    $0x6,%eax
  800c98:	89 df                	mov    %ebx,%edi
  800c9a:	89 de                	mov    %ebx,%esi
  800c9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9e:	85 c0                	test   %eax,%eax
  800ca0:	7f 08                	jg     800caa <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800caa:	83 ec 0c             	sub    $0xc,%esp
  800cad:	50                   	push   %eax
  800cae:	6a 06                	push   $0x6
  800cb0:	68 7f 26 80 00       	push   $0x80267f
  800cb5:	6a 23                	push   $0x23
  800cb7:	68 9c 26 80 00       	push   $0x80269c
  800cbc:	e8 a8 12 00 00       	call   801f69 <_panic>

00800cc1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	b8 08 00 00 00       	mov    $0x8,%eax
  800cda:	89 df                	mov    %ebx,%edi
  800cdc:	89 de                	mov    %ebx,%esi
  800cde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce0:	85 c0                	test   %eax,%eax
  800ce2:	7f 08                	jg     800cec <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	50                   	push   %eax
  800cf0:	6a 08                	push   $0x8
  800cf2:	68 7f 26 80 00       	push   $0x80267f
  800cf7:	6a 23                	push   $0x23
  800cf9:	68 9c 26 80 00       	push   $0x80269c
  800cfe:	e8 66 12 00 00       	call   801f69 <_panic>

00800d03 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d11:	8b 55 08             	mov    0x8(%ebp),%edx
  800d14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d17:	b8 09 00 00 00       	mov    $0x9,%eax
  800d1c:	89 df                	mov    %ebx,%edi
  800d1e:	89 de                	mov    %ebx,%esi
  800d20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d22:	85 c0                	test   %eax,%eax
  800d24:	7f 08                	jg     800d2e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2e:	83 ec 0c             	sub    $0xc,%esp
  800d31:	50                   	push   %eax
  800d32:	6a 09                	push   $0x9
  800d34:	68 7f 26 80 00       	push   $0x80267f
  800d39:	6a 23                	push   $0x23
  800d3b:	68 9c 26 80 00       	push   $0x80269c
  800d40:	e8 24 12 00 00       	call   801f69 <_panic>

00800d45 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d5e:	89 df                	mov    %ebx,%edi
  800d60:	89 de                	mov    %ebx,%esi
  800d62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	7f 08                	jg     800d70 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	83 ec 0c             	sub    $0xc,%esp
  800d73:	50                   	push   %eax
  800d74:	6a 0a                	push   $0xa
  800d76:	68 7f 26 80 00       	push   $0x80267f
  800d7b:	6a 23                	push   $0x23
  800d7d:	68 9c 26 80 00       	push   $0x80269c
  800d82:	e8 e2 11 00 00       	call   801f69 <_panic>

00800d87 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d98:	be 00 00 00 00       	mov    $0x0,%esi
  800d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dc0:	89 cb                	mov    %ecx,%ebx
  800dc2:	89 cf                	mov    %ecx,%edi
  800dc4:	89 ce                	mov    %ecx,%esi
  800dc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7f 08                	jg     800dd4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	50                   	push   %eax
  800dd8:	6a 0d                	push   $0xd
  800dda:	68 7f 26 80 00       	push   $0x80267f
  800ddf:	6a 23                	push   $0x23
  800de1:	68 9c 26 80 00       	push   $0x80269c
  800de6:	e8 7e 11 00 00       	call   801f69 <_panic>

00800deb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df1:	ba 00 00 00 00       	mov    $0x0,%edx
  800df6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dfb:	89 d1                	mov    %edx,%ecx
  800dfd:	89 d3                	mov    %edx,%ebx
  800dff:	89 d7                	mov    %edx,%edi
  800e01:	89 d6                	mov    %edx,%esi
  800e03:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	05 00 00 00 30       	add    $0x30000000,%eax
  800e15:	c1 e8 0c             	shr    $0xc,%eax
}
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e2a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    

00800e31 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e37:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e3c:	89 c2                	mov    %eax,%edx
  800e3e:	c1 ea 16             	shr    $0x16,%edx
  800e41:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e48:	f6 c2 01             	test   $0x1,%dl
  800e4b:	74 2a                	je     800e77 <fd_alloc+0x46>
  800e4d:	89 c2                	mov    %eax,%edx
  800e4f:	c1 ea 0c             	shr    $0xc,%edx
  800e52:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e59:	f6 c2 01             	test   $0x1,%dl
  800e5c:	74 19                	je     800e77 <fd_alloc+0x46>
  800e5e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e63:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e68:	75 d2                	jne    800e3c <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e6a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e70:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e75:	eb 07                	jmp    800e7e <fd_alloc+0x4d>
			*fd_store = fd;
  800e77:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e86:	83 f8 1f             	cmp    $0x1f,%eax
  800e89:	77 36                	ja     800ec1 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e8b:	c1 e0 0c             	shl    $0xc,%eax
  800e8e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e93:	89 c2                	mov    %eax,%edx
  800e95:	c1 ea 16             	shr    $0x16,%edx
  800e98:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e9f:	f6 c2 01             	test   $0x1,%dl
  800ea2:	74 24                	je     800ec8 <fd_lookup+0x48>
  800ea4:	89 c2                	mov    %eax,%edx
  800ea6:	c1 ea 0c             	shr    $0xc,%edx
  800ea9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eb0:	f6 c2 01             	test   $0x1,%dl
  800eb3:	74 1a                	je     800ecf <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb8:	89 02                	mov    %eax,(%edx)
	return 0;
  800eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    
		return -E_INVAL;
  800ec1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec6:	eb f7                	jmp    800ebf <fd_lookup+0x3f>
		return -E_INVAL;
  800ec8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ecd:	eb f0                	jmp    800ebf <fd_lookup+0x3f>
  800ecf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed4:	eb e9                	jmp    800ebf <fd_lookup+0x3f>

00800ed6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	ba 28 27 80 00       	mov    $0x802728,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ee4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ee9:	39 08                	cmp    %ecx,(%eax)
  800eeb:	74 33                	je     800f20 <dev_lookup+0x4a>
  800eed:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ef0:	8b 02                	mov    (%edx),%eax
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	75 f3                	jne    800ee9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ef6:	a1 08 40 80 00       	mov    0x804008,%eax
  800efb:	8b 40 48             	mov    0x48(%eax),%eax
  800efe:	83 ec 04             	sub    $0x4,%esp
  800f01:	51                   	push   %ecx
  800f02:	50                   	push   %eax
  800f03:	68 ac 26 80 00       	push   $0x8026ac
  800f08:	e8 57 f2 ff ff       	call   800164 <cprintf>
	*dev = 0;
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f16:	83 c4 10             	add    $0x10,%esp
  800f19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    
			*dev = devtab[i];
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2a:	eb f2                	jmp    800f1e <dev_lookup+0x48>

00800f2c <fd_close>:
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
  800f32:	83 ec 1c             	sub    $0x1c,%esp
  800f35:	8b 75 08             	mov    0x8(%ebp),%esi
  800f38:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f3b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f3e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f45:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f48:	50                   	push   %eax
  800f49:	e8 32 ff ff ff       	call   800e80 <fd_lookup>
  800f4e:	89 c3                	mov    %eax,%ebx
  800f50:	83 c4 08             	add    $0x8,%esp
  800f53:	85 c0                	test   %eax,%eax
  800f55:	78 05                	js     800f5c <fd_close+0x30>
	    || fd != fd2)
  800f57:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f5a:	74 16                	je     800f72 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f5c:	89 f8                	mov    %edi,%eax
  800f5e:	84 c0                	test   %al,%al
  800f60:	b8 00 00 00 00       	mov    $0x0,%eax
  800f65:	0f 44 d8             	cmove  %eax,%ebx
}
  800f68:	89 d8                	mov    %ebx,%eax
  800f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6d:	5b                   	pop    %ebx
  800f6e:	5e                   	pop    %esi
  800f6f:	5f                   	pop    %edi
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f78:	50                   	push   %eax
  800f79:	ff 36                	pushl  (%esi)
  800f7b:	e8 56 ff ff ff       	call   800ed6 <dev_lookup>
  800f80:	89 c3                	mov    %eax,%ebx
  800f82:	83 c4 10             	add    $0x10,%esp
  800f85:	85 c0                	test   %eax,%eax
  800f87:	78 15                	js     800f9e <fd_close+0x72>
		if (dev->dev_close)
  800f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f8c:	8b 40 10             	mov    0x10(%eax),%eax
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	74 1b                	je     800fae <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f93:	83 ec 0c             	sub    $0xc,%esp
  800f96:	56                   	push   %esi
  800f97:	ff d0                	call   *%eax
  800f99:	89 c3                	mov    %eax,%ebx
  800f9b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	56                   	push   %esi
  800fa2:	6a 00                	push   $0x0
  800fa4:	e8 d6 fc ff ff       	call   800c7f <sys_page_unmap>
	return r;
  800fa9:	83 c4 10             	add    $0x10,%esp
  800fac:	eb ba                	jmp    800f68 <fd_close+0x3c>
			r = 0;
  800fae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb3:	eb e9                	jmp    800f9e <fd_close+0x72>

00800fb5 <close>:

int
close(int fdnum)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fbe:	50                   	push   %eax
  800fbf:	ff 75 08             	pushl  0x8(%ebp)
  800fc2:	e8 b9 fe ff ff       	call   800e80 <fd_lookup>
  800fc7:	83 c4 08             	add    $0x8,%esp
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	78 10                	js     800fde <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fce:	83 ec 08             	sub    $0x8,%esp
  800fd1:	6a 01                	push   $0x1
  800fd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd6:	e8 51 ff ff ff       	call   800f2c <fd_close>
  800fdb:	83 c4 10             	add    $0x10,%esp
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <close_all>:

void
close_all(void)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fe7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	53                   	push   %ebx
  800ff0:	e8 c0 ff ff ff       	call   800fb5 <close>
	for (i = 0; i < MAXFD; i++)
  800ff5:	83 c3 01             	add    $0x1,%ebx
  800ff8:	83 c4 10             	add    $0x10,%esp
  800ffb:	83 fb 20             	cmp    $0x20,%ebx
  800ffe:	75 ec                	jne    800fec <close_all+0xc>
}
  801000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	57                   	push   %edi
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80100e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801011:	50                   	push   %eax
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 66 fe ff ff       	call   800e80 <fd_lookup>
  80101a:	89 c3                	mov    %eax,%ebx
  80101c:	83 c4 08             	add    $0x8,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	0f 88 81 00 00 00    	js     8010a8 <dup+0xa3>
		return r;
	close(newfdnum);
  801027:	83 ec 0c             	sub    $0xc,%esp
  80102a:	ff 75 0c             	pushl  0xc(%ebp)
  80102d:	e8 83 ff ff ff       	call   800fb5 <close>

	newfd = INDEX2FD(newfdnum);
  801032:	8b 75 0c             	mov    0xc(%ebp),%esi
  801035:	c1 e6 0c             	shl    $0xc,%esi
  801038:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80103e:	83 c4 04             	add    $0x4,%esp
  801041:	ff 75 e4             	pushl  -0x1c(%ebp)
  801044:	e8 d1 fd ff ff       	call   800e1a <fd2data>
  801049:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80104b:	89 34 24             	mov    %esi,(%esp)
  80104e:	e8 c7 fd ff ff       	call   800e1a <fd2data>
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801058:	89 d8                	mov    %ebx,%eax
  80105a:	c1 e8 16             	shr    $0x16,%eax
  80105d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801064:	a8 01                	test   $0x1,%al
  801066:	74 11                	je     801079 <dup+0x74>
  801068:	89 d8                	mov    %ebx,%eax
  80106a:	c1 e8 0c             	shr    $0xc,%eax
  80106d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801074:	f6 c2 01             	test   $0x1,%dl
  801077:	75 39                	jne    8010b2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801079:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80107c:	89 d0                	mov    %edx,%eax
  80107e:	c1 e8 0c             	shr    $0xc,%eax
  801081:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	25 07 0e 00 00       	and    $0xe07,%eax
  801090:	50                   	push   %eax
  801091:	56                   	push   %esi
  801092:	6a 00                	push   $0x0
  801094:	52                   	push   %edx
  801095:	6a 00                	push   $0x0
  801097:	e8 a1 fb ff ff       	call   800c3d <sys_page_map>
  80109c:	89 c3                	mov    %eax,%ebx
  80109e:	83 c4 20             	add    $0x20,%esp
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	78 31                	js     8010d6 <dup+0xd1>
		goto err;

	return newfdnum;
  8010a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010a8:	89 d8                	mov    %ebx,%eax
  8010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010b2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c1:	50                   	push   %eax
  8010c2:	57                   	push   %edi
  8010c3:	6a 00                	push   $0x0
  8010c5:	53                   	push   %ebx
  8010c6:	6a 00                	push   $0x0
  8010c8:	e8 70 fb ff ff       	call   800c3d <sys_page_map>
  8010cd:	89 c3                	mov    %eax,%ebx
  8010cf:	83 c4 20             	add    $0x20,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	79 a3                	jns    801079 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010d6:	83 ec 08             	sub    $0x8,%esp
  8010d9:	56                   	push   %esi
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 9e fb ff ff       	call   800c7f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010e1:	83 c4 08             	add    $0x8,%esp
  8010e4:	57                   	push   %edi
  8010e5:	6a 00                	push   $0x0
  8010e7:	e8 93 fb ff ff       	call   800c7f <sys_page_unmap>
	return r;
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	eb b7                	jmp    8010a8 <dup+0xa3>

008010f1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	53                   	push   %ebx
  8010f5:	83 ec 14             	sub    $0x14,%esp
  8010f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010fe:	50                   	push   %eax
  8010ff:	53                   	push   %ebx
  801100:	e8 7b fd ff ff       	call   800e80 <fd_lookup>
  801105:	83 c4 08             	add    $0x8,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	78 3f                	js     80114b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801112:	50                   	push   %eax
  801113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801116:	ff 30                	pushl  (%eax)
  801118:	e8 b9 fd ff ff       	call   800ed6 <dev_lookup>
  80111d:	83 c4 10             	add    $0x10,%esp
  801120:	85 c0                	test   %eax,%eax
  801122:	78 27                	js     80114b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801124:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801127:	8b 42 08             	mov    0x8(%edx),%eax
  80112a:	83 e0 03             	and    $0x3,%eax
  80112d:	83 f8 01             	cmp    $0x1,%eax
  801130:	74 1e                	je     801150 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801135:	8b 40 08             	mov    0x8(%eax),%eax
  801138:	85 c0                	test   %eax,%eax
  80113a:	74 35                	je     801171 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80113c:	83 ec 04             	sub    $0x4,%esp
  80113f:	ff 75 10             	pushl  0x10(%ebp)
  801142:	ff 75 0c             	pushl  0xc(%ebp)
  801145:	52                   	push   %edx
  801146:	ff d0                	call   *%eax
  801148:	83 c4 10             	add    $0x10,%esp
}
  80114b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801150:	a1 08 40 80 00       	mov    0x804008,%eax
  801155:	8b 40 48             	mov    0x48(%eax),%eax
  801158:	83 ec 04             	sub    $0x4,%esp
  80115b:	53                   	push   %ebx
  80115c:	50                   	push   %eax
  80115d:	68 ed 26 80 00       	push   $0x8026ed
  801162:	e8 fd ef ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116f:	eb da                	jmp    80114b <read+0x5a>
		return -E_NOT_SUPP;
  801171:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801176:	eb d3                	jmp    80114b <read+0x5a>

00801178 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	57                   	push   %edi
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
  80117e:	83 ec 0c             	sub    $0xc,%esp
  801181:	8b 7d 08             	mov    0x8(%ebp),%edi
  801184:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801187:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118c:	39 f3                	cmp    %esi,%ebx
  80118e:	73 25                	jae    8011b5 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801190:	83 ec 04             	sub    $0x4,%esp
  801193:	89 f0                	mov    %esi,%eax
  801195:	29 d8                	sub    %ebx,%eax
  801197:	50                   	push   %eax
  801198:	89 d8                	mov    %ebx,%eax
  80119a:	03 45 0c             	add    0xc(%ebp),%eax
  80119d:	50                   	push   %eax
  80119e:	57                   	push   %edi
  80119f:	e8 4d ff ff ff       	call   8010f1 <read>
		if (m < 0)
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	78 08                	js     8011b3 <readn+0x3b>
			return m;
		if (m == 0)
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	74 06                	je     8011b5 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011af:	01 c3                	add    %eax,%ebx
  8011b1:	eb d9                	jmp    80118c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011b3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011b5:	89 d8                	mov    %ebx,%eax
  8011b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ba:	5b                   	pop    %ebx
  8011bb:	5e                   	pop    %esi
  8011bc:	5f                   	pop    %edi
  8011bd:	5d                   	pop    %ebp
  8011be:	c3                   	ret    

008011bf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	53                   	push   %ebx
  8011c3:	83 ec 14             	sub    $0x14,%esp
  8011c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011cc:	50                   	push   %eax
  8011cd:	53                   	push   %ebx
  8011ce:	e8 ad fc ff ff       	call   800e80 <fd_lookup>
  8011d3:	83 c4 08             	add    $0x8,%esp
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	78 3a                	js     801214 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011da:	83 ec 08             	sub    $0x8,%esp
  8011dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e0:	50                   	push   %eax
  8011e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e4:	ff 30                	pushl  (%eax)
  8011e6:	e8 eb fc ff ff       	call   800ed6 <dev_lookup>
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	78 22                	js     801214 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011f9:	74 1e                	je     801219 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fe:	8b 52 0c             	mov    0xc(%edx),%edx
  801201:	85 d2                	test   %edx,%edx
  801203:	74 35                	je     80123a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	ff 75 10             	pushl  0x10(%ebp)
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff d2                	call   *%edx
  801211:	83 c4 10             	add    $0x10,%esp
}
  801214:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801217:	c9                   	leave  
  801218:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801219:	a1 08 40 80 00       	mov    0x804008,%eax
  80121e:	8b 40 48             	mov    0x48(%eax),%eax
  801221:	83 ec 04             	sub    $0x4,%esp
  801224:	53                   	push   %ebx
  801225:	50                   	push   %eax
  801226:	68 09 27 80 00       	push   $0x802709
  80122b:	e8 34 ef ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801238:	eb da                	jmp    801214 <write+0x55>
		return -E_NOT_SUPP;
  80123a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80123f:	eb d3                	jmp    801214 <write+0x55>

00801241 <seek>:

int
seek(int fdnum, off_t offset)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801247:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80124a:	50                   	push   %eax
  80124b:	ff 75 08             	pushl  0x8(%ebp)
  80124e:	e8 2d fc ff ff       	call   800e80 <fd_lookup>
  801253:	83 c4 08             	add    $0x8,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	78 0e                	js     801268 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80125a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801260:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	53                   	push   %ebx
  80126e:	83 ec 14             	sub    $0x14,%esp
  801271:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801274:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801277:	50                   	push   %eax
  801278:	53                   	push   %ebx
  801279:	e8 02 fc ff ff       	call   800e80 <fd_lookup>
  80127e:	83 c4 08             	add    $0x8,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 37                	js     8012bc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128b:	50                   	push   %eax
  80128c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128f:	ff 30                	pushl  (%eax)
  801291:	e8 40 fc ff ff       	call   800ed6 <dev_lookup>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 1f                	js     8012bc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80129d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a4:	74 1b                	je     8012c1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a9:	8b 52 18             	mov    0x18(%edx),%edx
  8012ac:	85 d2                	test   %edx,%edx
  8012ae:	74 32                	je     8012e2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	50                   	push   %eax
  8012b7:	ff d2                	call   *%edx
  8012b9:	83 c4 10             	add    $0x10,%esp
}
  8012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012c1:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012c6:	8b 40 48             	mov    0x48(%eax),%eax
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	53                   	push   %ebx
  8012cd:	50                   	push   %eax
  8012ce:	68 cc 26 80 00       	push   $0x8026cc
  8012d3:	e8 8c ee ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e0:	eb da                	jmp    8012bc <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012e7:	eb d3                	jmp    8012bc <ftruncate+0x52>

008012e9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	53                   	push   %ebx
  8012ed:	83 ec 14             	sub    $0x14,%esp
  8012f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f6:	50                   	push   %eax
  8012f7:	ff 75 08             	pushl  0x8(%ebp)
  8012fa:	e8 81 fb ff ff       	call   800e80 <fd_lookup>
  8012ff:	83 c4 08             	add    $0x8,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	78 4b                	js     801351 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801310:	ff 30                	pushl  (%eax)
  801312:	e8 bf fb ff ff       	call   800ed6 <dev_lookup>
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 33                	js     801351 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80131e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801321:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801325:	74 2f                	je     801356 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801327:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80132a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801331:	00 00 00 
	stat->st_isdir = 0;
  801334:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80133b:	00 00 00 
	stat->st_dev = dev;
  80133e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801344:	83 ec 08             	sub    $0x8,%esp
  801347:	53                   	push   %ebx
  801348:	ff 75 f0             	pushl  -0x10(%ebp)
  80134b:	ff 50 14             	call   *0x14(%eax)
  80134e:	83 c4 10             	add    $0x10,%esp
}
  801351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801354:	c9                   	leave  
  801355:	c3                   	ret    
		return -E_NOT_SUPP;
  801356:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135b:	eb f4                	jmp    801351 <fstat+0x68>

0080135d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	6a 00                	push   $0x0
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	e8 26 02 00 00       	call   801595 <open>
  80136f:	89 c3                	mov    %eax,%ebx
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	78 1b                	js     801393 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801378:	83 ec 08             	sub    $0x8,%esp
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	50                   	push   %eax
  80137f:	e8 65 ff ff ff       	call   8012e9 <fstat>
  801384:	89 c6                	mov    %eax,%esi
	close(fd);
  801386:	89 1c 24             	mov    %ebx,(%esp)
  801389:	e8 27 fc ff ff       	call   800fb5 <close>
	return r;
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	89 f3                	mov    %esi,%ebx
}
  801393:	89 d8                	mov    %ebx,%eax
  801395:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801398:	5b                   	pop    %ebx
  801399:	5e                   	pop    %esi
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	56                   	push   %esi
  8013a0:	53                   	push   %ebx
  8013a1:	89 c6                	mov    %eax,%esi
  8013a3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013a5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013ac:	74 27                	je     8013d5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013ae:	6a 07                	push   $0x7
  8013b0:	68 00 50 80 00       	push   $0x805000
  8013b5:	56                   	push   %esi
  8013b6:	ff 35 00 40 80 00    	pushl  0x804000
  8013bc:	e8 57 0c 00 00       	call   802018 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013c1:	83 c4 0c             	add    $0xc,%esp
  8013c4:	6a 00                	push   $0x0
  8013c6:	53                   	push   %ebx
  8013c7:	6a 00                	push   $0x0
  8013c9:	e8 e1 0b 00 00       	call   801faf <ipc_recv>
}
  8013ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d1:	5b                   	pop    %ebx
  8013d2:	5e                   	pop    %esi
  8013d3:	5d                   	pop    %ebp
  8013d4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013d5:	83 ec 0c             	sub    $0xc,%esp
  8013d8:	6a 01                	push   $0x1
  8013da:	e8 92 0c 00 00       	call   802071 <ipc_find_env>
  8013df:	a3 00 40 80 00       	mov    %eax,0x804000
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	eb c5                	jmp    8013ae <fsipc+0x12>

008013e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801402:	ba 00 00 00 00       	mov    $0x0,%edx
  801407:	b8 02 00 00 00       	mov    $0x2,%eax
  80140c:	e8 8b ff ff ff       	call   80139c <fsipc>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <devfile_flush>:
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8b 40 0c             	mov    0xc(%eax),%eax
  80141f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801424:	ba 00 00 00 00       	mov    $0x0,%edx
  801429:	b8 06 00 00 00       	mov    $0x6,%eax
  80142e:	e8 69 ff ff ff       	call   80139c <fsipc>
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <devfile_stat>:
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	53                   	push   %ebx
  801439:	83 ec 04             	sub    $0x4,%esp
  80143c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8b 40 0c             	mov    0xc(%eax),%eax
  801445:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80144a:	ba 00 00 00 00       	mov    $0x0,%edx
  80144f:	b8 05 00 00 00       	mov    $0x5,%eax
  801454:	e8 43 ff ff ff       	call   80139c <fsipc>
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 2c                	js     801489 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	68 00 50 80 00       	push   $0x805000
  801465:	53                   	push   %ebx
  801466:	e8 96 f3 ff ff       	call   800801 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80146b:	a1 80 50 80 00       	mov    0x805080,%eax
  801470:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801476:	a1 84 50 80 00       	mov    0x805084,%eax
  80147b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <devfile_write>:
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	53                   	push   %ebx
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8b 40 0c             	mov    0xc(%eax),%eax
  80149e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8014a3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014a9:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8014af:	77 30                	ja     8014e1 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	53                   	push   %ebx
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	68 08 50 80 00       	push   $0x805008
  8014bd:	e8 cd f4 ff ff       	call   80098f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8014cc:	e8 cb fe ff ff       	call   80139c <fsipc>
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 04                	js     8014dc <devfile_write+0x4e>
	assert(r <= n);
  8014d8:	39 d8                	cmp    %ebx,%eax
  8014da:	77 1e                	ja     8014fa <devfile_write+0x6c>
}
  8014dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014e1:	68 3c 27 80 00       	push   $0x80273c
  8014e6:	68 69 27 80 00       	push   $0x802769
  8014eb:	68 94 00 00 00       	push   $0x94
  8014f0:	68 7e 27 80 00       	push   $0x80277e
  8014f5:	e8 6f 0a 00 00       	call   801f69 <_panic>
	assert(r <= n);
  8014fa:	68 89 27 80 00       	push   $0x802789
  8014ff:	68 69 27 80 00       	push   $0x802769
  801504:	68 98 00 00 00       	push   $0x98
  801509:	68 7e 27 80 00       	push   $0x80277e
  80150e:	e8 56 0a 00 00       	call   801f69 <_panic>

00801513 <devfile_read>:
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	56                   	push   %esi
  801517:	53                   	push   %ebx
  801518:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8b 40 0c             	mov    0xc(%eax),%eax
  801521:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801526:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80152c:	ba 00 00 00 00       	mov    $0x0,%edx
  801531:	b8 03 00 00 00       	mov    $0x3,%eax
  801536:	e8 61 fe ff ff       	call   80139c <fsipc>
  80153b:	89 c3                	mov    %eax,%ebx
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 1f                	js     801560 <devfile_read+0x4d>
	assert(r <= n);
  801541:	39 f0                	cmp    %esi,%eax
  801543:	77 24                	ja     801569 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801545:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80154a:	7f 33                	jg     80157f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	50                   	push   %eax
  801550:	68 00 50 80 00       	push   $0x805000
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 32 f4 ff ff       	call   80098f <memmove>
	return r;
  80155d:	83 c4 10             	add    $0x10,%esp
}
  801560:	89 d8                	mov    %ebx,%eax
  801562:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    
	assert(r <= n);
  801569:	68 89 27 80 00       	push   $0x802789
  80156e:	68 69 27 80 00       	push   $0x802769
  801573:	6a 7c                	push   $0x7c
  801575:	68 7e 27 80 00       	push   $0x80277e
  80157a:	e8 ea 09 00 00       	call   801f69 <_panic>
	assert(r <= PGSIZE);
  80157f:	68 90 27 80 00       	push   $0x802790
  801584:	68 69 27 80 00       	push   $0x802769
  801589:	6a 7d                	push   $0x7d
  80158b:	68 7e 27 80 00       	push   $0x80277e
  801590:	e8 d4 09 00 00       	call   801f69 <_panic>

00801595 <open>:
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
  80159a:	83 ec 1c             	sub    $0x1c,%esp
  80159d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015a0:	56                   	push   %esi
  8015a1:	e8 24 f2 ff ff       	call   8007ca <strlen>
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015ae:	7f 6c                	jg     80161c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	e8 75 f8 ff ff       	call   800e31 <fd_alloc>
  8015bc:	89 c3                	mov    %eax,%ebx
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 3c                	js     801601 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	56                   	push   %esi
  8015c9:	68 00 50 80 00       	push   $0x805000
  8015ce:	e8 2e f2 ff ff       	call   800801 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e3:	e8 b4 fd ff ff       	call   80139c <fsipc>
  8015e8:	89 c3                	mov    %eax,%ebx
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 19                	js     80160a <open+0x75>
	return fd2num(fd);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f7:	e8 0e f8 ff ff       	call   800e0a <fd2num>
  8015fc:	89 c3                	mov    %eax,%ebx
  8015fe:	83 c4 10             	add    $0x10,%esp
}
  801601:	89 d8                	mov    %ebx,%eax
  801603:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801606:	5b                   	pop    %ebx
  801607:	5e                   	pop    %esi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    
		fd_close(fd, 0);
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	6a 00                	push   $0x0
  80160f:	ff 75 f4             	pushl  -0xc(%ebp)
  801612:	e8 15 f9 ff ff       	call   800f2c <fd_close>
		return r;
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	eb e5                	jmp    801601 <open+0x6c>
		return -E_BAD_PATH;
  80161c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801621:	eb de                	jmp    801601 <open+0x6c>

00801623 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801629:	ba 00 00 00 00       	mov    $0x0,%edx
  80162e:	b8 08 00 00 00       	mov    $0x8,%eax
  801633:	e8 64 fd ff ff       	call   80139c <fsipc>
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	56                   	push   %esi
  80163e:	53                   	push   %ebx
  80163f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	ff 75 08             	pushl  0x8(%ebp)
  801648:	e8 cd f7 ff ff       	call   800e1a <fd2data>
  80164d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80164f:	83 c4 08             	add    $0x8,%esp
  801652:	68 9c 27 80 00       	push   $0x80279c
  801657:	53                   	push   %ebx
  801658:	e8 a4 f1 ff ff       	call   800801 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80165d:	8b 46 04             	mov    0x4(%esi),%eax
  801660:	2b 06                	sub    (%esi),%eax
  801662:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801668:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80166f:	00 00 00 
	stat->st_dev = &devpipe;
  801672:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801679:	30 80 00 
	return 0;
}
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
  801681:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    

00801688 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	53                   	push   %ebx
  80168c:	83 ec 0c             	sub    $0xc,%esp
  80168f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801692:	53                   	push   %ebx
  801693:	6a 00                	push   $0x0
  801695:	e8 e5 f5 ff ff       	call   800c7f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80169a:	89 1c 24             	mov    %ebx,(%esp)
  80169d:	e8 78 f7 ff ff       	call   800e1a <fd2data>
  8016a2:	83 c4 08             	add    $0x8,%esp
  8016a5:	50                   	push   %eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	e8 d2 f5 ff ff       	call   800c7f <sys_page_unmap>
}
  8016ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <_pipeisclosed>:
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	57                   	push   %edi
  8016b6:	56                   	push   %esi
  8016b7:	53                   	push   %ebx
  8016b8:	83 ec 1c             	sub    $0x1c,%esp
  8016bb:	89 c7                	mov    %eax,%edi
  8016bd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8016c4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016c7:	83 ec 0c             	sub    $0xc,%esp
  8016ca:	57                   	push   %edi
  8016cb:	e8 da 09 00 00       	call   8020aa <pageref>
  8016d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016d3:	89 34 24             	mov    %esi,(%esp)
  8016d6:	e8 cf 09 00 00       	call   8020aa <pageref>
		nn = thisenv->env_runs;
  8016db:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8016e1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	39 cb                	cmp    %ecx,%ebx
  8016e9:	74 1b                	je     801706 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016eb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ee:	75 cf                	jne    8016bf <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016f0:	8b 42 58             	mov    0x58(%edx),%eax
  8016f3:	6a 01                	push   $0x1
  8016f5:	50                   	push   %eax
  8016f6:	53                   	push   %ebx
  8016f7:	68 a3 27 80 00       	push   $0x8027a3
  8016fc:	e8 63 ea ff ff       	call   800164 <cprintf>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	eb b9                	jmp    8016bf <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801706:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801709:	0f 94 c0             	sete   %al
  80170c:	0f b6 c0             	movzbl %al,%eax
}
  80170f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801712:	5b                   	pop    %ebx
  801713:	5e                   	pop    %esi
  801714:	5f                   	pop    %edi
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <devpipe_write>:
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	57                   	push   %edi
  80171b:	56                   	push   %esi
  80171c:	53                   	push   %ebx
  80171d:	83 ec 28             	sub    $0x28,%esp
  801720:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801723:	56                   	push   %esi
  801724:	e8 f1 f6 ff ff       	call   800e1a <fd2data>
  801729:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	bf 00 00 00 00       	mov    $0x0,%edi
  801733:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801736:	74 4f                	je     801787 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801738:	8b 43 04             	mov    0x4(%ebx),%eax
  80173b:	8b 0b                	mov    (%ebx),%ecx
  80173d:	8d 51 20             	lea    0x20(%ecx),%edx
  801740:	39 d0                	cmp    %edx,%eax
  801742:	72 14                	jb     801758 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801744:	89 da                	mov    %ebx,%edx
  801746:	89 f0                	mov    %esi,%eax
  801748:	e8 65 ff ff ff       	call   8016b2 <_pipeisclosed>
  80174d:	85 c0                	test   %eax,%eax
  80174f:	75 3a                	jne    80178b <devpipe_write+0x74>
			sys_yield();
  801751:	e8 85 f4 ff ff       	call   800bdb <sys_yield>
  801756:	eb e0                	jmp    801738 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801758:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80175b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80175f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801762:	89 c2                	mov    %eax,%edx
  801764:	c1 fa 1f             	sar    $0x1f,%edx
  801767:	89 d1                	mov    %edx,%ecx
  801769:	c1 e9 1b             	shr    $0x1b,%ecx
  80176c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80176f:	83 e2 1f             	and    $0x1f,%edx
  801772:	29 ca                	sub    %ecx,%edx
  801774:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801778:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80177c:	83 c0 01             	add    $0x1,%eax
  80177f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801782:	83 c7 01             	add    $0x1,%edi
  801785:	eb ac                	jmp    801733 <devpipe_write+0x1c>
	return i;
  801787:	89 f8                	mov    %edi,%eax
  801789:	eb 05                	jmp    801790 <devpipe_write+0x79>
				return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5f                   	pop    %edi
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    

00801798 <devpipe_read>:
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	57                   	push   %edi
  80179c:	56                   	push   %esi
  80179d:	53                   	push   %ebx
  80179e:	83 ec 18             	sub    $0x18,%esp
  8017a1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017a4:	57                   	push   %edi
  8017a5:	e8 70 f6 ff ff       	call   800e1a <fd2data>
  8017aa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	be 00 00 00 00       	mov    $0x0,%esi
  8017b4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017b7:	74 47                	je     801800 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8017b9:	8b 03                	mov    (%ebx),%eax
  8017bb:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017be:	75 22                	jne    8017e2 <devpipe_read+0x4a>
			if (i > 0)
  8017c0:	85 f6                	test   %esi,%esi
  8017c2:	75 14                	jne    8017d8 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8017c4:	89 da                	mov    %ebx,%edx
  8017c6:	89 f8                	mov    %edi,%eax
  8017c8:	e8 e5 fe ff ff       	call   8016b2 <_pipeisclosed>
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	75 33                	jne    801804 <devpipe_read+0x6c>
			sys_yield();
  8017d1:	e8 05 f4 ff ff       	call   800bdb <sys_yield>
  8017d6:	eb e1                	jmp    8017b9 <devpipe_read+0x21>
				return i;
  8017d8:	89 f0                	mov    %esi,%eax
}
  8017da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5f                   	pop    %edi
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017e2:	99                   	cltd   
  8017e3:	c1 ea 1b             	shr    $0x1b,%edx
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	83 e0 1f             	and    $0x1f,%eax
  8017eb:	29 d0                	sub    %edx,%eax
  8017ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017f8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017fb:	83 c6 01             	add    $0x1,%esi
  8017fe:	eb b4                	jmp    8017b4 <devpipe_read+0x1c>
	return i;
  801800:	89 f0                	mov    %esi,%eax
  801802:	eb d6                	jmp    8017da <devpipe_read+0x42>
				return 0;
  801804:	b8 00 00 00 00       	mov    $0x0,%eax
  801809:	eb cf                	jmp    8017da <devpipe_read+0x42>

0080180b <pipe>:
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	56                   	push   %esi
  80180f:	53                   	push   %ebx
  801810:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801813:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801816:	50                   	push   %eax
  801817:	e8 15 f6 ff ff       	call   800e31 <fd_alloc>
  80181c:	89 c3                	mov    %eax,%ebx
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	85 c0                	test   %eax,%eax
  801823:	78 5b                	js     801880 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	68 07 04 00 00       	push   $0x407
  80182d:	ff 75 f4             	pushl  -0xc(%ebp)
  801830:	6a 00                	push   $0x0
  801832:	e8 c3 f3 ff ff       	call   800bfa <sys_page_alloc>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 40                	js     801880 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801840:	83 ec 0c             	sub    $0xc,%esp
  801843:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801846:	50                   	push   %eax
  801847:	e8 e5 f5 ff ff       	call   800e31 <fd_alloc>
  80184c:	89 c3                	mov    %eax,%ebx
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	85 c0                	test   %eax,%eax
  801853:	78 1b                	js     801870 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	68 07 04 00 00       	push   $0x407
  80185d:	ff 75 f0             	pushl  -0x10(%ebp)
  801860:	6a 00                	push   $0x0
  801862:	e8 93 f3 ff ff       	call   800bfa <sys_page_alloc>
  801867:	89 c3                	mov    %eax,%ebx
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	79 19                	jns    801889 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801870:	83 ec 08             	sub    $0x8,%esp
  801873:	ff 75 f4             	pushl  -0xc(%ebp)
  801876:	6a 00                	push   $0x0
  801878:	e8 02 f4 ff ff       	call   800c7f <sys_page_unmap>
  80187d:	83 c4 10             	add    $0x10,%esp
}
  801880:	89 d8                	mov    %ebx,%eax
  801882:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5d                   	pop    %ebp
  801888:	c3                   	ret    
	va = fd2data(fd0);
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	ff 75 f4             	pushl  -0xc(%ebp)
  80188f:	e8 86 f5 ff ff       	call   800e1a <fd2data>
  801894:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801896:	83 c4 0c             	add    $0xc,%esp
  801899:	68 07 04 00 00       	push   $0x407
  80189e:	50                   	push   %eax
  80189f:	6a 00                	push   $0x0
  8018a1:	e8 54 f3 ff ff       	call   800bfa <sys_page_alloc>
  8018a6:	89 c3                	mov    %eax,%ebx
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	0f 88 8c 00 00 00    	js     80193f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018b3:	83 ec 0c             	sub    $0xc,%esp
  8018b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b9:	e8 5c f5 ff ff       	call   800e1a <fd2data>
  8018be:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018c5:	50                   	push   %eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	56                   	push   %esi
  8018c9:	6a 00                	push   $0x0
  8018cb:	e8 6d f3 ff ff       	call   800c3d <sys_page_map>
  8018d0:	89 c3                	mov    %eax,%ebx
  8018d2:	83 c4 20             	add    $0x20,%esp
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	78 58                	js     801931 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018f7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801903:	83 ec 0c             	sub    $0xc,%esp
  801906:	ff 75 f4             	pushl  -0xc(%ebp)
  801909:	e8 fc f4 ff ff       	call   800e0a <fd2num>
  80190e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801911:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801913:	83 c4 04             	add    $0x4,%esp
  801916:	ff 75 f0             	pushl  -0x10(%ebp)
  801919:	e8 ec f4 ff ff       	call   800e0a <fd2num>
  80191e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801921:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	bb 00 00 00 00       	mov    $0x0,%ebx
  80192c:	e9 4f ff ff ff       	jmp    801880 <pipe+0x75>
	sys_page_unmap(0, va);
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	56                   	push   %esi
  801935:	6a 00                	push   $0x0
  801937:	e8 43 f3 ff ff       	call   800c7f <sys_page_unmap>
  80193c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 f0             	pushl  -0x10(%ebp)
  801945:	6a 00                	push   $0x0
  801947:	e8 33 f3 ff ff       	call   800c7f <sys_page_unmap>
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	e9 1c ff ff ff       	jmp    801870 <pipe+0x65>

00801954 <pipeisclosed>:
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80195a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195d:	50                   	push   %eax
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	e8 1a f5 ff ff       	call   800e80 <fd_lookup>
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 18                	js     801985 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	ff 75 f4             	pushl  -0xc(%ebp)
  801973:	e8 a2 f4 ff ff       	call   800e1a <fd2data>
	return _pipeisclosed(fd, p);
  801978:	89 c2                	mov    %eax,%edx
  80197a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197d:	e8 30 fd ff ff       	call   8016b2 <_pipeisclosed>
  801982:	83 c4 10             	add    $0x10,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80198d:	68 bb 27 80 00       	push   $0x8027bb
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	e8 67 ee ff ff       	call   800801 <strcpy>
	return 0;
}
  80199a:	b8 00 00 00 00       	mov    $0x0,%eax
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <devsock_close>:
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 10             	sub    $0x10,%esp
  8019a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019ab:	53                   	push   %ebx
  8019ac:	e8 f9 06 00 00       	call   8020aa <pageref>
  8019b1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019b9:	83 f8 01             	cmp    $0x1,%eax
  8019bc:	74 07                	je     8019c5 <devsock_close+0x24>
}
  8019be:	89 d0                	mov    %edx,%eax
  8019c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019c5:	83 ec 0c             	sub    $0xc,%esp
  8019c8:	ff 73 0c             	pushl  0xc(%ebx)
  8019cb:	e8 b7 02 00 00       	call   801c87 <nsipc_close>
  8019d0:	89 c2                	mov    %eax,%edx
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	eb e7                	jmp    8019be <devsock_close+0x1d>

008019d7 <devsock_write>:
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	ff 75 10             	pushl  0x10(%ebp)
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	ff 70 0c             	pushl  0xc(%eax)
  8019eb:	e8 74 03 00 00       	call   801d64 <nsipc_send>
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <devsock_read>:
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 10             	pushl  0x10(%ebp)
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	ff 70 0c             	pushl  0xc(%eax)
  801a06:	e8 ed 02 00 00       	call   801cf8 <nsipc_recv>
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <fd2sockid>:
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a13:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	e8 63 f4 ff ff       	call   800e80 <fd_lookup>
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 10                	js     801a34 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a27:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a2d:	39 08                	cmp    %ecx,(%eax)
  801a2f:	75 05                	jne    801a36 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a31:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    
		return -E_NOT_SUPP;
  801a36:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a3b:	eb f7                	jmp    801a34 <fd2sockid+0x27>

00801a3d <alloc_sockfd>:
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 1c             	sub    $0x1c,%esp
  801a45:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4a:	50                   	push   %eax
  801a4b:	e8 e1 f3 ff ff       	call   800e31 <fd_alloc>
  801a50:	89 c3                	mov    %eax,%ebx
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 43                	js     801a9c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a59:	83 ec 04             	sub    $0x4,%esp
  801a5c:	68 07 04 00 00       	push   $0x407
  801a61:	ff 75 f4             	pushl  -0xc(%ebp)
  801a64:	6a 00                	push   $0x0
  801a66:	e8 8f f1 ff ff       	call   800bfa <sys_page_alloc>
  801a6b:	89 c3                	mov    %eax,%ebx
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 28                	js     801a9c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a7d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a89:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a8c:	83 ec 0c             	sub    $0xc,%esp
  801a8f:	50                   	push   %eax
  801a90:	e8 75 f3 ff ff       	call   800e0a <fd2num>
  801a95:	89 c3                	mov    %eax,%ebx
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	eb 0c                	jmp    801aa8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a9c:	83 ec 0c             	sub    $0xc,%esp
  801a9f:	56                   	push   %esi
  801aa0:	e8 e2 01 00 00       	call   801c87 <nsipc_close>
		return r;
  801aa5:	83 c4 10             	add    $0x10,%esp
}
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5e                   	pop    %esi
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    

00801ab1 <accept>:
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	e8 4e ff ff ff       	call   801a0d <fd2sockid>
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 1b                	js     801ade <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	ff 75 10             	pushl  0x10(%ebp)
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	50                   	push   %eax
  801acd:	e8 0e 01 00 00       	call   801be0 <nsipc_accept>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 05                	js     801ade <accept+0x2d>
	return alloc_sockfd(r);
  801ad9:	e8 5f ff ff ff       	call   801a3d <alloc_sockfd>
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <bind>:
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	e8 1f ff ff ff       	call   801a0d <fd2sockid>
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 12                	js     801b04 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	ff 75 10             	pushl  0x10(%ebp)
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	50                   	push   %eax
  801afc:	e8 2f 01 00 00       	call   801c30 <nsipc_bind>
  801b01:	83 c4 10             	add    $0x10,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <shutdown>:
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	e8 f9 fe ff ff       	call   801a0d <fd2sockid>
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 0f                	js     801b27 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b18:	83 ec 08             	sub    $0x8,%esp
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	50                   	push   %eax
  801b1f:	e8 41 01 00 00       	call   801c65 <nsipc_shutdown>
  801b24:	83 c4 10             	add    $0x10,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <connect>:
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	e8 d6 fe ff ff       	call   801a0d <fd2sockid>
  801b37:	85 c0                	test   %eax,%eax
  801b39:	78 12                	js     801b4d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	ff 75 10             	pushl  0x10(%ebp)
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	50                   	push   %eax
  801b45:	e8 57 01 00 00       	call   801ca1 <nsipc_connect>
  801b4a:	83 c4 10             	add    $0x10,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <listen>:
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	e8 b0 fe ff ff       	call   801a0d <fd2sockid>
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	78 0f                	js     801b70 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	50                   	push   %eax
  801b68:	e8 69 01 00 00       	call   801cd6 <nsipc_listen>
  801b6d:	83 c4 10             	add    $0x10,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b78:	ff 75 10             	pushl  0x10(%ebp)
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	ff 75 08             	pushl  0x8(%ebp)
  801b81:	e8 3c 02 00 00       	call   801dc2 <nsipc_socket>
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 05                	js     801b92 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b8d:	e8 ab fe ff ff       	call   801a3d <alloc_sockfd>
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	53                   	push   %ebx
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b9d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ba4:	74 26                	je     801bcc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ba6:	6a 07                	push   $0x7
  801ba8:	68 00 60 80 00       	push   $0x806000
  801bad:	53                   	push   %ebx
  801bae:	ff 35 04 40 80 00    	pushl  0x804004
  801bb4:	e8 5f 04 00 00       	call   802018 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bb9:	83 c4 0c             	add    $0xc,%esp
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	e8 e8 03 00 00       	call   801faf <ipc_recv>
}
  801bc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	6a 02                	push   $0x2
  801bd1:	e8 9b 04 00 00       	call   802071 <ipc_find_env>
  801bd6:	a3 04 40 80 00       	mov    %eax,0x804004
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	eb c6                	jmp    801ba6 <nsipc+0x12>

00801be0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	56                   	push   %esi
  801be4:	53                   	push   %ebx
  801be5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bf0:	8b 06                	mov    (%esi),%eax
  801bf2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfc:	e8 93 ff ff ff       	call   801b94 <nsipc>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	85 c0                	test   %eax,%eax
  801c05:	78 20                	js     801c27 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	ff 35 10 60 80 00    	pushl  0x806010
  801c10:	68 00 60 80 00       	push   $0x806000
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	e8 72 ed ff ff       	call   80098f <memmove>
		*addrlen = ret->ret_addrlen;
  801c1d:	a1 10 60 80 00       	mov    0x806010,%eax
  801c22:	89 06                	mov    %eax,(%esi)
  801c24:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c27:	89 d8                	mov    %ebx,%eax
  801c29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c42:	53                   	push   %ebx
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	68 04 60 80 00       	push   $0x806004
  801c4b:	e8 3f ed ff ff       	call   80098f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c50:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c56:	b8 02 00 00 00       	mov    $0x2,%eax
  801c5b:	e8 34 ff ff ff       	call   801b94 <nsipc>
}
  801c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c76:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c7b:	b8 03 00 00 00       	mov    $0x3,%eax
  801c80:	e8 0f ff ff ff       	call   801b94 <nsipc>
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <nsipc_close>:

int
nsipc_close(int s)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c95:	b8 04 00 00 00       	mov    $0x4,%eax
  801c9a:	e8 f5 fe ff ff       	call   801b94 <nsipc>
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 08             	sub    $0x8,%esp
  801ca8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cb3:	53                   	push   %ebx
  801cb4:	ff 75 0c             	pushl  0xc(%ebp)
  801cb7:	68 04 60 80 00       	push   $0x806004
  801cbc:	e8 ce ec ff ff       	call   80098f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cc1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cc7:	b8 05 00 00 00       	mov    $0x5,%eax
  801ccc:	e8 c3 fe ff ff       	call   801b94 <nsipc>
}
  801cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cec:	b8 06 00 00 00       	mov    $0x6,%eax
  801cf1:	e8 9e fe ff ff       	call   801b94 <nsipc>
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	56                   	push   %esi
  801cfc:	53                   	push   %ebx
  801cfd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d08:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d11:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d16:	b8 07 00 00 00       	mov    $0x7,%eax
  801d1b:	e8 74 fe ff ff       	call   801b94 <nsipc>
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 1f                	js     801d45 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d26:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d2b:	7f 21                	jg     801d4e <nsipc_recv+0x56>
  801d2d:	39 c6                	cmp    %eax,%esi
  801d2f:	7c 1d                	jl     801d4e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	50                   	push   %eax
  801d35:	68 00 60 80 00       	push   $0x806000
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	e8 4d ec ff ff       	call   80098f <memmove>
  801d42:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d45:	89 d8                	mov    %ebx,%eax
  801d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4a:	5b                   	pop    %ebx
  801d4b:	5e                   	pop    %esi
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d4e:	68 c7 27 80 00       	push   $0x8027c7
  801d53:	68 69 27 80 00       	push   $0x802769
  801d58:	6a 62                	push   $0x62
  801d5a:	68 dc 27 80 00       	push   $0x8027dc
  801d5f:	e8 05 02 00 00       	call   801f69 <_panic>

00801d64 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	53                   	push   %ebx
  801d68:	83 ec 04             	sub    $0x4,%esp
  801d6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d76:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d7c:	7f 2e                	jg     801dac <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	53                   	push   %ebx
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	68 0c 60 80 00       	push   $0x80600c
  801d8a:	e8 00 ec ff ff       	call   80098f <memmove>
	nsipcbuf.send.req_size = size;
  801d8f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d95:	8b 45 14             	mov    0x14(%ebp),%eax
  801d98:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d9d:	b8 08 00 00 00       	mov    $0x8,%eax
  801da2:	e8 ed fd ff ff       	call   801b94 <nsipc>
}
  801da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    
	assert(size < 1600);
  801dac:	68 e8 27 80 00       	push   $0x8027e8
  801db1:	68 69 27 80 00       	push   $0x802769
  801db6:	6a 6d                	push   $0x6d
  801db8:	68 dc 27 80 00       	push   $0x8027dc
  801dbd:	e8 a7 01 00 00       	call   801f69 <_panic>

00801dc2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd3:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801de0:	b8 09 00 00 00       	mov    $0x9,%eax
  801de5:	e8 aa fd ff ff       	call   801b94 <nsipc>
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	5d                   	pop    %ebp
  801df5:	c3                   	ret    

00801df6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dfc:	68 f4 27 80 00       	push   $0x8027f4
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	e8 f8 e9 ff ff       	call   800801 <strcpy>
	return 0;
}
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <devcons_write>:
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	57                   	push   %edi
  801e14:	56                   	push   %esi
  801e15:	53                   	push   %ebx
  801e16:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e1c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e21:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e27:	eb 2f                	jmp    801e58 <devcons_write+0x48>
		m = n - tot;
  801e29:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e2c:	29 f3                	sub    %esi,%ebx
  801e2e:	83 fb 7f             	cmp    $0x7f,%ebx
  801e31:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e36:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e39:	83 ec 04             	sub    $0x4,%esp
  801e3c:	53                   	push   %ebx
  801e3d:	89 f0                	mov    %esi,%eax
  801e3f:	03 45 0c             	add    0xc(%ebp),%eax
  801e42:	50                   	push   %eax
  801e43:	57                   	push   %edi
  801e44:	e8 46 eb ff ff       	call   80098f <memmove>
		sys_cputs(buf, m);
  801e49:	83 c4 08             	add    $0x8,%esp
  801e4c:	53                   	push   %ebx
  801e4d:	57                   	push   %edi
  801e4e:	e8 eb ec ff ff       	call   800b3e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e53:	01 de                	add    %ebx,%esi
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e5b:	72 cc                	jb     801e29 <devcons_write+0x19>
}
  801e5d:	89 f0                	mov    %esi,%eax
  801e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e62:	5b                   	pop    %ebx
  801e63:	5e                   	pop    %esi
  801e64:	5f                   	pop    %edi
  801e65:	5d                   	pop    %ebp
  801e66:	c3                   	ret    

00801e67 <devcons_read>:
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 08             	sub    $0x8,%esp
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e76:	75 07                	jne    801e7f <devcons_read+0x18>
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    
		sys_yield();
  801e7a:	e8 5c ed ff ff       	call   800bdb <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e7f:	e8 d8 ec ff ff       	call   800b5c <sys_cgetc>
  801e84:	85 c0                	test   %eax,%eax
  801e86:	74 f2                	je     801e7a <devcons_read+0x13>
	if (c < 0)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	78 ec                	js     801e78 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e8c:	83 f8 04             	cmp    $0x4,%eax
  801e8f:	74 0c                	je     801e9d <devcons_read+0x36>
	*(char*)vbuf = c;
  801e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e94:	88 02                	mov    %al,(%edx)
	return 1;
  801e96:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9b:	eb db                	jmp    801e78 <devcons_read+0x11>
		return 0;
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	eb d4                	jmp    801e78 <devcons_read+0x11>

00801ea4 <cputchar>:
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801eb0:	6a 01                	push   $0x1
  801eb2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eb5:	50                   	push   %eax
  801eb6:	e8 83 ec ff ff       	call   800b3e <sys_cputs>
}
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <getchar>:
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ec6:	6a 01                	push   $0x1
  801ec8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ecb:	50                   	push   %eax
  801ecc:	6a 00                	push   $0x0
  801ece:	e8 1e f2 ff ff       	call   8010f1 <read>
	if (r < 0)
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 08                	js     801ee2 <getchar+0x22>
	if (r < 1)
  801eda:	85 c0                	test   %eax,%eax
  801edc:	7e 06                	jle    801ee4 <getchar+0x24>
	return c;
  801ede:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    
		return -E_EOF;
  801ee4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ee9:	eb f7                	jmp    801ee2 <getchar+0x22>

00801eeb <iscons>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ef1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef4:	50                   	push   %eax
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	e8 83 ef ff ff       	call   800e80 <fd_lookup>
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	78 11                	js     801f15 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f0d:	39 10                	cmp    %edx,(%eax)
  801f0f:	0f 94 c0             	sete   %al
  801f12:	0f b6 c0             	movzbl %al,%eax
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <opencons>:
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f20:	50                   	push   %eax
  801f21:	e8 0b ef ff ff       	call   800e31 <fd_alloc>
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 3a                	js     801f67 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	68 07 04 00 00       	push   $0x407
  801f35:	ff 75 f4             	pushl  -0xc(%ebp)
  801f38:	6a 00                	push   $0x0
  801f3a:	e8 bb ec ff ff       	call   800bfa <sys_page_alloc>
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	78 21                	js     801f67 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f4f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	50                   	push   %eax
  801f5f:	e8 a6 ee ff ff       	call   800e0a <fd2num>
  801f64:	83 c4 10             	add    $0x10,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	56                   	push   %esi
  801f6d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f6e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f71:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f77:	e8 40 ec ff ff       	call   800bbc <sys_getenvid>
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	ff 75 0c             	pushl  0xc(%ebp)
  801f82:	ff 75 08             	pushl  0x8(%ebp)
  801f85:	56                   	push   %esi
  801f86:	50                   	push   %eax
  801f87:	68 00 28 80 00       	push   $0x802800
  801f8c:	e8 d3 e1 ff ff       	call   800164 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f91:	83 c4 18             	add    $0x18,%esp
  801f94:	53                   	push   %ebx
  801f95:	ff 75 10             	pushl  0x10(%ebp)
  801f98:	e8 76 e1 ff ff       	call   800113 <vcprintf>
	cprintf("\n");
  801f9d:	c7 04 24 b4 27 80 00 	movl   $0x8027b4,(%esp)
  801fa4:	e8 bb e1 ff ff       	call   800164 <cprintf>
  801fa9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fac:	cc                   	int3   
  801fad:	eb fd                	jmp    801fac <_panic+0x43>

00801faf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	8b 75 08             	mov    0x8(%ebp),%esi
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801fbd:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801fbf:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fc4:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	50                   	push   %eax
  801fcb:	e8 da ed ff ff       	call   800daa <sys_ipc_recv>
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 2b                	js     802002 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fd7:	85 f6                	test   %esi,%esi
  801fd9:	74 0a                	je     801fe5 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fdb:	a1 08 40 80 00       	mov    0x804008,%eax
  801fe0:	8b 40 74             	mov    0x74(%eax),%eax
  801fe3:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fe5:	85 db                	test   %ebx,%ebx
  801fe7:	74 0a                	je     801ff3 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fe9:	a1 08 40 80 00       	mov    0x804008,%eax
  801fee:	8b 40 78             	mov    0x78(%eax),%eax
  801ff1:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801ff3:	a1 08 40 80 00       	mov    0x804008,%eax
  801ff8:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ffb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ffe:	5b                   	pop    %ebx
  801fff:	5e                   	pop    %esi
  802000:	5d                   	pop    %ebp
  802001:	c3                   	ret    
	    if (from_env_store != NULL) {
  802002:	85 f6                	test   %esi,%esi
  802004:	74 06                	je     80200c <ipc_recv+0x5d>
	        *from_env_store = 0;
  802006:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80200c:	85 db                	test   %ebx,%ebx
  80200e:	74 eb                	je     801ffb <ipc_recv+0x4c>
	        *perm_store = 0;
  802010:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802016:	eb e3                	jmp    801ffb <ipc_recv+0x4c>

00802018 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	57                   	push   %edi
  80201c:	56                   	push   %esi
  80201d:	53                   	push   %ebx
  80201e:	83 ec 0c             	sub    $0xc,%esp
  802021:	8b 7d 08             	mov    0x8(%ebp),%edi
  802024:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802027:	85 f6                	test   %esi,%esi
  802029:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80202e:	0f 44 f0             	cmove  %eax,%esi
  802031:	eb 09                	jmp    80203c <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802033:	e8 a3 eb ff ff       	call   800bdb <sys_yield>
	} while(r != 0);
  802038:	85 db                	test   %ebx,%ebx
  80203a:	74 2d                	je     802069 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80203c:	ff 75 14             	pushl  0x14(%ebp)
  80203f:	56                   	push   %esi
  802040:	ff 75 0c             	pushl  0xc(%ebp)
  802043:	57                   	push   %edi
  802044:	e8 3e ed ff ff       	call   800d87 <sys_ipc_try_send>
  802049:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	85 c0                	test   %eax,%eax
  802050:	79 e1                	jns    802033 <ipc_send+0x1b>
  802052:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802055:	74 dc                	je     802033 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802057:	50                   	push   %eax
  802058:	68 24 28 80 00       	push   $0x802824
  80205d:	6a 45                	push   $0x45
  80205f:	68 31 28 80 00       	push   $0x802831
  802064:	e8 00 ff ff ff       	call   801f69 <_panic>
}
  802069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80206c:	5b                   	pop    %ebx
  80206d:	5e                   	pop    %esi
  80206e:	5f                   	pop    %edi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80207c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80207f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802085:	8b 52 50             	mov    0x50(%edx),%edx
  802088:	39 ca                	cmp    %ecx,%edx
  80208a:	74 11                	je     80209d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80208c:	83 c0 01             	add    $0x1,%eax
  80208f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802094:	75 e6                	jne    80207c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
  80209b:	eb 0b                	jmp    8020a8 <ipc_find_env+0x37>
			return envs[i].env_id;
  80209d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020a0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020a5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020b0:	89 d0                	mov    %edx,%eax
  8020b2:	c1 e8 16             	shr    $0x16,%eax
  8020b5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020bc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020c1:	f6 c1 01             	test   $0x1,%cl
  8020c4:	74 1d                	je     8020e3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020c6:	c1 ea 0c             	shr    $0xc,%edx
  8020c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020d0:	f6 c2 01             	test   $0x1,%dl
  8020d3:	74 0e                	je     8020e3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020d5:	c1 ea 0c             	shr    $0xc,%edx
  8020d8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020df:	ef 
  8020e0:	0f b7 c0             	movzwl %ax,%eax
}
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
  8020e5:	66 90                	xchg   %ax,%ax
  8020e7:	66 90                	xchg   %ax,%ax
  8020e9:	66 90                	xchg   %ax,%ax
  8020eb:	66 90                	xchg   %ax,%ax
  8020ed:	66 90                	xchg   %ax,%ax
  8020ef:	90                   	nop

008020f0 <__udivdi3>:
  8020f0:	55                   	push   %ebp
  8020f1:	57                   	push   %edi
  8020f2:	56                   	push   %esi
  8020f3:	53                   	push   %ebx
  8020f4:	83 ec 1c             	sub    $0x1c,%esp
  8020f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802103:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802107:	85 d2                	test   %edx,%edx
  802109:	75 35                	jne    802140 <__udivdi3+0x50>
  80210b:	39 f3                	cmp    %esi,%ebx
  80210d:	0f 87 bd 00 00 00    	ja     8021d0 <__udivdi3+0xe0>
  802113:	85 db                	test   %ebx,%ebx
  802115:	89 d9                	mov    %ebx,%ecx
  802117:	75 0b                	jne    802124 <__udivdi3+0x34>
  802119:	b8 01 00 00 00       	mov    $0x1,%eax
  80211e:	31 d2                	xor    %edx,%edx
  802120:	f7 f3                	div    %ebx
  802122:	89 c1                	mov    %eax,%ecx
  802124:	31 d2                	xor    %edx,%edx
  802126:	89 f0                	mov    %esi,%eax
  802128:	f7 f1                	div    %ecx
  80212a:	89 c6                	mov    %eax,%esi
  80212c:	89 e8                	mov    %ebp,%eax
  80212e:	89 f7                	mov    %esi,%edi
  802130:	f7 f1                	div    %ecx
  802132:	89 fa                	mov    %edi,%edx
  802134:	83 c4 1c             	add    $0x1c,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    
  80213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802140:	39 f2                	cmp    %esi,%edx
  802142:	77 7c                	ja     8021c0 <__udivdi3+0xd0>
  802144:	0f bd fa             	bsr    %edx,%edi
  802147:	83 f7 1f             	xor    $0x1f,%edi
  80214a:	0f 84 98 00 00 00    	je     8021e8 <__udivdi3+0xf8>
  802150:	89 f9                	mov    %edi,%ecx
  802152:	b8 20 00 00 00       	mov    $0x20,%eax
  802157:	29 f8                	sub    %edi,%eax
  802159:	d3 e2                	shl    %cl,%edx
  80215b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 da                	mov    %ebx,%edx
  802163:	d3 ea                	shr    %cl,%edx
  802165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802169:	09 d1                	or     %edx,%ecx
  80216b:	89 f2                	mov    %esi,%edx
  80216d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802171:	89 f9                	mov    %edi,%ecx
  802173:	d3 e3                	shl    %cl,%ebx
  802175:	89 c1                	mov    %eax,%ecx
  802177:	d3 ea                	shr    %cl,%edx
  802179:	89 f9                	mov    %edi,%ecx
  80217b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80217f:	d3 e6                	shl    %cl,%esi
  802181:	89 eb                	mov    %ebp,%ebx
  802183:	89 c1                	mov    %eax,%ecx
  802185:	d3 eb                	shr    %cl,%ebx
  802187:	09 de                	or     %ebx,%esi
  802189:	89 f0                	mov    %esi,%eax
  80218b:	f7 74 24 08          	divl   0x8(%esp)
  80218f:	89 d6                	mov    %edx,%esi
  802191:	89 c3                	mov    %eax,%ebx
  802193:	f7 64 24 0c          	mull   0xc(%esp)
  802197:	39 d6                	cmp    %edx,%esi
  802199:	72 0c                	jb     8021a7 <__udivdi3+0xb7>
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	39 c5                	cmp    %eax,%ebp
  8021a1:	73 5d                	jae    802200 <__udivdi3+0x110>
  8021a3:	39 d6                	cmp    %edx,%esi
  8021a5:	75 59                	jne    802200 <__udivdi3+0x110>
  8021a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021aa:	31 ff                	xor    %edi,%edi
  8021ac:	89 fa                	mov    %edi,%edx
  8021ae:	83 c4 1c             	add    $0x1c,%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5f                   	pop    %edi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    
  8021b6:	8d 76 00             	lea    0x0(%esi),%esi
  8021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021c0:	31 ff                	xor    %edi,%edi
  8021c2:	31 c0                	xor    %eax,%eax
  8021c4:	89 fa                	mov    %edi,%edx
  8021c6:	83 c4 1c             	add    $0x1c,%esp
  8021c9:	5b                   	pop    %ebx
  8021ca:	5e                   	pop    %esi
  8021cb:	5f                   	pop    %edi
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    
  8021ce:	66 90                	xchg   %ax,%ax
  8021d0:	31 ff                	xor    %edi,%edi
  8021d2:	89 e8                	mov    %ebp,%eax
  8021d4:	89 f2                	mov    %esi,%edx
  8021d6:	f7 f3                	div    %ebx
  8021d8:	89 fa                	mov    %edi,%edx
  8021da:	83 c4 1c             	add    $0x1c,%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5e                   	pop    %esi
  8021df:	5f                   	pop    %edi
  8021e0:	5d                   	pop    %ebp
  8021e1:	c3                   	ret    
  8021e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	72 06                	jb     8021f2 <__udivdi3+0x102>
  8021ec:	31 c0                	xor    %eax,%eax
  8021ee:	39 eb                	cmp    %ebp,%ebx
  8021f0:	77 d2                	ja     8021c4 <__udivdi3+0xd4>
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb cb                	jmp    8021c4 <__udivdi3+0xd4>
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 d8                	mov    %ebx,%eax
  802202:	31 ff                	xor    %edi,%edi
  802204:	eb be                	jmp    8021c4 <__udivdi3+0xd4>
  802206:	66 90                	xchg   %ax,%ax
  802208:	66 90                	xchg   %ax,%ax
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	66 90                	xchg   %ax,%ax
  80220e:	66 90                	xchg   %ax,%ax

00802210 <__umoddi3>:
  802210:	55                   	push   %ebp
  802211:	57                   	push   %edi
  802212:	56                   	push   %esi
  802213:	53                   	push   %ebx
  802214:	83 ec 1c             	sub    $0x1c,%esp
  802217:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80221b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80221f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802223:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802227:	85 ed                	test   %ebp,%ebp
  802229:	89 f0                	mov    %esi,%eax
  80222b:	89 da                	mov    %ebx,%edx
  80222d:	75 19                	jne    802248 <__umoddi3+0x38>
  80222f:	39 df                	cmp    %ebx,%edi
  802231:	0f 86 b1 00 00 00    	jbe    8022e8 <__umoddi3+0xd8>
  802237:	f7 f7                	div    %edi
  802239:	89 d0                	mov    %edx,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	39 dd                	cmp    %ebx,%ebp
  80224a:	77 f1                	ja     80223d <__umoddi3+0x2d>
  80224c:	0f bd cd             	bsr    %ebp,%ecx
  80224f:	83 f1 1f             	xor    $0x1f,%ecx
  802252:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802256:	0f 84 b4 00 00 00    	je     802310 <__umoddi3+0x100>
  80225c:	b8 20 00 00 00       	mov    $0x20,%eax
  802261:	89 c2                	mov    %eax,%edx
  802263:	8b 44 24 04          	mov    0x4(%esp),%eax
  802267:	29 c2                	sub    %eax,%edx
  802269:	89 c1                	mov    %eax,%ecx
  80226b:	89 f8                	mov    %edi,%eax
  80226d:	d3 e5                	shl    %cl,%ebp
  80226f:	89 d1                	mov    %edx,%ecx
  802271:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802275:	d3 e8                	shr    %cl,%eax
  802277:	09 c5                	or     %eax,%ebp
  802279:	8b 44 24 04          	mov    0x4(%esp),%eax
  80227d:	89 c1                	mov    %eax,%ecx
  80227f:	d3 e7                	shl    %cl,%edi
  802281:	89 d1                	mov    %edx,%ecx
  802283:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802287:	89 df                	mov    %ebx,%edi
  802289:	d3 ef                	shr    %cl,%edi
  80228b:	89 c1                	mov    %eax,%ecx
  80228d:	89 f0                	mov    %esi,%eax
  80228f:	d3 e3                	shl    %cl,%ebx
  802291:	89 d1                	mov    %edx,%ecx
  802293:	89 fa                	mov    %edi,%edx
  802295:	d3 e8                	shr    %cl,%eax
  802297:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80229c:	09 d8                	or     %ebx,%eax
  80229e:	f7 f5                	div    %ebp
  8022a0:	d3 e6                	shl    %cl,%esi
  8022a2:	89 d1                	mov    %edx,%ecx
  8022a4:	f7 64 24 08          	mull   0x8(%esp)
  8022a8:	39 d1                	cmp    %edx,%ecx
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	89 d7                	mov    %edx,%edi
  8022ae:	72 06                	jb     8022b6 <__umoddi3+0xa6>
  8022b0:	75 0e                	jne    8022c0 <__umoddi3+0xb0>
  8022b2:	39 c6                	cmp    %eax,%esi
  8022b4:	73 0a                	jae    8022c0 <__umoddi3+0xb0>
  8022b6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022ba:	19 ea                	sbb    %ebp,%edx
  8022bc:	89 d7                	mov    %edx,%edi
  8022be:	89 c3                	mov    %eax,%ebx
  8022c0:	89 ca                	mov    %ecx,%edx
  8022c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022c7:	29 de                	sub    %ebx,%esi
  8022c9:	19 fa                	sbb    %edi,%edx
  8022cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022cf:	89 d0                	mov    %edx,%eax
  8022d1:	d3 e0                	shl    %cl,%eax
  8022d3:	89 d9                	mov    %ebx,%ecx
  8022d5:	d3 ee                	shr    %cl,%esi
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	09 f0                	or     %esi,%eax
  8022db:	83 c4 1c             	add    $0x1c,%esp
  8022de:	5b                   	pop    %ebx
  8022df:	5e                   	pop    %esi
  8022e0:	5f                   	pop    %edi
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    
  8022e3:	90                   	nop
  8022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	85 ff                	test   %edi,%edi
  8022ea:	89 f9                	mov    %edi,%ecx
  8022ec:	75 0b                	jne    8022f9 <__umoddi3+0xe9>
  8022ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	f7 f7                	div    %edi
  8022f7:	89 c1                	mov    %eax,%ecx
  8022f9:	89 d8                	mov    %ebx,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	f7 f1                	div    %ecx
  8022ff:	89 f0                	mov    %esi,%eax
  802301:	f7 f1                	div    %ecx
  802303:	e9 31 ff ff ff       	jmp    802239 <__umoddi3+0x29>
  802308:	90                   	nop
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	39 dd                	cmp    %ebx,%ebp
  802312:	72 08                	jb     80231c <__umoddi3+0x10c>
  802314:	39 f7                	cmp    %esi,%edi
  802316:	0f 87 21 ff ff ff    	ja     80223d <__umoddi3+0x2d>
  80231c:	89 da                	mov    %ebx,%edx
  80231e:	89 f0                	mov    %esi,%eax
  802320:	29 f8                	sub    %edi,%eax
  802322:	19 ea                	sbb    %ebp,%edx
  802324:	e9 14 ff ff ff       	jmp    80223d <__umoddi3+0x2d>
