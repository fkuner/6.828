
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 6f 11 00 00       	call   8011b0 <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 72 11 00 00       	call   8011ca <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 08 40 80 00       	mov    0x804008,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 df 0b 00 00       	call   800c50 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 d0 27 80 00       	push   $0x8027d0
  800080:	e8 73 01 00 00       	call   8001f8 <cprintf>
		if (val == 10)
  800085:	a1 08 40 80 00       	mov    0x804008,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 08 40 80 00       	mov    %eax,0x804008
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 8b 11 00 00       	call   801233 <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 08 40 80 00 0a 	cmpl   $0xa,0x804008
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  8000c2:	e8 89 0b 00 00       	call   800c50 <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 a0 27 80 00       	push   $0x8027a0
  8000d1:	e8 22 01 00 00       	call   8001f8 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 72 0b 00 00       	call   800c50 <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 ba 27 80 00       	push   $0x8027ba
  8000e8:	e8 0b 01 00 00       	call   8001f8 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 38 11 00 00       	call   801233 <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80010e:	e8 3d 0b 00 00       	call   800c50 <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 db                	test   %ebx,%ebx
  800127:	7e 07                	jle    800130 <libmain+0x2d>
		binaryname = argv[0];
  800129:	8b 06                	mov    (%esi),%eax
  80012b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0a 00 00 00       	call   800149 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80014f:	e8 47 13 00 00       	call   80149b <close_all>
	sys_env_destroy(0);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	6a 00                	push   $0x0
  800159:	e8 b1 0a 00 00       	call   800c0f <sys_env_destroy>
}
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	53                   	push   %ebx
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016d:	8b 13                	mov    (%ebx),%edx
  80016f:	8d 42 01             	lea    0x1(%edx),%eax
  800172:	89 03                	mov    %eax,(%ebx)
  800174:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800177:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800180:	74 09                	je     80018b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800182:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800189:	c9                   	leave  
  80018a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	68 ff 00 00 00       	push   $0xff
  800193:	8d 43 08             	lea    0x8(%ebx),%eax
  800196:	50                   	push   %eax
  800197:	e8 36 0a 00 00       	call   800bd2 <sys_cputs>
		b->idx = 0;
  80019c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	eb db                	jmp    800182 <putch+0x1f>

008001a7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b7:	00 00 00 
	b.cnt = 0;
  8001ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c4:	ff 75 0c             	pushl  0xc(%ebp)
  8001c7:	ff 75 08             	pushl  0x8(%ebp)
  8001ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	68 63 01 80 00       	push   $0x800163
  8001d6:	e8 1a 01 00 00       	call   8002f5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001db:	83 c4 08             	add    $0x8,%esp
  8001de:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 e2 09 00 00       	call   800bd2 <sys_cputs>

	return b.cnt;
}
  8001f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f6:	c9                   	leave  
  8001f7:	c3                   	ret    

008001f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 9d ff ff ff       	call   8001a7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c7                	mov    %eax,%edi
  800217:	89 d6                	mov    %edx,%esi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800222:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800230:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800233:	39 d3                	cmp    %edx,%ebx
  800235:	72 05                	jb     80023c <printnum+0x30>
  800237:	39 45 10             	cmp    %eax,0x10(%ebp)
  80023a:	77 7a                	ja     8002b6 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	ff 75 18             	pushl  0x18(%ebp)
  800242:	8b 45 14             	mov    0x14(%ebp),%eax
  800245:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800248:	53                   	push   %ebx
  800249:	ff 75 10             	pushl  0x10(%ebp)
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800252:	ff 75 e0             	pushl  -0x20(%ebp)
  800255:	ff 75 dc             	pushl  -0x24(%ebp)
  800258:	ff 75 d8             	pushl  -0x28(%ebp)
  80025b:	e8 f0 22 00 00       	call   802550 <__udivdi3>
  800260:	83 c4 18             	add    $0x18,%esp
  800263:	52                   	push   %edx
  800264:	50                   	push   %eax
  800265:	89 f2                	mov    %esi,%edx
  800267:	89 f8                	mov    %edi,%eax
  800269:	e8 9e ff ff ff       	call   80020c <printnum>
  80026e:	83 c4 20             	add    $0x20,%esp
  800271:	eb 13                	jmp    800286 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	56                   	push   %esi
  800277:	ff 75 18             	pushl  0x18(%ebp)
  80027a:	ff d7                	call   *%edi
  80027c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027f:	83 eb 01             	sub    $0x1,%ebx
  800282:	85 db                	test   %ebx,%ebx
  800284:	7f ed                	jg     800273 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	56                   	push   %esi
  80028a:	83 ec 04             	sub    $0x4,%esp
  80028d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800290:	ff 75 e0             	pushl  -0x20(%ebp)
  800293:	ff 75 dc             	pushl  -0x24(%ebp)
  800296:	ff 75 d8             	pushl  -0x28(%ebp)
  800299:	e8 d2 23 00 00       	call   802670 <__umoddi3>
  80029e:	83 c4 14             	add    $0x14,%esp
  8002a1:	0f be 80 00 28 80 00 	movsbl 0x802800(%eax),%eax
  8002a8:	50                   	push   %eax
  8002a9:	ff d7                	call   *%edi
}
  8002ab:	83 c4 10             	add    $0x10,%esp
  8002ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b1:	5b                   	pop    %ebx
  8002b2:	5e                   	pop    %esi
  8002b3:	5f                   	pop    %edi
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    
  8002b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b9:	eb c4                	jmp    80027f <printnum+0x73>

008002bb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ca:	73 0a                	jae    8002d6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cf:	89 08                	mov    %ecx,(%eax)
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	88 02                	mov    %al,(%edx)
}
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    

008002d8 <printfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002de:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e1:	50                   	push   %eax
  8002e2:	ff 75 10             	pushl  0x10(%ebp)
  8002e5:	ff 75 0c             	pushl  0xc(%ebp)
  8002e8:	ff 75 08             	pushl  0x8(%ebp)
  8002eb:	e8 05 00 00 00       	call   8002f5 <vprintfmt>
}
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <vprintfmt>:
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 2c             	sub    $0x2c,%esp
  8002fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800301:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800304:	8b 7d 10             	mov    0x10(%ebp),%edi
  800307:	e9 21 04 00 00       	jmp    80072d <vprintfmt+0x438>
		padc = ' ';
  80030c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800310:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800317:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80031e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800325:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8d 47 01             	lea    0x1(%edi),%eax
  80032d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800330:	0f b6 17             	movzbl (%edi),%edx
  800333:	8d 42 dd             	lea    -0x23(%edx),%eax
  800336:	3c 55                	cmp    $0x55,%al
  800338:	0f 87 90 04 00 00    	ja     8007ce <vprintfmt+0x4d9>
  80033e:	0f b6 c0             	movzbl %al,%eax
  800341:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  800348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80034f:	eb d9                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800354:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800358:	eb d0                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	0f b6 d2             	movzbl %dl,%edx
  80035d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800368:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800372:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800375:	83 f9 09             	cmp    $0x9,%ecx
  800378:	77 55                	ja     8003cf <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80037a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80037d:	eb e9                	jmp    800368 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8d 40 04             	lea    0x4(%eax),%eax
  80038d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800393:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800397:	79 91                	jns    80032a <vprintfmt+0x35>
				width = precision, precision = -1;
  800399:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a6:	eb 82                	jmp    80032a <vprintfmt+0x35>
  8003a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b2:	0f 49 d0             	cmovns %eax,%edx
  8003b5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003bb:	e9 6a ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ca:	e9 5b ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003cf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003d5:	eb bc                	jmp    800393 <vprintfmt+0x9e>
			lflag++;
  8003d7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003dd:	e9 48 ff ff ff       	jmp    80032a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8d 78 04             	lea    0x4(%eax),%edi
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	53                   	push   %ebx
  8003ec:	ff 30                	pushl  (%eax)
  8003ee:	ff d6                	call   *%esi
			break;
  8003f0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f6:	e9 2f 03 00 00       	jmp    80072a <vprintfmt+0x435>
			err = va_arg(ap, int);
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 78 04             	lea    0x4(%eax),%edi
  800401:	8b 00                	mov    (%eax),%eax
  800403:	99                   	cltd   
  800404:	31 d0                	xor    %edx,%eax
  800406:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800408:	83 f8 0f             	cmp    $0xf,%eax
  80040b:	7f 23                	jg     800430 <vprintfmt+0x13b>
  80040d:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  800414:	85 d2                	test   %edx,%edx
  800416:	74 18                	je     800430 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800418:	52                   	push   %edx
  800419:	68 77 2c 80 00       	push   $0x802c77
  80041e:	53                   	push   %ebx
  80041f:	56                   	push   %esi
  800420:	e8 b3 fe ff ff       	call   8002d8 <printfmt>
  800425:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800428:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042b:	e9 fa 02 00 00       	jmp    80072a <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800430:	50                   	push   %eax
  800431:	68 18 28 80 00       	push   $0x802818
  800436:	53                   	push   %ebx
  800437:	56                   	push   %esi
  800438:	e8 9b fe ff ff       	call   8002d8 <printfmt>
  80043d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800440:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800443:	e9 e2 02 00 00       	jmp    80072a <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	83 c0 04             	add    $0x4,%eax
  80044e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800456:	85 ff                	test   %edi,%edi
  800458:	b8 11 28 80 00       	mov    $0x802811,%eax
  80045d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800460:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800464:	0f 8e bd 00 00 00    	jle    800527 <vprintfmt+0x232>
  80046a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80046e:	75 0e                	jne    80047e <vprintfmt+0x189>
  800470:	89 75 08             	mov    %esi,0x8(%ebp)
  800473:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800476:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800479:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80047c:	eb 6d                	jmp    8004eb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 d0             	pushl  -0x30(%ebp)
  800484:	57                   	push   %edi
  800485:	e8 ec 03 00 00       	call   800876 <strnlen>
  80048a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048d:	29 c1                	sub    %eax,%ecx
  80048f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800492:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800495:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800499:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80049f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	eb 0f                	jmp    8004b2 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004aa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	83 ef 01             	sub    $0x1,%edi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	85 ff                	test   %edi,%edi
  8004b4:	7f ed                	jg     8004a3 <vprintfmt+0x1ae>
  8004b6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004bc:	85 c9                	test   %ecx,%ecx
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	0f 49 c1             	cmovns %ecx,%eax
  8004c6:	29 c1                	sub    %eax,%ecx
  8004c8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ce:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d1:	89 cb                	mov    %ecx,%ebx
  8004d3:	eb 16                	jmp    8004eb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d9:	75 31                	jne    80050c <vprintfmt+0x217>
					putch(ch, putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	ff 75 0c             	pushl  0xc(%ebp)
  8004e1:	50                   	push   %eax
  8004e2:	ff 55 08             	call   *0x8(%ebp)
  8004e5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e8:	83 eb 01             	sub    $0x1,%ebx
  8004eb:	83 c7 01             	add    $0x1,%edi
  8004ee:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004f2:	0f be c2             	movsbl %dl,%eax
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	74 59                	je     800552 <vprintfmt+0x25d>
  8004f9:	85 f6                	test   %esi,%esi
  8004fb:	78 d8                	js     8004d5 <vprintfmt+0x1e0>
  8004fd:	83 ee 01             	sub    $0x1,%esi
  800500:	79 d3                	jns    8004d5 <vprintfmt+0x1e0>
  800502:	89 df                	mov    %ebx,%edi
  800504:	8b 75 08             	mov    0x8(%ebp),%esi
  800507:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050a:	eb 37                	jmp    800543 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80050c:	0f be d2             	movsbl %dl,%edx
  80050f:	83 ea 20             	sub    $0x20,%edx
  800512:	83 fa 5e             	cmp    $0x5e,%edx
  800515:	76 c4                	jbe    8004db <vprintfmt+0x1e6>
					putch('?', putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	ff 75 0c             	pushl  0xc(%ebp)
  80051d:	6a 3f                	push   $0x3f
  80051f:	ff 55 08             	call   *0x8(%ebp)
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	eb c1                	jmp    8004e8 <vprintfmt+0x1f3>
  800527:	89 75 08             	mov    %esi,0x8(%ebp)
  80052a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80052d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800530:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800533:	eb b6                	jmp    8004eb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 20                	push   $0x20
  80053b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053d:	83 ef 01             	sub    $0x1,%edi
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	85 ff                	test   %edi,%edi
  800545:	7f ee                	jg     800535 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	e9 d8 01 00 00       	jmp    80072a <vprintfmt+0x435>
  800552:	89 df                	mov    %ebx,%edi
  800554:	8b 75 08             	mov    0x8(%ebp),%esi
  800557:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055a:	eb e7                	jmp    800543 <vprintfmt+0x24e>
	if (lflag >= 2)
  80055c:	83 f9 01             	cmp    $0x1,%ecx
  80055f:	7e 45                	jle    8005a6 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8b 50 04             	mov    0x4(%eax),%edx
  800567:	8b 00                	mov    (%eax),%eax
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 08             	lea    0x8(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800578:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80057c:	79 62                	jns    8005e0 <vprintfmt+0x2eb>
				putch('-', putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	53                   	push   %ebx
  800582:	6a 2d                	push   $0x2d
  800584:	ff d6                	call   *%esi
				num = -(long long) num;
  800586:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800589:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058c:	f7 d8                	neg    %eax
  80058e:	83 d2 00             	adc    $0x0,%edx
  800591:	f7 da                	neg    %edx
  800593:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800596:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800599:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059c:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005a1:	e9 66 01 00 00       	jmp    80070c <vprintfmt+0x417>
	else if (lflag)
  8005a6:	85 c9                	test   %ecx,%ecx
  8005a8:	75 1b                	jne    8005c5 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b2:	89 c1                	mov    %eax,%ecx
  8005b4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 04             	lea    0x4(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c3:	eb b3                	jmp    800578 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cd:	89 c1                	mov    %eax,%ecx
  8005cf:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	eb 98                	jmp    800578 <vprintfmt+0x283>
			base = 10;
  8005e0:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005e5:	e9 22 01 00 00       	jmp    80070c <vprintfmt+0x417>
	if (lflag >= 2)
  8005ea:	83 f9 01             	cmp    $0x1,%ecx
  8005ed:	7e 21                	jle    800610 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 50 04             	mov    0x4(%eax),%edx
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	ba 0a 00 00 00       	mov    $0xa,%edx
  80060b:	e9 fc 00 00 00       	jmp    80070c <vprintfmt+0x417>
	else if (lflag)
  800610:	85 c9                	test   %ecx,%ecx
  800612:	75 23                	jne    800637 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	ba 00 00 00 00       	mov    $0x0,%edx
  80061e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800621:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800632:	e9 d5 00 00 00       	jmp    80070c <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800650:	ba 0a 00 00 00       	mov    $0xa,%edx
  800655:	e9 b2 00 00 00       	jmp    80070c <vprintfmt+0x417>
	if (lflag >= 2)
  80065a:	83 f9 01             	cmp    $0x1,%ecx
  80065d:	7e 42                	jle    8006a1 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 50 04             	mov    0x4(%eax),%edx
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 40 08             	lea    0x8(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800676:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  80067b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067f:	0f 89 87 00 00 00    	jns    80070c <vprintfmt+0x417>
				putch('-', putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 2d                	push   $0x2d
  80068b:	ff d6                	call   *%esi
				num = -(long long) num;
  80068d:	f7 5d d8             	negl   -0x28(%ebp)
  800690:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800694:	f7 5d dc             	negl   -0x24(%ebp)
  800697:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80069a:	ba 08 00 00 00       	mov    $0x8,%edx
  80069f:	eb 6b                	jmp    80070c <vprintfmt+0x417>
	else if (lflag)
  8006a1:	85 c9                	test   %ecx,%ecx
  8006a3:	75 1b                	jne    8006c0 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 04             	lea    0x4(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006be:	eb b6                	jmp    800676 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 40 04             	lea    0x4(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d9:	eb 9b                	jmp    800676 <vprintfmt+0x381>
			putch('0', putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	6a 30                	push   $0x30
  8006e1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006e3:	83 c4 08             	add    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	6a 78                	push   $0x78
  8006e9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006fb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800707:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80070c:	83 ec 0c             	sub    $0xc,%esp
  80070f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	ff 75 e0             	pushl  -0x20(%ebp)
  800717:	52                   	push   %edx
  800718:	ff 75 dc             	pushl  -0x24(%ebp)
  80071b:	ff 75 d8             	pushl  -0x28(%ebp)
  80071e:	89 da                	mov    %ebx,%edx
  800720:	89 f0                	mov    %esi,%eax
  800722:	e8 e5 fa ff ff       	call   80020c <printnum>
			break;
  800727:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80072a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072d:	83 c7 01             	add    $0x1,%edi
  800730:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800734:	83 f8 25             	cmp    $0x25,%eax
  800737:	0f 84 cf fb ff ff    	je     80030c <vprintfmt+0x17>
			if (ch == '\0')
  80073d:	85 c0                	test   %eax,%eax
  80073f:	0f 84 a9 00 00 00    	je     8007ee <vprintfmt+0x4f9>
			putch(ch, putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	53                   	push   %ebx
  800749:	50                   	push   %eax
  80074a:	ff d6                	call   *%esi
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	eb dc                	jmp    80072d <vprintfmt+0x438>
	if (lflag >= 2)
  800751:	83 f9 01             	cmp    $0x1,%ecx
  800754:	7e 1e                	jle    800774 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 50 04             	mov    0x4(%eax),%edx
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800761:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 40 08             	lea    0x8(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076d:	ba 10 00 00 00       	mov    $0x10,%edx
  800772:	eb 98                	jmp    80070c <vprintfmt+0x417>
	else if (lflag)
  800774:	85 c9                	test   %ecx,%ecx
  800776:	75 23                	jne    80079b <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	ba 00 00 00 00       	mov    $0x0,%edx
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800785:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800791:	ba 10 00 00 00       	mov    $0x10,%edx
  800796:	e9 71 ff ff ff       	jmp    80070c <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b4:	ba 10 00 00 00       	mov    $0x10,%edx
  8007b9:	e9 4e ff ff ff       	jmp    80070c <vprintfmt+0x417>
			putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	6a 25                	push   $0x25
  8007c4:	ff d6                	call   *%esi
			break;
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	e9 5c ff ff ff       	jmp    80072a <vprintfmt+0x435>
			putch('%', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	53                   	push   %ebx
  8007d2:	6a 25                	push   $0x25
  8007d4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	89 f8                	mov    %edi,%eax
  8007db:	eb 03                	jmp    8007e0 <vprintfmt+0x4eb>
  8007dd:	83 e8 01             	sub    $0x1,%eax
  8007e0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007e4:	75 f7                	jne    8007dd <vprintfmt+0x4e8>
  8007e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e9:	e9 3c ff ff ff       	jmp    80072a <vprintfmt+0x435>
}
  8007ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f1:	5b                   	pop    %ebx
  8007f2:	5e                   	pop    %esi
  8007f3:	5f                   	pop    %edi
  8007f4:	5d                   	pop    %ebp
  8007f5:	c3                   	ret    

008007f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	83 ec 18             	sub    $0x18,%esp
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800802:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800805:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800809:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80080c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800813:	85 c0                	test   %eax,%eax
  800815:	74 26                	je     80083d <vsnprintf+0x47>
  800817:	85 d2                	test   %edx,%edx
  800819:	7e 22                	jle    80083d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80081b:	ff 75 14             	pushl  0x14(%ebp)
  80081e:	ff 75 10             	pushl  0x10(%ebp)
  800821:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800824:	50                   	push   %eax
  800825:	68 bb 02 80 00       	push   $0x8002bb
  80082a:	e8 c6 fa ff ff       	call   8002f5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80082f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800832:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800838:	83 c4 10             	add    $0x10,%esp
}
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    
		return -E_INVAL;
  80083d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800842:	eb f7                	jmp    80083b <vsnprintf+0x45>

00800844 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80084a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80084d:	50                   	push   %eax
  80084e:	ff 75 10             	pushl  0x10(%ebp)
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	ff 75 08             	pushl  0x8(%ebp)
  800857:	e8 9a ff ff ff       	call   8007f6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80085c:	c9                   	leave  
  80085d:	c3                   	ret    

0080085e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800864:	b8 00 00 00 00       	mov    $0x0,%eax
  800869:	eb 03                	jmp    80086e <strlen+0x10>
		n++;
  80086b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80086e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800872:	75 f7                	jne    80086b <strlen+0xd>
	return n;
}
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	eb 03                	jmp    800889 <strnlen+0x13>
		n++;
  800886:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800889:	39 d0                	cmp    %edx,%eax
  80088b:	74 06                	je     800893 <strnlen+0x1d>
  80088d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800891:	75 f3                	jne    800886 <strnlen+0x10>
	return n;
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089f:	89 c2                	mov    %eax,%edx
  8008a1:	83 c1 01             	add    $0x1,%ecx
  8008a4:	83 c2 01             	add    $0x1,%edx
  8008a7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ab:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008ae:	84 db                	test   %bl,%bl
  8008b0:	75 ef                	jne    8008a1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b2:	5b                   	pop    %ebx
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	53                   	push   %ebx
  8008b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008bc:	53                   	push   %ebx
  8008bd:	e8 9c ff ff ff       	call   80085e <strlen>
  8008c2:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	01 d8                	add    %ebx,%eax
  8008ca:	50                   	push   %eax
  8008cb:	e8 c5 ff ff ff       	call   800895 <strcpy>
	return dst;
}
  8008d0:	89 d8                	mov    %ebx,%eax
  8008d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	56                   	push   %esi
  8008db:	53                   	push   %ebx
  8008dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8008df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e2:	89 f3                	mov    %esi,%ebx
  8008e4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e7:	89 f2                	mov    %esi,%edx
  8008e9:	eb 0f                	jmp    8008fa <strncpy+0x23>
		*dst++ = *src;
  8008eb:	83 c2 01             	add    $0x1,%edx
  8008ee:	0f b6 01             	movzbl (%ecx),%eax
  8008f1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008f4:	80 39 01             	cmpb   $0x1,(%ecx)
  8008f7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008fa:	39 da                	cmp    %ebx,%edx
  8008fc:	75 ed                	jne    8008eb <strncpy+0x14>
	}
	return ret;
}
  8008fe:	89 f0                	mov    %esi,%eax
  800900:	5b                   	pop    %ebx
  800901:	5e                   	pop    %esi
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	56                   	push   %esi
  800908:	53                   	push   %ebx
  800909:	8b 75 08             	mov    0x8(%ebp),%esi
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800912:	89 f0                	mov    %esi,%eax
  800914:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800918:	85 c9                	test   %ecx,%ecx
  80091a:	75 0b                	jne    800927 <strlcpy+0x23>
  80091c:	eb 17                	jmp    800935 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80091e:	83 c2 01             	add    $0x1,%edx
  800921:	83 c0 01             	add    $0x1,%eax
  800924:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800927:	39 d8                	cmp    %ebx,%eax
  800929:	74 07                	je     800932 <strlcpy+0x2e>
  80092b:	0f b6 0a             	movzbl (%edx),%ecx
  80092e:	84 c9                	test   %cl,%cl
  800930:	75 ec                	jne    80091e <strlcpy+0x1a>
		*dst = '\0';
  800932:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800935:	29 f0                	sub    %esi,%eax
}
  800937:	5b                   	pop    %ebx
  800938:	5e                   	pop    %esi
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800944:	eb 06                	jmp    80094c <strcmp+0x11>
		p++, q++;
  800946:	83 c1 01             	add    $0x1,%ecx
  800949:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80094c:	0f b6 01             	movzbl (%ecx),%eax
  80094f:	84 c0                	test   %al,%al
  800951:	74 04                	je     800957 <strcmp+0x1c>
  800953:	3a 02                	cmp    (%edx),%al
  800955:	74 ef                	je     800946 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800957:	0f b6 c0             	movzbl %al,%eax
  80095a:	0f b6 12             	movzbl (%edx),%edx
  80095d:	29 d0                	sub    %edx,%eax
}
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	53                   	push   %ebx
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096b:	89 c3                	mov    %eax,%ebx
  80096d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800970:	eb 06                	jmp    800978 <strncmp+0x17>
		n--, p++, q++;
  800972:	83 c0 01             	add    $0x1,%eax
  800975:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800978:	39 d8                	cmp    %ebx,%eax
  80097a:	74 16                	je     800992 <strncmp+0x31>
  80097c:	0f b6 08             	movzbl (%eax),%ecx
  80097f:	84 c9                	test   %cl,%cl
  800981:	74 04                	je     800987 <strncmp+0x26>
  800983:	3a 0a                	cmp    (%edx),%cl
  800985:	74 eb                	je     800972 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800987:	0f b6 00             	movzbl (%eax),%eax
  80098a:	0f b6 12             	movzbl (%edx),%edx
  80098d:	29 d0                	sub    %edx,%eax
}
  80098f:	5b                   	pop    %ebx
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    
		return 0;
  800992:	b8 00 00 00 00       	mov    $0x0,%eax
  800997:	eb f6                	jmp    80098f <strncmp+0x2e>

00800999 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a3:	0f b6 10             	movzbl (%eax),%edx
  8009a6:	84 d2                	test   %dl,%dl
  8009a8:	74 09                	je     8009b3 <strchr+0x1a>
		if (*s == c)
  8009aa:	38 ca                	cmp    %cl,%dl
  8009ac:	74 0a                	je     8009b8 <strchr+0x1f>
	for (; *s; s++)
  8009ae:	83 c0 01             	add    $0x1,%eax
  8009b1:	eb f0                	jmp    8009a3 <strchr+0xa>
			return (char *) s;
	return 0;
  8009b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	eb 03                	jmp    8009c9 <strfind+0xf>
  8009c6:	83 c0 01             	add    $0x1,%eax
  8009c9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009cc:	38 ca                	cmp    %cl,%dl
  8009ce:	74 04                	je     8009d4 <strfind+0x1a>
  8009d0:	84 d2                	test   %dl,%dl
  8009d2:	75 f2                	jne    8009c6 <strfind+0xc>
			break;
	return (char *) s;
}
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	57                   	push   %edi
  8009da:	56                   	push   %esi
  8009db:	53                   	push   %ebx
  8009dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009df:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009e2:	85 c9                	test   %ecx,%ecx
  8009e4:	74 13                	je     8009f9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009e6:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ec:	75 05                	jne    8009f3 <memset+0x1d>
  8009ee:	f6 c1 03             	test   $0x3,%cl
  8009f1:	74 0d                	je     800a00 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	fc                   	cld    
  8009f7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009f9:	89 f8                	mov    %edi,%eax
  8009fb:	5b                   	pop    %ebx
  8009fc:	5e                   	pop    %esi
  8009fd:	5f                   	pop    %edi
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    
		c &= 0xFF;
  800a00:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a04:	89 d3                	mov    %edx,%ebx
  800a06:	c1 e3 08             	shl    $0x8,%ebx
  800a09:	89 d0                	mov    %edx,%eax
  800a0b:	c1 e0 18             	shl    $0x18,%eax
  800a0e:	89 d6                	mov    %edx,%esi
  800a10:	c1 e6 10             	shl    $0x10,%esi
  800a13:	09 f0                	or     %esi,%eax
  800a15:	09 c2                	or     %eax,%edx
  800a17:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a19:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a1c:	89 d0                	mov    %edx,%eax
  800a1e:	fc                   	cld    
  800a1f:	f3 ab                	rep stos %eax,%es:(%edi)
  800a21:	eb d6                	jmp    8009f9 <memset+0x23>

00800a23 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	57                   	push   %edi
  800a27:	56                   	push   %esi
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a31:	39 c6                	cmp    %eax,%esi
  800a33:	73 35                	jae    800a6a <memmove+0x47>
  800a35:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a38:	39 c2                	cmp    %eax,%edx
  800a3a:	76 2e                	jbe    800a6a <memmove+0x47>
		s += n;
		d += n;
  800a3c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3f:	89 d6                	mov    %edx,%esi
  800a41:	09 fe                	or     %edi,%esi
  800a43:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a49:	74 0c                	je     800a57 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4b:	83 ef 01             	sub    $0x1,%edi
  800a4e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a51:	fd                   	std    
  800a52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a54:	fc                   	cld    
  800a55:	eb 21                	jmp    800a78 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a57:	f6 c1 03             	test   $0x3,%cl
  800a5a:	75 ef                	jne    800a4b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a5c:	83 ef 04             	sub    $0x4,%edi
  800a5f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a62:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a65:	fd                   	std    
  800a66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a68:	eb ea                	jmp    800a54 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6a:	89 f2                	mov    %esi,%edx
  800a6c:	09 c2                	or     %eax,%edx
  800a6e:	f6 c2 03             	test   $0x3,%dl
  800a71:	74 09                	je     800a7c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a73:	89 c7                	mov    %eax,%edi
  800a75:	fc                   	cld    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7c:	f6 c1 03             	test   $0x3,%cl
  800a7f:	75 f2                	jne    800a73 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a81:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a84:	89 c7                	mov    %eax,%edi
  800a86:	fc                   	cld    
  800a87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a89:	eb ed                	jmp    800a78 <memmove+0x55>

00800a8b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a8e:	ff 75 10             	pushl  0x10(%ebp)
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	e8 87 ff ff ff       	call   800a23 <memmove>
}
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    

00800a9e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	56                   	push   %esi
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa9:	89 c6                	mov    %eax,%esi
  800aab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aae:	39 f0                	cmp    %esi,%eax
  800ab0:	74 1c                	je     800ace <memcmp+0x30>
		if (*s1 != *s2)
  800ab2:	0f b6 08             	movzbl (%eax),%ecx
  800ab5:	0f b6 1a             	movzbl (%edx),%ebx
  800ab8:	38 d9                	cmp    %bl,%cl
  800aba:	75 08                	jne    800ac4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800abc:	83 c0 01             	add    $0x1,%eax
  800abf:	83 c2 01             	add    $0x1,%edx
  800ac2:	eb ea                	jmp    800aae <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ac4:	0f b6 c1             	movzbl %cl,%eax
  800ac7:	0f b6 db             	movzbl %bl,%ebx
  800aca:	29 d8                	sub    %ebx,%eax
  800acc:	eb 05                	jmp    800ad3 <memcmp+0x35>
	}

	return 0;
  800ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad3:	5b                   	pop    %ebx
  800ad4:	5e                   	pop    %esi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae5:	39 d0                	cmp    %edx,%eax
  800ae7:	73 09                	jae    800af2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae9:	38 08                	cmp    %cl,(%eax)
  800aeb:	74 05                	je     800af2 <memfind+0x1b>
	for (; s < ends; s++)
  800aed:	83 c0 01             	add    $0x1,%eax
  800af0:	eb f3                	jmp    800ae5 <memfind+0xe>
			break;
	return (void *) s;
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b00:	eb 03                	jmp    800b05 <strtol+0x11>
		s++;
  800b02:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b05:	0f b6 01             	movzbl (%ecx),%eax
  800b08:	3c 20                	cmp    $0x20,%al
  800b0a:	74 f6                	je     800b02 <strtol+0xe>
  800b0c:	3c 09                	cmp    $0x9,%al
  800b0e:	74 f2                	je     800b02 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b10:	3c 2b                	cmp    $0x2b,%al
  800b12:	74 2e                	je     800b42 <strtol+0x4e>
	int neg = 0;
  800b14:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b19:	3c 2d                	cmp    $0x2d,%al
  800b1b:	74 2f                	je     800b4c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b23:	75 05                	jne    800b2a <strtol+0x36>
  800b25:	80 39 30             	cmpb   $0x30,(%ecx)
  800b28:	74 2c                	je     800b56 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b2a:	85 db                	test   %ebx,%ebx
  800b2c:	75 0a                	jne    800b38 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b2e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b33:	80 39 30             	cmpb   $0x30,(%ecx)
  800b36:	74 28                	je     800b60 <strtol+0x6c>
		base = 10;
  800b38:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b40:	eb 50                	jmp    800b92 <strtol+0x9e>
		s++;
  800b42:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b45:	bf 00 00 00 00       	mov    $0x0,%edi
  800b4a:	eb d1                	jmp    800b1d <strtol+0x29>
		s++, neg = 1;
  800b4c:	83 c1 01             	add    $0x1,%ecx
  800b4f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b54:	eb c7                	jmp    800b1d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b56:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b5a:	74 0e                	je     800b6a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b5c:	85 db                	test   %ebx,%ebx
  800b5e:	75 d8                	jne    800b38 <strtol+0x44>
		s++, base = 8;
  800b60:	83 c1 01             	add    $0x1,%ecx
  800b63:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b68:	eb ce                	jmp    800b38 <strtol+0x44>
		s += 2, base = 16;
  800b6a:	83 c1 02             	add    $0x2,%ecx
  800b6d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b72:	eb c4                	jmp    800b38 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b74:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b77:	89 f3                	mov    %esi,%ebx
  800b79:	80 fb 19             	cmp    $0x19,%bl
  800b7c:	77 29                	ja     800ba7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b7e:	0f be d2             	movsbl %dl,%edx
  800b81:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b84:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b87:	7d 30                	jge    800bb9 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b89:	83 c1 01             	add    $0x1,%ecx
  800b8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b90:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b92:	0f b6 11             	movzbl (%ecx),%edx
  800b95:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b98:	89 f3                	mov    %esi,%ebx
  800b9a:	80 fb 09             	cmp    $0x9,%bl
  800b9d:	77 d5                	ja     800b74 <strtol+0x80>
			dig = *s - '0';
  800b9f:	0f be d2             	movsbl %dl,%edx
  800ba2:	83 ea 30             	sub    $0x30,%edx
  800ba5:	eb dd                	jmp    800b84 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ba7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800baa:	89 f3                	mov    %esi,%ebx
  800bac:	80 fb 19             	cmp    $0x19,%bl
  800baf:	77 08                	ja     800bb9 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bb1:	0f be d2             	movsbl %dl,%edx
  800bb4:	83 ea 37             	sub    $0x37,%edx
  800bb7:	eb cb                	jmp    800b84 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbd:	74 05                	je     800bc4 <strtol+0xd0>
		*endptr = (char *) s;
  800bbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bc4:	89 c2                	mov    %eax,%edx
  800bc6:	f7 da                	neg    %edx
  800bc8:	85 ff                	test   %edi,%edi
  800bca:	0f 45 c2             	cmovne %edx,%eax
}
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5f                   	pop    %edi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	57                   	push   %edi
  800bd6:	56                   	push   %esi
  800bd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800be0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be3:	89 c3                	mov    %eax,%ebx
  800be5:	89 c7                	mov    %eax,%edi
  800be7:	89 c6                	mov    %eax,%esi
  800be9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfb:	b8 01 00 00 00       	mov    $0x1,%eax
  800c00:	89 d1                	mov    %edx,%ecx
  800c02:	89 d3                	mov    %edx,%ebx
  800c04:	89 d7                	mov    %edx,%edi
  800c06:	89 d6                	mov    %edx,%esi
  800c08:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c0a:	5b                   	pop    %ebx
  800c0b:	5e                   	pop    %esi
  800c0c:	5f                   	pop    %edi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
  800c15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c20:	b8 03 00 00 00       	mov    $0x3,%eax
  800c25:	89 cb                	mov    %ecx,%ebx
  800c27:	89 cf                	mov    %ecx,%edi
  800c29:	89 ce                	mov    %ecx,%esi
  800c2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2d:	85 c0                	test   %eax,%eax
  800c2f:	7f 08                	jg     800c39 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c34:	5b                   	pop    %ebx
  800c35:	5e                   	pop    %esi
  800c36:	5f                   	pop    %edi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c39:	83 ec 0c             	sub    $0xc,%esp
  800c3c:	50                   	push   %eax
  800c3d:	6a 03                	push   $0x3
  800c3f:	68 ff 2a 80 00       	push   $0x802aff
  800c44:	6a 23                	push   $0x23
  800c46:	68 1c 2b 80 00       	push   $0x802b1c
  800c4b:	e8 d4 17 00 00       	call   802424 <_panic>

00800c50 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	57                   	push   %edi
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c56:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c60:	89 d1                	mov    %edx,%ecx
  800c62:	89 d3                	mov    %edx,%ebx
  800c64:	89 d7                	mov    %edx,%edi
  800c66:	89 d6                	mov    %edx,%esi
  800c68:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <sys_yield>:

void
sys_yield(void)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c7f:	89 d1                	mov    %edx,%ecx
  800c81:	89 d3                	mov    %edx,%ebx
  800c83:	89 d7                	mov    %edx,%edi
  800c85:	89 d6                	mov    %edx,%esi
  800c87:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5f                   	pop    %edi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c97:	be 00 00 00 00       	mov    $0x0,%esi
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800caa:	89 f7                	mov    %esi,%edi
  800cac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cae:	85 c0                	test   %eax,%eax
  800cb0:	7f 08                	jg     800cba <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cba:	83 ec 0c             	sub    $0xc,%esp
  800cbd:	50                   	push   %eax
  800cbe:	6a 04                	push   $0x4
  800cc0:	68 ff 2a 80 00       	push   $0x802aff
  800cc5:	6a 23                	push   $0x23
  800cc7:	68 1c 2b 80 00       	push   $0x802b1c
  800ccc:	e8 53 17 00 00       	call   802424 <_panic>

00800cd1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cda:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ceb:	8b 75 18             	mov    0x18(%ebp),%esi
  800cee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7f 08                	jg     800cfc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 05                	push   $0x5
  800d02:	68 ff 2a 80 00       	push   $0x802aff
  800d07:	6a 23                	push   $0x23
  800d09:	68 1c 2b 80 00       	push   $0x802b1c
  800d0e:	e8 11 17 00 00       	call   802424 <_panic>

00800d13 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d27:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 06                	push   $0x6
  800d44:	68 ff 2a 80 00       	push   $0x802aff
  800d49:	6a 23                	push   $0x23
  800d4b:	68 1c 2b 80 00       	push   $0x802b1c
  800d50:	e8 cf 16 00 00       	call   802424 <_panic>

00800d55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	b8 08 00 00 00       	mov    $0x8,%eax
  800d6e:	89 df                	mov    %ebx,%edi
  800d70:	89 de                	mov    %ebx,%esi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d84:	6a 08                	push   $0x8
  800d86:	68 ff 2a 80 00       	push   $0x802aff
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 1c 2b 80 00       	push   $0x802b1c
  800d92:	e8 8d 16 00 00       	call   802424 <_panic>

00800d97 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 09 00 00 00       	mov    $0x9,%eax
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	89 de                	mov    %ebx,%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800dc6:	6a 09                	push   $0x9
  800dc8:	68 ff 2a 80 00       	push   $0x802aff
  800dcd:	6a 23                	push   $0x23
  800dcf:	68 1c 2b 80 00       	push   $0x802b1c
  800dd4:	e8 4b 16 00 00       	call   802424 <_panic>

00800dd9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800ded:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df2:	89 df                	mov    %ebx,%edi
  800df4:	89 de                	mov    %ebx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e08:	6a 0a                	push   $0xa
  800e0a:	68 ff 2a 80 00       	push   $0x802aff
  800e0f:	6a 23                	push   $0x23
  800e11:	68 1c 2b 80 00       	push   $0x802b1c
  800e16:	e8 09 16 00 00       	call   802424 <_panic>

00800e1b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e27:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e2c:	be 00 00 00 00       	mov    $0x0,%esi
  800e31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e34:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e37:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	57                   	push   %edi
  800e42:	56                   	push   %esi
  800e43:	53                   	push   %ebx
  800e44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e47:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e54:	89 cb                	mov    %ecx,%ebx
  800e56:	89 cf                	mov    %ecx,%edi
  800e58:	89 ce                	mov    %ecx,%esi
  800e5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5f                   	pop    %edi
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 0d                	push   $0xd
  800e6e:	68 ff 2a 80 00       	push   $0x802aff
  800e73:	6a 23                	push   $0x23
  800e75:	68 1c 2b 80 00       	push   $0x802b1c
  800e7a:	e8 a5 15 00 00       	call   802424 <_panic>

00800e7f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e85:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8f:	89 d1                	mov    %edx,%ecx
  800e91:	89 d3                	mov    %edx,%ebx
  800e93:	89 d7                	mov    %edx,%edi
  800e95:	89 d6                	mov    %edx,%esi
  800e97:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 1c             	sub    $0x1c,%esp
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800eaa:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800eac:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800eaf:	89 d8                	mov    %ebx,%eax
  800eb1:	c1 e8 0c             	shr    $0xc,%eax
  800eb4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ebb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800ebe:	e8 8d fd ff ff       	call   800c50 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800ec3:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800ec9:	74 73                	je     800f3e <pgfault+0xa0>
  800ecb:	89 c6                	mov    %eax,%esi
  800ecd:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800ed4:	74 68                	je     800f3e <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800ed6:	83 ec 04             	sub    $0x4,%esp
  800ed9:	6a 07                	push   $0x7
  800edb:	68 00 f0 7f 00       	push   $0x7ff000
  800ee0:	50                   	push   %eax
  800ee1:	e8 a8 fd ff ff       	call   800c8e <sys_page_alloc>
  800ee6:	83 c4 10             	add    $0x10,%esp
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	75 65                	jne    800f52 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800eed:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	68 00 10 00 00       	push   $0x1000
  800efb:	53                   	push   %ebx
  800efc:	68 00 f0 7f 00       	push   $0x7ff000
  800f01:	e8 85 fb ff ff       	call   800a8b <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800f06:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f0d:	53                   	push   %ebx
  800f0e:	56                   	push   %esi
  800f0f:	68 00 f0 7f 00       	push   $0x7ff000
  800f14:	56                   	push   %esi
  800f15:	e8 b7 fd ff ff       	call   800cd1 <sys_page_map>
  800f1a:	83 c4 20             	add    $0x20,%esp
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	75 43                	jne    800f64 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	68 00 f0 7f 00       	push   $0x7ff000
  800f29:	56                   	push   %esi
  800f2a:	e8 e4 fd ff ff       	call   800d13 <sys_page_unmap>
  800f2f:	83 c4 10             	add    $0x10,%esp
  800f32:	85 c0                	test   %eax,%eax
  800f34:	75 40                	jne    800f76 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  800f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  800f3e:	83 ec 04             	sub    $0x4,%esp
  800f41:	68 2a 2b 80 00       	push   $0x802b2a
  800f46:	6a 1f                	push   $0x1f
  800f48:	68 48 2b 80 00       	push   $0x802b48
  800f4d:	e8 d2 14 00 00       	call   802424 <_panic>
	    panic("pgfault: %e", r);
  800f52:	50                   	push   %eax
  800f53:	68 53 2b 80 00       	push   $0x802b53
  800f58:	6a 2a                	push   $0x2a
  800f5a:	68 48 2b 80 00       	push   $0x802b48
  800f5f:	e8 c0 14 00 00       	call   802424 <_panic>
	    panic("pgfault: %e", r);
  800f64:	50                   	push   %eax
  800f65:	68 53 2b 80 00       	push   $0x802b53
  800f6a:	6a 2e                	push   $0x2e
  800f6c:	68 48 2b 80 00       	push   $0x802b48
  800f71:	e8 ae 14 00 00       	call   802424 <_panic>
	    panic("pgfault: %e", r);
  800f76:	50                   	push   %eax
  800f77:	68 53 2b 80 00       	push   $0x802b53
  800f7c:	6a 31                	push   $0x31
  800f7e:	68 48 2b 80 00       	push   $0x802b48
  800f83:	e8 9c 14 00 00       	call   802424 <_panic>

00800f88 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	57                   	push   %edi
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
  800f8e:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  800f91:	68 9e 0e 80 00       	push   $0x800e9e
  800f96:	e8 cf 14 00 00       	call   80246a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f9b:	b8 07 00 00 00       	mov    $0x7,%eax
  800fa0:	cd 30                	int    $0x30
  800fa2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	85 c0                	test   %eax,%eax
  800fad:	78 2b                	js     800fda <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800faf:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fb8:	0f 85 b5 00 00 00    	jne    801073 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  800fbe:	e8 8d fc ff ff       	call   800c50 <sys_getenvid>
  800fc3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fc8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fcb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fd0:	a3 0c 40 80 00       	mov    %eax,0x80400c
	    return 0;
  800fd5:	e9 8c 01 00 00       	jmp    801166 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  800fda:	50                   	push   %eax
  800fdb:	68 5f 2b 80 00       	push   $0x802b5f
  800fe0:	6a 77                	push   $0x77
  800fe2:	68 48 2b 80 00       	push   $0x802b48
  800fe7:	e8 38 14 00 00       	call   802424 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  800fec:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	25 07 0e 00 00       	and    $0xe07,%eax
  800ffb:	50                   	push   %eax
  800ffc:	57                   	push   %edi
  800ffd:	ff 75 e0             	pushl  -0x20(%ebp)
  801000:	57                   	push   %edi
  801001:	ff 75 e4             	pushl  -0x1c(%ebp)
  801004:	e8 c8 fc ff ff       	call   800cd1 <sys_page_map>
  801009:	83 c4 20             	add    $0x20,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	74 51                	je     801061 <fork+0xd9>
           panic("duppage: %e", r);
  801010:	50                   	push   %eax
  801011:	68 6f 2b 80 00       	push   $0x802b6f
  801016:	6a 4a                	push   $0x4a
  801018:	68 48 2b 80 00       	push   $0x802b48
  80101d:	e8 02 14 00 00       	call   802424 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	68 05 08 00 00       	push   $0x805
  80102a:	57                   	push   %edi
  80102b:	ff 75 e0             	pushl  -0x20(%ebp)
  80102e:	57                   	push   %edi
  80102f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801032:	e8 9a fc ff ff       	call   800cd1 <sys_page_map>
  801037:	83 c4 20             	add    $0x20,%esp
  80103a:	85 c0                	test   %eax,%eax
  80103c:	0f 85 bc 00 00 00    	jne    8010fe <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801042:	83 ec 0c             	sub    $0xc,%esp
  801045:	68 05 08 00 00       	push   $0x805
  80104a:	57                   	push   %edi
  80104b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80104e:	50                   	push   %eax
  80104f:	57                   	push   %edi
  801050:	50                   	push   %eax
  801051:	e8 7b fc ff ff       	call   800cd1 <sys_page_map>
  801056:	83 c4 20             	add    $0x20,%esp
  801059:	85 c0                	test   %eax,%eax
  80105b:	0f 85 af 00 00 00    	jne    801110 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801061:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801067:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80106d:	0f 84 af 00 00 00    	je     801122 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801073:	89 d8                	mov    %ebx,%eax
  801075:	c1 e8 16             	shr    $0x16,%eax
  801078:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80107f:	a8 01                	test   $0x1,%al
  801081:	74 de                	je     801061 <fork+0xd9>
  801083:	89 de                	mov    %ebx,%esi
  801085:	c1 ee 0c             	shr    $0xc,%esi
  801088:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80108f:	a8 01                	test   $0x1,%al
  801091:	74 ce                	je     801061 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  801093:	e8 b8 fb ff ff       	call   800c50 <sys_getenvid>
  801098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  80109b:	89 f7                	mov    %esi,%edi
  80109d:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8010a0:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010a7:	f6 c4 04             	test   $0x4,%ah
  8010aa:	0f 85 3c ff ff ff    	jne    800fec <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8010b0:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010b7:	a8 02                	test   $0x2,%al
  8010b9:	0f 85 63 ff ff ff    	jne    801022 <fork+0x9a>
  8010bf:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010c6:	f6 c4 08             	test   $0x8,%ah
  8010c9:	0f 85 53 ff ff ff    	jne    801022 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	6a 05                	push   $0x5
  8010d4:	57                   	push   %edi
  8010d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8010d8:	57                   	push   %edi
  8010d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010dc:	e8 f0 fb ff ff       	call   800cd1 <sys_page_map>
  8010e1:	83 c4 20             	add    $0x20,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	0f 84 75 ff ff ff    	je     801061 <fork+0xd9>
	        panic("duppage: %e", r);
  8010ec:	50                   	push   %eax
  8010ed:	68 6f 2b 80 00       	push   $0x802b6f
  8010f2:	6a 55                	push   $0x55
  8010f4:	68 48 2b 80 00       	push   $0x802b48
  8010f9:	e8 26 13 00 00       	call   802424 <_panic>
	        panic("duppage: %e", r);
  8010fe:	50                   	push   %eax
  8010ff:	68 6f 2b 80 00       	push   $0x802b6f
  801104:	6a 4e                	push   $0x4e
  801106:	68 48 2b 80 00       	push   $0x802b48
  80110b:	e8 14 13 00 00       	call   802424 <_panic>
	        panic("duppage: %e", r);
  801110:	50                   	push   %eax
  801111:	68 6f 2b 80 00       	push   $0x802b6f
  801116:	6a 51                	push   $0x51
  801118:	68 48 2b 80 00       	push   $0x802b48
  80111d:	e8 02 13 00 00       	call   802424 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801122:	83 ec 04             	sub    $0x4,%esp
  801125:	6a 07                	push   $0x7
  801127:	68 00 f0 bf ee       	push   $0xeebff000
  80112c:	ff 75 dc             	pushl  -0x24(%ebp)
  80112f:	e8 5a fb ff ff       	call   800c8e <sys_page_alloc>
  801134:	83 c4 10             	add    $0x10,%esp
  801137:	85 c0                	test   %eax,%eax
  801139:	75 36                	jne    801171 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	68 e3 24 80 00       	push   $0x8024e3
  801143:	ff 75 dc             	pushl  -0x24(%ebp)
  801146:	e8 8e fc ff ff       	call   800dd9 <sys_env_set_pgfault_upcall>
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 34                	jne    801186 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801152:	83 ec 08             	sub    $0x8,%esp
  801155:	6a 02                	push   $0x2
  801157:	ff 75 dc             	pushl  -0x24(%ebp)
  80115a:	e8 f6 fb ff ff       	call   800d55 <sys_env_set_status>
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	75 35                	jne    80119b <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801166:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801169:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    
	    panic("fork: %e", r);
  801171:	50                   	push   %eax
  801172:	68 66 2b 80 00       	push   $0x802b66
  801177:	68 8a 00 00 00       	push   $0x8a
  80117c:	68 48 2b 80 00       	push   $0x802b48
  801181:	e8 9e 12 00 00       	call   802424 <_panic>
	    panic("fork: %e", r);
  801186:	50                   	push   %eax
  801187:	68 66 2b 80 00       	push   $0x802b66
  80118c:	68 8d 00 00 00       	push   $0x8d
  801191:	68 48 2b 80 00       	push   $0x802b48
  801196:	e8 89 12 00 00       	call   802424 <_panic>
	    panic("fork: %e", r);
  80119b:	50                   	push   %eax
  80119c:	68 66 2b 80 00       	push   $0x802b66
  8011a1:	68 92 00 00 00       	push   $0x92
  8011a6:	68 48 2b 80 00       	push   $0x802b48
  8011ab:	e8 74 12 00 00       	call   802424 <_panic>

008011b0 <sfork>:

// Challenge!
int
sfork(void)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b6:	68 7b 2b 80 00       	push   $0x802b7b
  8011bb:	68 9b 00 00 00       	push   $0x9b
  8011c0:	68 48 2b 80 00       	push   $0x802b48
  8011c5:	e8 5a 12 00 00       	call   802424 <_panic>

008011ca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
  8011cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8011d8:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8011da:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8011df:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	50                   	push   %eax
  8011e6:	e8 53 fc ff ff       	call   800e3e <sys_ipc_recv>
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	78 2b                	js     80121d <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8011f2:	85 f6                	test   %esi,%esi
  8011f4:	74 0a                	je     801200 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8011f6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011fb:	8b 40 74             	mov    0x74(%eax),%eax
  8011fe:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801200:	85 db                	test   %ebx,%ebx
  801202:	74 0a                	je     80120e <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801204:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801209:	8b 40 78             	mov    0x78(%eax),%eax
  80120c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80120e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801213:	8b 40 70             	mov    0x70(%eax),%eax
}
  801216:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    
	    if (from_env_store != NULL) {
  80121d:	85 f6                	test   %esi,%esi
  80121f:	74 06                	je     801227 <ipc_recv+0x5d>
	        *from_env_store = 0;
  801221:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801227:	85 db                	test   %ebx,%ebx
  801229:	74 eb                	je     801216 <ipc_recv+0x4c>
	        *perm_store = 0;
  80122b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801231:	eb e3                	jmp    801216 <ipc_recv+0x4c>

00801233 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	57                   	push   %edi
  801237:	56                   	push   %esi
  801238:	53                   	push   %ebx
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80123f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  801242:	85 f6                	test   %esi,%esi
  801244:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801249:	0f 44 f0             	cmove  %eax,%esi
  80124c:	eb 09                	jmp    801257 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80124e:	e8 1c fa ff ff       	call   800c6f <sys_yield>
	} while(r != 0);
  801253:	85 db                	test   %ebx,%ebx
  801255:	74 2d                	je     801284 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  801257:	ff 75 14             	pushl  0x14(%ebp)
  80125a:	56                   	push   %esi
  80125b:	ff 75 0c             	pushl  0xc(%ebp)
  80125e:	57                   	push   %edi
  80125f:	e8 b7 fb ff ff       	call   800e1b <sys_ipc_try_send>
  801264:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  801266:	83 c4 10             	add    $0x10,%esp
  801269:	85 c0                	test   %eax,%eax
  80126b:	79 e1                	jns    80124e <ipc_send+0x1b>
  80126d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801270:	74 dc                	je     80124e <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  801272:	50                   	push   %eax
  801273:	68 91 2b 80 00       	push   $0x802b91
  801278:	6a 45                	push   $0x45
  80127a:	68 9e 2b 80 00       	push   $0x802b9e
  80127f:	e8 a0 11 00 00       	call   802424 <_panic>
}
  801284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5f                   	pop    %edi
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    

0080128c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801292:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801297:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80129a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012a0:	8b 52 50             	mov    0x50(%edx),%edx
  8012a3:	39 ca                	cmp    %ecx,%edx
  8012a5:	74 11                	je     8012b8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8012a7:	83 c0 01             	add    $0x1,%eax
  8012aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012af:	75 e6                	jne    801297 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b6:	eb 0b                	jmp    8012c3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8012b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	05 00 00 00 30       	add    $0x30000000,%eax
  8012d0:	c1 e8 0c             	shr    $0xc,%eax
}
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012e5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012f7:	89 c2                	mov    %eax,%edx
  8012f9:	c1 ea 16             	shr    $0x16,%edx
  8012fc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801303:	f6 c2 01             	test   $0x1,%dl
  801306:	74 2a                	je     801332 <fd_alloc+0x46>
  801308:	89 c2                	mov    %eax,%edx
  80130a:	c1 ea 0c             	shr    $0xc,%edx
  80130d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801314:	f6 c2 01             	test   $0x1,%dl
  801317:	74 19                	je     801332 <fd_alloc+0x46>
  801319:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80131e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801323:	75 d2                	jne    8012f7 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801325:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80132b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801330:	eb 07                	jmp    801339 <fd_alloc+0x4d>
			*fd_store = fd;
  801332:	89 01                	mov    %eax,(%ecx)
			return 0;
  801334:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    

0080133b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801341:	83 f8 1f             	cmp    $0x1f,%eax
  801344:	77 36                	ja     80137c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801346:	c1 e0 0c             	shl    $0xc,%eax
  801349:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80134e:	89 c2                	mov    %eax,%edx
  801350:	c1 ea 16             	shr    $0x16,%edx
  801353:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80135a:	f6 c2 01             	test   $0x1,%dl
  80135d:	74 24                	je     801383 <fd_lookup+0x48>
  80135f:	89 c2                	mov    %eax,%edx
  801361:	c1 ea 0c             	shr    $0xc,%edx
  801364:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136b:	f6 c2 01             	test   $0x1,%dl
  80136e:	74 1a                	je     80138a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	89 02                	mov    %eax,(%edx)
	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    
		return -E_INVAL;
  80137c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801381:	eb f7                	jmp    80137a <fd_lookup+0x3f>
		return -E_INVAL;
  801383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801388:	eb f0                	jmp    80137a <fd_lookup+0x3f>
  80138a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138f:	eb e9                	jmp    80137a <fd_lookup+0x3f>

00801391 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139a:	ba 24 2c 80 00       	mov    $0x802c24,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80139f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013a4:	39 08                	cmp    %ecx,(%eax)
  8013a6:	74 33                	je     8013db <dev_lookup+0x4a>
  8013a8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013ab:	8b 02                	mov    (%edx),%eax
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	75 f3                	jne    8013a4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013b1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013b6:	8b 40 48             	mov    0x48(%eax),%eax
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	51                   	push   %ecx
  8013bd:	50                   	push   %eax
  8013be:	68 a8 2b 80 00       	push   $0x802ba8
  8013c3:	e8 30 ee ff ff       	call   8001f8 <cprintf>
	*dev = 0;
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    
			*dev = devtab[i];
  8013db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013de:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	eb f2                	jmp    8013d9 <dev_lookup+0x48>

008013e7 <fd_close>:
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	57                   	push   %edi
  8013eb:	56                   	push   %esi
  8013ec:	53                   	push   %ebx
  8013ed:	83 ec 1c             	sub    $0x1c,%esp
  8013f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8013f3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013f9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013fa:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801400:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801403:	50                   	push   %eax
  801404:	e8 32 ff ff ff       	call   80133b <fd_lookup>
  801409:	89 c3                	mov    %eax,%ebx
  80140b:	83 c4 08             	add    $0x8,%esp
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 05                	js     801417 <fd_close+0x30>
	    || fd != fd2)
  801412:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801415:	74 16                	je     80142d <fd_close+0x46>
		return (must_exist ? r : 0);
  801417:	89 f8                	mov    %edi,%eax
  801419:	84 c0                	test   %al,%al
  80141b:	b8 00 00 00 00       	mov    $0x0,%eax
  801420:	0f 44 d8             	cmove  %eax,%ebx
}
  801423:	89 d8                	mov    %ebx,%eax
  801425:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801428:	5b                   	pop    %ebx
  801429:	5e                   	pop    %esi
  80142a:	5f                   	pop    %edi
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801433:	50                   	push   %eax
  801434:	ff 36                	pushl  (%esi)
  801436:	e8 56 ff ff ff       	call   801391 <dev_lookup>
  80143b:	89 c3                	mov    %eax,%ebx
  80143d:	83 c4 10             	add    $0x10,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	78 15                	js     801459 <fd_close+0x72>
		if (dev->dev_close)
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	8b 40 10             	mov    0x10(%eax),%eax
  80144a:	85 c0                	test   %eax,%eax
  80144c:	74 1b                	je     801469 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	56                   	push   %esi
  801452:	ff d0                	call   *%eax
  801454:	89 c3                	mov    %eax,%ebx
  801456:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	56                   	push   %esi
  80145d:	6a 00                	push   $0x0
  80145f:	e8 af f8 ff ff       	call   800d13 <sys_page_unmap>
	return r;
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	eb ba                	jmp    801423 <fd_close+0x3c>
			r = 0;
  801469:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146e:	eb e9                	jmp    801459 <fd_close+0x72>

00801470 <close>:

int
close(int fdnum)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801479:	50                   	push   %eax
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 b9 fe ff ff       	call   80133b <fd_lookup>
  801482:	83 c4 08             	add    $0x8,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 10                	js     801499 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801489:	83 ec 08             	sub    $0x8,%esp
  80148c:	6a 01                	push   $0x1
  80148e:	ff 75 f4             	pushl  -0xc(%ebp)
  801491:	e8 51 ff ff ff       	call   8013e7 <fd_close>
  801496:	83 c4 10             	add    $0x10,%esp
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <close_all>:

void
close_all(void)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	53                   	push   %ebx
  80149f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014a2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	53                   	push   %ebx
  8014ab:	e8 c0 ff ff ff       	call   801470 <close>
	for (i = 0; i < MAXFD; i++)
  8014b0:	83 c3 01             	add    $0x1,%ebx
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	83 fb 20             	cmp    $0x20,%ebx
  8014b9:	75 ec                	jne    8014a7 <close_all+0xc>
}
  8014bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	ff 75 08             	pushl  0x8(%ebp)
  8014d0:	e8 66 fe ff ff       	call   80133b <fd_lookup>
  8014d5:	89 c3                	mov    %eax,%ebx
  8014d7:	83 c4 08             	add    $0x8,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	0f 88 81 00 00 00    	js     801563 <dup+0xa3>
		return r;
	close(newfdnum);
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	e8 83 ff ff ff       	call   801470 <close>

	newfd = INDEX2FD(newfdnum);
  8014ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014f0:	c1 e6 0c             	shl    $0xc,%esi
  8014f3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014f9:	83 c4 04             	add    $0x4,%esp
  8014fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014ff:	e8 d1 fd ff ff       	call   8012d5 <fd2data>
  801504:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801506:	89 34 24             	mov    %esi,(%esp)
  801509:	e8 c7 fd ff ff       	call   8012d5 <fd2data>
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801513:	89 d8                	mov    %ebx,%eax
  801515:	c1 e8 16             	shr    $0x16,%eax
  801518:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80151f:	a8 01                	test   $0x1,%al
  801521:	74 11                	je     801534 <dup+0x74>
  801523:	89 d8                	mov    %ebx,%eax
  801525:	c1 e8 0c             	shr    $0xc,%eax
  801528:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80152f:	f6 c2 01             	test   $0x1,%dl
  801532:	75 39                	jne    80156d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801534:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801537:	89 d0                	mov    %edx,%eax
  801539:	c1 e8 0c             	shr    $0xc,%eax
  80153c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	25 07 0e 00 00       	and    $0xe07,%eax
  80154b:	50                   	push   %eax
  80154c:	56                   	push   %esi
  80154d:	6a 00                	push   $0x0
  80154f:	52                   	push   %edx
  801550:	6a 00                	push   $0x0
  801552:	e8 7a f7 ff ff       	call   800cd1 <sys_page_map>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	83 c4 20             	add    $0x20,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 31                	js     801591 <dup+0xd1>
		goto err;

	return newfdnum;
  801560:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801563:	89 d8                	mov    %ebx,%eax
  801565:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801568:	5b                   	pop    %ebx
  801569:	5e                   	pop    %esi
  80156a:	5f                   	pop    %edi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80156d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801574:	83 ec 0c             	sub    $0xc,%esp
  801577:	25 07 0e 00 00       	and    $0xe07,%eax
  80157c:	50                   	push   %eax
  80157d:	57                   	push   %edi
  80157e:	6a 00                	push   $0x0
  801580:	53                   	push   %ebx
  801581:	6a 00                	push   $0x0
  801583:	e8 49 f7 ff ff       	call   800cd1 <sys_page_map>
  801588:	89 c3                	mov    %eax,%ebx
  80158a:	83 c4 20             	add    $0x20,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	79 a3                	jns    801534 <dup+0x74>
	sys_page_unmap(0, newfd);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	56                   	push   %esi
  801595:	6a 00                	push   $0x0
  801597:	e8 77 f7 ff ff       	call   800d13 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80159c:	83 c4 08             	add    $0x8,%esp
  80159f:	57                   	push   %edi
  8015a0:	6a 00                	push   $0x0
  8015a2:	e8 6c f7 ff ff       	call   800d13 <sys_page_unmap>
	return r;
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	eb b7                	jmp    801563 <dup+0xa3>

008015ac <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 14             	sub    $0x14,%esp
  8015b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b9:	50                   	push   %eax
  8015ba:	53                   	push   %ebx
  8015bb:	e8 7b fd ff ff       	call   80133b <fd_lookup>
  8015c0:	83 c4 08             	add    $0x8,%esp
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 3f                	js     801606 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c7:	83 ec 08             	sub    $0x8,%esp
  8015ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cd:	50                   	push   %eax
  8015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d1:	ff 30                	pushl  (%eax)
  8015d3:	e8 b9 fd ff ff       	call   801391 <dev_lookup>
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 27                	js     801606 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e2:	8b 42 08             	mov    0x8(%edx),%eax
  8015e5:	83 e0 03             	and    $0x3,%eax
  8015e8:	83 f8 01             	cmp    $0x1,%eax
  8015eb:	74 1e                	je     80160b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f0:	8b 40 08             	mov    0x8(%eax),%eax
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	74 35                	je     80162c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	ff 75 10             	pushl  0x10(%ebp)
  8015fd:	ff 75 0c             	pushl  0xc(%ebp)
  801600:	52                   	push   %edx
  801601:	ff d0                	call   *%eax
  801603:	83 c4 10             	add    $0x10,%esp
}
  801606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801609:	c9                   	leave  
  80160a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80160b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801610:	8b 40 48             	mov    0x48(%eax),%eax
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	53                   	push   %ebx
  801617:	50                   	push   %eax
  801618:	68 e9 2b 80 00       	push   $0x802be9
  80161d:	e8 d6 eb ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162a:	eb da                	jmp    801606 <read+0x5a>
		return -E_NOT_SUPP;
  80162c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801631:	eb d3                	jmp    801606 <read+0x5a>

00801633 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	57                   	push   %edi
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
  801639:	83 ec 0c             	sub    $0xc,%esp
  80163c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80163f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801642:	bb 00 00 00 00       	mov    $0x0,%ebx
  801647:	39 f3                	cmp    %esi,%ebx
  801649:	73 25                	jae    801670 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	89 f0                	mov    %esi,%eax
  801650:	29 d8                	sub    %ebx,%eax
  801652:	50                   	push   %eax
  801653:	89 d8                	mov    %ebx,%eax
  801655:	03 45 0c             	add    0xc(%ebp),%eax
  801658:	50                   	push   %eax
  801659:	57                   	push   %edi
  80165a:	e8 4d ff ff ff       	call   8015ac <read>
		if (m < 0)
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	78 08                	js     80166e <readn+0x3b>
			return m;
		if (m == 0)
  801666:	85 c0                	test   %eax,%eax
  801668:	74 06                	je     801670 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80166a:	01 c3                	add    %eax,%ebx
  80166c:	eb d9                	jmp    801647 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80166e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801670:	89 d8                	mov    %ebx,%eax
  801672:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	53                   	push   %ebx
  80167e:	83 ec 14             	sub    $0x14,%esp
  801681:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801684:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801687:	50                   	push   %eax
  801688:	53                   	push   %ebx
  801689:	e8 ad fc ff ff       	call   80133b <fd_lookup>
  80168e:	83 c4 08             	add    $0x8,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 3a                	js     8016cf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169f:	ff 30                	pushl  (%eax)
  8016a1:	e8 eb fc ff ff       	call   801391 <dev_lookup>
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	78 22                	js     8016cf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b4:	74 1e                	je     8016d4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8016bc:	85 d2                	test   %edx,%edx
  8016be:	74 35                	je     8016f5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	ff 75 10             	pushl  0x10(%ebp)
  8016c6:	ff 75 0c             	pushl  0xc(%ebp)
  8016c9:	50                   	push   %eax
  8016ca:	ff d2                	call   *%edx
  8016cc:	83 c4 10             	add    $0x10,%esp
}
  8016cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016d4:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8016d9:	8b 40 48             	mov    0x48(%eax),%eax
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	53                   	push   %ebx
  8016e0:	50                   	push   %eax
  8016e1:	68 05 2c 80 00       	push   $0x802c05
  8016e6:	e8 0d eb ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f3:	eb da                	jmp    8016cf <write+0x55>
		return -E_NOT_SUPP;
  8016f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fa:	eb d3                	jmp    8016cf <write+0x55>

008016fc <seek>:

int
seek(int fdnum, off_t offset)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801702:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801705:	50                   	push   %eax
  801706:	ff 75 08             	pushl  0x8(%ebp)
  801709:	e8 2d fc ff ff       	call   80133b <fd_lookup>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	78 0e                	js     801723 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80171b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	53                   	push   %ebx
  801729:	83 ec 14             	sub    $0x14,%esp
  80172c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801732:	50                   	push   %eax
  801733:	53                   	push   %ebx
  801734:	e8 02 fc ff ff       	call   80133b <fd_lookup>
  801739:	83 c4 08             	add    $0x8,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 37                	js     801777 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801746:	50                   	push   %eax
  801747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174a:	ff 30                	pushl  (%eax)
  80174c:	e8 40 fc ff ff       	call   801391 <dev_lookup>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	85 c0                	test   %eax,%eax
  801756:	78 1f                	js     801777 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80175f:	74 1b                	je     80177c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801761:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801764:	8b 52 18             	mov    0x18(%edx),%edx
  801767:	85 d2                	test   %edx,%edx
  801769:	74 32                	je     80179d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	50                   	push   %eax
  801772:	ff d2                	call   *%edx
  801774:	83 c4 10             	add    $0x10,%esp
}
  801777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80177c:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801781:	8b 40 48             	mov    0x48(%eax),%eax
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	53                   	push   %ebx
  801788:	50                   	push   %eax
  801789:	68 c8 2b 80 00       	push   $0x802bc8
  80178e:	e8 65 ea ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179b:	eb da                	jmp    801777 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80179d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a2:	eb d3                	jmp    801777 <ftruncate+0x52>

008017a4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 14             	sub    $0x14,%esp
  8017ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	ff 75 08             	pushl  0x8(%ebp)
  8017b5:	e8 81 fb ff ff       	call   80133b <fd_lookup>
  8017ba:	83 c4 08             	add    $0x8,%esp
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 4b                	js     80180c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c7:	50                   	push   %eax
  8017c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cb:	ff 30                	pushl  (%eax)
  8017cd:	e8 bf fb ff ff       	call   801391 <dev_lookup>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 33                	js     80180c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017dc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017e0:	74 2f                	je     801811 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017e2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017e5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017ec:	00 00 00 
	stat->st_isdir = 0;
  8017ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017f6:	00 00 00 
	stat->st_dev = dev;
  8017f9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	53                   	push   %ebx
  801803:	ff 75 f0             	pushl  -0x10(%ebp)
  801806:	ff 50 14             	call   *0x14(%eax)
  801809:	83 c4 10             	add    $0x10,%esp
}
  80180c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180f:	c9                   	leave  
  801810:	c3                   	ret    
		return -E_NOT_SUPP;
  801811:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801816:	eb f4                	jmp    80180c <fstat+0x68>

00801818 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	56                   	push   %esi
  80181c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	6a 00                	push   $0x0
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	e8 26 02 00 00       	call   801a50 <open>
  80182a:	89 c3                	mov    %eax,%ebx
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 1b                	js     80184e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801833:	83 ec 08             	sub    $0x8,%esp
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	50                   	push   %eax
  80183a:	e8 65 ff ff ff       	call   8017a4 <fstat>
  80183f:	89 c6                	mov    %eax,%esi
	close(fd);
  801841:	89 1c 24             	mov    %ebx,(%esp)
  801844:	e8 27 fc ff ff       	call   801470 <close>
	return r;
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	89 f3                	mov    %esi,%ebx
}
  80184e:	89 d8                	mov    %ebx,%eax
  801850:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	56                   	push   %esi
  80185b:	53                   	push   %ebx
  80185c:	89 c6                	mov    %eax,%esi
  80185e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801860:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801867:	74 27                	je     801890 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801869:	6a 07                	push   $0x7
  80186b:	68 00 50 80 00       	push   $0x805000
  801870:	56                   	push   %esi
  801871:	ff 35 00 40 80 00    	pushl  0x804000
  801877:	e8 b7 f9 ff ff       	call   801233 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80187c:	83 c4 0c             	add    $0xc,%esp
  80187f:	6a 00                	push   $0x0
  801881:	53                   	push   %ebx
  801882:	6a 00                	push   $0x0
  801884:	e8 41 f9 ff ff       	call   8011ca <ipc_recv>
}
  801889:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188c:	5b                   	pop    %ebx
  80188d:	5e                   	pop    %esi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801890:	83 ec 0c             	sub    $0xc,%esp
  801893:	6a 01                	push   $0x1
  801895:	e8 f2 f9 ff ff       	call   80128c <ipc_find_env>
  80189a:	a3 00 40 80 00       	mov    %eax,0x804000
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	eb c5                	jmp    801869 <fsipc+0x12>

008018a4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8018c7:	e8 8b ff ff ff       	call   801857 <fsipc>
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <devfile_flush>:
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018da:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	b8 06 00 00 00       	mov    $0x6,%eax
  8018e9:	e8 69 ff ff ff       	call   801857 <fsipc>
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <devfile_stat>:
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801900:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801905:	ba 00 00 00 00       	mov    $0x0,%edx
  80190a:	b8 05 00 00 00       	mov    $0x5,%eax
  80190f:	e8 43 ff ff ff       	call   801857 <fsipc>
  801914:	85 c0                	test   %eax,%eax
  801916:	78 2c                	js     801944 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801918:	83 ec 08             	sub    $0x8,%esp
  80191b:	68 00 50 80 00       	push   $0x805000
  801920:	53                   	push   %ebx
  801921:	e8 6f ef ff ff       	call   800895 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801926:	a1 80 50 80 00       	mov    0x805080,%eax
  80192b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801931:	a1 84 50 80 00       	mov    0x805084,%eax
  801936:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <devfile_write>:
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	53                   	push   %ebx
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 40 0c             	mov    0xc(%eax),%eax
  801959:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80195e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801964:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80196a:	77 30                	ja     80199c <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	53                   	push   %ebx
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	68 08 50 80 00       	push   $0x805008
  801978:	e8 a6 f0 ff ff       	call   800a23 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80197d:	ba 00 00 00 00       	mov    $0x0,%edx
  801982:	b8 04 00 00 00       	mov    $0x4,%eax
  801987:	e8 cb fe ff ff       	call   801857 <fsipc>
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 04                	js     801997 <devfile_write+0x4e>
	assert(r <= n);
  801993:	39 d8                	cmp    %ebx,%eax
  801995:	77 1e                	ja     8019b5 <devfile_write+0x6c>
}
  801997:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80199c:	68 38 2c 80 00       	push   $0x802c38
  8019a1:	68 65 2c 80 00       	push   $0x802c65
  8019a6:	68 94 00 00 00       	push   $0x94
  8019ab:	68 7a 2c 80 00       	push   $0x802c7a
  8019b0:	e8 6f 0a 00 00       	call   802424 <_panic>
	assert(r <= n);
  8019b5:	68 85 2c 80 00       	push   $0x802c85
  8019ba:	68 65 2c 80 00       	push   $0x802c65
  8019bf:	68 98 00 00 00       	push   $0x98
  8019c4:	68 7a 2c 80 00       	push   $0x802c7a
  8019c9:	e8 56 0a 00 00       	call   802424 <_panic>

008019ce <devfile_read>:
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	56                   	push   %esi
  8019d2:	53                   	push   %ebx
  8019d3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019dc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019e1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8019f1:	e8 61 fe ff ff       	call   801857 <fsipc>
  8019f6:	89 c3                	mov    %eax,%ebx
  8019f8:	85 c0                	test   %eax,%eax
  8019fa:	78 1f                	js     801a1b <devfile_read+0x4d>
	assert(r <= n);
  8019fc:	39 f0                	cmp    %esi,%eax
  8019fe:	77 24                	ja     801a24 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a00:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a05:	7f 33                	jg     801a3a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	50                   	push   %eax
  801a0b:	68 00 50 80 00       	push   $0x805000
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	e8 0b f0 ff ff       	call   800a23 <memmove>
	return r;
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    
	assert(r <= n);
  801a24:	68 85 2c 80 00       	push   $0x802c85
  801a29:	68 65 2c 80 00       	push   $0x802c65
  801a2e:	6a 7c                	push   $0x7c
  801a30:	68 7a 2c 80 00       	push   $0x802c7a
  801a35:	e8 ea 09 00 00       	call   802424 <_panic>
	assert(r <= PGSIZE);
  801a3a:	68 8c 2c 80 00       	push   $0x802c8c
  801a3f:	68 65 2c 80 00       	push   $0x802c65
  801a44:	6a 7d                	push   $0x7d
  801a46:	68 7a 2c 80 00       	push   $0x802c7a
  801a4b:	e8 d4 09 00 00       	call   802424 <_panic>

00801a50 <open>:
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	56                   	push   %esi
  801a54:	53                   	push   %ebx
  801a55:	83 ec 1c             	sub    $0x1c,%esp
  801a58:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a5b:	56                   	push   %esi
  801a5c:	e8 fd ed ff ff       	call   80085e <strlen>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a69:	7f 6c                	jg     801ad7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a71:	50                   	push   %eax
  801a72:	e8 75 f8 ff ff       	call   8012ec <fd_alloc>
  801a77:	89 c3                	mov    %eax,%ebx
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 3c                	js     801abc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	56                   	push   %esi
  801a84:	68 00 50 80 00       	push   $0x805000
  801a89:	e8 07 ee ff ff       	call   800895 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a91:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a99:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9e:	e8 b4 fd ff ff       	call   801857 <fsipc>
  801aa3:	89 c3                	mov    %eax,%ebx
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 19                	js     801ac5 <open+0x75>
	return fd2num(fd);
  801aac:	83 ec 0c             	sub    $0xc,%esp
  801aaf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab2:	e8 0e f8 ff ff       	call   8012c5 <fd2num>
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	83 c4 10             	add    $0x10,%esp
}
  801abc:	89 d8                	mov    %ebx,%eax
  801abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac1:	5b                   	pop    %ebx
  801ac2:	5e                   	pop    %esi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    
		fd_close(fd, 0);
  801ac5:	83 ec 08             	sub    $0x8,%esp
  801ac8:	6a 00                	push   $0x0
  801aca:	ff 75 f4             	pushl  -0xc(%ebp)
  801acd:	e8 15 f9 ff ff       	call   8013e7 <fd_close>
		return r;
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	eb e5                	jmp    801abc <open+0x6c>
		return -E_BAD_PATH;
  801ad7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801adc:	eb de                	jmp    801abc <open+0x6c>

00801ade <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae9:	b8 08 00 00 00       	mov    $0x8,%eax
  801aee:	e8 64 fd ff ff       	call   801857 <fsipc>
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	56                   	push   %esi
  801af9:	53                   	push   %ebx
  801afa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	e8 cd f7 ff ff       	call   8012d5 <fd2data>
  801b08:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b0a:	83 c4 08             	add    $0x8,%esp
  801b0d:	68 98 2c 80 00       	push   $0x802c98
  801b12:	53                   	push   %ebx
  801b13:	e8 7d ed ff ff       	call   800895 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b18:	8b 46 04             	mov    0x4(%esi),%eax
  801b1b:	2b 06                	sub    (%esi),%eax
  801b1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b2a:	00 00 00 
	stat->st_dev = &devpipe;
  801b2d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b34:	30 80 00 
	return 0;
}
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	53                   	push   %ebx
  801b47:	83 ec 0c             	sub    $0xc,%esp
  801b4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b4d:	53                   	push   %ebx
  801b4e:	6a 00                	push   $0x0
  801b50:	e8 be f1 ff ff       	call   800d13 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b55:	89 1c 24             	mov    %ebx,(%esp)
  801b58:	e8 78 f7 ff ff       	call   8012d5 <fd2data>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	50                   	push   %eax
  801b61:	6a 00                	push   $0x0
  801b63:	e8 ab f1 ff ff       	call   800d13 <sys_page_unmap>
}
  801b68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <_pipeisclosed>:
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	57                   	push   %edi
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	83 ec 1c             	sub    $0x1c,%esp
  801b76:	89 c7                	mov    %eax,%edi
  801b78:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b7a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801b7f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	57                   	push   %edi
  801b86:	e8 7e 09 00 00       	call   802509 <pageref>
  801b8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b8e:	89 34 24             	mov    %esi,(%esp)
  801b91:	e8 73 09 00 00       	call   802509 <pageref>
		nn = thisenv->env_runs;
  801b96:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801b9c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	39 cb                	cmp    %ecx,%ebx
  801ba4:	74 1b                	je     801bc1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ba6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba9:	75 cf                	jne    801b7a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bab:	8b 42 58             	mov    0x58(%edx),%eax
  801bae:	6a 01                	push   $0x1
  801bb0:	50                   	push   %eax
  801bb1:	53                   	push   %ebx
  801bb2:	68 9f 2c 80 00       	push   $0x802c9f
  801bb7:	e8 3c e6 ff ff       	call   8001f8 <cprintf>
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	eb b9                	jmp    801b7a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bc1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc4:	0f 94 c0             	sete   %al
  801bc7:	0f b6 c0             	movzbl %al,%eax
}
  801bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5e                   	pop    %esi
  801bcf:	5f                   	pop    %edi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    

00801bd2 <devpipe_write>:
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	57                   	push   %edi
  801bd6:	56                   	push   %esi
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 28             	sub    $0x28,%esp
  801bdb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bde:	56                   	push   %esi
  801bdf:	e8 f1 f6 ff ff       	call   8012d5 <fd2data>
  801be4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bf1:	74 4f                	je     801c42 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bf3:	8b 43 04             	mov    0x4(%ebx),%eax
  801bf6:	8b 0b                	mov    (%ebx),%ecx
  801bf8:	8d 51 20             	lea    0x20(%ecx),%edx
  801bfb:	39 d0                	cmp    %edx,%eax
  801bfd:	72 14                	jb     801c13 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bff:	89 da                	mov    %ebx,%edx
  801c01:	89 f0                	mov    %esi,%eax
  801c03:	e8 65 ff ff ff       	call   801b6d <_pipeisclosed>
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	75 3a                	jne    801c46 <devpipe_write+0x74>
			sys_yield();
  801c0c:	e8 5e f0 ff ff       	call   800c6f <sys_yield>
  801c11:	eb e0                	jmp    801bf3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c16:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c1a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c1d:	89 c2                	mov    %eax,%edx
  801c1f:	c1 fa 1f             	sar    $0x1f,%edx
  801c22:	89 d1                	mov    %edx,%ecx
  801c24:	c1 e9 1b             	shr    $0x1b,%ecx
  801c27:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c2a:	83 e2 1f             	and    $0x1f,%edx
  801c2d:	29 ca                	sub    %ecx,%edx
  801c2f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c33:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c37:	83 c0 01             	add    $0x1,%eax
  801c3a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c3d:	83 c7 01             	add    $0x1,%edi
  801c40:	eb ac                	jmp    801bee <devpipe_write+0x1c>
	return i;
  801c42:	89 f8                	mov    %edi,%eax
  801c44:	eb 05                	jmp    801c4b <devpipe_write+0x79>
				return 0;
  801c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4e:	5b                   	pop    %ebx
  801c4f:	5e                   	pop    %esi
  801c50:	5f                   	pop    %edi
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    

00801c53 <devpipe_read>:
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	57                   	push   %edi
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
  801c59:	83 ec 18             	sub    $0x18,%esp
  801c5c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c5f:	57                   	push   %edi
  801c60:	e8 70 f6 ff ff       	call   8012d5 <fd2data>
  801c65:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	be 00 00 00 00       	mov    $0x0,%esi
  801c6f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c72:	74 47                	je     801cbb <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c74:	8b 03                	mov    (%ebx),%eax
  801c76:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c79:	75 22                	jne    801c9d <devpipe_read+0x4a>
			if (i > 0)
  801c7b:	85 f6                	test   %esi,%esi
  801c7d:	75 14                	jne    801c93 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c7f:	89 da                	mov    %ebx,%edx
  801c81:	89 f8                	mov    %edi,%eax
  801c83:	e8 e5 fe ff ff       	call   801b6d <_pipeisclosed>
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	75 33                	jne    801cbf <devpipe_read+0x6c>
			sys_yield();
  801c8c:	e8 de ef ff ff       	call   800c6f <sys_yield>
  801c91:	eb e1                	jmp    801c74 <devpipe_read+0x21>
				return i;
  801c93:	89 f0                	mov    %esi,%eax
}
  801c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5f                   	pop    %edi
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c9d:	99                   	cltd   
  801c9e:	c1 ea 1b             	shr    $0x1b,%edx
  801ca1:	01 d0                	add    %edx,%eax
  801ca3:	83 e0 1f             	and    $0x1f,%eax
  801ca6:	29 d0                	sub    %edx,%eax
  801ca8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cb3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cb6:	83 c6 01             	add    $0x1,%esi
  801cb9:	eb b4                	jmp    801c6f <devpipe_read+0x1c>
	return i;
  801cbb:	89 f0                	mov    %esi,%eax
  801cbd:	eb d6                	jmp    801c95 <devpipe_read+0x42>
				return 0;
  801cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc4:	eb cf                	jmp    801c95 <devpipe_read+0x42>

00801cc6 <pipe>:
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
  801ccb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd1:	50                   	push   %eax
  801cd2:	e8 15 f6 ff ff       	call   8012ec <fd_alloc>
  801cd7:	89 c3                	mov    %eax,%ebx
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 5b                	js     801d3b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	68 07 04 00 00       	push   $0x407
  801ce8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ceb:	6a 00                	push   $0x0
  801ced:	e8 9c ef ff ff       	call   800c8e <sys_page_alloc>
  801cf2:	89 c3                	mov    %eax,%ebx
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	78 40                	js     801d3b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801cfb:	83 ec 0c             	sub    $0xc,%esp
  801cfe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d01:	50                   	push   %eax
  801d02:	e8 e5 f5 ff ff       	call   8012ec <fd_alloc>
  801d07:	89 c3                	mov    %eax,%ebx
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	78 1b                	js     801d2b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d10:	83 ec 04             	sub    $0x4,%esp
  801d13:	68 07 04 00 00       	push   $0x407
  801d18:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1b:	6a 00                	push   $0x0
  801d1d:	e8 6c ef ff ff       	call   800c8e <sys_page_alloc>
  801d22:	89 c3                	mov    %eax,%ebx
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	85 c0                	test   %eax,%eax
  801d29:	79 19                	jns    801d44 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d2b:	83 ec 08             	sub    $0x8,%esp
  801d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d31:	6a 00                	push   $0x0
  801d33:	e8 db ef ff ff       	call   800d13 <sys_page_unmap>
  801d38:	83 c4 10             	add    $0x10,%esp
}
  801d3b:	89 d8                	mov    %ebx,%eax
  801d3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5d                   	pop    %ebp
  801d43:	c3                   	ret    
	va = fd2data(fd0);
  801d44:	83 ec 0c             	sub    $0xc,%esp
  801d47:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4a:	e8 86 f5 ff ff       	call   8012d5 <fd2data>
  801d4f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d51:	83 c4 0c             	add    $0xc,%esp
  801d54:	68 07 04 00 00       	push   $0x407
  801d59:	50                   	push   %eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	e8 2d ef ff ff       	call   800c8e <sys_page_alloc>
  801d61:	89 c3                	mov    %eax,%ebx
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	85 c0                	test   %eax,%eax
  801d68:	0f 88 8c 00 00 00    	js     801dfa <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6e:	83 ec 0c             	sub    $0xc,%esp
  801d71:	ff 75 f0             	pushl  -0x10(%ebp)
  801d74:	e8 5c f5 ff ff       	call   8012d5 <fd2data>
  801d79:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d80:	50                   	push   %eax
  801d81:	6a 00                	push   $0x0
  801d83:	56                   	push   %esi
  801d84:	6a 00                	push   $0x0
  801d86:	e8 46 ef ff ff       	call   800cd1 <sys_page_map>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	83 c4 20             	add    $0x20,%esp
  801d90:	85 c0                	test   %eax,%eax
  801d92:	78 58                	js     801dec <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d9d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dac:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801db2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dbe:	83 ec 0c             	sub    $0xc,%esp
  801dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc4:	e8 fc f4 ff ff       	call   8012c5 <fd2num>
  801dc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dcc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dce:	83 c4 04             	add    $0x4,%esp
  801dd1:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd4:	e8 ec f4 ff ff       	call   8012c5 <fd2num>
  801dd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de7:	e9 4f ff ff ff       	jmp    801d3b <pipe+0x75>
	sys_page_unmap(0, va);
  801dec:	83 ec 08             	sub    $0x8,%esp
  801def:	56                   	push   %esi
  801df0:	6a 00                	push   $0x0
  801df2:	e8 1c ef ff ff       	call   800d13 <sys_page_unmap>
  801df7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dfa:	83 ec 08             	sub    $0x8,%esp
  801dfd:	ff 75 f0             	pushl  -0x10(%ebp)
  801e00:	6a 00                	push   $0x0
  801e02:	e8 0c ef ff ff       	call   800d13 <sys_page_unmap>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	e9 1c ff ff ff       	jmp    801d2b <pipe+0x65>

00801e0f <pipeisclosed>:
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e18:	50                   	push   %eax
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	e8 1a f5 ff ff       	call   80133b <fd_lookup>
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	85 c0                	test   %eax,%eax
  801e26:	78 18                	js     801e40 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2e:	e8 a2 f4 ff ff       	call   8012d5 <fd2data>
	return _pipeisclosed(fd, p);
  801e33:	89 c2                	mov    %eax,%edx
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	e8 30 fd ff ff       	call   801b6d <_pipeisclosed>
  801e3d:	83 c4 10             	add    $0x10,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e48:	68 b7 2c 80 00       	push   $0x802cb7
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	e8 40 ea ff ff       	call   800895 <strcpy>
	return 0;
}
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <devsock_close>:
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	53                   	push   %ebx
  801e60:	83 ec 10             	sub    $0x10,%esp
  801e63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e66:	53                   	push   %ebx
  801e67:	e8 9d 06 00 00       	call   802509 <pageref>
  801e6c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e6f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e74:	83 f8 01             	cmp    $0x1,%eax
  801e77:	74 07                	je     801e80 <devsock_close+0x24>
}
  801e79:	89 d0                	mov    %edx,%eax
  801e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e80:	83 ec 0c             	sub    $0xc,%esp
  801e83:	ff 73 0c             	pushl  0xc(%ebx)
  801e86:	e8 b7 02 00 00       	call   802142 <nsipc_close>
  801e8b:	89 c2                	mov    %eax,%edx
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	eb e7                	jmp    801e79 <devsock_close+0x1d>

00801e92 <devsock_write>:
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	ff 75 10             	pushl  0x10(%ebp)
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	ff 70 0c             	pushl  0xc(%eax)
  801ea6:	e8 74 03 00 00       	call   80221f <nsipc_send>
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <devsock_read>:
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	ff 75 10             	pushl  0x10(%ebp)
  801eb8:	ff 75 0c             	pushl  0xc(%ebp)
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	ff 70 0c             	pushl  0xc(%eax)
  801ec1:	e8 ed 02 00 00       	call   8021b3 <nsipc_recv>
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <fd2sockid>:
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ece:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ed1:	52                   	push   %edx
  801ed2:	50                   	push   %eax
  801ed3:	e8 63 f4 ff ff       	call   80133b <fd_lookup>
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	85 c0                	test   %eax,%eax
  801edd:	78 10                	js     801eef <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ee8:	39 08                	cmp    %ecx,(%eax)
  801eea:	75 05                	jne    801ef1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801eec:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    
		return -E_NOT_SUPP;
  801ef1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ef6:	eb f7                	jmp    801eef <fd2sockid+0x27>

00801ef8 <alloc_sockfd>:
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	56                   	push   %esi
  801efc:	53                   	push   %ebx
  801efd:	83 ec 1c             	sub    $0x1c,%esp
  801f00:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f05:	50                   	push   %eax
  801f06:	e8 e1 f3 ff ff       	call   8012ec <fd_alloc>
  801f0b:	89 c3                	mov    %eax,%ebx
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	85 c0                	test   %eax,%eax
  801f12:	78 43                	js     801f57 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	68 07 04 00 00       	push   $0x407
  801f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1f:	6a 00                	push   $0x0
  801f21:	e8 68 ed ff ff       	call   800c8e <sys_page_alloc>
  801f26:	89 c3                	mov    %eax,%ebx
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 28                	js     801f57 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f38:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f44:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f47:	83 ec 0c             	sub    $0xc,%esp
  801f4a:	50                   	push   %eax
  801f4b:	e8 75 f3 ff ff       	call   8012c5 <fd2num>
  801f50:	89 c3                	mov    %eax,%ebx
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	eb 0c                	jmp    801f63 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	56                   	push   %esi
  801f5b:	e8 e2 01 00 00       	call   802142 <nsipc_close>
		return r;
  801f60:	83 c4 10             	add    $0x10,%esp
}
  801f63:	89 d8                	mov    %ebx,%eax
  801f65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f68:	5b                   	pop    %ebx
  801f69:	5e                   	pop    %esi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    

00801f6c <accept>:
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	e8 4e ff ff ff       	call   801ec8 <fd2sockid>
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 1b                	js     801f99 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	ff 75 10             	pushl  0x10(%ebp)
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	50                   	push   %eax
  801f88:	e8 0e 01 00 00       	call   80209b <nsipc_accept>
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	85 c0                	test   %eax,%eax
  801f92:	78 05                	js     801f99 <accept+0x2d>
	return alloc_sockfd(r);
  801f94:	e8 5f ff ff ff       	call   801ef8 <alloc_sockfd>
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <bind>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	e8 1f ff ff ff       	call   801ec8 <fd2sockid>
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	78 12                	js     801fbf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	ff 75 10             	pushl  0x10(%ebp)
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	50                   	push   %eax
  801fb7:	e8 2f 01 00 00       	call   8020eb <nsipc_bind>
  801fbc:	83 c4 10             	add    $0x10,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <shutdown>:
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	e8 f9 fe ff ff       	call   801ec8 <fd2sockid>
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	78 0f                	js     801fe2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	ff 75 0c             	pushl  0xc(%ebp)
  801fd9:	50                   	push   %eax
  801fda:	e8 41 01 00 00       	call   802120 <nsipc_shutdown>
  801fdf:	83 c4 10             	add    $0x10,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <connect>:
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	e8 d6 fe ff ff       	call   801ec8 <fd2sockid>
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 12                	js     802008 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	ff 75 10             	pushl  0x10(%ebp)
  801ffc:	ff 75 0c             	pushl  0xc(%ebp)
  801fff:	50                   	push   %eax
  802000:	e8 57 01 00 00       	call   80215c <nsipc_connect>
  802005:	83 c4 10             	add    $0x10,%esp
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <listen>:
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	e8 b0 fe ff ff       	call   801ec8 <fd2sockid>
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 0f                	js     80202b <listen+0x21>
	return nsipc_listen(r, backlog);
  80201c:	83 ec 08             	sub    $0x8,%esp
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	50                   	push   %eax
  802023:	e8 69 01 00 00       	call   802191 <nsipc_listen>
  802028:	83 c4 10             	add    $0x10,%esp
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <socket>:

int
socket(int domain, int type, int protocol)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802033:	ff 75 10             	pushl  0x10(%ebp)
  802036:	ff 75 0c             	pushl  0xc(%ebp)
  802039:	ff 75 08             	pushl  0x8(%ebp)
  80203c:	e8 3c 02 00 00       	call   80227d <nsipc_socket>
  802041:	83 c4 10             	add    $0x10,%esp
  802044:	85 c0                	test   %eax,%eax
  802046:	78 05                	js     80204d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802048:	e8 ab fe ff ff       	call   801ef8 <alloc_sockfd>
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	53                   	push   %ebx
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802058:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80205f:	74 26                	je     802087 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802061:	6a 07                	push   $0x7
  802063:	68 00 60 80 00       	push   $0x806000
  802068:	53                   	push   %ebx
  802069:	ff 35 04 40 80 00    	pushl  0x804004
  80206f:	e8 bf f1 ff ff       	call   801233 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802074:	83 c4 0c             	add    $0xc,%esp
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	e8 48 f1 ff ff       	call   8011ca <ipc_recv>
}
  802082:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802085:	c9                   	leave  
  802086:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	6a 02                	push   $0x2
  80208c:	e8 fb f1 ff ff       	call   80128c <ipc_find_env>
  802091:	a3 04 40 80 00       	mov    %eax,0x804004
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	eb c6                	jmp    802061 <nsipc+0x12>

0080209b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	56                   	push   %esi
  80209f:	53                   	push   %ebx
  8020a0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020ab:	8b 06                	mov    (%esi),%eax
  8020ad:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b7:	e8 93 ff ff ff       	call   80204f <nsipc>
  8020bc:	89 c3                	mov    %eax,%ebx
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	78 20                	js     8020e2 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	ff 35 10 60 80 00    	pushl  0x806010
  8020cb:	68 00 60 80 00       	push   $0x806000
  8020d0:	ff 75 0c             	pushl  0xc(%ebp)
  8020d3:	e8 4b e9 ff ff       	call   800a23 <memmove>
		*addrlen = ret->ret_addrlen;
  8020d8:	a1 10 60 80 00       	mov    0x806010,%eax
  8020dd:	89 06                	mov    %eax,(%esi)
  8020df:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8020e2:	89 d8                	mov    %ebx,%eax
  8020e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    

008020eb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	53                   	push   %ebx
  8020ef:	83 ec 08             	sub    $0x8,%esp
  8020f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020fd:	53                   	push   %ebx
  8020fe:	ff 75 0c             	pushl  0xc(%ebp)
  802101:	68 04 60 80 00       	push   $0x806004
  802106:	e8 18 e9 ff ff       	call   800a23 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80210b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802111:	b8 02 00 00 00       	mov    $0x2,%eax
  802116:	e8 34 ff ff ff       	call   80204f <nsipc>
}
  80211b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802136:	b8 03 00 00 00       	mov    $0x3,%eax
  80213b:	e8 0f ff ff ff       	call   80204f <nsipc>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <nsipc_close>:

int
nsipc_close(int s)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802150:	b8 04 00 00 00       	mov    $0x4,%eax
  802155:	e8 f5 fe ff ff       	call   80204f <nsipc>
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	53                   	push   %ebx
  802160:	83 ec 08             	sub    $0x8,%esp
  802163:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80216e:	53                   	push   %ebx
  80216f:	ff 75 0c             	pushl  0xc(%ebp)
  802172:	68 04 60 80 00       	push   $0x806004
  802177:	e8 a7 e8 ff ff       	call   800a23 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80217c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802182:	b8 05 00 00 00       	mov    $0x5,%eax
  802187:	e8 c3 fe ff ff       	call   80204f <nsipc>
}
  80218c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80219f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8021a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8021ac:	e8 9e fe ff ff       	call   80204f <nsipc>
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8021c3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8021c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cc:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021d1:	b8 07 00 00 00       	mov    $0x7,%eax
  8021d6:	e8 74 fe ff ff       	call   80204f <nsipc>
  8021db:	89 c3                	mov    %eax,%ebx
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 1f                	js     802200 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021e1:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021e6:	7f 21                	jg     802209 <nsipc_recv+0x56>
  8021e8:	39 c6                	cmp    %eax,%esi
  8021ea:	7c 1d                	jl     802209 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	50                   	push   %eax
  8021f0:	68 00 60 80 00       	push   $0x806000
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	e8 26 e8 ff ff       	call   800a23 <memmove>
  8021fd:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802200:	89 d8                	mov    %ebx,%eax
  802202:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802209:	68 c3 2c 80 00       	push   $0x802cc3
  80220e:	68 65 2c 80 00       	push   $0x802c65
  802213:	6a 62                	push   $0x62
  802215:	68 d8 2c 80 00       	push   $0x802cd8
  80221a:	e8 05 02 00 00       	call   802424 <_panic>

0080221f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	53                   	push   %ebx
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802231:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802237:	7f 2e                	jg     802267 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	53                   	push   %ebx
  80223d:	ff 75 0c             	pushl  0xc(%ebp)
  802240:	68 0c 60 80 00       	push   $0x80600c
  802245:	e8 d9 e7 ff ff       	call   800a23 <memmove>
	nsipcbuf.send.req_size = size;
  80224a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802250:	8b 45 14             	mov    0x14(%ebp),%eax
  802253:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802258:	b8 08 00 00 00       	mov    $0x8,%eax
  80225d:	e8 ed fd ff ff       	call   80204f <nsipc>
}
  802262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802265:	c9                   	leave  
  802266:	c3                   	ret    
	assert(size < 1600);
  802267:	68 e4 2c 80 00       	push   $0x802ce4
  80226c:	68 65 2c 80 00       	push   $0x802c65
  802271:	6a 6d                	push   $0x6d
  802273:	68 d8 2c 80 00       	push   $0x802cd8
  802278:	e8 a7 01 00 00       	call   802424 <_panic>

0080227d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80228b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228e:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802293:	8b 45 10             	mov    0x10(%ebp),%eax
  802296:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80229b:	b8 09 00 00 00       	mov    $0x9,%eax
  8022a0:	e8 aa fd ff ff       	call   80204f <nsipc>
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    

008022b1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022b7:	68 f0 2c 80 00       	push   $0x802cf0
  8022bc:	ff 75 0c             	pushl  0xc(%ebp)
  8022bf:	e8 d1 e5 ff ff       	call   800895 <strcpy>
	return 0;
}
  8022c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <devcons_write>:
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	57                   	push   %edi
  8022cf:	56                   	push   %esi
  8022d0:	53                   	push   %ebx
  8022d1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022d7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022dc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022e2:	eb 2f                	jmp    802313 <devcons_write+0x48>
		m = n - tot;
  8022e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022e7:	29 f3                	sub    %esi,%ebx
  8022e9:	83 fb 7f             	cmp    $0x7f,%ebx
  8022ec:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022f1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022f4:	83 ec 04             	sub    $0x4,%esp
  8022f7:	53                   	push   %ebx
  8022f8:	89 f0                	mov    %esi,%eax
  8022fa:	03 45 0c             	add    0xc(%ebp),%eax
  8022fd:	50                   	push   %eax
  8022fe:	57                   	push   %edi
  8022ff:	e8 1f e7 ff ff       	call   800a23 <memmove>
		sys_cputs(buf, m);
  802304:	83 c4 08             	add    $0x8,%esp
  802307:	53                   	push   %ebx
  802308:	57                   	push   %edi
  802309:	e8 c4 e8 ff ff       	call   800bd2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80230e:	01 de                	add    %ebx,%esi
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	3b 75 10             	cmp    0x10(%ebp),%esi
  802316:	72 cc                	jb     8022e4 <devcons_write+0x19>
}
  802318:	89 f0                	mov    %esi,%eax
  80231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    

00802322 <devcons_read>:
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 08             	sub    $0x8,%esp
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80232d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802331:	75 07                	jne    80233a <devcons_read+0x18>
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    
		sys_yield();
  802335:	e8 35 e9 ff ff       	call   800c6f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80233a:	e8 b1 e8 ff ff       	call   800bf0 <sys_cgetc>
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 f2                	je     802335 <devcons_read+0x13>
	if (c < 0)
  802343:	85 c0                	test   %eax,%eax
  802345:	78 ec                	js     802333 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802347:	83 f8 04             	cmp    $0x4,%eax
  80234a:	74 0c                	je     802358 <devcons_read+0x36>
	*(char*)vbuf = c;
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	88 02                	mov    %al,(%edx)
	return 1;
  802351:	b8 01 00 00 00       	mov    $0x1,%eax
  802356:	eb db                	jmp    802333 <devcons_read+0x11>
		return 0;
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
  80235d:	eb d4                	jmp    802333 <devcons_read+0x11>

0080235f <cputchar>:
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80236b:	6a 01                	push   $0x1
  80236d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802370:	50                   	push   %eax
  802371:	e8 5c e8 ff ff       	call   800bd2 <sys_cputs>
}
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <getchar>:
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802381:	6a 01                	push   $0x1
  802383:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802386:	50                   	push   %eax
  802387:	6a 00                	push   $0x0
  802389:	e8 1e f2 ff ff       	call   8015ac <read>
	if (r < 0)
  80238e:	83 c4 10             	add    $0x10,%esp
  802391:	85 c0                	test   %eax,%eax
  802393:	78 08                	js     80239d <getchar+0x22>
	if (r < 1)
  802395:	85 c0                	test   %eax,%eax
  802397:	7e 06                	jle    80239f <getchar+0x24>
	return c;
  802399:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    
		return -E_EOF;
  80239f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023a4:	eb f7                	jmp    80239d <getchar+0x22>

008023a6 <iscons>:
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023af:	50                   	push   %eax
  8023b0:	ff 75 08             	pushl  0x8(%ebp)
  8023b3:	e8 83 ef ff ff       	call   80133b <fd_lookup>
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	78 11                	js     8023d0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023c8:	39 10                	cmp    %edx,(%eax)
  8023ca:	0f 94 c0             	sete   %al
  8023cd:	0f b6 c0             	movzbl %al,%eax
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <opencons>:
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023db:	50                   	push   %eax
  8023dc:	e8 0b ef ff ff       	call   8012ec <fd_alloc>
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 3a                	js     802422 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	68 07 04 00 00       	push   $0x407
  8023f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f3:	6a 00                	push   $0x0
  8023f5:	e8 94 e8 ff ff       	call   800c8e <sys_page_alloc>
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	78 21                	js     802422 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80240a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802416:	83 ec 0c             	sub    $0xc,%esp
  802419:	50                   	push   %eax
  80241a:	e8 a6 ee ff ff       	call   8012c5 <fd2num>
  80241f:	83 c4 10             	add    $0x10,%esp
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	56                   	push   %esi
  802428:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802429:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80242c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802432:	e8 19 e8 ff ff       	call   800c50 <sys_getenvid>
  802437:	83 ec 0c             	sub    $0xc,%esp
  80243a:	ff 75 0c             	pushl  0xc(%ebp)
  80243d:	ff 75 08             	pushl  0x8(%ebp)
  802440:	56                   	push   %esi
  802441:	50                   	push   %eax
  802442:	68 fc 2c 80 00       	push   $0x802cfc
  802447:	e8 ac dd ff ff       	call   8001f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80244c:	83 c4 18             	add    $0x18,%esp
  80244f:	53                   	push   %ebx
  802450:	ff 75 10             	pushl  0x10(%ebp)
  802453:	e8 4f dd ff ff       	call   8001a7 <vcprintf>
	cprintf("\n");
  802458:	c7 04 24 b0 2c 80 00 	movl   $0x802cb0,(%esp)
  80245f:	e8 94 dd ff ff       	call   8001f8 <cprintf>
  802464:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802467:	cc                   	int3   
  802468:	eb fd                	jmp    802467 <_panic+0x43>

0080246a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802470:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802477:	74 0a                	je     802483 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802483:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802488:	8b 40 48             	mov    0x48(%eax),%eax
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	6a 07                	push   $0x7
  802490:	68 00 f0 bf ee       	push   $0xeebff000
  802495:	50                   	push   %eax
  802496:	e8 f3 e7 ff ff       	call   800c8e <sys_page_alloc>
  80249b:	83 c4 10             	add    $0x10,%esp
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	75 2f                	jne    8024d1 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8024a2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8024a7:	8b 40 48             	mov    0x48(%eax),%eax
  8024aa:	83 ec 08             	sub    $0x8,%esp
  8024ad:	68 e3 24 80 00       	push   $0x8024e3
  8024b2:	50                   	push   %eax
  8024b3:	e8 21 e9 ff ff       	call   800dd9 <sys_env_set_pgfault_upcall>
  8024b8:	83 c4 10             	add    $0x10,%esp
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 ba                	je     802479 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8024bf:	50                   	push   %eax
  8024c0:	68 20 2d 80 00       	push   $0x802d20
  8024c5:	6a 24                	push   $0x24
  8024c7:	68 38 2d 80 00       	push   $0x802d38
  8024cc:	e8 53 ff ff ff       	call   802424 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8024d1:	50                   	push   %eax
  8024d2:	68 20 2d 80 00       	push   $0x802d20
  8024d7:	6a 21                	push   $0x21
  8024d9:	68 38 2d 80 00       	push   $0x802d38
  8024de:	e8 41 ff ff ff       	call   802424 <_panic>

008024e3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024e3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024e4:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024e9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024eb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8024ee:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8024f2:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8024f5:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8024f9:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8024fd:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8024ff:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  802502:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  802503:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  802506:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802507:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802508:	c3                   	ret    

00802509 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80250f:	89 d0                	mov    %edx,%eax
  802511:	c1 e8 16             	shr    $0x16,%eax
  802514:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802520:	f6 c1 01             	test   $0x1,%cl
  802523:	74 1d                	je     802542 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802525:	c1 ea 0c             	shr    $0xc,%edx
  802528:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80252f:	f6 c2 01             	test   $0x1,%dl
  802532:	74 0e                	je     802542 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802534:	c1 ea 0c             	shr    $0xc,%edx
  802537:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80253e:	ef 
  80253f:	0f b7 c0             	movzwl %ax,%eax
}
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
  802544:	66 90                	xchg   %ax,%ax
  802546:	66 90                	xchg   %ax,%ax
  802548:	66 90                	xchg   %ax,%ax
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__udivdi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80255b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80255f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802563:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802567:	85 d2                	test   %edx,%edx
  802569:	75 35                	jne    8025a0 <__udivdi3+0x50>
  80256b:	39 f3                	cmp    %esi,%ebx
  80256d:	0f 87 bd 00 00 00    	ja     802630 <__udivdi3+0xe0>
  802573:	85 db                	test   %ebx,%ebx
  802575:	89 d9                	mov    %ebx,%ecx
  802577:	75 0b                	jne    802584 <__udivdi3+0x34>
  802579:	b8 01 00 00 00       	mov    $0x1,%eax
  80257e:	31 d2                	xor    %edx,%edx
  802580:	f7 f3                	div    %ebx
  802582:	89 c1                	mov    %eax,%ecx
  802584:	31 d2                	xor    %edx,%edx
  802586:	89 f0                	mov    %esi,%eax
  802588:	f7 f1                	div    %ecx
  80258a:	89 c6                	mov    %eax,%esi
  80258c:	89 e8                	mov    %ebp,%eax
  80258e:	89 f7                	mov    %esi,%edi
  802590:	f7 f1                	div    %ecx
  802592:	89 fa                	mov    %edi,%edx
  802594:	83 c4 1c             	add    $0x1c,%esp
  802597:	5b                   	pop    %ebx
  802598:	5e                   	pop    %esi
  802599:	5f                   	pop    %edi
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    
  80259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a0:	39 f2                	cmp    %esi,%edx
  8025a2:	77 7c                	ja     802620 <__udivdi3+0xd0>
  8025a4:	0f bd fa             	bsr    %edx,%edi
  8025a7:	83 f7 1f             	xor    $0x1f,%edi
  8025aa:	0f 84 98 00 00 00    	je     802648 <__udivdi3+0xf8>
  8025b0:	89 f9                	mov    %edi,%ecx
  8025b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b7:	29 f8                	sub    %edi,%eax
  8025b9:	d3 e2                	shl    %cl,%edx
  8025bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025bf:	89 c1                	mov    %eax,%ecx
  8025c1:	89 da                	mov    %ebx,%edx
  8025c3:	d3 ea                	shr    %cl,%edx
  8025c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025c9:	09 d1                	or     %edx,%ecx
  8025cb:	89 f2                	mov    %esi,%edx
  8025cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025d1:	89 f9                	mov    %edi,%ecx
  8025d3:	d3 e3                	shl    %cl,%ebx
  8025d5:	89 c1                	mov    %eax,%ecx
  8025d7:	d3 ea                	shr    %cl,%edx
  8025d9:	89 f9                	mov    %edi,%ecx
  8025db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025df:	d3 e6                	shl    %cl,%esi
  8025e1:	89 eb                	mov    %ebp,%ebx
  8025e3:	89 c1                	mov    %eax,%ecx
  8025e5:	d3 eb                	shr    %cl,%ebx
  8025e7:	09 de                	or     %ebx,%esi
  8025e9:	89 f0                	mov    %esi,%eax
  8025eb:	f7 74 24 08          	divl   0x8(%esp)
  8025ef:	89 d6                	mov    %edx,%esi
  8025f1:	89 c3                	mov    %eax,%ebx
  8025f3:	f7 64 24 0c          	mull   0xc(%esp)
  8025f7:	39 d6                	cmp    %edx,%esi
  8025f9:	72 0c                	jb     802607 <__udivdi3+0xb7>
  8025fb:	89 f9                	mov    %edi,%ecx
  8025fd:	d3 e5                	shl    %cl,%ebp
  8025ff:	39 c5                	cmp    %eax,%ebp
  802601:	73 5d                	jae    802660 <__udivdi3+0x110>
  802603:	39 d6                	cmp    %edx,%esi
  802605:	75 59                	jne    802660 <__udivdi3+0x110>
  802607:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80260a:	31 ff                	xor    %edi,%edi
  80260c:	89 fa                	mov    %edi,%edx
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	8d 76 00             	lea    0x0(%esi),%esi
  802619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802620:	31 ff                	xor    %edi,%edi
  802622:	31 c0                	xor    %eax,%eax
  802624:	89 fa                	mov    %edi,%edx
  802626:	83 c4 1c             	add    $0x1c,%esp
  802629:	5b                   	pop    %ebx
  80262a:	5e                   	pop    %esi
  80262b:	5f                   	pop    %edi
  80262c:	5d                   	pop    %ebp
  80262d:	c3                   	ret    
  80262e:	66 90                	xchg   %ax,%ax
  802630:	31 ff                	xor    %edi,%edi
  802632:	89 e8                	mov    %ebp,%eax
  802634:	89 f2                	mov    %esi,%edx
  802636:	f7 f3                	div    %ebx
  802638:	89 fa                	mov    %edi,%edx
  80263a:	83 c4 1c             	add    $0x1c,%esp
  80263d:	5b                   	pop    %ebx
  80263e:	5e                   	pop    %esi
  80263f:	5f                   	pop    %edi
  802640:	5d                   	pop    %ebp
  802641:	c3                   	ret    
  802642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	72 06                	jb     802652 <__udivdi3+0x102>
  80264c:	31 c0                	xor    %eax,%eax
  80264e:	39 eb                	cmp    %ebp,%ebx
  802650:	77 d2                	ja     802624 <__udivdi3+0xd4>
  802652:	b8 01 00 00 00       	mov    $0x1,%eax
  802657:	eb cb                	jmp    802624 <__udivdi3+0xd4>
  802659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802660:	89 d8                	mov    %ebx,%eax
  802662:	31 ff                	xor    %edi,%edi
  802664:	eb be                	jmp    802624 <__udivdi3+0xd4>
  802666:	66 90                	xchg   %ax,%ax
  802668:	66 90                	xchg   %ax,%ax
  80266a:	66 90                	xchg   %ax,%ax
  80266c:	66 90                	xchg   %ax,%ax
  80266e:	66 90                	xchg   %ax,%ax

00802670 <__umoddi3>:
  802670:	55                   	push   %ebp
  802671:	57                   	push   %edi
  802672:	56                   	push   %esi
  802673:	53                   	push   %ebx
  802674:	83 ec 1c             	sub    $0x1c,%esp
  802677:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80267b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80267f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802683:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802687:	85 ed                	test   %ebp,%ebp
  802689:	89 f0                	mov    %esi,%eax
  80268b:	89 da                	mov    %ebx,%edx
  80268d:	75 19                	jne    8026a8 <__umoddi3+0x38>
  80268f:	39 df                	cmp    %ebx,%edi
  802691:	0f 86 b1 00 00 00    	jbe    802748 <__umoddi3+0xd8>
  802697:	f7 f7                	div    %edi
  802699:	89 d0                	mov    %edx,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	83 c4 1c             	add    $0x1c,%esp
  8026a0:	5b                   	pop    %ebx
  8026a1:	5e                   	pop    %esi
  8026a2:	5f                   	pop    %edi
  8026a3:	5d                   	pop    %ebp
  8026a4:	c3                   	ret    
  8026a5:	8d 76 00             	lea    0x0(%esi),%esi
  8026a8:	39 dd                	cmp    %ebx,%ebp
  8026aa:	77 f1                	ja     80269d <__umoddi3+0x2d>
  8026ac:	0f bd cd             	bsr    %ebp,%ecx
  8026af:	83 f1 1f             	xor    $0x1f,%ecx
  8026b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026b6:	0f 84 b4 00 00 00    	je     802770 <__umoddi3+0x100>
  8026bc:	b8 20 00 00 00       	mov    $0x20,%eax
  8026c1:	89 c2                	mov    %eax,%edx
  8026c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026c7:	29 c2                	sub    %eax,%edx
  8026c9:	89 c1                	mov    %eax,%ecx
  8026cb:	89 f8                	mov    %edi,%eax
  8026cd:	d3 e5                	shl    %cl,%ebp
  8026cf:	89 d1                	mov    %edx,%ecx
  8026d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026d5:	d3 e8                	shr    %cl,%eax
  8026d7:	09 c5                	or     %eax,%ebp
  8026d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026dd:	89 c1                	mov    %eax,%ecx
  8026df:	d3 e7                	shl    %cl,%edi
  8026e1:	89 d1                	mov    %edx,%ecx
  8026e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026e7:	89 df                	mov    %ebx,%edi
  8026e9:	d3 ef                	shr    %cl,%edi
  8026eb:	89 c1                	mov    %eax,%ecx
  8026ed:	89 f0                	mov    %esi,%eax
  8026ef:	d3 e3                	shl    %cl,%ebx
  8026f1:	89 d1                	mov    %edx,%ecx
  8026f3:	89 fa                	mov    %edi,%edx
  8026f5:	d3 e8                	shr    %cl,%eax
  8026f7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fc:	09 d8                	or     %ebx,%eax
  8026fe:	f7 f5                	div    %ebp
  802700:	d3 e6                	shl    %cl,%esi
  802702:	89 d1                	mov    %edx,%ecx
  802704:	f7 64 24 08          	mull   0x8(%esp)
  802708:	39 d1                	cmp    %edx,%ecx
  80270a:	89 c3                	mov    %eax,%ebx
  80270c:	89 d7                	mov    %edx,%edi
  80270e:	72 06                	jb     802716 <__umoddi3+0xa6>
  802710:	75 0e                	jne    802720 <__umoddi3+0xb0>
  802712:	39 c6                	cmp    %eax,%esi
  802714:	73 0a                	jae    802720 <__umoddi3+0xb0>
  802716:	2b 44 24 08          	sub    0x8(%esp),%eax
  80271a:	19 ea                	sbb    %ebp,%edx
  80271c:	89 d7                	mov    %edx,%edi
  80271e:	89 c3                	mov    %eax,%ebx
  802720:	89 ca                	mov    %ecx,%edx
  802722:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802727:	29 de                	sub    %ebx,%esi
  802729:	19 fa                	sbb    %edi,%edx
  80272b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80272f:	89 d0                	mov    %edx,%eax
  802731:	d3 e0                	shl    %cl,%eax
  802733:	89 d9                	mov    %ebx,%ecx
  802735:	d3 ee                	shr    %cl,%esi
  802737:	d3 ea                	shr    %cl,%edx
  802739:	09 f0                	or     %esi,%eax
  80273b:	83 c4 1c             	add    $0x1c,%esp
  80273e:	5b                   	pop    %ebx
  80273f:	5e                   	pop    %esi
  802740:	5f                   	pop    %edi
  802741:	5d                   	pop    %ebp
  802742:	c3                   	ret    
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	85 ff                	test   %edi,%edi
  80274a:	89 f9                	mov    %edi,%ecx
  80274c:	75 0b                	jne    802759 <__umoddi3+0xe9>
  80274e:	b8 01 00 00 00       	mov    $0x1,%eax
  802753:	31 d2                	xor    %edx,%edx
  802755:	f7 f7                	div    %edi
  802757:	89 c1                	mov    %eax,%ecx
  802759:	89 d8                	mov    %ebx,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	f7 f1                	div    %ecx
  80275f:	89 f0                	mov    %esi,%eax
  802761:	f7 f1                	div    %ecx
  802763:	e9 31 ff ff ff       	jmp    802699 <__umoddi3+0x29>
  802768:	90                   	nop
  802769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802770:	39 dd                	cmp    %ebx,%ebp
  802772:	72 08                	jb     80277c <__umoddi3+0x10c>
  802774:	39 f7                	cmp    %esi,%edi
  802776:	0f 87 21 ff ff ff    	ja     80269d <__umoddi3+0x2d>
  80277c:	89 da                	mov    %ebx,%edx
  80277e:	89 f0                	mov    %esi,%eax
  802780:	29 f8                	sub    %edi,%eax
  802782:	19 ea                	sbb    %ebp,%edx
  802784:	e9 14 ff ff ff       	jmp    80269d <__umoddi3+0x2d>
