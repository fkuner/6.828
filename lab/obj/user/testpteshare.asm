
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 65 01 00 00       	call   800196 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 25 09 00 00       	call   80096e <strcpy>
	exit();
  800049:	e8 8e 01 00 00       	call   8001dc <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d2 00 00 00    	jne    800136 <umain+0xe3>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 ef 0c 00 00       	call   800d67 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bd 00 00 00    	js     800140 <umain+0xed>
	if ((r = fork()) < 0)
  800083:	e8 d9 0f 00 00       	call   801061 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 c0 00 00 00    	js     800152 <umain+0xff>
	if (r == 0) {
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 84 ca 00 00 00    	je     800164 <umain+0x111>
	wait(r);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	53                   	push   %ebx
  80009e:	e8 72 23 00 00       	call   802415 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a3:	83 c4 08             	add    $0x8,%esp
  8000a6:	ff 35 04 40 80 00    	pushl  0x804004
  8000ac:	68 00 00 00 a0       	push   $0xa0000000
  8000b1:	e8 5e 09 00 00       	call   800a14 <strcmp>
  8000b6:	83 c4 08             	add    $0x8,%esp
  8000b9:	85 c0                	test   %eax,%eax
  8000bb:	b8 60 2e 80 00       	mov    $0x802e60,%eax
  8000c0:	ba 66 2e 80 00       	mov    $0x802e66,%edx
  8000c5:	0f 45 c2             	cmovne %edx,%eax
  8000c8:	50                   	push   %eax
  8000c9:	68 93 2e 80 00       	push   $0x802e93
  8000ce:	e8 fe 01 00 00       	call   8002d1 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d3:	6a 00                	push   $0x0
  8000d5:	68 ae 2e 80 00       	push   $0x802eae
  8000da:	68 b3 2e 80 00       	push   $0x802eb3
  8000df:	68 b2 2e 80 00       	push   $0x802eb2
  8000e4:	e8 62 1f 00 00       	call   80204b <spawnl>
  8000e9:	83 c4 20             	add    $0x20,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 90 00 00 00    	js     800184 <umain+0x131>
	wait(r);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 18 23 00 00       	call   802415 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fd:	83 c4 08             	add    $0x8,%esp
  800100:	ff 35 00 40 80 00    	pushl  0x804000
  800106:	68 00 00 00 a0       	push   $0xa0000000
  80010b:	e8 04 09 00 00       	call   800a14 <strcmp>
  800110:	83 c4 08             	add    $0x8,%esp
  800113:	85 c0                	test   %eax,%eax
  800115:	b8 60 2e 80 00       	mov    $0x802e60,%eax
  80011a:	ba 66 2e 80 00       	mov    $0x802e66,%edx
  80011f:	0f 45 c2             	cmovne %edx,%eax
  800122:	50                   	push   %eax
  800123:	68 ca 2e 80 00       	push   $0x802eca
  800128:	e8 a4 01 00 00       	call   8002d1 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012d:	cc                   	int3   
}
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800134:	c9                   	leave  
  800135:	c3                   	ret    
		childofspawn();
  800136:	e8 f8 fe ff ff       	call   800033 <childofspawn>
  80013b:	e9 24 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  800140:	50                   	push   %eax
  800141:	68 6c 2e 80 00       	push   $0x802e6c
  800146:	6a 13                	push   $0x13
  800148:	68 7f 2e 80 00       	push   $0x802e7f
  80014d:	e8 a4 00 00 00       	call   8001f6 <_panic>
		panic("fork: %e", r);
  800152:	50                   	push   %eax
  800153:	68 a6 32 80 00       	push   $0x8032a6
  800158:	6a 17                	push   $0x17
  80015a:	68 7f 2e 80 00       	push   $0x802e7f
  80015f:	e8 92 00 00 00       	call   8001f6 <_panic>
		strcpy(VA, msg);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	ff 35 04 40 80 00    	pushl  0x804004
  80016d:	68 00 00 00 a0       	push   $0xa0000000
  800172:	e8 f7 07 00 00       	call   80096e <strcpy>
		exit();
  800177:	e8 60 00 00 00       	call   8001dc <exit>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	e9 16 ff ff ff       	jmp    80009a <umain+0x47>
		panic("spawn: %e", r);
  800184:	50                   	push   %eax
  800185:	68 c0 2e 80 00       	push   $0x802ec0
  80018a:	6a 21                	push   $0x21
  80018c:	68 7f 2e 80 00       	push   $0x802e7f
  800191:	e8 60 00 00 00       	call   8001f6 <_panic>

00800196 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8001a1:	e8 83 0b 00 00       	call   800d29 <sys_getenvid>
  8001a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b8:	85 db                	test   %ebx,%ebx
  8001ba:	7e 07                	jle    8001c3 <libmain+0x2d>
		binaryname = argv[0];
  8001bc:	8b 06                	mov    (%esi),%eax
  8001be:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	e8 86 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001cd:	e8 0a 00 00 00       	call   8001dc <exit>
}
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d8:	5b                   	pop    %ebx
  8001d9:	5e                   	pop    %esi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001e2:	e8 92 12 00 00       	call   801479 <close_all>
	sys_env_destroy(0);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	e8 f7 0a 00 00       	call   800ce8 <sys_env_destroy>
}
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001fb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fe:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800204:	e8 20 0b 00 00       	call   800d29 <sys_getenvid>
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	ff 75 0c             	pushl  0xc(%ebp)
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	56                   	push   %esi
  800213:	50                   	push   %eax
  800214:	68 10 2f 80 00       	push   $0x802f10
  800219:	e8 b3 00 00 00       	call   8002d1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	53                   	push   %ebx
  800222:	ff 75 10             	pushl  0x10(%ebp)
  800225:	e8 56 00 00 00       	call   800280 <vcprintf>
	cprintf("\n");
  80022a:	c7 04 24 90 34 80 00 	movl   $0x803490,(%esp)
  800231:	e8 9b 00 00 00       	call   8002d1 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800239:	cc                   	int3   
  80023a:	eb fd                	jmp    800239 <_panic+0x43>

0080023c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	53                   	push   %ebx
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800246:	8b 13                	mov    (%ebx),%edx
  800248:	8d 42 01             	lea    0x1(%edx),%eax
  80024b:	89 03                	mov    %eax,(%ebx)
  80024d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800250:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800254:	3d ff 00 00 00       	cmp    $0xff,%eax
  800259:	74 09                	je     800264 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80025b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800262:	c9                   	leave  
  800263:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	68 ff 00 00 00       	push   $0xff
  80026c:	8d 43 08             	lea    0x8(%ebx),%eax
  80026f:	50                   	push   %eax
  800270:	e8 36 0a 00 00       	call   800cab <sys_cputs>
		b->idx = 0;
  800275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	eb db                	jmp    80025b <putch+0x1f>

00800280 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800289:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800290:	00 00 00 
	b.cnt = 0;
  800293:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a9:	50                   	push   %eax
  8002aa:	68 3c 02 80 00       	push   $0x80023c
  8002af:	e8 1a 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b4:	83 c4 08             	add    $0x8,%esp
  8002b7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	e8 e2 09 00 00       	call   800cab <sys_cputs>

	return b.cnt;
}
  8002c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002da:	50                   	push   %eax
  8002db:	ff 75 08             	pushl  0x8(%ebp)
  8002de:	e8 9d ff ff ff       	call   800280 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	57                   	push   %edi
  8002e9:	56                   	push   %esi
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 1c             	sub    $0x1c,%esp
  8002ee:	89 c7                	mov    %eax,%edi
  8002f0:	89 d6                	mov    %edx,%esi
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800301:	bb 00 00 00 00       	mov    $0x0,%ebx
  800306:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80030c:	39 d3                	cmp    %edx,%ebx
  80030e:	72 05                	jb     800315 <printnum+0x30>
  800310:	39 45 10             	cmp    %eax,0x10(%ebp)
  800313:	77 7a                	ja     80038f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	ff 75 18             	pushl  0x18(%ebp)
  80031b:	8b 45 14             	mov    0x14(%ebp),%eax
  80031e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800321:	53                   	push   %ebx
  800322:	ff 75 10             	pushl  0x10(%ebp)
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032b:	ff 75 e0             	pushl  -0x20(%ebp)
  80032e:	ff 75 dc             	pushl  -0x24(%ebp)
  800331:	ff 75 d8             	pushl  -0x28(%ebp)
  800334:	e8 e7 28 00 00       	call   802c20 <__udivdi3>
  800339:	83 c4 18             	add    $0x18,%esp
  80033c:	52                   	push   %edx
  80033d:	50                   	push   %eax
  80033e:	89 f2                	mov    %esi,%edx
  800340:	89 f8                	mov    %edi,%eax
  800342:	e8 9e ff ff ff       	call   8002e5 <printnum>
  800347:	83 c4 20             	add    $0x20,%esp
  80034a:	eb 13                	jmp    80035f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	56                   	push   %esi
  800350:	ff 75 18             	pushl  0x18(%ebp)
  800353:	ff d7                	call   *%edi
  800355:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800358:	83 eb 01             	sub    $0x1,%ebx
  80035b:	85 db                	test   %ebx,%ebx
  80035d:	7f ed                	jg     80034c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	56                   	push   %esi
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	ff 75 e4             	pushl  -0x1c(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	ff 75 dc             	pushl  -0x24(%ebp)
  80036f:	ff 75 d8             	pushl  -0x28(%ebp)
  800372:	e8 c9 29 00 00       	call   802d40 <__umoddi3>
  800377:	83 c4 14             	add    $0x14,%esp
  80037a:	0f be 80 33 2f 80 00 	movsbl 0x802f33(%eax),%eax
  800381:	50                   	push   %eax
  800382:	ff d7                	call   *%edi
}
  800384:	83 c4 10             	add    $0x10,%esp
  800387:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038a:	5b                   	pop    %ebx
  80038b:	5e                   	pop    %esi
  80038c:	5f                   	pop    %edi
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    
  80038f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800392:	eb c4                	jmp    800358 <printnum+0x73>

00800394 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039e:	8b 10                	mov    (%eax),%edx
  8003a0:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a3:	73 0a                	jae    8003af <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003a8:	89 08                	mov    %ecx,(%eax)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	88 02                	mov    %al,(%edx)
}
  8003af:	5d                   	pop    %ebp
  8003b0:	c3                   	ret    

008003b1 <printfmt>:
{
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003b7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 10             	pushl  0x10(%ebp)
  8003be:	ff 75 0c             	pushl  0xc(%ebp)
  8003c1:	ff 75 08             	pushl  0x8(%ebp)
  8003c4:	e8 05 00 00 00       	call   8003ce <vprintfmt>
}
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 2c             	sub    $0x2c,%esp
  8003d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003dd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003e0:	e9 21 04 00 00       	jmp    800806 <vprintfmt+0x438>
		padc = ' ';
  8003e5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003e9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003f0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8d 47 01             	lea    0x1(%edi),%eax
  800406:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800409:	0f b6 17             	movzbl (%edi),%edx
  80040c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80040f:	3c 55                	cmp    $0x55,%al
  800411:	0f 87 90 04 00 00    	ja     8008a7 <vprintfmt+0x4d9>
  800417:	0f b6 c0             	movzbl %al,%eax
  80041a:	ff 24 85 80 30 80 00 	jmp    *0x803080(,%eax,4)
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800424:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800428:	eb d9                	jmp    800403 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80042d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800431:	eb d0                	jmp    800403 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800433:	0f b6 d2             	movzbl %dl,%edx
  800436:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800439:	b8 00 00 00 00       	mov    $0x0,%eax
  80043e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800441:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800444:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800448:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80044b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80044e:	83 f9 09             	cmp    $0x9,%ecx
  800451:	77 55                	ja     8004a8 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800453:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800456:	eb e9                	jmp    800441 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800460:	8b 45 14             	mov    0x14(%ebp),%eax
  800463:	8d 40 04             	lea    0x4(%eax),%eax
  800466:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80046c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800470:	79 91                	jns    800403 <vprintfmt+0x35>
				width = precision, precision = -1;
  800472:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800478:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80047f:	eb 82                	jmp    800403 <vprintfmt+0x35>
  800481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800484:	85 c0                	test   %eax,%eax
  800486:	ba 00 00 00 00       	mov    $0x0,%edx
  80048b:	0f 49 d0             	cmovns %eax,%edx
  80048e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800494:	e9 6a ff ff ff       	jmp    800403 <vprintfmt+0x35>
  800499:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80049c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004a3:	e9 5b ff ff ff       	jmp    800403 <vprintfmt+0x35>
  8004a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ae:	eb bc                	jmp    80046c <vprintfmt+0x9e>
			lflag++;
  8004b0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b6:	e9 48 ff ff ff       	jmp    800403 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 78 04             	lea    0x4(%eax),%edi
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 30                	pushl  (%eax)
  8004c7:	ff d6                	call   *%esi
			break;
  8004c9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004cc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004cf:	e9 2f 03 00 00       	jmp    800803 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 78 04             	lea    0x4(%eax),%edi
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	99                   	cltd   
  8004dd:	31 d0                	xor    %edx,%eax
  8004df:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e1:	83 f8 0f             	cmp    $0xf,%eax
  8004e4:	7f 23                	jg     800509 <vprintfmt+0x13b>
  8004e6:	8b 14 85 e0 31 80 00 	mov    0x8031e0(,%eax,4),%edx
  8004ed:	85 d2                	test   %edx,%edx
  8004ef:	74 18                	je     800509 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004f1:	52                   	push   %edx
  8004f2:	68 a3 33 80 00       	push   $0x8033a3
  8004f7:	53                   	push   %ebx
  8004f8:	56                   	push   %esi
  8004f9:	e8 b3 fe ff ff       	call   8003b1 <printfmt>
  8004fe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800501:	89 7d 14             	mov    %edi,0x14(%ebp)
  800504:	e9 fa 02 00 00       	jmp    800803 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800509:	50                   	push   %eax
  80050a:	68 4b 2f 80 00       	push   $0x802f4b
  80050f:	53                   	push   %ebx
  800510:	56                   	push   %esi
  800511:	e8 9b fe ff ff       	call   8003b1 <printfmt>
  800516:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800519:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80051c:	e9 e2 02 00 00       	jmp    800803 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	83 c0 04             	add    $0x4,%eax
  800527:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80052f:	85 ff                	test   %edi,%edi
  800531:	b8 44 2f 80 00       	mov    $0x802f44,%eax
  800536:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800539:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053d:	0f 8e bd 00 00 00    	jle    800600 <vprintfmt+0x232>
  800543:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800547:	75 0e                	jne    800557 <vprintfmt+0x189>
  800549:	89 75 08             	mov    %esi,0x8(%ebp)
  80054c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800552:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800555:	eb 6d                	jmp    8005c4 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	ff 75 d0             	pushl  -0x30(%ebp)
  80055d:	57                   	push   %edi
  80055e:	e8 ec 03 00 00       	call   80094f <strnlen>
  800563:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800566:	29 c1                	sub    %eax,%ecx
  800568:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80056b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80056e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800572:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800575:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800578:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80057a:	eb 0f                	jmp    80058b <vprintfmt+0x1bd>
					putch(padc, putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	ff 75 e0             	pushl  -0x20(%ebp)
  800583:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800585:	83 ef 01             	sub    $0x1,%edi
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	85 ff                	test   %edi,%edi
  80058d:	7f ed                	jg     80057c <vprintfmt+0x1ae>
  80058f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800592:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800595:	85 c9                	test   %ecx,%ecx
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	0f 49 c1             	cmovns %ecx,%eax
  80059f:	29 c1                	sub    %eax,%ecx
  8005a1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005aa:	89 cb                	mov    %ecx,%ebx
  8005ac:	eb 16                	jmp    8005c4 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b2:	75 31                	jne    8005e5 <vprintfmt+0x217>
					putch(ch, putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	50                   	push   %eax
  8005bb:	ff 55 08             	call   *0x8(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c1:	83 eb 01             	sub    $0x1,%ebx
  8005c4:	83 c7 01             	add    $0x1,%edi
  8005c7:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005cb:	0f be c2             	movsbl %dl,%eax
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	74 59                	je     80062b <vprintfmt+0x25d>
  8005d2:	85 f6                	test   %esi,%esi
  8005d4:	78 d8                	js     8005ae <vprintfmt+0x1e0>
  8005d6:	83 ee 01             	sub    $0x1,%esi
  8005d9:	79 d3                	jns    8005ae <vprintfmt+0x1e0>
  8005db:	89 df                	mov    %ebx,%edi
  8005dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e3:	eb 37                	jmp    80061c <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e5:	0f be d2             	movsbl %dl,%edx
  8005e8:	83 ea 20             	sub    $0x20,%edx
  8005eb:	83 fa 5e             	cmp    $0x5e,%edx
  8005ee:	76 c4                	jbe    8005b4 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	6a 3f                	push   $0x3f
  8005f8:	ff 55 08             	call   *0x8(%ebp)
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb c1                	jmp    8005c1 <vprintfmt+0x1f3>
  800600:	89 75 08             	mov    %esi,0x8(%ebp)
  800603:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800606:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800609:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80060c:	eb b6                	jmp    8005c4 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	6a 20                	push   $0x20
  800614:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800616:	83 ef 01             	sub    $0x1,%edi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	85 ff                	test   %edi,%edi
  80061e:	7f ee                	jg     80060e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800620:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
  800626:	e9 d8 01 00 00       	jmp    800803 <vprintfmt+0x435>
  80062b:	89 df                	mov    %ebx,%edi
  80062d:	8b 75 08             	mov    0x8(%ebp),%esi
  800630:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800633:	eb e7                	jmp    80061c <vprintfmt+0x24e>
	if (lflag >= 2)
  800635:	83 f9 01             	cmp    $0x1,%ecx
  800638:	7e 45                	jle    80067f <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 50 04             	mov    0x4(%eax),%edx
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 08             	lea    0x8(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800651:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800655:	79 62                	jns    8006b9 <vprintfmt+0x2eb>
				putch('-', putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	6a 2d                	push   $0x2d
  80065d:	ff d6                	call   *%esi
				num = -(long long) num;
  80065f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800662:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800665:	f7 d8                	neg    %eax
  800667:	83 d2 00             	adc    $0x0,%edx
  80066a:	f7 da                	neg    %edx
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800672:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800675:	ba 0a 00 00 00       	mov    $0xa,%edx
  80067a:	e9 66 01 00 00       	jmp    8007e5 <vprintfmt+0x417>
	else if (lflag)
  80067f:	85 c9                	test   %ecx,%ecx
  800681:	75 1b                	jne    80069e <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	c1 f9 1f             	sar    $0x1f,%ecx
  800690:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
  80069c:	eb b3                	jmp    800651 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a6:	89 c1                	mov    %eax,%ecx
  8006a8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ab:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	eb 98                	jmp    800651 <vprintfmt+0x283>
			base = 10;
  8006b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006be:	e9 22 01 00 00       	jmp    8007e5 <vprintfmt+0x417>
	if (lflag >= 2)
  8006c3:	83 f9 01             	cmp    $0x1,%ecx
  8006c6:	7e 21                	jle    8006e9 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 08             	lea    0x8(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006df:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006e4:	e9 fc 00 00 00       	jmp    8007e5 <vprintfmt+0x417>
	else if (lflag)
  8006e9:	85 c9                	test   %ecx,%ecx
  8006eb:	75 23                	jne    800710 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800706:	ba 0a 00 00 00       	mov    $0xa,%edx
  80070b:	e9 d5 00 00 00       	jmp    8007e5 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	ba 00 00 00 00       	mov    $0x0,%edx
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 40 04             	lea    0x4(%eax),%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800729:	ba 0a 00 00 00       	mov    $0xa,%edx
  80072e:	e9 b2 00 00 00       	jmp    8007e5 <vprintfmt+0x417>
	if (lflag >= 2)
  800733:	83 f9 01             	cmp    $0x1,%ecx
  800736:	7e 42                	jle    80077a <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8b 50 04             	mov    0x4(%eax),%edx
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 08             	lea    0x8(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074f:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800754:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800758:	0f 89 87 00 00 00    	jns    8007e5 <vprintfmt+0x417>
				putch('-', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 2d                	push   $0x2d
  800764:	ff d6                	call   *%esi
				num = -(long long) num;
  800766:	f7 5d d8             	negl   -0x28(%ebp)
  800769:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80076d:	f7 5d dc             	negl   -0x24(%ebp)
  800770:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800773:	ba 08 00 00 00       	mov    $0x8,%edx
  800778:	eb 6b                	jmp    8007e5 <vprintfmt+0x417>
	else if (lflag)
  80077a:	85 c9                	test   %ecx,%ecx
  80077c:	75 1b                	jne    800799 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
  800788:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8d 40 04             	lea    0x4(%eax),%eax
  800794:	89 45 14             	mov    %eax,0x14(%ebp)
  800797:	eb b6                	jmp    80074f <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 04             	lea    0x4(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	eb 9b                	jmp    80074f <vprintfmt+0x381>
			putch('0', putdat);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	53                   	push   %ebx
  8007b8:	6a 30                	push   $0x30
  8007ba:	ff d6                	call   *%esi
			putch('x', putdat);
  8007bc:	83 c4 08             	add    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	6a 78                	push   $0x78
  8007c2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007d4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 40 04             	lea    0x4(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e0:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8007ec:	50                   	push   %eax
  8007ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f0:	52                   	push   %edx
  8007f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8007f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f7:	89 da                	mov    %ebx,%edx
  8007f9:	89 f0                	mov    %esi,%eax
  8007fb:	e8 e5 fa ff ff       	call   8002e5 <printnum>
			break;
  800800:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800803:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800806:	83 c7 01             	add    $0x1,%edi
  800809:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80080d:	83 f8 25             	cmp    $0x25,%eax
  800810:	0f 84 cf fb ff ff    	je     8003e5 <vprintfmt+0x17>
			if (ch == '\0')
  800816:	85 c0                	test   %eax,%eax
  800818:	0f 84 a9 00 00 00    	je     8008c7 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	53                   	push   %ebx
  800822:	50                   	push   %eax
  800823:	ff d6                	call   *%esi
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	eb dc                	jmp    800806 <vprintfmt+0x438>
	if (lflag >= 2)
  80082a:	83 f9 01             	cmp    $0x1,%ecx
  80082d:	7e 1e                	jle    80084d <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 50 04             	mov    0x4(%eax),%edx
  800835:	8b 00                	mov    (%eax),%eax
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 08             	lea    0x8(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800846:	ba 10 00 00 00       	mov    $0x10,%edx
  80084b:	eb 98                	jmp    8007e5 <vprintfmt+0x417>
	else if (lflag)
  80084d:	85 c9                	test   %ecx,%ecx
  80084f:	75 23                	jne    800874 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	ba 00 00 00 00       	mov    $0x0,%edx
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8d 40 04             	lea    0x4(%eax),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086a:	ba 10 00 00 00       	mov    $0x10,%edx
  80086f:	e9 71 ff ff ff       	jmp    8007e5 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	ba 00 00 00 00       	mov    $0x0,%edx
  80087e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800881:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 40 04             	lea    0x4(%eax),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088d:	ba 10 00 00 00       	mov    $0x10,%edx
  800892:	e9 4e ff ff ff       	jmp    8007e5 <vprintfmt+0x417>
			putch(ch, putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	53                   	push   %ebx
  80089b:	6a 25                	push   $0x25
  80089d:	ff d6                	call   *%esi
			break;
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	e9 5c ff ff ff       	jmp    800803 <vprintfmt+0x435>
			putch('%', putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	6a 25                	push   $0x25
  8008ad:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 f8                	mov    %edi,%eax
  8008b4:	eb 03                	jmp    8008b9 <vprintfmt+0x4eb>
  8008b6:	83 e8 01             	sub    $0x1,%eax
  8008b9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008bd:	75 f7                	jne    8008b6 <vprintfmt+0x4e8>
  8008bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c2:	e9 3c ff ff ff       	jmp    800803 <vprintfmt+0x435>
}
  8008c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ca:	5b                   	pop    %ebx
  8008cb:	5e                   	pop    %esi
  8008cc:	5f                   	pop    %edi
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 18             	sub    $0x18,%esp
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008de:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ec:	85 c0                	test   %eax,%eax
  8008ee:	74 26                	je     800916 <vsnprintf+0x47>
  8008f0:	85 d2                	test   %edx,%edx
  8008f2:	7e 22                	jle    800916 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f4:	ff 75 14             	pushl  0x14(%ebp)
  8008f7:	ff 75 10             	pushl  0x10(%ebp)
  8008fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	68 94 03 80 00       	push   $0x800394
  800903:	e8 c6 fa ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80090e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800911:	83 c4 10             	add    $0x10,%esp
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    
		return -E_INVAL;
  800916:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80091b:	eb f7                	jmp    800914 <vsnprintf+0x45>

0080091d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800923:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800926:	50                   	push   %eax
  800927:	ff 75 10             	pushl  0x10(%ebp)
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	ff 75 08             	pushl  0x8(%ebp)
  800930:	e8 9a ff ff ff       	call   8008cf <vsnprintf>
	va_end(ap);

	return rc;
}
  800935:	c9                   	leave  
  800936:	c3                   	ret    

00800937 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
  800942:	eb 03                	jmp    800947 <strlen+0x10>
		n++;
  800944:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800947:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80094b:	75 f7                	jne    800944 <strlen+0xd>
	return n;
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800955:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800958:	b8 00 00 00 00       	mov    $0x0,%eax
  80095d:	eb 03                	jmp    800962 <strnlen+0x13>
		n++;
  80095f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800962:	39 d0                	cmp    %edx,%eax
  800964:	74 06                	je     80096c <strnlen+0x1d>
  800966:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80096a:	75 f3                	jne    80095f <strnlen+0x10>
	return n;
}
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	53                   	push   %ebx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800978:	89 c2                	mov    %eax,%edx
  80097a:	83 c1 01             	add    $0x1,%ecx
  80097d:	83 c2 01             	add    $0x1,%edx
  800980:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800984:	88 5a ff             	mov    %bl,-0x1(%edx)
  800987:	84 db                	test   %bl,%bl
  800989:	75 ef                	jne    80097a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80098b:	5b                   	pop    %ebx
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	53                   	push   %ebx
  800992:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800995:	53                   	push   %ebx
  800996:	e8 9c ff ff ff       	call   800937 <strlen>
  80099b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	01 d8                	add    %ebx,%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 c5 ff ff ff       	call   80096e <strcpy>
	return dst;
}
  8009a9:	89 d8                	mov    %ebx,%eax
  8009ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	56                   	push   %esi
  8009b4:	53                   	push   %ebx
  8009b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bb:	89 f3                	mov    %esi,%ebx
  8009bd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c0:	89 f2                	mov    %esi,%edx
  8009c2:	eb 0f                	jmp    8009d3 <strncpy+0x23>
		*dst++ = *src;
  8009c4:	83 c2 01             	add    $0x1,%edx
  8009c7:	0f b6 01             	movzbl (%ecx),%eax
  8009ca:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009cd:	80 39 01             	cmpb   $0x1,(%ecx)
  8009d0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009d3:	39 da                	cmp    %ebx,%edx
  8009d5:	75 ed                	jne    8009c4 <strncpy+0x14>
	}
	return ret;
}
  8009d7:	89 f0                	mov    %esi,%eax
  8009d9:	5b                   	pop    %ebx
  8009da:	5e                   	pop    %esi
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	56                   	push   %esi
  8009e1:	53                   	push   %ebx
  8009e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009eb:	89 f0                	mov    %esi,%eax
  8009ed:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f1:	85 c9                	test   %ecx,%ecx
  8009f3:	75 0b                	jne    800a00 <strlcpy+0x23>
  8009f5:	eb 17                	jmp    800a0e <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a00:	39 d8                	cmp    %ebx,%eax
  800a02:	74 07                	je     800a0b <strlcpy+0x2e>
  800a04:	0f b6 0a             	movzbl (%edx),%ecx
  800a07:	84 c9                	test   %cl,%cl
  800a09:	75 ec                	jne    8009f7 <strlcpy+0x1a>
		*dst = '\0';
  800a0b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0e:	29 f0                	sub    %esi,%eax
}
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a1d:	eb 06                	jmp    800a25 <strcmp+0x11>
		p++, q++;
  800a1f:	83 c1 01             	add    $0x1,%ecx
  800a22:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a25:	0f b6 01             	movzbl (%ecx),%eax
  800a28:	84 c0                	test   %al,%al
  800a2a:	74 04                	je     800a30 <strcmp+0x1c>
  800a2c:	3a 02                	cmp    (%edx),%al
  800a2e:	74 ef                	je     800a1f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a30:	0f b6 c0             	movzbl %al,%eax
  800a33:	0f b6 12             	movzbl (%edx),%edx
  800a36:	29 d0                	sub    %edx,%eax
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	53                   	push   %ebx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a44:	89 c3                	mov    %eax,%ebx
  800a46:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a49:	eb 06                	jmp    800a51 <strncmp+0x17>
		n--, p++, q++;
  800a4b:	83 c0 01             	add    $0x1,%eax
  800a4e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a51:	39 d8                	cmp    %ebx,%eax
  800a53:	74 16                	je     800a6b <strncmp+0x31>
  800a55:	0f b6 08             	movzbl (%eax),%ecx
  800a58:	84 c9                	test   %cl,%cl
  800a5a:	74 04                	je     800a60 <strncmp+0x26>
  800a5c:	3a 0a                	cmp    (%edx),%cl
  800a5e:	74 eb                	je     800a4b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a60:	0f b6 00             	movzbl (%eax),%eax
  800a63:	0f b6 12             	movzbl (%edx),%edx
  800a66:	29 d0                	sub    %edx,%eax
}
  800a68:	5b                   	pop    %ebx
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    
		return 0;
  800a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a70:	eb f6                	jmp    800a68 <strncmp+0x2e>

00800a72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7c:	0f b6 10             	movzbl (%eax),%edx
  800a7f:	84 d2                	test   %dl,%dl
  800a81:	74 09                	je     800a8c <strchr+0x1a>
		if (*s == c)
  800a83:	38 ca                	cmp    %cl,%dl
  800a85:	74 0a                	je     800a91 <strchr+0x1f>
	for (; *s; s++)
  800a87:	83 c0 01             	add    $0x1,%eax
  800a8a:	eb f0                	jmp    800a7c <strchr+0xa>
			return (char *) s;
	return 0;
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9d:	eb 03                	jmp    800aa2 <strfind+0xf>
  800a9f:	83 c0 01             	add    $0x1,%eax
  800aa2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aa5:	38 ca                	cmp    %cl,%dl
  800aa7:	74 04                	je     800aad <strfind+0x1a>
  800aa9:	84 d2                	test   %dl,%dl
  800aab:	75 f2                	jne    800a9f <strfind+0xc>
			break;
	return (char *) s;
}
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800abb:	85 c9                	test   %ecx,%ecx
  800abd:	74 13                	je     800ad2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800abf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ac5:	75 05                	jne    800acc <memset+0x1d>
  800ac7:	f6 c1 03             	test   $0x3,%cl
  800aca:	74 0d                	je     800ad9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	fc                   	cld    
  800ad0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad2:	89 f8                	mov    %edi,%eax
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    
		c &= 0xFF;
  800ad9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800add:	89 d3                	mov    %edx,%ebx
  800adf:	c1 e3 08             	shl    $0x8,%ebx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	c1 e0 18             	shl    $0x18,%eax
  800ae7:	89 d6                	mov    %edx,%esi
  800ae9:	c1 e6 10             	shl    $0x10,%esi
  800aec:	09 f0                	or     %esi,%eax
  800aee:	09 c2                	or     %eax,%edx
  800af0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800af2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	fc                   	cld    
  800af8:	f3 ab                	rep stos %eax,%es:(%edi)
  800afa:	eb d6                	jmp    800ad2 <memset+0x23>

00800afc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	57                   	push   %edi
  800b00:	56                   	push   %esi
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b0a:	39 c6                	cmp    %eax,%esi
  800b0c:	73 35                	jae    800b43 <memmove+0x47>
  800b0e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	76 2e                	jbe    800b43 <memmove+0x47>
		s += n;
		d += n;
  800b15:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	09 fe                	or     %edi,%esi
  800b1c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b22:	74 0c                	je     800b30 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b24:	83 ef 01             	sub    $0x1,%edi
  800b27:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2a:	fd                   	std    
  800b2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b2d:	fc                   	cld    
  800b2e:	eb 21                	jmp    800b51 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b30:	f6 c1 03             	test   $0x3,%cl
  800b33:	75 ef                	jne    800b24 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b35:	83 ef 04             	sub    $0x4,%edi
  800b38:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b3b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b3e:	fd                   	std    
  800b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b41:	eb ea                	jmp    800b2d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b43:	89 f2                	mov    %esi,%edx
  800b45:	09 c2                	or     %eax,%edx
  800b47:	f6 c2 03             	test   $0x3,%dl
  800b4a:	74 09                	je     800b55 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b4c:	89 c7                	mov    %eax,%edi
  800b4e:	fc                   	cld    
  800b4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b51:	5e                   	pop    %esi
  800b52:	5f                   	pop    %edi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b55:	f6 c1 03             	test   $0x3,%cl
  800b58:	75 f2                	jne    800b4c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b5d:	89 c7                	mov    %eax,%edi
  800b5f:	fc                   	cld    
  800b60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b62:	eb ed                	jmp    800b51 <memmove+0x55>

00800b64 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b67:	ff 75 10             	pushl  0x10(%ebp)
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	ff 75 08             	pushl  0x8(%ebp)
  800b70:	e8 87 ff ff ff       	call   800afc <memmove>
}
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b82:	89 c6                	mov    %eax,%esi
  800b84:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b87:	39 f0                	cmp    %esi,%eax
  800b89:	74 1c                	je     800ba7 <memcmp+0x30>
		if (*s1 != *s2)
  800b8b:	0f b6 08             	movzbl (%eax),%ecx
  800b8e:	0f b6 1a             	movzbl (%edx),%ebx
  800b91:	38 d9                	cmp    %bl,%cl
  800b93:	75 08                	jne    800b9d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b95:	83 c0 01             	add    $0x1,%eax
  800b98:	83 c2 01             	add    $0x1,%edx
  800b9b:	eb ea                	jmp    800b87 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b9d:	0f b6 c1             	movzbl %cl,%eax
  800ba0:	0f b6 db             	movzbl %bl,%ebx
  800ba3:	29 d8                	sub    %ebx,%eax
  800ba5:	eb 05                	jmp    800bac <memcmp+0x35>
	}

	return 0;
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bbe:	39 d0                	cmp    %edx,%eax
  800bc0:	73 09                	jae    800bcb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc2:	38 08                	cmp    %cl,(%eax)
  800bc4:	74 05                	je     800bcb <memfind+0x1b>
	for (; s < ends; s++)
  800bc6:	83 c0 01             	add    $0x1,%eax
  800bc9:	eb f3                	jmp    800bbe <memfind+0xe>
			break;
	return (void *) s;
}
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd9:	eb 03                	jmp    800bde <strtol+0x11>
		s++;
  800bdb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bde:	0f b6 01             	movzbl (%ecx),%eax
  800be1:	3c 20                	cmp    $0x20,%al
  800be3:	74 f6                	je     800bdb <strtol+0xe>
  800be5:	3c 09                	cmp    $0x9,%al
  800be7:	74 f2                	je     800bdb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800be9:	3c 2b                	cmp    $0x2b,%al
  800beb:	74 2e                	je     800c1b <strtol+0x4e>
	int neg = 0;
  800bed:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf2:	3c 2d                	cmp    $0x2d,%al
  800bf4:	74 2f                	je     800c25 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bfc:	75 05                	jne    800c03 <strtol+0x36>
  800bfe:	80 39 30             	cmpb   $0x30,(%ecx)
  800c01:	74 2c                	je     800c2f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c03:	85 db                	test   %ebx,%ebx
  800c05:	75 0a                	jne    800c11 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c07:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c0c:	80 39 30             	cmpb   $0x30,(%ecx)
  800c0f:	74 28                	je     800c39 <strtol+0x6c>
		base = 10;
  800c11:	b8 00 00 00 00       	mov    $0x0,%eax
  800c16:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c19:	eb 50                	jmp    800c6b <strtol+0x9e>
		s++;
  800c1b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c23:	eb d1                	jmp    800bf6 <strtol+0x29>
		s++, neg = 1;
  800c25:	83 c1 01             	add    $0x1,%ecx
  800c28:	bf 01 00 00 00       	mov    $0x1,%edi
  800c2d:	eb c7                	jmp    800bf6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c33:	74 0e                	je     800c43 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c35:	85 db                	test   %ebx,%ebx
  800c37:	75 d8                	jne    800c11 <strtol+0x44>
		s++, base = 8;
  800c39:	83 c1 01             	add    $0x1,%ecx
  800c3c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c41:	eb ce                	jmp    800c11 <strtol+0x44>
		s += 2, base = 16;
  800c43:	83 c1 02             	add    $0x2,%ecx
  800c46:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c4b:	eb c4                	jmp    800c11 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c4d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c50:	89 f3                	mov    %esi,%ebx
  800c52:	80 fb 19             	cmp    $0x19,%bl
  800c55:	77 29                	ja     800c80 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c57:	0f be d2             	movsbl %dl,%edx
  800c5a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c5d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c60:	7d 30                	jge    800c92 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c62:	83 c1 01             	add    $0x1,%ecx
  800c65:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c69:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c6b:	0f b6 11             	movzbl (%ecx),%edx
  800c6e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	80 fb 09             	cmp    $0x9,%bl
  800c76:	77 d5                	ja     800c4d <strtol+0x80>
			dig = *s - '0';
  800c78:	0f be d2             	movsbl %dl,%edx
  800c7b:	83 ea 30             	sub    $0x30,%edx
  800c7e:	eb dd                	jmp    800c5d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c80:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c83:	89 f3                	mov    %esi,%ebx
  800c85:	80 fb 19             	cmp    $0x19,%bl
  800c88:	77 08                	ja     800c92 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c8a:	0f be d2             	movsbl %dl,%edx
  800c8d:	83 ea 37             	sub    $0x37,%edx
  800c90:	eb cb                	jmp    800c5d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c96:	74 05                	je     800c9d <strtol+0xd0>
		*endptr = (char *) s;
  800c98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c9d:	89 c2                	mov    %eax,%edx
  800c9f:	f7 da                	neg    %edx
  800ca1:	85 ff                	test   %edi,%edi
  800ca3:	0f 45 c2             	cmovne %edx,%eax
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbc:	89 c3                	mov    %eax,%ebx
  800cbe:	89 c7                	mov    %eax,%edi
  800cc0:	89 c6                	mov    %eax,%esi
  800cc2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd4:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd9:	89 d1                	mov    %edx,%ecx
  800cdb:	89 d3                	mov    %edx,%ebx
  800cdd:	89 d7                	mov    %edx,%edi
  800cdf:	89 d6                	mov    %edx,%esi
  800ce1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfe:	89 cb                	mov    %ecx,%ebx
  800d00:	89 cf                	mov    %ecx,%edi
  800d02:	89 ce                	mov    %ecx,%esi
  800d04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 03                	push   $0x3
  800d18:	68 3f 32 80 00       	push   $0x80323f
  800d1d:	6a 23                	push   $0x23
  800d1f:	68 5c 32 80 00       	push   $0x80325c
  800d24:	e8 cd f4 ff ff       	call   8001f6 <_panic>

00800d29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d34:	b8 02 00 00 00       	mov    $0x2,%eax
  800d39:	89 d1                	mov    %edx,%ecx
  800d3b:	89 d3                	mov    %edx,%ebx
  800d3d:	89 d7                	mov    %edx,%edi
  800d3f:	89 d6                	mov    %edx,%esi
  800d41:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <sys_yield>:

void
sys_yield(void)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d58:	89 d1                	mov    %edx,%ecx
  800d5a:	89 d3                	mov    %edx,%ebx
  800d5c:	89 d7                	mov    %edx,%edi
  800d5e:	89 d6                	mov    %edx,%esi
  800d60:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d70:	be 00 00 00 00       	mov    $0x0,%esi
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d83:	89 f7                	mov    %esi,%edi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 04                	push   $0x4
  800d99:	68 3f 32 80 00       	push   $0x80323f
  800d9e:	6a 23                	push   $0x23
  800da0:	68 5c 32 80 00       	push   $0x80325c
  800da5:	e8 4c f4 ff ff       	call   8001f6 <_panic>

00800daa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc4:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 05                	push   $0x5
  800ddb:	68 3f 32 80 00       	push   $0x80323f
  800de0:	6a 23                	push   $0x23
  800de2:	68 5c 32 80 00       	push   $0x80325c
  800de7:	e8 0a f4 ff ff       	call   8001f6 <_panic>

00800dec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 06 00 00 00       	mov    $0x6,%eax
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7f 08                	jg     800e17 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	50                   	push   %eax
  800e1b:	6a 06                	push   $0x6
  800e1d:	68 3f 32 80 00       	push   $0x80323f
  800e22:	6a 23                	push   $0x23
  800e24:	68 5c 32 80 00       	push   $0x80325c
  800e29:	e8 c8 f3 ff ff       	call   8001f6 <_panic>

00800e2e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	b8 08 00 00 00       	mov    $0x8,%eax
  800e47:	89 df                	mov    %ebx,%edi
  800e49:	89 de                	mov    %ebx,%esi
  800e4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	7f 08                	jg     800e59 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	6a 08                	push   $0x8
  800e5f:	68 3f 32 80 00       	push   $0x80323f
  800e64:	6a 23                	push   $0x23
  800e66:	68 5c 32 80 00       	push   $0x80325c
  800e6b:	e8 86 f3 ff ff       	call   8001f6 <_panic>

00800e70 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e84:	b8 09 00 00 00       	mov    $0x9,%eax
  800e89:	89 df                	mov    %ebx,%edi
  800e8b:	89 de                	mov    %ebx,%esi
  800e8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	7f 08                	jg     800e9b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	50                   	push   %eax
  800e9f:	6a 09                	push   $0x9
  800ea1:	68 3f 32 80 00       	push   $0x80323f
  800ea6:	6a 23                	push   $0x23
  800ea8:	68 5c 32 80 00       	push   $0x80325c
  800ead:	e8 44 f3 ff ff       	call   8001f6 <_panic>

00800eb2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
  800eb8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecb:	89 df                	mov    %ebx,%edi
  800ecd:	89 de                	mov    %ebx,%esi
  800ecf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	7f 08                	jg     800edd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ed5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edd:	83 ec 0c             	sub    $0xc,%esp
  800ee0:	50                   	push   %eax
  800ee1:	6a 0a                	push   $0xa
  800ee3:	68 3f 32 80 00       	push   $0x80323f
  800ee8:	6a 23                	push   $0x23
  800eea:	68 5c 32 80 00       	push   $0x80325c
  800eef:	e8 02 f3 ff ff       	call   8001f6 <_panic>

00800ef4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f00:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f05:	be 00 00 00 00       	mov    $0x0,%esi
  800f0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f0d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f10:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f2d:	89 cb                	mov    %ecx,%ebx
  800f2f:	89 cf                	mov    %ecx,%edi
  800f31:	89 ce                	mov    %ecx,%esi
  800f33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7f 08                	jg     800f41 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	50                   	push   %eax
  800f45:	6a 0d                	push   $0xd
  800f47:	68 3f 32 80 00       	push   $0x80323f
  800f4c:	6a 23                	push   $0x23
  800f4e:	68 5c 32 80 00       	push   $0x80325c
  800f53:	e8 9e f2 ff ff       	call   8001f6 <_panic>

00800f58 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f63:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f68:	89 d1                	mov    %edx,%ecx
  800f6a:	89 d3                	mov    %edx,%ebx
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	89 d6                	mov    %edx,%esi
  800f70:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
  800f7d:	83 ec 1c             	sub    $0x1c,%esp
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800f83:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800f85:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800f88:	89 d8                	mov    %ebx,%eax
  800f8a:	c1 e8 0c             	shr    $0xc,%eax
  800f8d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800f97:	e8 8d fd ff ff       	call   800d29 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800f9c:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800fa2:	74 73                	je     801017 <pgfault+0xa0>
  800fa4:	89 c6                	mov    %eax,%esi
  800fa6:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800fad:	74 68                	je     801017 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800faf:	83 ec 04             	sub    $0x4,%esp
  800fb2:	6a 07                	push   $0x7
  800fb4:	68 00 f0 7f 00       	push   $0x7ff000
  800fb9:	50                   	push   %eax
  800fba:	e8 a8 fd ff ff       	call   800d67 <sys_page_alloc>
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	75 65                	jne    80102b <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800fc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	68 00 10 00 00       	push   $0x1000
  800fd4:	53                   	push   %ebx
  800fd5:	68 00 f0 7f 00       	push   $0x7ff000
  800fda:	e8 85 fb ff ff       	call   800b64 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800fdf:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fe6:	53                   	push   %ebx
  800fe7:	56                   	push   %esi
  800fe8:	68 00 f0 7f 00       	push   $0x7ff000
  800fed:	56                   	push   %esi
  800fee:	e8 b7 fd ff ff       	call   800daa <sys_page_map>
  800ff3:	83 c4 20             	add    $0x20,%esp
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	75 43                	jne    80103d <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800ffa:	83 ec 08             	sub    $0x8,%esp
  800ffd:	68 00 f0 7f 00       	push   $0x7ff000
  801002:	56                   	push   %esi
  801003:	e8 e4 fd ff ff       	call   800dec <sys_page_unmap>
  801008:	83 c4 10             	add    $0x10,%esp
  80100b:	85 c0                	test   %eax,%eax
  80100d:	75 40                	jne    80104f <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  80100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  801017:	83 ec 04             	sub    $0x4,%esp
  80101a:	68 6a 32 80 00       	push   $0x80326a
  80101f:	6a 1f                	push   $0x1f
  801021:	68 88 32 80 00       	push   $0x803288
  801026:	e8 cb f1 ff ff       	call   8001f6 <_panic>
	    panic("pgfault: %e", r);
  80102b:	50                   	push   %eax
  80102c:	68 93 32 80 00       	push   $0x803293
  801031:	6a 2a                	push   $0x2a
  801033:	68 88 32 80 00       	push   $0x803288
  801038:	e8 b9 f1 ff ff       	call   8001f6 <_panic>
	    panic("pgfault: %e", r);
  80103d:	50                   	push   %eax
  80103e:	68 93 32 80 00       	push   $0x803293
  801043:	6a 2e                	push   $0x2e
  801045:	68 88 32 80 00       	push   $0x803288
  80104a:	e8 a7 f1 ff ff       	call   8001f6 <_panic>
	    panic("pgfault: %e", r);
  80104f:	50                   	push   %eax
  801050:	68 93 32 80 00       	push   $0x803293
  801055:	6a 31                	push   $0x31
  801057:	68 88 32 80 00       	push   $0x803288
  80105c:	e8 95 f1 ff ff       	call   8001f6 <_panic>

00801061 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	57                   	push   %edi
  801065:	56                   	push   %esi
  801066:	53                   	push   %ebx
  801067:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  80106a:	68 77 0f 80 00       	push   $0x800f77
  80106f:	e8 d2 19 00 00       	call   802a46 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801074:	b8 07 00 00 00       	mov    $0x7,%eax
  801079:	cd 30                	int    $0x30
  80107b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80107e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  801081:	83 c4 10             	add    $0x10,%esp
  801084:	85 c0                	test   %eax,%eax
  801086:	78 2b                	js     8010b3 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801088:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80108d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801091:	0f 85 b5 00 00 00    	jne    80114c <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  801097:	e8 8d fc ff ff       	call   800d29 <sys_getenvid>
  80109c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a9:	a3 08 50 80 00       	mov    %eax,0x805008
	    return 0;
  8010ae:	e9 8c 01 00 00       	jmp    80123f <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  8010b3:	50                   	push   %eax
  8010b4:	68 9f 32 80 00       	push   $0x80329f
  8010b9:	6a 77                	push   $0x77
  8010bb:	68 88 32 80 00       	push   $0x803288
  8010c0:	e8 31 f1 ff ff       	call   8001f6 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  8010c5:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010cc:	83 ec 0c             	sub    $0xc,%esp
  8010cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d4:	50                   	push   %eax
  8010d5:	57                   	push   %edi
  8010d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8010d9:	57                   	push   %edi
  8010da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010dd:	e8 c8 fc ff ff       	call   800daa <sys_page_map>
  8010e2:	83 c4 20             	add    $0x20,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	74 51                	je     80113a <fork+0xd9>
           panic("duppage: %e", r);
  8010e9:	50                   	push   %eax
  8010ea:	68 af 32 80 00       	push   $0x8032af
  8010ef:	6a 4a                	push   $0x4a
  8010f1:	68 88 32 80 00       	push   $0x803288
  8010f6:	e8 fb f0 ff ff       	call   8001f6 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	68 05 08 00 00       	push   $0x805
  801103:	57                   	push   %edi
  801104:	ff 75 e0             	pushl  -0x20(%ebp)
  801107:	57                   	push   %edi
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	e8 9a fc ff ff       	call   800daa <sys_page_map>
  801110:	83 c4 20             	add    $0x20,%esp
  801113:	85 c0                	test   %eax,%eax
  801115:	0f 85 bc 00 00 00    	jne    8011d7 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	68 05 08 00 00       	push   $0x805
  801123:	57                   	push   %edi
  801124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801127:	50                   	push   %eax
  801128:	57                   	push   %edi
  801129:	50                   	push   %eax
  80112a:	e8 7b fc ff ff       	call   800daa <sys_page_map>
  80112f:	83 c4 20             	add    $0x20,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	0f 85 af 00 00 00    	jne    8011e9 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80113a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801140:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801146:	0f 84 af 00 00 00    	je     8011fb <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  80114c:	89 d8                	mov    %ebx,%eax
  80114e:	c1 e8 16             	shr    $0x16,%eax
  801151:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801158:	a8 01                	test   $0x1,%al
  80115a:	74 de                	je     80113a <fork+0xd9>
  80115c:	89 de                	mov    %ebx,%esi
  80115e:	c1 ee 0c             	shr    $0xc,%esi
  801161:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801168:	a8 01                	test   $0x1,%al
  80116a:	74 ce                	je     80113a <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  80116c:	e8 b8 fb ff ff       	call   800d29 <sys_getenvid>
  801171:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  801174:	89 f7                	mov    %esi,%edi
  801176:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  801179:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801180:	f6 c4 04             	test   $0x4,%ah
  801183:	0f 85 3c ff ff ff    	jne    8010c5 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  801189:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801190:	a8 02                	test   $0x2,%al
  801192:	0f 85 63 ff ff ff    	jne    8010fb <fork+0x9a>
  801198:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80119f:	f6 c4 08             	test   $0x8,%ah
  8011a2:	0f 85 53 ff ff ff    	jne    8010fb <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8011a8:	83 ec 0c             	sub    $0xc,%esp
  8011ab:	6a 05                	push   $0x5
  8011ad:	57                   	push   %edi
  8011ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8011b1:	57                   	push   %edi
  8011b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b5:	e8 f0 fb ff ff       	call   800daa <sys_page_map>
  8011ba:	83 c4 20             	add    $0x20,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	0f 84 75 ff ff ff    	je     80113a <fork+0xd9>
	        panic("duppage: %e", r);
  8011c5:	50                   	push   %eax
  8011c6:	68 af 32 80 00       	push   $0x8032af
  8011cb:	6a 55                	push   $0x55
  8011cd:	68 88 32 80 00       	push   $0x803288
  8011d2:	e8 1f f0 ff ff       	call   8001f6 <_panic>
	        panic("duppage: %e", r);
  8011d7:	50                   	push   %eax
  8011d8:	68 af 32 80 00       	push   $0x8032af
  8011dd:	6a 4e                	push   $0x4e
  8011df:	68 88 32 80 00       	push   $0x803288
  8011e4:	e8 0d f0 ff ff       	call   8001f6 <_panic>
	        panic("duppage: %e", r);
  8011e9:	50                   	push   %eax
  8011ea:	68 af 32 80 00       	push   $0x8032af
  8011ef:	6a 51                	push   $0x51
  8011f1:	68 88 32 80 00       	push   $0x803288
  8011f6:	e8 fb ef ff ff       	call   8001f6 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	6a 07                	push   $0x7
  801200:	68 00 f0 bf ee       	push   $0xeebff000
  801205:	ff 75 dc             	pushl  -0x24(%ebp)
  801208:	e8 5a fb ff ff       	call   800d67 <sys_page_alloc>
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	85 c0                	test   %eax,%eax
  801212:	75 36                	jne    80124a <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	68 bf 2a 80 00       	push   $0x802abf
  80121c:	ff 75 dc             	pushl  -0x24(%ebp)
  80121f:	e8 8e fc ff ff       	call   800eb2 <sys_env_set_pgfault_upcall>
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	75 34                	jne    80125f <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	6a 02                	push   $0x2
  801230:	ff 75 dc             	pushl  -0x24(%ebp)
  801233:	e8 f6 fb ff ff       	call   800e2e <sys_env_set_status>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	75 35                	jne    801274 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  80123f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801242:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    
	    panic("fork: %e", r);
  80124a:	50                   	push   %eax
  80124b:	68 a6 32 80 00       	push   $0x8032a6
  801250:	68 8a 00 00 00       	push   $0x8a
  801255:	68 88 32 80 00       	push   $0x803288
  80125a:	e8 97 ef ff ff       	call   8001f6 <_panic>
	    panic("fork: %e", r);
  80125f:	50                   	push   %eax
  801260:	68 a6 32 80 00       	push   $0x8032a6
  801265:	68 8d 00 00 00       	push   $0x8d
  80126a:	68 88 32 80 00       	push   $0x803288
  80126f:	e8 82 ef ff ff       	call   8001f6 <_panic>
	    panic("fork: %e", r);
  801274:	50                   	push   %eax
  801275:	68 a6 32 80 00       	push   $0x8032a6
  80127a:	68 92 00 00 00       	push   $0x92
  80127f:	68 88 32 80 00       	push   $0x803288
  801284:	e8 6d ef ff ff       	call   8001f6 <_panic>

00801289 <sfork>:

// Challenge!
int
sfork(void)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80128f:	68 bb 32 80 00       	push   $0x8032bb
  801294:	68 9b 00 00 00       	push   $0x9b
  801299:	68 88 32 80 00       	push   $0x803288
  80129e:	e8 53 ef ff ff       	call   8001f6 <_panic>

008012a3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ae:	c1 e8 0c             	shr    $0xc,%eax
}
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    

008012ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	c1 ea 16             	shr    $0x16,%edx
  8012da:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e1:	f6 c2 01             	test   $0x1,%dl
  8012e4:	74 2a                	je     801310 <fd_alloc+0x46>
  8012e6:	89 c2                	mov    %eax,%edx
  8012e8:	c1 ea 0c             	shr    $0xc,%edx
  8012eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f2:	f6 c2 01             	test   $0x1,%dl
  8012f5:	74 19                	je     801310 <fd_alloc+0x46>
  8012f7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012fc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801301:	75 d2                	jne    8012d5 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801303:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801309:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80130e:	eb 07                	jmp    801317 <fd_alloc+0x4d>
			*fd_store = fd;
  801310:	89 01                	mov    %eax,(%ecx)
			return 0;
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80131f:	83 f8 1f             	cmp    $0x1f,%eax
  801322:	77 36                	ja     80135a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801324:	c1 e0 0c             	shl    $0xc,%eax
  801327:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80132c:	89 c2                	mov    %eax,%edx
  80132e:	c1 ea 16             	shr    $0x16,%edx
  801331:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801338:	f6 c2 01             	test   $0x1,%dl
  80133b:	74 24                	je     801361 <fd_lookup+0x48>
  80133d:	89 c2                	mov    %eax,%edx
  80133f:	c1 ea 0c             	shr    $0xc,%edx
  801342:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801349:	f6 c2 01             	test   $0x1,%dl
  80134c:	74 1a                	je     801368 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801351:	89 02                	mov    %eax,(%edx)
	return 0;
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    
		return -E_INVAL;
  80135a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135f:	eb f7                	jmp    801358 <fd_lookup+0x3f>
		return -E_INVAL;
  801361:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801366:	eb f0                	jmp    801358 <fd_lookup+0x3f>
  801368:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136d:	eb e9                	jmp    801358 <fd_lookup+0x3f>

0080136f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801378:	ba 50 33 80 00       	mov    $0x803350,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80137d:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801382:	39 08                	cmp    %ecx,(%eax)
  801384:	74 33                	je     8013b9 <dev_lookup+0x4a>
  801386:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801389:	8b 02                	mov    (%edx),%eax
  80138b:	85 c0                	test   %eax,%eax
  80138d:	75 f3                	jne    801382 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80138f:	a1 08 50 80 00       	mov    0x805008,%eax
  801394:	8b 40 48             	mov    0x48(%eax),%eax
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	51                   	push   %ecx
  80139b:	50                   	push   %eax
  80139c:	68 d4 32 80 00       	push   $0x8032d4
  8013a1:	e8 2b ef ff ff       	call   8002d1 <cprintf>
	*dev = 0;
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    
			*dev = devtab[i];
  8013b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c3:	eb f2                	jmp    8013b7 <dev_lookup+0x48>

008013c5 <fd_close>:
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	57                   	push   %edi
  8013c9:	56                   	push   %esi
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 1c             	sub    $0x1c,%esp
  8013ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013de:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e1:	50                   	push   %eax
  8013e2:	e8 32 ff ff ff       	call   801319 <fd_lookup>
  8013e7:	89 c3                	mov    %eax,%ebx
  8013e9:	83 c4 08             	add    $0x8,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 05                	js     8013f5 <fd_close+0x30>
	    || fd != fd2)
  8013f0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013f3:	74 16                	je     80140b <fd_close+0x46>
		return (must_exist ? r : 0);
  8013f5:	89 f8                	mov    %edi,%eax
  8013f7:	84 c0                	test   %al,%al
  8013f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fe:	0f 44 d8             	cmove  %eax,%ebx
}
  801401:	89 d8                	mov    %ebx,%eax
  801403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801406:	5b                   	pop    %ebx
  801407:	5e                   	pop    %esi
  801408:	5f                   	pop    %edi
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801411:	50                   	push   %eax
  801412:	ff 36                	pushl  (%esi)
  801414:	e8 56 ff ff ff       	call   80136f <dev_lookup>
  801419:	89 c3                	mov    %eax,%ebx
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 15                	js     801437 <fd_close+0x72>
		if (dev->dev_close)
  801422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801425:	8b 40 10             	mov    0x10(%eax),%eax
  801428:	85 c0                	test   %eax,%eax
  80142a:	74 1b                	je     801447 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80142c:	83 ec 0c             	sub    $0xc,%esp
  80142f:	56                   	push   %esi
  801430:	ff d0                	call   *%eax
  801432:	89 c3                	mov    %eax,%ebx
  801434:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	56                   	push   %esi
  80143b:	6a 00                	push   $0x0
  80143d:	e8 aa f9 ff ff       	call   800dec <sys_page_unmap>
	return r;
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	eb ba                	jmp    801401 <fd_close+0x3c>
			r = 0;
  801447:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144c:	eb e9                	jmp    801437 <fd_close+0x72>

0080144e <close>:

int
close(int fdnum)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801454:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801457:	50                   	push   %eax
  801458:	ff 75 08             	pushl  0x8(%ebp)
  80145b:	e8 b9 fe ff ff       	call   801319 <fd_lookup>
  801460:	83 c4 08             	add    $0x8,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	78 10                	js     801477 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801467:	83 ec 08             	sub    $0x8,%esp
  80146a:	6a 01                	push   $0x1
  80146c:	ff 75 f4             	pushl  -0xc(%ebp)
  80146f:	e8 51 ff ff ff       	call   8013c5 <fd_close>
  801474:	83 c4 10             	add    $0x10,%esp
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <close_all>:

void
close_all(void)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	53                   	push   %ebx
  80147d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801480:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	53                   	push   %ebx
  801489:	e8 c0 ff ff ff       	call   80144e <close>
	for (i = 0; i < MAXFD; i++)
  80148e:	83 c3 01             	add    $0x1,%ebx
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	83 fb 20             	cmp    $0x20,%ebx
  801497:	75 ec                	jne    801485 <close_all+0xc>
}
  801499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	57                   	push   %edi
  8014a2:	56                   	push   %esi
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014aa:	50                   	push   %eax
  8014ab:	ff 75 08             	pushl  0x8(%ebp)
  8014ae:	e8 66 fe ff ff       	call   801319 <fd_lookup>
  8014b3:	89 c3                	mov    %eax,%ebx
  8014b5:	83 c4 08             	add    $0x8,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	0f 88 81 00 00 00    	js     801541 <dup+0xa3>
		return r;
	close(newfdnum);
  8014c0:	83 ec 0c             	sub    $0xc,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	e8 83 ff ff ff       	call   80144e <close>

	newfd = INDEX2FD(newfdnum);
  8014cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014ce:	c1 e6 0c             	shl    $0xc,%esi
  8014d1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014d7:	83 c4 04             	add    $0x4,%esp
  8014da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014dd:	e8 d1 fd ff ff       	call   8012b3 <fd2data>
  8014e2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014e4:	89 34 24             	mov    %esi,(%esp)
  8014e7:	e8 c7 fd ff ff       	call   8012b3 <fd2data>
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014f1:	89 d8                	mov    %ebx,%eax
  8014f3:	c1 e8 16             	shr    $0x16,%eax
  8014f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014fd:	a8 01                	test   $0x1,%al
  8014ff:	74 11                	je     801512 <dup+0x74>
  801501:	89 d8                	mov    %ebx,%eax
  801503:	c1 e8 0c             	shr    $0xc,%eax
  801506:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80150d:	f6 c2 01             	test   $0x1,%dl
  801510:	75 39                	jne    80154b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801512:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801515:	89 d0                	mov    %edx,%eax
  801517:	c1 e8 0c             	shr    $0xc,%eax
  80151a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801521:	83 ec 0c             	sub    $0xc,%esp
  801524:	25 07 0e 00 00       	and    $0xe07,%eax
  801529:	50                   	push   %eax
  80152a:	56                   	push   %esi
  80152b:	6a 00                	push   $0x0
  80152d:	52                   	push   %edx
  80152e:	6a 00                	push   $0x0
  801530:	e8 75 f8 ff ff       	call   800daa <sys_page_map>
  801535:	89 c3                	mov    %eax,%ebx
  801537:	83 c4 20             	add    $0x20,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 31                	js     80156f <dup+0xd1>
		goto err;

	return newfdnum;
  80153e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801541:	89 d8                	mov    %ebx,%eax
  801543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5f                   	pop    %edi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80154b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	25 07 0e 00 00       	and    $0xe07,%eax
  80155a:	50                   	push   %eax
  80155b:	57                   	push   %edi
  80155c:	6a 00                	push   $0x0
  80155e:	53                   	push   %ebx
  80155f:	6a 00                	push   $0x0
  801561:	e8 44 f8 ff ff       	call   800daa <sys_page_map>
  801566:	89 c3                	mov    %eax,%ebx
  801568:	83 c4 20             	add    $0x20,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	79 a3                	jns    801512 <dup+0x74>
	sys_page_unmap(0, newfd);
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	56                   	push   %esi
  801573:	6a 00                	push   $0x0
  801575:	e8 72 f8 ff ff       	call   800dec <sys_page_unmap>
	sys_page_unmap(0, nva);
  80157a:	83 c4 08             	add    $0x8,%esp
  80157d:	57                   	push   %edi
  80157e:	6a 00                	push   $0x0
  801580:	e8 67 f8 ff ff       	call   800dec <sys_page_unmap>
	return r;
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	eb b7                	jmp    801541 <dup+0xa3>

0080158a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	53                   	push   %ebx
  80158e:	83 ec 14             	sub    $0x14,%esp
  801591:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801594:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801597:	50                   	push   %eax
  801598:	53                   	push   %ebx
  801599:	e8 7b fd ff ff       	call   801319 <fd_lookup>
  80159e:	83 c4 08             	add    $0x8,%esp
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	78 3f                	js     8015e4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ab:	50                   	push   %eax
  8015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015af:	ff 30                	pushl  (%eax)
  8015b1:	e8 b9 fd ff ff       	call   80136f <dev_lookup>
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 27                	js     8015e4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c0:	8b 42 08             	mov    0x8(%edx),%eax
  8015c3:	83 e0 03             	and    $0x3,%eax
  8015c6:	83 f8 01             	cmp    $0x1,%eax
  8015c9:	74 1e                	je     8015e9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ce:	8b 40 08             	mov    0x8(%eax),%eax
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	74 35                	je     80160a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	ff 75 10             	pushl  0x10(%ebp)
  8015db:	ff 75 0c             	pushl  0xc(%ebp)
  8015de:	52                   	push   %edx
  8015df:	ff d0                	call   *%eax
  8015e1:	83 c4 10             	add    $0x10,%esp
}
  8015e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015e9:	a1 08 50 80 00       	mov    0x805008,%eax
  8015ee:	8b 40 48             	mov    0x48(%eax),%eax
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	53                   	push   %ebx
  8015f5:	50                   	push   %eax
  8015f6:	68 15 33 80 00       	push   $0x803315
  8015fb:	e8 d1 ec ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801608:	eb da                	jmp    8015e4 <read+0x5a>
		return -E_NOT_SUPP;
  80160a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160f:	eb d3                	jmp    8015e4 <read+0x5a>

00801611 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	57                   	push   %edi
  801615:	56                   	push   %esi
  801616:	53                   	push   %ebx
  801617:	83 ec 0c             	sub    $0xc,%esp
  80161a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801620:	bb 00 00 00 00       	mov    $0x0,%ebx
  801625:	39 f3                	cmp    %esi,%ebx
  801627:	73 25                	jae    80164e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	89 f0                	mov    %esi,%eax
  80162e:	29 d8                	sub    %ebx,%eax
  801630:	50                   	push   %eax
  801631:	89 d8                	mov    %ebx,%eax
  801633:	03 45 0c             	add    0xc(%ebp),%eax
  801636:	50                   	push   %eax
  801637:	57                   	push   %edi
  801638:	e8 4d ff ff ff       	call   80158a <read>
		if (m < 0)
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 08                	js     80164c <readn+0x3b>
			return m;
		if (m == 0)
  801644:	85 c0                	test   %eax,%eax
  801646:	74 06                	je     80164e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801648:	01 c3                	add    %eax,%ebx
  80164a:	eb d9                	jmp    801625 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80164e:	89 d8                	mov    %ebx,%eax
  801650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	53                   	push   %ebx
  80165c:	83 ec 14             	sub    $0x14,%esp
  80165f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801662:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801665:	50                   	push   %eax
  801666:	53                   	push   %ebx
  801667:	e8 ad fc ff ff       	call   801319 <fd_lookup>
  80166c:	83 c4 08             	add    $0x8,%esp
  80166f:	85 c0                	test   %eax,%eax
  801671:	78 3a                	js     8016ad <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801679:	50                   	push   %eax
  80167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167d:	ff 30                	pushl  (%eax)
  80167f:	e8 eb fc ff ff       	call   80136f <dev_lookup>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	78 22                	js     8016ad <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801692:	74 1e                	je     8016b2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801694:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801697:	8b 52 0c             	mov    0xc(%edx),%edx
  80169a:	85 d2                	test   %edx,%edx
  80169c:	74 35                	je     8016d3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	ff 75 10             	pushl  0x10(%ebp)
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	50                   	push   %eax
  8016a8:	ff d2                	call   *%edx
  8016aa:	83 c4 10             	add    $0x10,%esp
}
  8016ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b2:	a1 08 50 80 00       	mov    0x805008,%eax
  8016b7:	8b 40 48             	mov    0x48(%eax),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	53                   	push   %ebx
  8016be:	50                   	push   %eax
  8016bf:	68 31 33 80 00       	push   $0x803331
  8016c4:	e8 08 ec ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d1:	eb da                	jmp    8016ad <write+0x55>
		return -E_NOT_SUPP;
  8016d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d8:	eb d3                	jmp    8016ad <write+0x55>

008016da <seek>:

int
seek(int fdnum, off_t offset)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016e3:	50                   	push   %eax
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	e8 2d fc ff ff       	call   801319 <fd_lookup>
  8016ec:	83 c4 08             	add    $0x8,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 0e                	js     801701 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	53                   	push   %ebx
  801707:	83 ec 14             	sub    $0x14,%esp
  80170a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801710:	50                   	push   %eax
  801711:	53                   	push   %ebx
  801712:	e8 02 fc ff ff       	call   801319 <fd_lookup>
  801717:	83 c4 08             	add    $0x8,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 37                	js     801755 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801724:	50                   	push   %eax
  801725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801728:	ff 30                	pushl  (%eax)
  80172a:	e8 40 fc ff ff       	call   80136f <dev_lookup>
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	85 c0                	test   %eax,%eax
  801734:	78 1f                	js     801755 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801739:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80173d:	74 1b                	je     80175a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80173f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801742:	8b 52 18             	mov    0x18(%edx),%edx
  801745:	85 d2                	test   %edx,%edx
  801747:	74 32                	je     80177b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	ff 75 0c             	pushl  0xc(%ebp)
  80174f:	50                   	push   %eax
  801750:	ff d2                	call   *%edx
  801752:	83 c4 10             	add    $0x10,%esp
}
  801755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801758:	c9                   	leave  
  801759:	c3                   	ret    
			thisenv->env_id, fdnum);
  80175a:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80175f:	8b 40 48             	mov    0x48(%eax),%eax
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	53                   	push   %ebx
  801766:	50                   	push   %eax
  801767:	68 f4 32 80 00       	push   $0x8032f4
  80176c:	e8 60 eb ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801779:	eb da                	jmp    801755 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80177b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801780:	eb d3                	jmp    801755 <ftruncate+0x52>

00801782 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	53                   	push   %ebx
  801786:	83 ec 14             	sub    $0x14,%esp
  801789:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	e8 81 fb ff ff       	call   801319 <fd_lookup>
  801798:	83 c4 08             	add    $0x8,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 4b                	js     8017ea <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a5:	50                   	push   %eax
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a9:	ff 30                	pushl  (%eax)
  8017ab:	e8 bf fb ff ff       	call   80136f <dev_lookup>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 33                	js     8017ea <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ba:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017be:	74 2f                	je     8017ef <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017c0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017c3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017ca:	00 00 00 
	stat->st_isdir = 0;
  8017cd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017d4:	00 00 00 
	stat->st_dev = dev;
  8017d7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	53                   	push   %ebx
  8017e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e4:	ff 50 14             	call   *0x14(%eax)
  8017e7:	83 c4 10             	add    $0x10,%esp
}
  8017ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    
		return -E_NOT_SUPP;
  8017ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f4:	eb f4                	jmp    8017ea <fstat+0x68>

008017f6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	56                   	push   %esi
  8017fa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	e8 26 02 00 00       	call   801a2e <open>
  801808:	89 c3                	mov    %eax,%ebx
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 1b                	js     80182c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	50                   	push   %eax
  801818:	e8 65 ff ff ff       	call   801782 <fstat>
  80181d:	89 c6                	mov    %eax,%esi
	close(fd);
  80181f:	89 1c 24             	mov    %ebx,(%esp)
  801822:	e8 27 fc ff ff       	call   80144e <close>
	return r;
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	89 f3                	mov    %esi,%ebx
}
  80182c:	89 d8                	mov    %ebx,%eax
  80182e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801831:	5b                   	pop    %ebx
  801832:	5e                   	pop    %esi
  801833:	5d                   	pop    %ebp
  801834:	c3                   	ret    

00801835 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
  80183a:	89 c6                	mov    %eax,%esi
  80183c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80183e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801845:	74 27                	je     80186e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801847:	6a 07                	push   $0x7
  801849:	68 00 60 80 00       	push   $0x806000
  80184e:	56                   	push   %esi
  80184f:	ff 35 00 50 80 00    	pushl  0x805000
  801855:	e8 f4 12 00 00       	call   802b4e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80185a:	83 c4 0c             	add    $0xc,%esp
  80185d:	6a 00                	push   $0x0
  80185f:	53                   	push   %ebx
  801860:	6a 00                	push   $0x0
  801862:	e8 7e 12 00 00       	call   802ae5 <ipc_recv>
}
  801867:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186a:	5b                   	pop    %ebx
  80186b:	5e                   	pop    %esi
  80186c:	5d                   	pop    %ebp
  80186d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80186e:	83 ec 0c             	sub    $0xc,%esp
  801871:	6a 01                	push   $0x1
  801873:	e8 2f 13 00 00       	call   802ba7 <ipc_find_env>
  801878:	a3 00 50 80 00       	mov    %eax,0x805000
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	eb c5                	jmp    801847 <fsipc+0x12>

00801882 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	8b 40 0c             	mov    0xc(%eax),%eax
  80188e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801893:	8b 45 0c             	mov    0xc(%ebp),%eax
  801896:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a0:	b8 02 00 00 00       	mov    $0x2,%eax
  8018a5:	e8 8b ff ff ff       	call   801835 <fsipc>
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <devfile_flush>:
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b8:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8018bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c2:	b8 06 00 00 00       	mov    $0x6,%eax
  8018c7:	e8 69 ff ff ff       	call   801835 <fsipc>
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <devfile_stat>:
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	53                   	push   %ebx
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	8b 40 0c             	mov    0xc(%eax),%eax
  8018de:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e8:	b8 05 00 00 00       	mov    $0x5,%eax
  8018ed:	e8 43 ff ff ff       	call   801835 <fsipc>
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 2c                	js     801922 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	68 00 60 80 00       	push   $0x806000
  8018fe:	53                   	push   %ebx
  8018ff:	e8 6a f0 ff ff       	call   80096e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801904:	a1 80 60 80 00       	mov    0x806080,%eax
  801909:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80190f:	a1 84 60 80 00       	mov    0x806084,%eax
  801914:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <devfile_write>:
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	53                   	push   %ebx
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	8b 40 0c             	mov    0xc(%eax),%eax
  801937:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80193c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801942:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801948:	77 30                	ja     80197a <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	53                   	push   %ebx
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	68 08 60 80 00       	push   $0x806008
  801956:	e8 a1 f1 ff ff       	call   800afc <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80195b:	ba 00 00 00 00       	mov    $0x0,%edx
  801960:	b8 04 00 00 00       	mov    $0x4,%eax
  801965:	e8 cb fe ff ff       	call   801835 <fsipc>
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	85 c0                	test   %eax,%eax
  80196f:	78 04                	js     801975 <devfile_write+0x4e>
	assert(r <= n);
  801971:	39 d8                	cmp    %ebx,%eax
  801973:	77 1e                	ja     801993 <devfile_write+0x6c>
}
  801975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801978:	c9                   	leave  
  801979:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80197a:	68 64 33 80 00       	push   $0x803364
  80197f:	68 91 33 80 00       	push   $0x803391
  801984:	68 94 00 00 00       	push   $0x94
  801989:	68 a6 33 80 00       	push   $0x8033a6
  80198e:	e8 63 e8 ff ff       	call   8001f6 <_panic>
	assert(r <= n);
  801993:	68 b1 33 80 00       	push   $0x8033b1
  801998:	68 91 33 80 00       	push   $0x803391
  80199d:	68 98 00 00 00       	push   $0x98
  8019a2:	68 a6 33 80 00       	push   $0x8033a6
  8019a7:	e8 4a e8 ff ff       	call   8001f6 <_panic>

008019ac <devfile_read>:
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	56                   	push   %esi
  8019b0:	53                   	push   %ebx
  8019b1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ba:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8019bf:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	b8 03 00 00 00       	mov    $0x3,%eax
  8019cf:	e8 61 fe ff ff       	call   801835 <fsipc>
  8019d4:	89 c3                	mov    %eax,%ebx
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 1f                	js     8019f9 <devfile_read+0x4d>
	assert(r <= n);
  8019da:	39 f0                	cmp    %esi,%eax
  8019dc:	77 24                	ja     801a02 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019de:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019e3:	7f 33                	jg     801a18 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	50                   	push   %eax
  8019e9:	68 00 60 80 00       	push   $0x806000
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	e8 06 f1 ff ff       	call   800afc <memmove>
	return r;
  8019f6:	83 c4 10             	add    $0x10,%esp
}
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    
	assert(r <= n);
  801a02:	68 b1 33 80 00       	push   $0x8033b1
  801a07:	68 91 33 80 00       	push   $0x803391
  801a0c:	6a 7c                	push   $0x7c
  801a0e:	68 a6 33 80 00       	push   $0x8033a6
  801a13:	e8 de e7 ff ff       	call   8001f6 <_panic>
	assert(r <= PGSIZE);
  801a18:	68 b8 33 80 00       	push   $0x8033b8
  801a1d:	68 91 33 80 00       	push   $0x803391
  801a22:	6a 7d                	push   $0x7d
  801a24:	68 a6 33 80 00       	push   $0x8033a6
  801a29:	e8 c8 e7 ff ff       	call   8001f6 <_panic>

00801a2e <open>:
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	56                   	push   %esi
  801a32:	53                   	push   %ebx
  801a33:	83 ec 1c             	sub    $0x1c,%esp
  801a36:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a39:	56                   	push   %esi
  801a3a:	e8 f8 ee ff ff       	call   800937 <strlen>
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a47:	7f 6c                	jg     801ab5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a49:	83 ec 0c             	sub    $0xc,%esp
  801a4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4f:	50                   	push   %eax
  801a50:	e8 75 f8 ff ff       	call   8012ca <fd_alloc>
  801a55:	89 c3                	mov    %eax,%ebx
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 3c                	js     801a9a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	56                   	push   %esi
  801a62:	68 00 60 80 00       	push   $0x806000
  801a67:	e8 02 ef ff ff       	call   80096e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a77:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7c:	e8 b4 fd ff ff       	call   801835 <fsipc>
  801a81:	89 c3                	mov    %eax,%ebx
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 19                	js     801aa3 <open+0x75>
	return fd2num(fd);
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a90:	e8 0e f8 ff ff       	call   8012a3 <fd2num>
  801a95:	89 c3                	mov    %eax,%ebx
  801a97:	83 c4 10             	add    $0x10,%esp
}
  801a9a:	89 d8                	mov    %ebx,%eax
  801a9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    
		fd_close(fd, 0);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	6a 00                	push   $0x0
  801aa8:	ff 75 f4             	pushl  -0xc(%ebp)
  801aab:	e8 15 f9 ff ff       	call   8013c5 <fd_close>
		return r;
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	eb e5                	jmp    801a9a <open+0x6c>
		return -E_BAD_PATH;
  801ab5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aba:	eb de                	jmp    801a9a <open+0x6c>

00801abc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac7:	b8 08 00 00 00       	mov    $0x8,%eax
  801acc:	e8 64 fd ff ff       	call   801835 <fsipc>
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	57                   	push   %edi
  801ad7:	56                   	push   %esi
  801ad8:	53                   	push   %ebx
  801ad9:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 45 ff ff ff       	call   801a2e <open>
  801ae9:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	0f 88 40 03 00 00    	js     801e3a <spawn+0x367>
  801afa:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	68 00 02 00 00       	push   $0x200
  801b04:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801b0a:	50                   	push   %eax
  801b0b:	52                   	push   %edx
  801b0c:	e8 00 fb ff ff       	call   801611 <readn>
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	3d 00 02 00 00       	cmp    $0x200,%eax
  801b19:	75 5d                	jne    801b78 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  801b1b:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801b22:	45 4c 46 
  801b25:	75 51                	jne    801b78 <spawn+0xa5>
  801b27:	b8 07 00 00 00       	mov    $0x7,%eax
  801b2c:	cd 30                	int    $0x30
  801b2e:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801b34:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	0f 88 b6 04 00 00    	js     801ff8 <spawn+0x525>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801b42:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b47:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801b4a:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801b50:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801b56:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b5d:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b63:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b69:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801b6e:	be 00 00 00 00       	mov    $0x0,%esi
  801b73:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b76:	eb 4b                	jmp    801bc3 <spawn+0xf0>
		close(fd);
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b81:	e8 c8 f8 ff ff       	call   80144e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b86:	83 c4 0c             	add    $0xc,%esp
  801b89:	68 7f 45 4c 46       	push   $0x464c457f
  801b8e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b94:	68 c4 33 80 00       	push   $0x8033c4
  801b99:	e8 33 e7 ff ff       	call   8002d1 <cprintf>
		return -E_NOT_EXEC;
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801ba8:	ff ff ff 
  801bab:	e9 8a 02 00 00       	jmp    801e3a <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801bb0:	83 ec 0c             	sub    $0xc,%esp
  801bb3:	50                   	push   %eax
  801bb4:	e8 7e ed ff ff       	call   800937 <strlen>
  801bb9:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801bbd:	83 c3 01             	add    $0x1,%ebx
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801bca:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	75 df                	jne    801bb0 <spawn+0xdd>
  801bd1:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801bd7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801bdd:	bf 00 10 40 00       	mov    $0x401000,%edi
  801be2:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801be4:	89 fa                	mov    %edi,%edx
  801be6:	83 e2 fc             	and    $0xfffffffc,%edx
  801be9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801bf0:	29 c2                	sub    %eax,%edx
  801bf2:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801bf8:	8d 42 f8             	lea    -0x8(%edx),%eax
  801bfb:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801c00:	0f 86 03 04 00 00    	jbe    802009 <spawn+0x536>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	6a 07                	push   $0x7
  801c0b:	68 00 00 40 00       	push   $0x400000
  801c10:	6a 00                	push   $0x0
  801c12:	e8 50 f1 ff ff       	call   800d67 <sys_page_alloc>
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	0f 88 ec 03 00 00    	js     80200e <spawn+0x53b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801c22:	be 00 00 00 00       	mov    $0x0,%esi
  801c27:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801c2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c30:	eb 30                	jmp    801c62 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801c32:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c38:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801c3e:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801c41:	83 ec 08             	sub    $0x8,%esp
  801c44:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c47:	57                   	push   %edi
  801c48:	e8 21 ed ff ff       	call   80096e <strcpy>
		string_store += strlen(argv[i]) + 1;
  801c4d:	83 c4 04             	add    $0x4,%esp
  801c50:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c53:	e8 df ec ff ff       	call   800937 <strlen>
  801c58:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801c5c:	83 c6 01             	add    $0x1,%esi
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801c68:	7f c8                	jg     801c32 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801c6a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c70:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801c76:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c7d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c83:	0f 85 8c 00 00 00    	jne    801d15 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c89:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801c8f:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c95:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801c98:	89 f8                	mov    %edi,%eax
  801c9a:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801ca0:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ca3:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801ca8:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	6a 07                	push   $0x7
  801cb3:	68 00 d0 bf ee       	push   $0xeebfd000
  801cb8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801cbe:	68 00 00 40 00       	push   $0x400000
  801cc3:	6a 00                	push   $0x0
  801cc5:	e8 e0 f0 ff ff       	call   800daa <sys_page_map>
  801cca:	89 c3                	mov    %eax,%ebx
  801ccc:	83 c4 20             	add    $0x20,%esp
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	0f 88 57 03 00 00    	js     80202e <spawn+0x55b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801cd7:	83 ec 08             	sub    $0x8,%esp
  801cda:	68 00 00 40 00       	push   $0x400000
  801cdf:	6a 00                	push   $0x0
  801ce1:	e8 06 f1 ff ff       	call   800dec <sys_page_unmap>
  801ce6:	89 c3                	mov    %eax,%ebx
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	0f 88 3b 03 00 00    	js     80202e <spawn+0x55b>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801cf3:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801cf9:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801d00:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d06:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801d0d:	00 00 00 
  801d10:	e9 56 01 00 00       	jmp    801e6b <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d15:	68 50 34 80 00       	push   $0x803450
  801d1a:	68 91 33 80 00       	push   $0x803391
  801d1f:	68 f2 00 00 00       	push   $0xf2
  801d24:	68 de 33 80 00       	push   $0x8033de
  801d29:	e8 c8 e4 ff ff       	call   8001f6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d2e:	83 ec 04             	sub    $0x4,%esp
  801d31:	6a 07                	push   $0x7
  801d33:	68 00 00 40 00       	push   $0x400000
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 28 f0 ff ff       	call   800d67 <sys_page_alloc>
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	0f 88 cf 02 00 00    	js     802019 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d4a:	83 ec 08             	sub    $0x8,%esp
  801d4d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d53:	01 f0                	add    %esi,%eax
  801d55:	50                   	push   %eax
  801d56:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801d5c:	e8 79 f9 ff ff       	call   8016da <seek>
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	85 c0                	test   %eax,%eax
  801d66:	0f 88 b4 02 00 00    	js     802020 <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d75:	29 f0                	sub    %esi,%eax
  801d77:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d7c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d81:	0f 47 c1             	cmova  %ecx,%eax
  801d84:	50                   	push   %eax
  801d85:	68 00 00 40 00       	push   $0x400000
  801d8a:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801d90:	e8 7c f8 ff ff       	call   801611 <readn>
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	0f 88 87 02 00 00    	js     802027 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801da0:	83 ec 0c             	sub    $0xc,%esp
  801da3:	57                   	push   %edi
  801da4:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801daa:	56                   	push   %esi
  801dab:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801db1:	68 00 00 40 00       	push   $0x400000
  801db6:	6a 00                	push   $0x0
  801db8:	e8 ed ef ff ff       	call   800daa <sys_page_map>
  801dbd:	83 c4 20             	add    $0x20,%esp
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	0f 88 80 00 00 00    	js     801e48 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801dc8:	83 ec 08             	sub    $0x8,%esp
  801dcb:	68 00 00 40 00       	push   $0x400000
  801dd0:	6a 00                	push   $0x0
  801dd2:	e8 15 f0 ff ff       	call   800dec <sys_page_unmap>
  801dd7:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801dda:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801de0:	89 de                	mov    %ebx,%esi
  801de2:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801de8:	76 73                	jbe    801e5d <spawn+0x38a>
		if (i >= filesz) {
  801dea:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801df0:	0f 87 38 ff ff ff    	ja     801d2e <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	57                   	push   %edi
  801dfa:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801e00:	56                   	push   %esi
  801e01:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801e07:	e8 5b ef ff ff       	call   800d67 <sys_page_alloc>
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	79 c7                	jns    801dda <spawn+0x307>
  801e13:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e1e:	e8 c5 ee ff ff       	call   800ce8 <sys_env_destroy>
	close(fd);
  801e23:	83 c4 04             	add    $0x4,%esp
  801e26:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801e2c:	e8 1d f6 ff ff       	call   80144e <close>
	return r;
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801e3a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5f                   	pop    %edi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801e48:	50                   	push   %eax
  801e49:	68 ea 33 80 00       	push   $0x8033ea
  801e4e:	68 25 01 00 00       	push   $0x125
  801e53:	68 de 33 80 00       	push   $0x8033de
  801e58:	e8 99 e3 ff ff       	call   8001f6 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e5d:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801e64:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801e6b:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801e72:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801e78:	7e 71                	jle    801eeb <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801e7a:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801e80:	83 39 01             	cmpl   $0x1,(%ecx)
  801e83:	75 d8                	jne    801e5d <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e85:	8b 41 18             	mov    0x18(%ecx),%eax
  801e88:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801e8b:	83 f8 01             	cmp    $0x1,%eax
  801e8e:	19 ff                	sbb    %edi,%edi
  801e90:	83 e7 fe             	and    $0xfffffffe,%edi
  801e93:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e96:	8b 71 04             	mov    0x4(%ecx),%esi
  801e99:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801e9f:	8b 59 10             	mov    0x10(%ecx),%ebx
  801ea2:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801ea8:	8b 41 14             	mov    0x14(%ecx),%eax
  801eab:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801eb1:	8b 51 08             	mov    0x8(%ecx),%edx
  801eb4:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  801eba:	89 d0                	mov    %edx,%eax
  801ebc:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ec1:	74 1e                	je     801ee1 <spawn+0x40e>
		va -= i;
  801ec3:	29 c2                	sub    %eax,%edx
  801ec5:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  801ecb:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801ed1:	01 c3                	add    %eax,%ebx
  801ed3:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801ed9:	29 c6                	sub    %eax,%esi
  801edb:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ee6:	e9 f5 fe ff ff       	jmp    801de0 <spawn+0x30d>
	close(fd);
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801ef4:	e8 55 f5 ff ff       	call   80144e <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	envid_t parent_envid = sys_getenvid();
  801ef9:	e8 2b ee ff ff       	call   800d29 <sys_getenvid>
  801efe:	89 c6                	mov    %eax,%esi
  801f00:	83 c4 10             	add    $0x10,%esp
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801f03:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f08:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801f0e:	eb 0e                	jmp    801f1e <spawn+0x44b>
  801f10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f16:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801f1c:	74 62                	je     801f80 <spawn+0x4ad>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_SHARE) == PTE_SHARE) {
  801f1e:	89 d8                	mov    %ebx,%eax
  801f20:	c1 e8 16             	shr    $0x16,%eax
  801f23:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f2a:	a8 01                	test   $0x1,%al
  801f2c:	74 e2                	je     801f10 <spawn+0x43d>
  801f2e:	89 d8                	mov    %ebx,%eax
  801f30:	c1 e8 0c             	shr    $0xc,%eax
  801f33:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f3a:	f6 c2 01             	test   $0x1,%dl
  801f3d:	74 d1                	je     801f10 <spawn+0x43d>
  801f3f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f46:	f6 c6 04             	test   $0x4,%dh
  801f49:	74 c5                	je     801f10 <spawn+0x43d>
	        if ((r = sys_page_map(parent_envid, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
  801f4b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	25 07 0e 00 00       	and    $0xe07,%eax
  801f5a:	50                   	push   %eax
  801f5b:	53                   	push   %ebx
  801f5c:	57                   	push   %edi
  801f5d:	53                   	push   %ebx
  801f5e:	56                   	push   %esi
  801f5f:	e8 46 ee ff ff       	call   800daa <sys_page_map>
  801f64:	83 c4 20             	add    $0x20,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	74 a5                	je     801f10 <spawn+0x43d>
	            panic("copy_shared_pages: %e", r);
  801f6b:	50                   	push   %eax
  801f6c:	68 07 34 80 00       	push   $0x803407
  801f71:	68 38 01 00 00       	push   $0x138
  801f76:	68 de 33 80 00       	push   $0x8033de
  801f7b:	e8 76 e2 ff ff       	call   8001f6 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801f80:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801f87:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f8a:	83 ec 08             	sub    $0x8,%esp
  801f8d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f93:	50                   	push   %eax
  801f94:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f9a:	e8 d1 ee ff ff       	call   800e70 <sys_env_set_trapframe>
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	78 28                	js     801fce <spawn+0x4fb>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	6a 02                	push   $0x2
  801fab:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801fb1:	e8 78 ee ff ff       	call   800e2e <sys_env_set_status>
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	78 26                	js     801fe3 <spawn+0x510>
	return child;
  801fbd:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801fc3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801fc9:	e9 6c fe ff ff       	jmp    801e3a <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  801fce:	50                   	push   %eax
  801fcf:	68 1d 34 80 00       	push   $0x80341d
  801fd4:	68 86 00 00 00       	push   $0x86
  801fd9:	68 de 33 80 00       	push   $0x8033de
  801fde:	e8 13 e2 ff ff       	call   8001f6 <_panic>
		panic("sys_env_set_status: %e", r);
  801fe3:	50                   	push   %eax
  801fe4:	68 37 34 80 00       	push   $0x803437
  801fe9:	68 89 00 00 00       	push   $0x89
  801fee:	68 de 33 80 00       	push   $0x8033de
  801ff3:	e8 fe e1 ff ff       	call   8001f6 <_panic>
		return r;
  801ff8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ffe:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802004:	e9 31 fe ff ff       	jmp    801e3a <spawn+0x367>
		return -E_NO_MEM;
  802009:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  80200e:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802014:	e9 21 fe ff ff       	jmp    801e3a <spawn+0x367>
  802019:	89 c7                	mov    %eax,%edi
  80201b:	e9 f5 fd ff ff       	jmp    801e15 <spawn+0x342>
  802020:	89 c7                	mov    %eax,%edi
  802022:	e9 ee fd ff ff       	jmp    801e15 <spawn+0x342>
  802027:	89 c7                	mov    %eax,%edi
  802029:	e9 e7 fd ff ff       	jmp    801e15 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  80202e:	83 ec 08             	sub    $0x8,%esp
  802031:	68 00 00 40 00       	push   $0x400000
  802036:	6a 00                	push   $0x0
  802038:	e8 af ed ff ff       	call   800dec <sys_page_unmap>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802046:	e9 ef fd ff ff       	jmp    801e3a <spawn+0x367>

0080204b <spawnl>:
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	57                   	push   %edi
  80204f:	56                   	push   %esi
  802050:	53                   	push   %ebx
  802051:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802054:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80205c:	eb 05                	jmp    802063 <spawnl+0x18>
		argc++;
  80205e:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802061:	89 ca                	mov    %ecx,%edx
  802063:	8d 4a 04             	lea    0x4(%edx),%ecx
  802066:	83 3a 00             	cmpl   $0x0,(%edx)
  802069:	75 f3                	jne    80205e <spawnl+0x13>
	const char *argv[argc+2];
  80206b:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802072:	83 e2 f0             	and    $0xfffffff0,%edx
  802075:	29 d4                	sub    %edx,%esp
  802077:	8d 54 24 03          	lea    0x3(%esp),%edx
  80207b:	c1 ea 02             	shr    $0x2,%edx
  80207e:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802085:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80208a:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802091:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802098:	00 
	va_start(vl, arg0);
  802099:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80209c:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a3:	eb 0b                	jmp    8020b0 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  8020a5:	83 c0 01             	add    $0x1,%eax
  8020a8:	8b 39                	mov    (%ecx),%edi
  8020aa:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8020ad:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8020b0:	39 d0                	cmp    %edx,%eax
  8020b2:	75 f1                	jne    8020a5 <spawnl+0x5a>
	return spawn(prog, argv);
  8020b4:	83 ec 08             	sub    $0x8,%esp
  8020b7:	56                   	push   %esi
  8020b8:	ff 75 08             	pushl  0x8(%ebp)
  8020bb:	e8 13 fa ff ff       	call   801ad3 <spawn>
}
  8020c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c3:	5b                   	pop    %ebx
  8020c4:	5e                   	pop    %esi
  8020c5:	5f                   	pop    %edi
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    

008020c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	56                   	push   %esi
  8020cc:	53                   	push   %ebx
  8020cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	ff 75 08             	pushl  0x8(%ebp)
  8020d6:	e8 d8 f1 ff ff       	call   8012b3 <fd2data>
  8020db:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020dd:	83 c4 08             	add    $0x8,%esp
  8020e0:	68 78 34 80 00       	push   $0x803478
  8020e5:	53                   	push   %ebx
  8020e6:	e8 83 e8 ff ff       	call   80096e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020eb:	8b 46 04             	mov    0x4(%esi),%eax
  8020ee:	2b 06                	sub    (%esi),%eax
  8020f0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020fd:	00 00 00 
	stat->st_dev = &devpipe;
  802100:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  802107:	40 80 00 
	return 0;
}
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802112:	5b                   	pop    %ebx
  802113:	5e                   	pop    %esi
  802114:	5d                   	pop    %ebp
  802115:	c3                   	ret    

00802116 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	53                   	push   %ebx
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802120:	53                   	push   %ebx
  802121:	6a 00                	push   $0x0
  802123:	e8 c4 ec ff ff       	call   800dec <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802128:	89 1c 24             	mov    %ebx,(%esp)
  80212b:	e8 83 f1 ff ff       	call   8012b3 <fd2data>
  802130:	83 c4 08             	add    $0x8,%esp
  802133:	50                   	push   %eax
  802134:	6a 00                	push   $0x0
  802136:	e8 b1 ec ff ff       	call   800dec <sys_page_unmap>
}
  80213b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <_pipeisclosed>:
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	57                   	push   %edi
  802144:	56                   	push   %esi
  802145:	53                   	push   %ebx
  802146:	83 ec 1c             	sub    $0x1c,%esp
  802149:	89 c7                	mov    %eax,%edi
  80214b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80214d:	a1 08 50 80 00       	mov    0x805008,%eax
  802152:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	57                   	push   %edi
  802159:	e8 82 0a 00 00       	call   802be0 <pageref>
  80215e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802161:	89 34 24             	mov    %esi,(%esp)
  802164:	e8 77 0a 00 00       	call   802be0 <pageref>
		nn = thisenv->env_runs;
  802169:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80216f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	39 cb                	cmp    %ecx,%ebx
  802177:	74 1b                	je     802194 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802179:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80217c:	75 cf                	jne    80214d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80217e:	8b 42 58             	mov    0x58(%edx),%eax
  802181:	6a 01                	push   $0x1
  802183:	50                   	push   %eax
  802184:	53                   	push   %ebx
  802185:	68 7f 34 80 00       	push   $0x80347f
  80218a:	e8 42 e1 ff ff       	call   8002d1 <cprintf>
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	eb b9                	jmp    80214d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802194:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802197:	0f 94 c0             	sete   %al
  80219a:	0f b6 c0             	movzbl %al,%eax
}
  80219d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a0:	5b                   	pop    %ebx
  8021a1:	5e                   	pop    %esi
  8021a2:	5f                   	pop    %edi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    

008021a5 <devpipe_write>:
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	57                   	push   %edi
  8021a9:	56                   	push   %esi
  8021aa:	53                   	push   %ebx
  8021ab:	83 ec 28             	sub    $0x28,%esp
  8021ae:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021b1:	56                   	push   %esi
  8021b2:	e8 fc f0 ff ff       	call   8012b3 <fd2data>
  8021b7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021c4:	74 4f                	je     802215 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021c6:	8b 43 04             	mov    0x4(%ebx),%eax
  8021c9:	8b 0b                	mov    (%ebx),%ecx
  8021cb:	8d 51 20             	lea    0x20(%ecx),%edx
  8021ce:	39 d0                	cmp    %edx,%eax
  8021d0:	72 14                	jb     8021e6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021d2:	89 da                	mov    %ebx,%edx
  8021d4:	89 f0                	mov    %esi,%eax
  8021d6:	e8 65 ff ff ff       	call   802140 <_pipeisclosed>
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	75 3a                	jne    802219 <devpipe_write+0x74>
			sys_yield();
  8021df:	e8 64 eb ff ff       	call   800d48 <sys_yield>
  8021e4:	eb e0                	jmp    8021c6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021e9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021ed:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021f0:	89 c2                	mov    %eax,%edx
  8021f2:	c1 fa 1f             	sar    $0x1f,%edx
  8021f5:	89 d1                	mov    %edx,%ecx
  8021f7:	c1 e9 1b             	shr    $0x1b,%ecx
  8021fa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021fd:	83 e2 1f             	and    $0x1f,%edx
  802200:	29 ca                	sub    %ecx,%edx
  802202:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802206:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80220a:	83 c0 01             	add    $0x1,%eax
  80220d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802210:	83 c7 01             	add    $0x1,%edi
  802213:	eb ac                	jmp    8021c1 <devpipe_write+0x1c>
	return i;
  802215:	89 f8                	mov    %edi,%eax
  802217:	eb 05                	jmp    80221e <devpipe_write+0x79>
				return 0;
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    

00802226 <devpipe_read>:
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	57                   	push   %edi
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	83 ec 18             	sub    $0x18,%esp
  80222f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802232:	57                   	push   %edi
  802233:	e8 7b f0 ff ff       	call   8012b3 <fd2data>
  802238:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	be 00 00 00 00       	mov    $0x0,%esi
  802242:	3b 75 10             	cmp    0x10(%ebp),%esi
  802245:	74 47                	je     80228e <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802247:	8b 03                	mov    (%ebx),%eax
  802249:	3b 43 04             	cmp    0x4(%ebx),%eax
  80224c:	75 22                	jne    802270 <devpipe_read+0x4a>
			if (i > 0)
  80224e:	85 f6                	test   %esi,%esi
  802250:	75 14                	jne    802266 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802252:	89 da                	mov    %ebx,%edx
  802254:	89 f8                	mov    %edi,%eax
  802256:	e8 e5 fe ff ff       	call   802140 <_pipeisclosed>
  80225b:	85 c0                	test   %eax,%eax
  80225d:	75 33                	jne    802292 <devpipe_read+0x6c>
			sys_yield();
  80225f:	e8 e4 ea ff ff       	call   800d48 <sys_yield>
  802264:	eb e1                	jmp    802247 <devpipe_read+0x21>
				return i;
  802266:	89 f0                	mov    %esi,%eax
}
  802268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80226b:	5b                   	pop    %ebx
  80226c:	5e                   	pop    %esi
  80226d:	5f                   	pop    %edi
  80226e:	5d                   	pop    %ebp
  80226f:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802270:	99                   	cltd   
  802271:	c1 ea 1b             	shr    $0x1b,%edx
  802274:	01 d0                	add    %edx,%eax
  802276:	83 e0 1f             	and    $0x1f,%eax
  802279:	29 d0                	sub    %edx,%eax
  80227b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802283:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802286:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802289:	83 c6 01             	add    $0x1,%esi
  80228c:	eb b4                	jmp    802242 <devpipe_read+0x1c>
	return i;
  80228e:	89 f0                	mov    %esi,%eax
  802290:	eb d6                	jmp    802268 <devpipe_read+0x42>
				return 0;
  802292:	b8 00 00 00 00       	mov    $0x0,%eax
  802297:	eb cf                	jmp    802268 <devpipe_read+0x42>

00802299 <pipe>:
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	56                   	push   %esi
  80229d:	53                   	push   %ebx
  80229e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a4:	50                   	push   %eax
  8022a5:	e8 20 f0 ff ff       	call   8012ca <fd_alloc>
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	83 c4 10             	add    $0x10,%esp
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	78 5b                	js     80230e <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b3:	83 ec 04             	sub    $0x4,%esp
  8022b6:	68 07 04 00 00       	push   $0x407
  8022bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022be:	6a 00                	push   $0x0
  8022c0:	e8 a2 ea ff ff       	call   800d67 <sys_page_alloc>
  8022c5:	89 c3                	mov    %eax,%ebx
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	78 40                	js     80230e <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8022ce:	83 ec 0c             	sub    $0xc,%esp
  8022d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022d4:	50                   	push   %eax
  8022d5:	e8 f0 ef ff ff       	call   8012ca <fd_alloc>
  8022da:	89 c3                	mov    %eax,%ebx
  8022dc:	83 c4 10             	add    $0x10,%esp
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	78 1b                	js     8022fe <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022e3:	83 ec 04             	sub    $0x4,%esp
  8022e6:	68 07 04 00 00       	push   $0x407
  8022eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8022ee:	6a 00                	push   $0x0
  8022f0:	e8 72 ea ff ff       	call   800d67 <sys_page_alloc>
  8022f5:	89 c3                	mov    %eax,%ebx
  8022f7:	83 c4 10             	add    $0x10,%esp
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	79 19                	jns    802317 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8022fe:	83 ec 08             	sub    $0x8,%esp
  802301:	ff 75 f4             	pushl  -0xc(%ebp)
  802304:	6a 00                	push   $0x0
  802306:	e8 e1 ea ff ff       	call   800dec <sys_page_unmap>
  80230b:	83 c4 10             	add    $0x10,%esp
}
  80230e:	89 d8                	mov    %ebx,%eax
  802310:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5d                   	pop    %ebp
  802316:	c3                   	ret    
	va = fd2data(fd0);
  802317:	83 ec 0c             	sub    $0xc,%esp
  80231a:	ff 75 f4             	pushl  -0xc(%ebp)
  80231d:	e8 91 ef ff ff       	call   8012b3 <fd2data>
  802322:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802324:	83 c4 0c             	add    $0xc,%esp
  802327:	68 07 04 00 00       	push   $0x407
  80232c:	50                   	push   %eax
  80232d:	6a 00                	push   $0x0
  80232f:	e8 33 ea ff ff       	call   800d67 <sys_page_alloc>
  802334:	89 c3                	mov    %eax,%ebx
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	85 c0                	test   %eax,%eax
  80233b:	0f 88 8c 00 00 00    	js     8023cd <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802341:	83 ec 0c             	sub    $0xc,%esp
  802344:	ff 75 f0             	pushl  -0x10(%ebp)
  802347:	e8 67 ef ff ff       	call   8012b3 <fd2data>
  80234c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802353:	50                   	push   %eax
  802354:	6a 00                	push   $0x0
  802356:	56                   	push   %esi
  802357:	6a 00                	push   $0x0
  802359:	e8 4c ea ff ff       	call   800daa <sys_page_map>
  80235e:	89 c3                	mov    %eax,%ebx
  802360:	83 c4 20             	add    $0x20,%esp
  802363:	85 c0                	test   %eax,%eax
  802365:	78 58                	js     8023bf <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802370:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237f:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802385:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802391:	83 ec 0c             	sub    $0xc,%esp
  802394:	ff 75 f4             	pushl  -0xc(%ebp)
  802397:	e8 07 ef ff ff       	call   8012a3 <fd2num>
  80239c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80239f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023a1:	83 c4 04             	add    $0x4,%esp
  8023a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a7:	e8 f7 ee ff ff       	call   8012a3 <fd2num>
  8023ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023af:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023b2:	83 c4 10             	add    $0x10,%esp
  8023b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023ba:	e9 4f ff ff ff       	jmp    80230e <pipe+0x75>
	sys_page_unmap(0, va);
  8023bf:	83 ec 08             	sub    $0x8,%esp
  8023c2:	56                   	push   %esi
  8023c3:	6a 00                	push   $0x0
  8023c5:	e8 22 ea ff ff       	call   800dec <sys_page_unmap>
  8023ca:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023cd:	83 ec 08             	sub    $0x8,%esp
  8023d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8023d3:	6a 00                	push   $0x0
  8023d5:	e8 12 ea ff ff       	call   800dec <sys_page_unmap>
  8023da:	83 c4 10             	add    $0x10,%esp
  8023dd:	e9 1c ff ff ff       	jmp    8022fe <pipe+0x65>

008023e2 <pipeisclosed>:
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023eb:	50                   	push   %eax
  8023ec:	ff 75 08             	pushl  0x8(%ebp)
  8023ef:	e8 25 ef ff ff       	call   801319 <fd_lookup>
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	78 18                	js     802413 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8023fb:	83 ec 0c             	sub    $0xc,%esp
  8023fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802401:	e8 ad ee ff ff       	call   8012b3 <fd2data>
	return _pipeisclosed(fd, p);
  802406:	89 c2                	mov    %eax,%edx
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	e8 30 fd ff ff       	call   802140 <_pipeisclosed>
  802410:	83 c4 10             	add    $0x10,%esp
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	56                   	push   %esi
  802419:	53                   	push   %ebx
  80241a:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80241d:	85 f6                	test   %esi,%esi
  80241f:	74 13                	je     802434 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802421:	89 f3                	mov    %esi,%ebx
  802423:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802429:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80242c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802432:	eb 1b                	jmp    80244f <wait+0x3a>
	assert(envid != 0);
  802434:	68 97 34 80 00       	push   $0x803497
  802439:	68 91 33 80 00       	push   $0x803391
  80243e:	6a 09                	push   $0x9
  802440:	68 a2 34 80 00       	push   $0x8034a2
  802445:	e8 ac dd ff ff       	call   8001f6 <_panic>
		sys_yield();
  80244a:	e8 f9 e8 ff ff       	call   800d48 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80244f:	8b 43 48             	mov    0x48(%ebx),%eax
  802452:	39 f0                	cmp    %esi,%eax
  802454:	75 07                	jne    80245d <wait+0x48>
  802456:	8b 43 54             	mov    0x54(%ebx),%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 ed                	jne    80244a <wait+0x35>
}
  80245d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    

00802464 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80246a:	68 ad 34 80 00       	push   $0x8034ad
  80246f:	ff 75 0c             	pushl  0xc(%ebp)
  802472:	e8 f7 e4 ff ff       	call   80096e <strcpy>
	return 0;
}
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <devsock_close>:
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	53                   	push   %ebx
  802482:	83 ec 10             	sub    $0x10,%esp
  802485:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802488:	53                   	push   %ebx
  802489:	e8 52 07 00 00       	call   802be0 <pageref>
  80248e:	83 c4 10             	add    $0x10,%esp
		return 0;
  802491:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802496:	83 f8 01             	cmp    $0x1,%eax
  802499:	74 07                	je     8024a2 <devsock_close+0x24>
}
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8024a2:	83 ec 0c             	sub    $0xc,%esp
  8024a5:	ff 73 0c             	pushl  0xc(%ebx)
  8024a8:	e8 b7 02 00 00       	call   802764 <nsipc_close>
  8024ad:	89 c2                	mov    %eax,%edx
  8024af:	83 c4 10             	add    $0x10,%esp
  8024b2:	eb e7                	jmp    80249b <devsock_close+0x1d>

008024b4 <devsock_write>:
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8024ba:	6a 00                	push   $0x0
  8024bc:	ff 75 10             	pushl  0x10(%ebp)
  8024bf:	ff 75 0c             	pushl  0xc(%ebp)
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	ff 70 0c             	pushl  0xc(%eax)
  8024c8:	e8 74 03 00 00       	call   802841 <nsipc_send>
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <devsock_read>:
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
  8024d2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8024d5:	6a 00                	push   $0x0
  8024d7:	ff 75 10             	pushl  0x10(%ebp)
  8024da:	ff 75 0c             	pushl  0xc(%ebp)
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	ff 70 0c             	pushl  0xc(%eax)
  8024e3:	e8 ed 02 00 00       	call   8027d5 <nsipc_recv>
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <fd2sockid>:
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8024f0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024f3:	52                   	push   %edx
  8024f4:	50                   	push   %eax
  8024f5:	e8 1f ee ff ff       	call   801319 <fd_lookup>
  8024fa:	83 c4 10             	add    $0x10,%esp
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	78 10                	js     802511 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 0d 44 40 80 00    	mov    0x804044,%ecx
  80250a:	39 08                	cmp    %ecx,(%eax)
  80250c:	75 05                	jne    802513 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80250e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    
		return -E_NOT_SUPP;
  802513:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802518:	eb f7                	jmp    802511 <fd2sockid+0x27>

0080251a <alloc_sockfd>:
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	56                   	push   %esi
  80251e:	53                   	push   %ebx
  80251f:	83 ec 1c             	sub    $0x1c,%esp
  802522:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802527:	50                   	push   %eax
  802528:	e8 9d ed ff ff       	call   8012ca <fd_alloc>
  80252d:	89 c3                	mov    %eax,%ebx
  80252f:	83 c4 10             	add    $0x10,%esp
  802532:	85 c0                	test   %eax,%eax
  802534:	78 43                	js     802579 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	68 07 04 00 00       	push   $0x407
  80253e:	ff 75 f4             	pushl  -0xc(%ebp)
  802541:	6a 00                	push   $0x0
  802543:	e8 1f e8 ff ff       	call   800d67 <sys_page_alloc>
  802548:	89 c3                	mov    %eax,%ebx
  80254a:	83 c4 10             	add    $0x10,%esp
  80254d:	85 c0                	test   %eax,%eax
  80254f:	78 28                	js     802579 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80255a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802566:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	50                   	push   %eax
  80256d:	e8 31 ed ff ff       	call   8012a3 <fd2num>
  802572:	89 c3                	mov    %eax,%ebx
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	eb 0c                	jmp    802585 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802579:	83 ec 0c             	sub    $0xc,%esp
  80257c:	56                   	push   %esi
  80257d:	e8 e2 01 00 00       	call   802764 <nsipc_close>
		return r;
  802582:	83 c4 10             	add    $0x10,%esp
}
  802585:	89 d8                	mov    %ebx,%eax
  802587:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80258a:	5b                   	pop    %ebx
  80258b:	5e                   	pop    %esi
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    

0080258e <accept>:
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
  802591:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	e8 4e ff ff ff       	call   8024ea <fd2sockid>
  80259c:	85 c0                	test   %eax,%eax
  80259e:	78 1b                	js     8025bb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	ff 75 10             	pushl  0x10(%ebp)
  8025a6:	ff 75 0c             	pushl  0xc(%ebp)
  8025a9:	50                   	push   %eax
  8025aa:	e8 0e 01 00 00       	call   8026bd <nsipc_accept>
  8025af:	83 c4 10             	add    $0x10,%esp
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	78 05                	js     8025bb <accept+0x2d>
	return alloc_sockfd(r);
  8025b6:	e8 5f ff ff ff       	call   80251a <alloc_sockfd>
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <bind>:
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	e8 1f ff ff ff       	call   8024ea <fd2sockid>
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	78 12                	js     8025e1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8025cf:	83 ec 04             	sub    $0x4,%esp
  8025d2:	ff 75 10             	pushl  0x10(%ebp)
  8025d5:	ff 75 0c             	pushl  0xc(%ebp)
  8025d8:	50                   	push   %eax
  8025d9:	e8 2f 01 00 00       	call   80270d <nsipc_bind>
  8025de:	83 c4 10             	add    $0x10,%esp
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <shutdown>:
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	e8 f9 fe ff ff       	call   8024ea <fd2sockid>
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	78 0f                	js     802604 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8025f5:	83 ec 08             	sub    $0x8,%esp
  8025f8:	ff 75 0c             	pushl  0xc(%ebp)
  8025fb:	50                   	push   %eax
  8025fc:	e8 41 01 00 00       	call   802742 <nsipc_shutdown>
  802601:	83 c4 10             	add    $0x10,%esp
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <connect>:
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	e8 d6 fe ff ff       	call   8024ea <fd2sockid>
  802614:	85 c0                	test   %eax,%eax
  802616:	78 12                	js     80262a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	ff 75 10             	pushl  0x10(%ebp)
  80261e:	ff 75 0c             	pushl  0xc(%ebp)
  802621:	50                   	push   %eax
  802622:	e8 57 01 00 00       	call   80277e <nsipc_connect>
  802627:	83 c4 10             	add    $0x10,%esp
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <listen>:
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	e8 b0 fe ff ff       	call   8024ea <fd2sockid>
  80263a:	85 c0                	test   %eax,%eax
  80263c:	78 0f                	js     80264d <listen+0x21>
	return nsipc_listen(r, backlog);
  80263e:	83 ec 08             	sub    $0x8,%esp
  802641:	ff 75 0c             	pushl  0xc(%ebp)
  802644:	50                   	push   %eax
  802645:	e8 69 01 00 00       	call   8027b3 <nsipc_listen>
  80264a:	83 c4 10             	add    $0x10,%esp
}
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <socket>:

int
socket(int domain, int type, int protocol)
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802655:	ff 75 10             	pushl  0x10(%ebp)
  802658:	ff 75 0c             	pushl  0xc(%ebp)
  80265b:	ff 75 08             	pushl  0x8(%ebp)
  80265e:	e8 3c 02 00 00       	call   80289f <nsipc_socket>
  802663:	83 c4 10             	add    $0x10,%esp
  802666:	85 c0                	test   %eax,%eax
  802668:	78 05                	js     80266f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80266a:	e8 ab fe ff ff       	call   80251a <alloc_sockfd>
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	53                   	push   %ebx
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80267a:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802681:	74 26                	je     8026a9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802683:	6a 07                	push   $0x7
  802685:	68 00 70 80 00       	push   $0x807000
  80268a:	53                   	push   %ebx
  80268b:	ff 35 04 50 80 00    	pushl  0x805004
  802691:	e8 b8 04 00 00       	call   802b4e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802696:	83 c4 0c             	add    $0xc,%esp
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	e8 41 04 00 00       	call   802ae5 <ipc_recv>
}
  8026a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026a9:	83 ec 0c             	sub    $0xc,%esp
  8026ac:	6a 02                	push   $0x2
  8026ae:	e8 f4 04 00 00       	call   802ba7 <ipc_find_env>
  8026b3:	a3 04 50 80 00       	mov    %eax,0x805004
  8026b8:	83 c4 10             	add    $0x10,%esp
  8026bb:	eb c6                	jmp    802683 <nsipc+0x12>

008026bd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	56                   	push   %esi
  8026c1:	53                   	push   %ebx
  8026c2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8026cd:	8b 06                	mov    (%esi),%eax
  8026cf:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8026d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d9:	e8 93 ff ff ff       	call   802671 <nsipc>
  8026de:	89 c3                	mov    %eax,%ebx
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	78 20                	js     802704 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	ff 35 10 70 80 00    	pushl  0x807010
  8026ed:	68 00 70 80 00       	push   $0x807000
  8026f2:	ff 75 0c             	pushl  0xc(%ebp)
  8026f5:	e8 02 e4 ff ff       	call   800afc <memmove>
		*addrlen = ret->ret_addrlen;
  8026fa:	a1 10 70 80 00       	mov    0x807010,%eax
  8026ff:	89 06                	mov    %eax,(%esi)
  802701:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802704:	89 d8                	mov    %ebx,%eax
  802706:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802709:	5b                   	pop    %ebx
  80270a:	5e                   	pop    %esi
  80270b:	5d                   	pop    %ebp
  80270c:	c3                   	ret    

0080270d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
  802710:	53                   	push   %ebx
  802711:	83 ec 08             	sub    $0x8,%esp
  802714:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80271f:	53                   	push   %ebx
  802720:	ff 75 0c             	pushl  0xc(%ebp)
  802723:	68 04 70 80 00       	push   $0x807004
  802728:	e8 cf e3 ff ff       	call   800afc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80272d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802733:	b8 02 00 00 00       	mov    $0x2,%eax
  802738:	e8 34 ff ff ff       	call   802671 <nsipc>
}
  80273d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802740:	c9                   	leave  
  802741:	c3                   	ret    

00802742 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802748:	8b 45 08             	mov    0x8(%ebp),%eax
  80274b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802750:	8b 45 0c             	mov    0xc(%ebp),%eax
  802753:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802758:	b8 03 00 00 00       	mov    $0x3,%eax
  80275d:	e8 0f ff ff ff       	call   802671 <nsipc>
}
  802762:	c9                   	leave  
  802763:	c3                   	ret    

00802764 <nsipc_close>:

int
nsipc_close(int s)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
  802767:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802772:	b8 04 00 00 00       	mov    $0x4,%eax
  802777:	e8 f5 fe ff ff       	call   802671 <nsipc>
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	53                   	push   %ebx
  802782:	83 ec 08             	sub    $0x8,%esp
  802785:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802790:	53                   	push   %ebx
  802791:	ff 75 0c             	pushl  0xc(%ebp)
  802794:	68 04 70 80 00       	push   $0x807004
  802799:	e8 5e e3 ff ff       	call   800afc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80279e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8027a4:	b8 05 00 00 00       	mov    $0x5,%eax
  8027a9:	e8 c3 fe ff ff       	call   802671 <nsipc>
}
  8027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    

008027b3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8027b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8027c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c4:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8027c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8027ce:	e8 9e fe ff ff       	call   802671 <nsipc>
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	56                   	push   %esi
  8027d9:	53                   	push   %ebx
  8027da:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8027e5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8027eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8027ee:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8027f3:	b8 07 00 00 00       	mov    $0x7,%eax
  8027f8:	e8 74 fe ff ff       	call   802671 <nsipc>
  8027fd:	89 c3                	mov    %eax,%ebx
  8027ff:	85 c0                	test   %eax,%eax
  802801:	78 1f                	js     802822 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802803:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802808:	7f 21                	jg     80282b <nsipc_recv+0x56>
  80280a:	39 c6                	cmp    %eax,%esi
  80280c:	7c 1d                	jl     80282b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80280e:	83 ec 04             	sub    $0x4,%esp
  802811:	50                   	push   %eax
  802812:	68 00 70 80 00       	push   $0x807000
  802817:	ff 75 0c             	pushl  0xc(%ebp)
  80281a:	e8 dd e2 ff ff       	call   800afc <memmove>
  80281f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802822:	89 d8                	mov    %ebx,%eax
  802824:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802827:	5b                   	pop    %ebx
  802828:	5e                   	pop    %esi
  802829:	5d                   	pop    %ebp
  80282a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80282b:	68 b9 34 80 00       	push   $0x8034b9
  802830:	68 91 33 80 00       	push   $0x803391
  802835:	6a 62                	push   $0x62
  802837:	68 ce 34 80 00       	push   $0x8034ce
  80283c:	e8 b5 d9 ff ff       	call   8001f6 <_panic>

00802841 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	53                   	push   %ebx
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802853:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802859:	7f 2e                	jg     802889 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	53                   	push   %ebx
  80285f:	ff 75 0c             	pushl  0xc(%ebp)
  802862:	68 0c 70 80 00       	push   $0x80700c
  802867:	e8 90 e2 ff ff       	call   800afc <memmove>
	nsipcbuf.send.req_size = size;
  80286c:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802872:	8b 45 14             	mov    0x14(%ebp),%eax
  802875:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80287a:	b8 08 00 00 00       	mov    $0x8,%eax
  80287f:	e8 ed fd ff ff       	call   802671 <nsipc>
}
  802884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802887:	c9                   	leave  
  802888:	c3                   	ret    
	assert(size < 1600);
  802889:	68 da 34 80 00       	push   $0x8034da
  80288e:	68 91 33 80 00       	push   $0x803391
  802893:	6a 6d                	push   $0x6d
  802895:	68 ce 34 80 00       	push   $0x8034ce
  80289a:	e8 57 d9 ff ff       	call   8001f6 <_panic>

0080289f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8028ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b0:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8028b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8028bd:	b8 09 00 00 00       	mov    $0x9,%eax
  8028c2:	e8 aa fd ff ff       	call   802671 <nsipc>
}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d1:	5d                   	pop    %ebp
  8028d2:	c3                   	ret    

008028d3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028d3:	55                   	push   %ebp
  8028d4:	89 e5                	mov    %esp,%ebp
  8028d6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8028d9:	68 e6 34 80 00       	push   $0x8034e6
  8028de:	ff 75 0c             	pushl  0xc(%ebp)
  8028e1:	e8 88 e0 ff ff       	call   80096e <strcpy>
	return 0;
}
  8028e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028eb:	c9                   	leave  
  8028ec:	c3                   	ret    

008028ed <devcons_write>:
{
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
  8028f0:	57                   	push   %edi
  8028f1:	56                   	push   %esi
  8028f2:	53                   	push   %ebx
  8028f3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8028f9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8028fe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802904:	eb 2f                	jmp    802935 <devcons_write+0x48>
		m = n - tot;
  802906:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802909:	29 f3                	sub    %esi,%ebx
  80290b:	83 fb 7f             	cmp    $0x7f,%ebx
  80290e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802913:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802916:	83 ec 04             	sub    $0x4,%esp
  802919:	53                   	push   %ebx
  80291a:	89 f0                	mov    %esi,%eax
  80291c:	03 45 0c             	add    0xc(%ebp),%eax
  80291f:	50                   	push   %eax
  802920:	57                   	push   %edi
  802921:	e8 d6 e1 ff ff       	call   800afc <memmove>
		sys_cputs(buf, m);
  802926:	83 c4 08             	add    $0x8,%esp
  802929:	53                   	push   %ebx
  80292a:	57                   	push   %edi
  80292b:	e8 7b e3 ff ff       	call   800cab <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802930:	01 de                	add    %ebx,%esi
  802932:	83 c4 10             	add    $0x10,%esp
  802935:	3b 75 10             	cmp    0x10(%ebp),%esi
  802938:	72 cc                	jb     802906 <devcons_write+0x19>
}
  80293a:	89 f0                	mov    %esi,%eax
  80293c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80293f:	5b                   	pop    %ebx
  802940:	5e                   	pop    %esi
  802941:	5f                   	pop    %edi
  802942:	5d                   	pop    %ebp
  802943:	c3                   	ret    

00802944 <devcons_read>:
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 08             	sub    $0x8,%esp
  80294a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80294f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802953:	75 07                	jne    80295c <devcons_read+0x18>
}
  802955:	c9                   	leave  
  802956:	c3                   	ret    
		sys_yield();
  802957:	e8 ec e3 ff ff       	call   800d48 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80295c:	e8 68 e3 ff ff       	call   800cc9 <sys_cgetc>
  802961:	85 c0                	test   %eax,%eax
  802963:	74 f2                	je     802957 <devcons_read+0x13>
	if (c < 0)
  802965:	85 c0                	test   %eax,%eax
  802967:	78 ec                	js     802955 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802969:	83 f8 04             	cmp    $0x4,%eax
  80296c:	74 0c                	je     80297a <devcons_read+0x36>
	*(char*)vbuf = c;
  80296e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802971:	88 02                	mov    %al,(%edx)
	return 1;
  802973:	b8 01 00 00 00       	mov    $0x1,%eax
  802978:	eb db                	jmp    802955 <devcons_read+0x11>
		return 0;
  80297a:	b8 00 00 00 00       	mov    $0x0,%eax
  80297f:	eb d4                	jmp    802955 <devcons_read+0x11>

00802981 <cputchar>:
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
  802984:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80298d:	6a 01                	push   $0x1
  80298f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802992:	50                   	push   %eax
  802993:	e8 13 e3 ff ff       	call   800cab <sys_cputs>
}
  802998:	83 c4 10             	add    $0x10,%esp
  80299b:	c9                   	leave  
  80299c:	c3                   	ret    

0080299d <getchar>:
{
  80299d:	55                   	push   %ebp
  80299e:	89 e5                	mov    %esp,%ebp
  8029a0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8029a3:	6a 01                	push   $0x1
  8029a5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029a8:	50                   	push   %eax
  8029a9:	6a 00                	push   $0x0
  8029ab:	e8 da eb ff ff       	call   80158a <read>
	if (r < 0)
  8029b0:	83 c4 10             	add    $0x10,%esp
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	78 08                	js     8029bf <getchar+0x22>
	if (r < 1)
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	7e 06                	jle    8029c1 <getchar+0x24>
	return c;
  8029bb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029bf:	c9                   	leave  
  8029c0:	c3                   	ret    
		return -E_EOF;
  8029c1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029c6:	eb f7                	jmp    8029bf <getchar+0x22>

008029c8 <iscons>:
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029d1:	50                   	push   %eax
  8029d2:	ff 75 08             	pushl  0x8(%ebp)
  8029d5:	e8 3f e9 ff ff       	call   801319 <fd_lookup>
  8029da:	83 c4 10             	add    $0x10,%esp
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	78 11                	js     8029f2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8029ea:	39 10                	cmp    %edx,(%eax)
  8029ec:	0f 94 c0             	sete   %al
  8029ef:	0f b6 c0             	movzbl %al,%eax
}
  8029f2:	c9                   	leave  
  8029f3:	c3                   	ret    

008029f4 <opencons>:
{
  8029f4:	55                   	push   %ebp
  8029f5:	89 e5                	mov    %esp,%ebp
  8029f7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8029fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029fd:	50                   	push   %eax
  8029fe:	e8 c7 e8 ff ff       	call   8012ca <fd_alloc>
  802a03:	83 c4 10             	add    $0x10,%esp
  802a06:	85 c0                	test   %eax,%eax
  802a08:	78 3a                	js     802a44 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a0a:	83 ec 04             	sub    $0x4,%esp
  802a0d:	68 07 04 00 00       	push   $0x407
  802a12:	ff 75 f4             	pushl  -0xc(%ebp)
  802a15:	6a 00                	push   $0x0
  802a17:	e8 4b e3 ff ff       	call   800d67 <sys_page_alloc>
  802a1c:	83 c4 10             	add    $0x10,%esp
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	78 21                	js     802a44 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802a2c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a38:	83 ec 0c             	sub    $0xc,%esp
  802a3b:	50                   	push   %eax
  802a3c:	e8 62 e8 ff ff       	call   8012a3 <fd2num>
  802a41:	83 c4 10             	add    $0x10,%esp
}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a4c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a53:	74 0a                	je     802a5f <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a5d:	c9                   	leave  
  802a5e:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802a5f:	a1 08 50 80 00       	mov    0x805008,%eax
  802a64:	8b 40 48             	mov    0x48(%eax),%eax
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	6a 07                	push   $0x7
  802a6c:	68 00 f0 bf ee       	push   $0xeebff000
  802a71:	50                   	push   %eax
  802a72:	e8 f0 e2 ff ff       	call   800d67 <sys_page_alloc>
  802a77:	83 c4 10             	add    $0x10,%esp
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	75 2f                	jne    802aad <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802a7e:	a1 08 50 80 00       	mov    0x805008,%eax
  802a83:	8b 40 48             	mov    0x48(%eax),%eax
  802a86:	83 ec 08             	sub    $0x8,%esp
  802a89:	68 bf 2a 80 00       	push   $0x802abf
  802a8e:	50                   	push   %eax
  802a8f:	e8 1e e4 ff ff       	call   800eb2 <sys_env_set_pgfault_upcall>
  802a94:	83 c4 10             	add    $0x10,%esp
  802a97:	85 c0                	test   %eax,%eax
  802a99:	74 ba                	je     802a55 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  802a9b:	50                   	push   %eax
  802a9c:	68 f2 34 80 00       	push   $0x8034f2
  802aa1:	6a 24                	push   $0x24
  802aa3:	68 0a 35 80 00       	push   $0x80350a
  802aa8:	e8 49 d7 ff ff       	call   8001f6 <_panic>
		    panic("set_pgfault_handler: %e", r);
  802aad:	50                   	push   %eax
  802aae:	68 f2 34 80 00       	push   $0x8034f2
  802ab3:	6a 21                	push   $0x21
  802ab5:	68 0a 35 80 00       	push   $0x80350a
  802aba:	e8 37 d7 ff ff       	call   8001f6 <_panic>

00802abf <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802abf:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ac0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802ac5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802ac7:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  802aca:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  802ace:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  802ad1:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802ad5:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802ad9:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  802adb:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  802ade:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  802adf:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  802ae2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802ae3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ae4:	c3                   	ret    

00802ae5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
  802ae8:	56                   	push   %esi
  802ae9:	53                   	push   %ebx
  802aea:	8b 75 08             	mov    0x8(%ebp),%esi
  802aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802af3:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802af5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802afa:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802afd:	83 ec 0c             	sub    $0xc,%esp
  802b00:	50                   	push   %eax
  802b01:	e8 11 e4 ff ff       	call   800f17 <sys_ipc_recv>
  802b06:	83 c4 10             	add    $0x10,%esp
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	78 2b                	js     802b38 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802b0d:	85 f6                	test   %esi,%esi
  802b0f:	74 0a                	je     802b1b <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802b11:	a1 08 50 80 00       	mov    0x805008,%eax
  802b16:	8b 40 74             	mov    0x74(%eax),%eax
  802b19:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802b1b:	85 db                	test   %ebx,%ebx
  802b1d:	74 0a                	je     802b29 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802b1f:	a1 08 50 80 00       	mov    0x805008,%eax
  802b24:	8b 40 78             	mov    0x78(%eax),%eax
  802b27:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802b29:	a1 08 50 80 00       	mov    0x805008,%eax
  802b2e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802b31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b34:	5b                   	pop    %ebx
  802b35:	5e                   	pop    %esi
  802b36:	5d                   	pop    %ebp
  802b37:	c3                   	ret    
	    if (from_env_store != NULL) {
  802b38:	85 f6                	test   %esi,%esi
  802b3a:	74 06                	je     802b42 <ipc_recv+0x5d>
	        *from_env_store = 0;
  802b3c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802b42:	85 db                	test   %ebx,%ebx
  802b44:	74 eb                	je     802b31 <ipc_recv+0x4c>
	        *perm_store = 0;
  802b46:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802b4c:	eb e3                	jmp    802b31 <ipc_recv+0x4c>

00802b4e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
  802b51:	57                   	push   %edi
  802b52:	56                   	push   %esi
  802b53:	53                   	push   %ebx
  802b54:	83 ec 0c             	sub    $0xc,%esp
  802b57:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b5a:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802b5d:	85 f6                	test   %esi,%esi
  802b5f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802b64:	0f 44 f0             	cmove  %eax,%esi
  802b67:	eb 09                	jmp    802b72 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802b69:	e8 da e1 ff ff       	call   800d48 <sys_yield>
	} while(r != 0);
  802b6e:	85 db                	test   %ebx,%ebx
  802b70:	74 2d                	je     802b9f <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802b72:	ff 75 14             	pushl  0x14(%ebp)
  802b75:	56                   	push   %esi
  802b76:	ff 75 0c             	pushl  0xc(%ebp)
  802b79:	57                   	push   %edi
  802b7a:	e8 75 e3 ff ff       	call   800ef4 <sys_ipc_try_send>
  802b7f:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802b81:	83 c4 10             	add    $0x10,%esp
  802b84:	85 c0                	test   %eax,%eax
  802b86:	79 e1                	jns    802b69 <ipc_send+0x1b>
  802b88:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b8b:	74 dc                	je     802b69 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802b8d:	50                   	push   %eax
  802b8e:	68 18 35 80 00       	push   $0x803518
  802b93:	6a 45                	push   $0x45
  802b95:	68 25 35 80 00       	push   $0x803525
  802b9a:	e8 57 d6 ff ff       	call   8001f6 <_panic>
}
  802b9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ba2:	5b                   	pop    %ebx
  802ba3:	5e                   	pop    %esi
  802ba4:	5f                   	pop    %edi
  802ba5:	5d                   	pop    %ebp
  802ba6:	c3                   	ret    

00802ba7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ba7:	55                   	push   %ebp
  802ba8:	89 e5                	mov    %esp,%ebp
  802baa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802bad:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802bb2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802bb5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802bbb:	8b 52 50             	mov    0x50(%edx),%edx
  802bbe:	39 ca                	cmp    %ecx,%edx
  802bc0:	74 11                	je     802bd3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802bc2:	83 c0 01             	add    $0x1,%eax
  802bc5:	3d 00 04 00 00       	cmp    $0x400,%eax
  802bca:	75 e6                	jne    802bb2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd1:	eb 0b                	jmp    802bde <ipc_find_env+0x37>
			return envs[i].env_id;
  802bd3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802bd6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802bdb:	8b 40 48             	mov    0x48(%eax),%eax
}
  802bde:	5d                   	pop    %ebp
  802bdf:	c3                   	ret    

00802be0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
  802be3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802be6:	89 d0                	mov    %edx,%eax
  802be8:	c1 e8 16             	shr    $0x16,%eax
  802beb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802bf2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802bf7:	f6 c1 01             	test   $0x1,%cl
  802bfa:	74 1d                	je     802c19 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802bfc:	c1 ea 0c             	shr    $0xc,%edx
  802bff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802c06:	f6 c2 01             	test   $0x1,%dl
  802c09:	74 0e                	je     802c19 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c0b:	c1 ea 0c             	shr    $0xc,%edx
  802c0e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802c15:	ef 
  802c16:	0f b7 c0             	movzwl %ax,%eax
}
  802c19:	5d                   	pop    %ebp
  802c1a:	c3                   	ret    
  802c1b:	66 90                	xchg   %ax,%ax
  802c1d:	66 90                	xchg   %ax,%ax
  802c1f:	90                   	nop

00802c20 <__udivdi3>:
  802c20:	55                   	push   %ebp
  802c21:	57                   	push   %edi
  802c22:	56                   	push   %esi
  802c23:	53                   	push   %ebx
  802c24:	83 ec 1c             	sub    $0x1c,%esp
  802c27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802c2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802c2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802c37:	85 d2                	test   %edx,%edx
  802c39:	75 35                	jne    802c70 <__udivdi3+0x50>
  802c3b:	39 f3                	cmp    %esi,%ebx
  802c3d:	0f 87 bd 00 00 00    	ja     802d00 <__udivdi3+0xe0>
  802c43:	85 db                	test   %ebx,%ebx
  802c45:	89 d9                	mov    %ebx,%ecx
  802c47:	75 0b                	jne    802c54 <__udivdi3+0x34>
  802c49:	b8 01 00 00 00       	mov    $0x1,%eax
  802c4e:	31 d2                	xor    %edx,%edx
  802c50:	f7 f3                	div    %ebx
  802c52:	89 c1                	mov    %eax,%ecx
  802c54:	31 d2                	xor    %edx,%edx
  802c56:	89 f0                	mov    %esi,%eax
  802c58:	f7 f1                	div    %ecx
  802c5a:	89 c6                	mov    %eax,%esi
  802c5c:	89 e8                	mov    %ebp,%eax
  802c5e:	89 f7                	mov    %esi,%edi
  802c60:	f7 f1                	div    %ecx
  802c62:	89 fa                	mov    %edi,%edx
  802c64:	83 c4 1c             	add    $0x1c,%esp
  802c67:	5b                   	pop    %ebx
  802c68:	5e                   	pop    %esi
  802c69:	5f                   	pop    %edi
  802c6a:	5d                   	pop    %ebp
  802c6b:	c3                   	ret    
  802c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c70:	39 f2                	cmp    %esi,%edx
  802c72:	77 7c                	ja     802cf0 <__udivdi3+0xd0>
  802c74:	0f bd fa             	bsr    %edx,%edi
  802c77:	83 f7 1f             	xor    $0x1f,%edi
  802c7a:	0f 84 98 00 00 00    	je     802d18 <__udivdi3+0xf8>
  802c80:	89 f9                	mov    %edi,%ecx
  802c82:	b8 20 00 00 00       	mov    $0x20,%eax
  802c87:	29 f8                	sub    %edi,%eax
  802c89:	d3 e2                	shl    %cl,%edx
  802c8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c8f:	89 c1                	mov    %eax,%ecx
  802c91:	89 da                	mov    %ebx,%edx
  802c93:	d3 ea                	shr    %cl,%edx
  802c95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c99:	09 d1                	or     %edx,%ecx
  802c9b:	89 f2                	mov    %esi,%edx
  802c9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ca1:	89 f9                	mov    %edi,%ecx
  802ca3:	d3 e3                	shl    %cl,%ebx
  802ca5:	89 c1                	mov    %eax,%ecx
  802ca7:	d3 ea                	shr    %cl,%edx
  802ca9:	89 f9                	mov    %edi,%ecx
  802cab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802caf:	d3 e6                	shl    %cl,%esi
  802cb1:	89 eb                	mov    %ebp,%ebx
  802cb3:	89 c1                	mov    %eax,%ecx
  802cb5:	d3 eb                	shr    %cl,%ebx
  802cb7:	09 de                	or     %ebx,%esi
  802cb9:	89 f0                	mov    %esi,%eax
  802cbb:	f7 74 24 08          	divl   0x8(%esp)
  802cbf:	89 d6                	mov    %edx,%esi
  802cc1:	89 c3                	mov    %eax,%ebx
  802cc3:	f7 64 24 0c          	mull   0xc(%esp)
  802cc7:	39 d6                	cmp    %edx,%esi
  802cc9:	72 0c                	jb     802cd7 <__udivdi3+0xb7>
  802ccb:	89 f9                	mov    %edi,%ecx
  802ccd:	d3 e5                	shl    %cl,%ebp
  802ccf:	39 c5                	cmp    %eax,%ebp
  802cd1:	73 5d                	jae    802d30 <__udivdi3+0x110>
  802cd3:	39 d6                	cmp    %edx,%esi
  802cd5:	75 59                	jne    802d30 <__udivdi3+0x110>
  802cd7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802cda:	31 ff                	xor    %edi,%edi
  802cdc:	89 fa                	mov    %edi,%edx
  802cde:	83 c4 1c             	add    $0x1c,%esp
  802ce1:	5b                   	pop    %ebx
  802ce2:	5e                   	pop    %esi
  802ce3:	5f                   	pop    %edi
  802ce4:	5d                   	pop    %ebp
  802ce5:	c3                   	ret    
  802ce6:	8d 76 00             	lea    0x0(%esi),%esi
  802ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802cf0:	31 ff                	xor    %edi,%edi
  802cf2:	31 c0                	xor    %eax,%eax
  802cf4:	89 fa                	mov    %edi,%edx
  802cf6:	83 c4 1c             	add    $0x1c,%esp
  802cf9:	5b                   	pop    %ebx
  802cfa:	5e                   	pop    %esi
  802cfb:	5f                   	pop    %edi
  802cfc:	5d                   	pop    %ebp
  802cfd:	c3                   	ret    
  802cfe:	66 90                	xchg   %ax,%ax
  802d00:	31 ff                	xor    %edi,%edi
  802d02:	89 e8                	mov    %ebp,%eax
  802d04:	89 f2                	mov    %esi,%edx
  802d06:	f7 f3                	div    %ebx
  802d08:	89 fa                	mov    %edi,%edx
  802d0a:	83 c4 1c             	add    $0x1c,%esp
  802d0d:	5b                   	pop    %ebx
  802d0e:	5e                   	pop    %esi
  802d0f:	5f                   	pop    %edi
  802d10:	5d                   	pop    %ebp
  802d11:	c3                   	ret    
  802d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d18:	39 f2                	cmp    %esi,%edx
  802d1a:	72 06                	jb     802d22 <__udivdi3+0x102>
  802d1c:	31 c0                	xor    %eax,%eax
  802d1e:	39 eb                	cmp    %ebp,%ebx
  802d20:	77 d2                	ja     802cf4 <__udivdi3+0xd4>
  802d22:	b8 01 00 00 00       	mov    $0x1,%eax
  802d27:	eb cb                	jmp    802cf4 <__udivdi3+0xd4>
  802d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d30:	89 d8                	mov    %ebx,%eax
  802d32:	31 ff                	xor    %edi,%edi
  802d34:	eb be                	jmp    802cf4 <__udivdi3+0xd4>
  802d36:	66 90                	xchg   %ax,%ax
  802d38:	66 90                	xchg   %ax,%ax
  802d3a:	66 90                	xchg   %ax,%ax
  802d3c:	66 90                	xchg   %ax,%ax
  802d3e:	66 90                	xchg   %ax,%ax

00802d40 <__umoddi3>:
  802d40:	55                   	push   %ebp
  802d41:	57                   	push   %edi
  802d42:	56                   	push   %esi
  802d43:	53                   	push   %ebx
  802d44:	83 ec 1c             	sub    $0x1c,%esp
  802d47:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  802d4b:	8b 74 24 30          	mov    0x30(%esp),%esi
  802d4f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802d53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d57:	85 ed                	test   %ebp,%ebp
  802d59:	89 f0                	mov    %esi,%eax
  802d5b:	89 da                	mov    %ebx,%edx
  802d5d:	75 19                	jne    802d78 <__umoddi3+0x38>
  802d5f:	39 df                	cmp    %ebx,%edi
  802d61:	0f 86 b1 00 00 00    	jbe    802e18 <__umoddi3+0xd8>
  802d67:	f7 f7                	div    %edi
  802d69:	89 d0                	mov    %edx,%eax
  802d6b:	31 d2                	xor    %edx,%edx
  802d6d:	83 c4 1c             	add    $0x1c,%esp
  802d70:	5b                   	pop    %ebx
  802d71:	5e                   	pop    %esi
  802d72:	5f                   	pop    %edi
  802d73:	5d                   	pop    %ebp
  802d74:	c3                   	ret    
  802d75:	8d 76 00             	lea    0x0(%esi),%esi
  802d78:	39 dd                	cmp    %ebx,%ebp
  802d7a:	77 f1                	ja     802d6d <__umoddi3+0x2d>
  802d7c:	0f bd cd             	bsr    %ebp,%ecx
  802d7f:	83 f1 1f             	xor    $0x1f,%ecx
  802d82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d86:	0f 84 b4 00 00 00    	je     802e40 <__umoddi3+0x100>
  802d8c:	b8 20 00 00 00       	mov    $0x20,%eax
  802d91:	89 c2                	mov    %eax,%edx
  802d93:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d97:	29 c2                	sub    %eax,%edx
  802d99:	89 c1                	mov    %eax,%ecx
  802d9b:	89 f8                	mov    %edi,%eax
  802d9d:	d3 e5                	shl    %cl,%ebp
  802d9f:	89 d1                	mov    %edx,%ecx
  802da1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802da5:	d3 e8                	shr    %cl,%eax
  802da7:	09 c5                	or     %eax,%ebp
  802da9:	8b 44 24 04          	mov    0x4(%esp),%eax
  802dad:	89 c1                	mov    %eax,%ecx
  802daf:	d3 e7                	shl    %cl,%edi
  802db1:	89 d1                	mov    %edx,%ecx
  802db3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802db7:	89 df                	mov    %ebx,%edi
  802db9:	d3 ef                	shr    %cl,%edi
  802dbb:	89 c1                	mov    %eax,%ecx
  802dbd:	89 f0                	mov    %esi,%eax
  802dbf:	d3 e3                	shl    %cl,%ebx
  802dc1:	89 d1                	mov    %edx,%ecx
  802dc3:	89 fa                	mov    %edi,%edx
  802dc5:	d3 e8                	shr    %cl,%eax
  802dc7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802dcc:	09 d8                	or     %ebx,%eax
  802dce:	f7 f5                	div    %ebp
  802dd0:	d3 e6                	shl    %cl,%esi
  802dd2:	89 d1                	mov    %edx,%ecx
  802dd4:	f7 64 24 08          	mull   0x8(%esp)
  802dd8:	39 d1                	cmp    %edx,%ecx
  802dda:	89 c3                	mov    %eax,%ebx
  802ddc:	89 d7                	mov    %edx,%edi
  802dde:	72 06                	jb     802de6 <__umoddi3+0xa6>
  802de0:	75 0e                	jne    802df0 <__umoddi3+0xb0>
  802de2:	39 c6                	cmp    %eax,%esi
  802de4:	73 0a                	jae    802df0 <__umoddi3+0xb0>
  802de6:	2b 44 24 08          	sub    0x8(%esp),%eax
  802dea:	19 ea                	sbb    %ebp,%edx
  802dec:	89 d7                	mov    %edx,%edi
  802dee:	89 c3                	mov    %eax,%ebx
  802df0:	89 ca                	mov    %ecx,%edx
  802df2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802df7:	29 de                	sub    %ebx,%esi
  802df9:	19 fa                	sbb    %edi,%edx
  802dfb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802dff:	89 d0                	mov    %edx,%eax
  802e01:	d3 e0                	shl    %cl,%eax
  802e03:	89 d9                	mov    %ebx,%ecx
  802e05:	d3 ee                	shr    %cl,%esi
  802e07:	d3 ea                	shr    %cl,%edx
  802e09:	09 f0                	or     %esi,%eax
  802e0b:	83 c4 1c             	add    $0x1c,%esp
  802e0e:	5b                   	pop    %ebx
  802e0f:	5e                   	pop    %esi
  802e10:	5f                   	pop    %edi
  802e11:	5d                   	pop    %ebp
  802e12:	c3                   	ret    
  802e13:	90                   	nop
  802e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e18:	85 ff                	test   %edi,%edi
  802e1a:	89 f9                	mov    %edi,%ecx
  802e1c:	75 0b                	jne    802e29 <__umoddi3+0xe9>
  802e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e23:	31 d2                	xor    %edx,%edx
  802e25:	f7 f7                	div    %edi
  802e27:	89 c1                	mov    %eax,%ecx
  802e29:	89 d8                	mov    %ebx,%eax
  802e2b:	31 d2                	xor    %edx,%edx
  802e2d:	f7 f1                	div    %ecx
  802e2f:	89 f0                	mov    %esi,%eax
  802e31:	f7 f1                	div    %ecx
  802e33:	e9 31 ff ff ff       	jmp    802d69 <__umoddi3+0x29>
  802e38:	90                   	nop
  802e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e40:	39 dd                	cmp    %ebx,%ebp
  802e42:	72 08                	jb     802e4c <__umoddi3+0x10c>
  802e44:	39 f7                	cmp    %esi,%edi
  802e46:	0f 87 21 ff ff ff    	ja     802d6d <__umoddi3+0x2d>
  802e4c:	89 da                	mov    %ebx,%edx
  802e4e:	89 f0                	mov    %esi,%eax
  802e50:	29 f8                	sub    %edi,%eax
  802e52:	19 ea                	sbb    %ebp,%edx
  802e54:	e9 14 ff ff ff       	jmp    802d6d <__umoddi3+0x2d>
