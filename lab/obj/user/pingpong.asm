
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 04 0f 00 00       	call   800f45 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 2f 11 00 00       	call   801187 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 ab 0b 00 00       	call   800c0d <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 76 27 80 00       	push   $0x802776
  80006a:	e8 46 01 00 00       	call   8001b5 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 69 11 00 00       	call   8011f0 <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 6f 0b 00 00       	call   800c0d <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 60 27 80 00       	push   $0x802760
  8000a8:	e8 08 01 00 00       	call   8001b5 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 35 11 00 00       	call   8011f0 <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000cb:	e8 3d 0b 00 00       	call   800c0d <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	85 db                	test   %ebx,%ebx
  8000e4:	7e 07                	jle    8000ed <libmain+0x2d>
		binaryname = argv[0];
  8000e6:	8b 06                	mov    (%esi),%eax
  8000e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0a 00 00 00       	call   800106 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010c:	e8 47 13 00 00       	call   801458 <close_all>
	sys_env_destroy(0);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	6a 00                	push   $0x0
  800116:	e8 b1 0a 00 00       	call   800bcc <sys_env_destroy>
}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    

00800120 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	53                   	push   %ebx
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012a:	8b 13                	mov    (%ebx),%edx
  80012c:	8d 42 01             	lea    0x1(%edx),%eax
  80012f:	89 03                	mov    %eax,(%ebx)
  800131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800134:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800138:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013d:	74 09                	je     800148 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800146:	c9                   	leave  
  800147:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 ff 00 00 00       	push   $0xff
  800150:	8d 43 08             	lea    0x8(%ebx),%eax
  800153:	50                   	push   %eax
  800154:	e8 36 0a 00 00       	call   800b8f <sys_cputs>
		b->idx = 0;
  800159:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb db                	jmp    80013f <putch+0x1f>

00800164 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800174:	00 00 00 
	b.cnt = 0;
  800177:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	68 20 01 80 00       	push   $0x800120
  800193:	e8 1a 01 00 00       	call   8002b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800198:	83 c4 08             	add    $0x8,%esp
  80019b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 e2 09 00 00       	call   800b8f <sys_cputs>

	return b.cnt;
}
  8001ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001be:	50                   	push   %eax
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	e8 9d ff ff ff       	call   800164 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	57                   	push   %edi
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 1c             	sub    $0x1c,%esp
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 d6                	mov    %edx,%esi
  8001d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001df:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f0:	39 d3                	cmp    %edx,%ebx
  8001f2:	72 05                	jb     8001f9 <printnum+0x30>
  8001f4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f7:	77 7a                	ja     800273 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 18             	pushl  0x18(%ebp)
  8001ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800202:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800205:	53                   	push   %ebx
  800206:	ff 75 10             	pushl  0x10(%ebp)
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020f:	ff 75 e0             	pushl  -0x20(%ebp)
  800212:	ff 75 dc             	pushl  -0x24(%ebp)
  800215:	ff 75 d8             	pushl  -0x28(%ebp)
  800218:	e8 f3 22 00 00       	call   802510 <__udivdi3>
  80021d:	83 c4 18             	add    $0x18,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	89 f2                	mov    %esi,%edx
  800224:	89 f8                	mov    %edi,%eax
  800226:	e8 9e ff ff ff       	call   8001c9 <printnum>
  80022b:	83 c4 20             	add    $0x20,%esp
  80022e:	eb 13                	jmp    800243 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	56                   	push   %esi
  800234:	ff 75 18             	pushl  0x18(%ebp)
  800237:	ff d7                	call   *%edi
  800239:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023c:	83 eb 01             	sub    $0x1,%ebx
  80023f:	85 db                	test   %ebx,%ebx
  800241:	7f ed                	jg     800230 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	56                   	push   %esi
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024d:	ff 75 e0             	pushl  -0x20(%ebp)
  800250:	ff 75 dc             	pushl  -0x24(%ebp)
  800253:	ff 75 d8             	pushl  -0x28(%ebp)
  800256:	e8 d5 23 00 00       	call   802630 <__umoddi3>
  80025b:	83 c4 14             	add    $0x14,%esp
  80025e:	0f be 80 93 27 80 00 	movsbl 0x802793(%eax),%eax
  800265:	50                   	push   %eax
  800266:	ff d7                	call   *%edi
}
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
  800273:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800276:	eb c4                	jmp    80023c <printnum+0x73>

00800278 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800282:	8b 10                	mov    (%eax),%edx
  800284:	3b 50 04             	cmp    0x4(%eax),%edx
  800287:	73 0a                	jae    800293 <sprintputch+0x1b>
		*b->buf++ = ch;
  800289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	88 02                	mov    %al,(%edx)
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <printfmt>:
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029e:	50                   	push   %eax
  80029f:	ff 75 10             	pushl  0x10(%ebp)
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	e8 05 00 00 00       	call   8002b2 <vprintfmt>
}
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <vprintfmt>:
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 2c             	sub    $0x2c,%esp
  8002bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8002be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c4:	e9 21 04 00 00       	jmp    8006ea <vprintfmt+0x438>
		padc = ' ';
  8002c9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8d 47 01             	lea    0x1(%edi),%eax
  8002ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ed:	0f b6 17             	movzbl (%edi),%edx
  8002f0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f3:	3c 55                	cmp    $0x55,%al
  8002f5:	0f 87 90 04 00 00    	ja     80078b <vprintfmt+0x4d9>
  8002fb:	0f b6 c0             	movzbl %al,%eax
  8002fe:	ff 24 85 e0 28 80 00 	jmp    *0x8028e0(,%eax,4)
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800308:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80030c:	eb d9                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800311:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800315:	eb d0                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800317:	0f b6 d2             	movzbl %dl,%edx
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800325:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800328:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800332:	83 f9 09             	cmp    $0x9,%ecx
  800335:	77 55                	ja     80038c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800337:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033a:	eb e9                	jmp    800325 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 40 04             	lea    0x4(%eax),%eax
  80034a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800354:	79 91                	jns    8002e7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800356:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800363:	eb 82                	jmp    8002e7 <vprintfmt+0x35>
  800365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	ba 00 00 00 00       	mov    $0x0,%edx
  80036f:	0f 49 d0             	cmovns %eax,%edx
  800372:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800378:	e9 6a ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800380:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800387:	e9 5b ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800392:	eb bc                	jmp    800350 <vprintfmt+0x9e>
			lflag++;
  800394:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039a:	e9 48 ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8d 78 04             	lea    0x4(%eax),%edi
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 30                	pushl  (%eax)
  8003ab:	ff d6                	call   *%esi
			break;
  8003ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b3:	e9 2f 03 00 00       	jmp    8006e7 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 78 04             	lea    0x4(%eax),%edi
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	99                   	cltd   
  8003c1:	31 d0                	xor    %edx,%eax
  8003c3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c5:	83 f8 0f             	cmp    $0xf,%eax
  8003c8:	7f 23                	jg     8003ed <vprintfmt+0x13b>
  8003ca:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 18                	je     8003ed <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003d5:	52                   	push   %edx
  8003d6:	68 17 2c 80 00       	push   $0x802c17
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 b3 fe ff ff       	call   800295 <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e8:	e9 fa 02 00 00       	jmp    8006e7 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8003ed:	50                   	push   %eax
  8003ee:	68 ab 27 80 00       	push   $0x8027ab
  8003f3:	53                   	push   %ebx
  8003f4:	56                   	push   %esi
  8003f5:	e8 9b fe ff ff       	call   800295 <printfmt>
  8003fa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800400:	e9 e2 02 00 00       	jmp    8006e7 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	83 c0 04             	add    $0x4,%eax
  80040b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800413:	85 ff                	test   %edi,%edi
  800415:	b8 a4 27 80 00       	mov    $0x8027a4,%eax
  80041a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80041d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800421:	0f 8e bd 00 00 00    	jle    8004e4 <vprintfmt+0x232>
  800427:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80042b:	75 0e                	jne    80043b <vprintfmt+0x189>
  80042d:	89 75 08             	mov    %esi,0x8(%ebp)
  800430:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800433:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800436:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800439:	eb 6d                	jmp    8004a8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 d0             	pushl  -0x30(%ebp)
  800441:	57                   	push   %edi
  800442:	e8 ec 03 00 00       	call   800833 <strnlen>
  800447:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044a:	29 c1                	sub    %eax,%ecx
  80044c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80044f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800452:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800459:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80045c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	eb 0f                	jmp    80046f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	53                   	push   %ebx
  800464:	ff 75 e0             	pushl  -0x20(%ebp)
  800467:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800469:	83 ef 01             	sub    $0x1,%edi
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	85 ff                	test   %edi,%edi
  800471:	7f ed                	jg     800460 <vprintfmt+0x1ae>
  800473:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800476:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800479:	85 c9                	test   %ecx,%ecx
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
  800480:	0f 49 c1             	cmovns %ecx,%eax
  800483:	29 c1                	sub    %eax,%ecx
  800485:	89 75 08             	mov    %esi,0x8(%ebp)
  800488:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048e:	89 cb                	mov    %ecx,%ebx
  800490:	eb 16                	jmp    8004a8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800492:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800496:	75 31                	jne    8004c9 <vprintfmt+0x217>
					putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	ff 75 0c             	pushl  0xc(%ebp)
  80049e:	50                   	push   %eax
  80049f:	ff 55 08             	call   *0x8(%ebp)
  8004a2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a5:	83 eb 01             	sub    $0x1,%ebx
  8004a8:	83 c7 01             	add    $0x1,%edi
  8004ab:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004af:	0f be c2             	movsbl %dl,%eax
  8004b2:	85 c0                	test   %eax,%eax
  8004b4:	74 59                	je     80050f <vprintfmt+0x25d>
  8004b6:	85 f6                	test   %esi,%esi
  8004b8:	78 d8                	js     800492 <vprintfmt+0x1e0>
  8004ba:	83 ee 01             	sub    $0x1,%esi
  8004bd:	79 d3                	jns    800492 <vprintfmt+0x1e0>
  8004bf:	89 df                	mov    %ebx,%edi
  8004c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c7:	eb 37                	jmp    800500 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c9:	0f be d2             	movsbl %dl,%edx
  8004cc:	83 ea 20             	sub    $0x20,%edx
  8004cf:	83 fa 5e             	cmp    $0x5e,%edx
  8004d2:	76 c4                	jbe    800498 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	6a 3f                	push   $0x3f
  8004dc:	ff 55 08             	call   *0x8(%ebp)
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	eb c1                	jmp    8004a5 <vprintfmt+0x1f3>
  8004e4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ea:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f0:	eb b6                	jmp    8004a8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	53                   	push   %ebx
  8004f6:	6a 20                	push   $0x20
  8004f8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fa:	83 ef 01             	sub    $0x1,%edi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	85 ff                	test   %edi,%edi
  800502:	7f ee                	jg     8004f2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	e9 d8 01 00 00       	jmp    8006e7 <vprintfmt+0x435>
  80050f:	89 df                	mov    %ebx,%edi
  800511:	8b 75 08             	mov    0x8(%ebp),%esi
  800514:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800517:	eb e7                	jmp    800500 <vprintfmt+0x24e>
	if (lflag >= 2)
  800519:	83 f9 01             	cmp    $0x1,%ecx
  80051c:	7e 45                	jle    800563 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8b 50 04             	mov    0x4(%eax),%edx
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 08             	lea    0x8(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800539:	79 62                	jns    80059d <vprintfmt+0x2eb>
				putch('-', putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	53                   	push   %ebx
  80053f:	6a 2d                	push   $0x2d
  800541:	ff d6                	call   *%esi
				num = -(long long) num;
  800543:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800546:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800549:	f7 d8                	neg    %eax
  80054b:	83 d2 00             	adc    $0x0,%edx
  80054e:	f7 da                	neg    %edx
  800550:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800553:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800556:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800559:	ba 0a 00 00 00       	mov    $0xa,%edx
  80055e:	e9 66 01 00 00       	jmp    8006c9 <vprintfmt+0x417>
	else if (lflag)
  800563:	85 c9                	test   %ecx,%ecx
  800565:	75 1b                	jne    800582 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056f:	89 c1                	mov    %eax,%ecx
  800571:	c1 f9 1f             	sar    $0x1f,%ecx
  800574:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8d 40 04             	lea    0x4(%eax),%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
  800580:	eb b3                	jmp    800535 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058a:	89 c1                	mov    %eax,%ecx
  80058c:	c1 f9 1f             	sar    $0x1f,%ecx
  80058f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
  80059b:	eb 98                	jmp    800535 <vprintfmt+0x283>
			base = 10;
  80059d:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005a2:	e9 22 01 00 00       	jmp    8006c9 <vprintfmt+0x417>
	if (lflag >= 2)
  8005a7:	83 f9 01             	cmp    $0x1,%ecx
  8005aa:	7e 21                	jle    8005cd <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8b 50 04             	mov    0x4(%eax),%edx
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 08             	lea    0x8(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c3:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005c8:	e9 fc 00 00 00       	jmp    8006c9 <vprintfmt+0x417>
	else if (lflag)
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	75 23                	jne    8005f4 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 04             	lea    0x4(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ea:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005ef:	e9 d5 00 00 00       	jmp    8006c9 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
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
  800612:	e9 b2 00 00 00       	jmp    8006c9 <vprintfmt+0x417>
	if (lflag >= 2)
  800617:	83 f9 01             	cmp    $0x1,%ecx
  80061a:	7e 42                	jle    80065e <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 50 04             	mov    0x4(%eax),%edx
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800627:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 40 08             	lea    0x8(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800633:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800638:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80063c:	0f 89 87 00 00 00    	jns    8006c9 <vprintfmt+0x417>
				putch('-', putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	6a 2d                	push   $0x2d
  800648:	ff d6                	call   *%esi
				num = -(long long) num;
  80064a:	f7 5d d8             	negl   -0x28(%ebp)
  80064d:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800651:	f7 5d dc             	negl   -0x24(%ebp)
  800654:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800657:	ba 08 00 00 00       	mov    $0x8,%edx
  80065c:	eb 6b                	jmp    8006c9 <vprintfmt+0x417>
	else if (lflag)
  80065e:	85 c9                	test   %ecx,%ecx
  800660:	75 1b                	jne    80067d <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
  80067b:	eb b6                	jmp    800633 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	ba 00 00 00 00       	mov    $0x0,%edx
  800687:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
  800696:	eb 9b                	jmp    800633 <vprintfmt+0x381>
			putch('0', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 30                	push   $0x30
  80069e:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a0:	83 c4 08             	add    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	6a 78                	push   $0x78
  8006a6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006b8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 40 04             	lea    0x4(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c4:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006d0:	50                   	push   %eax
  8006d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d4:	52                   	push   %edx
  8006d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8006d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8006db:	89 da                	mov    %ebx,%edx
  8006dd:	89 f0                	mov    %esi,%eax
  8006df:	e8 e5 fa ff ff       	call   8001c9 <printnum>
			break;
  8006e4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ea:	83 c7 01             	add    $0x1,%edi
  8006ed:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f1:	83 f8 25             	cmp    $0x25,%eax
  8006f4:	0f 84 cf fb ff ff    	je     8002c9 <vprintfmt+0x17>
			if (ch == '\0')
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	0f 84 a9 00 00 00    	je     8007ab <vprintfmt+0x4f9>
			putch(ch, putdat);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	50                   	push   %eax
  800707:	ff d6                	call   *%esi
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	eb dc                	jmp    8006ea <vprintfmt+0x438>
	if (lflag >= 2)
  80070e:	83 f9 01             	cmp    $0x1,%ecx
  800711:	7e 1e                	jle    800731 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 50 04             	mov    0x4(%eax),%edx
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 08             	lea    0x8(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072a:	ba 10 00 00 00       	mov    $0x10,%edx
  80072f:	eb 98                	jmp    8006c9 <vprintfmt+0x417>
	else if (lflag)
  800731:	85 c9                	test   %ecx,%ecx
  800733:	75 23                	jne    800758 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	ba 00 00 00 00       	mov    $0x0,%edx
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074e:	ba 10 00 00 00       	mov    $0x10,%edx
  800753:	e9 71 ff ff ff       	jmp    8006c9 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
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
  800776:	e9 4e ff ff ff       	jmp    8006c9 <vprintfmt+0x417>
			putch(ch, putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 25                	push   $0x25
  800781:	ff d6                	call   *%esi
			break;
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	e9 5c ff ff ff       	jmp    8006e7 <vprintfmt+0x435>
			putch('%', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	53                   	push   %ebx
  80078f:	6a 25                	push   $0x25
  800791:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	89 f8                	mov    %edi,%eax
  800798:	eb 03                	jmp    80079d <vprintfmt+0x4eb>
  80079a:	83 e8 01             	sub    $0x1,%eax
  80079d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a1:	75 f7                	jne    80079a <vprintfmt+0x4e8>
  8007a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a6:	e9 3c ff ff ff       	jmp    8006e7 <vprintfmt+0x435>
}
  8007ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ae:	5b                   	pop    %ebx
  8007af:	5e                   	pop    %esi
  8007b0:	5f                   	pop    %edi
  8007b1:	5d                   	pop    %ebp
  8007b2:	c3                   	ret    

008007b3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	83 ec 18             	sub    $0x18,%esp
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 26                	je     8007fa <vsnprintf+0x47>
  8007d4:	85 d2                	test   %edx,%edx
  8007d6:	7e 22                	jle    8007fa <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d8:	ff 75 14             	pushl  0x14(%ebp)
  8007db:	ff 75 10             	pushl  0x10(%ebp)
  8007de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e1:	50                   	push   %eax
  8007e2:	68 78 02 80 00       	push   $0x800278
  8007e7:	e8 c6 fa ff ff       	call   8002b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    
		return -E_INVAL;
  8007fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ff:	eb f7                	jmp    8007f8 <vsnprintf+0x45>

00800801 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800807:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80080a:	50                   	push   %eax
  80080b:	ff 75 10             	pushl  0x10(%ebp)
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	ff 75 08             	pushl  0x8(%ebp)
  800814:	e8 9a ff ff ff       	call   8007b3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800819:	c9                   	leave  
  80081a:	c3                   	ret    

0080081b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800821:	b8 00 00 00 00       	mov    $0x0,%eax
  800826:	eb 03                	jmp    80082b <strlen+0x10>
		n++;
  800828:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80082b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80082f:	75 f7                	jne    800828 <strlen+0xd>
	return n;
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	eb 03                	jmp    800846 <strnlen+0x13>
		n++;
  800843:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800846:	39 d0                	cmp    %edx,%eax
  800848:	74 06                	je     800850 <strnlen+0x1d>
  80084a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084e:	75 f3                	jne    800843 <strnlen+0x10>
	return n;
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80085c:	89 c2                	mov    %eax,%edx
  80085e:	83 c1 01             	add    $0x1,%ecx
  800861:	83 c2 01             	add    $0x1,%edx
  800864:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800868:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086b:	84 db                	test   %bl,%bl
  80086d:	75 ef                	jne    80085e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80086f:	5b                   	pop    %ebx
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800879:	53                   	push   %ebx
  80087a:	e8 9c ff ff ff       	call   80081b <strlen>
  80087f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800882:	ff 75 0c             	pushl  0xc(%ebp)
  800885:	01 d8                	add    %ebx,%eax
  800887:	50                   	push   %eax
  800888:	e8 c5 ff ff ff       	call   800852 <strcpy>
	return dst;
}
  80088d:	89 d8                	mov    %ebx,%eax
  80088f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800892:	c9                   	leave  
  800893:	c3                   	ret    

00800894 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	56                   	push   %esi
  800898:	53                   	push   %ebx
  800899:	8b 75 08             	mov    0x8(%ebp),%esi
  80089c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089f:	89 f3                	mov    %esi,%ebx
  8008a1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a4:	89 f2                	mov    %esi,%edx
  8008a6:	eb 0f                	jmp    8008b7 <strncpy+0x23>
		*dst++ = *src;
  8008a8:	83 c2 01             	add    $0x1,%edx
  8008ab:	0f b6 01             	movzbl (%ecx),%eax
  8008ae:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b1:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b7:	39 da                	cmp    %ebx,%edx
  8008b9:	75 ed                	jne    8008a8 <strncpy+0x14>
	}
	return ret;
}
  8008bb:	89 f0                	mov    %esi,%eax
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	56                   	push   %esi
  8008c5:	53                   	push   %ebx
  8008c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d5:	85 c9                	test   %ecx,%ecx
  8008d7:	75 0b                	jne    8008e4 <strlcpy+0x23>
  8008d9:	eb 17                	jmp    8008f2 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008db:	83 c2 01             	add    $0x1,%edx
  8008de:	83 c0 01             	add    $0x1,%eax
  8008e1:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008e4:	39 d8                	cmp    %ebx,%eax
  8008e6:	74 07                	je     8008ef <strlcpy+0x2e>
  8008e8:	0f b6 0a             	movzbl (%edx),%ecx
  8008eb:	84 c9                	test   %cl,%cl
  8008ed:	75 ec                	jne    8008db <strlcpy+0x1a>
		*dst = '\0';
  8008ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f2:	29 f0                	sub    %esi,%eax
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800901:	eb 06                	jmp    800909 <strcmp+0x11>
		p++, q++;
  800903:	83 c1 01             	add    $0x1,%ecx
  800906:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800909:	0f b6 01             	movzbl (%ecx),%eax
  80090c:	84 c0                	test   %al,%al
  80090e:	74 04                	je     800914 <strcmp+0x1c>
  800910:	3a 02                	cmp    (%edx),%al
  800912:	74 ef                	je     800903 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800914:	0f b6 c0             	movzbl %al,%eax
  800917:	0f b6 12             	movzbl (%edx),%edx
  80091a:	29 d0                	sub    %edx,%eax
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 55 0c             	mov    0xc(%ebp),%edx
  800928:	89 c3                	mov    %eax,%ebx
  80092a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80092d:	eb 06                	jmp    800935 <strncmp+0x17>
		n--, p++, q++;
  80092f:	83 c0 01             	add    $0x1,%eax
  800932:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800935:	39 d8                	cmp    %ebx,%eax
  800937:	74 16                	je     80094f <strncmp+0x31>
  800939:	0f b6 08             	movzbl (%eax),%ecx
  80093c:	84 c9                	test   %cl,%cl
  80093e:	74 04                	je     800944 <strncmp+0x26>
  800940:	3a 0a                	cmp    (%edx),%cl
  800942:	74 eb                	je     80092f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800944:	0f b6 00             	movzbl (%eax),%eax
  800947:	0f b6 12             	movzbl (%edx),%edx
  80094a:	29 d0                	sub    %edx,%eax
}
  80094c:	5b                   	pop    %ebx
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    
		return 0;
  80094f:	b8 00 00 00 00       	mov    $0x0,%eax
  800954:	eb f6                	jmp    80094c <strncmp+0x2e>

00800956 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800960:	0f b6 10             	movzbl (%eax),%edx
  800963:	84 d2                	test   %dl,%dl
  800965:	74 09                	je     800970 <strchr+0x1a>
		if (*s == c)
  800967:	38 ca                	cmp    %cl,%dl
  800969:	74 0a                	je     800975 <strchr+0x1f>
	for (; *s; s++)
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	eb f0                	jmp    800960 <strchr+0xa>
			return (char *) s;
	return 0;
  800970:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800981:	eb 03                	jmp    800986 <strfind+0xf>
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800989:	38 ca                	cmp    %cl,%dl
  80098b:	74 04                	je     800991 <strfind+0x1a>
  80098d:	84 d2                	test   %dl,%dl
  80098f:	75 f2                	jne    800983 <strfind+0xc>
			break;
	return (char *) s;
}
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	57                   	push   %edi
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80099f:	85 c9                	test   %ecx,%ecx
  8009a1:	74 13                	je     8009b6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a3:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a9:	75 05                	jne    8009b0 <memset+0x1d>
  8009ab:	f6 c1 03             	test   $0x3,%cl
  8009ae:	74 0d                	je     8009bd <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	fc                   	cld    
  8009b4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b6:	89 f8                	mov    %edi,%eax
  8009b8:	5b                   	pop    %ebx
  8009b9:	5e                   	pop    %esi
  8009ba:	5f                   	pop    %edi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    
		c &= 0xFF;
  8009bd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c1:	89 d3                	mov    %edx,%ebx
  8009c3:	c1 e3 08             	shl    $0x8,%ebx
  8009c6:	89 d0                	mov    %edx,%eax
  8009c8:	c1 e0 18             	shl    $0x18,%eax
  8009cb:	89 d6                	mov    %edx,%esi
  8009cd:	c1 e6 10             	shl    $0x10,%esi
  8009d0:	09 f0                	or     %esi,%eax
  8009d2:	09 c2                	or     %eax,%edx
  8009d4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009d6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d9:	89 d0                	mov    %edx,%eax
  8009db:	fc                   	cld    
  8009dc:	f3 ab                	rep stos %eax,%es:(%edi)
  8009de:	eb d6                	jmp    8009b6 <memset+0x23>

008009e0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	57                   	push   %edi
  8009e4:	56                   	push   %esi
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ee:	39 c6                	cmp    %eax,%esi
  8009f0:	73 35                	jae    800a27 <memmove+0x47>
  8009f2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f5:	39 c2                	cmp    %eax,%edx
  8009f7:	76 2e                	jbe    800a27 <memmove+0x47>
		s += n;
		d += n;
  8009f9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fc:	89 d6                	mov    %edx,%esi
  8009fe:	09 fe                	or     %edi,%esi
  800a00:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a06:	74 0c                	je     800a14 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a08:	83 ef 01             	sub    $0x1,%edi
  800a0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0e:	fd                   	std    
  800a0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a11:	fc                   	cld    
  800a12:	eb 21                	jmp    800a35 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	f6 c1 03             	test   $0x3,%cl
  800a17:	75 ef                	jne    800a08 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a19:	83 ef 04             	sub    $0x4,%edi
  800a1c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a22:	fd                   	std    
  800a23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a25:	eb ea                	jmp    800a11 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a27:	89 f2                	mov    %esi,%edx
  800a29:	09 c2                	or     %eax,%edx
  800a2b:	f6 c2 03             	test   $0x3,%dl
  800a2e:	74 09                	je     800a39 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a30:	89 c7                	mov    %eax,%edi
  800a32:	fc                   	cld    
  800a33:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a35:	5e                   	pop    %esi
  800a36:	5f                   	pop    %edi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a39:	f6 c1 03             	test   $0x3,%cl
  800a3c:	75 f2                	jne    800a30 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a41:	89 c7                	mov    %eax,%edi
  800a43:	fc                   	cld    
  800a44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a46:	eb ed                	jmp    800a35 <memmove+0x55>

00800a48 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a4b:	ff 75 10             	pushl  0x10(%ebp)
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	ff 75 08             	pushl  0x8(%ebp)
  800a54:	e8 87 ff ff ff       	call   8009e0 <memmove>
}
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	89 c6                	mov    %eax,%esi
  800a68:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6b:	39 f0                	cmp    %esi,%eax
  800a6d:	74 1c                	je     800a8b <memcmp+0x30>
		if (*s1 != *s2)
  800a6f:	0f b6 08             	movzbl (%eax),%ecx
  800a72:	0f b6 1a             	movzbl (%edx),%ebx
  800a75:	38 d9                	cmp    %bl,%cl
  800a77:	75 08                	jne    800a81 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	eb ea                	jmp    800a6b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a81:	0f b6 c1             	movzbl %cl,%eax
  800a84:	0f b6 db             	movzbl %bl,%ebx
  800a87:	29 d8                	sub    %ebx,%eax
  800a89:	eb 05                	jmp    800a90 <memcmp+0x35>
	}

	return 0;
  800a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a90:	5b                   	pop    %ebx
  800a91:	5e                   	pop    %esi
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9d:	89 c2                	mov    %eax,%edx
  800a9f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa2:	39 d0                	cmp    %edx,%eax
  800aa4:	73 09                	jae    800aaf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa6:	38 08                	cmp    %cl,(%eax)
  800aa8:	74 05                	je     800aaf <memfind+0x1b>
	for (; s < ends; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	eb f3                	jmp    800aa2 <memfind+0xe>
			break;
	return (void *) s;
}
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	57                   	push   %edi
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
  800ab7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abd:	eb 03                	jmp    800ac2 <strtol+0x11>
		s++;
  800abf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ac2:	0f b6 01             	movzbl (%ecx),%eax
  800ac5:	3c 20                	cmp    $0x20,%al
  800ac7:	74 f6                	je     800abf <strtol+0xe>
  800ac9:	3c 09                	cmp    $0x9,%al
  800acb:	74 f2                	je     800abf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800acd:	3c 2b                	cmp    $0x2b,%al
  800acf:	74 2e                	je     800aff <strtol+0x4e>
	int neg = 0;
  800ad1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad6:	3c 2d                	cmp    $0x2d,%al
  800ad8:	74 2f                	je     800b09 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ada:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae0:	75 05                	jne    800ae7 <strtol+0x36>
  800ae2:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae5:	74 2c                	je     800b13 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae7:	85 db                	test   %ebx,%ebx
  800ae9:	75 0a                	jne    800af5 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aeb:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800af0:	80 39 30             	cmpb   $0x30,(%ecx)
  800af3:	74 28                	je     800b1d <strtol+0x6c>
		base = 10;
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
  800afa:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800afd:	eb 50                	jmp    800b4f <strtol+0x9e>
		s++;
  800aff:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b02:	bf 00 00 00 00       	mov    $0x0,%edi
  800b07:	eb d1                	jmp    800ada <strtol+0x29>
		s++, neg = 1;
  800b09:	83 c1 01             	add    $0x1,%ecx
  800b0c:	bf 01 00 00 00       	mov    $0x1,%edi
  800b11:	eb c7                	jmp    800ada <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b13:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b17:	74 0e                	je     800b27 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b19:	85 db                	test   %ebx,%ebx
  800b1b:	75 d8                	jne    800af5 <strtol+0x44>
		s++, base = 8;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b25:	eb ce                	jmp    800af5 <strtol+0x44>
		s += 2, base = 16;
  800b27:	83 c1 02             	add    $0x2,%ecx
  800b2a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b2f:	eb c4                	jmp    800af5 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b31:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b34:	89 f3                	mov    %esi,%ebx
  800b36:	80 fb 19             	cmp    $0x19,%bl
  800b39:	77 29                	ja     800b64 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3b:	0f be d2             	movsbl %dl,%edx
  800b3e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b41:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b44:	7d 30                	jge    800b76 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b46:	83 c1 01             	add    $0x1,%ecx
  800b49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b4d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b4f:	0f b6 11             	movzbl (%ecx),%edx
  800b52:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b55:	89 f3                	mov    %esi,%ebx
  800b57:	80 fb 09             	cmp    $0x9,%bl
  800b5a:	77 d5                	ja     800b31 <strtol+0x80>
			dig = *s - '0';
  800b5c:	0f be d2             	movsbl %dl,%edx
  800b5f:	83 ea 30             	sub    $0x30,%edx
  800b62:	eb dd                	jmp    800b41 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b64:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b67:	89 f3                	mov    %esi,%ebx
  800b69:	80 fb 19             	cmp    $0x19,%bl
  800b6c:	77 08                	ja     800b76 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b6e:	0f be d2             	movsbl %dl,%edx
  800b71:	83 ea 37             	sub    $0x37,%edx
  800b74:	eb cb                	jmp    800b41 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7a:	74 05                	je     800b81 <strtol+0xd0>
		*endptr = (char *) s;
  800b7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b81:	89 c2                	mov    %eax,%edx
  800b83:	f7 da                	neg    %edx
  800b85:	85 ff                	test   %edi,%edi
  800b87:	0f 45 c2             	cmovne %edx,%eax
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba0:	89 c3                	mov    %eax,%ebx
  800ba2:	89 c7                	mov    %eax,%edi
  800ba4:	89 c6                	mov    %eax,%esi
  800ba6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <sys_cgetc>:

int
sys_cgetc(void)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbd:	89 d1                	mov    %edx,%ecx
  800bbf:	89 d3                	mov    %edx,%ebx
  800bc1:	89 d7                	mov    %edx,%edi
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bda:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800be2:	89 cb                	mov    %ecx,%ebx
  800be4:	89 cf                	mov    %ecx,%edi
  800be6:	89 ce                	mov    %ecx,%esi
  800be8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bea:	85 c0                	test   %eax,%eax
  800bec:	7f 08                	jg     800bf6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf6:	83 ec 0c             	sub    $0xc,%esp
  800bf9:	50                   	push   %eax
  800bfa:	6a 03                	push   $0x3
  800bfc:	68 9f 2a 80 00       	push   $0x802a9f
  800c01:	6a 23                	push   $0x23
  800c03:	68 bc 2a 80 00       	push   $0x802abc
  800c08:	e8 d4 17 00 00       	call   8023e1 <_panic>

00800c0d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c13:	ba 00 00 00 00       	mov    $0x0,%edx
  800c18:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1d:	89 d1                	mov    %edx,%ecx
  800c1f:	89 d3                	mov    %edx,%ebx
  800c21:	89 d7                	mov    %edx,%edi
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_yield>:

void
sys_yield(void)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c3c:	89 d1                	mov    %edx,%ecx
  800c3e:	89 d3                	mov    %edx,%ebx
  800c40:	89 d7                	mov    %edx,%edi
  800c42:	89 d6                	mov    %edx,%esi
  800c44:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c54:	be 00 00 00 00       	mov    $0x0,%esi
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5f:	b8 04 00 00 00       	mov    $0x4,%eax
  800c64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c67:	89 f7                	mov    %esi,%edi
  800c69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	7f 08                	jg     800c77 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c77:	83 ec 0c             	sub    $0xc,%esp
  800c7a:	50                   	push   %eax
  800c7b:	6a 04                	push   $0x4
  800c7d:	68 9f 2a 80 00       	push   $0x802a9f
  800c82:	6a 23                	push   $0x23
  800c84:	68 bc 2a 80 00       	push   $0x802abc
  800c89:	e8 53 17 00 00       	call   8023e1 <_panic>

00800c8e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c97:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9d:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca8:	8b 75 18             	mov    0x18(%ebp),%esi
  800cab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cad:	85 c0                	test   %eax,%eax
  800caf:	7f 08                	jg     800cb9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb9:	83 ec 0c             	sub    $0xc,%esp
  800cbc:	50                   	push   %eax
  800cbd:	6a 05                	push   $0x5
  800cbf:	68 9f 2a 80 00       	push   $0x802a9f
  800cc4:	6a 23                	push   $0x23
  800cc6:	68 bc 2a 80 00       	push   $0x802abc
  800ccb:	e8 11 17 00 00       	call   8023e1 <_panic>

00800cd0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
  800cd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cde:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce9:	89 df                	mov    %ebx,%edi
  800ceb:	89 de                	mov    %ebx,%esi
  800ced:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cef:	85 c0                	test   %eax,%eax
  800cf1:	7f 08                	jg     800cfb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfb:	83 ec 0c             	sub    $0xc,%esp
  800cfe:	50                   	push   %eax
  800cff:	6a 06                	push   $0x6
  800d01:	68 9f 2a 80 00       	push   $0x802a9f
  800d06:	6a 23                	push   $0x23
  800d08:	68 bc 2a 80 00       	push   $0x802abc
  800d0d:	e8 cf 16 00 00       	call   8023e1 <_panic>

00800d12 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	b8 08 00 00 00       	mov    $0x8,%eax
  800d2b:	89 df                	mov    %ebx,%edi
  800d2d:	89 de                	mov    %ebx,%esi
  800d2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d31:	85 c0                	test   %eax,%eax
  800d33:	7f 08                	jg     800d3d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3d:	83 ec 0c             	sub    $0xc,%esp
  800d40:	50                   	push   %eax
  800d41:	6a 08                	push   $0x8
  800d43:	68 9f 2a 80 00       	push   $0x802a9f
  800d48:	6a 23                	push   $0x23
  800d4a:	68 bc 2a 80 00       	push   $0x802abc
  800d4f:	e8 8d 16 00 00       	call   8023e1 <_panic>

00800d54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6d:	89 df                	mov    %ebx,%edi
  800d6f:	89 de                	mov    %ebx,%esi
  800d71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7f 08                	jg     800d7f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	50                   	push   %eax
  800d83:	6a 09                	push   $0x9
  800d85:	68 9f 2a 80 00       	push   $0x802a9f
  800d8a:	6a 23                	push   $0x23
  800d8c:	68 bc 2a 80 00       	push   $0x802abc
  800d91:	e8 4b 16 00 00       	call   8023e1 <_panic>

00800d96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800daf:	89 df                	mov    %ebx,%edi
  800db1:	89 de                	mov    %ebx,%esi
  800db3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7f 08                	jg     800dc1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	50                   	push   %eax
  800dc5:	6a 0a                	push   $0xa
  800dc7:	68 9f 2a 80 00       	push   $0x802a9f
  800dcc:	6a 23                	push   $0x23
  800dce:	68 bc 2a 80 00       	push   $0x802abc
  800dd3:	e8 09 16 00 00       	call   8023e1 <_panic>

00800dd8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de9:	be 00 00 00 00       	mov    $0x0,%esi
  800dee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e11:	89 cb                	mov    %ecx,%ebx
  800e13:	89 cf                	mov    %ecx,%edi
  800e15:	89 ce                	mov    %ecx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 0d                	push   $0xd
  800e2b:	68 9f 2a 80 00       	push   $0x802a9f
  800e30:	6a 23                	push   $0x23
  800e32:	68 bc 2a 80 00       	push   $0x802abc
  800e37:	e8 a5 15 00 00       	call   8023e1 <_panic>

00800e3c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
  800e47:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e4c:	89 d1                	mov    %edx,%ecx
  800e4e:	89 d3                	mov    %edx,%ebx
  800e50:	89 d7                	mov    %edx,%edi
  800e52:	89 d6                	mov    %edx,%esi
  800e54:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 1c             	sub    $0x1c,%esp
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800e67:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800e69:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800e6c:	89 d8                	mov    %ebx,%eax
  800e6e:	c1 e8 0c             	shr    $0xc,%eax
  800e71:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800e7b:	e8 8d fd ff ff       	call   800c0d <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800e80:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800e86:	74 73                	je     800efb <pgfault+0xa0>
  800e88:	89 c6                	mov    %eax,%esi
  800e8a:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800e91:	74 68                	je     800efb <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800e93:	83 ec 04             	sub    $0x4,%esp
  800e96:	6a 07                	push   $0x7
  800e98:	68 00 f0 7f 00       	push   $0x7ff000
  800e9d:	50                   	push   %eax
  800e9e:	e8 a8 fd ff ff       	call   800c4b <sys_page_alloc>
  800ea3:	83 c4 10             	add    $0x10,%esp
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	75 65                	jne    800f0f <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800eaa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800eb0:	83 ec 04             	sub    $0x4,%esp
  800eb3:	68 00 10 00 00       	push   $0x1000
  800eb8:	53                   	push   %ebx
  800eb9:	68 00 f0 7f 00       	push   $0x7ff000
  800ebe:	e8 85 fb ff ff       	call   800a48 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800ec3:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800eca:	53                   	push   %ebx
  800ecb:	56                   	push   %esi
  800ecc:	68 00 f0 7f 00       	push   $0x7ff000
  800ed1:	56                   	push   %esi
  800ed2:	e8 b7 fd ff ff       	call   800c8e <sys_page_map>
  800ed7:	83 c4 20             	add    $0x20,%esp
  800eda:	85 c0                	test   %eax,%eax
  800edc:	75 43                	jne    800f21 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800ede:	83 ec 08             	sub    $0x8,%esp
  800ee1:	68 00 f0 7f 00       	push   $0x7ff000
  800ee6:	56                   	push   %esi
  800ee7:	e8 e4 fd ff ff       	call   800cd0 <sys_page_unmap>
  800eec:	83 c4 10             	add    $0x10,%esp
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	75 40                	jne    800f33 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  800ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  800efb:	83 ec 04             	sub    $0x4,%esp
  800efe:	68 ca 2a 80 00       	push   $0x802aca
  800f03:	6a 1f                	push   $0x1f
  800f05:	68 e8 2a 80 00       	push   $0x802ae8
  800f0a:	e8 d2 14 00 00       	call   8023e1 <_panic>
	    panic("pgfault: %e", r);
  800f0f:	50                   	push   %eax
  800f10:	68 f3 2a 80 00       	push   $0x802af3
  800f15:	6a 2a                	push   $0x2a
  800f17:	68 e8 2a 80 00       	push   $0x802ae8
  800f1c:	e8 c0 14 00 00       	call   8023e1 <_panic>
	    panic("pgfault: %e", r);
  800f21:	50                   	push   %eax
  800f22:	68 f3 2a 80 00       	push   $0x802af3
  800f27:	6a 2e                	push   $0x2e
  800f29:	68 e8 2a 80 00       	push   $0x802ae8
  800f2e:	e8 ae 14 00 00       	call   8023e1 <_panic>
	    panic("pgfault: %e", r);
  800f33:	50                   	push   %eax
  800f34:	68 f3 2a 80 00       	push   $0x802af3
  800f39:	6a 31                	push   $0x31
  800f3b:	68 e8 2a 80 00       	push   $0x802ae8
  800f40:	e8 9c 14 00 00       	call   8023e1 <_panic>

00800f45 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
  800f4b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  800f4e:	68 5b 0e 80 00       	push   $0x800e5b
  800f53:	e8 cf 14 00 00       	call   802427 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f58:	b8 07 00 00 00       	mov    $0x7,%eax
  800f5d:	cd 30                	int    $0x30
  800f5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  800f65:	83 c4 10             	add    $0x10,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	78 2b                	js     800f97 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f6c:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f71:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f75:	0f 85 b5 00 00 00    	jne    801030 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  800f7b:	e8 8d fc ff ff       	call   800c0d <sys_getenvid>
  800f80:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f85:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f88:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f8d:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  800f92:	e9 8c 01 00 00       	jmp    801123 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  800f97:	50                   	push   %eax
  800f98:	68 ff 2a 80 00       	push   $0x802aff
  800f9d:	6a 77                	push   $0x77
  800f9f:	68 e8 2a 80 00       	push   $0x802ae8
  800fa4:	e8 38 14 00 00       	call   8023e1 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  800fa9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fb0:	83 ec 0c             	sub    $0xc,%esp
  800fb3:	25 07 0e 00 00       	and    $0xe07,%eax
  800fb8:	50                   	push   %eax
  800fb9:	57                   	push   %edi
  800fba:	ff 75 e0             	pushl  -0x20(%ebp)
  800fbd:	57                   	push   %edi
  800fbe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc1:	e8 c8 fc ff ff       	call   800c8e <sys_page_map>
  800fc6:	83 c4 20             	add    $0x20,%esp
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	74 51                	je     80101e <fork+0xd9>
           panic("duppage: %e", r);
  800fcd:	50                   	push   %eax
  800fce:	68 0f 2b 80 00       	push   $0x802b0f
  800fd3:	6a 4a                	push   $0x4a
  800fd5:	68 e8 2a 80 00       	push   $0x802ae8
  800fda:	e8 02 14 00 00       	call   8023e1 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  800fdf:	83 ec 0c             	sub    $0xc,%esp
  800fe2:	68 05 08 00 00       	push   $0x805
  800fe7:	57                   	push   %edi
  800fe8:	ff 75 e0             	pushl  -0x20(%ebp)
  800feb:	57                   	push   %edi
  800fec:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fef:	e8 9a fc ff ff       	call   800c8e <sys_page_map>
  800ff4:	83 c4 20             	add    $0x20,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	0f 85 bc 00 00 00    	jne    8010bb <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	68 05 08 00 00       	push   $0x805
  801007:	57                   	push   %edi
  801008:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80100b:	50                   	push   %eax
  80100c:	57                   	push   %edi
  80100d:	50                   	push   %eax
  80100e:	e8 7b fc ff ff       	call   800c8e <sys_page_map>
  801013:	83 c4 20             	add    $0x20,%esp
  801016:	85 c0                	test   %eax,%eax
  801018:	0f 85 af 00 00 00    	jne    8010cd <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80101e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801024:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80102a:	0f 84 af 00 00 00    	je     8010df <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801030:	89 d8                	mov    %ebx,%eax
  801032:	c1 e8 16             	shr    $0x16,%eax
  801035:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80103c:	a8 01                	test   $0x1,%al
  80103e:	74 de                	je     80101e <fork+0xd9>
  801040:	89 de                	mov    %ebx,%esi
  801042:	c1 ee 0c             	shr    $0xc,%esi
  801045:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80104c:	a8 01                	test   $0x1,%al
  80104e:	74 ce                	je     80101e <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  801050:	e8 b8 fb ff ff       	call   800c0d <sys_getenvid>
  801055:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  801058:	89 f7                	mov    %esi,%edi
  80105a:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  80105d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801064:	f6 c4 04             	test   $0x4,%ah
  801067:	0f 85 3c ff ff ff    	jne    800fa9 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  80106d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801074:	a8 02                	test   $0x2,%al
  801076:	0f 85 63 ff ff ff    	jne    800fdf <fork+0x9a>
  80107c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801083:	f6 c4 08             	test   $0x8,%ah
  801086:	0f 85 53 ff ff ff    	jne    800fdf <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	6a 05                	push   $0x5
  801091:	57                   	push   %edi
  801092:	ff 75 e0             	pushl  -0x20(%ebp)
  801095:	57                   	push   %edi
  801096:	ff 75 e4             	pushl  -0x1c(%ebp)
  801099:	e8 f0 fb ff ff       	call   800c8e <sys_page_map>
  80109e:	83 c4 20             	add    $0x20,%esp
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	0f 84 75 ff ff ff    	je     80101e <fork+0xd9>
	        panic("duppage: %e", r);
  8010a9:	50                   	push   %eax
  8010aa:	68 0f 2b 80 00       	push   $0x802b0f
  8010af:	6a 55                	push   $0x55
  8010b1:	68 e8 2a 80 00       	push   $0x802ae8
  8010b6:	e8 26 13 00 00       	call   8023e1 <_panic>
	        panic("duppage: %e", r);
  8010bb:	50                   	push   %eax
  8010bc:	68 0f 2b 80 00       	push   $0x802b0f
  8010c1:	6a 4e                	push   $0x4e
  8010c3:	68 e8 2a 80 00       	push   $0x802ae8
  8010c8:	e8 14 13 00 00       	call   8023e1 <_panic>
	        panic("duppage: %e", r);
  8010cd:	50                   	push   %eax
  8010ce:	68 0f 2b 80 00       	push   $0x802b0f
  8010d3:	6a 51                	push   $0x51
  8010d5:	68 e8 2a 80 00       	push   $0x802ae8
  8010da:	e8 02 13 00 00       	call   8023e1 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	6a 07                	push   $0x7
  8010e4:	68 00 f0 bf ee       	push   $0xeebff000
  8010e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8010ec:	e8 5a fb ff ff       	call   800c4b <sys_page_alloc>
  8010f1:	83 c4 10             	add    $0x10,%esp
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	75 36                	jne    80112e <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	68 a0 24 80 00       	push   $0x8024a0
  801100:	ff 75 dc             	pushl  -0x24(%ebp)
  801103:	e8 8e fc ff ff       	call   800d96 <sys_env_set_pgfault_upcall>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	75 34                	jne    801143 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  80110f:	83 ec 08             	sub    $0x8,%esp
  801112:	6a 02                	push   $0x2
  801114:	ff 75 dc             	pushl  -0x24(%ebp)
  801117:	e8 f6 fb ff ff       	call   800d12 <sys_env_set_status>
  80111c:	83 c4 10             	add    $0x10,%esp
  80111f:	85 c0                	test   %eax,%eax
  801121:	75 35                	jne    801158 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801123:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801126:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801129:	5b                   	pop    %ebx
  80112a:	5e                   	pop    %esi
  80112b:	5f                   	pop    %edi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    
	    panic("fork: %e", r);
  80112e:	50                   	push   %eax
  80112f:	68 06 2b 80 00       	push   $0x802b06
  801134:	68 8a 00 00 00       	push   $0x8a
  801139:	68 e8 2a 80 00       	push   $0x802ae8
  80113e:	e8 9e 12 00 00       	call   8023e1 <_panic>
	    panic("fork: %e", r);
  801143:	50                   	push   %eax
  801144:	68 06 2b 80 00       	push   $0x802b06
  801149:	68 8d 00 00 00       	push   $0x8d
  80114e:	68 e8 2a 80 00       	push   $0x802ae8
  801153:	e8 89 12 00 00       	call   8023e1 <_panic>
	    panic("fork: %e", r);
  801158:	50                   	push   %eax
  801159:	68 06 2b 80 00       	push   $0x802b06
  80115e:	68 92 00 00 00       	push   $0x92
  801163:	68 e8 2a 80 00       	push   $0x802ae8
  801168:	e8 74 12 00 00       	call   8023e1 <_panic>

0080116d <sfork>:

// Challenge!
int
sfork(void)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801173:	68 1b 2b 80 00       	push   $0x802b1b
  801178:	68 9b 00 00 00       	push   $0x9b
  80117d:	68 e8 2a 80 00       	push   $0x802ae8
  801182:	e8 5a 12 00 00       	call   8023e1 <_panic>

00801187 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
  80118c:	8b 75 08             	mov    0x8(%ebp),%esi
  80118f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801192:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801195:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801197:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80119c:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80119f:	83 ec 0c             	sub    $0xc,%esp
  8011a2:	50                   	push   %eax
  8011a3:	e8 53 fc ff ff       	call   800dfb <sys_ipc_recv>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	78 2b                	js     8011da <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8011af:	85 f6                	test   %esi,%esi
  8011b1:	74 0a                	je     8011bd <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8011b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8011b8:	8b 40 74             	mov    0x74(%eax),%eax
  8011bb:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8011bd:	85 db                	test   %ebx,%ebx
  8011bf:	74 0a                	je     8011cb <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8011c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8011c6:	8b 40 78             	mov    0x78(%eax),%eax
  8011c9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8011cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8011d0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    
	    if (from_env_store != NULL) {
  8011da:	85 f6                	test   %esi,%esi
  8011dc:	74 06                	je     8011e4 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8011de:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8011e4:	85 db                	test   %ebx,%ebx
  8011e6:	74 eb                	je     8011d3 <ipc_recv+0x4c>
	        *perm_store = 0;
  8011e8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011ee:	eb e3                	jmp    8011d3 <ipc_recv+0x4c>

008011f0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	57                   	push   %edi
  8011f4:	56                   	push   %esi
  8011f5:	53                   	push   %ebx
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011fc:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8011ff:	85 f6                	test   %esi,%esi
  801201:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801206:	0f 44 f0             	cmove  %eax,%esi
  801209:	eb 09                	jmp    801214 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80120b:	e8 1c fa ff ff       	call   800c2c <sys_yield>
	} while(r != 0);
  801210:	85 db                	test   %ebx,%ebx
  801212:	74 2d                	je     801241 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  801214:	ff 75 14             	pushl  0x14(%ebp)
  801217:	56                   	push   %esi
  801218:	ff 75 0c             	pushl  0xc(%ebp)
  80121b:	57                   	push   %edi
  80121c:	e8 b7 fb ff ff       	call   800dd8 <sys_ipc_try_send>
  801221:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	79 e1                	jns    80120b <ipc_send+0x1b>
  80122a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80122d:	74 dc                	je     80120b <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80122f:	50                   	push   %eax
  801230:	68 31 2b 80 00       	push   $0x802b31
  801235:	6a 45                	push   $0x45
  801237:	68 3e 2b 80 00       	push   $0x802b3e
  80123c:	e8 a0 11 00 00       	call   8023e1 <_panic>
}
  801241:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801244:	5b                   	pop    %ebx
  801245:	5e                   	pop    %esi
  801246:	5f                   	pop    %edi
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80124f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801254:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801257:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80125d:	8b 52 50             	mov    0x50(%edx),%edx
  801260:	39 ca                	cmp    %ecx,%edx
  801262:	74 11                	je     801275 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801264:	83 c0 01             	add    $0x1,%eax
  801267:	3d 00 04 00 00       	cmp    $0x400,%eax
  80126c:	75 e6                	jne    801254 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
  801273:	eb 0b                	jmp    801280 <ipc_find_env+0x37>
			return envs[i].env_id;
  801275:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801278:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80127d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    

00801282 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	05 00 00 00 30       	add    $0x30000000,%eax
  80128d:	c1 e8 0c             	shr    $0xc,%eax
}
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80129d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    

008012a9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012af:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012b4:	89 c2                	mov    %eax,%edx
  8012b6:	c1 ea 16             	shr    $0x16,%edx
  8012b9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012c0:	f6 c2 01             	test   $0x1,%dl
  8012c3:	74 2a                	je     8012ef <fd_alloc+0x46>
  8012c5:	89 c2                	mov    %eax,%edx
  8012c7:	c1 ea 0c             	shr    $0xc,%edx
  8012ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012d1:	f6 c2 01             	test   $0x1,%dl
  8012d4:	74 19                	je     8012ef <fd_alloc+0x46>
  8012d6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012db:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012e0:	75 d2                	jne    8012b4 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012e2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012e8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012ed:	eb 07                	jmp    8012f6 <fd_alloc+0x4d>
			*fd_store = fd;
  8012ef:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012fe:	83 f8 1f             	cmp    $0x1f,%eax
  801301:	77 36                	ja     801339 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801303:	c1 e0 0c             	shl    $0xc,%eax
  801306:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80130b:	89 c2                	mov    %eax,%edx
  80130d:	c1 ea 16             	shr    $0x16,%edx
  801310:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801317:	f6 c2 01             	test   $0x1,%dl
  80131a:	74 24                	je     801340 <fd_lookup+0x48>
  80131c:	89 c2                	mov    %eax,%edx
  80131e:	c1 ea 0c             	shr    $0xc,%edx
  801321:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801328:	f6 c2 01             	test   $0x1,%dl
  80132b:	74 1a                	je     801347 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80132d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801330:	89 02                	mov    %eax,(%edx)
	return 0;
  801332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801337:	5d                   	pop    %ebp
  801338:	c3                   	ret    
		return -E_INVAL;
  801339:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133e:	eb f7                	jmp    801337 <fd_lookup+0x3f>
		return -E_INVAL;
  801340:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801345:	eb f0                	jmp    801337 <fd_lookup+0x3f>
  801347:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134c:	eb e9                	jmp    801337 <fd_lookup+0x3f>

0080134e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801357:	ba c4 2b 80 00       	mov    $0x802bc4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80135c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801361:	39 08                	cmp    %ecx,(%eax)
  801363:	74 33                	je     801398 <dev_lookup+0x4a>
  801365:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801368:	8b 02                	mov    (%edx),%eax
  80136a:	85 c0                	test   %eax,%eax
  80136c:	75 f3                	jne    801361 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80136e:	a1 08 40 80 00       	mov    0x804008,%eax
  801373:	8b 40 48             	mov    0x48(%eax),%eax
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	51                   	push   %ecx
  80137a:	50                   	push   %eax
  80137b:	68 48 2b 80 00       	push   $0x802b48
  801380:	e8 30 ee ff ff       	call   8001b5 <cprintf>
	*dev = 0;
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
  801388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    
			*dev = devtab[i];
  801398:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80139d:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a2:	eb f2                	jmp    801396 <dev_lookup+0x48>

008013a4 <fd_close>:
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	57                   	push   %edi
  8013a8:	56                   	push   %esi
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 1c             	sub    $0x1c,%esp
  8013ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8013b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013bd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c0:	50                   	push   %eax
  8013c1:	e8 32 ff ff ff       	call   8012f8 <fd_lookup>
  8013c6:	89 c3                	mov    %eax,%ebx
  8013c8:	83 c4 08             	add    $0x8,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	78 05                	js     8013d4 <fd_close+0x30>
	    || fd != fd2)
  8013cf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013d2:	74 16                	je     8013ea <fd_close+0x46>
		return (must_exist ? r : 0);
  8013d4:	89 f8                	mov    %edi,%eax
  8013d6:	84 c0                	test   %al,%al
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dd:	0f 44 d8             	cmove  %eax,%ebx
}
  8013e0:	89 d8                	mov    %ebx,%eax
  8013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e5:	5b                   	pop    %ebx
  8013e6:	5e                   	pop    %esi
  8013e7:	5f                   	pop    %edi
  8013e8:	5d                   	pop    %ebp
  8013e9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	ff 36                	pushl  (%esi)
  8013f3:	e8 56 ff ff ff       	call   80134e <dev_lookup>
  8013f8:	89 c3                	mov    %eax,%ebx
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 15                	js     801416 <fd_close+0x72>
		if (dev->dev_close)
  801401:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801404:	8b 40 10             	mov    0x10(%eax),%eax
  801407:	85 c0                	test   %eax,%eax
  801409:	74 1b                	je     801426 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	56                   	push   %esi
  80140f:	ff d0                	call   *%eax
  801411:	89 c3                	mov    %eax,%ebx
  801413:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	56                   	push   %esi
  80141a:	6a 00                	push   $0x0
  80141c:	e8 af f8 ff ff       	call   800cd0 <sys_page_unmap>
	return r;
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	eb ba                	jmp    8013e0 <fd_close+0x3c>
			r = 0;
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	eb e9                	jmp    801416 <fd_close+0x72>

0080142d <close>:

int
close(int fdnum)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801433:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801436:	50                   	push   %eax
  801437:	ff 75 08             	pushl  0x8(%ebp)
  80143a:	e8 b9 fe ff ff       	call   8012f8 <fd_lookup>
  80143f:	83 c4 08             	add    $0x8,%esp
  801442:	85 c0                	test   %eax,%eax
  801444:	78 10                	js     801456 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	6a 01                	push   $0x1
  80144b:	ff 75 f4             	pushl  -0xc(%ebp)
  80144e:	e8 51 ff ff ff       	call   8013a4 <fd_close>
  801453:	83 c4 10             	add    $0x10,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <close_all>:

void
close_all(void)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	53                   	push   %ebx
  80145c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80145f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801464:	83 ec 0c             	sub    $0xc,%esp
  801467:	53                   	push   %ebx
  801468:	e8 c0 ff ff ff       	call   80142d <close>
	for (i = 0; i < MAXFD; i++)
  80146d:	83 c3 01             	add    $0x1,%ebx
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	83 fb 20             	cmp    $0x20,%ebx
  801476:	75 ec                	jne    801464 <close_all+0xc>
}
  801478:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	57                   	push   %edi
  801481:	56                   	push   %esi
  801482:	53                   	push   %ebx
  801483:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801486:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801489:	50                   	push   %eax
  80148a:	ff 75 08             	pushl  0x8(%ebp)
  80148d:	e8 66 fe ff ff       	call   8012f8 <fd_lookup>
  801492:	89 c3                	mov    %eax,%ebx
  801494:	83 c4 08             	add    $0x8,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	0f 88 81 00 00 00    	js     801520 <dup+0xa3>
		return r;
	close(newfdnum);
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	e8 83 ff ff ff       	call   80142d <close>

	newfd = INDEX2FD(newfdnum);
  8014aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014ad:	c1 e6 0c             	shl    $0xc,%esi
  8014b0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014b6:	83 c4 04             	add    $0x4,%esp
  8014b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014bc:	e8 d1 fd ff ff       	call   801292 <fd2data>
  8014c1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014c3:	89 34 24             	mov    %esi,(%esp)
  8014c6:	e8 c7 fd ff ff       	call   801292 <fd2data>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014d0:	89 d8                	mov    %ebx,%eax
  8014d2:	c1 e8 16             	shr    $0x16,%eax
  8014d5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014dc:	a8 01                	test   $0x1,%al
  8014de:	74 11                	je     8014f1 <dup+0x74>
  8014e0:	89 d8                	mov    %ebx,%eax
  8014e2:	c1 e8 0c             	shr    $0xc,%eax
  8014e5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014ec:	f6 c2 01             	test   $0x1,%dl
  8014ef:	75 39                	jne    80152a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014f4:	89 d0                	mov    %edx,%eax
  8014f6:	c1 e8 0c             	shr    $0xc,%eax
  8014f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801500:	83 ec 0c             	sub    $0xc,%esp
  801503:	25 07 0e 00 00       	and    $0xe07,%eax
  801508:	50                   	push   %eax
  801509:	56                   	push   %esi
  80150a:	6a 00                	push   $0x0
  80150c:	52                   	push   %edx
  80150d:	6a 00                	push   $0x0
  80150f:	e8 7a f7 ff ff       	call   800c8e <sys_page_map>
  801514:	89 c3                	mov    %eax,%ebx
  801516:	83 c4 20             	add    $0x20,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 31                	js     80154e <dup+0xd1>
		goto err;

	return newfdnum;
  80151d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801520:	89 d8                	mov    %ebx,%eax
  801522:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5f                   	pop    %edi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80152a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	25 07 0e 00 00       	and    $0xe07,%eax
  801539:	50                   	push   %eax
  80153a:	57                   	push   %edi
  80153b:	6a 00                	push   $0x0
  80153d:	53                   	push   %ebx
  80153e:	6a 00                	push   $0x0
  801540:	e8 49 f7 ff ff       	call   800c8e <sys_page_map>
  801545:	89 c3                	mov    %eax,%ebx
  801547:	83 c4 20             	add    $0x20,%esp
  80154a:	85 c0                	test   %eax,%eax
  80154c:	79 a3                	jns    8014f1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	56                   	push   %esi
  801552:	6a 00                	push   $0x0
  801554:	e8 77 f7 ff ff       	call   800cd0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801559:	83 c4 08             	add    $0x8,%esp
  80155c:	57                   	push   %edi
  80155d:	6a 00                	push   $0x0
  80155f:	e8 6c f7 ff ff       	call   800cd0 <sys_page_unmap>
	return r;
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	eb b7                	jmp    801520 <dup+0xa3>

00801569 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	53                   	push   %ebx
  80156d:	83 ec 14             	sub    $0x14,%esp
  801570:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801573:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	53                   	push   %ebx
  801578:	e8 7b fd ff ff       	call   8012f8 <fd_lookup>
  80157d:	83 c4 08             	add    $0x8,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	78 3f                	js     8015c3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801584:	83 ec 08             	sub    $0x8,%esp
  801587:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158a:	50                   	push   %eax
  80158b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158e:	ff 30                	pushl  (%eax)
  801590:	e8 b9 fd ff ff       	call   80134e <dev_lookup>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	78 27                	js     8015c3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80159c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80159f:	8b 42 08             	mov    0x8(%edx),%eax
  8015a2:	83 e0 03             	and    $0x3,%eax
  8015a5:	83 f8 01             	cmp    $0x1,%eax
  8015a8:	74 1e                	je     8015c8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	8b 40 08             	mov    0x8(%eax),%eax
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	74 35                	je     8015e9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	ff 75 10             	pushl  0x10(%ebp)
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	52                   	push   %edx
  8015be:	ff d0                	call   *%eax
  8015c0:	83 c4 10             	add    $0x10,%esp
}
  8015c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015c8:	a1 08 40 80 00       	mov    0x804008,%eax
  8015cd:	8b 40 48             	mov    0x48(%eax),%eax
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	53                   	push   %ebx
  8015d4:	50                   	push   %eax
  8015d5:	68 89 2b 80 00       	push   $0x802b89
  8015da:	e8 d6 eb ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e7:	eb da                	jmp    8015c3 <read+0x5a>
		return -E_NOT_SUPP;
  8015e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ee:	eb d3                	jmp    8015c3 <read+0x5a>

008015f0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	57                   	push   %edi
  8015f4:	56                   	push   %esi
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 0c             	sub    $0xc,%esp
  8015f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015fc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801604:	39 f3                	cmp    %esi,%ebx
  801606:	73 25                	jae    80162d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	89 f0                	mov    %esi,%eax
  80160d:	29 d8                	sub    %ebx,%eax
  80160f:	50                   	push   %eax
  801610:	89 d8                	mov    %ebx,%eax
  801612:	03 45 0c             	add    0xc(%ebp),%eax
  801615:	50                   	push   %eax
  801616:	57                   	push   %edi
  801617:	e8 4d ff ff ff       	call   801569 <read>
		if (m < 0)
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	85 c0                	test   %eax,%eax
  801621:	78 08                	js     80162b <readn+0x3b>
			return m;
		if (m == 0)
  801623:	85 c0                	test   %eax,%eax
  801625:	74 06                	je     80162d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801627:	01 c3                	add    %eax,%ebx
  801629:	eb d9                	jmp    801604 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80162b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80162d:	89 d8                	mov    %ebx,%eax
  80162f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801632:	5b                   	pop    %ebx
  801633:	5e                   	pop    %esi
  801634:	5f                   	pop    %edi
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	53                   	push   %ebx
  80163b:	83 ec 14             	sub    $0x14,%esp
  80163e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801641:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801644:	50                   	push   %eax
  801645:	53                   	push   %ebx
  801646:	e8 ad fc ff ff       	call   8012f8 <fd_lookup>
  80164b:	83 c4 08             	add    $0x8,%esp
  80164e:	85 c0                	test   %eax,%eax
  801650:	78 3a                	js     80168c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801652:	83 ec 08             	sub    $0x8,%esp
  801655:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801658:	50                   	push   %eax
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165c:	ff 30                	pushl  (%eax)
  80165e:	e8 eb fc ff ff       	call   80134e <dev_lookup>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	85 c0                	test   %eax,%eax
  801668:	78 22                	js     80168c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801671:	74 1e                	je     801691 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801676:	8b 52 0c             	mov    0xc(%edx),%edx
  801679:	85 d2                	test   %edx,%edx
  80167b:	74 35                	je     8016b2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80167d:	83 ec 04             	sub    $0x4,%esp
  801680:	ff 75 10             	pushl  0x10(%ebp)
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	50                   	push   %eax
  801687:	ff d2                	call   *%edx
  801689:	83 c4 10             	add    $0x10,%esp
}
  80168c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168f:	c9                   	leave  
  801690:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801691:	a1 08 40 80 00       	mov    0x804008,%eax
  801696:	8b 40 48             	mov    0x48(%eax),%eax
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	53                   	push   %ebx
  80169d:	50                   	push   %eax
  80169e:	68 a5 2b 80 00       	push   $0x802ba5
  8016a3:	e8 0d eb ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b0:	eb da                	jmp    80168c <write+0x55>
		return -E_NOT_SUPP;
  8016b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016b7:	eb d3                	jmp    80168c <write+0x55>

008016b9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016bf:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016c2:	50                   	push   %eax
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	e8 2d fc ff ff       	call   8012f8 <fd_lookup>
  8016cb:	83 c4 08             	add    $0x8,%esp
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	78 0e                	js     8016e0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	53                   	push   %ebx
  8016e6:	83 ec 14             	sub    $0x14,%esp
  8016e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ef:	50                   	push   %eax
  8016f0:	53                   	push   %ebx
  8016f1:	e8 02 fc ff ff       	call   8012f8 <fd_lookup>
  8016f6:	83 c4 08             	add    $0x8,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 37                	js     801734 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	ff 30                	pushl  (%eax)
  801709:	e8 40 fc ff ff       	call   80134e <dev_lookup>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	78 1f                	js     801734 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80171c:	74 1b                	je     801739 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80171e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801721:	8b 52 18             	mov    0x18(%edx),%edx
  801724:	85 d2                	test   %edx,%edx
  801726:	74 32                	je     80175a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	ff 75 0c             	pushl  0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	ff d2                	call   *%edx
  801731:	83 c4 10             	add    $0x10,%esp
}
  801734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801737:	c9                   	leave  
  801738:	c3                   	ret    
			thisenv->env_id, fdnum);
  801739:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80173e:	8b 40 48             	mov    0x48(%eax),%eax
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	53                   	push   %ebx
  801745:	50                   	push   %eax
  801746:	68 68 2b 80 00       	push   $0x802b68
  80174b:	e8 65 ea ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801758:	eb da                	jmp    801734 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80175a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80175f:	eb d3                	jmp    801734 <ftruncate+0x52>

00801761 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	53                   	push   %ebx
  801765:	83 ec 14             	sub    $0x14,%esp
  801768:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80176b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176e:	50                   	push   %eax
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 81 fb ff ff       	call   8012f8 <fd_lookup>
  801777:	83 c4 08             	add    $0x8,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 4b                	js     8017c9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801784:	50                   	push   %eax
  801785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801788:	ff 30                	pushl  (%eax)
  80178a:	e8 bf fb ff ff       	call   80134e <dev_lookup>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	78 33                	js     8017c9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80179d:	74 2f                	je     8017ce <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80179f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017a2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017a9:	00 00 00 
	stat->st_isdir = 0;
  8017ac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017b3:	00 00 00 
	stat->st_dev = dev;
  8017b6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017bc:	83 ec 08             	sub    $0x8,%esp
  8017bf:	53                   	push   %ebx
  8017c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c3:	ff 50 14             	call   *0x14(%eax)
  8017c6:	83 c4 10             	add    $0x10,%esp
}
  8017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    
		return -E_NOT_SUPP;
  8017ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d3:	eb f4                	jmp    8017c9 <fstat+0x68>

008017d5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	6a 00                	push   $0x0
  8017df:	ff 75 08             	pushl  0x8(%ebp)
  8017e2:	e8 26 02 00 00       	call   801a0d <open>
  8017e7:	89 c3                	mov    %eax,%ebx
  8017e9:	83 c4 10             	add    $0x10,%esp
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 1b                	js     80180b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	50                   	push   %eax
  8017f7:	e8 65 ff ff ff       	call   801761 <fstat>
  8017fc:	89 c6                	mov    %eax,%esi
	close(fd);
  8017fe:	89 1c 24             	mov    %ebx,(%esp)
  801801:	e8 27 fc ff ff       	call   80142d <close>
	return r;
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	89 f3                	mov    %esi,%ebx
}
  80180b:	89 d8                	mov    %ebx,%eax
  80180d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801810:	5b                   	pop    %ebx
  801811:	5e                   	pop    %esi
  801812:	5d                   	pop    %ebp
  801813:	c3                   	ret    

00801814 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	56                   	push   %esi
  801818:	53                   	push   %ebx
  801819:	89 c6                	mov    %eax,%esi
  80181b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80181d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801824:	74 27                	je     80184d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801826:	6a 07                	push   $0x7
  801828:	68 00 50 80 00       	push   $0x805000
  80182d:	56                   	push   %esi
  80182e:	ff 35 00 40 80 00    	pushl  0x804000
  801834:	e8 b7 f9 ff ff       	call   8011f0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801839:	83 c4 0c             	add    $0xc,%esp
  80183c:	6a 00                	push   $0x0
  80183e:	53                   	push   %ebx
  80183f:	6a 00                	push   $0x0
  801841:	e8 41 f9 ff ff       	call   801187 <ipc_recv>
}
  801846:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801849:	5b                   	pop    %ebx
  80184a:	5e                   	pop    %esi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80184d:	83 ec 0c             	sub    $0xc,%esp
  801850:	6a 01                	push   $0x1
  801852:	e8 f2 f9 ff ff       	call   801249 <ipc_find_env>
  801857:	a3 00 40 80 00       	mov    %eax,0x804000
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	eb c5                	jmp    801826 <fsipc+0x12>

00801861 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	8b 40 0c             	mov    0xc(%eax),%eax
  80186d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801872:	8b 45 0c             	mov    0xc(%ebp),%eax
  801875:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80187a:	ba 00 00 00 00       	mov    $0x0,%edx
  80187f:	b8 02 00 00 00       	mov    $0x2,%eax
  801884:	e8 8b ff ff ff       	call   801814 <fsipc>
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <devfile_flush>:
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	8b 40 0c             	mov    0xc(%eax),%eax
  801897:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80189c:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a1:	b8 06 00 00 00       	mov    $0x6,%eax
  8018a6:	e8 69 ff ff ff       	call   801814 <fsipc>
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <devfile_stat>:
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8018cc:	e8 43 ff ff ff       	call   801814 <fsipc>
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 2c                	js     801901 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018d5:	83 ec 08             	sub    $0x8,%esp
  8018d8:	68 00 50 80 00       	push   $0x805000
  8018dd:	53                   	push   %ebx
  8018de:	e8 6f ef ff ff       	call   800852 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018e3:	a1 80 50 80 00       	mov    0x805080,%eax
  8018e8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ee:	a1 84 50 80 00       	mov    0x805084,%eax
  8018f3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <devfile_write>:
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	53                   	push   %ebx
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8b 40 0c             	mov    0xc(%eax),%eax
  801916:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80191b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801921:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801927:	77 30                	ja     801959 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	53                   	push   %ebx
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	68 08 50 80 00       	push   $0x805008
  801935:	e8 a6 f0 ff ff       	call   8009e0 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80193a:	ba 00 00 00 00       	mov    $0x0,%edx
  80193f:	b8 04 00 00 00       	mov    $0x4,%eax
  801944:	e8 cb fe ff ff       	call   801814 <fsipc>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 04                	js     801954 <devfile_write+0x4e>
	assert(r <= n);
  801950:	39 d8                	cmp    %ebx,%eax
  801952:	77 1e                	ja     801972 <devfile_write+0x6c>
}
  801954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801957:	c9                   	leave  
  801958:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801959:	68 d8 2b 80 00       	push   $0x802bd8
  80195e:	68 05 2c 80 00       	push   $0x802c05
  801963:	68 94 00 00 00       	push   $0x94
  801968:	68 1a 2c 80 00       	push   $0x802c1a
  80196d:	e8 6f 0a 00 00       	call   8023e1 <_panic>
	assert(r <= n);
  801972:	68 25 2c 80 00       	push   $0x802c25
  801977:	68 05 2c 80 00       	push   $0x802c05
  80197c:	68 98 00 00 00       	push   $0x98
  801981:	68 1a 2c 80 00       	push   $0x802c1a
  801986:	e8 56 0a 00 00       	call   8023e1 <_panic>

0080198b <devfile_read>:
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	8b 40 0c             	mov    0xc(%eax),%eax
  801999:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80199e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ae:	e8 61 fe ff ff       	call   801814 <fsipc>
  8019b3:	89 c3                	mov    %eax,%ebx
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 1f                	js     8019d8 <devfile_read+0x4d>
	assert(r <= n);
  8019b9:	39 f0                	cmp    %esi,%eax
  8019bb:	77 24                	ja     8019e1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019bd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019c2:	7f 33                	jg     8019f7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	50                   	push   %eax
  8019c8:	68 00 50 80 00       	push   $0x805000
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	e8 0b f0 ff ff       	call   8009e0 <memmove>
	return r;
  8019d5:	83 c4 10             	add    $0x10,%esp
}
  8019d8:	89 d8                	mov    %ebx,%eax
  8019da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019dd:	5b                   	pop    %ebx
  8019de:	5e                   	pop    %esi
  8019df:	5d                   	pop    %ebp
  8019e0:	c3                   	ret    
	assert(r <= n);
  8019e1:	68 25 2c 80 00       	push   $0x802c25
  8019e6:	68 05 2c 80 00       	push   $0x802c05
  8019eb:	6a 7c                	push   $0x7c
  8019ed:	68 1a 2c 80 00       	push   $0x802c1a
  8019f2:	e8 ea 09 00 00       	call   8023e1 <_panic>
	assert(r <= PGSIZE);
  8019f7:	68 2c 2c 80 00       	push   $0x802c2c
  8019fc:	68 05 2c 80 00       	push   $0x802c05
  801a01:	6a 7d                	push   $0x7d
  801a03:	68 1a 2c 80 00       	push   $0x802c1a
  801a08:	e8 d4 09 00 00       	call   8023e1 <_panic>

00801a0d <open>:
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 1c             	sub    $0x1c,%esp
  801a15:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a18:	56                   	push   %esi
  801a19:	e8 fd ed ff ff       	call   80081b <strlen>
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a26:	7f 6c                	jg     801a94 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a28:	83 ec 0c             	sub    $0xc,%esp
  801a2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2e:	50                   	push   %eax
  801a2f:	e8 75 f8 ff ff       	call   8012a9 <fd_alloc>
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 3c                	js     801a79 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	56                   	push   %esi
  801a41:	68 00 50 80 00       	push   $0x805000
  801a46:	e8 07 ee ff ff       	call   800852 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a56:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5b:	e8 b4 fd ff ff       	call   801814 <fsipc>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 19                	js     801a82 <open+0x75>
	return fd2num(fd);
  801a69:	83 ec 0c             	sub    $0xc,%esp
  801a6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6f:	e8 0e f8 ff ff       	call   801282 <fd2num>
  801a74:	89 c3                	mov    %eax,%ebx
  801a76:	83 c4 10             	add    $0x10,%esp
}
  801a79:	89 d8                	mov    %ebx,%eax
  801a7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7e:	5b                   	pop    %ebx
  801a7f:	5e                   	pop    %esi
  801a80:	5d                   	pop    %ebp
  801a81:	c3                   	ret    
		fd_close(fd, 0);
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8a:	e8 15 f9 ff ff       	call   8013a4 <fd_close>
		return r;
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	eb e5                	jmp    801a79 <open+0x6c>
		return -E_BAD_PATH;
  801a94:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a99:	eb de                	jmp    801a79 <open+0x6c>

00801a9b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa6:	b8 08 00 00 00       	mov    $0x8,%eax
  801aab:	e8 64 fd ff ff       	call   801814 <fsipc>
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	56                   	push   %esi
  801ab6:	53                   	push   %ebx
  801ab7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	ff 75 08             	pushl  0x8(%ebp)
  801ac0:	e8 cd f7 ff ff       	call   801292 <fd2data>
  801ac5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ac7:	83 c4 08             	add    $0x8,%esp
  801aca:	68 38 2c 80 00       	push   $0x802c38
  801acf:	53                   	push   %ebx
  801ad0:	e8 7d ed ff ff       	call   800852 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ad5:	8b 46 04             	mov    0x4(%esi),%eax
  801ad8:	2b 06                	sub    (%esi),%eax
  801ada:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ae0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ae7:	00 00 00 
	stat->st_dev = &devpipe;
  801aea:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801af1:	30 80 00 
	return 0;
}
  801af4:	b8 00 00 00 00       	mov    $0x0,%eax
  801af9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    

00801b00 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	53                   	push   %ebx
  801b04:	83 ec 0c             	sub    $0xc,%esp
  801b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b0a:	53                   	push   %ebx
  801b0b:	6a 00                	push   $0x0
  801b0d:	e8 be f1 ff ff       	call   800cd0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b12:	89 1c 24             	mov    %ebx,(%esp)
  801b15:	e8 78 f7 ff ff       	call   801292 <fd2data>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	50                   	push   %eax
  801b1e:	6a 00                	push   $0x0
  801b20:	e8 ab f1 ff ff       	call   800cd0 <sys_page_unmap>
}
  801b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <_pipeisclosed>:
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	57                   	push   %edi
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	83 ec 1c             	sub    $0x1c,%esp
  801b33:	89 c7                	mov    %eax,%edi
  801b35:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b37:	a1 08 40 80 00       	mov    0x804008,%eax
  801b3c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	57                   	push   %edi
  801b43:	e8 7e 09 00 00       	call   8024c6 <pageref>
  801b48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b4b:	89 34 24             	mov    %esi,(%esp)
  801b4e:	e8 73 09 00 00       	call   8024c6 <pageref>
		nn = thisenv->env_runs;
  801b53:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b59:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	39 cb                	cmp    %ecx,%ebx
  801b61:	74 1b                	je     801b7e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b63:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b66:	75 cf                	jne    801b37 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b68:	8b 42 58             	mov    0x58(%edx),%eax
  801b6b:	6a 01                	push   $0x1
  801b6d:	50                   	push   %eax
  801b6e:	53                   	push   %ebx
  801b6f:	68 3f 2c 80 00       	push   $0x802c3f
  801b74:	e8 3c e6 ff ff       	call   8001b5 <cprintf>
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	eb b9                	jmp    801b37 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b81:	0f 94 c0             	sete   %al
  801b84:	0f b6 c0             	movzbl %al,%eax
}
  801b87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b8a:	5b                   	pop    %ebx
  801b8b:	5e                   	pop    %esi
  801b8c:	5f                   	pop    %edi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    

00801b8f <devpipe_write>:
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	57                   	push   %edi
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	83 ec 28             	sub    $0x28,%esp
  801b98:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b9b:	56                   	push   %esi
  801b9c:	e8 f1 f6 ff ff       	call   801292 <fd2data>
  801ba1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bab:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bae:	74 4f                	je     801bff <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bb0:	8b 43 04             	mov    0x4(%ebx),%eax
  801bb3:	8b 0b                	mov    (%ebx),%ecx
  801bb5:	8d 51 20             	lea    0x20(%ecx),%edx
  801bb8:	39 d0                	cmp    %edx,%eax
  801bba:	72 14                	jb     801bd0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bbc:	89 da                	mov    %ebx,%edx
  801bbe:	89 f0                	mov    %esi,%eax
  801bc0:	e8 65 ff ff ff       	call   801b2a <_pipeisclosed>
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	75 3a                	jne    801c03 <devpipe_write+0x74>
			sys_yield();
  801bc9:	e8 5e f0 ff ff       	call   800c2c <sys_yield>
  801bce:	eb e0                	jmp    801bb0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bd3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bd7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bda:	89 c2                	mov    %eax,%edx
  801bdc:	c1 fa 1f             	sar    $0x1f,%edx
  801bdf:	89 d1                	mov    %edx,%ecx
  801be1:	c1 e9 1b             	shr    $0x1b,%ecx
  801be4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801be7:	83 e2 1f             	and    $0x1f,%edx
  801bea:	29 ca                	sub    %ecx,%edx
  801bec:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bf0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bf4:	83 c0 01             	add    $0x1,%eax
  801bf7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bfa:	83 c7 01             	add    $0x1,%edi
  801bfd:	eb ac                	jmp    801bab <devpipe_write+0x1c>
	return i;
  801bff:	89 f8                	mov    %edi,%eax
  801c01:	eb 05                	jmp    801c08 <devpipe_write+0x79>
				return 0;
  801c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c0b:	5b                   	pop    %ebx
  801c0c:	5e                   	pop    %esi
  801c0d:	5f                   	pop    %edi
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    

00801c10 <devpipe_read>:
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	57                   	push   %edi
  801c14:	56                   	push   %esi
  801c15:	53                   	push   %ebx
  801c16:	83 ec 18             	sub    $0x18,%esp
  801c19:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c1c:	57                   	push   %edi
  801c1d:	e8 70 f6 ff ff       	call   801292 <fd2data>
  801c22:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	be 00 00 00 00       	mov    $0x0,%esi
  801c2c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c2f:	74 47                	je     801c78 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c31:	8b 03                	mov    (%ebx),%eax
  801c33:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c36:	75 22                	jne    801c5a <devpipe_read+0x4a>
			if (i > 0)
  801c38:	85 f6                	test   %esi,%esi
  801c3a:	75 14                	jne    801c50 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c3c:	89 da                	mov    %ebx,%edx
  801c3e:	89 f8                	mov    %edi,%eax
  801c40:	e8 e5 fe ff ff       	call   801b2a <_pipeisclosed>
  801c45:	85 c0                	test   %eax,%eax
  801c47:	75 33                	jne    801c7c <devpipe_read+0x6c>
			sys_yield();
  801c49:	e8 de ef ff ff       	call   800c2c <sys_yield>
  801c4e:	eb e1                	jmp    801c31 <devpipe_read+0x21>
				return i;
  801c50:	89 f0                	mov    %esi,%eax
}
  801c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5f                   	pop    %edi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c5a:	99                   	cltd   
  801c5b:	c1 ea 1b             	shr    $0x1b,%edx
  801c5e:	01 d0                	add    %edx,%eax
  801c60:	83 e0 1f             	and    $0x1f,%eax
  801c63:	29 d0                	sub    %edx,%eax
  801c65:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c6d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c70:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c73:	83 c6 01             	add    $0x1,%esi
  801c76:	eb b4                	jmp    801c2c <devpipe_read+0x1c>
	return i;
  801c78:	89 f0                	mov    %esi,%eax
  801c7a:	eb d6                	jmp    801c52 <devpipe_read+0x42>
				return 0;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c81:	eb cf                	jmp    801c52 <devpipe_read+0x42>

00801c83 <pipe>:
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8e:	50                   	push   %eax
  801c8f:	e8 15 f6 ff ff       	call   8012a9 <fd_alloc>
  801c94:	89 c3                	mov    %eax,%ebx
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 5b                	js     801cf8 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	68 07 04 00 00       	push   $0x407
  801ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca8:	6a 00                	push   $0x0
  801caa:	e8 9c ef ff ff       	call   800c4b <sys_page_alloc>
  801caf:	89 c3                	mov    %eax,%ebx
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 40                	js     801cf8 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cbe:	50                   	push   %eax
  801cbf:	e8 e5 f5 ff ff       	call   8012a9 <fd_alloc>
  801cc4:	89 c3                	mov    %eax,%ebx
  801cc6:	83 c4 10             	add    $0x10,%esp
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	78 1b                	js     801ce8 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	68 07 04 00 00       	push   $0x407
  801cd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd8:	6a 00                	push   $0x0
  801cda:	e8 6c ef ff ff       	call   800c4b <sys_page_alloc>
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	79 19                	jns    801d01 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ce8:	83 ec 08             	sub    $0x8,%esp
  801ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cee:	6a 00                	push   $0x0
  801cf0:	e8 db ef ff ff       	call   800cd0 <sys_page_unmap>
  801cf5:	83 c4 10             	add    $0x10,%esp
}
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5e                   	pop    %esi
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    
	va = fd2data(fd0);
  801d01:	83 ec 0c             	sub    $0xc,%esp
  801d04:	ff 75 f4             	pushl  -0xc(%ebp)
  801d07:	e8 86 f5 ff ff       	call   801292 <fd2data>
  801d0c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d0e:	83 c4 0c             	add    $0xc,%esp
  801d11:	68 07 04 00 00       	push   $0x407
  801d16:	50                   	push   %eax
  801d17:	6a 00                	push   $0x0
  801d19:	e8 2d ef ff ff       	call   800c4b <sys_page_alloc>
  801d1e:	89 c3                	mov    %eax,%ebx
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	85 c0                	test   %eax,%eax
  801d25:	0f 88 8c 00 00 00    	js     801db7 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2b:	83 ec 0c             	sub    $0xc,%esp
  801d2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d31:	e8 5c f5 ff ff       	call   801292 <fd2data>
  801d36:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d3d:	50                   	push   %eax
  801d3e:	6a 00                	push   $0x0
  801d40:	56                   	push   %esi
  801d41:	6a 00                	push   $0x0
  801d43:	e8 46 ef ff ff       	call   800c8e <sys_page_map>
  801d48:	89 c3                	mov    %eax,%ebx
  801d4a:	83 c4 20             	add    $0x20,%esp
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	78 58                	js     801da9 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d5a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d69:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d6f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d74:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d81:	e8 fc f4 ff ff       	call   801282 <fd2num>
  801d86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d89:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d8b:	83 c4 04             	add    $0x4,%esp
  801d8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d91:	e8 ec f4 ff ff       	call   801282 <fd2num>
  801d96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d99:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801da4:	e9 4f ff ff ff       	jmp    801cf8 <pipe+0x75>
	sys_page_unmap(0, va);
  801da9:	83 ec 08             	sub    $0x8,%esp
  801dac:	56                   	push   %esi
  801dad:	6a 00                	push   $0x0
  801daf:	e8 1c ef ff ff       	call   800cd0 <sys_page_unmap>
  801db4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801db7:	83 ec 08             	sub    $0x8,%esp
  801dba:	ff 75 f0             	pushl  -0x10(%ebp)
  801dbd:	6a 00                	push   $0x0
  801dbf:	e8 0c ef ff ff       	call   800cd0 <sys_page_unmap>
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	e9 1c ff ff ff       	jmp    801ce8 <pipe+0x65>

00801dcc <pipeisclosed>:
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd5:	50                   	push   %eax
  801dd6:	ff 75 08             	pushl  0x8(%ebp)
  801dd9:	e8 1a f5 ff ff       	call   8012f8 <fd_lookup>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	85 c0                	test   %eax,%eax
  801de3:	78 18                	js     801dfd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801de5:	83 ec 0c             	sub    $0xc,%esp
  801de8:	ff 75 f4             	pushl  -0xc(%ebp)
  801deb:	e8 a2 f4 ff ff       	call   801292 <fd2data>
	return _pipeisclosed(fd, p);
  801df0:	89 c2                	mov    %eax,%edx
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	e8 30 fd ff ff       	call   801b2a <_pipeisclosed>
  801dfa:	83 c4 10             	add    $0x10,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e05:	68 57 2c 80 00       	push   $0x802c57
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	e8 40 ea ff ff       	call   800852 <strcpy>
	return 0;
}
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <devsock_close>:
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	53                   	push   %ebx
  801e1d:	83 ec 10             	sub    $0x10,%esp
  801e20:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e23:	53                   	push   %ebx
  801e24:	e8 9d 06 00 00       	call   8024c6 <pageref>
  801e29:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e2c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e31:	83 f8 01             	cmp    $0x1,%eax
  801e34:	74 07                	je     801e3d <devsock_close+0x24>
}
  801e36:	89 d0                	mov    %edx,%eax
  801e38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	ff 73 0c             	pushl  0xc(%ebx)
  801e43:	e8 b7 02 00 00       	call   8020ff <nsipc_close>
  801e48:	89 c2                	mov    %eax,%edx
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	eb e7                	jmp    801e36 <devsock_close+0x1d>

00801e4f <devsock_write>:
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	ff 75 10             	pushl  0x10(%ebp)
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	ff 70 0c             	pushl  0xc(%eax)
  801e63:	e8 74 03 00 00       	call   8021dc <nsipc_send>
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <devsock_read>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	ff 75 10             	pushl  0x10(%ebp)
  801e75:	ff 75 0c             	pushl  0xc(%ebp)
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	ff 70 0c             	pushl  0xc(%eax)
  801e7e:	e8 ed 02 00 00       	call   802170 <nsipc_recv>
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <fd2sockid>:
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e8b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e8e:	52                   	push   %edx
  801e8f:	50                   	push   %eax
  801e90:	e8 63 f4 ff ff       	call   8012f8 <fd_lookup>
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	78 10                	js     801eac <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ea5:	39 08                	cmp    %ecx,(%eax)
  801ea7:	75 05                	jne    801eae <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ea9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    
		return -E_NOT_SUPP;
  801eae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801eb3:	eb f7                	jmp    801eac <fd2sockid+0x27>

00801eb5 <alloc_sockfd>:
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	56                   	push   %esi
  801eb9:	53                   	push   %ebx
  801eba:	83 ec 1c             	sub    $0x1c,%esp
  801ebd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ebf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec2:	50                   	push   %eax
  801ec3:	e8 e1 f3 ff ff       	call   8012a9 <fd_alloc>
  801ec8:	89 c3                	mov    %eax,%ebx
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 43                	js     801f14 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ed1:	83 ec 04             	sub    $0x4,%esp
  801ed4:	68 07 04 00 00       	push   $0x407
  801ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  801edc:	6a 00                	push   $0x0
  801ede:	e8 68 ed ff ff       	call   800c4b <sys_page_alloc>
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 28                	js     801f14 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ef5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f01:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	50                   	push   %eax
  801f08:	e8 75 f3 ff ff       	call   801282 <fd2num>
  801f0d:	89 c3                	mov    %eax,%ebx
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	eb 0c                	jmp    801f20 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	56                   	push   %esi
  801f18:	e8 e2 01 00 00       	call   8020ff <nsipc_close>
		return r;
  801f1d:	83 c4 10             	add    $0x10,%esp
}
  801f20:	89 d8                	mov    %ebx,%eax
  801f22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f25:	5b                   	pop    %ebx
  801f26:	5e                   	pop    %esi
  801f27:	5d                   	pop    %ebp
  801f28:	c3                   	ret    

00801f29 <accept>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	e8 4e ff ff ff       	call   801e85 <fd2sockid>
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 1b                	js     801f56 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f3b:	83 ec 04             	sub    $0x4,%esp
  801f3e:	ff 75 10             	pushl  0x10(%ebp)
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	50                   	push   %eax
  801f45:	e8 0e 01 00 00       	call   802058 <nsipc_accept>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 05                	js     801f56 <accept+0x2d>
	return alloc_sockfd(r);
  801f51:	e8 5f ff ff ff       	call   801eb5 <alloc_sockfd>
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <bind>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	e8 1f ff ff ff       	call   801e85 <fd2sockid>
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 12                	js     801f7c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	ff 75 10             	pushl  0x10(%ebp)
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	50                   	push   %eax
  801f74:	e8 2f 01 00 00       	call   8020a8 <nsipc_bind>
  801f79:	83 c4 10             	add    $0x10,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <shutdown>:
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	e8 f9 fe ff ff       	call   801e85 <fd2sockid>
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 0f                	js     801f9f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f90:	83 ec 08             	sub    $0x8,%esp
  801f93:	ff 75 0c             	pushl  0xc(%ebp)
  801f96:	50                   	push   %eax
  801f97:	e8 41 01 00 00       	call   8020dd <nsipc_shutdown>
  801f9c:	83 c4 10             	add    $0x10,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <connect>:
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	e8 d6 fe ff ff       	call   801e85 <fd2sockid>
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	78 12                	js     801fc5 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	ff 75 10             	pushl  0x10(%ebp)
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	50                   	push   %eax
  801fbd:	e8 57 01 00 00       	call   802119 <nsipc_connect>
  801fc2:	83 c4 10             	add    $0x10,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <listen>:
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	e8 b0 fe ff ff       	call   801e85 <fd2sockid>
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 0f                	js     801fe8 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fd9:	83 ec 08             	sub    $0x8,%esp
  801fdc:	ff 75 0c             	pushl  0xc(%ebp)
  801fdf:	50                   	push   %eax
  801fe0:	e8 69 01 00 00       	call   80214e <nsipc_listen>
  801fe5:	83 c4 10             	add    $0x10,%esp
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <socket>:

int
socket(int domain, int type, int protocol)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ff0:	ff 75 10             	pushl  0x10(%ebp)
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	ff 75 08             	pushl  0x8(%ebp)
  801ff9:	e8 3c 02 00 00       	call   80223a <nsipc_socket>
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	85 c0                	test   %eax,%eax
  802003:	78 05                	js     80200a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802005:	e8 ab fe ff ff       	call   801eb5 <alloc_sockfd>
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	53                   	push   %ebx
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802015:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80201c:	74 26                	je     802044 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80201e:	6a 07                	push   $0x7
  802020:	68 00 60 80 00       	push   $0x806000
  802025:	53                   	push   %ebx
  802026:	ff 35 04 40 80 00    	pushl  0x804004
  80202c:	e8 bf f1 ff ff       	call   8011f0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802031:	83 c4 0c             	add    $0xc,%esp
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	e8 48 f1 ff ff       	call   801187 <ipc_recv>
}
  80203f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802042:	c9                   	leave  
  802043:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802044:	83 ec 0c             	sub    $0xc,%esp
  802047:	6a 02                	push   $0x2
  802049:	e8 fb f1 ff ff       	call   801249 <ipc_find_env>
  80204e:	a3 04 40 80 00       	mov    %eax,0x804004
  802053:	83 c4 10             	add    $0x10,%esp
  802056:	eb c6                	jmp    80201e <nsipc+0x12>

00802058 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	56                   	push   %esi
  80205c:	53                   	push   %ebx
  80205d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802068:	8b 06                	mov    (%esi),%eax
  80206a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80206f:	b8 01 00 00 00       	mov    $0x1,%eax
  802074:	e8 93 ff ff ff       	call   80200c <nsipc>
  802079:	89 c3                	mov    %eax,%ebx
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 20                	js     80209f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	ff 35 10 60 80 00    	pushl  0x806010
  802088:	68 00 60 80 00       	push   $0x806000
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	e8 4b e9 ff ff       	call   8009e0 <memmove>
		*addrlen = ret->ret_addrlen;
  802095:	a1 10 60 80 00       	mov    0x806010,%eax
  80209a:	89 06                	mov    %eax,(%esi)
  80209c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80209f:	89 d8                	mov    %ebx,%eax
  8020a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a4:	5b                   	pop    %ebx
  8020a5:	5e                   	pop    %esi
  8020a6:	5d                   	pop    %ebp
  8020a7:	c3                   	ret    

008020a8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 08             	sub    $0x8,%esp
  8020af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020ba:	53                   	push   %ebx
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	68 04 60 80 00       	push   $0x806004
  8020c3:	e8 18 e9 ff ff       	call   8009e0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020c8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8020ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8020d3:	e8 34 ff ff ff       	call   80200c <nsipc>
}
  8020d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8020eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ee:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8020f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8020f8:	e8 0f ff ff ff       	call   80200c <nsipc>
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <nsipc_close>:

int
nsipc_close(int s)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80210d:	b8 04 00 00 00       	mov    $0x4,%eax
  802112:	e8 f5 fe ff ff       	call   80200c <nsipc>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	53                   	push   %ebx
  80211d:	83 ec 08             	sub    $0x8,%esp
  802120:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80212b:	53                   	push   %ebx
  80212c:	ff 75 0c             	pushl  0xc(%ebp)
  80212f:	68 04 60 80 00       	push   $0x806004
  802134:	e8 a7 e8 ff ff       	call   8009e0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802139:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80213f:	b8 05 00 00 00       	mov    $0x5,%eax
  802144:	e8 c3 fe ff ff       	call   80200c <nsipc>
}
  802149:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80215c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802164:	b8 06 00 00 00       	mov    $0x6,%eax
  802169:	e8 9e fe ff ff       	call   80200c <nsipc>
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	56                   	push   %esi
  802174:	53                   	push   %ebx
  802175:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802180:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802186:	8b 45 14             	mov    0x14(%ebp),%eax
  802189:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80218e:	b8 07 00 00 00       	mov    $0x7,%eax
  802193:	e8 74 fe ff ff       	call   80200c <nsipc>
  802198:	89 c3                	mov    %eax,%ebx
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 1f                	js     8021bd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80219e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021a3:	7f 21                	jg     8021c6 <nsipc_recv+0x56>
  8021a5:	39 c6                	cmp    %eax,%esi
  8021a7:	7c 1d                	jl     8021c6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	50                   	push   %eax
  8021ad:	68 00 60 80 00       	push   $0x806000
  8021b2:	ff 75 0c             	pushl  0xc(%ebp)
  8021b5:	e8 26 e8 ff ff       	call   8009e0 <memmove>
  8021ba:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021bd:	89 d8                	mov    %ebx,%eax
  8021bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c2:	5b                   	pop    %ebx
  8021c3:	5e                   	pop    %esi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021c6:	68 63 2c 80 00       	push   $0x802c63
  8021cb:	68 05 2c 80 00       	push   $0x802c05
  8021d0:	6a 62                	push   $0x62
  8021d2:	68 78 2c 80 00       	push   $0x802c78
  8021d7:	e8 05 02 00 00       	call   8023e1 <_panic>

008021dc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021ee:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021f4:	7f 2e                	jg     802224 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021f6:	83 ec 04             	sub    $0x4,%esp
  8021f9:	53                   	push   %ebx
  8021fa:	ff 75 0c             	pushl  0xc(%ebp)
  8021fd:	68 0c 60 80 00       	push   $0x80600c
  802202:	e8 d9 e7 ff ff       	call   8009e0 <memmove>
	nsipcbuf.send.req_size = size;
  802207:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80220d:	8b 45 14             	mov    0x14(%ebp),%eax
  802210:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802215:	b8 08 00 00 00       	mov    $0x8,%eax
  80221a:	e8 ed fd ff ff       	call   80200c <nsipc>
}
  80221f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802222:	c9                   	leave  
  802223:	c3                   	ret    
	assert(size < 1600);
  802224:	68 84 2c 80 00       	push   $0x802c84
  802229:	68 05 2c 80 00       	push   $0x802c05
  80222e:	6a 6d                	push   $0x6d
  802230:	68 78 2c 80 00       	push   $0x802c78
  802235:	e8 a7 01 00 00       	call   8023e1 <_panic>

0080223a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802250:	8b 45 10             	mov    0x10(%ebp),%eax
  802253:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802258:	b8 09 00 00 00       	mov    $0x9,%eax
  80225d:	e8 aa fd ff ff       	call   80200c <nsipc>
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
  80226c:	5d                   	pop    %ebp
  80226d:	c3                   	ret    

0080226e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802274:	68 90 2c 80 00       	push   $0x802c90
  802279:	ff 75 0c             	pushl  0xc(%ebp)
  80227c:	e8 d1 e5 ff ff       	call   800852 <strcpy>
	return 0;
}
  802281:	b8 00 00 00 00       	mov    $0x0,%eax
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <devcons_write>:
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	57                   	push   %edi
  80228c:	56                   	push   %esi
  80228d:	53                   	push   %ebx
  80228e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802294:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802299:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80229f:	eb 2f                	jmp    8022d0 <devcons_write+0x48>
		m = n - tot;
  8022a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022a4:	29 f3                	sub    %esi,%ebx
  8022a6:	83 fb 7f             	cmp    $0x7f,%ebx
  8022a9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022ae:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022b1:	83 ec 04             	sub    $0x4,%esp
  8022b4:	53                   	push   %ebx
  8022b5:	89 f0                	mov    %esi,%eax
  8022b7:	03 45 0c             	add    0xc(%ebp),%eax
  8022ba:	50                   	push   %eax
  8022bb:	57                   	push   %edi
  8022bc:	e8 1f e7 ff ff       	call   8009e0 <memmove>
		sys_cputs(buf, m);
  8022c1:	83 c4 08             	add    $0x8,%esp
  8022c4:	53                   	push   %ebx
  8022c5:	57                   	push   %edi
  8022c6:	e8 c4 e8 ff ff       	call   800b8f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022cb:	01 de                	add    %ebx,%esi
  8022cd:	83 c4 10             	add    $0x10,%esp
  8022d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022d3:	72 cc                	jb     8022a1 <devcons_write+0x19>
}
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022da:	5b                   	pop    %ebx
  8022db:	5e                   	pop    %esi
  8022dc:	5f                   	pop    %edi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    

008022df <devcons_read>:
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	83 ec 08             	sub    $0x8,%esp
  8022e5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ee:	75 07                	jne    8022f7 <devcons_read+0x18>
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    
		sys_yield();
  8022f2:	e8 35 e9 ff ff       	call   800c2c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8022f7:	e8 b1 e8 ff ff       	call   800bad <sys_cgetc>
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	74 f2                	je     8022f2 <devcons_read+0x13>
	if (c < 0)
  802300:	85 c0                	test   %eax,%eax
  802302:	78 ec                	js     8022f0 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802304:	83 f8 04             	cmp    $0x4,%eax
  802307:	74 0c                	je     802315 <devcons_read+0x36>
	*(char*)vbuf = c;
  802309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230c:	88 02                	mov    %al,(%edx)
	return 1;
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	eb db                	jmp    8022f0 <devcons_read+0x11>
		return 0;
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
  80231a:	eb d4                	jmp    8022f0 <devcons_read+0x11>

0080231c <cputchar>:
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802328:	6a 01                	push   $0x1
  80232a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80232d:	50                   	push   %eax
  80232e:	e8 5c e8 ff ff       	call   800b8f <sys_cputs>
}
  802333:	83 c4 10             	add    $0x10,%esp
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <getchar>:
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80233e:	6a 01                	push   $0x1
  802340:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802343:	50                   	push   %eax
  802344:	6a 00                	push   $0x0
  802346:	e8 1e f2 ff ff       	call   801569 <read>
	if (r < 0)
  80234b:	83 c4 10             	add    $0x10,%esp
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 08                	js     80235a <getchar+0x22>
	if (r < 1)
  802352:	85 c0                	test   %eax,%eax
  802354:	7e 06                	jle    80235c <getchar+0x24>
	return c;
  802356:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    
		return -E_EOF;
  80235c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802361:	eb f7                	jmp    80235a <getchar+0x22>

00802363 <iscons>:
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236c:	50                   	push   %eax
  80236d:	ff 75 08             	pushl  0x8(%ebp)
  802370:	e8 83 ef ff ff       	call   8012f8 <fd_lookup>
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	85 c0                	test   %eax,%eax
  80237a:	78 11                	js     80238d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802385:	39 10                	cmp    %edx,(%eax)
  802387:	0f 94 c0             	sete   %al
  80238a:	0f b6 c0             	movzbl %al,%eax
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <opencons>:
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802395:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802398:	50                   	push   %eax
  802399:	e8 0b ef ff ff       	call   8012a9 <fd_alloc>
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	78 3a                	js     8023df <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023a5:	83 ec 04             	sub    $0x4,%esp
  8023a8:	68 07 04 00 00       	push   $0x407
  8023ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b0:	6a 00                	push   $0x0
  8023b2:	e8 94 e8 ff ff       	call   800c4b <sys_page_alloc>
  8023b7:	83 c4 10             	add    $0x10,%esp
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	78 21                	js     8023df <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023c7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	50                   	push   %eax
  8023d7:	e8 a6 ee ff ff       	call   801282 <fd2num>
  8023dc:	83 c4 10             	add    $0x10,%esp
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	56                   	push   %esi
  8023e5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023e6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023e9:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023ef:	e8 19 e8 ff ff       	call   800c0d <sys_getenvid>
  8023f4:	83 ec 0c             	sub    $0xc,%esp
  8023f7:	ff 75 0c             	pushl  0xc(%ebp)
  8023fa:	ff 75 08             	pushl  0x8(%ebp)
  8023fd:	56                   	push   %esi
  8023fe:	50                   	push   %eax
  8023ff:	68 9c 2c 80 00       	push   $0x802c9c
  802404:	e8 ac dd ff ff       	call   8001b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802409:	83 c4 18             	add    $0x18,%esp
  80240c:	53                   	push   %ebx
  80240d:	ff 75 10             	pushl  0x10(%ebp)
  802410:	e8 4f dd ff ff       	call   800164 <vcprintf>
	cprintf("\n");
  802415:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  80241c:	e8 94 dd ff ff       	call   8001b5 <cprintf>
  802421:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802424:	cc                   	int3   
  802425:	eb fd                	jmp    802424 <_panic+0x43>

00802427 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80242d:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802434:	74 0a                	je     802440 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802440:	a1 08 40 80 00       	mov    0x804008,%eax
  802445:	8b 40 48             	mov    0x48(%eax),%eax
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	6a 07                	push   $0x7
  80244d:	68 00 f0 bf ee       	push   $0xeebff000
  802452:	50                   	push   %eax
  802453:	e8 f3 e7 ff ff       	call   800c4b <sys_page_alloc>
  802458:	83 c4 10             	add    $0x10,%esp
  80245b:	85 c0                	test   %eax,%eax
  80245d:	75 2f                	jne    80248e <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  80245f:	a1 08 40 80 00       	mov    0x804008,%eax
  802464:	8b 40 48             	mov    0x48(%eax),%eax
  802467:	83 ec 08             	sub    $0x8,%esp
  80246a:	68 a0 24 80 00       	push   $0x8024a0
  80246f:	50                   	push   %eax
  802470:	e8 21 e9 ff ff       	call   800d96 <sys_env_set_pgfault_upcall>
  802475:	83 c4 10             	add    $0x10,%esp
  802478:	85 c0                	test   %eax,%eax
  80247a:	74 ba                	je     802436 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  80247c:	50                   	push   %eax
  80247d:	68 c0 2c 80 00       	push   $0x802cc0
  802482:	6a 24                	push   $0x24
  802484:	68 d8 2c 80 00       	push   $0x802cd8
  802489:	e8 53 ff ff ff       	call   8023e1 <_panic>
		    panic("set_pgfault_handler: %e", r);
  80248e:	50                   	push   %eax
  80248f:	68 c0 2c 80 00       	push   $0x802cc0
  802494:	6a 21                	push   $0x21
  802496:	68 d8 2c 80 00       	push   $0x802cd8
  80249b:	e8 41 ff ff ff       	call   8023e1 <_panic>

008024a0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024a0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024a1:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024a6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024a8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8024ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8024af:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8024b2:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8024b6:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8024ba:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8024bc:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  8024bf:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8024c0:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8024c3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8024c4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8024c5:	c3                   	ret    

008024c6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024cc:	89 d0                	mov    %edx,%eax
  8024ce:	c1 e8 16             	shr    $0x16,%eax
  8024d1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024dd:	f6 c1 01             	test   $0x1,%cl
  8024e0:	74 1d                	je     8024ff <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024e2:	c1 ea 0c             	shr    $0xc,%edx
  8024e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024ec:	f6 c2 01             	test   $0x1,%dl
  8024ef:	74 0e                	je     8024ff <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024f1:	c1 ea 0c             	shr    $0xc,%edx
  8024f4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024fb:	ef 
  8024fc:	0f b7 c0             	movzwl %ax,%eax
}
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    
  802501:	66 90                	xchg   %ax,%ax
  802503:	66 90                	xchg   %ax,%ax
  802505:	66 90                	xchg   %ax,%ax
  802507:	66 90                	xchg   %ax,%ax
  802509:	66 90                	xchg   %ax,%ax
  80250b:	66 90                	xchg   %ax,%ax
  80250d:	66 90                	xchg   %ax,%ax
  80250f:	90                   	nop

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80251b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80251f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802523:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802527:	85 d2                	test   %edx,%edx
  802529:	75 35                	jne    802560 <__udivdi3+0x50>
  80252b:	39 f3                	cmp    %esi,%ebx
  80252d:	0f 87 bd 00 00 00    	ja     8025f0 <__udivdi3+0xe0>
  802533:	85 db                	test   %ebx,%ebx
  802535:	89 d9                	mov    %ebx,%ecx
  802537:	75 0b                	jne    802544 <__udivdi3+0x34>
  802539:	b8 01 00 00 00       	mov    $0x1,%eax
  80253e:	31 d2                	xor    %edx,%edx
  802540:	f7 f3                	div    %ebx
  802542:	89 c1                	mov    %eax,%ecx
  802544:	31 d2                	xor    %edx,%edx
  802546:	89 f0                	mov    %esi,%eax
  802548:	f7 f1                	div    %ecx
  80254a:	89 c6                	mov    %eax,%esi
  80254c:	89 e8                	mov    %ebp,%eax
  80254e:	89 f7                	mov    %esi,%edi
  802550:	f7 f1                	div    %ecx
  802552:	89 fa                	mov    %edi,%edx
  802554:	83 c4 1c             	add    $0x1c,%esp
  802557:	5b                   	pop    %ebx
  802558:	5e                   	pop    %esi
  802559:	5f                   	pop    %edi
  80255a:	5d                   	pop    %ebp
  80255b:	c3                   	ret    
  80255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802560:	39 f2                	cmp    %esi,%edx
  802562:	77 7c                	ja     8025e0 <__udivdi3+0xd0>
  802564:	0f bd fa             	bsr    %edx,%edi
  802567:	83 f7 1f             	xor    $0x1f,%edi
  80256a:	0f 84 98 00 00 00    	je     802608 <__udivdi3+0xf8>
  802570:	89 f9                	mov    %edi,%ecx
  802572:	b8 20 00 00 00       	mov    $0x20,%eax
  802577:	29 f8                	sub    %edi,%eax
  802579:	d3 e2                	shl    %cl,%edx
  80257b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80257f:	89 c1                	mov    %eax,%ecx
  802581:	89 da                	mov    %ebx,%edx
  802583:	d3 ea                	shr    %cl,%edx
  802585:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802589:	09 d1                	or     %edx,%ecx
  80258b:	89 f2                	mov    %esi,%edx
  80258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802591:	89 f9                	mov    %edi,%ecx
  802593:	d3 e3                	shl    %cl,%ebx
  802595:	89 c1                	mov    %eax,%ecx
  802597:	d3 ea                	shr    %cl,%edx
  802599:	89 f9                	mov    %edi,%ecx
  80259b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80259f:	d3 e6                	shl    %cl,%esi
  8025a1:	89 eb                	mov    %ebp,%ebx
  8025a3:	89 c1                	mov    %eax,%ecx
  8025a5:	d3 eb                	shr    %cl,%ebx
  8025a7:	09 de                	or     %ebx,%esi
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	f7 74 24 08          	divl   0x8(%esp)
  8025af:	89 d6                	mov    %edx,%esi
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	f7 64 24 0c          	mull   0xc(%esp)
  8025b7:	39 d6                	cmp    %edx,%esi
  8025b9:	72 0c                	jb     8025c7 <__udivdi3+0xb7>
  8025bb:	89 f9                	mov    %edi,%ecx
  8025bd:	d3 e5                	shl    %cl,%ebp
  8025bf:	39 c5                	cmp    %eax,%ebp
  8025c1:	73 5d                	jae    802620 <__udivdi3+0x110>
  8025c3:	39 d6                	cmp    %edx,%esi
  8025c5:	75 59                	jne    802620 <__udivdi3+0x110>
  8025c7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025ca:	31 ff                	xor    %edi,%edi
  8025cc:	89 fa                	mov    %edi,%edx
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	8d 76 00             	lea    0x0(%esi),%esi
  8025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8025e0:	31 ff                	xor    %edi,%edi
  8025e2:	31 c0                	xor    %eax,%eax
  8025e4:	89 fa                	mov    %edi,%edx
  8025e6:	83 c4 1c             	add    $0x1c,%esp
  8025e9:	5b                   	pop    %ebx
  8025ea:	5e                   	pop    %esi
  8025eb:	5f                   	pop    %edi
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    
  8025ee:	66 90                	xchg   %ax,%ax
  8025f0:	31 ff                	xor    %edi,%edi
  8025f2:	89 e8                	mov    %ebp,%eax
  8025f4:	89 f2                	mov    %esi,%edx
  8025f6:	f7 f3                	div    %ebx
  8025f8:	89 fa                	mov    %edi,%edx
  8025fa:	83 c4 1c             	add    $0x1c,%esp
  8025fd:	5b                   	pop    %ebx
  8025fe:	5e                   	pop    %esi
  8025ff:	5f                   	pop    %edi
  802600:	5d                   	pop    %ebp
  802601:	c3                   	ret    
  802602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802608:	39 f2                	cmp    %esi,%edx
  80260a:	72 06                	jb     802612 <__udivdi3+0x102>
  80260c:	31 c0                	xor    %eax,%eax
  80260e:	39 eb                	cmp    %ebp,%ebx
  802610:	77 d2                	ja     8025e4 <__udivdi3+0xd4>
  802612:	b8 01 00 00 00       	mov    $0x1,%eax
  802617:	eb cb                	jmp    8025e4 <__udivdi3+0xd4>
  802619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802620:	89 d8                	mov    %ebx,%eax
  802622:	31 ff                	xor    %edi,%edi
  802624:	eb be                	jmp    8025e4 <__udivdi3+0xd4>
  802626:	66 90                	xchg   %ax,%ax
  802628:	66 90                	xchg   %ax,%ax
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__umoddi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	53                   	push   %ebx
  802634:	83 ec 1c             	sub    $0x1c,%esp
  802637:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80263b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80263f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802647:	85 ed                	test   %ebp,%ebp
  802649:	89 f0                	mov    %esi,%eax
  80264b:	89 da                	mov    %ebx,%edx
  80264d:	75 19                	jne    802668 <__umoddi3+0x38>
  80264f:	39 df                	cmp    %ebx,%edi
  802651:	0f 86 b1 00 00 00    	jbe    802708 <__umoddi3+0xd8>
  802657:	f7 f7                	div    %edi
  802659:	89 d0                	mov    %edx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	83 c4 1c             	add    $0x1c,%esp
  802660:	5b                   	pop    %ebx
  802661:	5e                   	pop    %esi
  802662:	5f                   	pop    %edi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	39 dd                	cmp    %ebx,%ebp
  80266a:	77 f1                	ja     80265d <__umoddi3+0x2d>
  80266c:	0f bd cd             	bsr    %ebp,%ecx
  80266f:	83 f1 1f             	xor    $0x1f,%ecx
  802672:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802676:	0f 84 b4 00 00 00    	je     802730 <__umoddi3+0x100>
  80267c:	b8 20 00 00 00       	mov    $0x20,%eax
  802681:	89 c2                	mov    %eax,%edx
  802683:	8b 44 24 04          	mov    0x4(%esp),%eax
  802687:	29 c2                	sub    %eax,%edx
  802689:	89 c1                	mov    %eax,%ecx
  80268b:	89 f8                	mov    %edi,%eax
  80268d:	d3 e5                	shl    %cl,%ebp
  80268f:	89 d1                	mov    %edx,%ecx
  802691:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802695:	d3 e8                	shr    %cl,%eax
  802697:	09 c5                	or     %eax,%ebp
  802699:	8b 44 24 04          	mov    0x4(%esp),%eax
  80269d:	89 c1                	mov    %eax,%ecx
  80269f:	d3 e7                	shl    %cl,%edi
  8026a1:	89 d1                	mov    %edx,%ecx
  8026a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026a7:	89 df                	mov    %ebx,%edi
  8026a9:	d3 ef                	shr    %cl,%edi
  8026ab:	89 c1                	mov    %eax,%ecx
  8026ad:	89 f0                	mov    %esi,%eax
  8026af:	d3 e3                	shl    %cl,%ebx
  8026b1:	89 d1                	mov    %edx,%ecx
  8026b3:	89 fa                	mov    %edi,%edx
  8026b5:	d3 e8                	shr    %cl,%eax
  8026b7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026bc:	09 d8                	or     %ebx,%eax
  8026be:	f7 f5                	div    %ebp
  8026c0:	d3 e6                	shl    %cl,%esi
  8026c2:	89 d1                	mov    %edx,%ecx
  8026c4:	f7 64 24 08          	mull   0x8(%esp)
  8026c8:	39 d1                	cmp    %edx,%ecx
  8026ca:	89 c3                	mov    %eax,%ebx
  8026cc:	89 d7                	mov    %edx,%edi
  8026ce:	72 06                	jb     8026d6 <__umoddi3+0xa6>
  8026d0:	75 0e                	jne    8026e0 <__umoddi3+0xb0>
  8026d2:	39 c6                	cmp    %eax,%esi
  8026d4:	73 0a                	jae    8026e0 <__umoddi3+0xb0>
  8026d6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026da:	19 ea                	sbb    %ebp,%edx
  8026dc:	89 d7                	mov    %edx,%edi
  8026de:	89 c3                	mov    %eax,%ebx
  8026e0:	89 ca                	mov    %ecx,%edx
  8026e2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8026e7:	29 de                	sub    %ebx,%esi
  8026e9:	19 fa                	sbb    %edi,%edx
  8026eb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8026ef:	89 d0                	mov    %edx,%eax
  8026f1:	d3 e0                	shl    %cl,%eax
  8026f3:	89 d9                	mov    %ebx,%ecx
  8026f5:	d3 ee                	shr    %cl,%esi
  8026f7:	d3 ea                	shr    %cl,%edx
  8026f9:	09 f0                	or     %esi,%eax
  8026fb:	83 c4 1c             	add    $0x1c,%esp
  8026fe:	5b                   	pop    %ebx
  8026ff:	5e                   	pop    %esi
  802700:	5f                   	pop    %edi
  802701:	5d                   	pop    %ebp
  802702:	c3                   	ret    
  802703:	90                   	nop
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	85 ff                	test   %edi,%edi
  80270a:	89 f9                	mov    %edi,%ecx
  80270c:	75 0b                	jne    802719 <__umoddi3+0xe9>
  80270e:	b8 01 00 00 00       	mov    $0x1,%eax
  802713:	31 d2                	xor    %edx,%edx
  802715:	f7 f7                	div    %edi
  802717:	89 c1                	mov    %eax,%ecx
  802719:	89 d8                	mov    %ebx,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f1                	div    %ecx
  80271f:	89 f0                	mov    %esi,%eax
  802721:	f7 f1                	div    %ecx
  802723:	e9 31 ff ff ff       	jmp    802659 <__umoddi3+0x29>
  802728:	90                   	nop
  802729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802730:	39 dd                	cmp    %ebx,%ebp
  802732:	72 08                	jb     80273c <__umoddi3+0x10c>
  802734:	39 f7                	cmp    %esi,%edi
  802736:	0f 87 21 ff ff ff    	ja     80265d <__umoddi3+0x2d>
  80273c:	89 da                	mov    %ebx,%edx
  80273e:	89 f0                	mov    %esi,%eax
  802740:	29 f8                	sub    %edi,%eax
  802742:	19 ea                	sbb    %ebp,%edx
  802744:	e9 14 ff ff ff       	jmp    80265d <__umoddi3+0x2d>
