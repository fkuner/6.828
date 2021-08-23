
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 40 26 80 00       	push   $0x802640
  80003e:	e8 c3 01 00 00       	call   800206 <cprintf>
	exit();
  800043:	e8 0f 01 00 00       	call   800157 <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 40 0e 00 00       	call   800eac <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 54 0e 00 00       	call   800edc <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 54 26 80 00       	push   $0x802654
  8000c2:	e8 3f 01 00 00       	call   800206 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 03 14 00 00       	call   8014df <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 54 26 80 00       	push   $0x802654
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 14 18 00 00       	call   801918 <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80011c:	e8 3d 0b 00 00       	call   800c5e <sys_getenvid>
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800129:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	85 db                	test   %ebx,%ebx
  800135:	7e 07                	jle    80013e <libmain+0x2d>
		binaryname = argv[0];
  800137:	8b 06                	mov    (%esi),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	e8 05 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800148:	e8 0a 00 00 00       	call   800157 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015d:	e8 74 10 00 00       	call   8011d6 <close_all>
	sys_env_destroy(0);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	6a 00                	push   $0x0
  800167:	e8 b1 0a 00 00       	call   800c1d <sys_env_destroy>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	53                   	push   %ebx
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017b:	8b 13                	mov    (%ebx),%edx
  80017d:	8d 42 01             	lea    0x1(%edx),%eax
  800180:	89 03                	mov    %eax,(%ebx)
  800182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800185:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800189:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018e:	74 09                	je     800199 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800190:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800197:	c9                   	leave  
  800198:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	68 ff 00 00 00       	push   $0xff
  8001a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 36 0a 00 00       	call   800be0 <sys_cputs>
		b->idx = 0;
  8001aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb db                	jmp    800190 <putch+0x1f>

008001b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c5:	00 00 00 
	b.cnt = 0;
  8001c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	68 71 01 80 00       	push   $0x800171
  8001e4:	e8 1a 01 00 00       	call   800303 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e9:	83 c4 08             	add    $0x8,%esp
  8001ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f8:	50                   	push   %eax
  8001f9:	e8 e2 09 00 00       	call   800be0 <sys_cputs>

	return b.cnt;
}
  8001fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020f:	50                   	push   %eax
  800210:	ff 75 08             	pushl  0x8(%ebp)
  800213:	e8 9d ff ff ff       	call   8001b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	57                   	push   %edi
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	83 ec 1c             	sub    $0x1c,%esp
  800223:	89 c7                	mov    %eax,%edi
  800225:	89 d6                	mov    %edx,%esi
  800227:	8b 45 08             	mov    0x8(%ebp),%eax
  80022a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800230:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800233:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800241:	39 d3                	cmp    %edx,%ebx
  800243:	72 05                	jb     80024a <printnum+0x30>
  800245:	39 45 10             	cmp    %eax,0x10(%ebp)
  800248:	77 7a                	ja     8002c4 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	ff 75 18             	pushl  0x18(%ebp)
  800250:	8b 45 14             	mov    0x14(%ebp),%eax
  800253:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800256:	53                   	push   %ebx
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800260:	ff 75 e0             	pushl  -0x20(%ebp)
  800263:	ff 75 dc             	pushl  -0x24(%ebp)
  800266:	ff 75 d8             	pushl  -0x28(%ebp)
  800269:	e8 82 21 00 00       	call   8023f0 <__udivdi3>
  80026e:	83 c4 18             	add    $0x18,%esp
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	89 f2                	mov    %esi,%edx
  800275:	89 f8                	mov    %edi,%eax
  800277:	e8 9e ff ff ff       	call   80021a <printnum>
  80027c:	83 c4 20             	add    $0x20,%esp
  80027f:	eb 13                	jmp    800294 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800281:	83 ec 08             	sub    $0x8,%esp
  800284:	56                   	push   %esi
  800285:	ff 75 18             	pushl  0x18(%ebp)
  800288:	ff d7                	call   *%edi
  80028a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	85 db                	test   %ebx,%ebx
  800292:	7f ed                	jg     800281 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	56                   	push   %esi
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029e:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a7:	e8 64 22 00 00       	call   802510 <__umoddi3>
  8002ac:	83 c4 14             	add    $0x14,%esp
  8002af:	0f be 80 86 26 80 00 	movsbl 0x802686(%eax),%eax
  8002b6:	50                   	push   %eax
  8002b7:	ff d7                	call   *%edi
}
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    
  8002c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c7:	eb c4                	jmp    80028d <printnum+0x73>

008002c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d3:	8b 10                	mov    (%eax),%edx
  8002d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d8:	73 0a                	jae    8002e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dd:	89 08                	mov    %ecx,(%eax)
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	88 02                	mov    %al,(%edx)
}
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <printfmt>:
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ef:	50                   	push   %eax
  8002f0:	ff 75 10             	pushl  0x10(%ebp)
  8002f3:	ff 75 0c             	pushl  0xc(%ebp)
  8002f6:	ff 75 08             	pushl  0x8(%ebp)
  8002f9:	e8 05 00 00 00       	call   800303 <vprintfmt>
}
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <vprintfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 2c             	sub    $0x2c,%esp
  80030c:	8b 75 08             	mov    0x8(%ebp),%esi
  80030f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800312:	8b 7d 10             	mov    0x10(%ebp),%edi
  800315:	e9 21 04 00 00       	jmp    80073b <vprintfmt+0x438>
		padc = ' ';
  80031a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80031e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800325:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80032c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800333:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800338:	8d 47 01             	lea    0x1(%edi),%eax
  80033b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033e:	0f b6 17             	movzbl (%edi),%edx
  800341:	8d 42 dd             	lea    -0x23(%edx),%eax
  800344:	3c 55                	cmp    $0x55,%al
  800346:	0f 87 90 04 00 00    	ja     8007dc <vprintfmt+0x4d9>
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800359:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80035d:	eb d9                	jmp    800338 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800362:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800366:	eb d0                	jmp    800338 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800368:	0f b6 d2             	movzbl %dl,%edx
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80036e:	b8 00 00 00 00       	mov    $0x0,%eax
  800373:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800376:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800379:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80037d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800380:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800383:	83 f9 09             	cmp    $0x9,%ecx
  800386:	77 55                	ja     8003dd <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800388:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038b:	eb e9                	jmp    800376 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	8b 00                	mov    (%eax),%eax
  800392:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800395:	8b 45 14             	mov    0x14(%ebp),%eax
  800398:	8d 40 04             	lea    0x4(%eax),%eax
  80039b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a5:	79 91                	jns    800338 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ad:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b4:	eb 82                	jmp    800338 <vprintfmt+0x35>
  8003b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b9:	85 c0                	test   %eax,%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	0f 49 d0             	cmovns %eax,%edx
  8003c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c9:	e9 6a ff ff ff       	jmp    800338 <vprintfmt+0x35>
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d8:	e9 5b ff ff ff       	jmp    800338 <vprintfmt+0x35>
  8003dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e3:	eb bc                	jmp    8003a1 <vprintfmt+0x9e>
			lflag++;
  8003e5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003eb:	e9 48 ff ff ff       	jmp    800338 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8d 78 04             	lea    0x4(%eax),%edi
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	53                   	push   %ebx
  8003fa:	ff 30                	pushl  (%eax)
  8003fc:	ff d6                	call   *%esi
			break;
  8003fe:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800401:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800404:	e9 2f 03 00 00       	jmp    800738 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	8d 78 04             	lea    0x4(%eax),%edi
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	99                   	cltd   
  800412:	31 d0                	xor    %edx,%eax
  800414:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800416:	83 f8 0f             	cmp    $0xf,%eax
  800419:	7f 23                	jg     80043e <vprintfmt+0x13b>
  80041b:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800422:	85 d2                	test   %edx,%edx
  800424:	74 18                	je     80043e <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800426:	52                   	push   %edx
  800427:	68 7b 2a 80 00       	push   $0x802a7b
  80042c:	53                   	push   %ebx
  80042d:	56                   	push   %esi
  80042e:	e8 b3 fe ff ff       	call   8002e6 <printfmt>
  800433:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800436:	89 7d 14             	mov    %edi,0x14(%ebp)
  800439:	e9 fa 02 00 00       	jmp    800738 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80043e:	50                   	push   %eax
  80043f:	68 9e 26 80 00       	push   $0x80269e
  800444:	53                   	push   %ebx
  800445:	56                   	push   %esi
  800446:	e8 9b fe ff ff       	call   8002e6 <printfmt>
  80044b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800451:	e9 e2 02 00 00       	jmp    800738 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800456:	8b 45 14             	mov    0x14(%ebp),%eax
  800459:	83 c0 04             	add    $0x4,%eax
  80045c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800464:	85 ff                	test   %edi,%edi
  800466:	b8 97 26 80 00       	mov    $0x802697,%eax
  80046b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80046e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800472:	0f 8e bd 00 00 00    	jle    800535 <vprintfmt+0x232>
  800478:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80047c:	75 0e                	jne    80048c <vprintfmt+0x189>
  80047e:	89 75 08             	mov    %esi,0x8(%ebp)
  800481:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800484:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800487:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048a:	eb 6d                	jmp    8004f9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 d0             	pushl  -0x30(%ebp)
  800492:	57                   	push   %edi
  800493:	e8 ec 03 00 00       	call   800884 <strnlen>
  800498:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049b:	29 c1                	sub    %eax,%ecx
  80049d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004a0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004aa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ad:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004af:	eb 0f                	jmp    8004c0 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	53                   	push   %ebx
  8004b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ed                	jg     8004b1 <vprintfmt+0x1ae>
  8004c4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ca:	85 c9                	test   %ecx,%ecx
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	0f 49 c1             	cmovns %ecx,%eax
  8004d4:	29 c1                	sub    %eax,%ecx
  8004d6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004dc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004df:	89 cb                	mov    %ecx,%ebx
  8004e1:	eb 16                	jmp    8004f9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e7:	75 31                	jne    80051a <vprintfmt+0x217>
					putch(ch, putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	ff 75 0c             	pushl  0xc(%ebp)
  8004ef:	50                   	push   %eax
  8004f0:	ff 55 08             	call   *0x8(%ebp)
  8004f3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f6:	83 eb 01             	sub    $0x1,%ebx
  8004f9:	83 c7 01             	add    $0x1,%edi
  8004fc:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800500:	0f be c2             	movsbl %dl,%eax
  800503:	85 c0                	test   %eax,%eax
  800505:	74 59                	je     800560 <vprintfmt+0x25d>
  800507:	85 f6                	test   %esi,%esi
  800509:	78 d8                	js     8004e3 <vprintfmt+0x1e0>
  80050b:	83 ee 01             	sub    $0x1,%esi
  80050e:	79 d3                	jns    8004e3 <vprintfmt+0x1e0>
  800510:	89 df                	mov    %ebx,%edi
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
  800515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800518:	eb 37                	jmp    800551 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80051a:	0f be d2             	movsbl %dl,%edx
  80051d:	83 ea 20             	sub    $0x20,%edx
  800520:	83 fa 5e             	cmp    $0x5e,%edx
  800523:	76 c4                	jbe    8004e9 <vprintfmt+0x1e6>
					putch('?', putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 0c             	pushl  0xc(%ebp)
  80052b:	6a 3f                	push   $0x3f
  80052d:	ff 55 08             	call   *0x8(%ebp)
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	eb c1                	jmp    8004f6 <vprintfmt+0x1f3>
  800535:	89 75 08             	mov    %esi,0x8(%ebp)
  800538:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800541:	eb b6                	jmp    8004f9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 20                	push   $0x20
  800549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ee                	jg     800543 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 d8 01 00 00       	jmp    800738 <vprintfmt+0x435>
  800560:	89 df                	mov    %ebx,%edi
  800562:	8b 75 08             	mov    0x8(%ebp),%esi
  800565:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800568:	eb e7                	jmp    800551 <vprintfmt+0x24e>
	if (lflag >= 2)
  80056a:	83 f9 01             	cmp    $0x1,%ecx
  80056d:	7e 45                	jle    8005b4 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 50 04             	mov    0x4(%eax),%edx
  800575:	8b 00                	mov    (%eax),%eax
  800577:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 40 08             	lea    0x8(%eax),%eax
  800583:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800586:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80058a:	79 62                	jns    8005ee <vprintfmt+0x2eb>
				putch('-', putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	53                   	push   %ebx
  800590:	6a 2d                	push   $0x2d
  800592:	ff d6                	call   *%esi
				num = -(long long) num;
  800594:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800597:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80059a:	f7 d8                	neg    %eax
  80059c:	83 d2 00             	adc    $0x0,%edx
  80059f:	f7 da                	neg    %edx
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005aa:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005af:	e9 66 01 00 00       	jmp    80071a <vprintfmt+0x417>
	else if (lflag)
  8005b4:	85 c9                	test   %ecx,%ecx
  8005b6:	75 1b                	jne    8005d3 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c0:	89 c1                	mov    %eax,%ecx
  8005c2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d1:	eb b3                	jmp    800586 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	89 c1                	mov    %eax,%ecx
  8005dd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8d 40 04             	lea    0x4(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ec:	eb 98                	jmp    800586 <vprintfmt+0x283>
			base = 10;
  8005ee:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005f3:	e9 22 01 00 00       	jmp    80071a <vprintfmt+0x417>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 21                	jle    80061e <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 50 04             	mov    0x4(%eax),%edx
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800614:	ba 0a 00 00 00       	mov    $0xa,%edx
  800619:	e9 fc 00 00 00       	jmp    80071a <vprintfmt+0x417>
	else if (lflag)
  80061e:	85 c9                	test   %ecx,%ecx
  800620:	75 23                	jne    800645 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800640:	e9 d5 00 00 00       	jmp    80071a <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	ba 00 00 00 00       	mov    $0x0,%edx
  80064f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800652:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 40 04             	lea    0x4(%eax),%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800663:	e9 b2 00 00 00       	jmp    80071a <vprintfmt+0x417>
	if (lflag >= 2)
  800668:	83 f9 01             	cmp    $0x1,%ecx
  80066b:	7e 42                	jle    8006af <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 50 04             	mov    0x4(%eax),%edx
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 08             	lea    0x8(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800684:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800689:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068d:	0f 89 87 00 00 00    	jns    80071a <vprintfmt+0x417>
				putch('-', putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	53                   	push   %ebx
  800697:	6a 2d                	push   $0x2d
  800699:	ff d6                	call   *%esi
				num = -(long long) num;
  80069b:	f7 5d d8             	negl   -0x28(%ebp)
  80069e:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8006a2:	f7 5d dc             	negl   -0x24(%ebp)
  8006a5:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006a8:	ba 08 00 00 00       	mov    $0x8,%edx
  8006ad:	eb 6b                	jmp    80071a <vprintfmt+0x417>
	else if (lflag)
  8006af:	85 c9                	test   %ecx,%ecx
  8006b1:	75 1b                	jne    8006ce <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cc:	eb b6                	jmp    800684 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e7:	eb 9b                	jmp    800684 <vprintfmt+0x381>
			putch('0', putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	6a 30                	push   $0x30
  8006ef:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f1:	83 c4 08             	add    $0x8,%esp
  8006f4:	53                   	push   %ebx
  8006f5:	6a 78                	push   $0x78
  8006f7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800703:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800706:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800709:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 40 04             	lea    0x4(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800715:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80071a:	83 ec 0c             	sub    $0xc,%esp
  80071d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800721:	50                   	push   %eax
  800722:	ff 75 e0             	pushl  -0x20(%ebp)
  800725:	52                   	push   %edx
  800726:	ff 75 dc             	pushl  -0x24(%ebp)
  800729:	ff 75 d8             	pushl  -0x28(%ebp)
  80072c:	89 da                	mov    %ebx,%edx
  80072e:	89 f0                	mov    %esi,%eax
  800730:	e8 e5 fa ff ff       	call   80021a <printnum>
			break;
  800735:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800738:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073b:	83 c7 01             	add    $0x1,%edi
  80073e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800742:	83 f8 25             	cmp    $0x25,%eax
  800745:	0f 84 cf fb ff ff    	je     80031a <vprintfmt+0x17>
			if (ch == '\0')
  80074b:	85 c0                	test   %eax,%eax
  80074d:	0f 84 a9 00 00 00    	je     8007fc <vprintfmt+0x4f9>
			putch(ch, putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	53                   	push   %ebx
  800757:	50                   	push   %eax
  800758:	ff d6                	call   *%esi
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	eb dc                	jmp    80073b <vprintfmt+0x438>
	if (lflag >= 2)
  80075f:	83 f9 01             	cmp    $0x1,%ecx
  800762:	7e 1e                	jle    800782 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 40 08             	lea    0x8(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077b:	ba 10 00 00 00       	mov    $0x10,%edx
  800780:	eb 98                	jmp    80071a <vprintfmt+0x417>
	else if (lflag)
  800782:	85 c9                	test   %ecx,%ecx
  800784:	75 23                	jne    8007a9 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	ba 10 00 00 00       	mov    $0x10,%edx
  8007a4:	e9 71 ff ff ff       	jmp    80071a <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	ba 10 00 00 00       	mov    $0x10,%edx
  8007c7:	e9 4e ff ff ff       	jmp    80071a <vprintfmt+0x417>
			putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 25                	push   $0x25
  8007d2:	ff d6                	call   *%esi
			break;
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	e9 5c ff ff ff       	jmp    800738 <vprintfmt+0x435>
			putch('%', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	6a 25                	push   $0x25
  8007e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	89 f8                	mov    %edi,%eax
  8007e9:	eb 03                	jmp    8007ee <vprintfmt+0x4eb>
  8007eb:	83 e8 01             	sub    $0x1,%eax
  8007ee:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007f2:	75 f7                	jne    8007eb <vprintfmt+0x4e8>
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f7:	e9 3c ff ff ff       	jmp    800738 <vprintfmt+0x435>
}
  8007fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ff:	5b                   	pop    %ebx
  800800:	5e                   	pop    %esi
  800801:	5f                   	pop    %edi
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	83 ec 18             	sub    $0x18,%esp
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800810:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800813:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800817:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800821:	85 c0                	test   %eax,%eax
  800823:	74 26                	je     80084b <vsnprintf+0x47>
  800825:	85 d2                	test   %edx,%edx
  800827:	7e 22                	jle    80084b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800829:	ff 75 14             	pushl  0x14(%ebp)
  80082c:	ff 75 10             	pushl  0x10(%ebp)
  80082f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800832:	50                   	push   %eax
  800833:	68 c9 02 80 00       	push   $0x8002c9
  800838:	e8 c6 fa ff ff       	call   800303 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80083d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800840:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800846:	83 c4 10             	add    $0x10,%esp
}
  800849:	c9                   	leave  
  80084a:	c3                   	ret    
		return -E_INVAL;
  80084b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800850:	eb f7                	jmp    800849 <vsnprintf+0x45>

00800852 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800858:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80085b:	50                   	push   %eax
  80085c:	ff 75 10             	pushl  0x10(%ebp)
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 9a ff ff ff       	call   800804 <vsnprintf>
	va_end(ap);

	return rc;
}
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800872:	b8 00 00 00 00       	mov    $0x0,%eax
  800877:	eb 03                	jmp    80087c <strlen+0x10>
		n++;
  800879:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80087c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800880:	75 f7                	jne    800879 <strlen+0xd>
	return n;
}
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088d:	b8 00 00 00 00       	mov    $0x0,%eax
  800892:	eb 03                	jmp    800897 <strnlen+0x13>
		n++;
  800894:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800897:	39 d0                	cmp    %edx,%eax
  800899:	74 06                	je     8008a1 <strnlen+0x1d>
  80089b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80089f:	75 f3                	jne    800894 <strnlen+0x10>
	return n;
}
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	53                   	push   %ebx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ad:	89 c2                	mov    %eax,%edx
  8008af:	83 c1 01             	add    $0x1,%ecx
  8008b2:	83 c2 01             	add    $0x1,%edx
  8008b5:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008b9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008bc:	84 db                	test   %bl,%bl
  8008be:	75 ef                	jne    8008af <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008c0:	5b                   	pop    %ebx
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	53                   	push   %ebx
  8008c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008ca:	53                   	push   %ebx
  8008cb:	e8 9c ff ff ff       	call   80086c <strlen>
  8008d0:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	01 d8                	add    %ebx,%eax
  8008d8:	50                   	push   %eax
  8008d9:	e8 c5 ff ff ff       	call   8008a3 <strcpy>
	return dst;
}
  8008de:	89 d8                	mov    %ebx,%eax
  8008e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	56                   	push   %esi
  8008e9:	53                   	push   %ebx
  8008ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f0:	89 f3                	mov    %esi,%ebx
  8008f2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f5:	89 f2                	mov    %esi,%edx
  8008f7:	eb 0f                	jmp    800908 <strncpy+0x23>
		*dst++ = *src;
  8008f9:	83 c2 01             	add    $0x1,%edx
  8008fc:	0f b6 01             	movzbl (%ecx),%eax
  8008ff:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800902:	80 39 01             	cmpb   $0x1,(%ecx)
  800905:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800908:	39 da                	cmp    %ebx,%edx
  80090a:	75 ed                	jne    8008f9 <strncpy+0x14>
	}
	return ret;
}
  80090c:	89 f0                	mov    %esi,%eax
  80090e:	5b                   	pop    %ebx
  80090f:	5e                   	pop    %esi
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800920:	89 f0                	mov    %esi,%eax
  800922:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800926:	85 c9                	test   %ecx,%ecx
  800928:	75 0b                	jne    800935 <strlcpy+0x23>
  80092a:	eb 17                	jmp    800943 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	83 c0 01             	add    $0x1,%eax
  800932:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800935:	39 d8                	cmp    %ebx,%eax
  800937:	74 07                	je     800940 <strlcpy+0x2e>
  800939:	0f b6 0a             	movzbl (%edx),%ecx
  80093c:	84 c9                	test   %cl,%cl
  80093e:	75 ec                	jne    80092c <strlcpy+0x1a>
		*dst = '\0';
  800940:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800943:	29 f0                	sub    %esi,%eax
}
  800945:	5b                   	pop    %ebx
  800946:	5e                   	pop    %esi
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800952:	eb 06                	jmp    80095a <strcmp+0x11>
		p++, q++;
  800954:	83 c1 01             	add    $0x1,%ecx
  800957:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80095a:	0f b6 01             	movzbl (%ecx),%eax
  80095d:	84 c0                	test   %al,%al
  80095f:	74 04                	je     800965 <strcmp+0x1c>
  800961:	3a 02                	cmp    (%edx),%al
  800963:	74 ef                	je     800954 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800965:	0f b6 c0             	movzbl %al,%eax
  800968:	0f b6 12             	movzbl (%edx),%edx
  80096b:	29 d0                	sub    %edx,%eax
}
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	53                   	push   %ebx
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
  800979:	89 c3                	mov    %eax,%ebx
  80097b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80097e:	eb 06                	jmp    800986 <strncmp+0x17>
		n--, p++, q++;
  800980:	83 c0 01             	add    $0x1,%eax
  800983:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800986:	39 d8                	cmp    %ebx,%eax
  800988:	74 16                	je     8009a0 <strncmp+0x31>
  80098a:	0f b6 08             	movzbl (%eax),%ecx
  80098d:	84 c9                	test   %cl,%cl
  80098f:	74 04                	je     800995 <strncmp+0x26>
  800991:	3a 0a                	cmp    (%edx),%cl
  800993:	74 eb                	je     800980 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800995:	0f b6 00             	movzbl (%eax),%eax
  800998:	0f b6 12             	movzbl (%edx),%edx
  80099b:	29 d0                	sub    %edx,%eax
}
  80099d:	5b                   	pop    %ebx
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    
		return 0;
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	eb f6                	jmp    80099d <strncmp+0x2e>

008009a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b1:	0f b6 10             	movzbl (%eax),%edx
  8009b4:	84 d2                	test   %dl,%dl
  8009b6:	74 09                	je     8009c1 <strchr+0x1a>
		if (*s == c)
  8009b8:	38 ca                	cmp    %cl,%dl
  8009ba:	74 0a                	je     8009c6 <strchr+0x1f>
	for (; *s; s++)
  8009bc:	83 c0 01             	add    $0x1,%eax
  8009bf:	eb f0                	jmp    8009b1 <strchr+0xa>
			return (char *) s;
	return 0;
  8009c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d2:	eb 03                	jmp    8009d7 <strfind+0xf>
  8009d4:	83 c0 01             	add    $0x1,%eax
  8009d7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009da:	38 ca                	cmp    %cl,%dl
  8009dc:	74 04                	je     8009e2 <strfind+0x1a>
  8009de:	84 d2                	test   %dl,%dl
  8009e0:	75 f2                	jne    8009d4 <strfind+0xc>
			break;
	return (char *) s;
}
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	57                   	push   %edi
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f0:	85 c9                	test   %ecx,%ecx
  8009f2:	74 13                	je     800a07 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009fa:	75 05                	jne    800a01 <memset+0x1d>
  8009fc:	f6 c1 03             	test   $0x3,%cl
  8009ff:	74 0d                	je     800a0e <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	fc                   	cld    
  800a05:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a07:	89 f8                	mov    %edi,%eax
  800a09:	5b                   	pop    %ebx
  800a0a:	5e                   	pop    %esi
  800a0b:	5f                   	pop    %edi
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    
		c &= 0xFF;
  800a0e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a12:	89 d3                	mov    %edx,%ebx
  800a14:	c1 e3 08             	shl    $0x8,%ebx
  800a17:	89 d0                	mov    %edx,%eax
  800a19:	c1 e0 18             	shl    $0x18,%eax
  800a1c:	89 d6                	mov    %edx,%esi
  800a1e:	c1 e6 10             	shl    $0x10,%esi
  800a21:	09 f0                	or     %esi,%eax
  800a23:	09 c2                	or     %eax,%edx
  800a25:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a27:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a2a:	89 d0                	mov    %edx,%eax
  800a2c:	fc                   	cld    
  800a2d:	f3 ab                	rep stos %eax,%es:(%edi)
  800a2f:	eb d6                	jmp    800a07 <memset+0x23>

00800a31 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	57                   	push   %edi
  800a35:	56                   	push   %esi
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a3f:	39 c6                	cmp    %eax,%esi
  800a41:	73 35                	jae    800a78 <memmove+0x47>
  800a43:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a46:	39 c2                	cmp    %eax,%edx
  800a48:	76 2e                	jbe    800a78 <memmove+0x47>
		s += n;
		d += n;
  800a4a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4d:	89 d6                	mov    %edx,%esi
  800a4f:	09 fe                	or     %edi,%esi
  800a51:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a57:	74 0c                	je     800a65 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a59:	83 ef 01             	sub    $0x1,%edi
  800a5c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a5f:	fd                   	std    
  800a60:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a62:	fc                   	cld    
  800a63:	eb 21                	jmp    800a86 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a65:	f6 c1 03             	test   $0x3,%cl
  800a68:	75 ef                	jne    800a59 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a6a:	83 ef 04             	sub    $0x4,%edi
  800a6d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a70:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a73:	fd                   	std    
  800a74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a76:	eb ea                	jmp    800a62 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a78:	89 f2                	mov    %esi,%edx
  800a7a:	09 c2                	or     %eax,%edx
  800a7c:	f6 c2 03             	test   $0x3,%dl
  800a7f:	74 09                	je     800a8a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a81:	89 c7                	mov    %eax,%edi
  800a83:	fc                   	cld    
  800a84:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a86:	5e                   	pop    %esi
  800a87:	5f                   	pop    %edi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8a:	f6 c1 03             	test   $0x3,%cl
  800a8d:	75 f2                	jne    800a81 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a8f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a92:	89 c7                	mov    %eax,%edi
  800a94:	fc                   	cld    
  800a95:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a97:	eb ed                	jmp    800a86 <memmove+0x55>

00800a99 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a9c:	ff 75 10             	pushl  0x10(%ebp)
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	ff 75 08             	pushl  0x8(%ebp)
  800aa5:	e8 87 ff ff ff       	call   800a31 <memmove>
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab7:	89 c6                	mov    %eax,%esi
  800ab9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abc:	39 f0                	cmp    %esi,%eax
  800abe:	74 1c                	je     800adc <memcmp+0x30>
		if (*s1 != *s2)
  800ac0:	0f b6 08             	movzbl (%eax),%ecx
  800ac3:	0f b6 1a             	movzbl (%edx),%ebx
  800ac6:	38 d9                	cmp    %bl,%cl
  800ac8:	75 08                	jne    800ad2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	83 c2 01             	add    $0x1,%edx
  800ad0:	eb ea                	jmp    800abc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ad2:	0f b6 c1             	movzbl %cl,%eax
  800ad5:	0f b6 db             	movzbl %bl,%ebx
  800ad8:	29 d8                	sub    %ebx,%eax
  800ada:	eb 05                	jmp    800ae1 <memcmp+0x35>
	}

	return 0;
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af3:	39 d0                	cmp    %edx,%eax
  800af5:	73 09                	jae    800b00 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af7:	38 08                	cmp    %cl,(%eax)
  800af9:	74 05                	je     800b00 <memfind+0x1b>
	for (; s < ends; s++)
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	eb f3                	jmp    800af3 <memfind+0xe>
			break;
	return (void *) s;
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	57                   	push   %edi
  800b06:	56                   	push   %esi
  800b07:	53                   	push   %ebx
  800b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0e:	eb 03                	jmp    800b13 <strtol+0x11>
		s++;
  800b10:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b13:	0f b6 01             	movzbl (%ecx),%eax
  800b16:	3c 20                	cmp    $0x20,%al
  800b18:	74 f6                	je     800b10 <strtol+0xe>
  800b1a:	3c 09                	cmp    $0x9,%al
  800b1c:	74 f2                	je     800b10 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b1e:	3c 2b                	cmp    $0x2b,%al
  800b20:	74 2e                	je     800b50 <strtol+0x4e>
	int neg = 0;
  800b22:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b27:	3c 2d                	cmp    $0x2d,%al
  800b29:	74 2f                	je     800b5a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b31:	75 05                	jne    800b38 <strtol+0x36>
  800b33:	80 39 30             	cmpb   $0x30,(%ecx)
  800b36:	74 2c                	je     800b64 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	75 0a                	jne    800b46 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b3c:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b41:	80 39 30             	cmpb   $0x30,(%ecx)
  800b44:	74 28                	je     800b6e <strtol+0x6c>
		base = 10;
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b4e:	eb 50                	jmp    800ba0 <strtol+0x9e>
		s++;
  800b50:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b53:	bf 00 00 00 00       	mov    $0x0,%edi
  800b58:	eb d1                	jmp    800b2b <strtol+0x29>
		s++, neg = 1;
  800b5a:	83 c1 01             	add    $0x1,%ecx
  800b5d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b62:	eb c7                	jmp    800b2b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b64:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b68:	74 0e                	je     800b78 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b6a:	85 db                	test   %ebx,%ebx
  800b6c:	75 d8                	jne    800b46 <strtol+0x44>
		s++, base = 8;
  800b6e:	83 c1 01             	add    $0x1,%ecx
  800b71:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b76:	eb ce                	jmp    800b46 <strtol+0x44>
		s += 2, base = 16;
  800b78:	83 c1 02             	add    $0x2,%ecx
  800b7b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b80:	eb c4                	jmp    800b46 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b82:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b85:	89 f3                	mov    %esi,%ebx
  800b87:	80 fb 19             	cmp    $0x19,%bl
  800b8a:	77 29                	ja     800bb5 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b8c:	0f be d2             	movsbl %dl,%edx
  800b8f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b92:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b95:	7d 30                	jge    800bc7 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b97:	83 c1 01             	add    $0x1,%ecx
  800b9a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b9e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ba0:	0f b6 11             	movzbl (%ecx),%edx
  800ba3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ba6:	89 f3                	mov    %esi,%ebx
  800ba8:	80 fb 09             	cmp    $0x9,%bl
  800bab:	77 d5                	ja     800b82 <strtol+0x80>
			dig = *s - '0';
  800bad:	0f be d2             	movsbl %dl,%edx
  800bb0:	83 ea 30             	sub    $0x30,%edx
  800bb3:	eb dd                	jmp    800b92 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bb5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bb8:	89 f3                	mov    %esi,%ebx
  800bba:	80 fb 19             	cmp    $0x19,%bl
  800bbd:	77 08                	ja     800bc7 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bbf:	0f be d2             	movsbl %dl,%edx
  800bc2:	83 ea 37             	sub    $0x37,%edx
  800bc5:	eb cb                	jmp    800b92 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcb:	74 05                	je     800bd2 <strtol+0xd0>
		*endptr = (char *) s;
  800bcd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bd2:	89 c2                	mov    %eax,%edx
  800bd4:	f7 da                	neg    %edx
  800bd6:	85 ff                	test   %edi,%edi
  800bd8:	0f 45 c2             	cmovne %edx,%eax
}
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5f                   	pop    %edi
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
  800beb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf1:	89 c3                	mov    %eax,%ebx
  800bf3:	89 c7                	mov    %eax,%edi
  800bf5:	89 c6                	mov    %eax,%esi
  800bf7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf9:	5b                   	pop    %ebx
  800bfa:	5e                   	pop    %esi
  800bfb:	5f                   	pop    %edi
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <sys_cgetc>:

int
sys_cgetc(void)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	b8 01 00 00 00       	mov    $0x1,%eax
  800c0e:	89 d1                	mov    %edx,%ecx
  800c10:	89 d3                	mov    %edx,%ebx
  800c12:	89 d7                	mov    %edx,%edi
  800c14:	89 d6                	mov    %edx,%esi
  800c16:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c33:	89 cb                	mov    %ecx,%ebx
  800c35:	89 cf                	mov    %ecx,%edi
  800c37:	89 ce                	mov    %ecx,%esi
  800c39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	7f 08                	jg     800c47 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c47:	83 ec 0c             	sub    $0xc,%esp
  800c4a:	50                   	push   %eax
  800c4b:	6a 03                	push   $0x3
  800c4d:	68 7f 29 80 00       	push   $0x80297f
  800c52:	6a 23                	push   $0x23
  800c54:	68 9c 29 80 00       	push   $0x80299c
  800c59:	e8 16 16 00 00       	call   802274 <_panic>

00800c5e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	57                   	push   %edi
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c64:	ba 00 00 00 00       	mov    $0x0,%edx
  800c69:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6e:	89 d1                	mov    %edx,%ecx
  800c70:	89 d3                	mov    %edx,%ebx
  800c72:	89 d7                	mov    %edx,%edi
  800c74:	89 d6                	mov    %edx,%esi
  800c76:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5f                   	pop    %edi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    

00800c7d <sys_yield>:

void
sys_yield(void)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	57                   	push   %edi
  800c81:	56                   	push   %esi
  800c82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c83:	ba 00 00 00 00       	mov    $0x0,%edx
  800c88:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8d:	89 d1                	mov    %edx,%ecx
  800c8f:	89 d3                	mov    %edx,%ebx
  800c91:	89 d7                	mov    %edx,%edi
  800c93:	89 d6                	mov    %edx,%esi
  800c95:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
  800ca2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca5:	be 00 00 00 00       	mov    $0x0,%esi
  800caa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb0:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb8:	89 f7                	mov    %esi,%edi
  800cba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	7f 08                	jg     800cc8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc8:	83 ec 0c             	sub    $0xc,%esp
  800ccb:	50                   	push   %eax
  800ccc:	6a 04                	push   $0x4
  800cce:	68 7f 29 80 00       	push   $0x80297f
  800cd3:	6a 23                	push   $0x23
  800cd5:	68 9c 29 80 00       	push   $0x80299c
  800cda:	e8 95 15 00 00       	call   802274 <_panic>

00800cdf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	57                   	push   %edi
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
  800ce5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cee:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf9:	8b 75 18             	mov    0x18(%ebp),%esi
  800cfc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfe:	85 c0                	test   %eax,%eax
  800d00:	7f 08                	jg     800d0a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5f                   	pop    %edi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	50                   	push   %eax
  800d0e:	6a 05                	push   $0x5
  800d10:	68 7f 29 80 00       	push   $0x80297f
  800d15:	6a 23                	push   $0x23
  800d17:	68 9c 29 80 00       	push   $0x80299c
  800d1c:	e8 53 15 00 00       	call   802274 <_panic>

00800d21 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	57                   	push   %edi
  800d25:	56                   	push   %esi
  800d26:	53                   	push   %ebx
  800d27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d35:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3a:	89 df                	mov    %ebx,%edi
  800d3c:	89 de                	mov    %ebx,%esi
  800d3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	7f 08                	jg     800d4c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4c:	83 ec 0c             	sub    $0xc,%esp
  800d4f:	50                   	push   %eax
  800d50:	6a 06                	push   $0x6
  800d52:	68 7f 29 80 00       	push   $0x80297f
  800d57:	6a 23                	push   $0x23
  800d59:	68 9c 29 80 00       	push   $0x80299c
  800d5e:	e8 11 15 00 00       	call   802274 <_panic>

00800d63 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d77:	b8 08 00 00 00       	mov    $0x8,%eax
  800d7c:	89 df                	mov    %ebx,%edi
  800d7e:	89 de                	mov    %ebx,%esi
  800d80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d82:	85 c0                	test   %eax,%eax
  800d84:	7f 08                	jg     800d8e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5f                   	pop    %edi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8e:	83 ec 0c             	sub    $0xc,%esp
  800d91:	50                   	push   %eax
  800d92:	6a 08                	push   $0x8
  800d94:	68 7f 29 80 00       	push   $0x80297f
  800d99:	6a 23                	push   $0x23
  800d9b:	68 9c 29 80 00       	push   $0x80299c
  800da0:	e8 cf 14 00 00       	call   802274 <_panic>

00800da5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	b8 09 00 00 00       	mov    $0x9,%eax
  800dbe:	89 df                	mov    %ebx,%edi
  800dc0:	89 de                	mov    %ebx,%esi
  800dc2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc4:	85 c0                	test   %eax,%eax
  800dc6:	7f 08                	jg     800dd0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd0:	83 ec 0c             	sub    $0xc,%esp
  800dd3:	50                   	push   %eax
  800dd4:	6a 09                	push   $0x9
  800dd6:	68 7f 29 80 00       	push   $0x80297f
  800ddb:	6a 23                	push   $0x23
  800ddd:	68 9c 29 80 00       	push   $0x80299c
  800de2:	e8 8d 14 00 00       	call   802274 <_panic>

00800de7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df5:	8b 55 08             	mov    0x8(%ebp),%edx
  800df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e00:	89 df                	mov    %ebx,%edi
  800e02:	89 de                	mov    %ebx,%esi
  800e04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7f 08                	jg     800e12 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	50                   	push   %eax
  800e16:	6a 0a                	push   $0xa
  800e18:	68 7f 29 80 00       	push   $0x80297f
  800e1d:	6a 23                	push   $0x23
  800e1f:	68 9c 29 80 00       	push   $0x80299c
  800e24:	e8 4b 14 00 00       	call   802274 <_panic>

00800e29 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3a:	be 00 00 00 00       	mov    $0x0,%esi
  800e3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e45:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e62:	89 cb                	mov    %ecx,%ebx
  800e64:	89 cf                	mov    %ecx,%edi
  800e66:	89 ce                	mov    %ecx,%esi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800e7a:	6a 0d                	push   $0xd
  800e7c:	68 7f 29 80 00       	push   $0x80297f
  800e81:	6a 23                	push   $0x23
  800e83:	68 9c 29 80 00       	push   $0x80299c
  800e88:	e8 e7 13 00 00       	call   802274 <_panic>

00800e8d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e93:	ba 00 00 00 00       	mov    $0x0,%edx
  800e98:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e9d:	89 d1                	mov    %edx,%ecx
  800e9f:	89 d3                	mov    %edx,%ebx
  800ea1:	89 d7                	mov    %edx,%edi
  800ea3:	89 d6                	mov    %edx,%esi
  800ea5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800eb8:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800eba:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800ebd:	83 3a 01             	cmpl   $0x1,(%edx)
  800ec0:	7e 09                	jle    800ecb <argstart+0x1f>
  800ec2:	ba 51 26 80 00       	mov    $0x802651,%edx
  800ec7:	85 c9                	test   %ecx,%ecx
  800ec9:	75 05                	jne    800ed0 <argstart+0x24>
  800ecb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed0:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800ed3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <argnext>:

int
argnext(struct Argstate *args)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 04             	sub    $0x4,%esp
  800ee3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800ee6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800eed:	8b 43 08             	mov    0x8(%ebx),%eax
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	74 72                	je     800f66 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  800ef4:	80 38 00             	cmpb   $0x0,(%eax)
  800ef7:	75 48                	jne    800f41 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800ef9:	8b 0b                	mov    (%ebx),%ecx
  800efb:	83 39 01             	cmpl   $0x1,(%ecx)
  800efe:	74 58                	je     800f58 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  800f00:	8b 53 04             	mov    0x4(%ebx),%edx
  800f03:	8b 42 04             	mov    0x4(%edx),%eax
  800f06:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f09:	75 4d                	jne    800f58 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  800f0b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f0f:	74 47                	je     800f58 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800f11:	83 c0 01             	add    $0x1,%eax
  800f14:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f17:	83 ec 04             	sub    $0x4,%esp
  800f1a:	8b 01                	mov    (%ecx),%eax
  800f1c:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800f23:	50                   	push   %eax
  800f24:	8d 42 08             	lea    0x8(%edx),%eax
  800f27:	50                   	push   %eax
  800f28:	83 c2 04             	add    $0x4,%edx
  800f2b:	52                   	push   %edx
  800f2c:	e8 00 fb ff ff       	call   800a31 <memmove>
		(*args->argc)--;
  800f31:	8b 03                	mov    (%ebx),%eax
  800f33:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f36:	8b 43 08             	mov    0x8(%ebx),%eax
  800f39:	83 c4 10             	add    $0x10,%esp
  800f3c:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f3f:	74 11                	je     800f52 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800f41:	8b 53 08             	mov    0x8(%ebx),%edx
  800f44:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800f47:	83 c2 01             	add    $0x1,%edx
  800f4a:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800f4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f52:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f56:	75 e9                	jne    800f41 <argnext+0x65>
	args->curarg = 0;
  800f58:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800f64:	eb e7                	jmp    800f4d <argnext+0x71>
		return -1;
  800f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800f6b:	eb e0                	jmp    800f4d <argnext+0x71>

00800f6d <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	53                   	push   %ebx
  800f71:	83 ec 04             	sub    $0x4,%esp
  800f74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800f77:	8b 43 08             	mov    0x8(%ebx),%eax
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	74 5b                	je     800fd9 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  800f7e:	80 38 00             	cmpb   $0x0,(%eax)
  800f81:	74 12                	je     800f95 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  800f83:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800f86:	c7 43 08 51 26 80 00 	movl   $0x802651,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800f8d:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800f90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    
	} else if (*args->argc > 1) {
  800f95:	8b 13                	mov    (%ebx),%edx
  800f97:	83 3a 01             	cmpl   $0x1,(%edx)
  800f9a:	7f 10                	jg     800fac <argnextvalue+0x3f>
		args->argvalue = 0;
  800f9c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800fa3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800faa:	eb e1                	jmp    800f8d <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  800fac:	8b 43 04             	mov    0x4(%ebx),%eax
  800faf:	8b 48 04             	mov    0x4(%eax),%ecx
  800fb2:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	8b 12                	mov    (%edx),%edx
  800fba:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800fc1:	52                   	push   %edx
  800fc2:	8d 50 08             	lea    0x8(%eax),%edx
  800fc5:	52                   	push   %edx
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	50                   	push   %eax
  800fca:	e8 62 fa ff ff       	call   800a31 <memmove>
		(*args->argc)--;
  800fcf:	8b 03                	mov    (%ebx),%eax
  800fd1:	83 28 01             	subl   $0x1,(%eax)
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	eb b4                	jmp    800f8d <argnextvalue+0x20>
		return 0;
  800fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fde:	eb b0                	jmp    800f90 <argnextvalue+0x23>

00800fe0 <argvalue>:
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fe9:	8b 42 0c             	mov    0xc(%edx),%eax
  800fec:	85 c0                	test   %eax,%eax
  800fee:	74 02                	je     800ff2 <argvalue+0x12>
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800ff2:	83 ec 0c             	sub    $0xc,%esp
  800ff5:	52                   	push   %edx
  800ff6:	e8 72 ff ff ff       	call   800f6d <argnextvalue>
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	eb f0                	jmp    800ff0 <argvalue+0x10>

00801000 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	05 00 00 00 30       	add    $0x30000000,%eax
  80100b:	c1 e8 0c             	shr    $0xc,%eax
}
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    

00801010 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80101b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801020:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801032:	89 c2                	mov    %eax,%edx
  801034:	c1 ea 16             	shr    $0x16,%edx
  801037:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80103e:	f6 c2 01             	test   $0x1,%dl
  801041:	74 2a                	je     80106d <fd_alloc+0x46>
  801043:	89 c2                	mov    %eax,%edx
  801045:	c1 ea 0c             	shr    $0xc,%edx
  801048:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80104f:	f6 c2 01             	test   $0x1,%dl
  801052:	74 19                	je     80106d <fd_alloc+0x46>
  801054:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801059:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80105e:	75 d2                	jne    801032 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801060:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801066:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80106b:	eb 07                	jmp    801074 <fd_alloc+0x4d>
			*fd_store = fd;
  80106d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80107c:	83 f8 1f             	cmp    $0x1f,%eax
  80107f:	77 36                	ja     8010b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801081:	c1 e0 0c             	shl    $0xc,%eax
  801084:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801089:	89 c2                	mov    %eax,%edx
  80108b:	c1 ea 16             	shr    $0x16,%edx
  80108e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801095:	f6 c2 01             	test   $0x1,%dl
  801098:	74 24                	je     8010be <fd_lookup+0x48>
  80109a:	89 c2                	mov    %eax,%edx
  80109c:	c1 ea 0c             	shr    $0xc,%edx
  80109f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a6:	f6 c2 01             	test   $0x1,%dl
  8010a9:	74 1a                	je     8010c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8010b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    
		return -E_INVAL;
  8010b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010bc:	eb f7                	jmp    8010b5 <fd_lookup+0x3f>
		return -E_INVAL;
  8010be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c3:	eb f0                	jmp    8010b5 <fd_lookup+0x3f>
  8010c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ca:	eb e9                	jmp    8010b5 <fd_lookup+0x3f>

008010cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	83 ec 08             	sub    $0x8,%esp
  8010d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d5:	ba 28 2a 80 00       	mov    $0x802a28,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010da:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010df:	39 08                	cmp    %ecx,(%eax)
  8010e1:	74 33                	je     801116 <dev_lookup+0x4a>
  8010e3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010e6:	8b 02                	mov    (%edx),%eax
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	75 f3                	jne    8010df <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8010f1:	8b 40 48             	mov    0x48(%eax),%eax
  8010f4:	83 ec 04             	sub    $0x4,%esp
  8010f7:	51                   	push   %ecx
  8010f8:	50                   	push   %eax
  8010f9:	68 ac 29 80 00       	push   $0x8029ac
  8010fe:	e8 03 f1 ff ff       	call   800206 <cprintf>
	*dev = 0;
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    
			*dev = devtab[i];
  801116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801119:	89 01                	mov    %eax,(%ecx)
			return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
  801120:	eb f2                	jmp    801114 <dev_lookup+0x48>

00801122 <fd_close>:
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	57                   	push   %edi
  801126:	56                   	push   %esi
  801127:	53                   	push   %ebx
  801128:	83 ec 1c             	sub    $0x1c,%esp
  80112b:	8b 75 08             	mov    0x8(%ebp),%esi
  80112e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801131:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801134:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801135:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80113b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80113e:	50                   	push   %eax
  80113f:	e8 32 ff ff ff       	call   801076 <fd_lookup>
  801144:	89 c3                	mov    %eax,%ebx
  801146:	83 c4 08             	add    $0x8,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 05                	js     801152 <fd_close+0x30>
	    || fd != fd2)
  80114d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801150:	74 16                	je     801168 <fd_close+0x46>
		return (must_exist ? r : 0);
  801152:	89 f8                	mov    %edi,%eax
  801154:	84 c0                	test   %al,%al
  801156:	b8 00 00 00 00       	mov    $0x0,%eax
  80115b:	0f 44 d8             	cmove  %eax,%ebx
}
  80115e:	89 d8                	mov    %ebx,%eax
  801160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80116e:	50                   	push   %eax
  80116f:	ff 36                	pushl  (%esi)
  801171:	e8 56 ff ff ff       	call   8010cc <dev_lookup>
  801176:	89 c3                	mov    %eax,%ebx
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	85 c0                	test   %eax,%eax
  80117d:	78 15                	js     801194 <fd_close+0x72>
		if (dev->dev_close)
  80117f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801182:	8b 40 10             	mov    0x10(%eax),%eax
  801185:	85 c0                	test   %eax,%eax
  801187:	74 1b                	je     8011a4 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	56                   	push   %esi
  80118d:	ff d0                	call   *%eax
  80118f:	89 c3                	mov    %eax,%ebx
  801191:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	56                   	push   %esi
  801198:	6a 00                	push   $0x0
  80119a:	e8 82 fb ff ff       	call   800d21 <sys_page_unmap>
	return r;
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	eb ba                	jmp    80115e <fd_close+0x3c>
			r = 0;
  8011a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a9:	eb e9                	jmp    801194 <fd_close+0x72>

008011ab <close>:

int
close(int fdnum)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b4:	50                   	push   %eax
  8011b5:	ff 75 08             	pushl  0x8(%ebp)
  8011b8:	e8 b9 fe ff ff       	call   801076 <fd_lookup>
  8011bd:	83 c4 08             	add    $0x8,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	78 10                	js     8011d4 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8011c4:	83 ec 08             	sub    $0x8,%esp
  8011c7:	6a 01                	push   $0x1
  8011c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cc:	e8 51 ff ff ff       	call   801122 <fd_close>
  8011d1:	83 c4 10             	add    $0x10,%esp
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <close_all>:

void
close_all(void)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	53                   	push   %ebx
  8011da:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	53                   	push   %ebx
  8011e6:	e8 c0 ff ff ff       	call   8011ab <close>
	for (i = 0; i < MAXFD; i++)
  8011eb:	83 c3 01             	add    $0x1,%ebx
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	83 fb 20             	cmp    $0x20,%ebx
  8011f4:	75 ec                	jne    8011e2 <close_all+0xc>
}
  8011f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
  801201:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801204:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801207:	50                   	push   %eax
  801208:	ff 75 08             	pushl  0x8(%ebp)
  80120b:	e8 66 fe ff ff       	call   801076 <fd_lookup>
  801210:	89 c3                	mov    %eax,%ebx
  801212:	83 c4 08             	add    $0x8,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	0f 88 81 00 00 00    	js     80129e <dup+0xa3>
		return r;
	close(newfdnum);
  80121d:	83 ec 0c             	sub    $0xc,%esp
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	e8 83 ff ff ff       	call   8011ab <close>

	newfd = INDEX2FD(newfdnum);
  801228:	8b 75 0c             	mov    0xc(%ebp),%esi
  80122b:	c1 e6 0c             	shl    $0xc,%esi
  80122e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801234:	83 c4 04             	add    $0x4,%esp
  801237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80123a:	e8 d1 fd ff ff       	call   801010 <fd2data>
  80123f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801241:	89 34 24             	mov    %esi,(%esp)
  801244:	e8 c7 fd ff ff       	call   801010 <fd2data>
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80124e:	89 d8                	mov    %ebx,%eax
  801250:	c1 e8 16             	shr    $0x16,%eax
  801253:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80125a:	a8 01                	test   $0x1,%al
  80125c:	74 11                	je     80126f <dup+0x74>
  80125e:	89 d8                	mov    %ebx,%eax
  801260:	c1 e8 0c             	shr    $0xc,%eax
  801263:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80126a:	f6 c2 01             	test   $0x1,%dl
  80126d:	75 39                	jne    8012a8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80126f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801272:	89 d0                	mov    %edx,%eax
  801274:	c1 e8 0c             	shr    $0xc,%eax
  801277:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	25 07 0e 00 00       	and    $0xe07,%eax
  801286:	50                   	push   %eax
  801287:	56                   	push   %esi
  801288:	6a 00                	push   $0x0
  80128a:	52                   	push   %edx
  80128b:	6a 00                	push   $0x0
  80128d:	e8 4d fa ff ff       	call   800cdf <sys_page_map>
  801292:	89 c3                	mov    %eax,%ebx
  801294:	83 c4 20             	add    $0x20,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	78 31                	js     8012cc <dup+0xd1>
		goto err;

	return newfdnum;
  80129b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80129e:	89 d8                	mov    %ebx,%eax
  8012a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b7:	50                   	push   %eax
  8012b8:	57                   	push   %edi
  8012b9:	6a 00                	push   $0x0
  8012bb:	53                   	push   %ebx
  8012bc:	6a 00                	push   $0x0
  8012be:	e8 1c fa ff ff       	call   800cdf <sys_page_map>
  8012c3:	89 c3                	mov    %eax,%ebx
  8012c5:	83 c4 20             	add    $0x20,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	79 a3                	jns    80126f <dup+0x74>
	sys_page_unmap(0, newfd);
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	56                   	push   %esi
  8012d0:	6a 00                	push   $0x0
  8012d2:	e8 4a fa ff ff       	call   800d21 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d7:	83 c4 08             	add    $0x8,%esp
  8012da:	57                   	push   %edi
  8012db:	6a 00                	push   $0x0
  8012dd:	e8 3f fa ff ff       	call   800d21 <sys_page_unmap>
	return r;
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	eb b7                	jmp    80129e <dup+0xa3>

008012e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 14             	sub    $0x14,%esp
  8012ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f4:	50                   	push   %eax
  8012f5:	53                   	push   %ebx
  8012f6:	e8 7b fd ff ff       	call   801076 <fd_lookup>
  8012fb:	83 c4 08             	add    $0x8,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	78 3f                	js     801341 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801308:	50                   	push   %eax
  801309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130c:	ff 30                	pushl  (%eax)
  80130e:	e8 b9 fd ff ff       	call   8010cc <dev_lookup>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	78 27                	js     801341 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80131a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80131d:	8b 42 08             	mov    0x8(%edx),%eax
  801320:	83 e0 03             	and    $0x3,%eax
  801323:	83 f8 01             	cmp    $0x1,%eax
  801326:	74 1e                	je     801346 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132b:	8b 40 08             	mov    0x8(%eax),%eax
  80132e:	85 c0                	test   %eax,%eax
  801330:	74 35                	je     801367 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801332:	83 ec 04             	sub    $0x4,%esp
  801335:	ff 75 10             	pushl  0x10(%ebp)
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	52                   	push   %edx
  80133c:	ff d0                	call   *%eax
  80133e:	83 c4 10             	add    $0x10,%esp
}
  801341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801344:	c9                   	leave  
  801345:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801346:	a1 08 40 80 00       	mov    0x804008,%eax
  80134b:	8b 40 48             	mov    0x48(%eax),%eax
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	53                   	push   %ebx
  801352:	50                   	push   %eax
  801353:	68 ed 29 80 00       	push   $0x8029ed
  801358:	e8 a9 ee ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801365:	eb da                	jmp    801341 <read+0x5a>
		return -E_NOT_SUPP;
  801367:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136c:	eb d3                	jmp    801341 <read+0x5a>

0080136e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	57                   	push   %edi
  801372:	56                   	push   %esi
  801373:	53                   	push   %ebx
  801374:	83 ec 0c             	sub    $0xc,%esp
  801377:	8b 7d 08             	mov    0x8(%ebp),%edi
  80137a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80137d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801382:	39 f3                	cmp    %esi,%ebx
  801384:	73 25                	jae    8013ab <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801386:	83 ec 04             	sub    $0x4,%esp
  801389:	89 f0                	mov    %esi,%eax
  80138b:	29 d8                	sub    %ebx,%eax
  80138d:	50                   	push   %eax
  80138e:	89 d8                	mov    %ebx,%eax
  801390:	03 45 0c             	add    0xc(%ebp),%eax
  801393:	50                   	push   %eax
  801394:	57                   	push   %edi
  801395:	e8 4d ff ff ff       	call   8012e7 <read>
		if (m < 0)
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 08                	js     8013a9 <readn+0x3b>
			return m;
		if (m == 0)
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	74 06                	je     8013ab <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8013a5:	01 c3                	add    %eax,%ebx
  8013a7:	eb d9                	jmp    801382 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5e                   	pop    %esi
  8013b2:	5f                   	pop    %edi
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 14             	sub    $0x14,%esp
  8013bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c2:	50                   	push   %eax
  8013c3:	53                   	push   %ebx
  8013c4:	e8 ad fc ff ff       	call   801076 <fd_lookup>
  8013c9:	83 c4 08             	add    $0x8,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 3a                	js     80140a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d6:	50                   	push   %eax
  8013d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013da:	ff 30                	pushl  (%eax)
  8013dc:	e8 eb fc ff ff       	call   8010cc <dev_lookup>
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 22                	js     80140a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013eb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ef:	74 1e                	je     80140f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f7:	85 d2                	test   %edx,%edx
  8013f9:	74 35                	je     801430 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	ff 75 10             	pushl  0x10(%ebp)
  801401:	ff 75 0c             	pushl  0xc(%ebp)
  801404:	50                   	push   %eax
  801405:	ff d2                	call   *%edx
  801407:	83 c4 10             	add    $0x10,%esp
}
  80140a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80140f:	a1 08 40 80 00       	mov    0x804008,%eax
  801414:	8b 40 48             	mov    0x48(%eax),%eax
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	53                   	push   %ebx
  80141b:	50                   	push   %eax
  80141c:	68 09 2a 80 00       	push   $0x802a09
  801421:	e8 e0 ed ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142e:	eb da                	jmp    80140a <write+0x55>
		return -E_NOT_SUPP;
  801430:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801435:	eb d3                	jmp    80140a <write+0x55>

00801437 <seek>:

int
seek(int fdnum, off_t offset)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801440:	50                   	push   %eax
  801441:	ff 75 08             	pushl  0x8(%ebp)
  801444:	e8 2d fc ff ff       	call   801076 <fd_lookup>
  801449:	83 c4 08             	add    $0x8,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 0e                	js     80145e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801456:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 14             	sub    $0x14,%esp
  801467:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	53                   	push   %ebx
  80146f:	e8 02 fc ff ff       	call   801076 <fd_lookup>
  801474:	83 c4 08             	add    $0x8,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	78 37                	js     8014b2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801481:	50                   	push   %eax
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	ff 30                	pushl  (%eax)
  801487:	e8 40 fc ff ff       	call   8010cc <dev_lookup>
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 1f                	js     8014b2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801496:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149a:	74 1b                	je     8014b7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80149c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149f:	8b 52 18             	mov    0x18(%edx),%edx
  8014a2:	85 d2                	test   %edx,%edx
  8014a4:	74 32                	je     8014d8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a6:	83 ec 08             	sub    $0x8,%esp
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	50                   	push   %eax
  8014ad:	ff d2                	call   *%edx
  8014af:	83 c4 10             	add    $0x10,%esp
}
  8014b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014b7:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014bc:	8b 40 48             	mov    0x48(%eax),%eax
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	53                   	push   %ebx
  8014c3:	50                   	push   %eax
  8014c4:	68 cc 29 80 00       	push   $0x8029cc
  8014c9:	e8 38 ed ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d6:	eb da                	jmp    8014b2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014dd:	eb d3                	jmp    8014b2 <ftruncate+0x52>

008014df <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	53                   	push   %ebx
  8014e3:	83 ec 14             	sub    $0x14,%esp
  8014e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ec:	50                   	push   %eax
  8014ed:	ff 75 08             	pushl  0x8(%ebp)
  8014f0:	e8 81 fb ff ff       	call   801076 <fd_lookup>
  8014f5:	83 c4 08             	add    $0x8,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 4b                	js     801547 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014fc:	83 ec 08             	sub    $0x8,%esp
  8014ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801502:	50                   	push   %eax
  801503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801506:	ff 30                	pushl  (%eax)
  801508:	e8 bf fb ff ff       	call   8010cc <dev_lookup>
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	78 33                	js     801547 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801517:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80151b:	74 2f                	je     80154c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80151d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801520:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801527:	00 00 00 
	stat->st_isdir = 0;
  80152a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801531:	00 00 00 
	stat->st_dev = dev;
  801534:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	53                   	push   %ebx
  80153e:	ff 75 f0             	pushl  -0x10(%ebp)
  801541:	ff 50 14             	call   *0x14(%eax)
  801544:	83 c4 10             	add    $0x10,%esp
}
  801547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    
		return -E_NOT_SUPP;
  80154c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801551:	eb f4                	jmp    801547 <fstat+0x68>

00801553 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	56                   	push   %esi
  801557:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	6a 00                	push   $0x0
  80155d:	ff 75 08             	pushl  0x8(%ebp)
  801560:	e8 26 02 00 00       	call   80178b <open>
  801565:	89 c3                	mov    %eax,%ebx
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 1b                	js     801589 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	50                   	push   %eax
  801575:	e8 65 ff ff ff       	call   8014df <fstat>
  80157a:	89 c6                	mov    %eax,%esi
	close(fd);
  80157c:	89 1c 24             	mov    %ebx,(%esp)
  80157f:	e8 27 fc ff ff       	call   8011ab <close>
	return r;
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	89 f3                	mov    %esi,%ebx
}
  801589:	89 d8                	mov    %ebx,%eax
  80158b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    

00801592 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	56                   	push   %esi
  801596:	53                   	push   %ebx
  801597:	89 c6                	mov    %eax,%esi
  801599:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80159b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015a2:	74 27                	je     8015cb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015a4:	6a 07                	push   $0x7
  8015a6:	68 00 50 80 00       	push   $0x805000
  8015ab:	56                   	push   %esi
  8015ac:	ff 35 00 40 80 00    	pushl  0x804000
  8015b2:	e8 6c 0d 00 00       	call   802323 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015b7:	83 c4 0c             	add    $0xc,%esp
  8015ba:	6a 00                	push   $0x0
  8015bc:	53                   	push   %ebx
  8015bd:	6a 00                	push   $0x0
  8015bf:	e8 f6 0c 00 00       	call   8022ba <ipc_recv>
}
  8015c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c7:	5b                   	pop    %ebx
  8015c8:	5e                   	pop    %esi
  8015c9:	5d                   	pop    %ebp
  8015ca:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	6a 01                	push   $0x1
  8015d0:	e8 a7 0d 00 00       	call   80237c <ipc_find_env>
  8015d5:	a3 00 40 80 00       	mov    %eax,0x804000
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	eb c5                	jmp    8015a4 <fsipc+0x12>

008015df <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fd:	b8 02 00 00 00       	mov    $0x2,%eax
  801602:	e8 8b ff ff ff       	call   801592 <fsipc>
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <devfile_flush>:
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8b 40 0c             	mov    0xc(%eax),%eax
  801615:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	b8 06 00 00 00       	mov    $0x6,%eax
  801624:	e8 69 ff ff ff       	call   801592 <fsipc>
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <devfile_stat>:
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	53                   	push   %ebx
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8b 40 0c             	mov    0xc(%eax),%eax
  80163b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801640:	ba 00 00 00 00       	mov    $0x0,%edx
  801645:	b8 05 00 00 00       	mov    $0x5,%eax
  80164a:	e8 43 ff ff ff       	call   801592 <fsipc>
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 2c                	js     80167f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	68 00 50 80 00       	push   $0x805000
  80165b:	53                   	push   %ebx
  80165c:	e8 42 f2 ff ff       	call   8008a3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801661:	a1 80 50 80 00       	mov    0x805080,%eax
  801666:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80166c:	a1 84 50 80 00       	mov    0x805084,%eax
  801671:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <devfile_write>:
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	53                   	push   %ebx
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8b 40 0c             	mov    0xc(%eax),%eax
  801694:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801699:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80169f:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8016a5:	77 30                	ja     8016d7 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	53                   	push   %ebx
  8016ab:	ff 75 0c             	pushl  0xc(%ebp)
  8016ae:	68 08 50 80 00       	push   $0x805008
  8016b3:	e8 79 f3 ff ff       	call   800a31 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bd:	b8 04 00 00 00       	mov    $0x4,%eax
  8016c2:	e8 cb fe ff ff       	call   801592 <fsipc>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	78 04                	js     8016d2 <devfile_write+0x4e>
	assert(r <= n);
  8016ce:	39 d8                	cmp    %ebx,%eax
  8016d0:	77 1e                	ja     8016f0 <devfile_write+0x6c>
}
  8016d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8016d7:	68 3c 2a 80 00       	push   $0x802a3c
  8016dc:	68 69 2a 80 00       	push   $0x802a69
  8016e1:	68 94 00 00 00       	push   $0x94
  8016e6:	68 7e 2a 80 00       	push   $0x802a7e
  8016eb:	e8 84 0b 00 00       	call   802274 <_panic>
	assert(r <= n);
  8016f0:	68 89 2a 80 00       	push   $0x802a89
  8016f5:	68 69 2a 80 00       	push   $0x802a69
  8016fa:	68 98 00 00 00       	push   $0x98
  8016ff:	68 7e 2a 80 00       	push   $0x802a7e
  801704:	e8 6b 0b 00 00       	call   802274 <_panic>

00801709 <devfile_read>:
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
  80170e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 40 0c             	mov    0xc(%eax),%eax
  801717:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80171c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	b8 03 00 00 00       	mov    $0x3,%eax
  80172c:	e8 61 fe ff ff       	call   801592 <fsipc>
  801731:	89 c3                	mov    %eax,%ebx
  801733:	85 c0                	test   %eax,%eax
  801735:	78 1f                	js     801756 <devfile_read+0x4d>
	assert(r <= n);
  801737:	39 f0                	cmp    %esi,%eax
  801739:	77 24                	ja     80175f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80173b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801740:	7f 33                	jg     801775 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	50                   	push   %eax
  801746:	68 00 50 80 00       	push   $0x805000
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	e8 de f2 ff ff       	call   800a31 <memmove>
	return r;
  801753:	83 c4 10             	add    $0x10,%esp
}
  801756:	89 d8                	mov    %ebx,%eax
  801758:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5e                   	pop    %esi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    
	assert(r <= n);
  80175f:	68 89 2a 80 00       	push   $0x802a89
  801764:	68 69 2a 80 00       	push   $0x802a69
  801769:	6a 7c                	push   $0x7c
  80176b:	68 7e 2a 80 00       	push   $0x802a7e
  801770:	e8 ff 0a 00 00       	call   802274 <_panic>
	assert(r <= PGSIZE);
  801775:	68 90 2a 80 00       	push   $0x802a90
  80177a:	68 69 2a 80 00       	push   $0x802a69
  80177f:	6a 7d                	push   $0x7d
  801781:	68 7e 2a 80 00       	push   $0x802a7e
  801786:	e8 e9 0a 00 00       	call   802274 <_panic>

0080178b <open>:
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	83 ec 1c             	sub    $0x1c,%esp
  801793:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801796:	56                   	push   %esi
  801797:	e8 d0 f0 ff ff       	call   80086c <strlen>
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017a4:	7f 6c                	jg     801812 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ac:	50                   	push   %eax
  8017ad:	e8 75 f8 ff ff       	call   801027 <fd_alloc>
  8017b2:	89 c3                	mov    %eax,%ebx
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 3c                	js     8017f7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	56                   	push   %esi
  8017bf:	68 00 50 80 00       	push   $0x805000
  8017c4:	e8 da f0 ff ff       	call   8008a3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d9:	e8 b4 fd ff ff       	call   801592 <fsipc>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 19                	js     801800 <open+0x75>
	return fd2num(fd);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ed:	e8 0e f8 ff ff       	call   801000 <fd2num>
  8017f2:	89 c3                	mov    %eax,%ebx
  8017f4:	83 c4 10             	add    $0x10,%esp
}
  8017f7:	89 d8                	mov    %ebx,%eax
  8017f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5e                   	pop    %esi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    
		fd_close(fd, 0);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	6a 00                	push   $0x0
  801805:	ff 75 f4             	pushl  -0xc(%ebp)
  801808:	e8 15 f9 ff ff       	call   801122 <fd_close>
		return r;
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb e5                	jmp    8017f7 <open+0x6c>
		return -E_BAD_PATH;
  801812:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801817:	eb de                	jmp    8017f7 <open+0x6c>

00801819 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80181f:	ba 00 00 00 00       	mov    $0x0,%edx
  801824:	b8 08 00 00 00       	mov    $0x8,%eax
  801829:	e8 64 fd ff ff       	call   801592 <fsipc>
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801830:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801834:	7e 38                	jle    80186e <writebuf+0x3e>
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	53                   	push   %ebx
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80183f:	ff 70 04             	pushl  0x4(%eax)
  801842:	8d 40 10             	lea    0x10(%eax),%eax
  801845:	50                   	push   %eax
  801846:	ff 33                	pushl  (%ebx)
  801848:	e8 68 fb ff ff       	call   8013b5 <write>
		if (result > 0)
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	85 c0                	test   %eax,%eax
  801852:	7e 03                	jle    801857 <writebuf+0x27>
			b->result += result;
  801854:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801857:	39 43 04             	cmp    %eax,0x4(%ebx)
  80185a:	74 0d                	je     801869 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80185c:	85 c0                	test   %eax,%eax
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	0f 4f c2             	cmovg  %edx,%eax
  801866:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801869:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    
  80186e:	f3 c3                	repz ret 

00801870 <putch>:

static void
putch(int ch, void *thunk)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	53                   	push   %ebx
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80187a:	8b 53 04             	mov    0x4(%ebx),%edx
  80187d:	8d 42 01             	lea    0x1(%edx),%eax
  801880:	89 43 04             	mov    %eax,0x4(%ebx)
  801883:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801886:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80188a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80188f:	74 06                	je     801897 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801891:	83 c4 04             	add    $0x4,%esp
  801894:	5b                   	pop    %ebx
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    
		writebuf(b);
  801897:	89 d8                	mov    %ebx,%eax
  801899:	e8 92 ff ff ff       	call   801830 <writebuf>
		b->idx = 0;
  80189e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8018a5:	eb ea                	jmp    801891 <putch+0x21>

008018a7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018b9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018c0:	00 00 00 
	b.result = 0;
  8018c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018ca:	00 00 00 
	b.error = 1;
  8018cd:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018d4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018e3:	50                   	push   %eax
  8018e4:	68 70 18 80 00       	push   $0x801870
  8018e9:	e8 15 ea ff ff       	call   800303 <vprintfmt>
	if (b.idx > 0)
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8018f8:	7f 11                	jg     80190b <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8018fa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801900:	85 c0                	test   %eax,%eax
  801902:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    
		writebuf(&b);
  80190b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801911:	e8 1a ff ff ff       	call   801830 <writebuf>
  801916:	eb e2                	jmp    8018fa <vfprintf+0x53>

00801918 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80191e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801921:	50                   	push   %eax
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	e8 7a ff ff ff       	call   8018a7 <vfprintf>
	va_end(ap);

	return cnt;
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <printf>:

int
printf(const char *fmt, ...)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801935:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801938:	50                   	push   %eax
  801939:	ff 75 08             	pushl  0x8(%ebp)
  80193c:	6a 01                	push   $0x1
  80193e:	e8 64 ff ff ff       	call   8018a7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	56                   	push   %esi
  801949:	53                   	push   %ebx
  80194a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	e8 b8 f6 ff ff       	call   801010 <fd2data>
  801958:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80195a:	83 c4 08             	add    $0x8,%esp
  80195d:	68 9c 2a 80 00       	push   $0x802a9c
  801962:	53                   	push   %ebx
  801963:	e8 3b ef ff ff       	call   8008a3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801968:	8b 46 04             	mov    0x4(%esi),%eax
  80196b:	2b 06                	sub    (%esi),%eax
  80196d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801973:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80197a:	00 00 00 
	stat->st_dev = &devpipe;
  80197d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801984:	30 80 00 
	return 0;
}
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
  80198c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5d                   	pop    %ebp
  801992:	c3                   	ret    

00801993 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	53                   	push   %ebx
  801997:	83 ec 0c             	sub    $0xc,%esp
  80199a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80199d:	53                   	push   %ebx
  80199e:	6a 00                	push   $0x0
  8019a0:	e8 7c f3 ff ff       	call   800d21 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019a5:	89 1c 24             	mov    %ebx,(%esp)
  8019a8:	e8 63 f6 ff ff       	call   801010 <fd2data>
  8019ad:	83 c4 08             	add    $0x8,%esp
  8019b0:	50                   	push   %eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	e8 69 f3 ff ff       	call   800d21 <sys_page_unmap>
}
  8019b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <_pipeisclosed>:
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	57                   	push   %edi
  8019c1:	56                   	push   %esi
  8019c2:	53                   	push   %ebx
  8019c3:	83 ec 1c             	sub    $0x1c,%esp
  8019c6:	89 c7                	mov    %eax,%edi
  8019c8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8019cf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019d2:	83 ec 0c             	sub    $0xc,%esp
  8019d5:	57                   	push   %edi
  8019d6:	e8 da 09 00 00       	call   8023b5 <pageref>
  8019db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019de:	89 34 24             	mov    %esi,(%esp)
  8019e1:	e8 cf 09 00 00       	call   8023b5 <pageref>
		nn = thisenv->env_runs;
  8019e6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8019ec:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	39 cb                	cmp    %ecx,%ebx
  8019f4:	74 1b                	je     801a11 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019f6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019f9:	75 cf                	jne    8019ca <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019fb:	8b 42 58             	mov    0x58(%edx),%eax
  8019fe:	6a 01                	push   $0x1
  801a00:	50                   	push   %eax
  801a01:	53                   	push   %ebx
  801a02:	68 a3 2a 80 00       	push   $0x802aa3
  801a07:	e8 fa e7 ff ff       	call   800206 <cprintf>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	eb b9                	jmp    8019ca <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a11:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a14:	0f 94 c0             	sete   %al
  801a17:	0f b6 c0             	movzbl %al,%eax
}
  801a1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5e                   	pop    %esi
  801a1f:	5f                   	pop    %edi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    

00801a22 <devpipe_write>:
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	57                   	push   %edi
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	83 ec 28             	sub    $0x28,%esp
  801a2b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a2e:	56                   	push   %esi
  801a2f:	e8 dc f5 ff ff       	call   801010 <fd2data>
  801a34:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a41:	74 4f                	je     801a92 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a43:	8b 43 04             	mov    0x4(%ebx),%eax
  801a46:	8b 0b                	mov    (%ebx),%ecx
  801a48:	8d 51 20             	lea    0x20(%ecx),%edx
  801a4b:	39 d0                	cmp    %edx,%eax
  801a4d:	72 14                	jb     801a63 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a4f:	89 da                	mov    %ebx,%edx
  801a51:	89 f0                	mov    %esi,%eax
  801a53:	e8 65 ff ff ff       	call   8019bd <_pipeisclosed>
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	75 3a                	jne    801a96 <devpipe_write+0x74>
			sys_yield();
  801a5c:	e8 1c f2 ff ff       	call   800c7d <sys_yield>
  801a61:	eb e0                	jmp    801a43 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a66:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a6a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a6d:	89 c2                	mov    %eax,%edx
  801a6f:	c1 fa 1f             	sar    $0x1f,%edx
  801a72:	89 d1                	mov    %edx,%ecx
  801a74:	c1 e9 1b             	shr    $0x1b,%ecx
  801a77:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a7a:	83 e2 1f             	and    $0x1f,%edx
  801a7d:	29 ca                	sub    %ecx,%edx
  801a7f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a83:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a87:	83 c0 01             	add    $0x1,%eax
  801a8a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a8d:	83 c7 01             	add    $0x1,%edi
  801a90:	eb ac                	jmp    801a3e <devpipe_write+0x1c>
	return i;
  801a92:	89 f8                	mov    %edi,%eax
  801a94:	eb 05                	jmp    801a9b <devpipe_write+0x79>
				return 0;
  801a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a9e:	5b                   	pop    %ebx
  801a9f:	5e                   	pop    %esi
  801aa0:	5f                   	pop    %edi
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    

00801aa3 <devpipe_read>:
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	57                   	push   %edi
  801aa7:	56                   	push   %esi
  801aa8:	53                   	push   %ebx
  801aa9:	83 ec 18             	sub    $0x18,%esp
  801aac:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801aaf:	57                   	push   %edi
  801ab0:	e8 5b f5 ff ff       	call   801010 <fd2data>
  801ab5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	be 00 00 00 00       	mov    $0x0,%esi
  801abf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ac2:	74 47                	je     801b0b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801ac4:	8b 03                	mov    (%ebx),%eax
  801ac6:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ac9:	75 22                	jne    801aed <devpipe_read+0x4a>
			if (i > 0)
  801acb:	85 f6                	test   %esi,%esi
  801acd:	75 14                	jne    801ae3 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801acf:	89 da                	mov    %ebx,%edx
  801ad1:	89 f8                	mov    %edi,%eax
  801ad3:	e8 e5 fe ff ff       	call   8019bd <_pipeisclosed>
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	75 33                	jne    801b0f <devpipe_read+0x6c>
			sys_yield();
  801adc:	e8 9c f1 ff ff       	call   800c7d <sys_yield>
  801ae1:	eb e1                	jmp    801ac4 <devpipe_read+0x21>
				return i;
  801ae3:	89 f0                	mov    %esi,%eax
}
  801ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae8:	5b                   	pop    %ebx
  801ae9:	5e                   	pop    %esi
  801aea:	5f                   	pop    %edi
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801aed:	99                   	cltd   
  801aee:	c1 ea 1b             	shr    $0x1b,%edx
  801af1:	01 d0                	add    %edx,%eax
  801af3:	83 e0 1f             	and    $0x1f,%eax
  801af6:	29 d0                	sub    %edx,%eax
  801af8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801afd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b00:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b03:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b06:	83 c6 01             	add    $0x1,%esi
  801b09:	eb b4                	jmp    801abf <devpipe_read+0x1c>
	return i;
  801b0b:	89 f0                	mov    %esi,%eax
  801b0d:	eb d6                	jmp    801ae5 <devpipe_read+0x42>
				return 0;
  801b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b14:	eb cf                	jmp    801ae5 <devpipe_read+0x42>

00801b16 <pipe>:
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	56                   	push   %esi
  801b1a:	53                   	push   %ebx
  801b1b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b21:	50                   	push   %eax
  801b22:	e8 00 f5 ff ff       	call   801027 <fd_alloc>
  801b27:	89 c3                	mov    %eax,%ebx
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	78 5b                	js     801b8b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b30:	83 ec 04             	sub    $0x4,%esp
  801b33:	68 07 04 00 00       	push   $0x407
  801b38:	ff 75 f4             	pushl  -0xc(%ebp)
  801b3b:	6a 00                	push   $0x0
  801b3d:	e8 5a f1 ff ff       	call   800c9c <sys_page_alloc>
  801b42:	89 c3                	mov    %eax,%ebx
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	85 c0                	test   %eax,%eax
  801b49:	78 40                	js     801b8b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801b4b:	83 ec 0c             	sub    $0xc,%esp
  801b4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b51:	50                   	push   %eax
  801b52:	e8 d0 f4 ff ff       	call   801027 <fd_alloc>
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	78 1b                	js     801b7b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	68 07 04 00 00       	push   $0x407
  801b68:	ff 75 f0             	pushl  -0x10(%ebp)
  801b6b:	6a 00                	push   $0x0
  801b6d:	e8 2a f1 ff ff       	call   800c9c <sys_page_alloc>
  801b72:	89 c3                	mov    %eax,%ebx
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	85 c0                	test   %eax,%eax
  801b79:	79 19                	jns    801b94 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801b7b:	83 ec 08             	sub    $0x8,%esp
  801b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b81:	6a 00                	push   $0x0
  801b83:	e8 99 f1 ff ff       	call   800d21 <sys_page_unmap>
  801b88:	83 c4 10             	add    $0x10,%esp
}
  801b8b:	89 d8                	mov    %ebx,%eax
  801b8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b90:	5b                   	pop    %ebx
  801b91:	5e                   	pop    %esi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
	va = fd2data(fd0);
  801b94:	83 ec 0c             	sub    $0xc,%esp
  801b97:	ff 75 f4             	pushl  -0xc(%ebp)
  801b9a:	e8 71 f4 ff ff       	call   801010 <fd2data>
  801b9f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ba1:	83 c4 0c             	add    $0xc,%esp
  801ba4:	68 07 04 00 00       	push   $0x407
  801ba9:	50                   	push   %eax
  801baa:	6a 00                	push   $0x0
  801bac:	e8 eb f0 ff ff       	call   800c9c <sys_page_alloc>
  801bb1:	89 c3                	mov    %eax,%ebx
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	0f 88 8c 00 00 00    	js     801c4a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	ff 75 f0             	pushl  -0x10(%ebp)
  801bc4:	e8 47 f4 ff ff       	call   801010 <fd2data>
  801bc9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bd0:	50                   	push   %eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	56                   	push   %esi
  801bd4:	6a 00                	push   $0x0
  801bd6:	e8 04 f1 ff ff       	call   800cdf <sys_page_map>
  801bdb:	89 c3                	mov    %eax,%ebx
  801bdd:	83 c4 20             	add    $0x20,%esp
  801be0:	85 c0                	test   %eax,%eax
  801be2:	78 58                	js     801c3c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c02:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c07:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 f4             	pushl  -0xc(%ebp)
  801c14:	e8 e7 f3 ff ff       	call   801000 <fd2num>
  801c19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c1c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c1e:	83 c4 04             	add    $0x4,%esp
  801c21:	ff 75 f0             	pushl  -0x10(%ebp)
  801c24:	e8 d7 f3 ff ff       	call   801000 <fd2num>
  801c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c37:	e9 4f ff ff ff       	jmp    801b8b <pipe+0x75>
	sys_page_unmap(0, va);
  801c3c:	83 ec 08             	sub    $0x8,%esp
  801c3f:	56                   	push   %esi
  801c40:	6a 00                	push   $0x0
  801c42:	e8 da f0 ff ff       	call   800d21 <sys_page_unmap>
  801c47:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c4a:	83 ec 08             	sub    $0x8,%esp
  801c4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c50:	6a 00                	push   $0x0
  801c52:	e8 ca f0 ff ff       	call   800d21 <sys_page_unmap>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	e9 1c ff ff ff       	jmp    801b7b <pipe+0x65>

00801c5f <pipeisclosed>:
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c68:	50                   	push   %eax
  801c69:	ff 75 08             	pushl  0x8(%ebp)
  801c6c:	e8 05 f4 ff ff       	call   801076 <fd_lookup>
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	85 c0                	test   %eax,%eax
  801c76:	78 18                	js     801c90 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c78:	83 ec 0c             	sub    $0xc,%esp
  801c7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7e:	e8 8d f3 ff ff       	call   801010 <fd2data>
	return _pipeisclosed(fd, p);
  801c83:	89 c2                	mov    %eax,%edx
  801c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c88:	e8 30 fd ff ff       	call   8019bd <_pipeisclosed>
  801c8d:	83 c4 10             	add    $0x10,%esp
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c98:	68 bb 2a 80 00       	push   $0x802abb
  801c9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ca0:	e8 fe eb ff ff       	call   8008a3 <strcpy>
	return 0;
}
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <devsock_close>:
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 10             	sub    $0x10,%esp
  801cb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cb6:	53                   	push   %ebx
  801cb7:	e8 f9 06 00 00       	call   8023b5 <pageref>
  801cbc:	83 c4 10             	add    $0x10,%esp
		return 0;
  801cbf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801cc4:	83 f8 01             	cmp    $0x1,%eax
  801cc7:	74 07                	je     801cd0 <devsock_close+0x24>
}
  801cc9:	89 d0                	mov    %edx,%eax
  801ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cd0:	83 ec 0c             	sub    $0xc,%esp
  801cd3:	ff 73 0c             	pushl  0xc(%ebx)
  801cd6:	e8 b7 02 00 00       	call   801f92 <nsipc_close>
  801cdb:	89 c2                	mov    %eax,%edx
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	eb e7                	jmp    801cc9 <devsock_close+0x1d>

00801ce2 <devsock_write>:
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 10             	pushl  0x10(%ebp)
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	ff 70 0c             	pushl  0xc(%eax)
  801cf6:	e8 74 03 00 00       	call   80206f <nsipc_send>
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <devsock_read>:
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	ff 75 10             	pushl  0x10(%ebp)
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	ff 70 0c             	pushl  0xc(%eax)
  801d11:	e8 ed 02 00 00       	call   802003 <nsipc_recv>
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <fd2sockid>:
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d1e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	e8 4e f3 ff ff       	call   801076 <fd_lookup>
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	78 10                	js     801d3f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d38:	39 08                	cmp    %ecx,(%eax)
  801d3a:	75 05                	jne    801d41 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d3c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    
		return -E_NOT_SUPP;
  801d41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d46:	eb f7                	jmp    801d3f <fd2sockid+0x27>

00801d48 <alloc_sockfd>:
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	56                   	push   %esi
  801d4c:	53                   	push   %ebx
  801d4d:	83 ec 1c             	sub    $0x1c,%esp
  801d50:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d55:	50                   	push   %eax
  801d56:	e8 cc f2 ff ff       	call   801027 <fd_alloc>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	85 c0                	test   %eax,%eax
  801d62:	78 43                	js     801da7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d64:	83 ec 04             	sub    $0x4,%esp
  801d67:	68 07 04 00 00       	push   $0x407
  801d6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6f:	6a 00                	push   $0x0
  801d71:	e8 26 ef ff ff       	call   800c9c <sys_page_alloc>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 28                	js     801da7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d88:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d94:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	50                   	push   %eax
  801d9b:	e8 60 f2 ff ff       	call   801000 <fd2num>
  801da0:	89 c3                	mov    %eax,%ebx
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	eb 0c                	jmp    801db3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	56                   	push   %esi
  801dab:	e8 e2 01 00 00       	call   801f92 <nsipc_close>
		return r;
  801db0:	83 c4 10             	add    $0x10,%esp
}
  801db3:	89 d8                	mov    %ebx,%eax
  801db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    

00801dbc <accept>:
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	e8 4e ff ff ff       	call   801d18 <fd2sockid>
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 1b                	js     801de9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dce:	83 ec 04             	sub    $0x4,%esp
  801dd1:	ff 75 10             	pushl  0x10(%ebp)
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	50                   	push   %eax
  801dd8:	e8 0e 01 00 00       	call   801eeb <nsipc_accept>
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	85 c0                	test   %eax,%eax
  801de2:	78 05                	js     801de9 <accept+0x2d>
	return alloc_sockfd(r);
  801de4:	e8 5f ff ff ff       	call   801d48 <alloc_sockfd>
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <bind>:
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	e8 1f ff ff ff       	call   801d18 <fd2sockid>
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 12                	js     801e0f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	ff 75 10             	pushl  0x10(%ebp)
  801e03:	ff 75 0c             	pushl  0xc(%ebp)
  801e06:	50                   	push   %eax
  801e07:	e8 2f 01 00 00       	call   801f3b <nsipc_bind>
  801e0c:	83 c4 10             	add    $0x10,%esp
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <shutdown>:
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	e8 f9 fe ff ff       	call   801d18 <fd2sockid>
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 0f                	js     801e32 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e23:	83 ec 08             	sub    $0x8,%esp
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	50                   	push   %eax
  801e2a:	e8 41 01 00 00       	call   801f70 <nsipc_shutdown>
  801e2f:	83 c4 10             	add    $0x10,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <connect>:
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	e8 d6 fe ff ff       	call   801d18 <fd2sockid>
  801e42:	85 c0                	test   %eax,%eax
  801e44:	78 12                	js     801e58 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e46:	83 ec 04             	sub    $0x4,%esp
  801e49:	ff 75 10             	pushl  0x10(%ebp)
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	50                   	push   %eax
  801e50:	e8 57 01 00 00       	call   801fac <nsipc_connect>
  801e55:	83 c4 10             	add    $0x10,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <listen>:
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	e8 b0 fe ff ff       	call   801d18 <fd2sockid>
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 0f                	js     801e7b <listen+0x21>
	return nsipc_listen(r, backlog);
  801e6c:	83 ec 08             	sub    $0x8,%esp
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	50                   	push   %eax
  801e73:	e8 69 01 00 00       	call   801fe1 <nsipc_listen>
  801e78:	83 c4 10             	add    $0x10,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <socket>:

int
socket(int domain, int type, int protocol)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e83:	ff 75 10             	pushl  0x10(%ebp)
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	e8 3c 02 00 00       	call   8020cd <nsipc_socket>
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	85 c0                	test   %eax,%eax
  801e96:	78 05                	js     801e9d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e98:	e8 ab fe ff ff       	call   801d48 <alloc_sockfd>
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	53                   	push   %ebx
  801ea3:	83 ec 04             	sub    $0x4,%esp
  801ea6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ea8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801eaf:	74 26                	je     801ed7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801eb1:	6a 07                	push   $0x7
  801eb3:	68 00 60 80 00       	push   $0x806000
  801eb8:	53                   	push   %ebx
  801eb9:	ff 35 04 40 80 00    	pushl  0x804004
  801ebf:	e8 5f 04 00 00       	call   802323 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ec4:	83 c4 0c             	add    $0xc,%esp
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	e8 e8 03 00 00       	call   8022ba <ipc_recv>
}
  801ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ed7:	83 ec 0c             	sub    $0xc,%esp
  801eda:	6a 02                	push   $0x2
  801edc:	e8 9b 04 00 00       	call   80237c <ipc_find_env>
  801ee1:	a3 04 40 80 00       	mov    %eax,0x804004
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	eb c6                	jmp    801eb1 <nsipc+0x12>

00801eeb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801efb:	8b 06                	mov    (%esi),%eax
  801efd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f02:	b8 01 00 00 00       	mov    $0x1,%eax
  801f07:	e8 93 ff ff ff       	call   801e9f <nsipc>
  801f0c:	89 c3                	mov    %eax,%ebx
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	78 20                	js     801f32 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	ff 35 10 60 80 00    	pushl  0x806010
  801f1b:	68 00 60 80 00       	push   $0x806000
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	e8 09 eb ff ff       	call   800a31 <memmove>
		*addrlen = ret->ret_addrlen;
  801f28:	a1 10 60 80 00       	mov    0x806010,%eax
  801f2d:	89 06                	mov    %eax,(%esi)
  801f2f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801f32:	89 d8                	mov    %ebx,%eax
  801f34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f4d:	53                   	push   %ebx
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	68 04 60 80 00       	push   $0x806004
  801f56:	e8 d6 ea ff ff       	call   800a31 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f5b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f61:	b8 02 00 00 00       	mov    $0x2,%eax
  801f66:	e8 34 ff ff ff       	call   801e9f <nsipc>
}
  801f6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f86:	b8 03 00 00 00       	mov    $0x3,%eax
  801f8b:	e8 0f ff ff ff       	call   801e9f <nsipc>
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <nsipc_close>:

int
nsipc_close(int s)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801fa0:	b8 04 00 00 00       	mov    $0x4,%eax
  801fa5:	e8 f5 fe ff ff       	call   801e9f <nsipc>
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	53                   	push   %ebx
  801fb0:	83 ec 08             	sub    $0x8,%esp
  801fb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fbe:	53                   	push   %ebx
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	68 04 60 80 00       	push   $0x806004
  801fc7:	e8 65 ea ff ff       	call   800a31 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fcc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801fd2:	b8 05 00 00 00       	mov    $0x5,%eax
  801fd7:	e8 c3 fe ff ff       	call   801e9f <nsipc>
}
  801fdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ff7:	b8 06 00 00 00       	mov    $0x6,%eax
  801ffc:	e8 9e fe ff ff       	call   801e9f <nsipc>
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	56                   	push   %esi
  802007:	53                   	push   %ebx
  802008:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802013:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802019:	8b 45 14             	mov    0x14(%ebp),%eax
  80201c:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802021:	b8 07 00 00 00       	mov    $0x7,%eax
  802026:	e8 74 fe ff ff       	call   801e9f <nsipc>
  80202b:	89 c3                	mov    %eax,%ebx
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 1f                	js     802050 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802031:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802036:	7f 21                	jg     802059 <nsipc_recv+0x56>
  802038:	39 c6                	cmp    %eax,%esi
  80203a:	7c 1d                	jl     802059 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80203c:	83 ec 04             	sub    $0x4,%esp
  80203f:	50                   	push   %eax
  802040:	68 00 60 80 00       	push   $0x806000
  802045:	ff 75 0c             	pushl  0xc(%ebp)
  802048:	e8 e4 e9 ff ff       	call   800a31 <memmove>
  80204d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802050:	89 d8                	mov    %ebx,%eax
  802052:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802055:	5b                   	pop    %ebx
  802056:	5e                   	pop    %esi
  802057:	5d                   	pop    %ebp
  802058:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802059:	68 c7 2a 80 00       	push   $0x802ac7
  80205e:	68 69 2a 80 00       	push   $0x802a69
  802063:	6a 62                	push   $0x62
  802065:	68 dc 2a 80 00       	push   $0x802adc
  80206a:	e8 05 02 00 00       	call   802274 <_panic>

0080206f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	53                   	push   %ebx
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802081:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802087:	7f 2e                	jg     8020b7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	53                   	push   %ebx
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	68 0c 60 80 00       	push   $0x80600c
  802095:	e8 97 e9 ff ff       	call   800a31 <memmove>
	nsipcbuf.send.req_size = size;
  80209a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8020a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8020a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8020ad:	e8 ed fd ff ff       	call   801e9f <nsipc>
}
  8020b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    
	assert(size < 1600);
  8020b7:	68 e8 2a 80 00       	push   $0x802ae8
  8020bc:	68 69 2a 80 00       	push   $0x802a69
  8020c1:	6a 6d                	push   $0x6d
  8020c3:	68 dc 2a 80 00       	push   $0x802adc
  8020c8:	e8 a7 01 00 00       	call   802274 <_panic>

008020cd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020de:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020eb:	b8 09 00 00 00       	mov    $0x9,%eax
  8020f0:	e8 aa fd ff ff       	call   801e9f <nsipc>
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    

00802101 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802107:	68 f4 2a 80 00       	push   $0x802af4
  80210c:	ff 75 0c             	pushl  0xc(%ebp)
  80210f:	e8 8f e7 ff ff       	call   8008a3 <strcpy>
	return 0;
}
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <devcons_write>:
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	57                   	push   %edi
  80211f:	56                   	push   %esi
  802120:	53                   	push   %ebx
  802121:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802127:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80212c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802132:	eb 2f                	jmp    802163 <devcons_write+0x48>
		m = n - tot;
  802134:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802137:	29 f3                	sub    %esi,%ebx
  802139:	83 fb 7f             	cmp    $0x7f,%ebx
  80213c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802141:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	53                   	push   %ebx
  802148:	89 f0                	mov    %esi,%eax
  80214a:	03 45 0c             	add    0xc(%ebp),%eax
  80214d:	50                   	push   %eax
  80214e:	57                   	push   %edi
  80214f:	e8 dd e8 ff ff       	call   800a31 <memmove>
		sys_cputs(buf, m);
  802154:	83 c4 08             	add    $0x8,%esp
  802157:	53                   	push   %ebx
  802158:	57                   	push   %edi
  802159:	e8 82 ea ff ff       	call   800be0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80215e:	01 de                	add    %ebx,%esi
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	3b 75 10             	cmp    0x10(%ebp),%esi
  802166:	72 cc                	jb     802134 <devcons_write+0x19>
}
  802168:	89 f0                	mov    %esi,%eax
  80216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5e                   	pop    %esi
  80216f:	5f                   	pop    %edi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    

00802172 <devcons_read>:
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 08             	sub    $0x8,%esp
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80217d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802181:	75 07                	jne    80218a <devcons_read+0x18>
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    
		sys_yield();
  802185:	e8 f3 ea ff ff       	call   800c7d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80218a:	e8 6f ea ff ff       	call   800bfe <sys_cgetc>
  80218f:	85 c0                	test   %eax,%eax
  802191:	74 f2                	je     802185 <devcons_read+0x13>
	if (c < 0)
  802193:	85 c0                	test   %eax,%eax
  802195:	78 ec                	js     802183 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802197:	83 f8 04             	cmp    $0x4,%eax
  80219a:	74 0c                	je     8021a8 <devcons_read+0x36>
	*(char*)vbuf = c;
  80219c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219f:	88 02                	mov    %al,(%edx)
	return 1;
  8021a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a6:	eb db                	jmp    802183 <devcons_read+0x11>
		return 0;
  8021a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ad:	eb d4                	jmp    802183 <devcons_read+0x11>

008021af <cputchar>:
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021bb:	6a 01                	push   $0x1
  8021bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c0:	50                   	push   %eax
  8021c1:	e8 1a ea ff ff       	call   800be0 <sys_cputs>
}
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <getchar>:
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021d1:	6a 01                	push   $0x1
  8021d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d6:	50                   	push   %eax
  8021d7:	6a 00                	push   $0x0
  8021d9:	e8 09 f1 ff ff       	call   8012e7 <read>
	if (r < 0)
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	78 08                	js     8021ed <getchar+0x22>
	if (r < 1)
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	7e 06                	jle    8021ef <getchar+0x24>
	return c;
  8021e9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    
		return -E_EOF;
  8021ef:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021f4:	eb f7                	jmp    8021ed <getchar+0x22>

008021f6 <iscons>:
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ff:	50                   	push   %eax
  802200:	ff 75 08             	pushl  0x8(%ebp)
  802203:	e8 6e ee ff ff       	call   801076 <fd_lookup>
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	85 c0                	test   %eax,%eax
  80220d:	78 11                	js     802220 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802218:	39 10                	cmp    %edx,(%eax)
  80221a:	0f 94 c0             	sete   %al
  80221d:	0f b6 c0             	movzbl %al,%eax
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <opencons>:
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802228:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80222b:	50                   	push   %eax
  80222c:	e8 f6 ed ff ff       	call   801027 <fd_alloc>
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	85 c0                	test   %eax,%eax
  802236:	78 3a                	js     802272 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802238:	83 ec 04             	sub    $0x4,%esp
  80223b:	68 07 04 00 00       	push   $0x407
  802240:	ff 75 f4             	pushl  -0xc(%ebp)
  802243:	6a 00                	push   $0x0
  802245:	e8 52 ea ff ff       	call   800c9c <sys_page_alloc>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	78 21                	js     802272 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80225a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802266:	83 ec 0c             	sub    $0xc,%esp
  802269:	50                   	push   %eax
  80226a:	e8 91 ed ff ff       	call   801000 <fd2num>
  80226f:	83 c4 10             	add    $0x10,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	56                   	push   %esi
  802278:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802279:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80227c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802282:	e8 d7 e9 ff ff       	call   800c5e <sys_getenvid>
  802287:	83 ec 0c             	sub    $0xc,%esp
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	ff 75 08             	pushl  0x8(%ebp)
  802290:	56                   	push   %esi
  802291:	50                   	push   %eax
  802292:	68 00 2b 80 00       	push   $0x802b00
  802297:	e8 6a df ff ff       	call   800206 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80229c:	83 c4 18             	add    $0x18,%esp
  80229f:	53                   	push   %ebx
  8022a0:	ff 75 10             	pushl  0x10(%ebp)
  8022a3:	e8 0d df ff ff       	call   8001b5 <vcprintf>
	cprintf("\n");
  8022a8:	c7 04 24 50 26 80 00 	movl   $0x802650,(%esp)
  8022af:	e8 52 df ff ff       	call   800206 <cprintf>
  8022b4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022b7:	cc                   	int3   
  8022b8:	eb fd                	jmp    8022b7 <_panic+0x43>

008022ba <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	56                   	push   %esi
  8022be:	53                   	push   %ebx
  8022bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8022c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8022c8:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8022ca:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022cf:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8022d2:	83 ec 0c             	sub    $0xc,%esp
  8022d5:	50                   	push   %eax
  8022d6:	e8 71 eb ff ff       	call   800e4c <sys_ipc_recv>
  8022db:	83 c4 10             	add    $0x10,%esp
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	78 2b                	js     80230d <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8022e2:	85 f6                	test   %esi,%esi
  8022e4:	74 0a                	je     8022f0 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8022e6:	a1 08 40 80 00       	mov    0x804008,%eax
  8022eb:	8b 40 74             	mov    0x74(%eax),%eax
  8022ee:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8022f0:	85 db                	test   %ebx,%ebx
  8022f2:	74 0a                	je     8022fe <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8022f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f9:	8b 40 78             	mov    0x78(%eax),%eax
  8022fc:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022fe:	a1 08 40 80 00       	mov    0x804008,%eax
  802303:	8b 40 70             	mov    0x70(%eax),%eax
}
  802306:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802309:	5b                   	pop    %ebx
  80230a:	5e                   	pop    %esi
  80230b:	5d                   	pop    %ebp
  80230c:	c3                   	ret    
	    if (from_env_store != NULL) {
  80230d:	85 f6                	test   %esi,%esi
  80230f:	74 06                	je     802317 <ipc_recv+0x5d>
	        *from_env_store = 0;
  802311:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802317:	85 db                	test   %ebx,%ebx
  802319:	74 eb                	je     802306 <ipc_recv+0x4c>
	        *perm_store = 0;
  80231b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802321:	eb e3                	jmp    802306 <ipc_recv+0x4c>

00802323 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	57                   	push   %edi
  802327:	56                   	push   %esi
  802328:	53                   	push   %ebx
  802329:	83 ec 0c             	sub    $0xc,%esp
  80232c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80232f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802332:	85 f6                	test   %esi,%esi
  802334:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802339:	0f 44 f0             	cmove  %eax,%esi
  80233c:	eb 09                	jmp    802347 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80233e:	e8 3a e9 ff ff       	call   800c7d <sys_yield>
	} while(r != 0);
  802343:	85 db                	test   %ebx,%ebx
  802345:	74 2d                	je     802374 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802347:	ff 75 14             	pushl  0x14(%ebp)
  80234a:	56                   	push   %esi
  80234b:	ff 75 0c             	pushl  0xc(%ebp)
  80234e:	57                   	push   %edi
  80234f:	e8 d5 ea ff ff       	call   800e29 <sys_ipc_try_send>
  802354:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802356:	83 c4 10             	add    $0x10,%esp
  802359:	85 c0                	test   %eax,%eax
  80235b:	79 e1                	jns    80233e <ipc_send+0x1b>
  80235d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802360:	74 dc                	je     80233e <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802362:	50                   	push   %eax
  802363:	68 24 2b 80 00       	push   $0x802b24
  802368:	6a 45                	push   $0x45
  80236a:	68 31 2b 80 00       	push   $0x802b31
  80236f:	e8 00 ff ff ff       	call   802274 <_panic>
}
  802374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5f                   	pop    %edi
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    

0080237c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802382:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802387:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80238a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802390:	8b 52 50             	mov    0x50(%edx),%edx
  802393:	39 ca                	cmp    %ecx,%edx
  802395:	74 11                	je     8023a8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802397:	83 c0 01             	add    $0x1,%eax
  80239a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80239f:	75 e6                	jne    802387 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	eb 0b                	jmp    8023b3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8023a8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023ab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023b0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    

008023b5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023bb:	89 d0                	mov    %edx,%eax
  8023bd:	c1 e8 16             	shr    $0x16,%eax
  8023c0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023cc:	f6 c1 01             	test   $0x1,%cl
  8023cf:	74 1d                	je     8023ee <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023d1:	c1 ea 0c             	shr    $0xc,%edx
  8023d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023db:	f6 c2 01             	test   $0x1,%dl
  8023de:	74 0e                	je     8023ee <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023e0:	c1 ea 0c             	shr    $0xc,%edx
  8023e3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023ea:	ef 
  8023eb:	0f b7 c0             	movzwl %ax,%eax
}
  8023ee:	5d                   	pop    %ebp
  8023ef:	c3                   	ret    

008023f0 <__udivdi3>:
  8023f0:	55                   	push   %ebp
  8023f1:	57                   	push   %edi
  8023f2:	56                   	push   %esi
  8023f3:	53                   	push   %ebx
  8023f4:	83 ec 1c             	sub    $0x1c,%esp
  8023f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802403:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802407:	85 d2                	test   %edx,%edx
  802409:	75 35                	jne    802440 <__udivdi3+0x50>
  80240b:	39 f3                	cmp    %esi,%ebx
  80240d:	0f 87 bd 00 00 00    	ja     8024d0 <__udivdi3+0xe0>
  802413:	85 db                	test   %ebx,%ebx
  802415:	89 d9                	mov    %ebx,%ecx
  802417:	75 0b                	jne    802424 <__udivdi3+0x34>
  802419:	b8 01 00 00 00       	mov    $0x1,%eax
  80241e:	31 d2                	xor    %edx,%edx
  802420:	f7 f3                	div    %ebx
  802422:	89 c1                	mov    %eax,%ecx
  802424:	31 d2                	xor    %edx,%edx
  802426:	89 f0                	mov    %esi,%eax
  802428:	f7 f1                	div    %ecx
  80242a:	89 c6                	mov    %eax,%esi
  80242c:	89 e8                	mov    %ebp,%eax
  80242e:	89 f7                	mov    %esi,%edi
  802430:	f7 f1                	div    %ecx
  802432:	89 fa                	mov    %edi,%edx
  802434:	83 c4 1c             	add    $0x1c,%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5f                   	pop    %edi
  80243a:	5d                   	pop    %ebp
  80243b:	c3                   	ret    
  80243c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802440:	39 f2                	cmp    %esi,%edx
  802442:	77 7c                	ja     8024c0 <__udivdi3+0xd0>
  802444:	0f bd fa             	bsr    %edx,%edi
  802447:	83 f7 1f             	xor    $0x1f,%edi
  80244a:	0f 84 98 00 00 00    	je     8024e8 <__udivdi3+0xf8>
  802450:	89 f9                	mov    %edi,%ecx
  802452:	b8 20 00 00 00       	mov    $0x20,%eax
  802457:	29 f8                	sub    %edi,%eax
  802459:	d3 e2                	shl    %cl,%edx
  80245b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80245f:	89 c1                	mov    %eax,%ecx
  802461:	89 da                	mov    %ebx,%edx
  802463:	d3 ea                	shr    %cl,%edx
  802465:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802469:	09 d1                	or     %edx,%ecx
  80246b:	89 f2                	mov    %esi,%edx
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 f9                	mov    %edi,%ecx
  802473:	d3 e3                	shl    %cl,%ebx
  802475:	89 c1                	mov    %eax,%ecx
  802477:	d3 ea                	shr    %cl,%edx
  802479:	89 f9                	mov    %edi,%ecx
  80247b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80247f:	d3 e6                	shl    %cl,%esi
  802481:	89 eb                	mov    %ebp,%ebx
  802483:	89 c1                	mov    %eax,%ecx
  802485:	d3 eb                	shr    %cl,%ebx
  802487:	09 de                	or     %ebx,%esi
  802489:	89 f0                	mov    %esi,%eax
  80248b:	f7 74 24 08          	divl   0x8(%esp)
  80248f:	89 d6                	mov    %edx,%esi
  802491:	89 c3                	mov    %eax,%ebx
  802493:	f7 64 24 0c          	mull   0xc(%esp)
  802497:	39 d6                	cmp    %edx,%esi
  802499:	72 0c                	jb     8024a7 <__udivdi3+0xb7>
  80249b:	89 f9                	mov    %edi,%ecx
  80249d:	d3 e5                	shl    %cl,%ebp
  80249f:	39 c5                	cmp    %eax,%ebp
  8024a1:	73 5d                	jae    802500 <__udivdi3+0x110>
  8024a3:	39 d6                	cmp    %edx,%esi
  8024a5:	75 59                	jne    802500 <__udivdi3+0x110>
  8024a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024aa:	31 ff                	xor    %edi,%edi
  8024ac:	89 fa                	mov    %edi,%edx
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	8d 76 00             	lea    0x0(%esi),%esi
  8024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8024c0:	31 ff                	xor    %edi,%edi
  8024c2:	31 c0                	xor    %eax,%eax
  8024c4:	89 fa                	mov    %edi,%edx
  8024c6:	83 c4 1c             	add    $0x1c,%esp
  8024c9:	5b                   	pop    %ebx
  8024ca:	5e                   	pop    %esi
  8024cb:	5f                   	pop    %edi
  8024cc:	5d                   	pop    %ebp
  8024cd:	c3                   	ret    
  8024ce:	66 90                	xchg   %ax,%ax
  8024d0:	31 ff                	xor    %edi,%edi
  8024d2:	89 e8                	mov    %ebp,%eax
  8024d4:	89 f2                	mov    %esi,%edx
  8024d6:	f7 f3                	div    %ebx
  8024d8:	89 fa                	mov    %edi,%edx
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e8:	39 f2                	cmp    %esi,%edx
  8024ea:	72 06                	jb     8024f2 <__udivdi3+0x102>
  8024ec:	31 c0                	xor    %eax,%eax
  8024ee:	39 eb                	cmp    %ebp,%ebx
  8024f0:	77 d2                	ja     8024c4 <__udivdi3+0xd4>
  8024f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f7:	eb cb                	jmp    8024c4 <__udivdi3+0xd4>
  8024f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802500:	89 d8                	mov    %ebx,%eax
  802502:	31 ff                	xor    %edi,%edi
  802504:	eb be                	jmp    8024c4 <__udivdi3+0xd4>
  802506:	66 90                	xchg   %ax,%ax
  802508:	66 90                	xchg   %ax,%ax
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__umoddi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80251b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80251f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802527:	85 ed                	test   %ebp,%ebp
  802529:	89 f0                	mov    %esi,%eax
  80252b:	89 da                	mov    %ebx,%edx
  80252d:	75 19                	jne    802548 <__umoddi3+0x38>
  80252f:	39 df                	cmp    %ebx,%edi
  802531:	0f 86 b1 00 00 00    	jbe    8025e8 <__umoddi3+0xd8>
  802537:	f7 f7                	div    %edi
  802539:	89 d0                	mov    %edx,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	83 c4 1c             	add    $0x1c,%esp
  802540:	5b                   	pop    %ebx
  802541:	5e                   	pop    %esi
  802542:	5f                   	pop    %edi
  802543:	5d                   	pop    %ebp
  802544:	c3                   	ret    
  802545:	8d 76 00             	lea    0x0(%esi),%esi
  802548:	39 dd                	cmp    %ebx,%ebp
  80254a:	77 f1                	ja     80253d <__umoddi3+0x2d>
  80254c:	0f bd cd             	bsr    %ebp,%ecx
  80254f:	83 f1 1f             	xor    $0x1f,%ecx
  802552:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802556:	0f 84 b4 00 00 00    	je     802610 <__umoddi3+0x100>
  80255c:	b8 20 00 00 00       	mov    $0x20,%eax
  802561:	89 c2                	mov    %eax,%edx
  802563:	8b 44 24 04          	mov    0x4(%esp),%eax
  802567:	29 c2                	sub    %eax,%edx
  802569:	89 c1                	mov    %eax,%ecx
  80256b:	89 f8                	mov    %edi,%eax
  80256d:	d3 e5                	shl    %cl,%ebp
  80256f:	89 d1                	mov    %edx,%ecx
  802571:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802575:	d3 e8                	shr    %cl,%eax
  802577:	09 c5                	or     %eax,%ebp
  802579:	8b 44 24 04          	mov    0x4(%esp),%eax
  80257d:	89 c1                	mov    %eax,%ecx
  80257f:	d3 e7                	shl    %cl,%edi
  802581:	89 d1                	mov    %edx,%ecx
  802583:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802587:	89 df                	mov    %ebx,%edi
  802589:	d3 ef                	shr    %cl,%edi
  80258b:	89 c1                	mov    %eax,%ecx
  80258d:	89 f0                	mov    %esi,%eax
  80258f:	d3 e3                	shl    %cl,%ebx
  802591:	89 d1                	mov    %edx,%ecx
  802593:	89 fa                	mov    %edi,%edx
  802595:	d3 e8                	shr    %cl,%eax
  802597:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80259c:	09 d8                	or     %ebx,%eax
  80259e:	f7 f5                	div    %ebp
  8025a0:	d3 e6                	shl    %cl,%esi
  8025a2:	89 d1                	mov    %edx,%ecx
  8025a4:	f7 64 24 08          	mull   0x8(%esp)
  8025a8:	39 d1                	cmp    %edx,%ecx
  8025aa:	89 c3                	mov    %eax,%ebx
  8025ac:	89 d7                	mov    %edx,%edi
  8025ae:	72 06                	jb     8025b6 <__umoddi3+0xa6>
  8025b0:	75 0e                	jne    8025c0 <__umoddi3+0xb0>
  8025b2:	39 c6                	cmp    %eax,%esi
  8025b4:	73 0a                	jae    8025c0 <__umoddi3+0xb0>
  8025b6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8025ba:	19 ea                	sbb    %ebp,%edx
  8025bc:	89 d7                	mov    %edx,%edi
  8025be:	89 c3                	mov    %eax,%ebx
  8025c0:	89 ca                	mov    %ecx,%edx
  8025c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8025c7:	29 de                	sub    %ebx,%esi
  8025c9:	19 fa                	sbb    %edi,%edx
  8025cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8025cf:	89 d0                	mov    %edx,%eax
  8025d1:	d3 e0                	shl    %cl,%eax
  8025d3:	89 d9                	mov    %ebx,%ecx
  8025d5:	d3 ee                	shr    %cl,%esi
  8025d7:	d3 ea                	shr    %cl,%edx
  8025d9:	09 f0                	or     %esi,%eax
  8025db:	83 c4 1c             	add    $0x1c,%esp
  8025de:	5b                   	pop    %ebx
  8025df:	5e                   	pop    %esi
  8025e0:	5f                   	pop    %edi
  8025e1:	5d                   	pop    %ebp
  8025e2:	c3                   	ret    
  8025e3:	90                   	nop
  8025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	85 ff                	test   %edi,%edi
  8025ea:	89 f9                	mov    %edi,%ecx
  8025ec:	75 0b                	jne    8025f9 <__umoddi3+0xe9>
  8025ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f3:	31 d2                	xor    %edx,%edx
  8025f5:	f7 f7                	div    %edi
  8025f7:	89 c1                	mov    %eax,%ecx
  8025f9:	89 d8                	mov    %ebx,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	f7 f1                	div    %ecx
  8025ff:	89 f0                	mov    %esi,%eax
  802601:	f7 f1                	div    %ecx
  802603:	e9 31 ff ff ff       	jmp    802539 <__umoddi3+0x29>
  802608:	90                   	nop
  802609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802610:	39 dd                	cmp    %ebx,%ebp
  802612:	72 08                	jb     80261c <__umoddi3+0x10c>
  802614:	39 f7                	cmp    %esi,%edi
  802616:	0f 87 21 ff ff ff    	ja     80253d <__umoddi3+0x2d>
  80261c:	89 da                	mov    %ebx,%edx
  80261e:	89 f0                	mov    %esi,%eax
  802620:	29 f8                	sub    %edi,%eax
  802622:	19 ea                	sbb    %ebp,%edx
  802624:	e9 14 ff ff ff       	jmp    80253d <__umoddi3+0x2d>
