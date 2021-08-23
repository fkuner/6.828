
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 ee 0b 00 00       	call   800c30 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 80 27 80 00       	push   $0x802780
  80004c:	e8 87 01 00 00       	call   8001d8 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 bb 07 00 00       	call   80083e <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 91 27 80 00       	push   $0x802791
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 78 07 00 00       	call   800824 <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 b4 0e 00 00       	call   800f68 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 60 00 00 00       	call   800129 <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 90 27 80 00       	push   $0x802790
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 3d 0b 00 00       	call   800c30 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x2d>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800110:	83 ec 08             	sub    $0x8,%esp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	e8 b4 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011a:	e8 0a 00 00 00       	call   800129 <exit>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012f:	e8 4c 12 00 00       	call   801380 <close_all>
	sys_env_destroy(0);
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	6a 00                	push   $0x0
  800139:	e8 b1 0a 00 00       	call   800bef <sys_env_destroy>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	53                   	push   %ebx
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014d:	8b 13                	mov    (%ebx),%edx
  80014f:	8d 42 01             	lea    0x1(%edx),%eax
  800152:	89 03                	mov    %eax,(%ebx)
  800154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800157:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800160:	74 09                	je     80016b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800162:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800169:	c9                   	leave  
  80016a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	68 ff 00 00 00       	push   $0xff
  800173:	8d 43 08             	lea    0x8(%ebx),%eax
  800176:	50                   	push   %eax
  800177:	e8 36 0a 00 00       	call   800bb2 <sys_cputs>
		b->idx = 0;
  80017c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	eb db                	jmp    800162 <putch+0x1f>

00800187 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800190:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800197:	00 00 00 
	b.cnt = 0;
  80019a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	68 43 01 80 00       	push   $0x800143
  8001b6:	e8 1a 01 00 00       	call   8002d5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bb:	83 c4 08             	add    $0x8,%esp
  8001be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 e2 09 00 00       	call   800bb2 <sys_cputs>

	return b.cnt;
}
  8001d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e1:	50                   	push   %eax
  8001e2:	ff 75 08             	pushl  0x8(%ebp)
  8001e5:	e8 9d ff ff ff       	call   800187 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 1c             	sub    $0x1c,%esp
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	89 d6                	mov    %edx,%esi
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800202:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800208:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800210:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800213:	39 d3                	cmp    %edx,%ebx
  800215:	72 05                	jb     80021c <printnum+0x30>
  800217:	39 45 10             	cmp    %eax,0x10(%ebp)
  80021a:	77 7a                	ja     800296 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	ff 75 18             	pushl  0x18(%ebp)
  800222:	8b 45 14             	mov    0x14(%ebp),%eax
  800225:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800228:	53                   	push   %ebx
  800229:	ff 75 10             	pushl  0x10(%ebp)
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800232:	ff 75 e0             	pushl  -0x20(%ebp)
  800235:	ff 75 dc             	pushl  -0x24(%ebp)
  800238:	ff 75 d8             	pushl  -0x28(%ebp)
  80023b:	e8 f0 22 00 00       	call   802530 <__udivdi3>
  800240:	83 c4 18             	add    $0x18,%esp
  800243:	52                   	push   %edx
  800244:	50                   	push   %eax
  800245:	89 f2                	mov    %esi,%edx
  800247:	89 f8                	mov    %edi,%eax
  800249:	e8 9e ff ff ff       	call   8001ec <printnum>
  80024e:	83 c4 20             	add    $0x20,%esp
  800251:	eb 13                	jmp    800266 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	ff 75 18             	pushl  0x18(%ebp)
  80025a:	ff d7                	call   *%edi
  80025c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80025f:	83 eb 01             	sub    $0x1,%ebx
  800262:	85 db                	test   %ebx,%ebx
  800264:	7f ed                	jg     800253 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	56                   	push   %esi
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800270:	ff 75 e0             	pushl  -0x20(%ebp)
  800273:	ff 75 dc             	pushl  -0x24(%ebp)
  800276:	ff 75 d8             	pushl  -0x28(%ebp)
  800279:	e8 d2 23 00 00       	call   802650 <__umoddi3>
  80027e:	83 c4 14             	add    $0x14,%esp
  800281:	0f be 80 a0 27 80 00 	movsbl 0x8027a0(%eax),%eax
  800288:	50                   	push   %eax
  800289:	ff d7                	call   *%edi
}
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    
  800296:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800299:	eb c4                	jmp    80025f <printnum+0x73>

0080029b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a5:	8b 10                	mov    (%eax),%edx
  8002a7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002aa:	73 0a                	jae    8002b6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002af:	89 08                	mov    %ecx,(%eax)
  8002b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b4:	88 02                	mov    %al,(%edx)
}
  8002b6:	5d                   	pop    %ebp
  8002b7:	c3                   	ret    

008002b8 <printfmt>:
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002be:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c1:	50                   	push   %eax
  8002c2:	ff 75 10             	pushl  0x10(%ebp)
  8002c5:	ff 75 0c             	pushl  0xc(%ebp)
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	e8 05 00 00 00       	call   8002d5 <vprintfmt>
}
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <vprintfmt>:
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 2c             	sub    $0x2c,%esp
  8002de:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e7:	e9 21 04 00 00       	jmp    80070d <vprintfmt+0x438>
		padc = ' ';
  8002ec:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002f0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002f7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800305:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8d 47 01             	lea    0x1(%edi),%eax
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800310:	0f b6 17             	movzbl (%edi),%edx
  800313:	8d 42 dd             	lea    -0x23(%edx),%eax
  800316:	3c 55                	cmp    $0x55,%al
  800318:	0f 87 90 04 00 00    	ja     8007ae <vprintfmt+0x4d9>
  80031e:	0f b6 c0             	movzbl %al,%eax
  800321:	ff 24 85 e0 28 80 00 	jmp    *0x8028e0(,%eax,4)
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80032f:	eb d9                	jmp    80030a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800334:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800338:	eb d0                	jmp    80030a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	0f b6 d2             	movzbl %dl,%edx
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800348:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800352:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800355:	83 f9 09             	cmp    $0x9,%ecx
  800358:	77 55                	ja     8003af <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80035a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035d:	eb e9                	jmp    800348 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8d 40 04             	lea    0x4(%eax),%eax
  80036d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800373:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800377:	79 91                	jns    80030a <vprintfmt+0x35>
				width = precision, precision = -1;
  800379:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800386:	eb 82                	jmp    80030a <vprintfmt+0x35>
  800388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038b:	85 c0                	test   %eax,%eax
  80038d:	ba 00 00 00 00       	mov    $0x0,%edx
  800392:	0f 49 d0             	cmovns %eax,%edx
  800395:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039b:	e9 6a ff ff ff       	jmp    80030a <vprintfmt+0x35>
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003aa:	e9 5b ff ff ff       	jmp    80030a <vprintfmt+0x35>
  8003af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b5:	eb bc                	jmp    800373 <vprintfmt+0x9e>
			lflag++;
  8003b7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bd:	e9 48 ff ff ff       	jmp    80030a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8d 78 04             	lea    0x4(%eax),%edi
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	53                   	push   %ebx
  8003cc:	ff 30                	pushl  (%eax)
  8003ce:	ff d6                	call   *%esi
			break;
  8003d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d6:	e9 2f 03 00 00       	jmp    80070a <vprintfmt+0x435>
			err = va_arg(ap, int);
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 78 04             	lea    0x4(%eax),%edi
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	99                   	cltd   
  8003e4:	31 d0                	xor    %edx,%eax
  8003e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e8:	83 f8 0f             	cmp    $0xf,%eax
  8003eb:	7f 23                	jg     800410 <vprintfmt+0x13b>
  8003ed:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 18                	je     800410 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003f8:	52                   	push   %edx
  8003f9:	68 03 2c 80 00       	push   $0x802c03
  8003fe:	53                   	push   %ebx
  8003ff:	56                   	push   %esi
  800400:	e8 b3 fe ff ff       	call   8002b8 <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040b:	e9 fa 02 00 00       	jmp    80070a <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800410:	50                   	push   %eax
  800411:	68 b8 27 80 00       	push   $0x8027b8
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 9b fe ff ff       	call   8002b8 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800423:	e9 e2 02 00 00       	jmp    80070a <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800428:	8b 45 14             	mov    0x14(%ebp),%eax
  80042b:	83 c0 04             	add    $0x4,%eax
  80042e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800436:	85 ff                	test   %edi,%edi
  800438:	b8 b1 27 80 00       	mov    $0x8027b1,%eax
  80043d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800440:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800444:	0f 8e bd 00 00 00    	jle    800507 <vprintfmt+0x232>
  80044a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80044e:	75 0e                	jne    80045e <vprintfmt+0x189>
  800450:	89 75 08             	mov    %esi,0x8(%ebp)
  800453:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800456:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800459:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80045c:	eb 6d                	jmp    8004cb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	ff 75 d0             	pushl  -0x30(%ebp)
  800464:	57                   	push   %edi
  800465:	e8 ec 03 00 00       	call   800856 <strnlen>
  80046a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046d:	29 c1                	sub    %eax,%ecx
  80046f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800472:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800475:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800479:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80047f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800481:	eb 0f                	jmp    800492 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	ff 75 e0             	pushl  -0x20(%ebp)
  80048a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ef 01             	sub    $0x1,%edi
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	85 ff                	test   %edi,%edi
  800494:	7f ed                	jg     800483 <vprintfmt+0x1ae>
  800496:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800499:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80049c:	85 c9                	test   %ecx,%ecx
  80049e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a3:	0f 49 c1             	cmovns %ecx,%eax
  8004a6:	29 c1                	sub    %eax,%ecx
  8004a8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ab:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ae:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b1:	89 cb                	mov    %ecx,%ebx
  8004b3:	eb 16                	jmp    8004cb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b9:	75 31                	jne    8004ec <vprintfmt+0x217>
					putch(ch, putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	50                   	push   %eax
  8004c2:	ff 55 08             	call   *0x8(%ebp)
  8004c5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c8:	83 eb 01             	sub    $0x1,%ebx
  8004cb:	83 c7 01             	add    $0x1,%edi
  8004ce:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004d2:	0f be c2             	movsbl %dl,%eax
  8004d5:	85 c0                	test   %eax,%eax
  8004d7:	74 59                	je     800532 <vprintfmt+0x25d>
  8004d9:	85 f6                	test   %esi,%esi
  8004db:	78 d8                	js     8004b5 <vprintfmt+0x1e0>
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	79 d3                	jns    8004b5 <vprintfmt+0x1e0>
  8004e2:	89 df                	mov    %ebx,%edi
  8004e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ea:	eb 37                	jmp    800523 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ec:	0f be d2             	movsbl %dl,%edx
  8004ef:	83 ea 20             	sub    $0x20,%edx
  8004f2:	83 fa 5e             	cmp    $0x5e,%edx
  8004f5:	76 c4                	jbe    8004bb <vprintfmt+0x1e6>
					putch('?', putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	ff 75 0c             	pushl  0xc(%ebp)
  8004fd:	6a 3f                	push   $0x3f
  8004ff:	ff 55 08             	call   *0x8(%ebp)
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	eb c1                	jmp    8004c8 <vprintfmt+0x1f3>
  800507:	89 75 08             	mov    %esi,0x8(%ebp)
  80050a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800510:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800513:	eb b6                	jmp    8004cb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 20                	push   $0x20
  80051b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051d:	83 ef 01             	sub    $0x1,%edi
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	85 ff                	test   %edi,%edi
  800525:	7f ee                	jg     800515 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	e9 d8 01 00 00       	jmp    80070a <vprintfmt+0x435>
  800532:	89 df                	mov    %ebx,%edi
  800534:	8b 75 08             	mov    0x8(%ebp),%esi
  800537:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053a:	eb e7                	jmp    800523 <vprintfmt+0x24e>
	if (lflag >= 2)
  80053c:	83 f9 01             	cmp    $0x1,%ecx
  80053f:	7e 45                	jle    800586 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 50 04             	mov    0x4(%eax),%edx
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 08             	lea    0x8(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800558:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80055c:	79 62                	jns    8005c0 <vprintfmt+0x2eb>
				putch('-', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	6a 2d                	push   $0x2d
  800564:	ff d6                	call   *%esi
				num = -(long long) num;
  800566:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800569:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80056c:	f7 d8                	neg    %eax
  80056e:	83 d2 00             	adc    $0x0,%edx
  800571:	f7 da                	neg    %edx
  800573:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800576:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800579:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057c:	ba 0a 00 00 00       	mov    $0xa,%edx
  800581:	e9 66 01 00 00       	jmp    8006ec <vprintfmt+0x417>
	else if (lflag)
  800586:	85 c9                	test   %ecx,%ecx
  800588:	75 1b                	jne    8005a5 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800592:	89 c1                	mov    %eax,%ecx
  800594:	c1 f9 1f             	sar    $0x1f,%ecx
  800597:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 40 04             	lea    0x4(%eax),%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a3:	eb b3                	jmp    800558 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ad:	89 c1                	mov    %eax,%ecx
  8005af:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005be:	eb 98                	jmp    800558 <vprintfmt+0x283>
			base = 10;
  8005c0:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005c5:	e9 22 01 00 00       	jmp    8006ec <vprintfmt+0x417>
	if (lflag >= 2)
  8005ca:	83 f9 01             	cmp    $0x1,%ecx
  8005cd:	7e 21                	jle    8005f0 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 50 04             	mov    0x4(%eax),%edx
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 08             	lea    0x8(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e6:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005eb:	e9 fc 00 00 00       	jmp    8006ec <vprintfmt+0x417>
	else if (lflag)
  8005f0:	85 c9                	test   %ecx,%ecx
  8005f2:	75 23                	jne    800617 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800612:	e9 d5 00 00 00       	jmp    8006ec <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	ba 00 00 00 00       	mov    $0x0,%edx
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 40 04             	lea    0x4(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	ba 0a 00 00 00       	mov    $0xa,%edx
  800635:	e9 b2 00 00 00       	jmp    8006ec <vprintfmt+0x417>
	if (lflag >= 2)
  80063a:	83 f9 01             	cmp    $0x1,%ecx
  80063d:	7e 42                	jle    800681 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 50 04             	mov    0x4(%eax),%edx
  800645:	8b 00                	mov    (%eax),%eax
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 08             	lea    0x8(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800656:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  80065b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80065f:	0f 89 87 00 00 00    	jns    8006ec <vprintfmt+0x417>
				putch('-', putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	53                   	push   %ebx
  800669:	6a 2d                	push   $0x2d
  80066b:	ff d6                	call   *%esi
				num = -(long long) num;
  80066d:	f7 5d d8             	negl   -0x28(%ebp)
  800670:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800674:	f7 5d dc             	negl   -0x24(%ebp)
  800677:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80067a:	ba 08 00 00 00       	mov    $0x8,%edx
  80067f:	eb 6b                	jmp    8006ec <vprintfmt+0x417>
	else if (lflag)
  800681:	85 c9                	test   %ecx,%ecx
  800683:	75 1b                	jne    8006a0 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	ba 00 00 00 00       	mov    $0x0,%edx
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	eb b6                	jmp    800656 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b9:	eb 9b                	jmp    800656 <vprintfmt+0x381>
			putch('0', putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 30                	push   $0x30
  8006c1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c3:	83 c4 08             	add    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	6a 78                	push   $0x78
  8006c9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006db:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e7:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f7:	52                   	push   %edx
  8006f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	89 da                	mov    %ebx,%edx
  800700:	89 f0                	mov    %esi,%eax
  800702:	e8 e5 fa ff ff       	call   8001ec <printnum>
			break;
  800707:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80070a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	83 c7 01             	add    $0x1,%edi
  800710:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800714:	83 f8 25             	cmp    $0x25,%eax
  800717:	0f 84 cf fb ff ff    	je     8002ec <vprintfmt+0x17>
			if (ch == '\0')
  80071d:	85 c0                	test   %eax,%eax
  80071f:	0f 84 a9 00 00 00    	je     8007ce <vprintfmt+0x4f9>
			putch(ch, putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	50                   	push   %eax
  80072a:	ff d6                	call   *%esi
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	eb dc                	jmp    80070d <vprintfmt+0x438>
	if (lflag >= 2)
  800731:	83 f9 01             	cmp    $0x1,%ecx
  800734:	7e 1e                	jle    800754 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 50 04             	mov    0x4(%eax),%edx
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800741:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8d 40 08             	lea    0x8(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074d:	ba 10 00 00 00       	mov    $0x10,%edx
  800752:	eb 98                	jmp    8006ec <vprintfmt+0x417>
	else if (lflag)
  800754:	85 c9                	test   %ecx,%ecx
  800756:	75 23                	jne    80077b <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800771:	ba 10 00 00 00       	mov    $0x10,%edx
  800776:	e9 71 ff ff ff       	jmp    8006ec <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800794:	ba 10 00 00 00       	mov    $0x10,%edx
  800799:	e9 4e ff ff ff       	jmp    8006ec <vprintfmt+0x417>
			putch(ch, putdat);
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	53                   	push   %ebx
  8007a2:	6a 25                	push   $0x25
  8007a4:	ff d6                	call   *%esi
			break;
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	e9 5c ff ff ff       	jmp    80070a <vprintfmt+0x435>
			putch('%', putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	53                   	push   %ebx
  8007b2:	6a 25                	push   $0x25
  8007b4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 f8                	mov    %edi,%eax
  8007bb:	eb 03                	jmp    8007c0 <vprintfmt+0x4eb>
  8007bd:	83 e8 01             	sub    $0x1,%eax
  8007c0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c4:	75 f7                	jne    8007bd <vprintfmt+0x4e8>
  8007c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c9:	e9 3c ff ff ff       	jmp    80070a <vprintfmt+0x435>
}
  8007ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d1:	5b                   	pop    %ebx
  8007d2:	5e                   	pop    %esi
  8007d3:	5f                   	pop    %edi
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	83 ec 18             	sub    $0x18,%esp
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f3:	85 c0                	test   %eax,%eax
  8007f5:	74 26                	je     80081d <vsnprintf+0x47>
  8007f7:	85 d2                	test   %edx,%edx
  8007f9:	7e 22                	jle    80081d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007fb:	ff 75 14             	pushl  0x14(%ebp)
  8007fe:	ff 75 10             	pushl  0x10(%ebp)
  800801:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800804:	50                   	push   %eax
  800805:	68 9b 02 80 00       	push   $0x80029b
  80080a:	e8 c6 fa ff ff       	call   8002d5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80080f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800812:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800818:	83 c4 10             	add    $0x10,%esp
}
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    
		return -E_INVAL;
  80081d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800822:	eb f7                	jmp    80081b <vsnprintf+0x45>

00800824 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80082a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80082d:	50                   	push   %eax
  80082e:	ff 75 10             	pushl  0x10(%ebp)
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	ff 75 08             	pushl  0x8(%ebp)
  800837:	e8 9a ff ff ff       	call   8007d6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80083c:	c9                   	leave  
  80083d:	c3                   	ret    

0080083e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800844:	b8 00 00 00 00       	mov    $0x0,%eax
  800849:	eb 03                	jmp    80084e <strlen+0x10>
		n++;
  80084b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80084e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800852:	75 f7                	jne    80084b <strlen+0xd>
	return n;
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	eb 03                	jmp    800869 <strnlen+0x13>
		n++;
  800866:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800869:	39 d0                	cmp    %edx,%eax
  80086b:	74 06                	je     800873 <strnlen+0x1d>
  80086d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800871:	75 f3                	jne    800866 <strnlen+0x10>
	return n;
}
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	53                   	push   %ebx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80087f:	89 c2                	mov    %eax,%edx
  800881:	83 c1 01             	add    $0x1,%ecx
  800884:	83 c2 01             	add    $0x1,%edx
  800887:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80088b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80088e:	84 db                	test   %bl,%bl
  800890:	75 ef                	jne    800881 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800892:	5b                   	pop    %ebx
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80089c:	53                   	push   %ebx
  80089d:	e8 9c ff ff ff       	call   80083e <strlen>
  8008a2:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	01 d8                	add    %ebx,%eax
  8008aa:	50                   	push   %eax
  8008ab:	e8 c5 ff ff ff       	call   800875 <strcpy>
	return dst;
}
  8008b0:	89 d8                	mov    %ebx,%eax
  8008b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    

008008b7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	56                   	push   %esi
  8008bb:	53                   	push   %ebx
  8008bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8008bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c2:	89 f3                	mov    %esi,%ebx
  8008c4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c7:	89 f2                	mov    %esi,%edx
  8008c9:	eb 0f                	jmp    8008da <strncpy+0x23>
		*dst++ = *src;
  8008cb:	83 c2 01             	add    $0x1,%edx
  8008ce:	0f b6 01             	movzbl (%ecx),%eax
  8008d1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d4:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008da:	39 da                	cmp    %ebx,%edx
  8008dc:	75 ed                	jne    8008cb <strncpy+0x14>
	}
	return ret;
}
  8008de:	89 f0                	mov    %esi,%eax
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008f2:	89 f0                	mov    %esi,%eax
  8008f4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f8:	85 c9                	test   %ecx,%ecx
  8008fa:	75 0b                	jne    800907 <strlcpy+0x23>
  8008fc:	eb 17                	jmp    800915 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008fe:	83 c2 01             	add    $0x1,%edx
  800901:	83 c0 01             	add    $0x1,%eax
  800904:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800907:	39 d8                	cmp    %ebx,%eax
  800909:	74 07                	je     800912 <strlcpy+0x2e>
  80090b:	0f b6 0a             	movzbl (%edx),%ecx
  80090e:	84 c9                	test   %cl,%cl
  800910:	75 ec                	jne    8008fe <strlcpy+0x1a>
		*dst = '\0';
  800912:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800915:	29 f0                	sub    %esi,%eax
}
  800917:	5b                   	pop    %ebx
  800918:	5e                   	pop    %esi
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800921:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800924:	eb 06                	jmp    80092c <strcmp+0x11>
		p++, q++;
  800926:	83 c1 01             	add    $0x1,%ecx
  800929:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80092c:	0f b6 01             	movzbl (%ecx),%eax
  80092f:	84 c0                	test   %al,%al
  800931:	74 04                	je     800937 <strcmp+0x1c>
  800933:	3a 02                	cmp    (%edx),%al
  800935:	74 ef                	je     800926 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800937:	0f b6 c0             	movzbl %al,%eax
  80093a:	0f b6 12             	movzbl (%edx),%edx
  80093d:	29 d0                	sub    %edx,%eax
}
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	53                   	push   %ebx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	89 c3                	mov    %eax,%ebx
  80094d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800950:	eb 06                	jmp    800958 <strncmp+0x17>
		n--, p++, q++;
  800952:	83 c0 01             	add    $0x1,%eax
  800955:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800958:	39 d8                	cmp    %ebx,%eax
  80095a:	74 16                	je     800972 <strncmp+0x31>
  80095c:	0f b6 08             	movzbl (%eax),%ecx
  80095f:	84 c9                	test   %cl,%cl
  800961:	74 04                	je     800967 <strncmp+0x26>
  800963:	3a 0a                	cmp    (%edx),%cl
  800965:	74 eb                	je     800952 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800967:	0f b6 00             	movzbl (%eax),%eax
  80096a:	0f b6 12             	movzbl (%edx),%edx
  80096d:	29 d0                	sub    %edx,%eax
}
  80096f:	5b                   	pop    %ebx
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    
		return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
  800977:	eb f6                	jmp    80096f <strncmp+0x2e>

00800979 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800983:	0f b6 10             	movzbl (%eax),%edx
  800986:	84 d2                	test   %dl,%dl
  800988:	74 09                	je     800993 <strchr+0x1a>
		if (*s == c)
  80098a:	38 ca                	cmp    %cl,%dl
  80098c:	74 0a                	je     800998 <strchr+0x1f>
	for (; *s; s++)
  80098e:	83 c0 01             	add    $0x1,%eax
  800991:	eb f0                	jmp    800983 <strchr+0xa>
			return (char *) s;
	return 0;
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a4:	eb 03                	jmp    8009a9 <strfind+0xf>
  8009a6:	83 c0 01             	add    $0x1,%eax
  8009a9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ac:	38 ca                	cmp    %cl,%dl
  8009ae:	74 04                	je     8009b4 <strfind+0x1a>
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	75 f2                	jne    8009a6 <strfind+0xc>
			break;
	return (char *) s;
}
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	57                   	push   %edi
  8009ba:	56                   	push   %esi
  8009bb:	53                   	push   %ebx
  8009bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c2:	85 c9                	test   %ecx,%ecx
  8009c4:	74 13                	je     8009d9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c6:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cc:	75 05                	jne    8009d3 <memset+0x1d>
  8009ce:	f6 c1 03             	test   $0x3,%cl
  8009d1:	74 0d                	je     8009e0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d6:	fc                   	cld    
  8009d7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d9:	89 f8                	mov    %edi,%eax
  8009db:	5b                   	pop    %ebx
  8009dc:	5e                   	pop    %esi
  8009dd:	5f                   	pop    %edi
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    
		c &= 0xFF;
  8009e0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e4:	89 d3                	mov    %edx,%ebx
  8009e6:	c1 e3 08             	shl    $0x8,%ebx
  8009e9:	89 d0                	mov    %edx,%eax
  8009eb:	c1 e0 18             	shl    $0x18,%eax
  8009ee:	89 d6                	mov    %edx,%esi
  8009f0:	c1 e6 10             	shl    $0x10,%esi
  8009f3:	09 f0                	or     %esi,%eax
  8009f5:	09 c2                	or     %eax,%edx
  8009f7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009f9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	fc                   	cld    
  8009ff:	f3 ab                	rep stos %eax,%es:(%edi)
  800a01:	eb d6                	jmp    8009d9 <memset+0x23>

00800a03 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	57                   	push   %edi
  800a07:	56                   	push   %esi
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a11:	39 c6                	cmp    %eax,%esi
  800a13:	73 35                	jae    800a4a <memmove+0x47>
  800a15:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a18:	39 c2                	cmp    %eax,%edx
  800a1a:	76 2e                	jbe    800a4a <memmove+0x47>
		s += n;
		d += n;
  800a1c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1f:	89 d6                	mov    %edx,%esi
  800a21:	09 fe                	or     %edi,%esi
  800a23:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a29:	74 0c                	je     800a37 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a2b:	83 ef 01             	sub    $0x1,%edi
  800a2e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a31:	fd                   	std    
  800a32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a34:	fc                   	cld    
  800a35:	eb 21                	jmp    800a58 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a37:	f6 c1 03             	test   $0x3,%cl
  800a3a:	75 ef                	jne    800a2b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a3c:	83 ef 04             	sub    $0x4,%edi
  800a3f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a45:	fd                   	std    
  800a46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a48:	eb ea                	jmp    800a34 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4a:	89 f2                	mov    %esi,%edx
  800a4c:	09 c2                	or     %eax,%edx
  800a4e:	f6 c2 03             	test   $0x3,%dl
  800a51:	74 09                	je     800a5c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a53:	89 c7                	mov    %eax,%edi
  800a55:	fc                   	cld    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a58:	5e                   	pop    %esi
  800a59:	5f                   	pop    %edi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5c:	f6 c1 03             	test   $0x3,%cl
  800a5f:	75 f2                	jne    800a53 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a61:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a64:	89 c7                	mov    %eax,%edi
  800a66:	fc                   	cld    
  800a67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a69:	eb ed                	jmp    800a58 <memmove+0x55>

00800a6b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a6e:	ff 75 10             	pushl  0x10(%ebp)
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	ff 75 08             	pushl  0x8(%ebp)
  800a77:	e8 87 ff ff ff       	call   800a03 <memmove>
}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	56                   	push   %esi
  800a82:	53                   	push   %ebx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a89:	89 c6                	mov    %eax,%esi
  800a8b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8e:	39 f0                	cmp    %esi,%eax
  800a90:	74 1c                	je     800aae <memcmp+0x30>
		if (*s1 != *s2)
  800a92:	0f b6 08             	movzbl (%eax),%ecx
  800a95:	0f b6 1a             	movzbl (%edx),%ebx
  800a98:	38 d9                	cmp    %bl,%cl
  800a9a:	75 08                	jne    800aa4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a9c:	83 c0 01             	add    $0x1,%eax
  800a9f:	83 c2 01             	add    $0x1,%edx
  800aa2:	eb ea                	jmp    800a8e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aa4:	0f b6 c1             	movzbl %cl,%eax
  800aa7:	0f b6 db             	movzbl %bl,%ebx
  800aaa:	29 d8                	sub    %ebx,%eax
  800aac:	eb 05                	jmp    800ab3 <memcmp+0x35>
	}

	return 0;
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab3:	5b                   	pop    %ebx
  800ab4:	5e                   	pop    %esi
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac5:	39 d0                	cmp    %edx,%eax
  800ac7:	73 09                	jae    800ad2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac9:	38 08                	cmp    %cl,(%eax)
  800acb:	74 05                	je     800ad2 <memfind+0x1b>
	for (; s < ends; s++)
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	eb f3                	jmp    800ac5 <memfind+0xe>
			break;
	return (void *) s;
}
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	57                   	push   %edi
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
  800ada:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800add:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae0:	eb 03                	jmp    800ae5 <strtol+0x11>
		s++;
  800ae2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae5:	0f b6 01             	movzbl (%ecx),%eax
  800ae8:	3c 20                	cmp    $0x20,%al
  800aea:	74 f6                	je     800ae2 <strtol+0xe>
  800aec:	3c 09                	cmp    $0x9,%al
  800aee:	74 f2                	je     800ae2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800af0:	3c 2b                	cmp    $0x2b,%al
  800af2:	74 2e                	je     800b22 <strtol+0x4e>
	int neg = 0;
  800af4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af9:	3c 2d                	cmp    $0x2d,%al
  800afb:	74 2f                	je     800b2c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b03:	75 05                	jne    800b0a <strtol+0x36>
  800b05:	80 39 30             	cmpb   $0x30,(%ecx)
  800b08:	74 2c                	je     800b36 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b0a:	85 db                	test   %ebx,%ebx
  800b0c:	75 0a                	jne    800b18 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b13:	80 39 30             	cmpb   $0x30,(%ecx)
  800b16:	74 28                	je     800b40 <strtol+0x6c>
		base = 10;
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b20:	eb 50                	jmp    800b72 <strtol+0x9e>
		s++;
  800b22:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b25:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2a:	eb d1                	jmp    800afd <strtol+0x29>
		s++, neg = 1;
  800b2c:	83 c1 01             	add    $0x1,%ecx
  800b2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b34:	eb c7                	jmp    800afd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b36:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3a:	74 0e                	je     800b4a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b3c:	85 db                	test   %ebx,%ebx
  800b3e:	75 d8                	jne    800b18 <strtol+0x44>
		s++, base = 8;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b48:	eb ce                	jmp    800b18 <strtol+0x44>
		s += 2, base = 16;
  800b4a:	83 c1 02             	add    $0x2,%ecx
  800b4d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b52:	eb c4                	jmp    800b18 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b54:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b57:	89 f3                	mov    %esi,%ebx
  800b59:	80 fb 19             	cmp    $0x19,%bl
  800b5c:	77 29                	ja     800b87 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b5e:	0f be d2             	movsbl %dl,%edx
  800b61:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b64:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b67:	7d 30                	jge    800b99 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b69:	83 c1 01             	add    $0x1,%ecx
  800b6c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b72:	0f b6 11             	movzbl (%ecx),%edx
  800b75:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b78:	89 f3                	mov    %esi,%ebx
  800b7a:	80 fb 09             	cmp    $0x9,%bl
  800b7d:	77 d5                	ja     800b54 <strtol+0x80>
			dig = *s - '0';
  800b7f:	0f be d2             	movsbl %dl,%edx
  800b82:	83 ea 30             	sub    $0x30,%edx
  800b85:	eb dd                	jmp    800b64 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b87:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	80 fb 19             	cmp    $0x19,%bl
  800b8f:	77 08                	ja     800b99 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b91:	0f be d2             	movsbl %dl,%edx
  800b94:	83 ea 37             	sub    $0x37,%edx
  800b97:	eb cb                	jmp    800b64 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9d:	74 05                	je     800ba4 <strtol+0xd0>
		*endptr = (char *) s;
  800b9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	f7 da                	neg    %edx
  800ba8:	85 ff                	test   %edi,%edi
  800baa:	0f 45 c2             	cmovne %edx,%eax
}
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc3:	89 c3                	mov    %eax,%ebx
  800bc5:	89 c7                	mov    %eax,%edi
  800bc7:	89 c6                	mov    %eax,%esi
  800bc9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5f                   	pop    %edi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	b8 01 00 00 00       	mov    $0x1,%eax
  800be0:	89 d1                	mov    %edx,%ecx
  800be2:	89 d3                	mov    %edx,%ebx
  800be4:	89 d7                	mov    %edx,%edi
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800c00:	b8 03 00 00 00       	mov    $0x3,%eax
  800c05:	89 cb                	mov    %ecx,%ebx
  800c07:	89 cf                	mov    %ecx,%edi
  800c09:	89 ce                	mov    %ecx,%esi
  800c0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	7f 08                	jg     800c19 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	50                   	push   %eax
  800c1d:	6a 03                	push   $0x3
  800c1f:	68 9f 2a 80 00       	push   $0x802a9f
  800c24:	6a 23                	push   $0x23
  800c26:	68 bc 2a 80 00       	push   $0x802abc
  800c2b:	e8 d9 16 00 00       	call   802309 <_panic>

00800c30 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	57                   	push   %edi
  800c34:	56                   	push   %esi
  800c35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c36:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c40:	89 d1                	mov    %edx,%ecx
  800c42:	89 d3                	mov    %edx,%ebx
  800c44:	89 d7                	mov    %edx,%edi
  800c46:	89 d6                	mov    %edx,%esi
  800c48:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <sys_yield>:

void
sys_yield(void)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	be 00 00 00 00       	mov    $0x0,%esi
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 04 00 00 00       	mov    $0x4,%eax
  800c87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8a:	89 f7                	mov    %esi,%edi
  800c8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	7f 08                	jg     800c9a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800c9e:	6a 04                	push   $0x4
  800ca0:	68 9f 2a 80 00       	push   $0x802a9f
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 bc 2a 80 00       	push   $0x802abc
  800cac:	e8 58 16 00 00       	call   802309 <_panic>

00800cb1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccb:	8b 75 18             	mov    0x18(%ebp),%esi
  800cce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	7f 08                	jg     800cdc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800ce0:	6a 05                	push   $0x5
  800ce2:	68 9f 2a 80 00       	push   $0x802a9f
  800ce7:	6a 23                	push   $0x23
  800ce9:	68 bc 2a 80 00       	push   $0x802abc
  800cee:	e8 16 16 00 00       	call   802309 <_panic>

00800cf3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d07:	b8 06 00 00 00       	mov    $0x6,%eax
  800d0c:	89 df                	mov    %ebx,%edi
  800d0e:	89 de                	mov    %ebx,%esi
  800d10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d12:	85 c0                	test   %eax,%eax
  800d14:	7f 08                	jg     800d1e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d22:	6a 06                	push   $0x6
  800d24:	68 9f 2a 80 00       	push   $0x802a9f
  800d29:	6a 23                	push   $0x23
  800d2b:	68 bc 2a 80 00       	push   $0x802abc
  800d30:	e8 d4 15 00 00       	call   802309 <_panic>

00800d35 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800d49:	b8 08 00 00 00       	mov    $0x8,%eax
  800d4e:	89 df                	mov    %ebx,%edi
  800d50:	89 de                	mov    %ebx,%esi
  800d52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d64:	6a 08                	push   $0x8
  800d66:	68 9f 2a 80 00       	push   $0x802a9f
  800d6b:	6a 23                	push   $0x23
  800d6d:	68 bc 2a 80 00       	push   $0x802abc
  800d72:	e8 92 15 00 00       	call   802309 <_panic>

00800d77 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800d8b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d90:	89 df                	mov    %ebx,%edi
  800d92:	89 de                	mov    %ebx,%esi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800da6:	6a 09                	push   $0x9
  800da8:	68 9f 2a 80 00       	push   $0x802a9f
  800dad:	6a 23                	push   $0x23
  800daf:	68 bc 2a 80 00       	push   $0x802abc
  800db4:	e8 50 15 00 00       	call   802309 <_panic>

00800db9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd2:	89 df                	mov    %ebx,%edi
  800dd4:	89 de                	mov    %ebx,%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 0a                	push   $0xa
  800dea:	68 9f 2a 80 00       	push   $0x802a9f
  800def:	6a 23                	push   $0x23
  800df1:	68 bc 2a 80 00       	push   $0x802abc
  800df6:	e8 0e 15 00 00       	call   802309 <_panic>

00800dfb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e07:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e0c:	be 00 00 00 00       	mov    $0x0,%esi
  800e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e14:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e17:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e34:	89 cb                	mov    %ecx,%ebx
  800e36:	89 cf                	mov    %ecx,%edi
  800e38:	89 ce                	mov    %ecx,%esi
  800e3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7f 08                	jg     800e48 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	50                   	push   %eax
  800e4c:	6a 0d                	push   $0xd
  800e4e:	68 9f 2a 80 00       	push   $0x802a9f
  800e53:	6a 23                	push   $0x23
  800e55:	68 bc 2a 80 00       	push   $0x802abc
  800e5a:	e8 aa 14 00 00       	call   802309 <_panic>

00800e5f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e65:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e6f:	89 d1                	mov    %edx,%ecx
  800e71:	89 d3                	mov    %edx,%ebx
  800e73:	89 d7                	mov    %edx,%edi
  800e75:	89 d6                	mov    %edx,%esi
  800e77:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5f                   	pop    %edi
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 1c             	sub    $0x1c,%esp
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800e8a:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800e8c:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800e8f:	89 d8                	mov    %ebx,%eax
  800e91:	c1 e8 0c             	shr    $0xc,%eax
  800e94:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800e9e:	e8 8d fd ff ff       	call   800c30 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800ea3:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800ea9:	74 73                	je     800f1e <pgfault+0xa0>
  800eab:	89 c6                	mov    %eax,%esi
  800ead:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800eb4:	74 68                	je     800f1e <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800eb6:	83 ec 04             	sub    $0x4,%esp
  800eb9:	6a 07                	push   $0x7
  800ebb:	68 00 f0 7f 00       	push   $0x7ff000
  800ec0:	50                   	push   %eax
  800ec1:	e8 a8 fd ff ff       	call   800c6e <sys_page_alloc>
  800ec6:	83 c4 10             	add    $0x10,%esp
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	75 65                	jne    800f32 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800ecd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800ed3:	83 ec 04             	sub    $0x4,%esp
  800ed6:	68 00 10 00 00       	push   $0x1000
  800edb:	53                   	push   %ebx
  800edc:	68 00 f0 7f 00       	push   $0x7ff000
  800ee1:	e8 85 fb ff ff       	call   800a6b <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800ee6:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800eed:	53                   	push   %ebx
  800eee:	56                   	push   %esi
  800eef:	68 00 f0 7f 00       	push   $0x7ff000
  800ef4:	56                   	push   %esi
  800ef5:	e8 b7 fd ff ff       	call   800cb1 <sys_page_map>
  800efa:	83 c4 20             	add    $0x20,%esp
  800efd:	85 c0                	test   %eax,%eax
  800eff:	75 43                	jne    800f44 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800f01:	83 ec 08             	sub    $0x8,%esp
  800f04:	68 00 f0 7f 00       	push   $0x7ff000
  800f09:	56                   	push   %esi
  800f0a:	e8 e4 fd ff ff       	call   800cf3 <sys_page_unmap>
  800f0f:	83 c4 10             	add    $0x10,%esp
  800f12:	85 c0                	test   %eax,%eax
  800f14:	75 40                	jne    800f56 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  800f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	68 ca 2a 80 00       	push   $0x802aca
  800f26:	6a 1f                	push   $0x1f
  800f28:	68 e8 2a 80 00       	push   $0x802ae8
  800f2d:	e8 d7 13 00 00       	call   802309 <_panic>
	    panic("pgfault: %e", r);
  800f32:	50                   	push   %eax
  800f33:	68 f3 2a 80 00       	push   $0x802af3
  800f38:	6a 2a                	push   $0x2a
  800f3a:	68 e8 2a 80 00       	push   $0x802ae8
  800f3f:	e8 c5 13 00 00       	call   802309 <_panic>
	    panic("pgfault: %e", r);
  800f44:	50                   	push   %eax
  800f45:	68 f3 2a 80 00       	push   $0x802af3
  800f4a:	6a 2e                	push   $0x2e
  800f4c:	68 e8 2a 80 00       	push   $0x802ae8
  800f51:	e8 b3 13 00 00       	call   802309 <_panic>
	    panic("pgfault: %e", r);
  800f56:	50                   	push   %eax
  800f57:	68 f3 2a 80 00       	push   $0x802af3
  800f5c:	6a 31                	push   $0x31
  800f5e:	68 e8 2a 80 00       	push   $0x802ae8
  800f63:	e8 a1 13 00 00       	call   802309 <_panic>

00800f68 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
  800f6e:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  800f71:	68 7e 0e 80 00       	push   $0x800e7e
  800f76:	e8 d4 13 00 00       	call   80234f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f7b:	b8 07 00 00 00       	mov    $0x7,%eax
  800f80:	cd 30                	int    $0x30
  800f82:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f85:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	78 2b                	js     800fba <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f8f:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f94:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f98:	0f 85 b5 00 00 00    	jne    801053 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  800f9e:	e8 8d fc ff ff       	call   800c30 <sys_getenvid>
  800fa3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fa8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fb0:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  800fb5:	e9 8c 01 00 00       	jmp    801146 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  800fba:	50                   	push   %eax
  800fbb:	68 ff 2a 80 00       	push   $0x802aff
  800fc0:	6a 77                	push   $0x77
  800fc2:	68 e8 2a 80 00       	push   $0x802ae8
  800fc7:	e8 3d 13 00 00       	call   802309 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  800fcc:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	25 07 0e 00 00       	and    $0xe07,%eax
  800fdb:	50                   	push   %eax
  800fdc:	57                   	push   %edi
  800fdd:	ff 75 e0             	pushl  -0x20(%ebp)
  800fe0:	57                   	push   %edi
  800fe1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe4:	e8 c8 fc ff ff       	call   800cb1 <sys_page_map>
  800fe9:	83 c4 20             	add    $0x20,%esp
  800fec:	85 c0                	test   %eax,%eax
  800fee:	74 51                	je     801041 <fork+0xd9>
           panic("duppage: %e", r);
  800ff0:	50                   	push   %eax
  800ff1:	68 0f 2b 80 00       	push   $0x802b0f
  800ff6:	6a 4a                	push   $0x4a
  800ff8:	68 e8 2a 80 00       	push   $0x802ae8
  800ffd:	e8 07 13 00 00       	call   802309 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	68 05 08 00 00       	push   $0x805
  80100a:	57                   	push   %edi
  80100b:	ff 75 e0             	pushl  -0x20(%ebp)
  80100e:	57                   	push   %edi
  80100f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801012:	e8 9a fc ff ff       	call   800cb1 <sys_page_map>
  801017:	83 c4 20             	add    $0x20,%esp
  80101a:	85 c0                	test   %eax,%eax
  80101c:	0f 85 bc 00 00 00    	jne    8010de <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	68 05 08 00 00       	push   $0x805
  80102a:	57                   	push   %edi
  80102b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80102e:	50                   	push   %eax
  80102f:	57                   	push   %edi
  801030:	50                   	push   %eax
  801031:	e8 7b fc ff ff       	call   800cb1 <sys_page_map>
  801036:	83 c4 20             	add    $0x20,%esp
  801039:	85 c0                	test   %eax,%eax
  80103b:	0f 85 af 00 00 00    	jne    8010f0 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801041:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801047:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80104d:	0f 84 af 00 00 00    	je     801102 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801053:	89 d8                	mov    %ebx,%eax
  801055:	c1 e8 16             	shr    $0x16,%eax
  801058:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80105f:	a8 01                	test   $0x1,%al
  801061:	74 de                	je     801041 <fork+0xd9>
  801063:	89 de                	mov    %ebx,%esi
  801065:	c1 ee 0c             	shr    $0xc,%esi
  801068:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80106f:	a8 01                	test   $0x1,%al
  801071:	74 ce                	je     801041 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  801073:	e8 b8 fb ff ff       	call   800c30 <sys_getenvid>
  801078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  80107b:	89 f7                	mov    %esi,%edi
  80107d:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  801080:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801087:	f6 c4 04             	test   $0x4,%ah
  80108a:	0f 85 3c ff ff ff    	jne    800fcc <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  801090:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801097:	a8 02                	test   $0x2,%al
  801099:	0f 85 63 ff ff ff    	jne    801002 <fork+0x9a>
  80109f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010a6:	f6 c4 08             	test   $0x8,%ah
  8010a9:	0f 85 53 ff ff ff    	jne    801002 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	6a 05                	push   $0x5
  8010b4:	57                   	push   %edi
  8010b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8010b8:	57                   	push   %edi
  8010b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010bc:	e8 f0 fb ff ff       	call   800cb1 <sys_page_map>
  8010c1:	83 c4 20             	add    $0x20,%esp
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	0f 84 75 ff ff ff    	je     801041 <fork+0xd9>
	        panic("duppage: %e", r);
  8010cc:	50                   	push   %eax
  8010cd:	68 0f 2b 80 00       	push   $0x802b0f
  8010d2:	6a 55                	push   $0x55
  8010d4:	68 e8 2a 80 00       	push   $0x802ae8
  8010d9:	e8 2b 12 00 00       	call   802309 <_panic>
	        panic("duppage: %e", r);
  8010de:	50                   	push   %eax
  8010df:	68 0f 2b 80 00       	push   $0x802b0f
  8010e4:	6a 4e                	push   $0x4e
  8010e6:	68 e8 2a 80 00       	push   $0x802ae8
  8010eb:	e8 19 12 00 00       	call   802309 <_panic>
	        panic("duppage: %e", r);
  8010f0:	50                   	push   %eax
  8010f1:	68 0f 2b 80 00       	push   $0x802b0f
  8010f6:	6a 51                	push   $0x51
  8010f8:	68 e8 2a 80 00       	push   $0x802ae8
  8010fd:	e8 07 12 00 00       	call   802309 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801102:	83 ec 04             	sub    $0x4,%esp
  801105:	6a 07                	push   $0x7
  801107:	68 00 f0 bf ee       	push   $0xeebff000
  80110c:	ff 75 dc             	pushl  -0x24(%ebp)
  80110f:	e8 5a fb ff ff       	call   800c6e <sys_page_alloc>
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	85 c0                	test   %eax,%eax
  801119:	75 36                	jne    801151 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	68 c8 23 80 00       	push   $0x8023c8
  801123:	ff 75 dc             	pushl  -0x24(%ebp)
  801126:	e8 8e fc ff ff       	call   800db9 <sys_env_set_pgfault_upcall>
  80112b:	83 c4 10             	add    $0x10,%esp
  80112e:	85 c0                	test   %eax,%eax
  801130:	75 34                	jne    801166 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801132:	83 ec 08             	sub    $0x8,%esp
  801135:	6a 02                	push   $0x2
  801137:	ff 75 dc             	pushl  -0x24(%ebp)
  80113a:	e8 f6 fb ff ff       	call   800d35 <sys_env_set_status>
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	75 35                	jne    80117b <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801146:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801149:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5f                   	pop    %edi
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    
	    panic("fork: %e", r);
  801151:	50                   	push   %eax
  801152:	68 06 2b 80 00       	push   $0x802b06
  801157:	68 8a 00 00 00       	push   $0x8a
  80115c:	68 e8 2a 80 00       	push   $0x802ae8
  801161:	e8 a3 11 00 00       	call   802309 <_panic>
	    panic("fork: %e", r);
  801166:	50                   	push   %eax
  801167:	68 06 2b 80 00       	push   $0x802b06
  80116c:	68 8d 00 00 00       	push   $0x8d
  801171:	68 e8 2a 80 00       	push   $0x802ae8
  801176:	e8 8e 11 00 00       	call   802309 <_panic>
	    panic("fork: %e", r);
  80117b:	50                   	push   %eax
  80117c:	68 06 2b 80 00       	push   $0x802b06
  801181:	68 92 00 00 00       	push   $0x92
  801186:	68 e8 2a 80 00       	push   $0x802ae8
  80118b:	e8 79 11 00 00       	call   802309 <_panic>

00801190 <sfork>:

// Challenge!
int
sfork(void)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801196:	68 1b 2b 80 00       	push   $0x802b1b
  80119b:	68 9b 00 00 00       	push   $0x9b
  8011a0:	68 e8 2a 80 00       	push   $0x802ae8
  8011a5:	e8 5f 11 00 00       	call   802309 <_panic>

008011aa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	05 00 00 00 30       	add    $0x30000000,%eax
  8011b5:	c1 e8 0c             	shr    $0xc,%eax
}
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ca:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    

008011d1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011dc:	89 c2                	mov    %eax,%edx
  8011de:	c1 ea 16             	shr    $0x16,%edx
  8011e1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e8:	f6 c2 01             	test   $0x1,%dl
  8011eb:	74 2a                	je     801217 <fd_alloc+0x46>
  8011ed:	89 c2                	mov    %eax,%edx
  8011ef:	c1 ea 0c             	shr    $0xc,%edx
  8011f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f9:	f6 c2 01             	test   $0x1,%dl
  8011fc:	74 19                	je     801217 <fd_alloc+0x46>
  8011fe:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801203:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801208:	75 d2                	jne    8011dc <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80120a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801210:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801215:	eb 07                	jmp    80121e <fd_alloc+0x4d>
			*fd_store = fd;
  801217:	89 01                	mov    %eax,(%ecx)
			return 0;
  801219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801226:	83 f8 1f             	cmp    $0x1f,%eax
  801229:	77 36                	ja     801261 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80122b:	c1 e0 0c             	shl    $0xc,%eax
  80122e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801233:	89 c2                	mov    %eax,%edx
  801235:	c1 ea 16             	shr    $0x16,%edx
  801238:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80123f:	f6 c2 01             	test   $0x1,%dl
  801242:	74 24                	je     801268 <fd_lookup+0x48>
  801244:	89 c2                	mov    %eax,%edx
  801246:	c1 ea 0c             	shr    $0xc,%edx
  801249:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801250:	f6 c2 01             	test   $0x1,%dl
  801253:	74 1a                	je     80126f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801255:	8b 55 0c             	mov    0xc(%ebp),%edx
  801258:	89 02                	mov    %eax,(%edx)
	return 0;
  80125a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125f:	5d                   	pop    %ebp
  801260:	c3                   	ret    
		return -E_INVAL;
  801261:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801266:	eb f7                	jmp    80125f <fd_lookup+0x3f>
		return -E_INVAL;
  801268:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126d:	eb f0                	jmp    80125f <fd_lookup+0x3f>
  80126f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801274:	eb e9                	jmp    80125f <fd_lookup+0x3f>

00801276 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 08             	sub    $0x8,%esp
  80127c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127f:	ba b0 2b 80 00       	mov    $0x802bb0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801284:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801289:	39 08                	cmp    %ecx,(%eax)
  80128b:	74 33                	je     8012c0 <dev_lookup+0x4a>
  80128d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801290:	8b 02                	mov    (%edx),%eax
  801292:	85 c0                	test   %eax,%eax
  801294:	75 f3                	jne    801289 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801296:	a1 08 40 80 00       	mov    0x804008,%eax
  80129b:	8b 40 48             	mov    0x48(%eax),%eax
  80129e:	83 ec 04             	sub    $0x4,%esp
  8012a1:	51                   	push   %ecx
  8012a2:	50                   	push   %eax
  8012a3:	68 34 2b 80 00       	push   $0x802b34
  8012a8:	e8 2b ef ff ff       	call   8001d8 <cprintf>
	*dev = 0;
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    
			*dev = devtab[i];
  8012c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ca:	eb f2                	jmp    8012be <dev_lookup+0x48>

008012cc <fd_close>:
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 1c             	sub    $0x1c,%esp
  8012d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012de:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012df:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012e5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e8:	50                   	push   %eax
  8012e9:	e8 32 ff ff ff       	call   801220 <fd_lookup>
  8012ee:	89 c3                	mov    %eax,%ebx
  8012f0:	83 c4 08             	add    $0x8,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 05                	js     8012fc <fd_close+0x30>
	    || fd != fd2)
  8012f7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012fa:	74 16                	je     801312 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012fc:	89 f8                	mov    %edi,%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	0f 44 d8             	cmove  %eax,%ebx
}
  801308:	89 d8                	mov    %ebx,%eax
  80130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130d:	5b                   	pop    %ebx
  80130e:	5e                   	pop    %esi
  80130f:	5f                   	pop    %edi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	ff 36                	pushl  (%esi)
  80131b:	e8 56 ff ff ff       	call   801276 <dev_lookup>
  801320:	89 c3                	mov    %eax,%ebx
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 15                	js     80133e <fd_close+0x72>
		if (dev->dev_close)
  801329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132c:	8b 40 10             	mov    0x10(%eax),%eax
  80132f:	85 c0                	test   %eax,%eax
  801331:	74 1b                	je     80134e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801333:	83 ec 0c             	sub    $0xc,%esp
  801336:	56                   	push   %esi
  801337:	ff d0                	call   *%eax
  801339:	89 c3                	mov    %eax,%ebx
  80133b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80133e:	83 ec 08             	sub    $0x8,%esp
  801341:	56                   	push   %esi
  801342:	6a 00                	push   $0x0
  801344:	e8 aa f9 ff ff       	call   800cf3 <sys_page_unmap>
	return r;
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	eb ba                	jmp    801308 <fd_close+0x3c>
			r = 0;
  80134e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801353:	eb e9                	jmp    80133e <fd_close+0x72>

00801355 <close>:

int
close(int fdnum)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80135b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135e:	50                   	push   %eax
  80135f:	ff 75 08             	pushl  0x8(%ebp)
  801362:	e8 b9 fe ff ff       	call   801220 <fd_lookup>
  801367:	83 c4 08             	add    $0x8,%esp
  80136a:	85 c0                	test   %eax,%eax
  80136c:	78 10                	js     80137e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	6a 01                	push   $0x1
  801373:	ff 75 f4             	pushl  -0xc(%ebp)
  801376:	e8 51 ff ff ff       	call   8012cc <fd_close>
  80137b:	83 c4 10             	add    $0x10,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <close_all>:

void
close_all(void)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	53                   	push   %ebx
  801384:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801387:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	53                   	push   %ebx
  801390:	e8 c0 ff ff ff       	call   801355 <close>
	for (i = 0; i < MAXFD; i++)
  801395:	83 c3 01             	add    $0x1,%ebx
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	83 fb 20             	cmp    $0x20,%ebx
  80139e:	75 ec                	jne    80138c <close_all+0xc>
}
  8013a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	57                   	push   %edi
  8013a9:	56                   	push   %esi
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b1:	50                   	push   %eax
  8013b2:	ff 75 08             	pushl  0x8(%ebp)
  8013b5:	e8 66 fe ff ff       	call   801220 <fd_lookup>
  8013ba:	89 c3                	mov    %eax,%ebx
  8013bc:	83 c4 08             	add    $0x8,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	0f 88 81 00 00 00    	js     801448 <dup+0xa3>
		return r;
	close(newfdnum);
  8013c7:	83 ec 0c             	sub    $0xc,%esp
  8013ca:	ff 75 0c             	pushl  0xc(%ebp)
  8013cd:	e8 83 ff ff ff       	call   801355 <close>

	newfd = INDEX2FD(newfdnum);
  8013d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d5:	c1 e6 0c             	shl    $0xc,%esi
  8013d8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013de:	83 c4 04             	add    $0x4,%esp
  8013e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013e4:	e8 d1 fd ff ff       	call   8011ba <fd2data>
  8013e9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013eb:	89 34 24             	mov    %esi,(%esp)
  8013ee:	e8 c7 fd ff ff       	call   8011ba <fd2data>
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013f8:	89 d8                	mov    %ebx,%eax
  8013fa:	c1 e8 16             	shr    $0x16,%eax
  8013fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801404:	a8 01                	test   $0x1,%al
  801406:	74 11                	je     801419 <dup+0x74>
  801408:	89 d8                	mov    %ebx,%eax
  80140a:	c1 e8 0c             	shr    $0xc,%eax
  80140d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801414:	f6 c2 01             	test   $0x1,%dl
  801417:	75 39                	jne    801452 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141c:	89 d0                	mov    %edx,%eax
  80141e:	c1 e8 0c             	shr    $0xc,%eax
  801421:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801428:	83 ec 0c             	sub    $0xc,%esp
  80142b:	25 07 0e 00 00       	and    $0xe07,%eax
  801430:	50                   	push   %eax
  801431:	56                   	push   %esi
  801432:	6a 00                	push   $0x0
  801434:	52                   	push   %edx
  801435:	6a 00                	push   $0x0
  801437:	e8 75 f8 ff ff       	call   800cb1 <sys_page_map>
  80143c:	89 c3                	mov    %eax,%ebx
  80143e:	83 c4 20             	add    $0x20,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 31                	js     801476 <dup+0xd1>
		goto err;

	return newfdnum;
  801445:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801448:	89 d8                	mov    %ebx,%eax
  80144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144d:	5b                   	pop    %ebx
  80144e:	5e                   	pop    %esi
  80144f:	5f                   	pop    %edi
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801452:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801459:	83 ec 0c             	sub    $0xc,%esp
  80145c:	25 07 0e 00 00       	and    $0xe07,%eax
  801461:	50                   	push   %eax
  801462:	57                   	push   %edi
  801463:	6a 00                	push   $0x0
  801465:	53                   	push   %ebx
  801466:	6a 00                	push   $0x0
  801468:	e8 44 f8 ff ff       	call   800cb1 <sys_page_map>
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	83 c4 20             	add    $0x20,%esp
  801472:	85 c0                	test   %eax,%eax
  801474:	79 a3                	jns    801419 <dup+0x74>
	sys_page_unmap(0, newfd);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	56                   	push   %esi
  80147a:	6a 00                	push   $0x0
  80147c:	e8 72 f8 ff ff       	call   800cf3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801481:	83 c4 08             	add    $0x8,%esp
  801484:	57                   	push   %edi
  801485:	6a 00                	push   $0x0
  801487:	e8 67 f8 ff ff       	call   800cf3 <sys_page_unmap>
	return r;
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	eb b7                	jmp    801448 <dup+0xa3>

00801491 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	53                   	push   %ebx
  801495:	83 ec 14             	sub    $0x14,%esp
  801498:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	53                   	push   %ebx
  8014a0:	e8 7b fd ff ff       	call   801220 <fd_lookup>
  8014a5:	83 c4 08             	add    $0x8,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 3f                	js     8014eb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b2:	50                   	push   %eax
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	ff 30                	pushl  (%eax)
  8014b8:	e8 b9 fd ff ff       	call   801276 <dev_lookup>
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 27                	js     8014eb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c7:	8b 42 08             	mov    0x8(%edx),%eax
  8014ca:	83 e0 03             	and    $0x3,%eax
  8014cd:	83 f8 01             	cmp    $0x1,%eax
  8014d0:	74 1e                	je     8014f0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d5:	8b 40 08             	mov    0x8(%eax),%eax
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	74 35                	je     801511 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	ff 75 10             	pushl  0x10(%ebp)
  8014e2:	ff 75 0c             	pushl  0xc(%ebp)
  8014e5:	52                   	push   %edx
  8014e6:	ff d0                	call   *%eax
  8014e8:	83 c4 10             	add    $0x10,%esp
}
  8014eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8014f5:	8b 40 48             	mov    0x48(%eax),%eax
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	53                   	push   %ebx
  8014fc:	50                   	push   %eax
  8014fd:	68 75 2b 80 00       	push   $0x802b75
  801502:	e8 d1 ec ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150f:	eb da                	jmp    8014eb <read+0x5a>
		return -E_NOT_SUPP;
  801511:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801516:	eb d3                	jmp    8014eb <read+0x5a>

00801518 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	57                   	push   %edi
  80151c:	56                   	push   %esi
  80151d:	53                   	push   %ebx
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	8b 7d 08             	mov    0x8(%ebp),%edi
  801524:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801527:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152c:	39 f3                	cmp    %esi,%ebx
  80152e:	73 25                	jae    801555 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	89 f0                	mov    %esi,%eax
  801535:	29 d8                	sub    %ebx,%eax
  801537:	50                   	push   %eax
  801538:	89 d8                	mov    %ebx,%eax
  80153a:	03 45 0c             	add    0xc(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	57                   	push   %edi
  80153f:	e8 4d ff ff ff       	call   801491 <read>
		if (m < 0)
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	78 08                	js     801553 <readn+0x3b>
			return m;
		if (m == 0)
  80154b:	85 c0                	test   %eax,%eax
  80154d:	74 06                	je     801555 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80154f:	01 c3                	add    %eax,%ebx
  801551:	eb d9                	jmp    80152c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801553:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801555:	89 d8                	mov    %ebx,%eax
  801557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5f                   	pop    %edi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	53                   	push   %ebx
  801563:	83 ec 14             	sub    $0x14,%esp
  801566:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801569:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156c:	50                   	push   %eax
  80156d:	53                   	push   %ebx
  80156e:	e8 ad fc ff ff       	call   801220 <fd_lookup>
  801573:	83 c4 08             	add    $0x8,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 3a                	js     8015b4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801584:	ff 30                	pushl  (%eax)
  801586:	e8 eb fc ff ff       	call   801276 <dev_lookup>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 22                	js     8015b4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801595:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801599:	74 1e                	je     8015b9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80159b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159e:	8b 52 0c             	mov    0xc(%edx),%edx
  8015a1:	85 d2                	test   %edx,%edx
  8015a3:	74 35                	je     8015da <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	ff 75 10             	pushl  0x10(%ebp)
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	50                   	push   %eax
  8015af:	ff d2                	call   *%edx
  8015b1:	83 c4 10             	add    $0x10,%esp
}
  8015b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8015be:	8b 40 48             	mov    0x48(%eax),%eax
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	53                   	push   %ebx
  8015c5:	50                   	push   %eax
  8015c6:	68 91 2b 80 00       	push   $0x802b91
  8015cb:	e8 08 ec ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d8:	eb da                	jmp    8015b4 <write+0x55>
		return -E_NOT_SUPP;
  8015da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015df:	eb d3                	jmp    8015b4 <write+0x55>

008015e1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e7:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 2d fc ff ff       	call   801220 <fd_lookup>
  8015f3:	83 c4 08             	add    $0x8,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 0e                	js     801608 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801600:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
  80160e:	83 ec 14             	sub    $0x14,%esp
  801611:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801614:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801617:	50                   	push   %eax
  801618:	53                   	push   %ebx
  801619:	e8 02 fc ff ff       	call   801220 <fd_lookup>
  80161e:	83 c4 08             	add    $0x8,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 37                	js     80165c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162b:	50                   	push   %eax
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162f:	ff 30                	pushl  (%eax)
  801631:	e8 40 fc ff ff       	call   801276 <dev_lookup>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 1f                	js     80165c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801644:	74 1b                	je     801661 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 52 18             	mov    0x18(%edx),%edx
  80164c:	85 d2                	test   %edx,%edx
  80164e:	74 32                	je     801682 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	50                   	push   %eax
  801657:	ff d2                	call   *%edx
  801659:	83 c4 10             	add    $0x10,%esp
}
  80165c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165f:	c9                   	leave  
  801660:	c3                   	ret    
			thisenv->env_id, fdnum);
  801661:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801666:	8b 40 48             	mov    0x48(%eax),%eax
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	53                   	push   %ebx
  80166d:	50                   	push   %eax
  80166e:	68 54 2b 80 00       	push   $0x802b54
  801673:	e8 60 eb ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801680:	eb da                	jmp    80165c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801682:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801687:	eb d3                	jmp    80165c <ftruncate+0x52>

00801689 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	53                   	push   %ebx
  80168d:	83 ec 14             	sub    $0x14,%esp
  801690:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801693:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801696:	50                   	push   %eax
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 81 fb ff ff       	call   801220 <fd_lookup>
  80169f:	83 c4 08             	add    $0x8,%esp
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 4b                	js     8016f1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	ff 30                	pushl  (%eax)
  8016b2:	e8 bf fb ff ff       	call   801276 <dev_lookup>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 33                	js     8016f1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c5:	74 2f                	je     8016f6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016d1:	00 00 00 
	stat->st_isdir = 0;
  8016d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016db:	00 00 00 
	stat->st_dev = dev;
  8016de:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	53                   	push   %ebx
  8016e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016eb:	ff 50 14             	call   *0x14(%eax)
  8016ee:	83 c4 10             	add    $0x10,%esp
}
  8016f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fb:	eb f4                	jmp    8016f1 <fstat+0x68>

008016fd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	6a 00                	push   $0x0
  801707:	ff 75 08             	pushl  0x8(%ebp)
  80170a:	e8 26 02 00 00       	call   801935 <open>
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	78 1b                	js     801733 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	50                   	push   %eax
  80171f:	e8 65 ff ff ff       	call   801689 <fstat>
  801724:	89 c6                	mov    %eax,%esi
	close(fd);
  801726:	89 1c 24             	mov    %ebx,(%esp)
  801729:	e8 27 fc ff ff       	call   801355 <close>
	return r;
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 f3                	mov    %esi,%ebx
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	89 c6                	mov    %eax,%esi
  801743:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801745:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80174c:	74 27                	je     801775 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174e:	6a 07                	push   $0x7
  801750:	68 00 50 80 00       	push   $0x805000
  801755:	56                   	push   %esi
  801756:	ff 35 00 40 80 00    	pushl  0x804000
  80175c:	e8 f6 0c 00 00       	call   802457 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801761:	83 c4 0c             	add    $0xc,%esp
  801764:	6a 00                	push   $0x0
  801766:	53                   	push   %ebx
  801767:	6a 00                	push   $0x0
  801769:	e8 80 0c 00 00       	call   8023ee <ipc_recv>
}
  80176e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	6a 01                	push   $0x1
  80177a:	e8 31 0d 00 00       	call   8024b0 <ipc_find_env>
  80177f:	a3 00 40 80 00       	mov    %eax,0x804000
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	eb c5                	jmp    80174e <fsipc+0x12>

00801789 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ac:	e8 8b ff ff ff       	call   80173c <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_flush>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ce:	e8 69 ff ff ff       	call   80173c <fsipc>
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <devfile_stat>:
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8017f4:	e8 43 ff ff ff       	call   80173c <fsipc>
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 2c                	js     801829 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	68 00 50 80 00       	push   $0x805000
  801805:	53                   	push   %ebx
  801806:	e8 6a f0 ff ff       	call   800875 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80180b:	a1 80 50 80 00       	mov    0x805080,%eax
  801810:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801816:	a1 84 50 80 00       	mov    0x805084,%eax
  80181b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <devfile_write>:
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	53                   	push   %ebx
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8b 40 0c             	mov    0xc(%eax),%eax
  80183e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801843:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801849:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80184f:	77 30                	ja     801881 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	53                   	push   %ebx
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	68 08 50 80 00       	push   $0x805008
  80185d:	e8 a1 f1 ff ff       	call   800a03 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801862:	ba 00 00 00 00       	mov    $0x0,%edx
  801867:	b8 04 00 00 00       	mov    $0x4,%eax
  80186c:	e8 cb fe ff ff       	call   80173c <fsipc>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	85 c0                	test   %eax,%eax
  801876:	78 04                	js     80187c <devfile_write+0x4e>
	assert(r <= n);
  801878:	39 d8                	cmp    %ebx,%eax
  80187a:	77 1e                	ja     80189a <devfile_write+0x6c>
}
  80187c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187f:	c9                   	leave  
  801880:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801881:	68 c4 2b 80 00       	push   $0x802bc4
  801886:	68 f1 2b 80 00       	push   $0x802bf1
  80188b:	68 94 00 00 00       	push   $0x94
  801890:	68 06 2c 80 00       	push   $0x802c06
  801895:	e8 6f 0a 00 00       	call   802309 <_panic>
	assert(r <= n);
  80189a:	68 11 2c 80 00       	push   $0x802c11
  80189f:	68 f1 2b 80 00       	push   $0x802bf1
  8018a4:	68 98 00 00 00       	push   $0x98
  8018a9:	68 06 2c 80 00       	push   $0x802c06
  8018ae:	e8 56 0a 00 00       	call   802309 <_panic>

008018b3 <devfile_read>:
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018c6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d1:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d6:	e8 61 fe ff ff       	call   80173c <fsipc>
  8018db:	89 c3                	mov    %eax,%ebx
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 1f                	js     801900 <devfile_read+0x4d>
	assert(r <= n);
  8018e1:	39 f0                	cmp    %esi,%eax
  8018e3:	77 24                	ja     801909 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ea:	7f 33                	jg     80191f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	50                   	push   %eax
  8018f0:	68 00 50 80 00       	push   $0x805000
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	e8 06 f1 ff ff       	call   800a03 <memmove>
	return r;
  8018fd:	83 c4 10             	add    $0x10,%esp
}
  801900:	89 d8                	mov    %ebx,%eax
  801902:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5d                   	pop    %ebp
  801908:	c3                   	ret    
	assert(r <= n);
  801909:	68 11 2c 80 00       	push   $0x802c11
  80190e:	68 f1 2b 80 00       	push   $0x802bf1
  801913:	6a 7c                	push   $0x7c
  801915:	68 06 2c 80 00       	push   $0x802c06
  80191a:	e8 ea 09 00 00       	call   802309 <_panic>
	assert(r <= PGSIZE);
  80191f:	68 18 2c 80 00       	push   $0x802c18
  801924:	68 f1 2b 80 00       	push   $0x802bf1
  801929:	6a 7d                	push   $0x7d
  80192b:	68 06 2c 80 00       	push   $0x802c06
  801930:	e8 d4 09 00 00       	call   802309 <_panic>

00801935 <open>:
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	56                   	push   %esi
  801939:	53                   	push   %ebx
  80193a:	83 ec 1c             	sub    $0x1c,%esp
  80193d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801940:	56                   	push   %esi
  801941:	e8 f8 ee ff ff       	call   80083e <strlen>
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194e:	7f 6c                	jg     8019bc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801956:	50                   	push   %eax
  801957:	e8 75 f8 ff ff       	call   8011d1 <fd_alloc>
  80195c:	89 c3                	mov    %eax,%ebx
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	85 c0                	test   %eax,%eax
  801963:	78 3c                	js     8019a1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	56                   	push   %esi
  801969:	68 00 50 80 00       	push   $0x805000
  80196e:	e8 02 ef ff ff       	call   800875 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80197b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
  801983:	e8 b4 fd ff ff       	call   80173c <fsipc>
  801988:	89 c3                	mov    %eax,%ebx
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 19                	js     8019aa <open+0x75>
	return fd2num(fd);
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	ff 75 f4             	pushl  -0xc(%ebp)
  801997:	e8 0e f8 ff ff       	call   8011aa <fd2num>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
}
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
		fd_close(fd, 0);
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b2:	e8 15 f9 ff ff       	call   8012cc <fd_close>
		return r;
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	eb e5                	jmp    8019a1 <open+0x6c>
		return -E_BAD_PATH;
  8019bc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c1:	eb de                	jmp    8019a1 <open+0x6c>

008019c3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d3:	e8 64 fd ff ff       	call   80173c <fsipc>
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	56                   	push   %esi
  8019de:	53                   	push   %ebx
  8019df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	e8 cd f7 ff ff       	call   8011ba <fd2data>
  8019ed:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019ef:	83 c4 08             	add    $0x8,%esp
  8019f2:	68 24 2c 80 00       	push   $0x802c24
  8019f7:	53                   	push   %ebx
  8019f8:	e8 78 ee ff ff       	call   800875 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019fd:	8b 46 04             	mov    0x4(%esi),%eax
  801a00:	2b 06                	sub    (%esi),%eax
  801a02:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a08:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a0f:	00 00 00 
	stat->st_dev = &devpipe;
  801a12:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a19:	30 80 00 
	return 0;
}
  801a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a24:	5b                   	pop    %ebx
  801a25:	5e                   	pop    %esi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    

00801a28 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	53                   	push   %ebx
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a32:	53                   	push   %ebx
  801a33:	6a 00                	push   $0x0
  801a35:	e8 b9 f2 ff ff       	call   800cf3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a3a:	89 1c 24             	mov    %ebx,(%esp)
  801a3d:	e8 78 f7 ff ff       	call   8011ba <fd2data>
  801a42:	83 c4 08             	add    $0x8,%esp
  801a45:	50                   	push   %eax
  801a46:	6a 00                	push   $0x0
  801a48:	e8 a6 f2 ff ff       	call   800cf3 <sys_page_unmap>
}
  801a4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <_pipeisclosed>:
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	57                   	push   %edi
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	83 ec 1c             	sub    $0x1c,%esp
  801a5b:	89 c7                	mov    %eax,%edi
  801a5d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a5f:	a1 08 40 80 00       	mov    0x804008,%eax
  801a64:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a67:	83 ec 0c             	sub    $0xc,%esp
  801a6a:	57                   	push   %edi
  801a6b:	e8 79 0a 00 00       	call   8024e9 <pageref>
  801a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a73:	89 34 24             	mov    %esi,(%esp)
  801a76:	e8 6e 0a 00 00       	call   8024e9 <pageref>
		nn = thisenv->env_runs;
  801a7b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a81:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	39 cb                	cmp    %ecx,%ebx
  801a89:	74 1b                	je     801aa6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a8b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a8e:	75 cf                	jne    801a5f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a90:	8b 42 58             	mov    0x58(%edx),%eax
  801a93:	6a 01                	push   $0x1
  801a95:	50                   	push   %eax
  801a96:	53                   	push   %ebx
  801a97:	68 2b 2c 80 00       	push   $0x802c2b
  801a9c:	e8 37 e7 ff ff       	call   8001d8 <cprintf>
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	eb b9                	jmp    801a5f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801aa6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aa9:	0f 94 c0             	sete   %al
  801aac:	0f b6 c0             	movzbl %al,%eax
}
  801aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5e                   	pop    %esi
  801ab4:	5f                   	pop    %edi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <devpipe_write>:
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	57                   	push   %edi
  801abb:	56                   	push   %esi
  801abc:	53                   	push   %ebx
  801abd:	83 ec 28             	sub    $0x28,%esp
  801ac0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ac3:	56                   	push   %esi
  801ac4:	e8 f1 f6 ff ff       	call   8011ba <fd2data>
  801ac9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ad6:	74 4f                	je     801b27 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ad8:	8b 43 04             	mov    0x4(%ebx),%eax
  801adb:	8b 0b                	mov    (%ebx),%ecx
  801add:	8d 51 20             	lea    0x20(%ecx),%edx
  801ae0:	39 d0                	cmp    %edx,%eax
  801ae2:	72 14                	jb     801af8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ae4:	89 da                	mov    %ebx,%edx
  801ae6:	89 f0                	mov    %esi,%eax
  801ae8:	e8 65 ff ff ff       	call   801a52 <_pipeisclosed>
  801aed:	85 c0                	test   %eax,%eax
  801aef:	75 3a                	jne    801b2b <devpipe_write+0x74>
			sys_yield();
  801af1:	e8 59 f1 ff ff       	call   800c4f <sys_yield>
  801af6:	eb e0                	jmp    801ad8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801af8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801afb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801aff:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b02:	89 c2                	mov    %eax,%edx
  801b04:	c1 fa 1f             	sar    $0x1f,%edx
  801b07:	89 d1                	mov    %edx,%ecx
  801b09:	c1 e9 1b             	shr    $0x1b,%ecx
  801b0c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b0f:	83 e2 1f             	and    $0x1f,%edx
  801b12:	29 ca                	sub    %ecx,%edx
  801b14:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b18:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b1c:	83 c0 01             	add    $0x1,%eax
  801b1f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b22:	83 c7 01             	add    $0x1,%edi
  801b25:	eb ac                	jmp    801ad3 <devpipe_write+0x1c>
	return i;
  801b27:	89 f8                	mov    %edi,%eax
  801b29:	eb 05                	jmp    801b30 <devpipe_write+0x79>
				return 0;
  801b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    

00801b38 <devpipe_read>:
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	57                   	push   %edi
  801b3c:	56                   	push   %esi
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 18             	sub    $0x18,%esp
  801b41:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b44:	57                   	push   %edi
  801b45:	e8 70 f6 ff ff       	call   8011ba <fd2data>
  801b4a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	be 00 00 00 00       	mov    $0x0,%esi
  801b54:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b57:	74 47                	je     801ba0 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b59:	8b 03                	mov    (%ebx),%eax
  801b5b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b5e:	75 22                	jne    801b82 <devpipe_read+0x4a>
			if (i > 0)
  801b60:	85 f6                	test   %esi,%esi
  801b62:	75 14                	jne    801b78 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b64:	89 da                	mov    %ebx,%edx
  801b66:	89 f8                	mov    %edi,%eax
  801b68:	e8 e5 fe ff ff       	call   801a52 <_pipeisclosed>
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	75 33                	jne    801ba4 <devpipe_read+0x6c>
			sys_yield();
  801b71:	e8 d9 f0 ff ff       	call   800c4f <sys_yield>
  801b76:	eb e1                	jmp    801b59 <devpipe_read+0x21>
				return i;
  801b78:	89 f0                	mov    %esi,%eax
}
  801b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5f                   	pop    %edi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b82:	99                   	cltd   
  801b83:	c1 ea 1b             	shr    $0x1b,%edx
  801b86:	01 d0                	add    %edx,%eax
  801b88:	83 e0 1f             	and    $0x1f,%eax
  801b8b:	29 d0                	sub    %edx,%eax
  801b8d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b95:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b98:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b9b:	83 c6 01             	add    $0x1,%esi
  801b9e:	eb b4                	jmp    801b54 <devpipe_read+0x1c>
	return i;
  801ba0:	89 f0                	mov    %esi,%eax
  801ba2:	eb d6                	jmp    801b7a <devpipe_read+0x42>
				return 0;
  801ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba9:	eb cf                	jmp    801b7a <devpipe_read+0x42>

00801bab <pipe>:
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb6:	50                   	push   %eax
  801bb7:	e8 15 f6 ff ff       	call   8011d1 <fd_alloc>
  801bbc:	89 c3                	mov    %eax,%ebx
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	78 5b                	js     801c20 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 07 04 00 00       	push   $0x407
  801bcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd0:	6a 00                	push   $0x0
  801bd2:	e8 97 f0 ff ff       	call   800c6e <sys_page_alloc>
  801bd7:	89 c3                	mov    %eax,%ebx
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 40                	js     801c20 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be6:	50                   	push   %eax
  801be7:	e8 e5 f5 ff ff       	call   8011d1 <fd_alloc>
  801bec:	89 c3                	mov    %eax,%ebx
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 1b                	js     801c10 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	68 07 04 00 00       	push   $0x407
  801bfd:	ff 75 f0             	pushl  -0x10(%ebp)
  801c00:	6a 00                	push   $0x0
  801c02:	e8 67 f0 ff ff       	call   800c6e <sys_page_alloc>
  801c07:	89 c3                	mov    %eax,%ebx
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	79 19                	jns    801c29 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c10:	83 ec 08             	sub    $0x8,%esp
  801c13:	ff 75 f4             	pushl  -0xc(%ebp)
  801c16:	6a 00                	push   $0x0
  801c18:	e8 d6 f0 ff ff       	call   800cf3 <sys_page_unmap>
  801c1d:	83 c4 10             	add    $0x10,%esp
}
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c25:	5b                   	pop    %ebx
  801c26:	5e                   	pop    %esi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    
	va = fd2data(fd0);
  801c29:	83 ec 0c             	sub    $0xc,%esp
  801c2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2f:	e8 86 f5 ff ff       	call   8011ba <fd2data>
  801c34:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c36:	83 c4 0c             	add    $0xc,%esp
  801c39:	68 07 04 00 00       	push   $0x407
  801c3e:	50                   	push   %eax
  801c3f:	6a 00                	push   $0x0
  801c41:	e8 28 f0 ff ff       	call   800c6e <sys_page_alloc>
  801c46:	89 c3                	mov    %eax,%ebx
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	0f 88 8c 00 00 00    	js     801cdf <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 f0             	pushl  -0x10(%ebp)
  801c59:	e8 5c f5 ff ff       	call   8011ba <fd2data>
  801c5e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c65:	50                   	push   %eax
  801c66:	6a 00                	push   $0x0
  801c68:	56                   	push   %esi
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 41 f0 ff ff       	call   800cb1 <sys_page_map>
  801c70:	89 c3                	mov    %eax,%ebx
  801c72:	83 c4 20             	add    $0x20,%esp
  801c75:	85 c0                	test   %eax,%eax
  801c77:	78 58                	js     801cd1 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c82:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c91:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c97:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ca3:	83 ec 0c             	sub    $0xc,%esp
  801ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca9:	e8 fc f4 ff ff       	call   8011aa <fd2num>
  801cae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cb3:	83 c4 04             	add    $0x4,%esp
  801cb6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb9:	e8 ec f4 ff ff       	call   8011aa <fd2num>
  801cbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ccc:	e9 4f ff ff ff       	jmp    801c20 <pipe+0x75>
	sys_page_unmap(0, va);
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	56                   	push   %esi
  801cd5:	6a 00                	push   $0x0
  801cd7:	e8 17 f0 ff ff       	call   800cf3 <sys_page_unmap>
  801cdc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cdf:	83 ec 08             	sub    $0x8,%esp
  801ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce5:	6a 00                	push   $0x0
  801ce7:	e8 07 f0 ff ff       	call   800cf3 <sys_page_unmap>
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	e9 1c ff ff ff       	jmp    801c10 <pipe+0x65>

00801cf4 <pipeisclosed>:
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfd:	50                   	push   %eax
  801cfe:	ff 75 08             	pushl  0x8(%ebp)
  801d01:	e8 1a f5 ff ff       	call   801220 <fd_lookup>
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	78 18                	js     801d25 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	ff 75 f4             	pushl  -0xc(%ebp)
  801d13:	e8 a2 f4 ff ff       	call   8011ba <fd2data>
	return _pipeisclosed(fd, p);
  801d18:	89 c2                	mov    %eax,%edx
  801d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1d:	e8 30 fd ff ff       	call   801a52 <_pipeisclosed>
  801d22:	83 c4 10             	add    $0x10,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d2d:	68 43 2c 80 00       	push   $0x802c43
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	e8 3b eb ff ff       	call   800875 <strcpy>
	return 0;
}
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <devsock_close>:
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	53                   	push   %ebx
  801d45:	83 ec 10             	sub    $0x10,%esp
  801d48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d4b:	53                   	push   %ebx
  801d4c:	e8 98 07 00 00       	call   8024e9 <pageref>
  801d51:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d54:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d59:	83 f8 01             	cmp    $0x1,%eax
  801d5c:	74 07                	je     801d65 <devsock_close+0x24>
}
  801d5e:	89 d0                	mov    %edx,%eax
  801d60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	ff 73 0c             	pushl  0xc(%ebx)
  801d6b:	e8 b7 02 00 00       	call   802027 <nsipc_close>
  801d70:	89 c2                	mov    %eax,%edx
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	eb e7                	jmp    801d5e <devsock_close+0x1d>

00801d77 <devsock_write>:
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	ff 75 10             	pushl  0x10(%ebp)
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	ff 70 0c             	pushl  0xc(%eax)
  801d8b:	e8 74 03 00 00       	call   802104 <nsipc_send>
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <devsock_read>:
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	ff 75 10             	pushl  0x10(%ebp)
  801d9d:	ff 75 0c             	pushl  0xc(%ebp)
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	ff 70 0c             	pushl  0xc(%eax)
  801da6:	e8 ed 02 00 00       	call   802098 <nsipc_recv>
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <fd2sockid>:
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801db3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801db6:	52                   	push   %edx
  801db7:	50                   	push   %eax
  801db8:	e8 63 f4 ff ff       	call   801220 <fd_lookup>
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	78 10                	js     801dd4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc7:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801dcd:	39 08                	cmp    %ecx,(%eax)
  801dcf:	75 05                	jne    801dd6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dd1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    
		return -E_NOT_SUPP;
  801dd6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ddb:	eb f7                	jmp    801dd4 <fd2sockid+0x27>

00801ddd <alloc_sockfd>:
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	56                   	push   %esi
  801de1:	53                   	push   %ebx
  801de2:	83 ec 1c             	sub    $0x1c,%esp
  801de5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801de7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dea:	50                   	push   %eax
  801deb:	e8 e1 f3 ff ff       	call   8011d1 <fd_alloc>
  801df0:	89 c3                	mov    %eax,%ebx
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	85 c0                	test   %eax,%eax
  801df7:	78 43                	js     801e3c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801df9:	83 ec 04             	sub    $0x4,%esp
  801dfc:	68 07 04 00 00       	push   $0x407
  801e01:	ff 75 f4             	pushl  -0xc(%ebp)
  801e04:	6a 00                	push   $0x0
  801e06:	e8 63 ee ff ff       	call   800c6e <sys_page_alloc>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	85 c0                	test   %eax,%eax
  801e12:	78 28                	js     801e3c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e1d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e29:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	50                   	push   %eax
  801e30:	e8 75 f3 ff ff       	call   8011aa <fd2num>
  801e35:	89 c3                	mov    %eax,%ebx
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	eb 0c                	jmp    801e48 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	56                   	push   %esi
  801e40:	e8 e2 01 00 00       	call   802027 <nsipc_close>
		return r;
  801e45:	83 c4 10             	add    $0x10,%esp
}
  801e48:	89 d8                	mov    %ebx,%eax
  801e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e4d:	5b                   	pop    %ebx
  801e4e:	5e                   	pop    %esi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    

00801e51 <accept>:
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	e8 4e ff ff ff       	call   801dad <fd2sockid>
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	78 1b                	js     801e7e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e63:	83 ec 04             	sub    $0x4,%esp
  801e66:	ff 75 10             	pushl  0x10(%ebp)
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	50                   	push   %eax
  801e6d:	e8 0e 01 00 00       	call   801f80 <nsipc_accept>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	85 c0                	test   %eax,%eax
  801e77:	78 05                	js     801e7e <accept+0x2d>
	return alloc_sockfd(r);
  801e79:	e8 5f ff ff ff       	call   801ddd <alloc_sockfd>
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <bind>:
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	e8 1f ff ff ff       	call   801dad <fd2sockid>
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 12                	js     801ea4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	ff 75 10             	pushl  0x10(%ebp)
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	50                   	push   %eax
  801e9c:	e8 2f 01 00 00       	call   801fd0 <nsipc_bind>
  801ea1:	83 c4 10             	add    $0x10,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <shutdown>:
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	e8 f9 fe ff ff       	call   801dad <fd2sockid>
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 0f                	js     801ec7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801eb8:	83 ec 08             	sub    $0x8,%esp
  801ebb:	ff 75 0c             	pushl  0xc(%ebp)
  801ebe:	50                   	push   %eax
  801ebf:	e8 41 01 00 00       	call   802005 <nsipc_shutdown>
  801ec4:	83 c4 10             	add    $0x10,%esp
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <connect>:
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	e8 d6 fe ff ff       	call   801dad <fd2sockid>
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	78 12                	js     801eed <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	ff 75 10             	pushl  0x10(%ebp)
  801ee1:	ff 75 0c             	pushl  0xc(%ebp)
  801ee4:	50                   	push   %eax
  801ee5:	e8 57 01 00 00       	call   802041 <nsipc_connect>
  801eea:	83 c4 10             	add    $0x10,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <listen>:
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	e8 b0 fe ff ff       	call   801dad <fd2sockid>
  801efd:	85 c0                	test   %eax,%eax
  801eff:	78 0f                	js     801f10 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f01:	83 ec 08             	sub    $0x8,%esp
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	50                   	push   %eax
  801f08:	e8 69 01 00 00       	call   802076 <nsipc_listen>
  801f0d:	83 c4 10             	add    $0x10,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f18:	ff 75 10             	pushl  0x10(%ebp)
  801f1b:	ff 75 0c             	pushl  0xc(%ebp)
  801f1e:	ff 75 08             	pushl  0x8(%ebp)
  801f21:	e8 3c 02 00 00       	call   802162 <nsipc_socket>
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 05                	js     801f32 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f2d:	e8 ab fe ff ff       	call   801ddd <alloc_sockfd>
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	53                   	push   %ebx
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f3d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801f44:	74 26                	je     801f6c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f46:	6a 07                	push   $0x7
  801f48:	68 00 60 80 00       	push   $0x806000
  801f4d:	53                   	push   %ebx
  801f4e:	ff 35 04 40 80 00    	pushl  0x804004
  801f54:	e8 fe 04 00 00       	call   802457 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f59:	83 c4 0c             	add    $0xc,%esp
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	e8 87 04 00 00       	call   8023ee <ipc_recv>
}
  801f67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	6a 02                	push   $0x2
  801f71:	e8 3a 05 00 00       	call   8024b0 <ipc_find_env>
  801f76:	a3 04 40 80 00       	mov    %eax,0x804004
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	eb c6                	jmp    801f46 <nsipc+0x12>

00801f80 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	56                   	push   %esi
  801f84:	53                   	push   %ebx
  801f85:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f90:	8b 06                	mov    (%esi),%eax
  801f92:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f97:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9c:	e8 93 ff ff ff       	call   801f34 <nsipc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	78 20                	js     801fc7 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	ff 35 10 60 80 00    	pushl  0x806010
  801fb0:	68 00 60 80 00       	push   $0x806000
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	e8 46 ea ff ff       	call   800a03 <memmove>
		*addrlen = ret->ret_addrlen;
  801fbd:	a1 10 60 80 00       	mov    0x806010,%eax
  801fc2:	89 06                	mov    %eax,(%esi)
  801fc4:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801fc7:	89 d8                	mov    %ebx,%eax
  801fc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5d                   	pop    %ebp
  801fcf:	c3                   	ret    

00801fd0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	53                   	push   %ebx
  801fd4:	83 ec 08             	sub    $0x8,%esp
  801fd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fe2:	53                   	push   %ebx
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	68 04 60 80 00       	push   $0x806004
  801feb:	e8 13 ea ff ff       	call   800a03 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ff0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ff6:	b8 02 00 00 00       	mov    $0x2,%eax
  801ffb:	e8 34 ff ff ff       	call   801f34 <nsipc>
}
  802000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802013:	8b 45 0c             	mov    0xc(%ebp),%eax
  802016:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80201b:	b8 03 00 00 00       	mov    $0x3,%eax
  802020:	e8 0f ff ff ff       	call   801f34 <nsipc>
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <nsipc_close>:

int
nsipc_close(int s)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802035:	b8 04 00 00 00       	mov    $0x4,%eax
  80203a:	e8 f5 fe ff ff       	call   801f34 <nsipc>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	53                   	push   %ebx
  802045:	83 ec 08             	sub    $0x8,%esp
  802048:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802053:	53                   	push   %ebx
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	68 04 60 80 00       	push   $0x806004
  80205c:	e8 a2 e9 ff ff       	call   800a03 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802061:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802067:	b8 05 00 00 00       	mov    $0x5,%eax
  80206c:	e8 c3 fe ff ff       	call   801f34 <nsipc>
}
  802071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802084:	8b 45 0c             	mov    0xc(%ebp),%eax
  802087:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80208c:	b8 06 00 00 00       	mov    $0x6,%eax
  802091:	e8 9e fe ff ff       	call   801f34 <nsipc>
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	56                   	push   %esi
  80209c:	53                   	push   %ebx
  80209d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8020a8:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8020ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020b6:	b8 07 00 00 00       	mov    $0x7,%eax
  8020bb:	e8 74 fe ff ff       	call   801f34 <nsipc>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 1f                	js     8020e5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020c6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020cb:	7f 21                	jg     8020ee <nsipc_recv+0x56>
  8020cd:	39 c6                	cmp    %eax,%esi
  8020cf:	7c 1d                	jl     8020ee <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	50                   	push   %eax
  8020d5:	68 00 60 80 00       	push   $0x806000
  8020da:	ff 75 0c             	pushl  0xc(%ebp)
  8020dd:	e8 21 e9 ff ff       	call   800a03 <memmove>
  8020e2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020e5:	89 d8                	mov    %ebx,%eax
  8020e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ea:	5b                   	pop    %ebx
  8020eb:	5e                   	pop    %esi
  8020ec:	5d                   	pop    %ebp
  8020ed:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020ee:	68 4f 2c 80 00       	push   $0x802c4f
  8020f3:	68 f1 2b 80 00       	push   $0x802bf1
  8020f8:	6a 62                	push   $0x62
  8020fa:	68 64 2c 80 00       	push   $0x802c64
  8020ff:	e8 05 02 00 00       	call   802309 <_panic>

00802104 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	53                   	push   %ebx
  802108:	83 ec 04             	sub    $0x4,%esp
  80210b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802116:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80211c:	7f 2e                	jg     80214c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	53                   	push   %ebx
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	68 0c 60 80 00       	push   $0x80600c
  80212a:	e8 d4 e8 ff ff       	call   800a03 <memmove>
	nsipcbuf.send.req_size = size;
  80212f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802135:	8b 45 14             	mov    0x14(%ebp),%eax
  802138:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80213d:	b8 08 00 00 00       	mov    $0x8,%eax
  802142:	e8 ed fd ff ff       	call   801f34 <nsipc>
}
  802147:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    
	assert(size < 1600);
  80214c:	68 70 2c 80 00       	push   $0x802c70
  802151:	68 f1 2b 80 00       	push   $0x802bf1
  802156:	6a 6d                	push   $0x6d
  802158:	68 64 2c 80 00       	push   $0x802c64
  80215d:	e8 a7 01 00 00       	call   802309 <_panic>

00802162 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802170:	8b 45 0c             	mov    0xc(%ebp),%eax
  802173:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802178:	8b 45 10             	mov    0x10(%ebp),%eax
  80217b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802180:	b8 09 00 00 00       	mov    $0x9,%eax
  802185:	e8 aa fd ff ff       	call   801f34 <nsipc>
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    

00802196 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80219c:	68 7c 2c 80 00       	push   $0x802c7c
  8021a1:	ff 75 0c             	pushl  0xc(%ebp)
  8021a4:	e8 cc e6 ff ff       	call   800875 <strcpy>
	return 0;
}
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <devcons_write>:
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	57                   	push   %edi
  8021b4:	56                   	push   %esi
  8021b5:	53                   	push   %ebx
  8021b6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021bc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021c1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021c7:	eb 2f                	jmp    8021f8 <devcons_write+0x48>
		m = n - tot;
  8021c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021cc:	29 f3                	sub    %esi,%ebx
  8021ce:	83 fb 7f             	cmp    $0x7f,%ebx
  8021d1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021d6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	53                   	push   %ebx
  8021dd:	89 f0                	mov    %esi,%eax
  8021df:	03 45 0c             	add    0xc(%ebp),%eax
  8021e2:	50                   	push   %eax
  8021e3:	57                   	push   %edi
  8021e4:	e8 1a e8 ff ff       	call   800a03 <memmove>
		sys_cputs(buf, m);
  8021e9:	83 c4 08             	add    $0x8,%esp
  8021ec:	53                   	push   %ebx
  8021ed:	57                   	push   %edi
  8021ee:	e8 bf e9 ff ff       	call   800bb2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021f3:	01 de                	add    %ebx,%esi
  8021f5:	83 c4 10             	add    $0x10,%esp
  8021f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021fb:	72 cc                	jb     8021c9 <devcons_write+0x19>
}
  8021fd:	89 f0                	mov    %esi,%eax
  8021ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802202:	5b                   	pop    %ebx
  802203:	5e                   	pop    %esi
  802204:	5f                   	pop    %edi
  802205:	5d                   	pop    %ebp
  802206:	c3                   	ret    

00802207 <devcons_read>:
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 08             	sub    $0x8,%esp
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802212:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802216:	75 07                	jne    80221f <devcons_read+0x18>
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    
		sys_yield();
  80221a:	e8 30 ea ff ff       	call   800c4f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80221f:	e8 ac e9 ff ff       	call   800bd0 <sys_cgetc>
  802224:	85 c0                	test   %eax,%eax
  802226:	74 f2                	je     80221a <devcons_read+0x13>
	if (c < 0)
  802228:	85 c0                	test   %eax,%eax
  80222a:	78 ec                	js     802218 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80222c:	83 f8 04             	cmp    $0x4,%eax
  80222f:	74 0c                	je     80223d <devcons_read+0x36>
	*(char*)vbuf = c;
  802231:	8b 55 0c             	mov    0xc(%ebp),%edx
  802234:	88 02                	mov    %al,(%edx)
	return 1;
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	eb db                	jmp    802218 <devcons_read+0x11>
		return 0;
  80223d:	b8 00 00 00 00       	mov    $0x0,%eax
  802242:	eb d4                	jmp    802218 <devcons_read+0x11>

00802244 <cputchar>:
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802250:	6a 01                	push   $0x1
  802252:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802255:	50                   	push   %eax
  802256:	e8 57 e9 ff ff       	call   800bb2 <sys_cputs>
}
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <getchar>:
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802266:	6a 01                	push   $0x1
  802268:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80226b:	50                   	push   %eax
  80226c:	6a 00                	push   $0x0
  80226e:	e8 1e f2 ff ff       	call   801491 <read>
	if (r < 0)
  802273:	83 c4 10             	add    $0x10,%esp
  802276:	85 c0                	test   %eax,%eax
  802278:	78 08                	js     802282 <getchar+0x22>
	if (r < 1)
  80227a:	85 c0                	test   %eax,%eax
  80227c:	7e 06                	jle    802284 <getchar+0x24>
	return c;
  80227e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    
		return -E_EOF;
  802284:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802289:	eb f7                	jmp    802282 <getchar+0x22>

0080228b <iscons>:
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802291:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802294:	50                   	push   %eax
  802295:	ff 75 08             	pushl  0x8(%ebp)
  802298:	e8 83 ef ff ff       	call   801220 <fd_lookup>
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	78 11                	js     8022b5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022ad:	39 10                	cmp    %edx,(%eax)
  8022af:	0f 94 c0             	sete   %al
  8022b2:	0f b6 c0             	movzbl %al,%eax
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <opencons>:
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c0:	50                   	push   %eax
  8022c1:	e8 0b ef ff ff       	call   8011d1 <fd_alloc>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 3a                	js     802307 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	68 07 04 00 00       	push   $0x407
  8022d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d8:	6a 00                	push   $0x0
  8022da:	e8 8f e9 ff ff       	call   800c6e <sys_page_alloc>
  8022df:	83 c4 10             	add    $0x10,%esp
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	78 21                	js     802307 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022ef:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022fb:	83 ec 0c             	sub    $0xc,%esp
  8022fe:	50                   	push   %eax
  8022ff:	e8 a6 ee ff ff       	call   8011aa <fd2num>
  802304:	83 c4 10             	add    $0x10,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80230e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802311:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802317:	e8 14 e9 ff ff       	call   800c30 <sys_getenvid>
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	ff 75 08             	pushl  0x8(%ebp)
  802325:	56                   	push   %esi
  802326:	50                   	push   %eax
  802327:	68 88 2c 80 00       	push   $0x802c88
  80232c:	e8 a7 de ff ff       	call   8001d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802331:	83 c4 18             	add    $0x18,%esp
  802334:	53                   	push   %ebx
  802335:	ff 75 10             	pushl  0x10(%ebp)
  802338:	e8 4a de ff ff       	call   800187 <vcprintf>
	cprintf("\n");
  80233d:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  802344:	e8 8f de ff ff       	call   8001d8 <cprintf>
  802349:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80234c:	cc                   	int3   
  80234d:	eb fd                	jmp    80234c <_panic+0x43>

0080234f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802355:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80235c:	74 0a                	je     802368 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802368:	a1 08 40 80 00       	mov    0x804008,%eax
  80236d:	8b 40 48             	mov    0x48(%eax),%eax
  802370:	83 ec 04             	sub    $0x4,%esp
  802373:	6a 07                	push   $0x7
  802375:	68 00 f0 bf ee       	push   $0xeebff000
  80237a:	50                   	push   %eax
  80237b:	e8 ee e8 ff ff       	call   800c6e <sys_page_alloc>
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	85 c0                	test   %eax,%eax
  802385:	75 2f                	jne    8023b6 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802387:	a1 08 40 80 00       	mov    0x804008,%eax
  80238c:	8b 40 48             	mov    0x48(%eax),%eax
  80238f:	83 ec 08             	sub    $0x8,%esp
  802392:	68 c8 23 80 00       	push   $0x8023c8
  802397:	50                   	push   %eax
  802398:	e8 1c ea ff ff       	call   800db9 <sys_env_set_pgfault_upcall>
  80239d:	83 c4 10             	add    $0x10,%esp
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	74 ba                	je     80235e <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8023a4:	50                   	push   %eax
  8023a5:	68 ac 2c 80 00       	push   $0x802cac
  8023aa:	6a 24                	push   $0x24
  8023ac:	68 c4 2c 80 00       	push   $0x802cc4
  8023b1:	e8 53 ff ff ff       	call   802309 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8023b6:	50                   	push   %eax
  8023b7:	68 ac 2c 80 00       	push   $0x802cac
  8023bc:	6a 21                	push   $0x21
  8023be:	68 c4 2c 80 00       	push   $0x802cc4
  8023c3:	e8 41 ff ff ff       	call   802309 <_panic>

008023c8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023c8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023c9:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8023ce:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023d0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8023d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8023d7:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8023da:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8023de:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8023e2:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8023e4:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  8023e7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8023e8:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8023eb:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8023ec:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8023ed:	c3                   	ret    

008023ee <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	56                   	push   %esi
  8023f2:	53                   	push   %ebx
  8023f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8023f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8023fc:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8023fe:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802403:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	50                   	push   %eax
  80240a:	e8 0f ea ff ff       	call   800e1e <sys_ipc_recv>
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	85 c0                	test   %eax,%eax
  802414:	78 2b                	js     802441 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802416:	85 f6                	test   %esi,%esi
  802418:	74 0a                	je     802424 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80241a:	a1 08 40 80 00       	mov    0x804008,%eax
  80241f:	8b 40 74             	mov    0x74(%eax),%eax
  802422:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802424:	85 db                	test   %ebx,%ebx
  802426:	74 0a                	je     802432 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802428:	a1 08 40 80 00       	mov    0x804008,%eax
  80242d:	8b 40 78             	mov    0x78(%eax),%eax
  802430:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802432:	a1 08 40 80 00       	mov    0x804008,%eax
  802437:	8b 40 70             	mov    0x70(%eax),%eax
}
  80243a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80243d:	5b                   	pop    %ebx
  80243e:	5e                   	pop    %esi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
	    if (from_env_store != NULL) {
  802441:	85 f6                	test   %esi,%esi
  802443:	74 06                	je     80244b <ipc_recv+0x5d>
	        *from_env_store = 0;
  802445:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80244b:	85 db                	test   %ebx,%ebx
  80244d:	74 eb                	je     80243a <ipc_recv+0x4c>
	        *perm_store = 0;
  80244f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802455:	eb e3                	jmp    80243a <ipc_recv+0x4c>

00802457 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	57                   	push   %edi
  80245b:	56                   	push   %esi
  80245c:	53                   	push   %ebx
  80245d:	83 ec 0c             	sub    $0xc,%esp
  802460:	8b 7d 08             	mov    0x8(%ebp),%edi
  802463:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802466:	85 f6                	test   %esi,%esi
  802468:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80246d:	0f 44 f0             	cmove  %eax,%esi
  802470:	eb 09                	jmp    80247b <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802472:	e8 d8 e7 ff ff       	call   800c4f <sys_yield>
	} while(r != 0);
  802477:	85 db                	test   %ebx,%ebx
  802479:	74 2d                	je     8024a8 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80247b:	ff 75 14             	pushl  0x14(%ebp)
  80247e:	56                   	push   %esi
  80247f:	ff 75 0c             	pushl  0xc(%ebp)
  802482:	57                   	push   %edi
  802483:	e8 73 e9 ff ff       	call   800dfb <sys_ipc_try_send>
  802488:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80248a:	83 c4 10             	add    $0x10,%esp
  80248d:	85 c0                	test   %eax,%eax
  80248f:	79 e1                	jns    802472 <ipc_send+0x1b>
  802491:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802494:	74 dc                	je     802472 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802496:	50                   	push   %eax
  802497:	68 d2 2c 80 00       	push   $0x802cd2
  80249c:	6a 45                	push   $0x45
  80249e:	68 df 2c 80 00       	push   $0x802cdf
  8024a3:	e8 61 fe ff ff       	call   802309 <_panic>
}
  8024a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    

008024b0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024bb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024be:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024c4:	8b 52 50             	mov    0x50(%edx),%edx
  8024c7:	39 ca                	cmp    %ecx,%edx
  8024c9:	74 11                	je     8024dc <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8024cb:	83 c0 01             	add    $0x1,%eax
  8024ce:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024d3:	75 e6                	jne    8024bb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024da:	eb 0b                	jmp    8024e7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8024dc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024e4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024e7:	5d                   	pop    %ebp
  8024e8:	c3                   	ret    

008024e9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024ef:	89 d0                	mov    %edx,%eax
  8024f1:	c1 e8 16             	shr    $0x16,%eax
  8024f4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802500:	f6 c1 01             	test   $0x1,%cl
  802503:	74 1d                	je     802522 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802505:	c1 ea 0c             	shr    $0xc,%edx
  802508:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80250f:	f6 c2 01             	test   $0x1,%dl
  802512:	74 0e                	je     802522 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802514:	c1 ea 0c             	shr    $0xc,%edx
  802517:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80251e:	ef 
  80251f:	0f b7 c0             	movzwl %ax,%eax
}
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
  802524:	66 90                	xchg   %ax,%ax
  802526:	66 90                	xchg   %ax,%ax
  802528:	66 90                	xchg   %ax,%ax
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <__udivdi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	53                   	push   %ebx
  802534:	83 ec 1c             	sub    $0x1c,%esp
  802537:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80253b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80253f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802543:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802547:	85 d2                	test   %edx,%edx
  802549:	75 35                	jne    802580 <__udivdi3+0x50>
  80254b:	39 f3                	cmp    %esi,%ebx
  80254d:	0f 87 bd 00 00 00    	ja     802610 <__udivdi3+0xe0>
  802553:	85 db                	test   %ebx,%ebx
  802555:	89 d9                	mov    %ebx,%ecx
  802557:	75 0b                	jne    802564 <__udivdi3+0x34>
  802559:	b8 01 00 00 00       	mov    $0x1,%eax
  80255e:	31 d2                	xor    %edx,%edx
  802560:	f7 f3                	div    %ebx
  802562:	89 c1                	mov    %eax,%ecx
  802564:	31 d2                	xor    %edx,%edx
  802566:	89 f0                	mov    %esi,%eax
  802568:	f7 f1                	div    %ecx
  80256a:	89 c6                	mov    %eax,%esi
  80256c:	89 e8                	mov    %ebp,%eax
  80256e:	89 f7                	mov    %esi,%edi
  802570:	f7 f1                	div    %ecx
  802572:	89 fa                	mov    %edi,%edx
  802574:	83 c4 1c             	add    $0x1c,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5f                   	pop    %edi
  80257a:	5d                   	pop    %ebp
  80257b:	c3                   	ret    
  80257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802580:	39 f2                	cmp    %esi,%edx
  802582:	77 7c                	ja     802600 <__udivdi3+0xd0>
  802584:	0f bd fa             	bsr    %edx,%edi
  802587:	83 f7 1f             	xor    $0x1f,%edi
  80258a:	0f 84 98 00 00 00    	je     802628 <__udivdi3+0xf8>
  802590:	89 f9                	mov    %edi,%ecx
  802592:	b8 20 00 00 00       	mov    $0x20,%eax
  802597:	29 f8                	sub    %edi,%eax
  802599:	d3 e2                	shl    %cl,%edx
  80259b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80259f:	89 c1                	mov    %eax,%ecx
  8025a1:	89 da                	mov    %ebx,%edx
  8025a3:	d3 ea                	shr    %cl,%edx
  8025a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025a9:	09 d1                	or     %edx,%ecx
  8025ab:	89 f2                	mov    %esi,%edx
  8025ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b1:	89 f9                	mov    %edi,%ecx
  8025b3:	d3 e3                	shl    %cl,%ebx
  8025b5:	89 c1                	mov    %eax,%ecx
  8025b7:	d3 ea                	shr    %cl,%edx
  8025b9:	89 f9                	mov    %edi,%ecx
  8025bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025bf:	d3 e6                	shl    %cl,%esi
  8025c1:	89 eb                	mov    %ebp,%ebx
  8025c3:	89 c1                	mov    %eax,%ecx
  8025c5:	d3 eb                	shr    %cl,%ebx
  8025c7:	09 de                	or     %ebx,%esi
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	f7 74 24 08          	divl   0x8(%esp)
  8025cf:	89 d6                	mov    %edx,%esi
  8025d1:	89 c3                	mov    %eax,%ebx
  8025d3:	f7 64 24 0c          	mull   0xc(%esp)
  8025d7:	39 d6                	cmp    %edx,%esi
  8025d9:	72 0c                	jb     8025e7 <__udivdi3+0xb7>
  8025db:	89 f9                	mov    %edi,%ecx
  8025dd:	d3 e5                	shl    %cl,%ebp
  8025df:	39 c5                	cmp    %eax,%ebp
  8025e1:	73 5d                	jae    802640 <__udivdi3+0x110>
  8025e3:	39 d6                	cmp    %edx,%esi
  8025e5:	75 59                	jne    802640 <__udivdi3+0x110>
  8025e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025ea:	31 ff                	xor    %edi,%edi
  8025ec:	89 fa                	mov    %edi,%edx
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	8d 76 00             	lea    0x0(%esi),%esi
  8025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802600:	31 ff                	xor    %edi,%edi
  802602:	31 c0                	xor    %eax,%eax
  802604:	89 fa                	mov    %edi,%edx
  802606:	83 c4 1c             	add    $0x1c,%esp
  802609:	5b                   	pop    %ebx
  80260a:	5e                   	pop    %esi
  80260b:	5f                   	pop    %edi
  80260c:	5d                   	pop    %ebp
  80260d:	c3                   	ret    
  80260e:	66 90                	xchg   %ax,%ax
  802610:	31 ff                	xor    %edi,%edi
  802612:	89 e8                	mov    %ebp,%eax
  802614:	89 f2                	mov    %esi,%edx
  802616:	f7 f3                	div    %ebx
  802618:	89 fa                	mov    %edi,%edx
  80261a:	83 c4 1c             	add    $0x1c,%esp
  80261d:	5b                   	pop    %ebx
  80261e:	5e                   	pop    %esi
  80261f:	5f                   	pop    %edi
  802620:	5d                   	pop    %ebp
  802621:	c3                   	ret    
  802622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	72 06                	jb     802632 <__udivdi3+0x102>
  80262c:	31 c0                	xor    %eax,%eax
  80262e:	39 eb                	cmp    %ebp,%ebx
  802630:	77 d2                	ja     802604 <__udivdi3+0xd4>
  802632:	b8 01 00 00 00       	mov    $0x1,%eax
  802637:	eb cb                	jmp    802604 <__udivdi3+0xd4>
  802639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802640:	89 d8                	mov    %ebx,%eax
  802642:	31 ff                	xor    %edi,%edi
  802644:	eb be                	jmp    802604 <__udivdi3+0xd4>
  802646:	66 90                	xchg   %ax,%ax
  802648:	66 90                	xchg   %ax,%ax
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__umoddi3>:
  802650:	55                   	push   %ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	53                   	push   %ebx
  802654:	83 ec 1c             	sub    $0x1c,%esp
  802657:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80265b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80265f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802663:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802667:	85 ed                	test   %ebp,%ebp
  802669:	89 f0                	mov    %esi,%eax
  80266b:	89 da                	mov    %ebx,%edx
  80266d:	75 19                	jne    802688 <__umoddi3+0x38>
  80266f:	39 df                	cmp    %ebx,%edi
  802671:	0f 86 b1 00 00 00    	jbe    802728 <__umoddi3+0xd8>
  802677:	f7 f7                	div    %edi
  802679:	89 d0                	mov    %edx,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	39 dd                	cmp    %ebx,%ebp
  80268a:	77 f1                	ja     80267d <__umoddi3+0x2d>
  80268c:	0f bd cd             	bsr    %ebp,%ecx
  80268f:	83 f1 1f             	xor    $0x1f,%ecx
  802692:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802696:	0f 84 b4 00 00 00    	je     802750 <__umoddi3+0x100>
  80269c:	b8 20 00 00 00       	mov    $0x20,%eax
  8026a1:	89 c2                	mov    %eax,%edx
  8026a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026a7:	29 c2                	sub    %eax,%edx
  8026a9:	89 c1                	mov    %eax,%ecx
  8026ab:	89 f8                	mov    %edi,%eax
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	89 d1                	mov    %edx,%ecx
  8026b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026b5:	d3 e8                	shr    %cl,%eax
  8026b7:	09 c5                	or     %eax,%ebp
  8026b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	d3 e7                	shl    %cl,%edi
  8026c1:	89 d1                	mov    %edx,%ecx
  8026c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026c7:	89 df                	mov    %ebx,%edi
  8026c9:	d3 ef                	shr    %cl,%edi
  8026cb:	89 c1                	mov    %eax,%ecx
  8026cd:	89 f0                	mov    %esi,%eax
  8026cf:	d3 e3                	shl    %cl,%ebx
  8026d1:	89 d1                	mov    %edx,%ecx
  8026d3:	89 fa                	mov    %edi,%edx
  8026d5:	d3 e8                	shr    %cl,%eax
  8026d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026dc:	09 d8                	or     %ebx,%eax
  8026de:	f7 f5                	div    %ebp
  8026e0:	d3 e6                	shl    %cl,%esi
  8026e2:	89 d1                	mov    %edx,%ecx
  8026e4:	f7 64 24 08          	mull   0x8(%esp)
  8026e8:	39 d1                	cmp    %edx,%ecx
  8026ea:	89 c3                	mov    %eax,%ebx
  8026ec:	89 d7                	mov    %edx,%edi
  8026ee:	72 06                	jb     8026f6 <__umoddi3+0xa6>
  8026f0:	75 0e                	jne    802700 <__umoddi3+0xb0>
  8026f2:	39 c6                	cmp    %eax,%esi
  8026f4:	73 0a                	jae    802700 <__umoddi3+0xb0>
  8026f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026fa:	19 ea                	sbb    %ebp,%edx
  8026fc:	89 d7                	mov    %edx,%edi
  8026fe:	89 c3                	mov    %eax,%ebx
  802700:	89 ca                	mov    %ecx,%edx
  802702:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802707:	29 de                	sub    %ebx,%esi
  802709:	19 fa                	sbb    %edi,%edx
  80270b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80270f:	89 d0                	mov    %edx,%eax
  802711:	d3 e0                	shl    %cl,%eax
  802713:	89 d9                	mov    %ebx,%ecx
  802715:	d3 ee                	shr    %cl,%esi
  802717:	d3 ea                	shr    %cl,%edx
  802719:	09 f0                	or     %esi,%eax
  80271b:	83 c4 1c             	add    $0x1c,%esp
  80271e:	5b                   	pop    %ebx
  80271f:	5e                   	pop    %esi
  802720:	5f                   	pop    %edi
  802721:	5d                   	pop    %ebp
  802722:	c3                   	ret    
  802723:	90                   	nop
  802724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802728:	85 ff                	test   %edi,%edi
  80272a:	89 f9                	mov    %edi,%ecx
  80272c:	75 0b                	jne    802739 <__umoddi3+0xe9>
  80272e:	b8 01 00 00 00       	mov    $0x1,%eax
  802733:	31 d2                	xor    %edx,%edx
  802735:	f7 f7                	div    %edi
  802737:	89 c1                	mov    %eax,%ecx
  802739:	89 d8                	mov    %ebx,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	f7 f1                	div    %ecx
  80273f:	89 f0                	mov    %esi,%eax
  802741:	f7 f1                	div    %ecx
  802743:	e9 31 ff ff ff       	jmp    802679 <__umoddi3+0x29>
  802748:	90                   	nop
  802749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802750:	39 dd                	cmp    %ebx,%ebp
  802752:	72 08                	jb     80275c <__umoddi3+0x10c>
  802754:	39 f7                	cmp    %esi,%edi
  802756:	0f 87 21 ff ff ff    	ja     80267d <__umoddi3+0x2d>
  80275c:	89 da                	mov    %ebx,%edx
  80275e:	89 f0                	mov    %esi,%eax
  802760:	29 f8                	sub    %edi,%eax
  802762:	19 ea                	sbb    %ebp,%edx
  802764:	e9 14 ff ff ff       	jmp    80267d <__umoddi3+0x2d>
