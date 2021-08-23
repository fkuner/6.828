
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 6e 01 00 00       	call   80019f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 e6 0f 00 00       	call   801024 <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 9e 00 00 00    	jne    8000e7 <umain+0xb4>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	68 00 00 b0 00       	push   $0xb00000
  800053:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 0a 12 00 00       	call   801266 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	68 00 00 b0 00       	push   $0xb00000
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	68 20 28 80 00       	push   $0x802820
  80006c:	e8 23 02 00 00       	call   800294 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800071:	83 c4 04             	add    $0x4,%esp
  800074:	ff 35 04 30 80 00    	pushl  0x803004
  80007a:	e8 7b 08 00 00       	call   8008fa <strlen>
  80007f:	83 c4 0c             	add    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	ff 35 04 30 80 00    	pushl  0x803004
  800089:	68 00 00 b0 00       	push   $0xb00000
  80008e:	e8 6a 09 00 00       	call   8009fd <strncmp>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	74 3b                	je     8000d5 <umain+0xa2>
			cprintf("child received correct message\n");

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 35 00 30 80 00    	pushl  0x803000
  8000a3:	e8 52 08 00 00       	call   8008fa <strlen>
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	83 c0 01             	add    $0x1,%eax
  8000ae:	50                   	push   %eax
  8000af:	ff 35 00 30 80 00    	pushl  0x803000
  8000b5:	68 00 00 b0 00       	push   $0xb00000
  8000ba:	e8 68 0a 00 00       	call   800b27 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000bf:	6a 07                	push   $0x7
  8000c1:	68 00 00 b0 00       	push   $0xb00000
  8000c6:	6a 00                	push   $0x0
  8000c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8000cb:	e8 ff 11 00 00       	call   8012cf <ipc_send>
		return;
  8000d0:	83 c4 20             	add    $0x20,%esp
	ipc_recv(&who, TEMP_ADDR, 0);
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
		cprintf("parent received correct message\n");
	return;
}
  8000d3:	c9                   	leave  
  8000d4:	c3                   	ret    
			cprintf("child received correct message\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 34 28 80 00       	push   $0x802834
  8000dd:	e8 b2 01 00 00       	call   800294 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb b3                	jmp    80009a <umain+0x67>
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8000e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ec:	8b 40 48             	mov    0x48(%eax),%eax
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	6a 07                	push   $0x7
  8000f4:	68 00 00 a0 00       	push   $0xa00000
  8000f9:	50                   	push   %eax
  8000fa:	e8 2b 0c 00 00       	call   800d2a <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8000ff:	83 c4 04             	add    $0x4,%esp
  800102:	ff 35 04 30 80 00    	pushl  0x803004
  800108:	e8 ed 07 00 00       	call   8008fa <strlen>
  80010d:	83 c4 0c             	add    $0xc,%esp
  800110:	83 c0 01             	add    $0x1,%eax
  800113:	50                   	push   %eax
  800114:	ff 35 04 30 80 00    	pushl  0x803004
  80011a:	68 00 00 a0 00       	push   $0xa00000
  80011f:	e8 03 0a 00 00       	call   800b27 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800124:	6a 07                	push   $0x7
  800126:	68 00 00 a0 00       	push   $0xa00000
  80012b:	6a 00                	push   $0x0
  80012d:	ff 75 f4             	pushl  -0xc(%ebp)
  800130:	e8 9a 11 00 00       	call   8012cf <ipc_send>
	ipc_recv(&who, TEMP_ADDR, 0);
  800135:	83 c4 1c             	add    $0x1c,%esp
  800138:	6a 00                	push   $0x0
  80013a:	68 00 00 a0 00       	push   $0xa00000
  80013f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 1e 11 00 00       	call   801266 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  800148:	83 c4 0c             	add    $0xc,%esp
  80014b:	68 00 00 a0 00       	push   $0xa00000
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	68 20 28 80 00       	push   $0x802820
  800158:	e8 37 01 00 00       	call   800294 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  80015d:	83 c4 04             	add    $0x4,%esp
  800160:	ff 35 00 30 80 00    	pushl  0x803000
  800166:	e8 8f 07 00 00       	call   8008fa <strlen>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 35 00 30 80 00    	pushl  0x803000
  800175:	68 00 00 a0 00       	push   $0xa00000
  80017a:	e8 7e 08 00 00       	call   8009fd <strncmp>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	85 c0                	test   %eax,%eax
  800184:	0f 85 49 ff ff ff    	jne    8000d3 <umain+0xa0>
		cprintf("parent received correct message\n");
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	68 54 28 80 00       	push   $0x802854
  800192:	e8 fd 00 00 00       	call   800294 <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	e9 34 ff ff ff       	jmp    8000d3 <umain+0xa0>

0080019f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8001aa:	e8 3d 0b 00 00       	call   800cec <sys_getenvid>
  8001af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bc:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c1:	85 db                	test   %ebx,%ebx
  8001c3:	7e 07                	jle    8001cc <libmain+0x2d>
		binaryname = argv[0];
  8001c5:	8b 06                	mov    (%esi),%eax
  8001c7:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	e8 5d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001d6:	e8 0a 00 00 00       	call   8001e5 <exit>
}
  8001db:	83 c4 10             	add    $0x10,%esp
  8001de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e1:	5b                   	pop    %ebx
  8001e2:	5e                   	pop    %esi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    

008001e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001eb:	e8 47 13 00 00       	call   801537 <close_all>
	sys_env_destroy(0);
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	6a 00                	push   $0x0
  8001f5:	e8 b1 0a 00 00       	call   800cab <sys_env_destroy>
}
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 13                	mov    (%ebx),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 03                	mov    %eax,(%ebx)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	74 09                	je     800227 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800225:	c9                   	leave  
  800226:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	68 ff 00 00 00       	push   $0xff
  80022f:	8d 43 08             	lea    0x8(%ebx),%eax
  800232:	50                   	push   %eax
  800233:	e8 36 0a 00 00       	call   800c6e <sys_cputs>
		b->idx = 0;
  800238:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb db                	jmp    80021e <putch+0x1f>

00800243 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800253:	00 00 00 
	b.cnt = 0;
  800256:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800260:	ff 75 0c             	pushl  0xc(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	68 ff 01 80 00       	push   $0x8001ff
  800272:	e8 1a 01 00 00       	call   800391 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800277:	83 c4 08             	add    $0x8,%esp
  80027a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800280:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	e8 e2 09 00 00       	call   800c6e <sys_cputs>

	return b.cnt;
}
  80028c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029d:	50                   	push   %eax
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 9d ff ff ff       	call   800243 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	57                   	push   %edi
  8002ac:	56                   	push   %esi
  8002ad:	53                   	push   %ebx
  8002ae:	83 ec 1c             	sub    $0x1c,%esp
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	89 d6                	mov    %edx,%esi
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002be:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002cc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002cf:	39 d3                	cmp    %edx,%ebx
  8002d1:	72 05                	jb     8002d8 <printnum+0x30>
  8002d3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002d6:	77 7a                	ja     800352 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	ff 75 18             	pushl  0x18(%ebp)
  8002de:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e4:	53                   	push   %ebx
  8002e5:	ff 75 10             	pushl  0x10(%ebp)
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f7:	e8 e4 22 00 00       	call   8025e0 <__udivdi3>
  8002fc:	83 c4 18             	add    $0x18,%esp
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	89 f2                	mov    %esi,%edx
  800303:	89 f8                	mov    %edi,%eax
  800305:	e8 9e ff ff ff       	call   8002a8 <printnum>
  80030a:	83 c4 20             	add    $0x20,%esp
  80030d:	eb 13                	jmp    800322 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	56                   	push   %esi
  800313:	ff 75 18             	pushl  0x18(%ebp)
  800316:	ff d7                	call   *%edi
  800318:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80031b:	83 eb 01             	sub    $0x1,%ebx
  80031e:	85 db                	test   %ebx,%ebx
  800320:	7f ed                	jg     80030f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800322:	83 ec 08             	sub    $0x8,%esp
  800325:	56                   	push   %esi
  800326:	83 ec 04             	sub    $0x4,%esp
  800329:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032c:	ff 75 e0             	pushl  -0x20(%ebp)
  80032f:	ff 75 dc             	pushl  -0x24(%ebp)
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 c6 23 00 00       	call   802700 <__umoddi3>
  80033a:	83 c4 14             	add    $0x14,%esp
  80033d:	0f be 80 cc 28 80 00 	movsbl 0x8028cc(%eax),%eax
  800344:	50                   	push   %eax
  800345:	ff d7                	call   *%edi
}
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    
  800352:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800355:	eb c4                	jmp    80031b <printnum+0x73>

00800357 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800361:	8b 10                	mov    (%eax),%edx
  800363:	3b 50 04             	cmp    0x4(%eax),%edx
  800366:	73 0a                	jae    800372 <sprintputch+0x1b>
		*b->buf++ = ch;
  800368:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036b:	89 08                	mov    %ecx,(%eax)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	88 02                	mov    %al,(%edx)
}
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <printfmt>:
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037d:	50                   	push   %eax
  80037e:	ff 75 10             	pushl  0x10(%ebp)
  800381:	ff 75 0c             	pushl  0xc(%ebp)
  800384:	ff 75 08             	pushl  0x8(%ebp)
  800387:	e8 05 00 00 00       	call   800391 <vprintfmt>
}
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <vprintfmt>:
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	57                   	push   %edi
  800395:	56                   	push   %esi
  800396:	53                   	push   %ebx
  800397:	83 ec 2c             	sub    $0x2c,%esp
  80039a:	8b 75 08             	mov    0x8(%ebp),%esi
  80039d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a3:	e9 21 04 00 00       	jmp    8007c9 <vprintfmt+0x438>
		padc = ' ';
  8003a8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003b3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8d 47 01             	lea    0x1(%edi),%eax
  8003c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cc:	0f b6 17             	movzbl (%edi),%edx
  8003cf:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d2:	3c 55                	cmp    $0x55,%al
  8003d4:	0f 87 90 04 00 00    	ja     80086a <vprintfmt+0x4d9>
  8003da:	0f b6 c0             	movzbl %al,%eax
  8003dd:	ff 24 85 00 2a 80 00 	jmp    *0x802a00(,%eax,4)
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003eb:	eb d9                	jmp    8003c6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f4:	eb d0                	jmp    8003c6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	0f b6 d2             	movzbl %dl,%edx
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800401:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800404:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800407:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80040b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800411:	83 f9 09             	cmp    $0x9,%ecx
  800414:	77 55                	ja     80046b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800416:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800419:	eb e9                	jmp    800404 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 40 04             	lea    0x4(%eax),%eax
  800429:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800433:	79 91                	jns    8003c6 <vprintfmt+0x35>
				width = precision, precision = -1;
  800435:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800442:	eb 82                	jmp    8003c6 <vprintfmt+0x35>
  800444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800447:	85 c0                	test   %eax,%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	0f 49 d0             	cmovns %eax,%edx
  800451:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800457:	e9 6a ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800466:	e9 5b ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
  80046b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800471:	eb bc                	jmp    80042f <vprintfmt+0x9e>
			lflag++;
  800473:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800479:	e9 48 ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8d 78 04             	lea    0x4(%eax),%edi
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	ff 30                	pushl  (%eax)
  80048a:	ff d6                	call   *%esi
			break;
  80048c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800492:	e9 2f 03 00 00       	jmp    8007c6 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 78 04             	lea    0x4(%eax),%edi
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	99                   	cltd   
  8004a0:	31 d0                	xor    %edx,%eax
  8004a2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a4:	83 f8 0f             	cmp    $0xf,%eax
  8004a7:	7f 23                	jg     8004cc <vprintfmt+0x13b>
  8004a9:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	74 18                	je     8004cc <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004b4:	52                   	push   %edx
  8004b5:	68 37 2d 80 00       	push   $0x802d37
  8004ba:	53                   	push   %ebx
  8004bb:	56                   	push   %esi
  8004bc:	e8 b3 fe ff ff       	call   800374 <printfmt>
  8004c1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c7:	e9 fa 02 00 00       	jmp    8007c6 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8004cc:	50                   	push   %eax
  8004cd:	68 e4 28 80 00       	push   $0x8028e4
  8004d2:	53                   	push   %ebx
  8004d3:	56                   	push   %esi
  8004d4:	e8 9b fe ff ff       	call   800374 <printfmt>
  8004d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004dc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004df:	e9 e2 02 00 00       	jmp    8007c6 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	83 c0 04             	add    $0x4,%eax
  8004ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004f2:	85 ff                	test   %edi,%edi
  8004f4:	b8 dd 28 80 00       	mov    $0x8028dd,%eax
  8004f9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800500:	0f 8e bd 00 00 00    	jle    8005c3 <vprintfmt+0x232>
  800506:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80050a:	75 0e                	jne    80051a <vprintfmt+0x189>
  80050c:	89 75 08             	mov    %esi,0x8(%ebp)
  80050f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800512:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800515:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800518:	eb 6d                	jmp    800587 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	ff 75 d0             	pushl  -0x30(%ebp)
  800520:	57                   	push   %edi
  800521:	e8 ec 03 00 00       	call   800912 <strnlen>
  800526:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800529:	29 c1                	sub    %eax,%ecx
  80052b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80052e:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800531:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800538:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80053b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053d:	eb 0f                	jmp    80054e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	53                   	push   %ebx
  800543:	ff 75 e0             	pushl  -0x20(%ebp)
  800546:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800548:	83 ef 01             	sub    $0x1,%edi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	85 ff                	test   %edi,%edi
  800550:	7f ed                	jg     80053f <vprintfmt+0x1ae>
  800552:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800555:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800558:	85 c9                	test   %ecx,%ecx
  80055a:	b8 00 00 00 00       	mov    $0x0,%eax
  80055f:	0f 49 c1             	cmovns %ecx,%eax
  800562:	29 c1                	sub    %eax,%ecx
  800564:	89 75 08             	mov    %esi,0x8(%ebp)
  800567:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80056a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80056d:	89 cb                	mov    %ecx,%ebx
  80056f:	eb 16                	jmp    800587 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800571:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800575:	75 31                	jne    8005a8 <vprintfmt+0x217>
					putch(ch, putdat);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	ff 55 08             	call   *0x8(%ebp)
  800581:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800584:	83 eb 01             	sub    $0x1,%ebx
  800587:	83 c7 01             	add    $0x1,%edi
  80058a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80058e:	0f be c2             	movsbl %dl,%eax
  800591:	85 c0                	test   %eax,%eax
  800593:	74 59                	je     8005ee <vprintfmt+0x25d>
  800595:	85 f6                	test   %esi,%esi
  800597:	78 d8                	js     800571 <vprintfmt+0x1e0>
  800599:	83 ee 01             	sub    $0x1,%esi
  80059c:	79 d3                	jns    800571 <vprintfmt+0x1e0>
  80059e:	89 df                	mov    %ebx,%edi
  8005a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005a6:	eb 37                	jmp    8005df <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a8:	0f be d2             	movsbl %dl,%edx
  8005ab:	83 ea 20             	sub    $0x20,%edx
  8005ae:	83 fa 5e             	cmp    $0x5e,%edx
  8005b1:	76 c4                	jbe    800577 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	6a 3f                	push   $0x3f
  8005bb:	ff 55 08             	call   *0x8(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	eb c1                	jmp    800584 <vprintfmt+0x1f3>
  8005c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005cf:	eb b6                	jmp    800587 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	6a 20                	push   $0x20
  8005d7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d9:	83 ef 01             	sub    $0x1,%edi
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	85 ff                	test   %edi,%edi
  8005e1:	7f ee                	jg     8005d1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	e9 d8 01 00 00       	jmp    8007c6 <vprintfmt+0x435>
  8005ee:	89 df                	mov    %ebx,%edi
  8005f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005f6:	eb e7                	jmp    8005df <vprintfmt+0x24e>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 45                	jle    800642 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 50 04             	mov    0x4(%eax),%edx
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800614:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800618:	79 62                	jns    80067c <vprintfmt+0x2eb>
				putch('-', putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	6a 2d                	push   $0x2d
  800620:	ff d6                	call   *%esi
				num = -(long long) num;
  800622:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800625:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800628:	f7 d8                	neg    %eax
  80062a:	83 d2 00             	adc    $0x0,%edx
  80062d:	f7 da                	neg    %edx
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800635:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800638:	ba 0a 00 00 00       	mov    $0xa,%edx
  80063d:	e9 66 01 00 00       	jmp    8007a8 <vprintfmt+0x417>
	else if (lflag)
  800642:	85 c9                	test   %ecx,%ecx
  800644:	75 1b                	jne    800661 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064e:	89 c1                	mov    %eax,%ecx
  800650:	c1 f9 1f             	sar    $0x1f,%ecx
  800653:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
  80065f:	eb b3                	jmp    800614 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800669:	89 c1                	mov    %eax,%ecx
  80066b:	c1 f9 1f             	sar    $0x1f,%ecx
  80066e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
  80067a:	eb 98                	jmp    800614 <vprintfmt+0x283>
			base = 10;
  80067c:	ba 0a 00 00 00       	mov    $0xa,%edx
  800681:	e9 22 01 00 00       	jmp    8007a8 <vprintfmt+0x417>
	if (lflag >= 2)
  800686:	83 f9 01             	cmp    $0x1,%ecx
  800689:	7e 21                	jle    8006ac <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 50 04             	mov    0x4(%eax),%edx
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800696:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006a7:	e9 fc 00 00 00       	jmp    8007a8 <vprintfmt+0x417>
	else if (lflag)
  8006ac:	85 c9                	test   %ecx,%ecx
  8006ae:	75 23                	jne    8006d3 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 40 04             	lea    0x4(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006ce:	e9 d5 00 00 00       	jmp    8007a8 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ec:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006f1:	e9 b2 00 00 00       	jmp    8007a8 <vprintfmt+0x417>
	if (lflag >= 2)
  8006f6:	83 f9 01             	cmp    $0x1,%ecx
  8006f9:	7e 42                	jle    80073d <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 50 04             	mov    0x4(%eax),%edx
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800706:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8d 40 08             	lea    0x8(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800712:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800717:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80071b:	0f 89 87 00 00 00    	jns    8007a8 <vprintfmt+0x417>
				putch('-', putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	53                   	push   %ebx
  800725:	6a 2d                	push   $0x2d
  800727:	ff d6                	call   *%esi
				num = -(long long) num;
  800729:	f7 5d d8             	negl   -0x28(%ebp)
  80072c:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800730:	f7 5d dc             	negl   -0x24(%ebp)
  800733:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800736:	ba 08 00 00 00       	mov    $0x8,%edx
  80073b:	eb 6b                	jmp    8007a8 <vprintfmt+0x417>
	else if (lflag)
  80073d:	85 c9                	test   %ecx,%ecx
  80073f:	75 1b                	jne    80075c <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
  80075a:	eb b6                	jmp    800712 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	ba 00 00 00 00       	mov    $0x0,%edx
  800766:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800769:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
  800775:	eb 9b                	jmp    800712 <vprintfmt+0x381>
			putch('0', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	53                   	push   %ebx
  80077b:	6a 30                	push   $0x30
  80077d:	ff d6                	call   *%esi
			putch('x', putdat);
  80077f:	83 c4 08             	add    $0x8,%esp
  800782:	53                   	push   %ebx
  800783:	6a 78                	push   $0x78
  800785:	ff d6                	call   *%esi
			num = (unsigned long long)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	ba 00 00 00 00       	mov    $0x0,%edx
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800797:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8d 40 04             	lea    0x4(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a3:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8007af:	50                   	push   %eax
  8007b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b3:	52                   	push   %edx
  8007b4:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b7:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ba:	89 da                	mov    %ebx,%edx
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	e8 e5 fa ff ff       	call   8002a8 <printnum>
			break;
  8007c3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	83 c7 01             	add    $0x1,%edi
  8007cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d0:	83 f8 25             	cmp    $0x25,%eax
  8007d3:	0f 84 cf fb ff ff    	je     8003a8 <vprintfmt+0x17>
			if (ch == '\0')
  8007d9:	85 c0                	test   %eax,%eax
  8007db:	0f 84 a9 00 00 00    	je     80088a <vprintfmt+0x4f9>
			putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	50                   	push   %eax
  8007e6:	ff d6                	call   *%esi
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	eb dc                	jmp    8007c9 <vprintfmt+0x438>
	if (lflag >= 2)
  8007ed:	83 f9 01             	cmp    $0x1,%ecx
  8007f0:	7e 1e                	jle    800810 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 50 04             	mov    0x4(%eax),%edx
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8d 40 08             	lea    0x8(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800809:	ba 10 00 00 00       	mov    $0x10,%edx
  80080e:	eb 98                	jmp    8007a8 <vprintfmt+0x417>
	else if (lflag)
  800810:	85 c9                	test   %ecx,%ecx
  800812:	75 23                	jne    800837 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800821:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8d 40 04             	lea    0x4(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082d:	ba 10 00 00 00       	mov    $0x10,%edx
  800832:	e9 71 ff ff ff       	jmp    8007a8 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	ba 00 00 00 00       	mov    $0x0,%edx
  800841:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800844:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8d 40 04             	lea    0x4(%eax),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800850:	ba 10 00 00 00       	mov    $0x10,%edx
  800855:	e9 4e ff ff ff       	jmp    8007a8 <vprintfmt+0x417>
			putch(ch, putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	53                   	push   %ebx
  80085e:	6a 25                	push   $0x25
  800860:	ff d6                	call   *%esi
			break;
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	e9 5c ff ff ff       	jmp    8007c6 <vprintfmt+0x435>
			putch('%', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	53                   	push   %ebx
  80086e:	6a 25                	push   $0x25
  800870:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800872:	83 c4 10             	add    $0x10,%esp
  800875:	89 f8                	mov    %edi,%eax
  800877:	eb 03                	jmp    80087c <vprintfmt+0x4eb>
  800879:	83 e8 01             	sub    $0x1,%eax
  80087c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800880:	75 f7                	jne    800879 <vprintfmt+0x4e8>
  800882:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800885:	e9 3c ff ff ff       	jmp    8007c6 <vprintfmt+0x435>
}
  80088a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088d:	5b                   	pop    %ebx
  80088e:	5e                   	pop    %esi
  80088f:	5f                   	pop    %edi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	83 ec 18             	sub    $0x18,%esp
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80089e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	74 26                	je     8008d9 <vsnprintf+0x47>
  8008b3:	85 d2                	test   %edx,%edx
  8008b5:	7e 22                	jle    8008d9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b7:	ff 75 14             	pushl  0x14(%ebp)
  8008ba:	ff 75 10             	pushl  0x10(%ebp)
  8008bd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c0:	50                   	push   %eax
  8008c1:	68 57 03 80 00       	push   $0x800357
  8008c6:	e8 c6 fa ff ff       	call   800391 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ce:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
}
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    
		return -E_INVAL;
  8008d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008de:	eb f7                	jmp    8008d7 <vsnprintf+0x45>

008008e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e9:	50                   	push   %eax
  8008ea:	ff 75 10             	pushl  0x10(%ebp)
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	ff 75 08             	pushl  0x8(%ebp)
  8008f3:	e8 9a ff ff ff       	call   800892 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f8:	c9                   	leave  
  8008f9:	c3                   	ret    

008008fa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800900:	b8 00 00 00 00       	mov    $0x0,%eax
  800905:	eb 03                	jmp    80090a <strlen+0x10>
		n++;
  800907:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80090a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090e:	75 f7                	jne    800907 <strlen+0xd>
	return n;
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800918:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
  800920:	eb 03                	jmp    800925 <strnlen+0x13>
		n++;
  800922:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800925:	39 d0                	cmp    %edx,%eax
  800927:	74 06                	je     80092f <strnlen+0x1d>
  800929:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80092d:	75 f3                	jne    800922 <strnlen+0x10>
	return n;
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80093b:	89 c2                	mov    %eax,%edx
  80093d:	83 c1 01             	add    $0x1,%ecx
  800940:	83 c2 01             	add    $0x1,%edx
  800943:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800947:	88 5a ff             	mov    %bl,-0x1(%edx)
  80094a:	84 db                	test   %bl,%bl
  80094c:	75 ef                	jne    80093d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80094e:	5b                   	pop    %ebx
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800958:	53                   	push   %ebx
  800959:	e8 9c ff ff ff       	call   8008fa <strlen>
  80095e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	01 d8                	add    %ebx,%eax
  800966:	50                   	push   %eax
  800967:	e8 c5 ff ff ff       	call   800931 <strcpy>
	return dst;
}
  80096c:	89 d8                	mov    %ebx,%eax
  80096e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	56                   	push   %esi
  800977:	53                   	push   %ebx
  800978:	8b 75 08             	mov    0x8(%ebp),%esi
  80097b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097e:	89 f3                	mov    %esi,%ebx
  800980:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800983:	89 f2                	mov    %esi,%edx
  800985:	eb 0f                	jmp    800996 <strncpy+0x23>
		*dst++ = *src;
  800987:	83 c2 01             	add    $0x1,%edx
  80098a:	0f b6 01             	movzbl (%ecx),%eax
  80098d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800990:	80 39 01             	cmpb   $0x1,(%ecx)
  800993:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800996:	39 da                	cmp    %ebx,%edx
  800998:	75 ed                	jne    800987 <strncpy+0x14>
	}
	return ret;
}
  80099a:	89 f0                	mov    %esi,%eax
  80099c:	5b                   	pop    %ebx
  80099d:	5e                   	pop    %esi
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	56                   	push   %esi
  8009a4:	53                   	push   %ebx
  8009a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b4:	85 c9                	test   %ecx,%ecx
  8009b6:	75 0b                	jne    8009c3 <strlcpy+0x23>
  8009b8:	eb 17                	jmp    8009d1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009ba:	83 c2 01             	add    $0x1,%edx
  8009bd:	83 c0 01             	add    $0x1,%eax
  8009c0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009c3:	39 d8                	cmp    %ebx,%eax
  8009c5:	74 07                	je     8009ce <strlcpy+0x2e>
  8009c7:	0f b6 0a             	movzbl (%edx),%ecx
  8009ca:	84 c9                	test   %cl,%cl
  8009cc:	75 ec                	jne    8009ba <strlcpy+0x1a>
		*dst = '\0';
  8009ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d1:	29 f0                	sub    %esi,%eax
}
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e0:	eb 06                	jmp    8009e8 <strcmp+0x11>
		p++, q++;
  8009e2:	83 c1 01             	add    $0x1,%ecx
  8009e5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009e8:	0f b6 01             	movzbl (%ecx),%eax
  8009eb:	84 c0                	test   %al,%al
  8009ed:	74 04                	je     8009f3 <strcmp+0x1c>
  8009ef:	3a 02                	cmp    (%edx),%al
  8009f1:	74 ef                	je     8009e2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f3:	0f b6 c0             	movzbl %al,%eax
  8009f6:	0f b6 12             	movzbl (%edx),%edx
  8009f9:	29 d0                	sub    %edx,%eax
}
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	53                   	push   %ebx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a07:	89 c3                	mov    %eax,%ebx
  800a09:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a0c:	eb 06                	jmp    800a14 <strncmp+0x17>
		n--, p++, q++;
  800a0e:	83 c0 01             	add    $0x1,%eax
  800a11:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a14:	39 d8                	cmp    %ebx,%eax
  800a16:	74 16                	je     800a2e <strncmp+0x31>
  800a18:	0f b6 08             	movzbl (%eax),%ecx
  800a1b:	84 c9                	test   %cl,%cl
  800a1d:	74 04                	je     800a23 <strncmp+0x26>
  800a1f:	3a 0a                	cmp    (%edx),%cl
  800a21:	74 eb                	je     800a0e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a23:	0f b6 00             	movzbl (%eax),%eax
  800a26:	0f b6 12             	movzbl (%edx),%edx
  800a29:	29 d0                	sub    %edx,%eax
}
  800a2b:	5b                   	pop    %ebx
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    
		return 0;
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	eb f6                	jmp    800a2b <strncmp+0x2e>

00800a35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3f:	0f b6 10             	movzbl (%eax),%edx
  800a42:	84 d2                	test   %dl,%dl
  800a44:	74 09                	je     800a4f <strchr+0x1a>
		if (*s == c)
  800a46:	38 ca                	cmp    %cl,%dl
  800a48:	74 0a                	je     800a54 <strchr+0x1f>
	for (; *s; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	eb f0                	jmp    800a3f <strchr+0xa>
			return (char *) s;
	return 0;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a60:	eb 03                	jmp    800a65 <strfind+0xf>
  800a62:	83 c0 01             	add    $0x1,%eax
  800a65:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a68:	38 ca                	cmp    %cl,%dl
  800a6a:	74 04                	je     800a70 <strfind+0x1a>
  800a6c:	84 d2                	test   %dl,%dl
  800a6e:	75 f2                	jne    800a62 <strfind+0xc>
			break;
	return (char *) s;
}
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	57                   	push   %edi
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a7e:	85 c9                	test   %ecx,%ecx
  800a80:	74 13                	je     800a95 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a82:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a88:	75 05                	jne    800a8f <memset+0x1d>
  800a8a:	f6 c1 03             	test   $0x3,%cl
  800a8d:	74 0d                	je     800a9c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	fc                   	cld    
  800a93:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a95:	89 f8                	mov    %edi,%eax
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    
		c &= 0xFF;
  800a9c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa0:	89 d3                	mov    %edx,%ebx
  800aa2:	c1 e3 08             	shl    $0x8,%ebx
  800aa5:	89 d0                	mov    %edx,%eax
  800aa7:	c1 e0 18             	shl    $0x18,%eax
  800aaa:	89 d6                	mov    %edx,%esi
  800aac:	c1 e6 10             	shl    $0x10,%esi
  800aaf:	09 f0                	or     %esi,%eax
  800ab1:	09 c2                	or     %eax,%edx
  800ab3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ab5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab8:	89 d0                	mov    %edx,%eax
  800aba:	fc                   	cld    
  800abb:	f3 ab                	rep stos %eax,%es:(%edi)
  800abd:	eb d6                	jmp    800a95 <memset+0x23>

00800abf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	57                   	push   %edi
  800ac3:	56                   	push   %esi
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aca:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800acd:	39 c6                	cmp    %eax,%esi
  800acf:	73 35                	jae    800b06 <memmove+0x47>
  800ad1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad4:	39 c2                	cmp    %eax,%edx
  800ad6:	76 2e                	jbe    800b06 <memmove+0x47>
		s += n;
		d += n;
  800ad8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adb:	89 d6                	mov    %edx,%esi
  800add:	09 fe                	or     %edi,%esi
  800adf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae5:	74 0c                	je     800af3 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae7:	83 ef 01             	sub    $0x1,%edi
  800aea:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aed:	fd                   	std    
  800aee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af0:	fc                   	cld    
  800af1:	eb 21                	jmp    800b14 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af3:	f6 c1 03             	test   $0x3,%cl
  800af6:	75 ef                	jne    800ae7 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af8:	83 ef 04             	sub    $0x4,%edi
  800afb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800afe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b01:	fd                   	std    
  800b02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b04:	eb ea                	jmp    800af0 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b06:	89 f2                	mov    %esi,%edx
  800b08:	09 c2                	or     %eax,%edx
  800b0a:	f6 c2 03             	test   $0x3,%dl
  800b0d:	74 09                	je     800b18 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b0f:	89 c7                	mov    %eax,%edi
  800b11:	fc                   	cld    
  800b12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b18:	f6 c1 03             	test   $0x3,%cl
  800b1b:	75 f2                	jne    800b0f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	fc                   	cld    
  800b23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b25:	eb ed                	jmp    800b14 <memmove+0x55>

00800b27 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b2a:	ff 75 10             	pushl  0x10(%ebp)
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	ff 75 08             	pushl  0x8(%ebp)
  800b33:	e8 87 ff ff ff       	call   800abf <memmove>
}
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	56                   	push   %esi
  800b3e:	53                   	push   %ebx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b45:	89 c6                	mov    %eax,%esi
  800b47:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4a:	39 f0                	cmp    %esi,%eax
  800b4c:	74 1c                	je     800b6a <memcmp+0x30>
		if (*s1 != *s2)
  800b4e:	0f b6 08             	movzbl (%eax),%ecx
  800b51:	0f b6 1a             	movzbl (%edx),%ebx
  800b54:	38 d9                	cmp    %bl,%cl
  800b56:	75 08                	jne    800b60 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b58:	83 c0 01             	add    $0x1,%eax
  800b5b:	83 c2 01             	add    $0x1,%edx
  800b5e:	eb ea                	jmp    800b4a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b60:	0f b6 c1             	movzbl %cl,%eax
  800b63:	0f b6 db             	movzbl %bl,%ebx
  800b66:	29 d8                	sub    %ebx,%eax
  800b68:	eb 05                	jmp    800b6f <memcmp+0x35>
	}

	return 0;
  800b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7c:	89 c2                	mov    %eax,%edx
  800b7e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b81:	39 d0                	cmp    %edx,%eax
  800b83:	73 09                	jae    800b8e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b85:	38 08                	cmp    %cl,(%eax)
  800b87:	74 05                	je     800b8e <memfind+0x1b>
	for (; s < ends; s++)
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	eb f3                	jmp    800b81 <memfind+0xe>
			break;
	return (void *) s;
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9c:	eb 03                	jmp    800ba1 <strtol+0x11>
		s++;
  800b9e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba1:	0f b6 01             	movzbl (%ecx),%eax
  800ba4:	3c 20                	cmp    $0x20,%al
  800ba6:	74 f6                	je     800b9e <strtol+0xe>
  800ba8:	3c 09                	cmp    $0x9,%al
  800baa:	74 f2                	je     800b9e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bac:	3c 2b                	cmp    $0x2b,%al
  800bae:	74 2e                	je     800bde <strtol+0x4e>
	int neg = 0;
  800bb0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb5:	3c 2d                	cmp    $0x2d,%al
  800bb7:	74 2f                	je     800be8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbf:	75 05                	jne    800bc6 <strtol+0x36>
  800bc1:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc4:	74 2c                	je     800bf2 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	75 0a                	jne    800bd4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bca:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bcf:	80 39 30             	cmpb   $0x30,(%ecx)
  800bd2:	74 28                	je     800bfc <strtol+0x6c>
		base = 10;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bdc:	eb 50                	jmp    800c2e <strtol+0x9e>
		s++;
  800bde:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be1:	bf 00 00 00 00       	mov    $0x0,%edi
  800be6:	eb d1                	jmp    800bb9 <strtol+0x29>
		s++, neg = 1;
  800be8:	83 c1 01             	add    $0x1,%ecx
  800beb:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf0:	eb c7                	jmp    800bb9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf6:	74 0e                	je     800c06 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf8:	85 db                	test   %ebx,%ebx
  800bfa:	75 d8                	jne    800bd4 <strtol+0x44>
		s++, base = 8;
  800bfc:	83 c1 01             	add    $0x1,%ecx
  800bff:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c04:	eb ce                	jmp    800bd4 <strtol+0x44>
		s += 2, base = 16;
  800c06:	83 c1 02             	add    $0x2,%ecx
  800c09:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0e:	eb c4                	jmp    800bd4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c10:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c13:	89 f3                	mov    %esi,%ebx
  800c15:	80 fb 19             	cmp    $0x19,%bl
  800c18:	77 29                	ja     800c43 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c1a:	0f be d2             	movsbl %dl,%edx
  800c1d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c20:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c23:	7d 30                	jge    800c55 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c25:	83 c1 01             	add    $0x1,%ecx
  800c28:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2e:	0f b6 11             	movzbl (%ecx),%edx
  800c31:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c34:	89 f3                	mov    %esi,%ebx
  800c36:	80 fb 09             	cmp    $0x9,%bl
  800c39:	77 d5                	ja     800c10 <strtol+0x80>
			dig = *s - '0';
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 30             	sub    $0x30,%edx
  800c41:	eb dd                	jmp    800c20 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c43:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c46:	89 f3                	mov    %esi,%ebx
  800c48:	80 fb 19             	cmp    $0x19,%bl
  800c4b:	77 08                	ja     800c55 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c4d:	0f be d2             	movsbl %dl,%edx
  800c50:	83 ea 37             	sub    $0x37,%edx
  800c53:	eb cb                	jmp    800c20 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	74 05                	je     800c60 <strtol+0xd0>
		*endptr = (char *) s;
  800c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	f7 da                	neg    %edx
  800c64:	85 ff                	test   %edi,%edi
  800c66:	0f 45 c2             	cmovne %edx,%eax
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7f:	89 c3                	mov    %eax,%ebx
  800c81:	89 c7                	mov    %eax,%edi
  800c83:	89 c6                	mov    %eax,%esi
  800c85:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
  800c97:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9c:	89 d1                	mov    %edx,%ecx
  800c9e:	89 d3                	mov    %edx,%ebx
  800ca0:	89 d7                	mov    %edx,%edi
  800ca2:	89 d6                	mov    %edx,%esi
  800ca4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc1:	89 cb                	mov    %ecx,%ebx
  800cc3:	89 cf                	mov    %ecx,%edi
  800cc5:	89 ce                	mov    %ecx,%esi
  800cc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7f 08                	jg     800cd5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	6a 03                	push   $0x3
  800cdb:	68 bf 2b 80 00       	push   $0x802bbf
  800ce0:	6a 23                	push   $0x23
  800ce2:	68 dc 2b 80 00       	push   $0x802bdc
  800ce7:	e8 d4 17 00 00       	call   8024c0 <_panic>

00800cec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf7:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfc:	89 d1                	mov    %edx,%ecx
  800cfe:	89 d3                	mov    %edx,%ebx
  800d00:	89 d7                	mov    %edx,%edi
  800d02:	89 d6                	mov    %edx,%esi
  800d04:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <sys_yield>:

void
sys_yield(void)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d11:	ba 00 00 00 00       	mov    $0x0,%edx
  800d16:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1b:	89 d1                	mov    %edx,%ecx
  800d1d:	89 d3                	mov    %edx,%ebx
  800d1f:	89 d7                	mov    %edx,%edi
  800d21:	89 d6                	mov    %edx,%esi
  800d23:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	be 00 00 00 00       	mov    $0x0,%esi
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d46:	89 f7                	mov    %esi,%edi
  800d48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	7f 08                	jg     800d56 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d56:	83 ec 0c             	sub    $0xc,%esp
  800d59:	50                   	push   %eax
  800d5a:	6a 04                	push   $0x4
  800d5c:	68 bf 2b 80 00       	push   $0x802bbf
  800d61:	6a 23                	push   $0x23
  800d63:	68 dc 2b 80 00       	push   $0x802bdc
  800d68:	e8 53 17 00 00       	call   8024c0 <_panic>

00800d6d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 05 00 00 00       	mov    $0x5,%eax
  800d81:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d84:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d87:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 05                	push   $0x5
  800d9e:	68 bf 2b 80 00       	push   $0x802bbf
  800da3:	6a 23                	push   $0x23
  800da5:	68 dc 2b 80 00       	push   $0x802bdc
  800daa:	e8 11 17 00 00       	call   8024c0 <_panic>

00800daf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	57                   	push   %edi
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
  800db5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc8:	89 df                	mov    %ebx,%edi
  800dca:	89 de                	mov    %ebx,%esi
  800dcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	7f 08                	jg     800dda <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dda:	83 ec 0c             	sub    $0xc,%esp
  800ddd:	50                   	push   %eax
  800dde:	6a 06                	push   $0x6
  800de0:	68 bf 2b 80 00       	push   $0x802bbf
  800de5:	6a 23                	push   $0x23
  800de7:	68 dc 2b 80 00       	push   $0x802bdc
  800dec:	e8 cf 16 00 00       	call   8024c0 <_panic>

00800df1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0a:	89 df                	mov    %ebx,%edi
  800e0c:	89 de                	mov    %ebx,%esi
  800e0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e10:	85 c0                	test   %eax,%eax
  800e12:	7f 08                	jg     800e1c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	50                   	push   %eax
  800e20:	6a 08                	push   $0x8
  800e22:	68 bf 2b 80 00       	push   $0x802bbf
  800e27:	6a 23                	push   $0x23
  800e29:	68 dc 2b 80 00       	push   $0x802bdc
  800e2e:	e8 8d 16 00 00       	call   8024c0 <_panic>

00800e33 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 09                	push   $0x9
  800e64:	68 bf 2b 80 00       	push   $0x802bbf
  800e69:	6a 23                	push   $0x23
  800e6b:	68 dc 2b 80 00       	push   $0x802bdc
  800e70:	e8 4b 16 00 00       	call   8024c0 <_panic>

00800e75 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8e:	89 df                	mov    %ebx,%edi
  800e90:	89 de                	mov    %ebx,%esi
  800e92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	7f 08                	jg     800ea0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	50                   	push   %eax
  800ea4:	6a 0a                	push   $0xa
  800ea6:	68 bf 2b 80 00       	push   $0x802bbf
  800eab:	6a 23                	push   $0x23
  800ead:	68 dc 2b 80 00       	push   $0x802bdc
  800eb2:	e8 09 16 00 00       	call   8024c0 <_panic>

00800eb7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec8:	be 00 00 00 00       	mov    $0x0,%esi
  800ecd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef0:	89 cb                	mov    %ecx,%ebx
  800ef2:	89 cf                	mov    %ecx,%edi
  800ef4:	89 ce                	mov    %ecx,%esi
  800ef6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7f 08                	jg     800f04 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	50                   	push   %eax
  800f08:	6a 0d                	push   $0xd
  800f0a:	68 bf 2b 80 00       	push   $0x802bbf
  800f0f:	6a 23                	push   $0x23
  800f11:	68 dc 2b 80 00       	push   $0x802bdc
  800f16:	e8 a5 15 00 00       	call   8024c0 <_panic>

00800f1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 1c             	sub    $0x1c,%esp
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800f46:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800f48:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800f4b:	89 d8                	mov    %ebx,%eax
  800f4d:	c1 e8 0c             	shr    $0xc,%eax
  800f50:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800f5a:	e8 8d fd ff ff       	call   800cec <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800f5f:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800f65:	74 73                	je     800fda <pgfault+0xa0>
  800f67:	89 c6                	mov    %eax,%esi
  800f69:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800f70:	74 68                	je     800fda <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	6a 07                	push   $0x7
  800f77:	68 00 f0 7f 00       	push   $0x7ff000
  800f7c:	50                   	push   %eax
  800f7d:	e8 a8 fd ff ff       	call   800d2a <sys_page_alloc>
  800f82:	83 c4 10             	add    $0x10,%esp
  800f85:	85 c0                	test   %eax,%eax
  800f87:	75 65                	jne    800fee <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f89:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	68 00 10 00 00       	push   $0x1000
  800f97:	53                   	push   %ebx
  800f98:	68 00 f0 7f 00       	push   $0x7ff000
  800f9d:	e8 85 fb ff ff       	call   800b27 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800fa2:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fa9:	53                   	push   %ebx
  800faa:	56                   	push   %esi
  800fab:	68 00 f0 7f 00       	push   $0x7ff000
  800fb0:	56                   	push   %esi
  800fb1:	e8 b7 fd ff ff       	call   800d6d <sys_page_map>
  800fb6:	83 c4 20             	add    $0x20,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 43                	jne    801000 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	68 00 f0 7f 00       	push   $0x7ff000
  800fc5:	56                   	push   %esi
  800fc6:	e8 e4 fd ff ff       	call   800daf <sys_page_unmap>
  800fcb:	83 c4 10             	add    $0x10,%esp
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	75 40                	jne    801012 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  800fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  800fda:	83 ec 04             	sub    $0x4,%esp
  800fdd:	68 ea 2b 80 00       	push   $0x802bea
  800fe2:	6a 1f                	push   $0x1f
  800fe4:	68 08 2c 80 00       	push   $0x802c08
  800fe9:	e8 d2 14 00 00       	call   8024c0 <_panic>
	    panic("pgfault: %e", r);
  800fee:	50                   	push   %eax
  800fef:	68 13 2c 80 00       	push   $0x802c13
  800ff4:	6a 2a                	push   $0x2a
  800ff6:	68 08 2c 80 00       	push   $0x802c08
  800ffb:	e8 c0 14 00 00       	call   8024c0 <_panic>
	    panic("pgfault: %e", r);
  801000:	50                   	push   %eax
  801001:	68 13 2c 80 00       	push   $0x802c13
  801006:	6a 2e                	push   $0x2e
  801008:	68 08 2c 80 00       	push   $0x802c08
  80100d:	e8 ae 14 00 00       	call   8024c0 <_panic>
	    panic("pgfault: %e", r);
  801012:	50                   	push   %eax
  801013:	68 13 2c 80 00       	push   $0x802c13
  801018:	6a 31                	push   $0x31
  80101a:	68 08 2c 80 00       	push   $0x802c08
  80101f:	e8 9c 14 00 00       	call   8024c0 <_panic>

00801024 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	57                   	push   %edi
  801028:	56                   	push   %esi
  801029:	53                   	push   %ebx
  80102a:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  80102d:	68 3a 0f 80 00       	push   $0x800f3a
  801032:	e8 cf 14 00 00       	call   802506 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801037:	b8 07 00 00 00       	mov    $0x7,%eax
  80103c:	cd 30                	int    $0x30
  80103e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801041:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	78 2b                	js     801076 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80104b:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801050:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801054:	0f 85 b5 00 00 00    	jne    80110f <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  80105a:	e8 8d fc ff ff       	call   800cec <sys_getenvid>
  80105f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801064:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801067:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106c:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  801071:	e9 8c 01 00 00       	jmp    801202 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  801076:	50                   	push   %eax
  801077:	68 1f 2c 80 00       	push   $0x802c1f
  80107c:	6a 77                	push   $0x77
  80107e:	68 08 2c 80 00       	push   $0x802c08
  801083:	e8 38 14 00 00       	call   8024c0 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801088:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80108f:	83 ec 0c             	sub    $0xc,%esp
  801092:	25 07 0e 00 00       	and    $0xe07,%eax
  801097:	50                   	push   %eax
  801098:	57                   	push   %edi
  801099:	ff 75 e0             	pushl  -0x20(%ebp)
  80109c:	57                   	push   %edi
  80109d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a0:	e8 c8 fc ff ff       	call   800d6d <sys_page_map>
  8010a5:	83 c4 20             	add    $0x20,%esp
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	74 51                	je     8010fd <fork+0xd9>
           panic("duppage: %e", r);
  8010ac:	50                   	push   %eax
  8010ad:	68 2f 2c 80 00       	push   $0x802c2f
  8010b2:	6a 4a                	push   $0x4a
  8010b4:	68 08 2c 80 00       	push   $0x802c08
  8010b9:	e8 02 14 00 00       	call   8024c0 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  8010be:	83 ec 0c             	sub    $0xc,%esp
  8010c1:	68 05 08 00 00       	push   $0x805
  8010c6:	57                   	push   %edi
  8010c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8010ca:	57                   	push   %edi
  8010cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010ce:	e8 9a fc ff ff       	call   800d6d <sys_page_map>
  8010d3:	83 c4 20             	add    $0x20,%esp
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	0f 85 bc 00 00 00    	jne    80119a <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  8010de:	83 ec 0c             	sub    $0xc,%esp
  8010e1:	68 05 08 00 00       	push   $0x805
  8010e6:	57                   	push   %edi
  8010e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010ea:	50                   	push   %eax
  8010eb:	57                   	push   %edi
  8010ec:	50                   	push   %eax
  8010ed:	e8 7b fc ff ff       	call   800d6d <sys_page_map>
  8010f2:	83 c4 20             	add    $0x20,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	0f 85 af 00 00 00    	jne    8011ac <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801103:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801109:	0f 84 af 00 00 00    	je     8011be <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  80110f:	89 d8                	mov    %ebx,%eax
  801111:	c1 e8 16             	shr    $0x16,%eax
  801114:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80111b:	a8 01                	test   $0x1,%al
  80111d:	74 de                	je     8010fd <fork+0xd9>
  80111f:	89 de                	mov    %ebx,%esi
  801121:	c1 ee 0c             	shr    $0xc,%esi
  801124:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80112b:	a8 01                	test   $0x1,%al
  80112d:	74 ce                	je     8010fd <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  80112f:	e8 b8 fb ff ff       	call   800cec <sys_getenvid>
  801134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  801137:	89 f7                	mov    %esi,%edi
  801139:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  80113c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801143:	f6 c4 04             	test   $0x4,%ah
  801146:	0f 85 3c ff ff ff    	jne    801088 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  80114c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801153:	a8 02                	test   $0x2,%al
  801155:	0f 85 63 ff ff ff    	jne    8010be <fork+0x9a>
  80115b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801162:	f6 c4 08             	test   $0x8,%ah
  801165:	0f 85 53 ff ff ff    	jne    8010be <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	6a 05                	push   $0x5
  801170:	57                   	push   %edi
  801171:	ff 75 e0             	pushl  -0x20(%ebp)
  801174:	57                   	push   %edi
  801175:	ff 75 e4             	pushl  -0x1c(%ebp)
  801178:	e8 f0 fb ff ff       	call   800d6d <sys_page_map>
  80117d:	83 c4 20             	add    $0x20,%esp
  801180:	85 c0                	test   %eax,%eax
  801182:	0f 84 75 ff ff ff    	je     8010fd <fork+0xd9>
	        panic("duppage: %e", r);
  801188:	50                   	push   %eax
  801189:	68 2f 2c 80 00       	push   $0x802c2f
  80118e:	6a 55                	push   $0x55
  801190:	68 08 2c 80 00       	push   $0x802c08
  801195:	e8 26 13 00 00       	call   8024c0 <_panic>
	        panic("duppage: %e", r);
  80119a:	50                   	push   %eax
  80119b:	68 2f 2c 80 00       	push   $0x802c2f
  8011a0:	6a 4e                	push   $0x4e
  8011a2:	68 08 2c 80 00       	push   $0x802c08
  8011a7:	e8 14 13 00 00       	call   8024c0 <_panic>
	        panic("duppage: %e", r);
  8011ac:	50                   	push   %eax
  8011ad:	68 2f 2c 80 00       	push   $0x802c2f
  8011b2:	6a 51                	push   $0x51
  8011b4:	68 08 2c 80 00       	push   $0x802c08
  8011b9:	e8 02 13 00 00       	call   8024c0 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8011be:	83 ec 04             	sub    $0x4,%esp
  8011c1:	6a 07                	push   $0x7
  8011c3:	68 00 f0 bf ee       	push   $0xeebff000
  8011c8:	ff 75 dc             	pushl  -0x24(%ebp)
  8011cb:	e8 5a fb ff ff       	call   800d2a <sys_page_alloc>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	75 36                	jne    80120d <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	68 7f 25 80 00       	push   $0x80257f
  8011df:	ff 75 dc             	pushl  -0x24(%ebp)
  8011e2:	e8 8e fc ff ff       	call   800e75 <sys_env_set_pgfault_upcall>
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	75 34                	jne    801222 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	6a 02                	push   $0x2
  8011f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8011f6:	e8 f6 fb ff ff       	call   800df1 <sys_env_set_status>
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	75 35                	jne    801237 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801202:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801205:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801208:	5b                   	pop    %ebx
  801209:	5e                   	pop    %esi
  80120a:	5f                   	pop    %edi
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    
	    panic("fork: %e", r);
  80120d:	50                   	push   %eax
  80120e:	68 26 2c 80 00       	push   $0x802c26
  801213:	68 8a 00 00 00       	push   $0x8a
  801218:	68 08 2c 80 00       	push   $0x802c08
  80121d:	e8 9e 12 00 00       	call   8024c0 <_panic>
	    panic("fork: %e", r);
  801222:	50                   	push   %eax
  801223:	68 26 2c 80 00       	push   $0x802c26
  801228:	68 8d 00 00 00       	push   $0x8d
  80122d:	68 08 2c 80 00       	push   $0x802c08
  801232:	e8 89 12 00 00       	call   8024c0 <_panic>
	    panic("fork: %e", r);
  801237:	50                   	push   %eax
  801238:	68 26 2c 80 00       	push   $0x802c26
  80123d:	68 92 00 00 00       	push   $0x92
  801242:	68 08 2c 80 00       	push   $0x802c08
  801247:	e8 74 12 00 00       	call   8024c0 <_panic>

0080124c <sfork>:

// Challenge!
int
sfork(void)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801252:	68 3b 2c 80 00       	push   $0x802c3b
  801257:	68 9b 00 00 00       	push   $0x9b
  80125c:	68 08 2c 80 00       	push   $0x802c08
  801261:	e8 5a 12 00 00       	call   8024c0 <_panic>

00801266 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	56                   	push   %esi
  80126a:	53                   	push   %ebx
  80126b:	8b 75 08             	mov    0x8(%ebp),%esi
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801274:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801276:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80127b:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	50                   	push   %eax
  801282:	e8 53 fc ff ff       	call   800eda <sys_ipc_recv>
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 2b                	js     8012b9 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80128e:	85 f6                	test   %esi,%esi
  801290:	74 0a                	je     80129c <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801292:	a1 08 40 80 00       	mov    0x804008,%eax
  801297:	8b 40 74             	mov    0x74(%eax),%eax
  80129a:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80129c:	85 db                	test   %ebx,%ebx
  80129e:	74 0a                	je     8012aa <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8012a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a5:	8b 40 78             	mov    0x78(%eax),%eax
  8012a8:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8012aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8012af:	8b 40 70             	mov    0x70(%eax),%eax
}
  8012b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b5:	5b                   	pop    %ebx
  8012b6:	5e                   	pop    %esi
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    
	    if (from_env_store != NULL) {
  8012b9:	85 f6                	test   %esi,%esi
  8012bb:	74 06                	je     8012c3 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8012bd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8012c3:	85 db                	test   %ebx,%ebx
  8012c5:	74 eb                	je     8012b2 <ipc_recv+0x4c>
	        *perm_store = 0;
  8012c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8012cd:	eb e3                	jmp    8012b2 <ipc_recv+0x4c>

008012cf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	57                   	push   %edi
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012db:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8012de:	85 f6                	test   %esi,%esi
  8012e0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012e5:	0f 44 f0             	cmove  %eax,%esi
  8012e8:	eb 09                	jmp    8012f3 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8012ea:	e8 1c fa ff ff       	call   800d0b <sys_yield>
	} while(r != 0);
  8012ef:	85 db                	test   %ebx,%ebx
  8012f1:	74 2d                	je     801320 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8012f3:	ff 75 14             	pushl  0x14(%ebp)
  8012f6:	56                   	push   %esi
  8012f7:	ff 75 0c             	pushl  0xc(%ebp)
  8012fa:	57                   	push   %edi
  8012fb:	e8 b7 fb ff ff       	call   800eb7 <sys_ipc_try_send>
  801300:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	79 e1                	jns    8012ea <ipc_send+0x1b>
  801309:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80130c:	74 dc                	je     8012ea <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80130e:	50                   	push   %eax
  80130f:	68 51 2c 80 00       	push   $0x802c51
  801314:	6a 45                	push   $0x45
  801316:	68 5e 2c 80 00       	push   $0x802c5e
  80131b:	e8 a0 11 00 00       	call   8024c0 <_panic>
}
  801320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801323:	5b                   	pop    %ebx
  801324:	5e                   	pop    %esi
  801325:	5f                   	pop    %edi
  801326:	5d                   	pop    %ebp
  801327:	c3                   	ret    

00801328 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80132e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801333:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801336:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80133c:	8b 52 50             	mov    0x50(%edx),%edx
  80133f:	39 ca                	cmp    %ecx,%edx
  801341:	74 11                	je     801354 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801343:	83 c0 01             	add    $0x1,%eax
  801346:	3d 00 04 00 00       	cmp    $0x400,%eax
  80134b:	75 e6                	jne    801333 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 0b                	jmp    80135f <ipc_find_env+0x37>
			return envs[i].env_id;
  801354:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801357:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80135c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80135f:	5d                   	pop    %ebp
  801360:	c3                   	ret    

00801361 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	05 00 00 00 30       	add    $0x30000000,%eax
  80136c:	c1 e8 0c             	shr    $0xc,%eax
}
  80136f:	5d                   	pop    %ebp
  801370:	c3                   	ret    

00801371 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80137c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801381:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    

00801388 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801393:	89 c2                	mov    %eax,%edx
  801395:	c1 ea 16             	shr    $0x16,%edx
  801398:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80139f:	f6 c2 01             	test   $0x1,%dl
  8013a2:	74 2a                	je     8013ce <fd_alloc+0x46>
  8013a4:	89 c2                	mov    %eax,%edx
  8013a6:	c1 ea 0c             	shr    $0xc,%edx
  8013a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013b0:	f6 c2 01             	test   $0x1,%dl
  8013b3:	74 19                	je     8013ce <fd_alloc+0x46>
  8013b5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013ba:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013bf:	75 d2                	jne    801393 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013c1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013c7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013cc:	eb 07                	jmp    8013d5 <fd_alloc+0x4d>
			*fd_store = fd;
  8013ce:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d5:	5d                   	pop    %ebp
  8013d6:	c3                   	ret    

008013d7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013dd:	83 f8 1f             	cmp    $0x1f,%eax
  8013e0:	77 36                	ja     801418 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013e2:	c1 e0 0c             	shl    $0xc,%eax
  8013e5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ea:	89 c2                	mov    %eax,%edx
  8013ec:	c1 ea 16             	shr    $0x16,%edx
  8013ef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f6:	f6 c2 01             	test   $0x1,%dl
  8013f9:	74 24                	je     80141f <fd_lookup+0x48>
  8013fb:	89 c2                	mov    %eax,%edx
  8013fd:	c1 ea 0c             	shr    $0xc,%edx
  801400:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801407:	f6 c2 01             	test   $0x1,%dl
  80140a:	74 1a                	je     801426 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80140c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140f:	89 02                	mov    %eax,(%edx)
	return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    
		return -E_INVAL;
  801418:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141d:	eb f7                	jmp    801416 <fd_lookup+0x3f>
		return -E_INVAL;
  80141f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801424:	eb f0                	jmp    801416 <fd_lookup+0x3f>
  801426:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142b:	eb e9                	jmp    801416 <fd_lookup+0x3f>

0080142d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801436:	ba e4 2c 80 00       	mov    $0x802ce4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80143b:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801440:	39 08                	cmp    %ecx,(%eax)
  801442:	74 33                	je     801477 <dev_lookup+0x4a>
  801444:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801447:	8b 02                	mov    (%edx),%eax
  801449:	85 c0                	test   %eax,%eax
  80144b:	75 f3                	jne    801440 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80144d:	a1 08 40 80 00       	mov    0x804008,%eax
  801452:	8b 40 48             	mov    0x48(%eax),%eax
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	51                   	push   %ecx
  801459:	50                   	push   %eax
  80145a:	68 68 2c 80 00       	push   $0x802c68
  80145f:	e8 30 ee ff ff       	call   800294 <cprintf>
	*dev = 0;
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    
			*dev = devtab[i];
  801477:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80147c:	b8 00 00 00 00       	mov    $0x0,%eax
  801481:	eb f2                	jmp    801475 <dev_lookup+0x48>

00801483 <fd_close>:
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	57                   	push   %edi
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
  801489:	83 ec 1c             	sub    $0x1c,%esp
  80148c:	8b 75 08             	mov    0x8(%ebp),%esi
  80148f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801492:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801495:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801496:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80149c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80149f:	50                   	push   %eax
  8014a0:	e8 32 ff ff ff       	call   8013d7 <fd_lookup>
  8014a5:	89 c3                	mov    %eax,%ebx
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 05                	js     8014b3 <fd_close+0x30>
	    || fd != fd2)
  8014ae:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014b1:	74 16                	je     8014c9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014b3:	89 f8                	mov    %edi,%eax
  8014b5:	84 c0                	test   %al,%al
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bc:	0f 44 d8             	cmove  %eax,%ebx
}
  8014bf:	89 d8                	mov    %ebx,%eax
  8014c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c4:	5b                   	pop    %ebx
  8014c5:	5e                   	pop    %esi
  8014c6:	5f                   	pop    %edi
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014cf:	50                   	push   %eax
  8014d0:	ff 36                	pushl  (%esi)
  8014d2:	e8 56 ff ff ff       	call   80142d <dev_lookup>
  8014d7:	89 c3                	mov    %eax,%ebx
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 15                	js     8014f5 <fd_close+0x72>
		if (dev->dev_close)
  8014e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e3:	8b 40 10             	mov    0x10(%eax),%eax
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	74 1b                	je     801505 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8014ea:	83 ec 0c             	sub    $0xc,%esp
  8014ed:	56                   	push   %esi
  8014ee:	ff d0                	call   *%eax
  8014f0:	89 c3                	mov    %eax,%ebx
  8014f2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014f5:	83 ec 08             	sub    $0x8,%esp
  8014f8:	56                   	push   %esi
  8014f9:	6a 00                	push   $0x0
  8014fb:	e8 af f8 ff ff       	call   800daf <sys_page_unmap>
	return r;
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	eb ba                	jmp    8014bf <fd_close+0x3c>
			r = 0;
  801505:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150a:	eb e9                	jmp    8014f5 <fd_close+0x72>

0080150c <close>:

int
close(int fdnum)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801512:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 b9 fe ff ff       	call   8013d7 <fd_lookup>
  80151e:	83 c4 08             	add    $0x8,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 10                	js     801535 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	6a 01                	push   $0x1
  80152a:	ff 75 f4             	pushl  -0xc(%ebp)
  80152d:	e8 51 ff ff ff       	call   801483 <fd_close>
  801532:	83 c4 10             	add    $0x10,%esp
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <close_all>:

void
close_all(void)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	53                   	push   %ebx
  80153b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80153e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	53                   	push   %ebx
  801547:	e8 c0 ff ff ff       	call   80150c <close>
	for (i = 0; i < MAXFD; i++)
  80154c:	83 c3 01             	add    $0x1,%ebx
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	83 fb 20             	cmp    $0x20,%ebx
  801555:	75 ec                	jne    801543 <close_all+0xc>
}
  801557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	57                   	push   %edi
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801565:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801568:	50                   	push   %eax
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	e8 66 fe ff ff       	call   8013d7 <fd_lookup>
  801571:	89 c3                	mov    %eax,%ebx
  801573:	83 c4 08             	add    $0x8,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	0f 88 81 00 00 00    	js     8015ff <dup+0xa3>
		return r;
	close(newfdnum);
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	ff 75 0c             	pushl  0xc(%ebp)
  801584:	e8 83 ff ff ff       	call   80150c <close>

	newfd = INDEX2FD(newfdnum);
  801589:	8b 75 0c             	mov    0xc(%ebp),%esi
  80158c:	c1 e6 0c             	shl    $0xc,%esi
  80158f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	ff 75 e4             	pushl  -0x1c(%ebp)
  80159b:	e8 d1 fd ff ff       	call   801371 <fd2data>
  8015a0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015a2:	89 34 24             	mov    %esi,(%esp)
  8015a5:	e8 c7 fd ff ff       	call   801371 <fd2data>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015af:	89 d8                	mov    %ebx,%eax
  8015b1:	c1 e8 16             	shr    $0x16,%eax
  8015b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015bb:	a8 01                	test   $0x1,%al
  8015bd:	74 11                	je     8015d0 <dup+0x74>
  8015bf:	89 d8                	mov    %ebx,%eax
  8015c1:	c1 e8 0c             	shr    $0xc,%eax
  8015c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015cb:	f6 c2 01             	test   $0x1,%dl
  8015ce:	75 39                	jne    801609 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015d3:	89 d0                	mov    %edx,%eax
  8015d5:	c1 e8 0c             	shr    $0xc,%eax
  8015d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015df:	83 ec 0c             	sub    $0xc,%esp
  8015e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8015e7:	50                   	push   %eax
  8015e8:	56                   	push   %esi
  8015e9:	6a 00                	push   $0x0
  8015eb:	52                   	push   %edx
  8015ec:	6a 00                	push   $0x0
  8015ee:	e8 7a f7 ff ff       	call   800d6d <sys_page_map>
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 20             	add    $0x20,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 31                	js     80162d <dup+0xd1>
		goto err;

	return newfdnum;
  8015fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015ff:	89 d8                	mov    %ebx,%eax
  801601:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801604:	5b                   	pop    %ebx
  801605:	5e                   	pop    %esi
  801606:	5f                   	pop    %edi
  801607:	5d                   	pop    %ebp
  801608:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801609:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	25 07 0e 00 00       	and    $0xe07,%eax
  801618:	50                   	push   %eax
  801619:	57                   	push   %edi
  80161a:	6a 00                	push   $0x0
  80161c:	53                   	push   %ebx
  80161d:	6a 00                	push   $0x0
  80161f:	e8 49 f7 ff ff       	call   800d6d <sys_page_map>
  801624:	89 c3                	mov    %eax,%ebx
  801626:	83 c4 20             	add    $0x20,%esp
  801629:	85 c0                	test   %eax,%eax
  80162b:	79 a3                	jns    8015d0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	56                   	push   %esi
  801631:	6a 00                	push   $0x0
  801633:	e8 77 f7 ff ff       	call   800daf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801638:	83 c4 08             	add    $0x8,%esp
  80163b:	57                   	push   %edi
  80163c:	6a 00                	push   $0x0
  80163e:	e8 6c f7 ff ff       	call   800daf <sys_page_unmap>
	return r;
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	eb b7                	jmp    8015ff <dup+0xa3>

00801648 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	53                   	push   %ebx
  80164c:	83 ec 14             	sub    $0x14,%esp
  80164f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801652:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	53                   	push   %ebx
  801657:	e8 7b fd ff ff       	call   8013d7 <fd_lookup>
  80165c:	83 c4 08             	add    $0x8,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 3f                	js     8016a2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801669:	50                   	push   %eax
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	ff 30                	pushl  (%eax)
  80166f:	e8 b9 fd ff ff       	call   80142d <dev_lookup>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 27                	js     8016a2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80167b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167e:	8b 42 08             	mov    0x8(%edx),%eax
  801681:	83 e0 03             	and    $0x3,%eax
  801684:	83 f8 01             	cmp    $0x1,%eax
  801687:	74 1e                	je     8016a7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168c:	8b 40 08             	mov    0x8(%eax),%eax
  80168f:	85 c0                	test   %eax,%eax
  801691:	74 35                	je     8016c8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	ff 75 10             	pushl  0x10(%ebp)
  801699:	ff 75 0c             	pushl  0xc(%ebp)
  80169c:	52                   	push   %edx
  80169d:	ff d0                	call   *%eax
  80169f:	83 c4 10             	add    $0x10,%esp
}
  8016a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8016ac:	8b 40 48             	mov    0x48(%eax),%eax
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	53                   	push   %ebx
  8016b3:	50                   	push   %eax
  8016b4:	68 a9 2c 80 00       	push   $0x802ca9
  8016b9:	e8 d6 eb ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c6:	eb da                	jmp    8016a2 <read+0x5a>
		return -E_NOT_SUPP;
  8016c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cd:	eb d3                	jmp    8016a2 <read+0x5a>

008016cf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	57                   	push   %edi
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 0c             	sub    $0xc,%esp
  8016d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016db:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016e3:	39 f3                	cmp    %esi,%ebx
  8016e5:	73 25                	jae    80170c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	89 f0                	mov    %esi,%eax
  8016ec:	29 d8                	sub    %ebx,%eax
  8016ee:	50                   	push   %eax
  8016ef:	89 d8                	mov    %ebx,%eax
  8016f1:	03 45 0c             	add    0xc(%ebp),%eax
  8016f4:	50                   	push   %eax
  8016f5:	57                   	push   %edi
  8016f6:	e8 4d ff ff ff       	call   801648 <read>
		if (m < 0)
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 08                	js     80170a <readn+0x3b>
			return m;
		if (m == 0)
  801702:	85 c0                	test   %eax,%eax
  801704:	74 06                	je     80170c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801706:	01 c3                	add    %eax,%ebx
  801708:	eb d9                	jmp    8016e3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80170a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80170c:	89 d8                	mov    %ebx,%eax
  80170e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5f                   	pop    %edi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    

00801716 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	53                   	push   %ebx
  80171a:	83 ec 14             	sub    $0x14,%esp
  80171d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801720:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801723:	50                   	push   %eax
  801724:	53                   	push   %ebx
  801725:	e8 ad fc ff ff       	call   8013d7 <fd_lookup>
  80172a:	83 c4 08             	add    $0x8,%esp
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 3a                	js     80176b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801737:	50                   	push   %eax
  801738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173b:	ff 30                	pushl  (%eax)
  80173d:	e8 eb fc ff ff       	call   80142d <dev_lookup>
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	85 c0                	test   %eax,%eax
  801747:	78 22                	js     80176b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801750:	74 1e                	je     801770 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801755:	8b 52 0c             	mov    0xc(%edx),%edx
  801758:	85 d2                	test   %edx,%edx
  80175a:	74 35                	je     801791 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	ff 75 10             	pushl  0x10(%ebp)
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	50                   	push   %eax
  801766:	ff d2                	call   *%edx
  801768:	83 c4 10             	add    $0x10,%esp
}
  80176b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801770:	a1 08 40 80 00       	mov    0x804008,%eax
  801775:	8b 40 48             	mov    0x48(%eax),%eax
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	53                   	push   %ebx
  80177c:	50                   	push   %eax
  80177d:	68 c5 2c 80 00       	push   $0x802cc5
  801782:	e8 0d eb ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178f:	eb da                	jmp    80176b <write+0x55>
		return -E_NOT_SUPP;
  801791:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801796:	eb d3                	jmp    80176b <write+0x55>

00801798 <seek>:

int
seek(int fdnum, off_t offset)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80179e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017a1:	50                   	push   %eax
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	e8 2d fc ff ff       	call   8013d7 <fd_lookup>
  8017aa:	83 c4 08             	add    $0x8,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 0e                	js     8017bf <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	53                   	push   %ebx
  8017c5:	83 ec 14             	sub    $0x14,%esp
  8017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	53                   	push   %ebx
  8017d0:	e8 02 fc ff ff       	call   8013d7 <fd_lookup>
  8017d5:	83 c4 08             	add    $0x8,%esp
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	78 37                	js     801813 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e6:	ff 30                	pushl  (%eax)
  8017e8:	e8 40 fc ff ff       	call   80142d <dev_lookup>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 1f                	js     801813 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017fb:	74 1b                	je     801818 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801800:	8b 52 18             	mov    0x18(%edx),%edx
  801803:	85 d2                	test   %edx,%edx
  801805:	74 32                	je     801839 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801807:	83 ec 08             	sub    $0x8,%esp
  80180a:	ff 75 0c             	pushl  0xc(%ebp)
  80180d:	50                   	push   %eax
  80180e:	ff d2                	call   *%edx
  801810:	83 c4 10             	add    $0x10,%esp
}
  801813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801816:	c9                   	leave  
  801817:	c3                   	ret    
			thisenv->env_id, fdnum);
  801818:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80181d:	8b 40 48             	mov    0x48(%eax),%eax
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	53                   	push   %ebx
  801824:	50                   	push   %eax
  801825:	68 88 2c 80 00       	push   $0x802c88
  80182a:	e8 65 ea ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801837:	eb da                	jmp    801813 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801839:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80183e:	eb d3                	jmp    801813 <ftruncate+0x52>

00801840 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	53                   	push   %ebx
  801844:	83 ec 14             	sub    $0x14,%esp
  801847:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184d:	50                   	push   %eax
  80184e:	ff 75 08             	pushl  0x8(%ebp)
  801851:	e8 81 fb ff ff       	call   8013d7 <fd_lookup>
  801856:	83 c4 08             	add    $0x8,%esp
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 4b                	js     8018a8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185d:	83 ec 08             	sub    $0x8,%esp
  801860:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801863:	50                   	push   %eax
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801867:	ff 30                	pushl  (%eax)
  801869:	e8 bf fb ff ff       	call   80142d <dev_lookup>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	78 33                	js     8018a8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801878:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80187c:	74 2f                	je     8018ad <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80187e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801881:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801888:	00 00 00 
	stat->st_isdir = 0;
  80188b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801892:	00 00 00 
	stat->st_dev = dev;
  801895:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	53                   	push   %ebx
  80189f:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a2:	ff 50 14             	call   *0x14(%eax)
  8018a5:	83 c4 10             	add    $0x10,%esp
}
  8018a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b2:	eb f4                	jmp    8018a8 <fstat+0x68>

008018b4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	6a 00                	push   $0x0
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	e8 26 02 00 00       	call   801aec <open>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 1b                	js     8018ea <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	50                   	push   %eax
  8018d6:	e8 65 ff ff ff       	call   801840 <fstat>
  8018db:	89 c6                	mov    %eax,%esi
	close(fd);
  8018dd:	89 1c 24             	mov    %ebx,(%esp)
  8018e0:	e8 27 fc ff ff       	call   80150c <close>
	return r;
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	89 f3                	mov    %esi,%ebx
}
  8018ea:	89 d8                	mov    %ebx,%eax
  8018ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5e                   	pop    %esi
  8018f1:	5d                   	pop    %ebp
  8018f2:	c3                   	ret    

008018f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	56                   	push   %esi
  8018f7:	53                   	push   %ebx
  8018f8:	89 c6                	mov    %eax,%esi
  8018fa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018fc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801903:	74 27                	je     80192c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801905:	6a 07                	push   $0x7
  801907:	68 00 50 80 00       	push   $0x805000
  80190c:	56                   	push   %esi
  80190d:	ff 35 00 40 80 00    	pushl  0x804000
  801913:	e8 b7 f9 ff ff       	call   8012cf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801918:	83 c4 0c             	add    $0xc,%esp
  80191b:	6a 00                	push   $0x0
  80191d:	53                   	push   %ebx
  80191e:	6a 00                	push   $0x0
  801920:	e8 41 f9 ff ff       	call   801266 <ipc_recv>
}
  801925:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801928:	5b                   	pop    %ebx
  801929:	5e                   	pop    %esi
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80192c:	83 ec 0c             	sub    $0xc,%esp
  80192f:	6a 01                	push   $0x1
  801931:	e8 f2 f9 ff ff       	call   801328 <ipc_find_env>
  801936:	a3 00 40 80 00       	mov    %eax,0x804000
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	eb c5                	jmp    801905 <fsipc+0x12>

00801940 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	8b 40 0c             	mov    0xc(%eax),%eax
  80194c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801959:	ba 00 00 00 00       	mov    $0x0,%edx
  80195e:	b8 02 00 00 00       	mov    $0x2,%eax
  801963:	e8 8b ff ff ff       	call   8018f3 <fsipc>
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <devfile_flush>:
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8b 40 0c             	mov    0xc(%eax),%eax
  801976:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80197b:	ba 00 00 00 00       	mov    $0x0,%edx
  801980:	b8 06 00 00 00       	mov    $0x6,%eax
  801985:	e8 69 ff ff ff       	call   8018f3 <fsipc>
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <devfile_stat>:
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	53                   	push   %ebx
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8b 40 0c             	mov    0xc(%eax),%eax
  80199c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a6:	b8 05 00 00 00       	mov    $0x5,%eax
  8019ab:	e8 43 ff ff ff       	call   8018f3 <fsipc>
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	78 2c                	js     8019e0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019b4:	83 ec 08             	sub    $0x8,%esp
  8019b7:	68 00 50 80 00       	push   $0x805000
  8019bc:	53                   	push   %ebx
  8019bd:	e8 6f ef ff ff       	call   800931 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019c2:	a1 80 50 80 00       	mov    0x805080,%eax
  8019c7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019cd:	a1 84 50 80 00       	mov    0x805084,%eax
  8019d2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <devfile_write>:
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019fa:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a00:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a06:	77 30                	ja     801a38 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	53                   	push   %ebx
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	68 08 50 80 00       	push   $0x805008
  801a14:	e8 a6 f0 ff ff       	call   800abf <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	b8 04 00 00 00       	mov    $0x4,%eax
  801a23:	e8 cb fe ff ff       	call   8018f3 <fsipc>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 04                	js     801a33 <devfile_write+0x4e>
	assert(r <= n);
  801a2f:	39 d8                	cmp    %ebx,%eax
  801a31:	77 1e                	ja     801a51 <devfile_write+0x6c>
}
  801a33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a38:	68 f8 2c 80 00       	push   $0x802cf8
  801a3d:	68 25 2d 80 00       	push   $0x802d25
  801a42:	68 94 00 00 00       	push   $0x94
  801a47:	68 3a 2d 80 00       	push   $0x802d3a
  801a4c:	e8 6f 0a 00 00       	call   8024c0 <_panic>
	assert(r <= n);
  801a51:	68 45 2d 80 00       	push   $0x802d45
  801a56:	68 25 2d 80 00       	push   $0x802d25
  801a5b:	68 98 00 00 00       	push   $0x98
  801a60:	68 3a 2d 80 00       	push   $0x802d3a
  801a65:	e8 56 0a 00 00       	call   8024c0 <_panic>

00801a6a <devfile_read>:
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	8b 40 0c             	mov    0xc(%eax),%eax
  801a78:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a7d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a83:	ba 00 00 00 00       	mov    $0x0,%edx
  801a88:	b8 03 00 00 00       	mov    $0x3,%eax
  801a8d:	e8 61 fe ff ff       	call   8018f3 <fsipc>
  801a92:	89 c3                	mov    %eax,%ebx
  801a94:	85 c0                	test   %eax,%eax
  801a96:	78 1f                	js     801ab7 <devfile_read+0x4d>
	assert(r <= n);
  801a98:	39 f0                	cmp    %esi,%eax
  801a9a:	77 24                	ja     801ac0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a9c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa1:	7f 33                	jg     801ad6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	50                   	push   %eax
  801aa7:	68 00 50 80 00       	push   $0x805000
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	e8 0b f0 ff ff       	call   800abf <memmove>
	return r;
  801ab4:	83 c4 10             	add    $0x10,%esp
}
  801ab7:	89 d8                	mov    %ebx,%eax
  801ab9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abc:	5b                   	pop    %ebx
  801abd:	5e                   	pop    %esi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
	assert(r <= n);
  801ac0:	68 45 2d 80 00       	push   $0x802d45
  801ac5:	68 25 2d 80 00       	push   $0x802d25
  801aca:	6a 7c                	push   $0x7c
  801acc:	68 3a 2d 80 00       	push   $0x802d3a
  801ad1:	e8 ea 09 00 00       	call   8024c0 <_panic>
	assert(r <= PGSIZE);
  801ad6:	68 4c 2d 80 00       	push   $0x802d4c
  801adb:	68 25 2d 80 00       	push   $0x802d25
  801ae0:	6a 7d                	push   $0x7d
  801ae2:	68 3a 2d 80 00       	push   $0x802d3a
  801ae7:	e8 d4 09 00 00       	call   8024c0 <_panic>

00801aec <open>:
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	56                   	push   %esi
  801af0:	53                   	push   %ebx
  801af1:	83 ec 1c             	sub    $0x1c,%esp
  801af4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801af7:	56                   	push   %esi
  801af8:	e8 fd ed ff ff       	call   8008fa <strlen>
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b05:	7f 6c                	jg     801b73 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0d:	50                   	push   %eax
  801b0e:	e8 75 f8 ff ff       	call   801388 <fd_alloc>
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	83 c4 10             	add    $0x10,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 3c                	js     801b58 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b1c:	83 ec 08             	sub    $0x8,%esp
  801b1f:	56                   	push   %esi
  801b20:	68 00 50 80 00       	push   $0x805000
  801b25:	e8 07 ee ff ff       	call   800931 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b35:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3a:	e8 b4 fd ff ff       	call   8018f3 <fsipc>
  801b3f:	89 c3                	mov    %eax,%ebx
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	85 c0                	test   %eax,%eax
  801b46:	78 19                	js     801b61 <open+0x75>
	return fd2num(fd);
  801b48:	83 ec 0c             	sub    $0xc,%esp
  801b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4e:	e8 0e f8 ff ff       	call   801361 <fd2num>
  801b53:	89 c3                	mov    %eax,%ebx
  801b55:	83 c4 10             	add    $0x10,%esp
}
  801b58:	89 d8                	mov    %ebx,%eax
  801b5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    
		fd_close(fd, 0);
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	6a 00                	push   $0x0
  801b66:	ff 75 f4             	pushl  -0xc(%ebp)
  801b69:	e8 15 f9 ff ff       	call   801483 <fd_close>
		return r;
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	eb e5                	jmp    801b58 <open+0x6c>
		return -E_BAD_PATH;
  801b73:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b78:	eb de                	jmp    801b58 <open+0x6c>

00801b7a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b80:	ba 00 00 00 00       	mov    $0x0,%edx
  801b85:	b8 08 00 00 00       	mov    $0x8,%eax
  801b8a:	e8 64 fd ff ff       	call   8018f3 <fsipc>
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	56                   	push   %esi
  801b95:	53                   	push   %ebx
  801b96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	e8 cd f7 ff ff       	call   801371 <fd2data>
  801ba4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ba6:	83 c4 08             	add    $0x8,%esp
  801ba9:	68 58 2d 80 00       	push   $0x802d58
  801bae:	53                   	push   %ebx
  801baf:	e8 7d ed ff ff       	call   800931 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bb4:	8b 46 04             	mov    0x4(%esi),%eax
  801bb7:	2b 06                	sub    (%esi),%eax
  801bb9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bbf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc6:	00 00 00 
	stat->st_dev = &devpipe;
  801bc9:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801bd0:	30 80 00 
	return 0;
}
  801bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	53                   	push   %ebx
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801be9:	53                   	push   %ebx
  801bea:	6a 00                	push   $0x0
  801bec:	e8 be f1 ff ff       	call   800daf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bf1:	89 1c 24             	mov    %ebx,(%esp)
  801bf4:	e8 78 f7 ff ff       	call   801371 <fd2data>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	50                   	push   %eax
  801bfd:	6a 00                	push   $0x0
  801bff:	e8 ab f1 ff ff       	call   800daf <sys_page_unmap>
}
  801c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <_pipeisclosed>:
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	57                   	push   %edi
  801c0d:	56                   	push   %esi
  801c0e:	53                   	push   %ebx
  801c0f:	83 ec 1c             	sub    $0x1c,%esp
  801c12:	89 c7                	mov    %eax,%edi
  801c14:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c16:	a1 08 40 80 00       	mov    0x804008,%eax
  801c1b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	57                   	push   %edi
  801c22:	e8 7e 09 00 00       	call   8025a5 <pageref>
  801c27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c2a:	89 34 24             	mov    %esi,(%esp)
  801c2d:	e8 73 09 00 00       	call   8025a5 <pageref>
		nn = thisenv->env_runs;
  801c32:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c38:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	39 cb                	cmp    %ecx,%ebx
  801c40:	74 1b                	je     801c5d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c42:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c45:	75 cf                	jne    801c16 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c47:	8b 42 58             	mov    0x58(%edx),%eax
  801c4a:	6a 01                	push   $0x1
  801c4c:	50                   	push   %eax
  801c4d:	53                   	push   %ebx
  801c4e:	68 5f 2d 80 00       	push   $0x802d5f
  801c53:	e8 3c e6 ff ff       	call   800294 <cprintf>
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	eb b9                	jmp    801c16 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c5d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c60:	0f 94 c0             	sete   %al
  801c63:	0f b6 c0             	movzbl %al,%eax
}
  801c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5f                   	pop    %edi
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    

00801c6e <devpipe_write>:
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 28             	sub    $0x28,%esp
  801c77:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c7a:	56                   	push   %esi
  801c7b:	e8 f1 f6 ff ff       	call   801371 <fd2data>
  801c80:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c8d:	74 4f                	je     801cde <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c8f:	8b 43 04             	mov    0x4(%ebx),%eax
  801c92:	8b 0b                	mov    (%ebx),%ecx
  801c94:	8d 51 20             	lea    0x20(%ecx),%edx
  801c97:	39 d0                	cmp    %edx,%eax
  801c99:	72 14                	jb     801caf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c9b:	89 da                	mov    %ebx,%edx
  801c9d:	89 f0                	mov    %esi,%eax
  801c9f:	e8 65 ff ff ff       	call   801c09 <_pipeisclosed>
  801ca4:	85 c0                	test   %eax,%eax
  801ca6:	75 3a                	jne    801ce2 <devpipe_write+0x74>
			sys_yield();
  801ca8:	e8 5e f0 ff ff       	call   800d0b <sys_yield>
  801cad:	eb e0                	jmp    801c8f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cb6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cb9:	89 c2                	mov    %eax,%edx
  801cbb:	c1 fa 1f             	sar    $0x1f,%edx
  801cbe:	89 d1                	mov    %edx,%ecx
  801cc0:	c1 e9 1b             	shr    $0x1b,%ecx
  801cc3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cc6:	83 e2 1f             	and    $0x1f,%edx
  801cc9:	29 ca                	sub    %ecx,%edx
  801ccb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ccf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cd3:	83 c0 01             	add    $0x1,%eax
  801cd6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cd9:	83 c7 01             	add    $0x1,%edi
  801cdc:	eb ac                	jmp    801c8a <devpipe_write+0x1c>
	return i;
  801cde:	89 f8                	mov    %edi,%eax
  801ce0:	eb 05                	jmp    801ce7 <devpipe_write+0x79>
				return 0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <devpipe_read>:
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	57                   	push   %edi
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 18             	sub    $0x18,%esp
  801cf8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cfb:	57                   	push   %edi
  801cfc:	e8 70 f6 ff ff       	call   801371 <fd2data>
  801d01:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	be 00 00 00 00       	mov    $0x0,%esi
  801d0b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d0e:	74 47                	je     801d57 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d10:	8b 03                	mov    (%ebx),%eax
  801d12:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d15:	75 22                	jne    801d39 <devpipe_read+0x4a>
			if (i > 0)
  801d17:	85 f6                	test   %esi,%esi
  801d19:	75 14                	jne    801d2f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d1b:	89 da                	mov    %ebx,%edx
  801d1d:	89 f8                	mov    %edi,%eax
  801d1f:	e8 e5 fe ff ff       	call   801c09 <_pipeisclosed>
  801d24:	85 c0                	test   %eax,%eax
  801d26:	75 33                	jne    801d5b <devpipe_read+0x6c>
			sys_yield();
  801d28:	e8 de ef ff ff       	call   800d0b <sys_yield>
  801d2d:	eb e1                	jmp    801d10 <devpipe_read+0x21>
				return i;
  801d2f:	89 f0                	mov    %esi,%eax
}
  801d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d39:	99                   	cltd   
  801d3a:	c1 ea 1b             	shr    $0x1b,%edx
  801d3d:	01 d0                	add    %edx,%eax
  801d3f:	83 e0 1f             	and    $0x1f,%eax
  801d42:	29 d0                	sub    %edx,%eax
  801d44:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d4c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d4f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d52:	83 c6 01             	add    $0x1,%esi
  801d55:	eb b4                	jmp    801d0b <devpipe_read+0x1c>
	return i;
  801d57:	89 f0                	mov    %esi,%eax
  801d59:	eb d6                	jmp    801d31 <devpipe_read+0x42>
				return 0;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d60:	eb cf                	jmp    801d31 <devpipe_read+0x42>

00801d62 <pipe>:
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	56                   	push   %esi
  801d66:	53                   	push   %ebx
  801d67:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6d:	50                   	push   %eax
  801d6e:	e8 15 f6 ff ff       	call   801388 <fd_alloc>
  801d73:	89 c3                	mov    %eax,%ebx
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 5b                	js     801dd7 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	68 07 04 00 00       	push   $0x407
  801d84:	ff 75 f4             	pushl  -0xc(%ebp)
  801d87:	6a 00                	push   $0x0
  801d89:	e8 9c ef ff ff       	call   800d2a <sys_page_alloc>
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	85 c0                	test   %eax,%eax
  801d95:	78 40                	js     801dd7 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	e8 e5 f5 ff ff       	call   801388 <fd_alloc>
  801da3:	89 c3                	mov    %eax,%ebx
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 1b                	js     801dc7 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	68 07 04 00 00       	push   $0x407
  801db4:	ff 75 f0             	pushl  -0x10(%ebp)
  801db7:	6a 00                	push   $0x0
  801db9:	e8 6c ef ff ff       	call   800d2a <sys_page_alloc>
  801dbe:	89 c3                	mov    %eax,%ebx
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	79 19                	jns    801de0 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 f4             	pushl  -0xc(%ebp)
  801dcd:	6a 00                	push   $0x0
  801dcf:	e8 db ef ff ff       	call   800daf <sys_page_unmap>
  801dd4:	83 c4 10             	add    $0x10,%esp
}
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ddc:	5b                   	pop    %ebx
  801ddd:	5e                   	pop    %esi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
	va = fd2data(fd0);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff 75 f4             	pushl  -0xc(%ebp)
  801de6:	e8 86 f5 ff ff       	call   801371 <fd2data>
  801deb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ded:	83 c4 0c             	add    $0xc,%esp
  801df0:	68 07 04 00 00       	push   $0x407
  801df5:	50                   	push   %eax
  801df6:	6a 00                	push   $0x0
  801df8:	e8 2d ef ff ff       	call   800d2a <sys_page_alloc>
  801dfd:	89 c3                	mov    %eax,%ebx
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	85 c0                	test   %eax,%eax
  801e04:	0f 88 8c 00 00 00    	js     801e96 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0a:	83 ec 0c             	sub    $0xc,%esp
  801e0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e10:	e8 5c f5 ff ff       	call   801371 <fd2data>
  801e15:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e1c:	50                   	push   %eax
  801e1d:	6a 00                	push   $0x0
  801e1f:	56                   	push   %esi
  801e20:	6a 00                	push   $0x0
  801e22:	e8 46 ef ff ff       	call   800d6d <sys_page_map>
  801e27:	89 c3                	mov    %eax,%ebx
  801e29:	83 c4 20             	add    $0x20,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 58                	js     801e88 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801e39:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801e4e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e60:	e8 fc f4 ff ff       	call   801361 <fd2num>
  801e65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e68:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e6a:	83 c4 04             	add    $0x4,%esp
  801e6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e70:	e8 ec f4 ff ff       	call   801361 <fd2num>
  801e75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e78:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e83:	e9 4f ff ff ff       	jmp    801dd7 <pipe+0x75>
	sys_page_unmap(0, va);
  801e88:	83 ec 08             	sub    $0x8,%esp
  801e8b:	56                   	push   %esi
  801e8c:	6a 00                	push   $0x0
  801e8e:	e8 1c ef ff ff       	call   800daf <sys_page_unmap>
  801e93:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e96:	83 ec 08             	sub    $0x8,%esp
  801e99:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 0c ef ff ff       	call   800daf <sys_page_unmap>
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	e9 1c ff ff ff       	jmp    801dc7 <pipe+0x65>

00801eab <pipeisclosed>:
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb4:	50                   	push   %eax
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	e8 1a f5 ff ff       	call   8013d7 <fd_lookup>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 18                	js     801edc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eca:	e8 a2 f4 ff ff       	call   801371 <fd2data>
	return _pipeisclosed(fd, p);
  801ecf:	89 c2                	mov    %eax,%edx
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	e8 30 fd ff ff       	call   801c09 <_pipeisclosed>
  801ed9:	83 c4 10             	add    $0x10,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ee4:	68 77 2d 80 00       	push   $0x802d77
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	e8 40 ea ff ff       	call   800931 <strcpy>
	return 0;
}
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <devsock_close>:
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	53                   	push   %ebx
  801efc:	83 ec 10             	sub    $0x10,%esp
  801eff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f02:	53                   	push   %ebx
  801f03:	e8 9d 06 00 00       	call   8025a5 <pageref>
  801f08:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f0b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f10:	83 f8 01             	cmp    $0x1,%eax
  801f13:	74 07                	je     801f1c <devsock_close+0x24>
}
  801f15:	89 d0                	mov    %edx,%eax
  801f17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	ff 73 0c             	pushl  0xc(%ebx)
  801f22:	e8 b7 02 00 00       	call   8021de <nsipc_close>
  801f27:	89 c2                	mov    %eax,%edx
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	eb e7                	jmp    801f15 <devsock_close+0x1d>

00801f2e <devsock_write>:
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	ff 75 10             	pushl  0x10(%ebp)
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	ff 70 0c             	pushl  0xc(%eax)
  801f42:	e8 74 03 00 00       	call   8022bb <nsipc_send>
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <devsock_read>:
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	ff 75 10             	pushl  0x10(%ebp)
  801f54:	ff 75 0c             	pushl  0xc(%ebp)
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	ff 70 0c             	pushl  0xc(%eax)
  801f5d:	e8 ed 02 00 00       	call   80224f <nsipc_recv>
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <fd2sockid>:
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f6a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f6d:	52                   	push   %edx
  801f6e:	50                   	push   %eax
  801f6f:	e8 63 f4 ff ff       	call   8013d7 <fd_lookup>
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	85 c0                	test   %eax,%eax
  801f79:	78 10                	js     801f8b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 0d 44 30 80 00    	mov    0x803044,%ecx
  801f84:	39 08                	cmp    %ecx,(%eax)
  801f86:	75 05                	jne    801f8d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f88:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    
		return -E_NOT_SUPP;
  801f8d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f92:	eb f7                	jmp    801f8b <fd2sockid+0x27>

00801f94 <alloc_sockfd>:
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	56                   	push   %esi
  801f98:	53                   	push   %ebx
  801f99:	83 ec 1c             	sub    $0x1c,%esp
  801f9c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa1:	50                   	push   %eax
  801fa2:	e8 e1 f3 ff ff       	call   801388 <fd_alloc>
  801fa7:	89 c3                	mov    %eax,%ebx
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 43                	js     801ff3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 07 04 00 00       	push   $0x407
  801fb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbb:	6a 00                	push   $0x0
  801fbd:	e8 68 ed ff ff       	call   800d2a <sys_page_alloc>
  801fc2:	89 c3                	mov    %eax,%ebx
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	78 28                	js     801ff3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 15 44 30 80 00    	mov    0x803044,%edx
  801fd4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fe0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	50                   	push   %eax
  801fe7:	e8 75 f3 ff ff       	call   801361 <fd2num>
  801fec:	89 c3                	mov    %eax,%ebx
  801fee:	83 c4 10             	add    $0x10,%esp
  801ff1:	eb 0c                	jmp    801fff <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	56                   	push   %esi
  801ff7:	e8 e2 01 00 00       	call   8021de <nsipc_close>
		return r;
  801ffc:	83 c4 10             	add    $0x10,%esp
}
  801fff:	89 d8                	mov    %ebx,%eax
  802001:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802004:	5b                   	pop    %ebx
  802005:	5e                   	pop    %esi
  802006:	5d                   	pop    %ebp
  802007:	c3                   	ret    

00802008 <accept>:
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	e8 4e ff ff ff       	call   801f64 <fd2sockid>
  802016:	85 c0                	test   %eax,%eax
  802018:	78 1b                	js     802035 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	ff 75 10             	pushl  0x10(%ebp)
  802020:	ff 75 0c             	pushl  0xc(%ebp)
  802023:	50                   	push   %eax
  802024:	e8 0e 01 00 00       	call   802137 <nsipc_accept>
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	85 c0                	test   %eax,%eax
  80202e:	78 05                	js     802035 <accept+0x2d>
	return alloc_sockfd(r);
  802030:	e8 5f ff ff ff       	call   801f94 <alloc_sockfd>
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <bind>:
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	e8 1f ff ff ff       	call   801f64 <fd2sockid>
  802045:	85 c0                	test   %eax,%eax
  802047:	78 12                	js     80205b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802049:	83 ec 04             	sub    $0x4,%esp
  80204c:	ff 75 10             	pushl  0x10(%ebp)
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	50                   	push   %eax
  802053:	e8 2f 01 00 00       	call   802187 <nsipc_bind>
  802058:	83 c4 10             	add    $0x10,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <shutdown>:
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	e8 f9 fe ff ff       	call   801f64 <fd2sockid>
  80206b:	85 c0                	test   %eax,%eax
  80206d:	78 0f                	js     80207e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80206f:	83 ec 08             	sub    $0x8,%esp
  802072:	ff 75 0c             	pushl  0xc(%ebp)
  802075:	50                   	push   %eax
  802076:	e8 41 01 00 00       	call   8021bc <nsipc_shutdown>
  80207b:	83 c4 10             	add    $0x10,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <connect>:
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	e8 d6 fe ff ff       	call   801f64 <fd2sockid>
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 12                	js     8020a4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802092:	83 ec 04             	sub    $0x4,%esp
  802095:	ff 75 10             	pushl  0x10(%ebp)
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	50                   	push   %eax
  80209c:	e8 57 01 00 00       	call   8021f8 <nsipc_connect>
  8020a1:	83 c4 10             	add    $0x10,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <listen>:
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	e8 b0 fe ff ff       	call   801f64 <fd2sockid>
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	78 0f                	js     8020c7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	50                   	push   %eax
  8020bf:	e8 69 01 00 00       	call   80222d <nsipc_listen>
  8020c4:	83 c4 10             	add    $0x10,%esp
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020cf:	ff 75 10             	pushl  0x10(%ebp)
  8020d2:	ff 75 0c             	pushl  0xc(%ebp)
  8020d5:	ff 75 08             	pushl  0x8(%ebp)
  8020d8:	e8 3c 02 00 00       	call   802319 <nsipc_socket>
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	78 05                	js     8020e9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020e4:	e8 ab fe ff ff       	call   801f94 <alloc_sockfd>
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	53                   	push   %ebx
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020f4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8020fb:	74 26                	je     802123 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020fd:	6a 07                	push   $0x7
  8020ff:	68 00 60 80 00       	push   $0x806000
  802104:	53                   	push   %ebx
  802105:	ff 35 04 40 80 00    	pushl  0x804004
  80210b:	e8 bf f1 ff ff       	call   8012cf <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802110:	83 c4 0c             	add    $0xc,%esp
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	e8 48 f1 ff ff       	call   801266 <ipc_recv>
}
  80211e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802121:	c9                   	leave  
  802122:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	6a 02                	push   $0x2
  802128:	e8 fb f1 ff ff       	call   801328 <ipc_find_env>
  80212d:	a3 04 40 80 00       	mov    %eax,0x804004
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	eb c6                	jmp    8020fd <nsipc+0x12>

00802137 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802147:	8b 06                	mov    (%esi),%eax
  802149:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80214e:	b8 01 00 00 00       	mov    $0x1,%eax
  802153:	e8 93 ff ff ff       	call   8020eb <nsipc>
  802158:	89 c3                	mov    %eax,%ebx
  80215a:	85 c0                	test   %eax,%eax
  80215c:	78 20                	js     80217e <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	ff 35 10 60 80 00    	pushl  0x806010
  802167:	68 00 60 80 00       	push   $0x806000
  80216c:	ff 75 0c             	pushl  0xc(%ebp)
  80216f:	e8 4b e9 ff ff       	call   800abf <memmove>
		*addrlen = ret->ret_addrlen;
  802174:	a1 10 60 80 00       	mov    0x806010,%eax
  802179:	89 06                	mov    %eax,(%esi)
  80217b:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80217e:	89 d8                	mov    %ebx,%eax
  802180:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5d                   	pop    %ebp
  802186:	c3                   	ret    

00802187 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	53                   	push   %ebx
  80218b:	83 ec 08             	sub    $0x8,%esp
  80218e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802199:	53                   	push   %ebx
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	68 04 60 80 00       	push   $0x806004
  8021a2:	e8 18 e9 ff ff       	call   800abf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021a7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8021ad:	b8 02 00 00 00       	mov    $0x2,%eax
  8021b2:	e8 34 ff ff ff       	call   8020eb <nsipc>
}
  8021b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8021ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8021d2:	b8 03 00 00 00       	mov    $0x3,%eax
  8021d7:	e8 0f ff ff ff       	call   8020eb <nsipc>
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <nsipc_close>:

int
nsipc_close(int s)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8021ec:	b8 04 00 00 00       	mov    $0x4,%eax
  8021f1:	e8 f5 fe ff ff       	call   8020eb <nsipc>
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	53                   	push   %ebx
  8021fc:	83 ec 08             	sub    $0x8,%esp
  8021ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80220a:	53                   	push   %ebx
  80220b:	ff 75 0c             	pushl  0xc(%ebp)
  80220e:	68 04 60 80 00       	push   $0x806004
  802213:	e8 a7 e8 ff ff       	call   800abf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802218:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80221e:	b8 05 00 00 00       	mov    $0x5,%eax
  802223:	e8 c3 fe ff ff       	call   8020eb <nsipc>
}
  802228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80223b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802243:	b8 06 00 00 00       	mov    $0x6,%eax
  802248:	e8 9e fe ff ff       	call   8020eb <nsipc>
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	56                   	push   %esi
  802253:	53                   	push   %ebx
  802254:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80225f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802265:	8b 45 14             	mov    0x14(%ebp),%eax
  802268:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80226d:	b8 07 00 00 00       	mov    $0x7,%eax
  802272:	e8 74 fe ff ff       	call   8020eb <nsipc>
  802277:	89 c3                	mov    %eax,%ebx
  802279:	85 c0                	test   %eax,%eax
  80227b:	78 1f                	js     80229c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80227d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802282:	7f 21                	jg     8022a5 <nsipc_recv+0x56>
  802284:	39 c6                	cmp    %eax,%esi
  802286:	7c 1d                	jl     8022a5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	50                   	push   %eax
  80228c:	68 00 60 80 00       	push   $0x806000
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	e8 26 e8 ff ff       	call   800abf <memmove>
  802299:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80229c:	89 d8                	mov    %ebx,%eax
  80229e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022a5:	68 83 2d 80 00       	push   $0x802d83
  8022aa:	68 25 2d 80 00       	push   $0x802d25
  8022af:	6a 62                	push   $0x62
  8022b1:	68 98 2d 80 00       	push   $0x802d98
  8022b6:	e8 05 02 00 00       	call   8024c0 <_panic>

008022bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	53                   	push   %ebx
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8022cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022d3:	7f 2e                	jg     802303 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	53                   	push   %ebx
  8022d9:	ff 75 0c             	pushl  0xc(%ebp)
  8022dc:	68 0c 60 80 00       	push   $0x80600c
  8022e1:	e8 d9 e7 ff ff       	call   800abf <memmove>
	nsipcbuf.send.req_size = size;
  8022e6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ef:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8022f9:	e8 ed fd ff ff       	call   8020eb <nsipc>
}
  8022fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802301:	c9                   	leave  
  802302:	c3                   	ret    
	assert(size < 1600);
  802303:	68 a4 2d 80 00       	push   $0x802da4
  802308:	68 25 2d 80 00       	push   $0x802d25
  80230d:	6a 6d                	push   $0x6d
  80230f:	68 98 2d 80 00       	push   $0x802d98
  802314:	e8 a7 01 00 00       	call   8024c0 <_panic>

00802319 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80232f:	8b 45 10             	mov    0x10(%ebp),%eax
  802332:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802337:	b8 09 00 00 00       	mov    $0x9,%eax
  80233c:	e8 aa fd ff ff       	call   8020eb <nsipc>
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802346:	b8 00 00 00 00       	mov    $0x0,%eax
  80234b:	5d                   	pop    %ebp
  80234c:	c3                   	ret    

0080234d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802353:	68 b0 2d 80 00       	push   $0x802db0
  802358:	ff 75 0c             	pushl  0xc(%ebp)
  80235b:	e8 d1 e5 ff ff       	call   800931 <strcpy>
	return 0;
}
  802360:	b8 00 00 00 00       	mov    $0x0,%eax
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <devcons_write>:
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	57                   	push   %edi
  80236b:	56                   	push   %esi
  80236c:	53                   	push   %ebx
  80236d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802373:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802378:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80237e:	eb 2f                	jmp    8023af <devcons_write+0x48>
		m = n - tot;
  802380:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802383:	29 f3                	sub    %esi,%ebx
  802385:	83 fb 7f             	cmp    $0x7f,%ebx
  802388:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80238d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	53                   	push   %ebx
  802394:	89 f0                	mov    %esi,%eax
  802396:	03 45 0c             	add    0xc(%ebp),%eax
  802399:	50                   	push   %eax
  80239a:	57                   	push   %edi
  80239b:	e8 1f e7 ff ff       	call   800abf <memmove>
		sys_cputs(buf, m);
  8023a0:	83 c4 08             	add    $0x8,%esp
  8023a3:	53                   	push   %ebx
  8023a4:	57                   	push   %edi
  8023a5:	e8 c4 e8 ff ff       	call   800c6e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023aa:	01 de                	add    %ebx,%esi
  8023ac:	83 c4 10             	add    $0x10,%esp
  8023af:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023b2:	72 cc                	jb     802380 <devcons_write+0x19>
}
  8023b4:	89 f0                	mov    %esi,%eax
  8023b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023b9:	5b                   	pop    %ebx
  8023ba:	5e                   	pop    %esi
  8023bb:	5f                   	pop    %edi
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <devcons_read>:
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023cd:	75 07                	jne    8023d6 <devcons_read+0x18>
}
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    
		sys_yield();
  8023d1:	e8 35 e9 ff ff       	call   800d0b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8023d6:	e8 b1 e8 ff ff       	call   800c8c <sys_cgetc>
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 f2                	je     8023d1 <devcons_read+0x13>
	if (c < 0)
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	78 ec                	js     8023cf <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8023e3:	83 f8 04             	cmp    $0x4,%eax
  8023e6:	74 0c                	je     8023f4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8023e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023eb:	88 02                	mov    %al,(%edx)
	return 1;
  8023ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f2:	eb db                	jmp    8023cf <devcons_read+0x11>
		return 0;
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	eb d4                	jmp    8023cf <devcons_read+0x11>

008023fb <cputchar>:
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802407:	6a 01                	push   $0x1
  802409:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80240c:	50                   	push   %eax
  80240d:	e8 5c e8 ff ff       	call   800c6e <sys_cputs>
}
  802412:	83 c4 10             	add    $0x10,%esp
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <getchar>:
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80241d:	6a 01                	push   $0x1
  80241f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802422:	50                   	push   %eax
  802423:	6a 00                	push   $0x0
  802425:	e8 1e f2 ff ff       	call   801648 <read>
	if (r < 0)
  80242a:	83 c4 10             	add    $0x10,%esp
  80242d:	85 c0                	test   %eax,%eax
  80242f:	78 08                	js     802439 <getchar+0x22>
	if (r < 1)
  802431:	85 c0                	test   %eax,%eax
  802433:	7e 06                	jle    80243b <getchar+0x24>
	return c;
  802435:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    
		return -E_EOF;
  80243b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802440:	eb f7                	jmp    802439 <getchar+0x22>

00802442 <iscons>:
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80244b:	50                   	push   %eax
  80244c:	ff 75 08             	pushl  0x8(%ebp)
  80244f:	e8 83 ef ff ff       	call   8013d7 <fd_lookup>
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	85 c0                	test   %eax,%eax
  802459:	78 11                	js     80246c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 15 60 30 80 00    	mov    0x803060,%edx
  802464:	39 10                	cmp    %edx,(%eax)
  802466:	0f 94 c0             	sete   %al
  802469:	0f b6 c0             	movzbl %al,%eax
}
  80246c:	c9                   	leave  
  80246d:	c3                   	ret    

0080246e <opencons>:
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802474:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802477:	50                   	push   %eax
  802478:	e8 0b ef ff ff       	call   801388 <fd_alloc>
  80247d:	83 c4 10             	add    $0x10,%esp
  802480:	85 c0                	test   %eax,%eax
  802482:	78 3a                	js     8024be <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	68 07 04 00 00       	push   $0x407
  80248c:	ff 75 f4             	pushl  -0xc(%ebp)
  80248f:	6a 00                	push   $0x0
  802491:	e8 94 e8 ff ff       	call   800d2a <sys_page_alloc>
  802496:	83 c4 10             	add    $0x10,%esp
  802499:	85 c0                	test   %eax,%eax
  80249b:	78 21                	js     8024be <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 15 60 30 80 00    	mov    0x803060,%edx
  8024a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024b2:	83 ec 0c             	sub    $0xc,%esp
  8024b5:	50                   	push   %eax
  8024b6:	e8 a6 ee ff ff       	call   801361 <fd2num>
  8024bb:	83 c4 10             	add    $0x10,%esp
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	56                   	push   %esi
  8024c4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8024c5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8024c8:	8b 35 08 30 80 00    	mov    0x803008,%esi
  8024ce:	e8 19 e8 ff ff       	call   800cec <sys_getenvid>
  8024d3:	83 ec 0c             	sub    $0xc,%esp
  8024d6:	ff 75 0c             	pushl  0xc(%ebp)
  8024d9:	ff 75 08             	pushl  0x8(%ebp)
  8024dc:	56                   	push   %esi
  8024dd:	50                   	push   %eax
  8024de:	68 bc 2d 80 00       	push   $0x802dbc
  8024e3:	e8 ac dd ff ff       	call   800294 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024e8:	83 c4 18             	add    $0x18,%esp
  8024eb:	53                   	push   %ebx
  8024ec:	ff 75 10             	pushl  0x10(%ebp)
  8024ef:	e8 4f dd ff ff       	call   800243 <vcprintf>
	cprintf("\n");
  8024f4:	c7 04 24 70 2d 80 00 	movl   $0x802d70,(%esp)
  8024fb:	e8 94 dd ff ff       	call   800294 <cprintf>
  802500:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802503:	cc                   	int3   
  802504:	eb fd                	jmp    802503 <_panic+0x43>

00802506 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80250c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802513:	74 0a                	je     80251f <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80251f:	a1 08 40 80 00       	mov    0x804008,%eax
  802524:	8b 40 48             	mov    0x48(%eax),%eax
  802527:	83 ec 04             	sub    $0x4,%esp
  80252a:	6a 07                	push   $0x7
  80252c:	68 00 f0 bf ee       	push   $0xeebff000
  802531:	50                   	push   %eax
  802532:	e8 f3 e7 ff ff       	call   800d2a <sys_page_alloc>
  802537:	83 c4 10             	add    $0x10,%esp
  80253a:	85 c0                	test   %eax,%eax
  80253c:	75 2f                	jne    80256d <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  80253e:	a1 08 40 80 00       	mov    0x804008,%eax
  802543:	8b 40 48             	mov    0x48(%eax),%eax
  802546:	83 ec 08             	sub    $0x8,%esp
  802549:	68 7f 25 80 00       	push   $0x80257f
  80254e:	50                   	push   %eax
  80254f:	e8 21 e9 ff ff       	call   800e75 <sys_env_set_pgfault_upcall>
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	85 c0                	test   %eax,%eax
  802559:	74 ba                	je     802515 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  80255b:	50                   	push   %eax
  80255c:	68 e0 2d 80 00       	push   $0x802de0
  802561:	6a 24                	push   $0x24
  802563:	68 f8 2d 80 00       	push   $0x802df8
  802568:	e8 53 ff ff ff       	call   8024c0 <_panic>
		    panic("set_pgfault_handler: %e", r);
  80256d:	50                   	push   %eax
  80256e:	68 e0 2d 80 00       	push   $0x802de0
  802573:	6a 21                	push   $0x21
  802575:	68 f8 2d 80 00       	push   $0x802df8
  80257a:	e8 41 ff ff ff       	call   8024c0 <_panic>

0080257f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80257f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802580:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802585:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802587:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  80258a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  80258e:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  802591:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802595:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802599:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  80259b:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  80259e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  80259f:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8025a2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8025a3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8025a4:	c3                   	ret    

008025a5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025ab:	89 d0                	mov    %edx,%eax
  8025ad:	c1 e8 16             	shr    $0x16,%eax
  8025b0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025bc:	f6 c1 01             	test   $0x1,%cl
  8025bf:	74 1d                	je     8025de <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025c1:	c1 ea 0c             	shr    $0xc,%edx
  8025c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025cb:	f6 c2 01             	test   $0x1,%dl
  8025ce:	74 0e                	je     8025de <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025d0:	c1 ea 0c             	shr    $0xc,%edx
  8025d3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025da:	ef 
  8025db:	0f b7 c0             	movzwl %ax,%eax
}
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    

008025e0 <__udivdi3>:
  8025e0:	55                   	push   %ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	53                   	push   %ebx
  8025e4:	83 ec 1c             	sub    $0x1c,%esp
  8025e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025f7:	85 d2                	test   %edx,%edx
  8025f9:	75 35                	jne    802630 <__udivdi3+0x50>
  8025fb:	39 f3                	cmp    %esi,%ebx
  8025fd:	0f 87 bd 00 00 00    	ja     8026c0 <__udivdi3+0xe0>
  802603:	85 db                	test   %ebx,%ebx
  802605:	89 d9                	mov    %ebx,%ecx
  802607:	75 0b                	jne    802614 <__udivdi3+0x34>
  802609:	b8 01 00 00 00       	mov    $0x1,%eax
  80260e:	31 d2                	xor    %edx,%edx
  802610:	f7 f3                	div    %ebx
  802612:	89 c1                	mov    %eax,%ecx
  802614:	31 d2                	xor    %edx,%edx
  802616:	89 f0                	mov    %esi,%eax
  802618:	f7 f1                	div    %ecx
  80261a:	89 c6                	mov    %eax,%esi
  80261c:	89 e8                	mov    %ebp,%eax
  80261e:	89 f7                	mov    %esi,%edi
  802620:	f7 f1                	div    %ecx
  802622:	89 fa                	mov    %edi,%edx
  802624:	83 c4 1c             	add    $0x1c,%esp
  802627:	5b                   	pop    %ebx
  802628:	5e                   	pop    %esi
  802629:	5f                   	pop    %edi
  80262a:	5d                   	pop    %ebp
  80262b:	c3                   	ret    
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	39 f2                	cmp    %esi,%edx
  802632:	77 7c                	ja     8026b0 <__udivdi3+0xd0>
  802634:	0f bd fa             	bsr    %edx,%edi
  802637:	83 f7 1f             	xor    $0x1f,%edi
  80263a:	0f 84 98 00 00 00    	je     8026d8 <__udivdi3+0xf8>
  802640:	89 f9                	mov    %edi,%ecx
  802642:	b8 20 00 00 00       	mov    $0x20,%eax
  802647:	29 f8                	sub    %edi,%eax
  802649:	d3 e2                	shl    %cl,%edx
  80264b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80264f:	89 c1                	mov    %eax,%ecx
  802651:	89 da                	mov    %ebx,%edx
  802653:	d3 ea                	shr    %cl,%edx
  802655:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802659:	09 d1                	or     %edx,%ecx
  80265b:	89 f2                	mov    %esi,%edx
  80265d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802661:	89 f9                	mov    %edi,%ecx
  802663:	d3 e3                	shl    %cl,%ebx
  802665:	89 c1                	mov    %eax,%ecx
  802667:	d3 ea                	shr    %cl,%edx
  802669:	89 f9                	mov    %edi,%ecx
  80266b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80266f:	d3 e6                	shl    %cl,%esi
  802671:	89 eb                	mov    %ebp,%ebx
  802673:	89 c1                	mov    %eax,%ecx
  802675:	d3 eb                	shr    %cl,%ebx
  802677:	09 de                	or     %ebx,%esi
  802679:	89 f0                	mov    %esi,%eax
  80267b:	f7 74 24 08          	divl   0x8(%esp)
  80267f:	89 d6                	mov    %edx,%esi
  802681:	89 c3                	mov    %eax,%ebx
  802683:	f7 64 24 0c          	mull   0xc(%esp)
  802687:	39 d6                	cmp    %edx,%esi
  802689:	72 0c                	jb     802697 <__udivdi3+0xb7>
  80268b:	89 f9                	mov    %edi,%ecx
  80268d:	d3 e5                	shl    %cl,%ebp
  80268f:	39 c5                	cmp    %eax,%ebp
  802691:	73 5d                	jae    8026f0 <__udivdi3+0x110>
  802693:	39 d6                	cmp    %edx,%esi
  802695:	75 59                	jne    8026f0 <__udivdi3+0x110>
  802697:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80269a:	31 ff                	xor    %edi,%edi
  80269c:	89 fa                	mov    %edi,%edx
  80269e:	83 c4 1c             	add    $0x1c,%esp
  8026a1:	5b                   	pop    %ebx
  8026a2:	5e                   	pop    %esi
  8026a3:	5f                   	pop    %edi
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    
  8026a6:	8d 76 00             	lea    0x0(%esi),%esi
  8026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8026b0:	31 ff                	xor    %edi,%edi
  8026b2:	31 c0                	xor    %eax,%eax
  8026b4:	89 fa                	mov    %edi,%edx
  8026b6:	83 c4 1c             	add    $0x1c,%esp
  8026b9:	5b                   	pop    %ebx
  8026ba:	5e                   	pop    %esi
  8026bb:	5f                   	pop    %edi
  8026bc:	5d                   	pop    %ebp
  8026bd:	c3                   	ret    
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	31 ff                	xor    %edi,%edi
  8026c2:	89 e8                	mov    %ebp,%eax
  8026c4:	89 f2                	mov    %esi,%edx
  8026c6:	f7 f3                	div    %ebx
  8026c8:	89 fa                	mov    %edi,%edx
  8026ca:	83 c4 1c             	add    $0x1c,%esp
  8026cd:	5b                   	pop    %ebx
  8026ce:	5e                   	pop    %esi
  8026cf:	5f                   	pop    %edi
  8026d0:	5d                   	pop    %ebp
  8026d1:	c3                   	ret    
  8026d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026d8:	39 f2                	cmp    %esi,%edx
  8026da:	72 06                	jb     8026e2 <__udivdi3+0x102>
  8026dc:	31 c0                	xor    %eax,%eax
  8026de:	39 eb                	cmp    %ebp,%ebx
  8026e0:	77 d2                	ja     8026b4 <__udivdi3+0xd4>
  8026e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026e7:	eb cb                	jmp    8026b4 <__udivdi3+0xd4>
  8026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	89 d8                	mov    %ebx,%eax
  8026f2:	31 ff                	xor    %edi,%edi
  8026f4:	eb be                	jmp    8026b4 <__udivdi3+0xd4>
  8026f6:	66 90                	xchg   %ax,%ax
  8026f8:	66 90                	xchg   %ax,%ax
  8026fa:	66 90                	xchg   %ax,%ax
  8026fc:	66 90                	xchg   %ax,%ax
  8026fe:	66 90                	xchg   %ax,%ax

00802700 <__umoddi3>:
  802700:	55                   	push   %ebp
  802701:	57                   	push   %edi
  802702:	56                   	push   %esi
  802703:	53                   	push   %ebx
  802704:	83 ec 1c             	sub    $0x1c,%esp
  802707:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80270b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80270f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802717:	85 ed                	test   %ebp,%ebp
  802719:	89 f0                	mov    %esi,%eax
  80271b:	89 da                	mov    %ebx,%edx
  80271d:	75 19                	jne    802738 <__umoddi3+0x38>
  80271f:	39 df                	cmp    %ebx,%edi
  802721:	0f 86 b1 00 00 00    	jbe    8027d8 <__umoddi3+0xd8>
  802727:	f7 f7                	div    %edi
  802729:	89 d0                	mov    %edx,%eax
  80272b:	31 d2                	xor    %edx,%edx
  80272d:	83 c4 1c             	add    $0x1c,%esp
  802730:	5b                   	pop    %ebx
  802731:	5e                   	pop    %esi
  802732:	5f                   	pop    %edi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    
  802735:	8d 76 00             	lea    0x0(%esi),%esi
  802738:	39 dd                	cmp    %ebx,%ebp
  80273a:	77 f1                	ja     80272d <__umoddi3+0x2d>
  80273c:	0f bd cd             	bsr    %ebp,%ecx
  80273f:	83 f1 1f             	xor    $0x1f,%ecx
  802742:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802746:	0f 84 b4 00 00 00    	je     802800 <__umoddi3+0x100>
  80274c:	b8 20 00 00 00       	mov    $0x20,%eax
  802751:	89 c2                	mov    %eax,%edx
  802753:	8b 44 24 04          	mov    0x4(%esp),%eax
  802757:	29 c2                	sub    %eax,%edx
  802759:	89 c1                	mov    %eax,%ecx
  80275b:	89 f8                	mov    %edi,%eax
  80275d:	d3 e5                	shl    %cl,%ebp
  80275f:	89 d1                	mov    %edx,%ecx
  802761:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802765:	d3 e8                	shr    %cl,%eax
  802767:	09 c5                	or     %eax,%ebp
  802769:	8b 44 24 04          	mov    0x4(%esp),%eax
  80276d:	89 c1                	mov    %eax,%ecx
  80276f:	d3 e7                	shl    %cl,%edi
  802771:	89 d1                	mov    %edx,%ecx
  802773:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802777:	89 df                	mov    %ebx,%edi
  802779:	d3 ef                	shr    %cl,%edi
  80277b:	89 c1                	mov    %eax,%ecx
  80277d:	89 f0                	mov    %esi,%eax
  80277f:	d3 e3                	shl    %cl,%ebx
  802781:	89 d1                	mov    %edx,%ecx
  802783:	89 fa                	mov    %edi,%edx
  802785:	d3 e8                	shr    %cl,%eax
  802787:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80278c:	09 d8                	or     %ebx,%eax
  80278e:	f7 f5                	div    %ebp
  802790:	d3 e6                	shl    %cl,%esi
  802792:	89 d1                	mov    %edx,%ecx
  802794:	f7 64 24 08          	mull   0x8(%esp)
  802798:	39 d1                	cmp    %edx,%ecx
  80279a:	89 c3                	mov    %eax,%ebx
  80279c:	89 d7                	mov    %edx,%edi
  80279e:	72 06                	jb     8027a6 <__umoddi3+0xa6>
  8027a0:	75 0e                	jne    8027b0 <__umoddi3+0xb0>
  8027a2:	39 c6                	cmp    %eax,%esi
  8027a4:	73 0a                	jae    8027b0 <__umoddi3+0xb0>
  8027a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8027aa:	19 ea                	sbb    %ebp,%edx
  8027ac:	89 d7                	mov    %edx,%edi
  8027ae:	89 c3                	mov    %eax,%ebx
  8027b0:	89 ca                	mov    %ecx,%edx
  8027b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8027b7:	29 de                	sub    %ebx,%esi
  8027b9:	19 fa                	sbb    %edi,%edx
  8027bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8027bf:	89 d0                	mov    %edx,%eax
  8027c1:	d3 e0                	shl    %cl,%eax
  8027c3:	89 d9                	mov    %ebx,%ecx
  8027c5:	d3 ee                	shr    %cl,%esi
  8027c7:	d3 ea                	shr    %cl,%edx
  8027c9:	09 f0                	or     %esi,%eax
  8027cb:	83 c4 1c             	add    $0x1c,%esp
  8027ce:	5b                   	pop    %ebx
  8027cf:	5e                   	pop    %esi
  8027d0:	5f                   	pop    %edi
  8027d1:	5d                   	pop    %ebp
  8027d2:	c3                   	ret    
  8027d3:	90                   	nop
  8027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	85 ff                	test   %edi,%edi
  8027da:	89 f9                	mov    %edi,%ecx
  8027dc:	75 0b                	jne    8027e9 <__umoddi3+0xe9>
  8027de:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e3:	31 d2                	xor    %edx,%edx
  8027e5:	f7 f7                	div    %edi
  8027e7:	89 c1                	mov    %eax,%ecx
  8027e9:	89 d8                	mov    %ebx,%eax
  8027eb:	31 d2                	xor    %edx,%edx
  8027ed:	f7 f1                	div    %ecx
  8027ef:	89 f0                	mov    %esi,%eax
  8027f1:	f7 f1                	div    %ecx
  8027f3:	e9 31 ff ff ff       	jmp    802729 <__umoddi3+0x29>
  8027f8:	90                   	nop
  8027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802800:	39 dd                	cmp    %ebx,%ebp
  802802:	72 08                	jb     80280c <__umoddi3+0x10c>
  802804:	39 f7                	cmp    %esi,%edi
  802806:	0f 87 21 ff ff ff    	ja     80272d <__umoddi3+0x2d>
  80280c:	89 da                	mov    %ebx,%edx
  80280e:	89 f0                	mov    %esi,%eax
  802810:	29 f8                	sub    %edi,%eax
  802812:	19 ea                	sbb    %ebp,%edx
  802814:	e9 14 ff ff ff       	jmp    80272d <__umoddi3+0x2d>
