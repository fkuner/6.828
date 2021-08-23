
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 9b 01 00 00       	call   8001cc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 a0 28 80 00       	push   $0x8028a0
  800043:	e8 1c 1a 00 00       	call   801a64 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 01 01 00 00    	js     800156 <umain+0x123>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 b0 16 00 00       	call   801710 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 d4 15 00 00       	call   801647 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e8 00 00 00    	jle    800168 <umain+0x135>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 12 10 00 00       	call   801097 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 eb 00 00 00    	js     80017a <umain+0x147>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	85 c0                	test   %eax,%eax
  800091:	75 7b                	jne    80010e <umain+0xdb>
		seek(fd, 0);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	6a 00                	push   $0x0
  800098:	53                   	push   %ebx
  800099:	e8 72 16 00 00       	call   801710 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009e:	c7 04 24 08 29 80 00 	movl   $0x802908,(%esp)
  8000a5:	e8 5d 02 00 00       	call   800307 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 02 00 00       	push   $0x200
  8000b2:	68 20 40 80 00       	push   $0x804020
  8000b7:	53                   	push   %ebx
  8000b8:	e8 8a 15 00 00       	call   801647 <readn>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	39 c6                	cmp    %eax,%esi
  8000c2:	0f 85 c4 00 00 00    	jne    80018c <umain+0x159>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	56                   	push   %esi
  8000cc:	68 20 40 80 00       	push   $0x804020
  8000d1:	68 20 42 80 00       	push   $0x804220
  8000d6:	e8 d2 0a 00 00       	call   800bad <memcmp>
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 85 bc 00 00 00    	jne    8001a2 <umain+0x16f>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 d2 28 80 00       	push   $0x8028d2
  8000ee:	e8 14 02 00 00       	call   800307 <cprintf>
		seek(fd, 0);
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	6a 00                	push   $0x0
  8000f8:	53                   	push   %ebx
  8000f9:	e8 12 16 00 00       	call   801710 <seek>
		close(fd);
  8000fe:	89 1c 24             	mov    %ebx,(%esp)
  800101:	e8 7e 13 00 00       	call   801484 <close>
		exit();
  800106:	e8 07 01 00 00       	call   800212 <exit>
  80010b:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	57                   	push   %edi
  800112:	e8 3f 1d 00 00       	call   801e56 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800117:	83 c4 0c             	add    $0xc,%esp
  80011a:	68 00 02 00 00       	push   $0x200
  80011f:	68 20 40 80 00       	push   $0x804020
  800124:	53                   	push   %ebx
  800125:	e8 1d 15 00 00       	call   801647 <readn>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	39 c6                	cmp    %eax,%esi
  80012f:	0f 85 81 00 00 00    	jne    8001b6 <umain+0x183>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	68 eb 28 80 00       	push   $0x8028eb
  80013d:	e8 c5 01 00 00       	call   800307 <cprintf>
	close(fd);
  800142:	89 1c 24             	mov    %ebx,(%esp)
  800145:	e8 3a 13 00 00       	call   801484 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014a:	cc                   	int3   

	breakpoint();
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    
		panic("open motd: %e", fd);
  800156:	50                   	push   %eax
  800157:	68 a5 28 80 00       	push   $0x8028a5
  80015c:	6a 0c                	push   $0xc
  80015e:	68 b3 28 80 00       	push   $0x8028b3
  800163:	e8 c4 00 00 00       	call   80022c <_panic>
		panic("readn: %e", n);
  800168:	50                   	push   %eax
  800169:	68 c8 28 80 00       	push   $0x8028c8
  80016e:	6a 0f                	push   $0xf
  800170:	68 b3 28 80 00       	push   $0x8028b3
  800175:	e8 b2 00 00 00       	call   80022c <_panic>
		panic("fork: %e", r);
  80017a:	50                   	push   %eax
  80017b:	68 66 2d 80 00       	push   $0x802d66
  800180:	6a 12                	push   $0x12
  800182:	68 b3 28 80 00       	push   $0x8028b3
  800187:	e8 a0 00 00 00       	call   80022c <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	56                   	push   %esi
  800191:	68 4c 29 80 00       	push   $0x80294c
  800196:	6a 17                	push   $0x17
  800198:	68 b3 28 80 00       	push   $0x8028b3
  80019d:	e8 8a 00 00 00       	call   80022c <_panic>
			panic("read in parent got different bytes from read in child");
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 78 29 80 00       	push   $0x802978
  8001aa:	6a 19                	push   $0x19
  8001ac:	68 b3 28 80 00       	push   $0x8028b3
  8001b1:	e8 76 00 00 00       	call   80022c <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	56                   	push   %esi
  8001bb:	68 b0 29 80 00       	push   $0x8029b0
  8001c0:	6a 21                	push   $0x21
  8001c2:	68 b3 28 80 00       	push   $0x8028b3
  8001c7:	e8 60 00 00 00       	call   80022c <_panic>

008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8001d7:	e8 83 0b 00 00       	call   800d5f <sys_getenvid>
  8001dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e9:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7e 07                	jle    8001f9 <libmain+0x2d>
		binaryname = argv[0];
  8001f2:	8b 06                	mov    (%esi),%eax
  8001f4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	56                   	push   %esi
  8001fd:	53                   	push   %ebx
  8001fe:	e8 30 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800203:	e8 0a 00 00 00       	call   800212 <exit>
}
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    

00800212 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800218:	e8 92 12 00 00       	call   8014af <close_all>
	sys_env_destroy(0);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	6a 00                	push   $0x0
  800222:	e8 f7 0a 00 00       	call   800d1e <sys_env_destroy>
}
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800231:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800234:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80023a:	e8 20 0b 00 00       	call   800d5f <sys_getenvid>
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	56                   	push   %esi
  800249:	50                   	push   %eax
  80024a:	68 e0 29 80 00       	push   $0x8029e0
  80024f:	e8 b3 00 00 00       	call   800307 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800254:	83 c4 18             	add    $0x18,%esp
  800257:	53                   	push   %ebx
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	e8 56 00 00 00       	call   8002b6 <vcprintf>
	cprintf("\n");
  800260:	c7 04 24 e9 28 80 00 	movl   $0x8028e9,(%esp)
  800267:	e8 9b 00 00 00       	call   800307 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026f:	cc                   	int3   
  800270:	eb fd                	jmp    80026f <_panic+0x43>

00800272 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027c:	8b 13                	mov    (%ebx),%edx
  80027e:	8d 42 01             	lea    0x1(%edx),%eax
  800281:	89 03                	mov    %eax,(%ebx)
  800283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800286:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028f:	74 09                	je     80029a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800291:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800298:	c9                   	leave  
  800299:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	68 ff 00 00 00       	push   $0xff
  8002a2:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a5:	50                   	push   %eax
  8002a6:	e8 36 0a 00 00       	call   800ce1 <sys_cputs>
		b->idx = 0;
  8002ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	eb db                	jmp    800291 <putch+0x1f>

008002b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c6:	00 00 00 
	b.cnt = 0;
  8002c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d3:	ff 75 0c             	pushl  0xc(%ebp)
  8002d6:	ff 75 08             	pushl  0x8(%ebp)
  8002d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002df:	50                   	push   %eax
  8002e0:	68 72 02 80 00       	push   $0x800272
  8002e5:	e8 1a 01 00 00       	call   800404 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ea:	83 c4 08             	add    $0x8,%esp
  8002ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	e8 e2 09 00 00       	call   800ce1 <sys_cputs>

	return b.cnt;
}
  8002ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 08             	pushl  0x8(%ebp)
  800314:	e8 9d ff ff ff       	call   8002b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
  800321:	83 ec 1c             	sub    $0x1c,%esp
  800324:	89 c7                	mov    %eax,%edi
  800326:	89 d6                	mov    %edx,%esi
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800331:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800334:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800337:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80033f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800342:	39 d3                	cmp    %edx,%ebx
  800344:	72 05                	jb     80034b <printnum+0x30>
  800346:	39 45 10             	cmp    %eax,0x10(%ebp)
  800349:	77 7a                	ja     8003c5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	ff 75 18             	pushl  0x18(%ebp)
  800351:	8b 45 14             	mov    0x14(%ebp),%eax
  800354:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800357:	53                   	push   %ebx
  800358:	ff 75 10             	pushl  0x10(%ebp)
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	ff 75 dc             	pushl  -0x24(%ebp)
  800367:	ff 75 d8             	pushl  -0x28(%ebp)
  80036a:	e8 f1 22 00 00       	call   802660 <__udivdi3>
  80036f:	83 c4 18             	add    $0x18,%esp
  800372:	52                   	push   %edx
  800373:	50                   	push   %eax
  800374:	89 f2                	mov    %esi,%edx
  800376:	89 f8                	mov    %edi,%eax
  800378:	e8 9e ff ff ff       	call   80031b <printnum>
  80037d:	83 c4 20             	add    $0x20,%esp
  800380:	eb 13                	jmp    800395 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800382:	83 ec 08             	sub    $0x8,%esp
  800385:	56                   	push   %esi
  800386:	ff 75 18             	pushl  0x18(%ebp)
  800389:	ff d7                	call   *%edi
  80038b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80038e:	83 eb 01             	sub    $0x1,%ebx
  800391:	85 db                	test   %ebx,%ebx
  800393:	7f ed                	jg     800382 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	56                   	push   %esi
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039f:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a8:	e8 d3 23 00 00       	call   802780 <__umoddi3>
  8003ad:	83 c4 14             	add    $0x14,%esp
  8003b0:	0f be 80 03 2a 80 00 	movsbl 0x802a03(%eax),%eax
  8003b7:	50                   	push   %eax
  8003b8:	ff d7                	call   *%edi
}
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c0:	5b                   	pop    %ebx
  8003c1:	5e                   	pop    %esi
  8003c2:	5f                   	pop    %edi
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    
  8003c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003c8:	eb c4                	jmp    80038e <printnum+0x73>

008003ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d4:	8b 10                	mov    (%eax),%edx
  8003d6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d9:	73 0a                	jae    8003e5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	88 02                	mov    %al,(%edx)
}
  8003e5:	5d                   	pop    %ebp
  8003e6:	c3                   	ret    

008003e7 <printfmt>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ed:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f0:	50                   	push   %eax
  8003f1:	ff 75 10             	pushl  0x10(%ebp)
  8003f4:	ff 75 0c             	pushl  0xc(%ebp)
  8003f7:	ff 75 08             	pushl  0x8(%ebp)
  8003fa:	e8 05 00 00 00       	call   800404 <vprintfmt>
}
  8003ff:	83 c4 10             	add    $0x10,%esp
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <vprintfmt>:
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	57                   	push   %edi
  800408:	56                   	push   %esi
  800409:	53                   	push   %ebx
  80040a:	83 ec 2c             	sub    $0x2c,%esp
  80040d:	8b 75 08             	mov    0x8(%ebp),%esi
  800410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800413:	8b 7d 10             	mov    0x10(%ebp),%edi
  800416:	e9 21 04 00 00       	jmp    80083c <vprintfmt+0x438>
		padc = ' ';
  80041b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80041f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800426:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80042d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800434:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8d 47 01             	lea    0x1(%edi),%eax
  80043c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043f:	0f b6 17             	movzbl (%edi),%edx
  800442:	8d 42 dd             	lea    -0x23(%edx),%eax
  800445:	3c 55                	cmp    $0x55,%al
  800447:	0f 87 90 04 00 00    	ja     8008dd <vprintfmt+0x4d9>
  80044d:	0f b6 c0             	movzbl %al,%eax
  800450:	ff 24 85 40 2b 80 00 	jmp    *0x802b40(,%eax,4)
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80045a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80045e:	eb d9                	jmp    800439 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800463:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800467:	eb d0                	jmp    800439 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800469:	0f b6 d2             	movzbl %dl,%edx
  80046c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80046f:	b8 00 00 00 00       	mov    $0x0,%eax
  800474:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800477:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80047a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80047e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800481:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800484:	83 f9 09             	cmp    $0x9,%ecx
  800487:	77 55                	ja     8004de <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800489:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80048c:	eb e9                	jmp    800477 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8d 40 04             	lea    0x4(%eax),%eax
  80049c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a6:	79 91                	jns    800439 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004b5:	eb 82                	jmp    800439 <vprintfmt+0x35>
  8004b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c1:	0f 49 d0             	cmovns %eax,%edx
  8004c4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ca:	e9 6a ff ff ff       	jmp    800439 <vprintfmt+0x35>
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004d9:	e9 5b ff ff ff       	jmp    800439 <vprintfmt+0x35>
  8004de:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e4:	eb bc                	jmp    8004a2 <vprintfmt+0x9e>
			lflag++;
  8004e6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ec:	e9 48 ff ff ff       	jmp    800439 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 78 04             	lea    0x4(%eax),%edi
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	ff 30                	pushl  (%eax)
  8004fd:	ff d6                	call   *%esi
			break;
  8004ff:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800502:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800505:	e9 2f 03 00 00       	jmp    800839 <vprintfmt+0x435>
			err = va_arg(ap, int);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8d 78 04             	lea    0x4(%eax),%edi
  800510:	8b 00                	mov    (%eax),%eax
  800512:	99                   	cltd   
  800513:	31 d0                	xor    %edx,%eax
  800515:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800517:	83 f8 0f             	cmp    $0xf,%eax
  80051a:	7f 23                	jg     80053f <vprintfmt+0x13b>
  80051c:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  800523:	85 d2                	test   %edx,%edx
  800525:	74 18                	je     80053f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800527:	52                   	push   %edx
  800528:	68 66 2e 80 00       	push   $0x802e66
  80052d:	53                   	push   %ebx
  80052e:	56                   	push   %esi
  80052f:	e8 b3 fe ff ff       	call   8003e7 <printfmt>
  800534:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800537:	89 7d 14             	mov    %edi,0x14(%ebp)
  80053a:	e9 fa 02 00 00       	jmp    800839 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80053f:	50                   	push   %eax
  800540:	68 1b 2a 80 00       	push   $0x802a1b
  800545:	53                   	push   %ebx
  800546:	56                   	push   %esi
  800547:	e8 9b fe ff ff       	call   8003e7 <printfmt>
  80054c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800552:	e9 e2 02 00 00       	jmp    800839 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 c0 04             	add    $0x4,%eax
  80055d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800565:	85 ff                	test   %edi,%edi
  800567:	b8 14 2a 80 00       	mov    $0x802a14,%eax
  80056c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80056f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800573:	0f 8e bd 00 00 00    	jle    800636 <vprintfmt+0x232>
  800579:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80057d:	75 0e                	jne    80058d <vprintfmt+0x189>
  80057f:	89 75 08             	mov    %esi,0x8(%ebp)
  800582:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800585:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800588:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80058b:	eb 6d                	jmp    8005fa <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 d0             	pushl  -0x30(%ebp)
  800593:	57                   	push   %edi
  800594:	e8 ec 03 00 00       	call   800985 <strnlen>
  800599:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059c:	29 c1                	sub    %eax,%ecx
  80059e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005a4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ab:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005ae:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	eb 0f                	jmp    8005c1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	83 ef 01             	sub    $0x1,%edi
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	85 ff                	test   %edi,%edi
  8005c3:	7f ed                	jg     8005b2 <vprintfmt+0x1ae>
  8005c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005c8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005cb:	85 c9                	test   %ecx,%ecx
  8005cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d2:	0f 49 c1             	cmovns %ecx,%eax
  8005d5:	29 c1                	sub    %eax,%ecx
  8005d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8005da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005dd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e0:	89 cb                	mov    %ecx,%ebx
  8005e2:	eb 16                	jmp    8005fa <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e8:	75 31                	jne    80061b <vprintfmt+0x217>
					putch(ch, putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 0c             	pushl  0xc(%ebp)
  8005f0:	50                   	push   %eax
  8005f1:	ff 55 08             	call   *0x8(%ebp)
  8005f4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f7:	83 eb 01             	sub    $0x1,%ebx
  8005fa:	83 c7 01             	add    $0x1,%edi
  8005fd:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800601:	0f be c2             	movsbl %dl,%eax
  800604:	85 c0                	test   %eax,%eax
  800606:	74 59                	je     800661 <vprintfmt+0x25d>
  800608:	85 f6                	test   %esi,%esi
  80060a:	78 d8                	js     8005e4 <vprintfmt+0x1e0>
  80060c:	83 ee 01             	sub    $0x1,%esi
  80060f:	79 d3                	jns    8005e4 <vprintfmt+0x1e0>
  800611:	89 df                	mov    %ebx,%edi
  800613:	8b 75 08             	mov    0x8(%ebp),%esi
  800616:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800619:	eb 37                	jmp    800652 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80061b:	0f be d2             	movsbl %dl,%edx
  80061e:	83 ea 20             	sub    $0x20,%edx
  800621:	83 fa 5e             	cmp    $0x5e,%edx
  800624:	76 c4                	jbe    8005ea <vprintfmt+0x1e6>
					putch('?', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	6a 3f                	push   $0x3f
  80062e:	ff 55 08             	call   *0x8(%ebp)
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	eb c1                	jmp    8005f7 <vprintfmt+0x1f3>
  800636:	89 75 08             	mov    %esi,0x8(%ebp)
  800639:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80063c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80063f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800642:	eb b6                	jmp    8005fa <vprintfmt+0x1f6>
				putch(' ', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 20                	push   $0x20
  80064a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064c:	83 ef 01             	sub    $0x1,%edi
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	85 ff                	test   %edi,%edi
  800654:	7f ee                	jg     800644 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800656:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	e9 d8 01 00 00       	jmp    800839 <vprintfmt+0x435>
  800661:	89 df                	mov    %ebx,%edi
  800663:	8b 75 08             	mov    0x8(%ebp),%esi
  800666:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800669:	eb e7                	jmp    800652 <vprintfmt+0x24e>
	if (lflag >= 2)
  80066b:	83 f9 01             	cmp    $0x1,%ecx
  80066e:	7e 45                	jle    8006b5 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 50 04             	mov    0x4(%eax),%edx
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 08             	lea    0x8(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068b:	79 62                	jns    8006ef <vprintfmt+0x2eb>
				putch('-', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 2d                	push   $0x2d
  800693:	ff d6                	call   *%esi
				num = -(long long) num;
  800695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800698:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80069b:	f7 d8                	neg    %eax
  80069d:	83 d2 00             	adc    $0x0,%edx
  8006a0:	f7 da                	neg    %edx
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ab:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006b0:	e9 66 01 00 00       	jmp    80081b <vprintfmt+0x417>
	else if (lflag)
  8006b5:	85 c9                	test   %ecx,%ecx
  8006b7:	75 1b                	jne    8006d4 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 c1                	mov    %eax,%ecx
  8006c3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d2:	eb b3                	jmp    800687 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 c1                	mov    %eax,%ecx
  8006de:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ed:	eb 98                	jmp    800687 <vprintfmt+0x283>
			base = 10;
  8006ef:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006f4:	e9 22 01 00 00       	jmp    80081b <vprintfmt+0x417>
	if (lflag >= 2)
  8006f9:	83 f9 01             	cmp    $0x1,%ecx
  8006fc:	7e 21                	jle    80071f <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800709:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800715:	ba 0a 00 00 00       	mov    $0xa,%edx
  80071a:	e9 fc 00 00 00       	jmp    80081b <vprintfmt+0x417>
	else if (lflag)
  80071f:	85 c9                	test   %ecx,%ecx
  800721:	75 23                	jne    800746 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073c:	ba 0a 00 00 00       	mov    $0xa,%edx
  800741:	e9 d5 00 00 00       	jmp    80081b <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	ba 00 00 00 00       	mov    $0x0,%edx
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8d 40 04             	lea    0x4(%eax),%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075f:	ba 0a 00 00 00       	mov    $0xa,%edx
  800764:	e9 b2 00 00 00       	jmp    80081b <vprintfmt+0x417>
	if (lflag >= 2)
  800769:	83 f9 01             	cmp    $0x1,%ecx
  80076c:	7e 42                	jle    8007b0 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8b 50 04             	mov    0x4(%eax),%edx
  800774:	8b 00                	mov    (%eax),%eax
  800776:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800779:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8d 40 08             	lea    0x8(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800785:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  80078a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80078e:	0f 89 87 00 00 00    	jns    80081b <vprintfmt+0x417>
				putch('-', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	53                   	push   %ebx
  800798:	6a 2d                	push   $0x2d
  80079a:	ff d6                	call   *%esi
				num = -(long long) num;
  80079c:	f7 5d d8             	negl   -0x28(%ebp)
  80079f:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8007a3:	f7 5d dc             	negl   -0x24(%ebp)
  8007a6:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007a9:	ba 08 00 00 00       	mov    $0x8,%edx
  8007ae:	eb 6b                	jmp    80081b <vprintfmt+0x417>
	else if (lflag)
  8007b0:	85 c9                	test   %ecx,%ecx
  8007b2:	75 1b                	jne    8007cf <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cd:	eb b6                	jmp    800785 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e8:	eb 9b                	jmp    800785 <vprintfmt+0x381>
			putch('0', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	53                   	push   %ebx
  8007ee:	6a 30                	push   $0x30
  8007f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f2:	83 c4 08             	add    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	6a 78                	push   $0x78
  8007f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800807:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80080a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800816:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800822:	50                   	push   %eax
  800823:	ff 75 e0             	pushl  -0x20(%ebp)
  800826:	52                   	push   %edx
  800827:	ff 75 dc             	pushl  -0x24(%ebp)
  80082a:	ff 75 d8             	pushl  -0x28(%ebp)
  80082d:	89 da                	mov    %ebx,%edx
  80082f:	89 f0                	mov    %esi,%eax
  800831:	e8 e5 fa ff ff       	call   80031b <printnum>
			break;
  800836:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800839:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083c:	83 c7 01             	add    $0x1,%edi
  80083f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800843:	83 f8 25             	cmp    $0x25,%eax
  800846:	0f 84 cf fb ff ff    	je     80041b <vprintfmt+0x17>
			if (ch == '\0')
  80084c:	85 c0                	test   %eax,%eax
  80084e:	0f 84 a9 00 00 00    	je     8008fd <vprintfmt+0x4f9>
			putch(ch, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	53                   	push   %ebx
  800858:	50                   	push   %eax
  800859:	ff d6                	call   *%esi
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	eb dc                	jmp    80083c <vprintfmt+0x438>
	if (lflag >= 2)
  800860:	83 f9 01             	cmp    $0x1,%ecx
  800863:	7e 1e                	jle    800883 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8b 50 04             	mov    0x4(%eax),%edx
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800870:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8d 40 08             	lea    0x8(%eax),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087c:	ba 10 00 00 00       	mov    $0x10,%edx
  800881:	eb 98                	jmp    80081b <vprintfmt+0x417>
	else if (lflag)
  800883:	85 c9                	test   %ecx,%ecx
  800885:	75 23                	jne    8008aa <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	ba 00 00 00 00       	mov    $0x0,%edx
  800891:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800894:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 40 04             	lea    0x4(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a0:	ba 10 00 00 00       	mov    $0x10,%edx
  8008a5:	e9 71 ff ff ff       	jmp    80081b <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8d 40 04             	lea    0x4(%eax),%eax
  8008c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c3:	ba 10 00 00 00       	mov    $0x10,%edx
  8008c8:	e9 4e ff ff ff       	jmp    80081b <vprintfmt+0x417>
			putch(ch, putdat);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	53                   	push   %ebx
  8008d1:	6a 25                	push   $0x25
  8008d3:	ff d6                	call   *%esi
			break;
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	e9 5c ff ff ff       	jmp    800839 <vprintfmt+0x435>
			putch('%', putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	6a 25                	push   $0x25
  8008e3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	89 f8                	mov    %edi,%eax
  8008ea:	eb 03                	jmp    8008ef <vprintfmt+0x4eb>
  8008ec:	83 e8 01             	sub    $0x1,%eax
  8008ef:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008f3:	75 f7                	jne    8008ec <vprintfmt+0x4e8>
  8008f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f8:	e9 3c ff ff ff       	jmp    800839 <vprintfmt+0x435>
}
  8008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800900:	5b                   	pop    %ebx
  800901:	5e                   	pop    %esi
  800902:	5f                   	pop    %edi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	83 ec 18             	sub    $0x18,%esp
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800911:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800914:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800918:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800922:	85 c0                	test   %eax,%eax
  800924:	74 26                	je     80094c <vsnprintf+0x47>
  800926:	85 d2                	test   %edx,%edx
  800928:	7e 22                	jle    80094c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80092a:	ff 75 14             	pushl  0x14(%ebp)
  80092d:	ff 75 10             	pushl  0x10(%ebp)
  800930:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800933:	50                   	push   %eax
  800934:	68 ca 03 80 00       	push   $0x8003ca
  800939:	e8 c6 fa ff ff       	call   800404 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80093e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800941:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800947:	83 c4 10             	add    $0x10,%esp
}
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    
		return -E_INVAL;
  80094c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800951:	eb f7                	jmp    80094a <vsnprintf+0x45>

00800953 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800959:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80095c:	50                   	push   %eax
  80095d:	ff 75 10             	pushl  0x10(%ebp)
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	ff 75 08             	pushl  0x8(%ebp)
  800966:	e8 9a ff ff ff       	call   800905 <vsnprintf>
	va_end(ap);

	return rc;
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800973:	b8 00 00 00 00       	mov    $0x0,%eax
  800978:	eb 03                	jmp    80097d <strlen+0x10>
		n++;
  80097a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80097d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800981:	75 f7                	jne    80097a <strlen+0xd>
	return n;
}
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	eb 03                	jmp    800998 <strnlen+0x13>
		n++;
  800995:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800998:	39 d0                	cmp    %edx,%eax
  80099a:	74 06                	je     8009a2 <strnlen+0x1d>
  80099c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a0:	75 f3                	jne    800995 <strnlen+0x10>
	return n;
}
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	83 c1 01             	add    $0x1,%ecx
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009ba:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009bd:	84 db                	test   %bl,%bl
  8009bf:	75 ef                	jne    8009b0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c1:	5b                   	pop    %ebx
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009cb:	53                   	push   %ebx
  8009cc:	e8 9c ff ff ff       	call   80096d <strlen>
  8009d1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	01 d8                	add    %ebx,%eax
  8009d9:	50                   	push   %eax
  8009da:	e8 c5 ff ff ff       	call   8009a4 <strcpy>
	return dst;
}
  8009df:	89 d8                	mov    %ebx,%eax
  8009e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f1:	89 f3                	mov    %esi,%ebx
  8009f3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f6:	89 f2                	mov    %esi,%edx
  8009f8:	eb 0f                	jmp    800a09 <strncpy+0x23>
		*dst++ = *src;
  8009fa:	83 c2 01             	add    $0x1,%edx
  8009fd:	0f b6 01             	movzbl (%ecx),%eax
  800a00:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a03:	80 39 01             	cmpb   $0x1,(%ecx)
  800a06:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a09:	39 da                	cmp    %ebx,%edx
  800a0b:	75 ed                	jne    8009fa <strncpy+0x14>
	}
	return ret;
}
  800a0d:	89 f0                	mov    %esi,%eax
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	56                   	push   %esi
  800a17:	53                   	push   %ebx
  800a18:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a21:	89 f0                	mov    %esi,%eax
  800a23:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a27:	85 c9                	test   %ecx,%ecx
  800a29:	75 0b                	jne    800a36 <strlcpy+0x23>
  800a2b:	eb 17                	jmp    800a44 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a2d:	83 c2 01             	add    $0x1,%edx
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a36:	39 d8                	cmp    %ebx,%eax
  800a38:	74 07                	je     800a41 <strlcpy+0x2e>
  800a3a:	0f b6 0a             	movzbl (%edx),%ecx
  800a3d:	84 c9                	test   %cl,%cl
  800a3f:	75 ec                	jne    800a2d <strlcpy+0x1a>
		*dst = '\0';
  800a41:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a44:	29 f0                	sub    %esi,%eax
}
  800a46:	5b                   	pop    %ebx
  800a47:	5e                   	pop    %esi
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a50:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a53:	eb 06                	jmp    800a5b <strcmp+0x11>
		p++, q++;
  800a55:	83 c1 01             	add    $0x1,%ecx
  800a58:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a5b:	0f b6 01             	movzbl (%ecx),%eax
  800a5e:	84 c0                	test   %al,%al
  800a60:	74 04                	je     800a66 <strcmp+0x1c>
  800a62:	3a 02                	cmp    (%edx),%al
  800a64:	74 ef                	je     800a55 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a66:	0f b6 c0             	movzbl %al,%eax
  800a69:	0f b6 12             	movzbl (%edx),%edx
  800a6c:	29 d0                	sub    %edx,%eax
}
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	53                   	push   %ebx
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7a:	89 c3                	mov    %eax,%ebx
  800a7c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a7f:	eb 06                	jmp    800a87 <strncmp+0x17>
		n--, p++, q++;
  800a81:	83 c0 01             	add    $0x1,%eax
  800a84:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a87:	39 d8                	cmp    %ebx,%eax
  800a89:	74 16                	je     800aa1 <strncmp+0x31>
  800a8b:	0f b6 08             	movzbl (%eax),%ecx
  800a8e:	84 c9                	test   %cl,%cl
  800a90:	74 04                	je     800a96 <strncmp+0x26>
  800a92:	3a 0a                	cmp    (%edx),%cl
  800a94:	74 eb                	je     800a81 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a96:	0f b6 00             	movzbl (%eax),%eax
  800a99:	0f b6 12             	movzbl (%edx),%edx
  800a9c:	29 d0                	sub    %edx,%eax
}
  800a9e:	5b                   	pop    %ebx
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    
		return 0;
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	eb f6                	jmp    800a9e <strncmp+0x2e>

00800aa8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab2:	0f b6 10             	movzbl (%eax),%edx
  800ab5:	84 d2                	test   %dl,%dl
  800ab7:	74 09                	je     800ac2 <strchr+0x1a>
		if (*s == c)
  800ab9:	38 ca                	cmp    %cl,%dl
  800abb:	74 0a                	je     800ac7 <strchr+0x1f>
	for (; *s; s++)
  800abd:	83 c0 01             	add    $0x1,%eax
  800ac0:	eb f0                	jmp    800ab2 <strchr+0xa>
			return (char *) s;
	return 0;
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad3:	eb 03                	jmp    800ad8 <strfind+0xf>
  800ad5:	83 c0 01             	add    $0x1,%eax
  800ad8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800adb:	38 ca                	cmp    %cl,%dl
  800add:	74 04                	je     800ae3 <strfind+0x1a>
  800adf:	84 d2                	test   %dl,%dl
  800ae1:	75 f2                	jne    800ad5 <strfind+0xc>
			break;
	return (char *) s;
}
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	57                   	push   %edi
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
  800aeb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af1:	85 c9                	test   %ecx,%ecx
  800af3:	74 13                	je     800b08 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800afb:	75 05                	jne    800b02 <memset+0x1d>
  800afd:	f6 c1 03             	test   $0x3,%cl
  800b00:	74 0d                	je     800b0f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	fc                   	cld    
  800b06:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b08:	89 f8                	mov    %edi,%eax
  800b0a:	5b                   	pop    %ebx
  800b0b:	5e                   	pop    %esi
  800b0c:	5f                   	pop    %edi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    
		c &= 0xFF;
  800b0f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b13:	89 d3                	mov    %edx,%ebx
  800b15:	c1 e3 08             	shl    $0x8,%ebx
  800b18:	89 d0                	mov    %edx,%eax
  800b1a:	c1 e0 18             	shl    $0x18,%eax
  800b1d:	89 d6                	mov    %edx,%esi
  800b1f:	c1 e6 10             	shl    $0x10,%esi
  800b22:	09 f0                	or     %esi,%eax
  800b24:	09 c2                	or     %eax,%edx
  800b26:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b28:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b2b:	89 d0                	mov    %edx,%eax
  800b2d:	fc                   	cld    
  800b2e:	f3 ab                	rep stos %eax,%es:(%edi)
  800b30:	eb d6                	jmp    800b08 <memset+0x23>

00800b32 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b40:	39 c6                	cmp    %eax,%esi
  800b42:	73 35                	jae    800b79 <memmove+0x47>
  800b44:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b47:	39 c2                	cmp    %eax,%edx
  800b49:	76 2e                	jbe    800b79 <memmove+0x47>
		s += n;
		d += n;
  800b4b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4e:	89 d6                	mov    %edx,%esi
  800b50:	09 fe                	or     %edi,%esi
  800b52:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b58:	74 0c                	je     800b66 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b5a:	83 ef 01             	sub    $0x1,%edi
  800b5d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b60:	fd                   	std    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b63:	fc                   	cld    
  800b64:	eb 21                	jmp    800b87 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b66:	f6 c1 03             	test   $0x3,%cl
  800b69:	75 ef                	jne    800b5a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b6b:	83 ef 04             	sub    $0x4,%edi
  800b6e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b71:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b74:	fd                   	std    
  800b75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b77:	eb ea                	jmp    800b63 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b79:	89 f2                	mov    %esi,%edx
  800b7b:	09 c2                	or     %eax,%edx
  800b7d:	f6 c2 03             	test   $0x3,%dl
  800b80:	74 09                	je     800b8b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b82:	89 c7                	mov    %eax,%edi
  800b84:	fc                   	cld    
  800b85:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b87:	5e                   	pop    %esi
  800b88:	5f                   	pop    %edi
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8b:	f6 c1 03             	test   $0x3,%cl
  800b8e:	75 f2                	jne    800b82 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b90:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b93:	89 c7                	mov    %eax,%edi
  800b95:	fc                   	cld    
  800b96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b98:	eb ed                	jmp    800b87 <memmove+0x55>

00800b9a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	ff 75 08             	pushl  0x8(%ebp)
  800ba6:	e8 87 ff ff ff       	call   800b32 <memmove>
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	89 c6                	mov    %eax,%esi
  800bba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bbd:	39 f0                	cmp    %esi,%eax
  800bbf:	74 1c                	je     800bdd <memcmp+0x30>
		if (*s1 != *s2)
  800bc1:	0f b6 08             	movzbl (%eax),%ecx
  800bc4:	0f b6 1a             	movzbl (%edx),%ebx
  800bc7:	38 d9                	cmp    %bl,%cl
  800bc9:	75 08                	jne    800bd3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bcb:	83 c0 01             	add    $0x1,%eax
  800bce:	83 c2 01             	add    $0x1,%edx
  800bd1:	eb ea                	jmp    800bbd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bd3:	0f b6 c1             	movzbl %cl,%eax
  800bd6:	0f b6 db             	movzbl %bl,%ebx
  800bd9:	29 d8                	sub    %ebx,%eax
  800bdb:	eb 05                	jmp    800be2 <memcmp+0x35>
	}

	return 0;
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bef:	89 c2                	mov    %eax,%edx
  800bf1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bf4:	39 d0                	cmp    %edx,%eax
  800bf6:	73 09                	jae    800c01 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf8:	38 08                	cmp    %cl,(%eax)
  800bfa:	74 05                	je     800c01 <memfind+0x1b>
	for (; s < ends; s++)
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	eb f3                	jmp    800bf4 <memfind+0xe>
			break;
	return (void *) s;
}
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c0f:	eb 03                	jmp    800c14 <strtol+0x11>
		s++;
  800c11:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c14:	0f b6 01             	movzbl (%ecx),%eax
  800c17:	3c 20                	cmp    $0x20,%al
  800c19:	74 f6                	je     800c11 <strtol+0xe>
  800c1b:	3c 09                	cmp    $0x9,%al
  800c1d:	74 f2                	je     800c11 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c1f:	3c 2b                	cmp    $0x2b,%al
  800c21:	74 2e                	je     800c51 <strtol+0x4e>
	int neg = 0;
  800c23:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c28:	3c 2d                	cmp    $0x2d,%al
  800c2a:	74 2f                	je     800c5b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c32:	75 05                	jne    800c39 <strtol+0x36>
  800c34:	80 39 30             	cmpb   $0x30,(%ecx)
  800c37:	74 2c                	je     800c65 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c39:	85 db                	test   %ebx,%ebx
  800c3b:	75 0a                	jne    800c47 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c3d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c42:	80 39 30             	cmpb   $0x30,(%ecx)
  800c45:	74 28                	je     800c6f <strtol+0x6c>
		base = 10;
  800c47:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c4f:	eb 50                	jmp    800ca1 <strtol+0x9e>
		s++;
  800c51:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c54:	bf 00 00 00 00       	mov    $0x0,%edi
  800c59:	eb d1                	jmp    800c2c <strtol+0x29>
		s++, neg = 1;
  800c5b:	83 c1 01             	add    $0x1,%ecx
  800c5e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c63:	eb c7                	jmp    800c2c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c65:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c69:	74 0e                	je     800c79 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c6b:	85 db                	test   %ebx,%ebx
  800c6d:	75 d8                	jne    800c47 <strtol+0x44>
		s++, base = 8;
  800c6f:	83 c1 01             	add    $0x1,%ecx
  800c72:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c77:	eb ce                	jmp    800c47 <strtol+0x44>
		s += 2, base = 16;
  800c79:	83 c1 02             	add    $0x2,%ecx
  800c7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c81:	eb c4                	jmp    800c47 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c83:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c86:	89 f3                	mov    %esi,%ebx
  800c88:	80 fb 19             	cmp    $0x19,%bl
  800c8b:	77 29                	ja     800cb6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c8d:	0f be d2             	movsbl %dl,%edx
  800c90:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c93:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c96:	7d 30                	jge    800cc8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c98:	83 c1 01             	add    $0x1,%ecx
  800c9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c9f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ca1:	0f b6 11             	movzbl (%ecx),%edx
  800ca4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ca7:	89 f3                	mov    %esi,%ebx
  800ca9:	80 fb 09             	cmp    $0x9,%bl
  800cac:	77 d5                	ja     800c83 <strtol+0x80>
			dig = *s - '0';
  800cae:	0f be d2             	movsbl %dl,%edx
  800cb1:	83 ea 30             	sub    $0x30,%edx
  800cb4:	eb dd                	jmp    800c93 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800cb6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cb9:	89 f3                	mov    %esi,%ebx
  800cbb:	80 fb 19             	cmp    $0x19,%bl
  800cbe:	77 08                	ja     800cc8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800cc0:	0f be d2             	movsbl %dl,%edx
  800cc3:	83 ea 37             	sub    $0x37,%edx
  800cc6:	eb cb                	jmp    800c93 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccc:	74 05                	je     800cd3 <strtol+0xd0>
		*endptr = (char *) s;
  800cce:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cd3:	89 c2                	mov    %eax,%edx
  800cd5:	f7 da                	neg    %edx
  800cd7:	85 ff                	test   %edi,%edi
  800cd9:	0f 45 c2             	cmovne %edx,%eax
}
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf2:	89 c3                	mov    %eax,%ebx
  800cf4:	89 c7                	mov    %eax,%edi
  800cf6:	89 c6                	mov    %eax,%esi
  800cf8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <sys_cgetc>:

int
sys_cgetc(void)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d05:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  800d0f:	89 d1                	mov    %edx,%ecx
  800d11:	89 d3                	mov    %edx,%ebx
  800d13:	89 d7                	mov    %edx,%edi
  800d15:	89 d6                	mov    %edx,%esi
  800d17:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d34:	89 cb                	mov    %ecx,%ebx
  800d36:	89 cf                	mov    %ecx,%edi
  800d38:	89 ce                	mov    %ecx,%esi
  800d3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	7f 08                	jg     800d48 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d48:	83 ec 0c             	sub    $0xc,%esp
  800d4b:	50                   	push   %eax
  800d4c:	6a 03                	push   $0x3
  800d4e:	68 ff 2c 80 00       	push   $0x802cff
  800d53:	6a 23                	push   $0x23
  800d55:	68 1c 2d 80 00       	push   $0x802d1c
  800d5a:	e8 cd f4 ff ff       	call   80022c <_panic>

00800d5f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d65:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d6f:	89 d1                	mov    %edx,%ecx
  800d71:	89 d3                	mov    %edx,%ebx
  800d73:	89 d7                	mov    %edx,%edi
  800d75:	89 d6                	mov    %edx,%esi
  800d77:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <sys_yield>:

void
sys_yield(void)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d84:	ba 00 00 00 00       	mov    $0x0,%edx
  800d89:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d8e:	89 d1                	mov    %edx,%ecx
  800d90:	89 d3                	mov    %edx,%ebx
  800d92:	89 d7                	mov    %edx,%edi
  800d94:	89 d6                	mov    %edx,%esi
  800d96:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da6:	be 00 00 00 00       	mov    $0x0,%esi
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db1:	b8 04 00 00 00       	mov    $0x4,%eax
  800db6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db9:	89 f7                	mov    %esi,%edi
  800dbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	7f 08                	jg     800dc9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc9:	83 ec 0c             	sub    $0xc,%esp
  800dcc:	50                   	push   %eax
  800dcd:	6a 04                	push   $0x4
  800dcf:	68 ff 2c 80 00       	push   $0x802cff
  800dd4:	6a 23                	push   $0x23
  800dd6:	68 1c 2d 80 00       	push   $0x802d1c
  800ddb:	e8 4c f4 ff ff       	call   80022c <_panic>

00800de0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800def:	b8 05 00 00 00       	mov    $0x5,%eax
  800df4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dfa:	8b 75 18             	mov    0x18(%ebp),%esi
  800dfd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7f 08                	jg     800e0b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	50                   	push   %eax
  800e0f:	6a 05                	push   $0x5
  800e11:	68 ff 2c 80 00       	push   $0x802cff
  800e16:	6a 23                	push   $0x23
  800e18:	68 1c 2d 80 00       	push   $0x802d1c
  800e1d:	e8 0a f4 ff ff       	call   80022c <_panic>

00800e22 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 06 00 00 00       	mov    $0x6,%eax
  800e3b:	89 df                	mov    %ebx,%edi
  800e3d:	89 de                	mov    %ebx,%esi
  800e3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7f 08                	jg     800e4d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	6a 06                	push   $0x6
  800e53:	68 ff 2c 80 00       	push   $0x802cff
  800e58:	6a 23                	push   $0x23
  800e5a:	68 1c 2d 80 00       	push   $0x802d1c
  800e5f:	e8 c8 f3 ff ff       	call   80022c <_panic>

00800e64 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e78:	b8 08 00 00 00       	mov    $0x8,%eax
  800e7d:	89 df                	mov    %ebx,%edi
  800e7f:	89 de                	mov    %ebx,%esi
  800e81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 08                	push   $0x8
  800e95:	68 ff 2c 80 00       	push   $0x802cff
  800e9a:	6a 23                	push   $0x23
  800e9c:	68 1c 2d 80 00       	push   $0x802d1c
  800ea1:	e8 86 f3 ff ff       	call   80022c <_panic>

00800ea6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eba:	b8 09 00 00 00       	mov    $0x9,%eax
  800ebf:	89 df                	mov    %ebx,%edi
  800ec1:	89 de                	mov    %ebx,%esi
  800ec3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	7f 08                	jg     800ed1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	50                   	push   %eax
  800ed5:	6a 09                	push   $0x9
  800ed7:	68 ff 2c 80 00       	push   $0x802cff
  800edc:	6a 23                	push   $0x23
  800ede:	68 1c 2d 80 00       	push   $0x802d1c
  800ee3:	e8 44 f3 ff ff       	call   80022c <_panic>

00800ee8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
  800eee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f01:	89 df                	mov    %ebx,%edi
  800f03:	89 de                	mov    %ebx,%esi
  800f05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f07:	85 c0                	test   %eax,%eax
  800f09:	7f 08                	jg     800f13 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	50                   	push   %eax
  800f17:	6a 0a                	push   $0xa
  800f19:	68 ff 2c 80 00       	push   $0x802cff
  800f1e:	6a 23                	push   $0x23
  800f20:	68 1c 2d 80 00       	push   $0x802d1c
  800f25:	e8 02 f3 ff ff       	call   80022c <_panic>

00800f2a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f36:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f3b:	be 00 00 00 00       	mov    $0x0,%esi
  800f40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f46:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	57                   	push   %edi
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
  800f53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f63:	89 cb                	mov    %ecx,%ebx
  800f65:	89 cf                	mov    %ecx,%edi
  800f67:	89 ce                	mov    %ecx,%esi
  800f69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	7f 08                	jg     800f77 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f77:	83 ec 0c             	sub    $0xc,%esp
  800f7a:	50                   	push   %eax
  800f7b:	6a 0d                	push   $0xd
  800f7d:	68 ff 2c 80 00       	push   $0x802cff
  800f82:	6a 23                	push   $0x23
  800f84:	68 1c 2d 80 00       	push   $0x802d1c
  800f89:	e8 9e f2 ff ff       	call   80022c <_panic>

00800f8e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f94:	ba 00 00 00 00       	mov    $0x0,%edx
  800f99:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9e:	89 d1                	mov    %edx,%ecx
  800fa0:	89 d3                	mov    %edx,%ebx
  800fa2:	89 d7                	mov    %edx,%edi
  800fa4:	89 d6                	mov    %edx,%esi
  800fa6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 1c             	sub    $0x1c,%esp
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800fb9:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800fbb:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800fbe:	89 d8                	mov    %ebx,%eax
  800fc0:	c1 e8 0c             	shr    $0xc,%eax
  800fc3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800fcd:	e8 8d fd ff ff       	call   800d5f <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800fd2:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800fd8:	74 73                	je     80104d <pgfault+0xa0>
  800fda:	89 c6                	mov    %eax,%esi
  800fdc:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800fe3:	74 68                	je     80104d <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800fe5:	83 ec 04             	sub    $0x4,%esp
  800fe8:	6a 07                	push   $0x7
  800fea:	68 00 f0 7f 00       	push   $0x7ff000
  800fef:	50                   	push   %eax
  800ff0:	e8 a8 fd ff ff       	call   800d9d <sys_page_alloc>
  800ff5:	83 c4 10             	add    $0x10,%esp
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	75 65                	jne    801061 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800ffc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801002:	83 ec 04             	sub    $0x4,%esp
  801005:	68 00 10 00 00       	push   $0x1000
  80100a:	53                   	push   %ebx
  80100b:	68 00 f0 7f 00       	push   $0x7ff000
  801010:	e8 85 fb ff ff       	call   800b9a <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801015:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80101c:	53                   	push   %ebx
  80101d:	56                   	push   %esi
  80101e:	68 00 f0 7f 00       	push   $0x7ff000
  801023:	56                   	push   %esi
  801024:	e8 b7 fd ff ff       	call   800de0 <sys_page_map>
  801029:	83 c4 20             	add    $0x20,%esp
  80102c:	85 c0                	test   %eax,%eax
  80102e:	75 43                	jne    801073 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	68 00 f0 7f 00       	push   $0x7ff000
  801038:	56                   	push   %esi
  801039:	e8 e4 fd ff ff       	call   800e22 <sys_page_unmap>
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	85 c0                	test   %eax,%eax
  801043:	75 40                	jne    801085 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  801045:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  80104d:	83 ec 04             	sub    $0x4,%esp
  801050:	68 2a 2d 80 00       	push   $0x802d2a
  801055:	6a 1f                	push   $0x1f
  801057:	68 48 2d 80 00       	push   $0x802d48
  80105c:	e8 cb f1 ff ff       	call   80022c <_panic>
	    panic("pgfault: %e", r);
  801061:	50                   	push   %eax
  801062:	68 53 2d 80 00       	push   $0x802d53
  801067:	6a 2a                	push   $0x2a
  801069:	68 48 2d 80 00       	push   $0x802d48
  80106e:	e8 b9 f1 ff ff       	call   80022c <_panic>
	    panic("pgfault: %e", r);
  801073:	50                   	push   %eax
  801074:	68 53 2d 80 00       	push   $0x802d53
  801079:	6a 2e                	push   $0x2e
  80107b:	68 48 2d 80 00       	push   $0x802d48
  801080:	e8 a7 f1 ff ff       	call   80022c <_panic>
	    panic("pgfault: %e", r);
  801085:	50                   	push   %eax
  801086:	68 53 2d 80 00       	push   $0x802d53
  80108b:	6a 31                	push   $0x31
  80108d:	68 48 2d 80 00       	push   $0x802d48
  801092:	e8 95 f1 ff ff       	call   80022c <_panic>

00801097 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
  80109d:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  8010a0:	68 ad 0f 80 00       	push   $0x800fad
  8010a5:	e8 dd 13 00 00       	call   802487 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8010af:	cd 30                	int    $0x30
  8010b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	78 2b                	js     8010e9 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010be:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010c7:	0f 85 b5 00 00 00    	jne    801182 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  8010cd:	e8 8d fc ff ff       	call   800d5f <sys_getenvid>
  8010d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010d7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010df:	a3 20 44 80 00       	mov    %eax,0x804420
	    return 0;
  8010e4:	e9 8c 01 00 00       	jmp    801275 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  8010e9:	50                   	push   %eax
  8010ea:	68 5f 2d 80 00       	push   $0x802d5f
  8010ef:	6a 77                	push   $0x77
  8010f1:	68 48 2d 80 00       	push   $0x802d48
  8010f6:	e8 31 f1 ff ff       	call   80022c <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  8010fb:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801102:	83 ec 0c             	sub    $0xc,%esp
  801105:	25 07 0e 00 00       	and    $0xe07,%eax
  80110a:	50                   	push   %eax
  80110b:	57                   	push   %edi
  80110c:	ff 75 e0             	pushl  -0x20(%ebp)
  80110f:	57                   	push   %edi
  801110:	ff 75 e4             	pushl  -0x1c(%ebp)
  801113:	e8 c8 fc ff ff       	call   800de0 <sys_page_map>
  801118:	83 c4 20             	add    $0x20,%esp
  80111b:	85 c0                	test   %eax,%eax
  80111d:	74 51                	je     801170 <fork+0xd9>
           panic("duppage: %e", r);
  80111f:	50                   	push   %eax
  801120:	68 6f 2d 80 00       	push   $0x802d6f
  801125:	6a 4a                	push   $0x4a
  801127:	68 48 2d 80 00       	push   $0x802d48
  80112c:	e8 fb f0 ff ff       	call   80022c <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	68 05 08 00 00       	push   $0x805
  801139:	57                   	push   %edi
  80113a:	ff 75 e0             	pushl  -0x20(%ebp)
  80113d:	57                   	push   %edi
  80113e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801141:	e8 9a fc ff ff       	call   800de0 <sys_page_map>
  801146:	83 c4 20             	add    $0x20,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	0f 85 bc 00 00 00    	jne    80120d <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801151:	83 ec 0c             	sub    $0xc,%esp
  801154:	68 05 08 00 00       	push   $0x805
  801159:	57                   	push   %edi
  80115a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80115d:	50                   	push   %eax
  80115e:	57                   	push   %edi
  80115f:	50                   	push   %eax
  801160:	e8 7b fc ff ff       	call   800de0 <sys_page_map>
  801165:	83 c4 20             	add    $0x20,%esp
  801168:	85 c0                	test   %eax,%eax
  80116a:	0f 85 af 00 00 00    	jne    80121f <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801170:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801176:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80117c:	0f 84 af 00 00 00    	je     801231 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801182:	89 d8                	mov    %ebx,%eax
  801184:	c1 e8 16             	shr    $0x16,%eax
  801187:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80118e:	a8 01                	test   $0x1,%al
  801190:	74 de                	je     801170 <fork+0xd9>
  801192:	89 de                	mov    %ebx,%esi
  801194:	c1 ee 0c             	shr    $0xc,%esi
  801197:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80119e:	a8 01                	test   $0x1,%al
  8011a0:	74 ce                	je     801170 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  8011a2:	e8 b8 fb ff ff       	call   800d5f <sys_getenvid>
  8011a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  8011aa:	89 f7                	mov    %esi,%edi
  8011ac:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8011af:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011b6:	f6 c4 04             	test   $0x4,%ah
  8011b9:	0f 85 3c ff ff ff    	jne    8010fb <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8011bf:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011c6:	a8 02                	test   $0x2,%al
  8011c8:	0f 85 63 ff ff ff    	jne    801131 <fork+0x9a>
  8011ce:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011d5:	f6 c4 08             	test   $0x8,%ah
  8011d8:	0f 85 53 ff ff ff    	jne    801131 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	6a 05                	push   $0x5
  8011e3:	57                   	push   %edi
  8011e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8011e7:	57                   	push   %edi
  8011e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011eb:	e8 f0 fb ff ff       	call   800de0 <sys_page_map>
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	0f 84 75 ff ff ff    	je     801170 <fork+0xd9>
	        panic("duppage: %e", r);
  8011fb:	50                   	push   %eax
  8011fc:	68 6f 2d 80 00       	push   $0x802d6f
  801201:	6a 55                	push   $0x55
  801203:	68 48 2d 80 00       	push   $0x802d48
  801208:	e8 1f f0 ff ff       	call   80022c <_panic>
	        panic("duppage: %e", r);
  80120d:	50                   	push   %eax
  80120e:	68 6f 2d 80 00       	push   $0x802d6f
  801213:	6a 4e                	push   $0x4e
  801215:	68 48 2d 80 00       	push   $0x802d48
  80121a:	e8 0d f0 ff ff       	call   80022c <_panic>
	        panic("duppage: %e", r);
  80121f:	50                   	push   %eax
  801220:	68 6f 2d 80 00       	push   $0x802d6f
  801225:	6a 51                	push   $0x51
  801227:	68 48 2d 80 00       	push   $0x802d48
  80122c:	e8 fb ef ff ff       	call   80022c <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	6a 07                	push   $0x7
  801236:	68 00 f0 bf ee       	push   $0xeebff000
  80123b:	ff 75 dc             	pushl  -0x24(%ebp)
  80123e:	e8 5a fb ff ff       	call   800d9d <sys_page_alloc>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	75 36                	jne    801280 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	68 00 25 80 00       	push   $0x802500
  801252:	ff 75 dc             	pushl  -0x24(%ebp)
  801255:	e8 8e fc ff ff       	call   800ee8 <sys_env_set_pgfault_upcall>
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	85 c0                	test   %eax,%eax
  80125f:	75 34                	jne    801295 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	6a 02                	push   $0x2
  801266:	ff 75 dc             	pushl  -0x24(%ebp)
  801269:	e8 f6 fb ff ff       	call   800e64 <sys_env_set_status>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	75 35                	jne    8012aa <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    
	    panic("fork: %e", r);
  801280:	50                   	push   %eax
  801281:	68 66 2d 80 00       	push   $0x802d66
  801286:	68 8a 00 00 00       	push   $0x8a
  80128b:	68 48 2d 80 00       	push   $0x802d48
  801290:	e8 97 ef ff ff       	call   80022c <_panic>
	    panic("fork: %e", r);
  801295:	50                   	push   %eax
  801296:	68 66 2d 80 00       	push   $0x802d66
  80129b:	68 8d 00 00 00       	push   $0x8d
  8012a0:	68 48 2d 80 00       	push   $0x802d48
  8012a5:	e8 82 ef ff ff       	call   80022c <_panic>
	    panic("fork: %e", r);
  8012aa:	50                   	push   %eax
  8012ab:	68 66 2d 80 00       	push   $0x802d66
  8012b0:	68 92 00 00 00       	push   $0x92
  8012b5:	68 48 2d 80 00       	push   $0x802d48
  8012ba:	e8 6d ef ff ff       	call   80022c <_panic>

008012bf <sfork>:

// Challenge!
int
sfork(void)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012c5:	68 7b 2d 80 00       	push   $0x802d7b
  8012ca:	68 9b 00 00 00       	push   $0x9b
  8012cf:	68 48 2d 80 00       	push   $0x802d48
  8012d4:	e8 53 ef ff ff       	call   80022c <_panic>

008012d9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	05 00 00 00 30       	add    $0x30000000,%eax
  8012e4:	c1 e8 0c             	shr    $0xc,%eax
}
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    

008012e9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012f9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80130b:	89 c2                	mov    %eax,%edx
  80130d:	c1 ea 16             	shr    $0x16,%edx
  801310:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801317:	f6 c2 01             	test   $0x1,%dl
  80131a:	74 2a                	je     801346 <fd_alloc+0x46>
  80131c:	89 c2                	mov    %eax,%edx
  80131e:	c1 ea 0c             	shr    $0xc,%edx
  801321:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801328:	f6 c2 01             	test   $0x1,%dl
  80132b:	74 19                	je     801346 <fd_alloc+0x46>
  80132d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801332:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801337:	75 d2                	jne    80130b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801339:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80133f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801344:	eb 07                	jmp    80134d <fd_alloc+0x4d>
			*fd_store = fd;
  801346:	89 01                	mov    %eax,(%ecx)
			return 0;
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    

0080134f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801355:	83 f8 1f             	cmp    $0x1f,%eax
  801358:	77 36                	ja     801390 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80135a:	c1 e0 0c             	shl    $0xc,%eax
  80135d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801362:	89 c2                	mov    %eax,%edx
  801364:	c1 ea 16             	shr    $0x16,%edx
  801367:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136e:	f6 c2 01             	test   $0x1,%dl
  801371:	74 24                	je     801397 <fd_lookup+0x48>
  801373:	89 c2                	mov    %eax,%edx
  801375:	c1 ea 0c             	shr    $0xc,%edx
  801378:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80137f:	f6 c2 01             	test   $0x1,%dl
  801382:	74 1a                	je     80139e <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801384:	8b 55 0c             	mov    0xc(%ebp),%edx
  801387:	89 02                	mov    %eax,(%edx)
	return 0;
  801389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    
		return -E_INVAL;
  801390:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801395:	eb f7                	jmp    80138e <fd_lookup+0x3f>
		return -E_INVAL;
  801397:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139c:	eb f0                	jmp    80138e <fd_lookup+0x3f>
  80139e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a3:	eb e9                	jmp    80138e <fd_lookup+0x3f>

008013a5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ae:	ba 10 2e 80 00       	mov    $0x802e10,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013b3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013b8:	39 08                	cmp    %ecx,(%eax)
  8013ba:	74 33                	je     8013ef <dev_lookup+0x4a>
  8013bc:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013bf:	8b 02                	mov    (%edx),%eax
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	75 f3                	jne    8013b8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013c5:	a1 20 44 80 00       	mov    0x804420,%eax
  8013ca:	8b 40 48             	mov    0x48(%eax),%eax
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	51                   	push   %ecx
  8013d1:	50                   	push   %eax
  8013d2:	68 94 2d 80 00       	push   $0x802d94
  8013d7:	e8 2b ef ff ff       	call   800307 <cprintf>
	*dev = 0;
  8013dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013e5:	83 c4 10             	add    $0x10,%esp
  8013e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    
			*dev = devtab[i];
  8013ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f9:	eb f2                	jmp    8013ed <dev_lookup+0x48>

008013fb <fd_close>:
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	57                   	push   %edi
  8013ff:	56                   	push   %esi
  801400:	53                   	push   %ebx
  801401:	83 ec 1c             	sub    $0x1c,%esp
  801404:	8b 75 08             	mov    0x8(%ebp),%esi
  801407:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80140a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80140d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801414:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801417:	50                   	push   %eax
  801418:	e8 32 ff ff ff       	call   80134f <fd_lookup>
  80141d:	89 c3                	mov    %eax,%ebx
  80141f:	83 c4 08             	add    $0x8,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	78 05                	js     80142b <fd_close+0x30>
	    || fd != fd2)
  801426:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801429:	74 16                	je     801441 <fd_close+0x46>
		return (must_exist ? r : 0);
  80142b:	89 f8                	mov    %edi,%eax
  80142d:	84 c0                	test   %al,%al
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
  801434:	0f 44 d8             	cmove  %eax,%ebx
}
  801437:	89 d8                	mov    %ebx,%eax
  801439:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801441:	83 ec 08             	sub    $0x8,%esp
  801444:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	ff 36                	pushl  (%esi)
  80144a:	e8 56 ff ff ff       	call   8013a5 <dev_lookup>
  80144f:	89 c3                	mov    %eax,%ebx
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	78 15                	js     80146d <fd_close+0x72>
		if (dev->dev_close)
  801458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145b:	8b 40 10             	mov    0x10(%eax),%eax
  80145e:	85 c0                	test   %eax,%eax
  801460:	74 1b                	je     80147d <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801462:	83 ec 0c             	sub    $0xc,%esp
  801465:	56                   	push   %esi
  801466:	ff d0                	call   *%eax
  801468:	89 c3                	mov    %eax,%ebx
  80146a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	56                   	push   %esi
  801471:	6a 00                	push   $0x0
  801473:	e8 aa f9 ff ff       	call   800e22 <sys_page_unmap>
	return r;
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	eb ba                	jmp    801437 <fd_close+0x3c>
			r = 0;
  80147d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801482:	eb e9                	jmp    80146d <fd_close+0x72>

00801484 <close>:

int
close(int fdnum)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148d:	50                   	push   %eax
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	e8 b9 fe ff ff       	call   80134f <fd_lookup>
  801496:	83 c4 08             	add    $0x8,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 10                	js     8014ad <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	6a 01                	push   $0x1
  8014a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a5:	e8 51 ff ff ff       	call   8013fb <fd_close>
  8014aa:	83 c4 10             	add    $0x10,%esp
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <close_all>:

void
close_all(void)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	53                   	push   %ebx
  8014b3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	53                   	push   %ebx
  8014bf:	e8 c0 ff ff ff       	call   801484 <close>
	for (i = 0; i < MAXFD; i++)
  8014c4:	83 c3 01             	add    $0x1,%ebx
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	83 fb 20             	cmp    $0x20,%ebx
  8014cd:	75 ec                	jne    8014bb <close_all+0xc>
}
  8014cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	57                   	push   %edi
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 08             	pushl  0x8(%ebp)
  8014e4:	e8 66 fe ff ff       	call   80134f <fd_lookup>
  8014e9:	89 c3                	mov    %eax,%ebx
  8014eb:	83 c4 08             	add    $0x8,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	0f 88 81 00 00 00    	js     801577 <dup+0xa3>
		return r;
	close(newfdnum);
  8014f6:	83 ec 0c             	sub    $0xc,%esp
  8014f9:	ff 75 0c             	pushl  0xc(%ebp)
  8014fc:	e8 83 ff ff ff       	call   801484 <close>

	newfd = INDEX2FD(newfdnum);
  801501:	8b 75 0c             	mov    0xc(%ebp),%esi
  801504:	c1 e6 0c             	shl    $0xc,%esi
  801507:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80150d:	83 c4 04             	add    $0x4,%esp
  801510:	ff 75 e4             	pushl  -0x1c(%ebp)
  801513:	e8 d1 fd ff ff       	call   8012e9 <fd2data>
  801518:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80151a:	89 34 24             	mov    %esi,(%esp)
  80151d:	e8 c7 fd ff ff       	call   8012e9 <fd2data>
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801527:	89 d8                	mov    %ebx,%eax
  801529:	c1 e8 16             	shr    $0x16,%eax
  80152c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801533:	a8 01                	test   $0x1,%al
  801535:	74 11                	je     801548 <dup+0x74>
  801537:	89 d8                	mov    %ebx,%eax
  801539:	c1 e8 0c             	shr    $0xc,%eax
  80153c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801543:	f6 c2 01             	test   $0x1,%dl
  801546:	75 39                	jne    801581 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801548:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80154b:	89 d0                	mov    %edx,%eax
  80154d:	c1 e8 0c             	shr    $0xc,%eax
  801550:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	25 07 0e 00 00       	and    $0xe07,%eax
  80155f:	50                   	push   %eax
  801560:	56                   	push   %esi
  801561:	6a 00                	push   $0x0
  801563:	52                   	push   %edx
  801564:	6a 00                	push   $0x0
  801566:	e8 75 f8 ff ff       	call   800de0 <sys_page_map>
  80156b:	89 c3                	mov    %eax,%ebx
  80156d:	83 c4 20             	add    $0x20,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 31                	js     8015a5 <dup+0xd1>
		goto err;

	return newfdnum;
  801574:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801577:	89 d8                	mov    %ebx,%eax
  801579:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5f                   	pop    %edi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801581:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801588:	83 ec 0c             	sub    $0xc,%esp
  80158b:	25 07 0e 00 00       	and    $0xe07,%eax
  801590:	50                   	push   %eax
  801591:	57                   	push   %edi
  801592:	6a 00                	push   $0x0
  801594:	53                   	push   %ebx
  801595:	6a 00                	push   $0x0
  801597:	e8 44 f8 ff ff       	call   800de0 <sys_page_map>
  80159c:	89 c3                	mov    %eax,%ebx
  80159e:	83 c4 20             	add    $0x20,%esp
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	79 a3                	jns    801548 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	56                   	push   %esi
  8015a9:	6a 00                	push   $0x0
  8015ab:	e8 72 f8 ff ff       	call   800e22 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015b0:	83 c4 08             	add    $0x8,%esp
  8015b3:	57                   	push   %edi
  8015b4:	6a 00                	push   $0x0
  8015b6:	e8 67 f8 ff ff       	call   800e22 <sys_page_unmap>
	return r;
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	eb b7                	jmp    801577 <dup+0xa3>

008015c0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	53                   	push   %ebx
  8015c4:	83 ec 14             	sub    $0x14,%esp
  8015c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015cd:	50                   	push   %eax
  8015ce:	53                   	push   %ebx
  8015cf:	e8 7b fd ff ff       	call   80134f <fd_lookup>
  8015d4:	83 c4 08             	add    $0x8,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 3f                	js     80161a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e1:	50                   	push   %eax
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e5:	ff 30                	pushl  (%eax)
  8015e7:	e8 b9 fd ff ff       	call   8013a5 <dev_lookup>
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 27                	js     80161a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f6:	8b 42 08             	mov    0x8(%edx),%eax
  8015f9:	83 e0 03             	and    $0x3,%eax
  8015fc:	83 f8 01             	cmp    $0x1,%eax
  8015ff:	74 1e                	je     80161f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801604:	8b 40 08             	mov    0x8(%eax),%eax
  801607:	85 c0                	test   %eax,%eax
  801609:	74 35                	je     801640 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	ff 75 10             	pushl  0x10(%ebp)
  801611:	ff 75 0c             	pushl  0xc(%ebp)
  801614:	52                   	push   %edx
  801615:	ff d0                	call   *%eax
  801617:	83 c4 10             	add    $0x10,%esp
}
  80161a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80161f:	a1 20 44 80 00       	mov    0x804420,%eax
  801624:	8b 40 48             	mov    0x48(%eax),%eax
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	53                   	push   %ebx
  80162b:	50                   	push   %eax
  80162c:	68 d5 2d 80 00       	push   $0x802dd5
  801631:	e8 d1 ec ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163e:	eb da                	jmp    80161a <read+0x5a>
		return -E_NOT_SUPP;
  801640:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801645:	eb d3                	jmp    80161a <read+0x5a>

00801647 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	57                   	push   %edi
  80164b:	56                   	push   %esi
  80164c:	53                   	push   %ebx
  80164d:	83 ec 0c             	sub    $0xc,%esp
  801650:	8b 7d 08             	mov    0x8(%ebp),%edi
  801653:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801656:	bb 00 00 00 00       	mov    $0x0,%ebx
  80165b:	39 f3                	cmp    %esi,%ebx
  80165d:	73 25                	jae    801684 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	89 f0                	mov    %esi,%eax
  801664:	29 d8                	sub    %ebx,%eax
  801666:	50                   	push   %eax
  801667:	89 d8                	mov    %ebx,%eax
  801669:	03 45 0c             	add    0xc(%ebp),%eax
  80166c:	50                   	push   %eax
  80166d:	57                   	push   %edi
  80166e:	e8 4d ff ff ff       	call   8015c0 <read>
		if (m < 0)
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	78 08                	js     801682 <readn+0x3b>
			return m;
		if (m == 0)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	74 06                	je     801684 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80167e:	01 c3                	add    %eax,%ebx
  801680:	eb d9                	jmp    80165b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801682:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801684:	89 d8                	mov    %ebx,%eax
  801686:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801689:	5b                   	pop    %ebx
  80168a:	5e                   	pop    %esi
  80168b:	5f                   	pop    %edi
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	53                   	push   %ebx
  801692:	83 ec 14             	sub    $0x14,%esp
  801695:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801698:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	53                   	push   %ebx
  80169d:	e8 ad fc ff ff       	call   80134f <fd_lookup>
  8016a2:	83 c4 08             	add    $0x8,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 3a                	js     8016e3 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016af:	50                   	push   %eax
  8016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b3:	ff 30                	pushl  (%eax)
  8016b5:	e8 eb fc ff ff       	call   8013a5 <dev_lookup>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 22                	js     8016e3 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c8:	74 1e                	je     8016e8 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8016d0:	85 d2                	test   %edx,%edx
  8016d2:	74 35                	je     801709 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	ff 75 10             	pushl  0x10(%ebp)
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	50                   	push   %eax
  8016de:	ff d2                	call   *%edx
  8016e0:	83 c4 10             	add    $0x10,%esp
}
  8016e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016e8:	a1 20 44 80 00       	mov    0x804420,%eax
  8016ed:	8b 40 48             	mov    0x48(%eax),%eax
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	53                   	push   %ebx
  8016f4:	50                   	push   %eax
  8016f5:	68 f1 2d 80 00       	push   $0x802df1
  8016fa:	e8 08 ec ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801707:	eb da                	jmp    8016e3 <write+0x55>
		return -E_NOT_SUPP;
  801709:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170e:	eb d3                	jmp    8016e3 <write+0x55>

00801710 <seek>:

int
seek(int fdnum, off_t offset)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801716:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801719:	50                   	push   %eax
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	e8 2d fc ff ff       	call   80134f <fd_lookup>
  801722:	83 c4 08             	add    $0x8,%esp
  801725:	85 c0                	test   %eax,%eax
  801727:	78 0e                	js     801737 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	53                   	push   %ebx
  80173d:	83 ec 14             	sub    $0x14,%esp
  801740:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801743:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801746:	50                   	push   %eax
  801747:	53                   	push   %ebx
  801748:	e8 02 fc ff ff       	call   80134f <fd_lookup>
  80174d:	83 c4 08             	add    $0x8,%esp
  801750:	85 c0                	test   %eax,%eax
  801752:	78 37                	js     80178b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175a:	50                   	push   %eax
  80175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175e:	ff 30                	pushl  (%eax)
  801760:	e8 40 fc ff ff       	call   8013a5 <dev_lookup>
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	85 c0                	test   %eax,%eax
  80176a:	78 1f                	js     80178b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801773:	74 1b                	je     801790 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801775:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801778:	8b 52 18             	mov    0x18(%edx),%edx
  80177b:	85 d2                	test   %edx,%edx
  80177d:	74 32                	je     8017b1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	50                   	push   %eax
  801786:	ff d2                	call   *%edx
  801788:	83 c4 10             	add    $0x10,%esp
}
  80178b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801790:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801795:	8b 40 48             	mov    0x48(%eax),%eax
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	53                   	push   %ebx
  80179c:	50                   	push   %eax
  80179d:	68 b4 2d 80 00       	push   $0x802db4
  8017a2:	e8 60 eb ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017af:	eb da                	jmp    80178b <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017b6:	eb d3                	jmp    80178b <ftruncate+0x52>

008017b8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 14             	sub    $0x14,%esp
  8017bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c5:	50                   	push   %eax
  8017c6:	ff 75 08             	pushl  0x8(%ebp)
  8017c9:	e8 81 fb ff ff       	call   80134f <fd_lookup>
  8017ce:	83 c4 08             	add    $0x8,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 4b                	js     801820 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017db:	50                   	push   %eax
  8017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017df:	ff 30                	pushl  (%eax)
  8017e1:	e8 bf fb ff ff       	call   8013a5 <dev_lookup>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	78 33                	js     801820 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017f4:	74 2f                	je     801825 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017f6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017f9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801800:	00 00 00 
	stat->st_isdir = 0;
  801803:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80180a:	00 00 00 
	stat->st_dev = dev;
  80180d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	53                   	push   %ebx
  801817:	ff 75 f0             	pushl  -0x10(%ebp)
  80181a:	ff 50 14             	call   *0x14(%eax)
  80181d:	83 c4 10             	add    $0x10,%esp
}
  801820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801823:	c9                   	leave  
  801824:	c3                   	ret    
		return -E_NOT_SUPP;
  801825:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182a:	eb f4                	jmp    801820 <fstat+0x68>

0080182c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	6a 00                	push   $0x0
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	e8 26 02 00 00       	call   801a64 <open>
  80183e:	89 c3                	mov    %eax,%ebx
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	85 c0                	test   %eax,%eax
  801845:	78 1b                	js     801862 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	50                   	push   %eax
  80184e:	e8 65 ff ff ff       	call   8017b8 <fstat>
  801853:	89 c6                	mov    %eax,%esi
	close(fd);
  801855:	89 1c 24             	mov    %ebx,(%esp)
  801858:	e8 27 fc ff ff       	call   801484 <close>
	return r;
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	89 f3                	mov    %esi,%ebx
}
  801862:	89 d8                	mov    %ebx,%eax
  801864:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5d                   	pop    %ebp
  80186a:	c3                   	ret    

0080186b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	56                   	push   %esi
  80186f:	53                   	push   %ebx
  801870:	89 c6                	mov    %eax,%esi
  801872:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801874:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80187b:	74 27                	je     8018a4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80187d:	6a 07                	push   $0x7
  80187f:	68 00 50 80 00       	push   $0x805000
  801884:	56                   	push   %esi
  801885:	ff 35 00 40 80 00    	pushl  0x804000
  80188b:	e8 ff 0c 00 00       	call   80258f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801890:	83 c4 0c             	add    $0xc,%esp
  801893:	6a 00                	push   $0x0
  801895:	53                   	push   %ebx
  801896:	6a 00                	push   $0x0
  801898:	e8 89 0c 00 00       	call   802526 <ipc_recv>
}
  80189d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a0:	5b                   	pop    %ebx
  8018a1:	5e                   	pop    %esi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018a4:	83 ec 0c             	sub    $0xc,%esp
  8018a7:	6a 01                	push   $0x1
  8018a9:	e8 3a 0d 00 00       	call   8025e8 <ipc_find_env>
  8018ae:	a3 00 40 80 00       	mov    %eax,0x804000
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	eb c5                	jmp    80187d <fsipc+0x12>

008018b8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d6:	b8 02 00 00 00       	mov    $0x2,%eax
  8018db:	e8 8b ff ff ff       	call   80186b <fsipc>
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <devfile_flush>:
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ee:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	b8 06 00 00 00       	mov    $0x6,%eax
  8018fd:	e8 69 ff ff ff       	call   80186b <fsipc>
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <devfile_stat>:
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	53                   	push   %ebx
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8b 40 0c             	mov    0xc(%eax),%eax
  801914:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	b8 05 00 00 00       	mov    $0x5,%eax
  801923:	e8 43 ff ff ff       	call   80186b <fsipc>
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 2c                	js     801958 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	68 00 50 80 00       	push   $0x805000
  801934:	53                   	push   %ebx
  801935:	e8 6a f0 ff ff       	call   8009a4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80193a:	a1 80 50 80 00       	mov    0x805080,%eax
  80193f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801945:	a1 84 50 80 00       	mov    0x805084,%eax
  80194a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801958:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <devfile_write>:
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	53                   	push   %ebx
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	8b 40 0c             	mov    0xc(%eax),%eax
  80196d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801972:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801978:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80197e:	77 30                	ja     8019b0 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	53                   	push   %ebx
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	68 08 50 80 00       	push   $0x805008
  80198c:	e8 a1 f1 ff ff       	call   800b32 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801991:	ba 00 00 00 00       	mov    $0x0,%edx
  801996:	b8 04 00 00 00       	mov    $0x4,%eax
  80199b:	e8 cb fe ff ff       	call   80186b <fsipc>
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 04                	js     8019ab <devfile_write+0x4e>
	assert(r <= n);
  8019a7:	39 d8                	cmp    %ebx,%eax
  8019a9:	77 1e                	ja     8019c9 <devfile_write+0x6c>
}
  8019ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019b0:	68 24 2e 80 00       	push   $0x802e24
  8019b5:	68 54 2e 80 00       	push   $0x802e54
  8019ba:	68 94 00 00 00       	push   $0x94
  8019bf:	68 69 2e 80 00       	push   $0x802e69
  8019c4:	e8 63 e8 ff ff       	call   80022c <_panic>
	assert(r <= n);
  8019c9:	68 74 2e 80 00       	push   $0x802e74
  8019ce:	68 54 2e 80 00       	push   $0x802e54
  8019d3:	68 98 00 00 00       	push   $0x98
  8019d8:	68 69 2e 80 00       	push   $0x802e69
  8019dd:	e8 4a e8 ff ff       	call   80022c <_panic>

008019e2 <devfile_read>:
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019f5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801a00:	b8 03 00 00 00       	mov    $0x3,%eax
  801a05:	e8 61 fe ff ff       	call   80186b <fsipc>
  801a0a:	89 c3                	mov    %eax,%ebx
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	78 1f                	js     801a2f <devfile_read+0x4d>
	assert(r <= n);
  801a10:	39 f0                	cmp    %esi,%eax
  801a12:	77 24                	ja     801a38 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a14:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a19:	7f 33                	jg     801a4e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	50                   	push   %eax
  801a1f:	68 00 50 80 00       	push   $0x805000
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	e8 06 f1 ff ff       	call   800b32 <memmove>
	return r;
  801a2c:	83 c4 10             	add    $0x10,%esp
}
  801a2f:	89 d8                	mov    %ebx,%eax
  801a31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a34:	5b                   	pop    %ebx
  801a35:	5e                   	pop    %esi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    
	assert(r <= n);
  801a38:	68 74 2e 80 00       	push   $0x802e74
  801a3d:	68 54 2e 80 00       	push   $0x802e54
  801a42:	6a 7c                	push   $0x7c
  801a44:	68 69 2e 80 00       	push   $0x802e69
  801a49:	e8 de e7 ff ff       	call   80022c <_panic>
	assert(r <= PGSIZE);
  801a4e:	68 7b 2e 80 00       	push   $0x802e7b
  801a53:	68 54 2e 80 00       	push   $0x802e54
  801a58:	6a 7d                	push   $0x7d
  801a5a:	68 69 2e 80 00       	push   $0x802e69
  801a5f:	e8 c8 e7 ff ff       	call   80022c <_panic>

00801a64 <open>:
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	56                   	push   %esi
  801a68:	53                   	push   %ebx
  801a69:	83 ec 1c             	sub    $0x1c,%esp
  801a6c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a6f:	56                   	push   %esi
  801a70:	e8 f8 ee ff ff       	call   80096d <strlen>
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a7d:	7f 6c                	jg     801aeb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a7f:	83 ec 0c             	sub    $0xc,%esp
  801a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 75 f8 ff ff       	call   801300 <fd_alloc>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 3c                	js     801ad0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	56                   	push   %esi
  801a98:	68 00 50 80 00       	push   $0x805000
  801a9d:	e8 02 ef ff ff       	call   8009a4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aad:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab2:	e8 b4 fd ff ff       	call   80186b <fsipc>
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 19                	js     801ad9 <open+0x75>
	return fd2num(fd);
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac6:	e8 0e f8 ff ff       	call   8012d9 <fd2num>
  801acb:	89 c3                	mov    %eax,%ebx
  801acd:	83 c4 10             	add    $0x10,%esp
}
  801ad0:	89 d8                	mov    %ebx,%eax
  801ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad5:	5b                   	pop    %ebx
  801ad6:	5e                   	pop    %esi
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    
		fd_close(fd, 0);
  801ad9:	83 ec 08             	sub    $0x8,%esp
  801adc:	6a 00                	push   $0x0
  801ade:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae1:	e8 15 f9 ff ff       	call   8013fb <fd_close>
		return r;
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	eb e5                	jmp    801ad0 <open+0x6c>
		return -E_BAD_PATH;
  801aeb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801af0:	eb de                	jmp    801ad0 <open+0x6c>

00801af2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801af8:	ba 00 00 00 00       	mov    $0x0,%edx
  801afd:	b8 08 00 00 00       	mov    $0x8,%eax
  801b02:	e8 64 fd ff ff       	call   80186b <fsipc>
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b11:	83 ec 0c             	sub    $0xc,%esp
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	e8 cd f7 ff ff       	call   8012e9 <fd2data>
  801b1c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b1e:	83 c4 08             	add    $0x8,%esp
  801b21:	68 87 2e 80 00       	push   $0x802e87
  801b26:	53                   	push   %ebx
  801b27:	e8 78 ee ff ff       	call   8009a4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b2c:	8b 46 04             	mov    0x4(%esi),%eax
  801b2f:	2b 06                	sub    (%esi),%eax
  801b31:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b37:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3e:	00 00 00 
	stat->st_dev = &devpipe;
  801b41:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b48:	30 80 00 
	return 0;
}
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    

00801b57 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	53                   	push   %ebx
  801b5b:	83 ec 0c             	sub    $0xc,%esp
  801b5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b61:	53                   	push   %ebx
  801b62:	6a 00                	push   $0x0
  801b64:	e8 b9 f2 ff ff       	call   800e22 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b69:	89 1c 24             	mov    %ebx,(%esp)
  801b6c:	e8 78 f7 ff ff       	call   8012e9 <fd2data>
  801b71:	83 c4 08             	add    $0x8,%esp
  801b74:	50                   	push   %eax
  801b75:	6a 00                	push   $0x0
  801b77:	e8 a6 f2 ff ff       	call   800e22 <sys_page_unmap>
}
  801b7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <_pipeisclosed>:
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	57                   	push   %edi
  801b85:	56                   	push   %esi
  801b86:	53                   	push   %ebx
  801b87:	83 ec 1c             	sub    $0x1c,%esp
  801b8a:	89 c7                	mov    %eax,%edi
  801b8c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b8e:	a1 20 44 80 00       	mov    0x804420,%eax
  801b93:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b96:	83 ec 0c             	sub    $0xc,%esp
  801b99:	57                   	push   %edi
  801b9a:	e8 82 0a 00 00       	call   802621 <pageref>
  801b9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba2:	89 34 24             	mov    %esi,(%esp)
  801ba5:	e8 77 0a 00 00       	call   802621 <pageref>
		nn = thisenv->env_runs;
  801baa:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801bb0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	39 cb                	cmp    %ecx,%ebx
  801bb8:	74 1b                	je     801bd5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bba:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bbd:	75 cf                	jne    801b8e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bbf:	8b 42 58             	mov    0x58(%edx),%eax
  801bc2:	6a 01                	push   $0x1
  801bc4:	50                   	push   %eax
  801bc5:	53                   	push   %ebx
  801bc6:	68 8e 2e 80 00       	push   $0x802e8e
  801bcb:	e8 37 e7 ff ff       	call   800307 <cprintf>
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	eb b9                	jmp    801b8e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bd5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bd8:	0f 94 c0             	sete   %al
  801bdb:	0f b6 c0             	movzbl %al,%eax
}
  801bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5f                   	pop    %edi
  801be4:	5d                   	pop    %ebp
  801be5:	c3                   	ret    

00801be6 <devpipe_write>:
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	57                   	push   %edi
  801bea:	56                   	push   %esi
  801beb:	53                   	push   %ebx
  801bec:	83 ec 28             	sub    $0x28,%esp
  801bef:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bf2:	56                   	push   %esi
  801bf3:	e8 f1 f6 ff ff       	call   8012e9 <fd2data>
  801bf8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  801c02:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c05:	74 4f                	je     801c56 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c07:	8b 43 04             	mov    0x4(%ebx),%eax
  801c0a:	8b 0b                	mov    (%ebx),%ecx
  801c0c:	8d 51 20             	lea    0x20(%ecx),%edx
  801c0f:	39 d0                	cmp    %edx,%eax
  801c11:	72 14                	jb     801c27 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c13:	89 da                	mov    %ebx,%edx
  801c15:	89 f0                	mov    %esi,%eax
  801c17:	e8 65 ff ff ff       	call   801b81 <_pipeisclosed>
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	75 3a                	jne    801c5a <devpipe_write+0x74>
			sys_yield();
  801c20:	e8 59 f1 ff ff       	call   800d7e <sys_yield>
  801c25:	eb e0                	jmp    801c07 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c2a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c2e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c31:	89 c2                	mov    %eax,%edx
  801c33:	c1 fa 1f             	sar    $0x1f,%edx
  801c36:	89 d1                	mov    %edx,%ecx
  801c38:	c1 e9 1b             	shr    $0x1b,%ecx
  801c3b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c3e:	83 e2 1f             	and    $0x1f,%edx
  801c41:	29 ca                	sub    %ecx,%edx
  801c43:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c47:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c4b:	83 c0 01             	add    $0x1,%eax
  801c4e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c51:	83 c7 01             	add    $0x1,%edi
  801c54:	eb ac                	jmp    801c02 <devpipe_write+0x1c>
	return i;
  801c56:	89 f8                	mov    %edi,%eax
  801c58:	eb 05                	jmp    801c5f <devpipe_write+0x79>
				return 0;
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c62:	5b                   	pop    %ebx
  801c63:	5e                   	pop    %esi
  801c64:	5f                   	pop    %edi
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    

00801c67 <devpipe_read>:
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	57                   	push   %edi
  801c6b:	56                   	push   %esi
  801c6c:	53                   	push   %ebx
  801c6d:	83 ec 18             	sub    $0x18,%esp
  801c70:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c73:	57                   	push   %edi
  801c74:	e8 70 f6 ff ff       	call   8012e9 <fd2data>
  801c79:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	be 00 00 00 00       	mov    $0x0,%esi
  801c83:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c86:	74 47                	je     801ccf <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c88:	8b 03                	mov    (%ebx),%eax
  801c8a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c8d:	75 22                	jne    801cb1 <devpipe_read+0x4a>
			if (i > 0)
  801c8f:	85 f6                	test   %esi,%esi
  801c91:	75 14                	jne    801ca7 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c93:	89 da                	mov    %ebx,%edx
  801c95:	89 f8                	mov    %edi,%eax
  801c97:	e8 e5 fe ff ff       	call   801b81 <_pipeisclosed>
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	75 33                	jne    801cd3 <devpipe_read+0x6c>
			sys_yield();
  801ca0:	e8 d9 f0 ff ff       	call   800d7e <sys_yield>
  801ca5:	eb e1                	jmp    801c88 <devpipe_read+0x21>
				return i;
  801ca7:	89 f0                	mov    %esi,%eax
}
  801ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5f                   	pop    %edi
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb1:	99                   	cltd   
  801cb2:	c1 ea 1b             	shr    $0x1b,%edx
  801cb5:	01 d0                	add    %edx,%eax
  801cb7:	83 e0 1f             	and    $0x1f,%eax
  801cba:	29 d0                	sub    %edx,%eax
  801cbc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cc7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cca:	83 c6 01             	add    $0x1,%esi
  801ccd:	eb b4                	jmp    801c83 <devpipe_read+0x1c>
	return i;
  801ccf:	89 f0                	mov    %esi,%eax
  801cd1:	eb d6                	jmp    801ca9 <devpipe_read+0x42>
				return 0;
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd8:	eb cf                	jmp    801ca9 <devpipe_read+0x42>

00801cda <pipe>:
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	56                   	push   %esi
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce5:	50                   	push   %eax
  801ce6:	e8 15 f6 ff ff       	call   801300 <fd_alloc>
  801ceb:	89 c3                	mov    %eax,%ebx
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 5b                	js     801d4f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	68 07 04 00 00       	push   $0x407
  801cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  801cff:	6a 00                	push   $0x0
  801d01:	e8 97 f0 ff ff       	call   800d9d <sys_page_alloc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 40                	js     801d4f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d15:	50                   	push   %eax
  801d16:	e8 e5 f5 ff ff       	call   801300 <fd_alloc>
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 1b                	js     801d3f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	68 07 04 00 00       	push   $0x407
  801d2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2f:	6a 00                	push   $0x0
  801d31:	e8 67 f0 ff ff       	call   800d9d <sys_page_alloc>
  801d36:	89 c3                	mov    %eax,%ebx
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	79 19                	jns    801d58 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d3f:	83 ec 08             	sub    $0x8,%esp
  801d42:	ff 75 f4             	pushl  -0xc(%ebp)
  801d45:	6a 00                	push   $0x0
  801d47:	e8 d6 f0 ff ff       	call   800e22 <sys_page_unmap>
  801d4c:	83 c4 10             	add    $0x10,%esp
}
  801d4f:	89 d8                	mov    %ebx,%eax
  801d51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
	va = fd2data(fd0);
  801d58:	83 ec 0c             	sub    $0xc,%esp
  801d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5e:	e8 86 f5 ff ff       	call   8012e9 <fd2data>
  801d63:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d65:	83 c4 0c             	add    $0xc,%esp
  801d68:	68 07 04 00 00       	push   $0x407
  801d6d:	50                   	push   %eax
  801d6e:	6a 00                	push   $0x0
  801d70:	e8 28 f0 ff ff       	call   800d9d <sys_page_alloc>
  801d75:	89 c3                	mov    %eax,%ebx
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	0f 88 8c 00 00 00    	js     801e0e <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	ff 75 f0             	pushl  -0x10(%ebp)
  801d88:	e8 5c f5 ff ff       	call   8012e9 <fd2data>
  801d8d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d94:	50                   	push   %eax
  801d95:	6a 00                	push   $0x0
  801d97:	56                   	push   %esi
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 41 f0 ff ff       	call   800de0 <sys_page_map>
  801d9f:	89 c3                	mov    %eax,%ebx
  801da1:	83 c4 20             	add    $0x20,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 58                	js     801e00 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dab:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801db1:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dc6:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd8:	e8 fc f4 ff ff       	call   8012d9 <fd2num>
  801ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801de2:	83 c4 04             	add    $0x4,%esp
  801de5:	ff 75 f0             	pushl  -0x10(%ebp)
  801de8:	e8 ec f4 ff ff       	call   8012d9 <fd2num>
  801ded:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dfb:	e9 4f ff ff ff       	jmp    801d4f <pipe+0x75>
	sys_page_unmap(0, va);
  801e00:	83 ec 08             	sub    $0x8,%esp
  801e03:	56                   	push   %esi
  801e04:	6a 00                	push   $0x0
  801e06:	e8 17 f0 ff ff       	call   800e22 <sys_page_unmap>
  801e0b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e0e:	83 ec 08             	sub    $0x8,%esp
  801e11:	ff 75 f0             	pushl  -0x10(%ebp)
  801e14:	6a 00                	push   $0x0
  801e16:	e8 07 f0 ff ff       	call   800e22 <sys_page_unmap>
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	e9 1c ff ff ff       	jmp    801d3f <pipe+0x65>

00801e23 <pipeisclosed>:
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2c:	50                   	push   %eax
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	e8 1a f5 ff ff       	call   80134f <fd_lookup>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 18                	js     801e54 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e42:	e8 a2 f4 ff ff       	call   8012e9 <fd2data>
	return _pipeisclosed(fd, p);
  801e47:	89 c2                	mov    %eax,%edx
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	e8 30 fd ff ff       	call   801b81 <_pipeisclosed>
  801e51:	83 c4 10             	add    $0x10,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801e5e:	85 f6                	test   %esi,%esi
  801e60:	74 13                	je     801e75 <wait+0x1f>
	e = &envs[ENVX(envid)];
  801e62:	89 f3                	mov    %esi,%ebx
  801e64:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e6a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801e6d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801e73:	eb 1b                	jmp    801e90 <wait+0x3a>
	assert(envid != 0);
  801e75:	68 a6 2e 80 00       	push   $0x802ea6
  801e7a:	68 54 2e 80 00       	push   $0x802e54
  801e7f:	6a 09                	push   $0x9
  801e81:	68 b1 2e 80 00       	push   $0x802eb1
  801e86:	e8 a1 e3 ff ff       	call   80022c <_panic>
		sys_yield();
  801e8b:	e8 ee ee ff ff       	call   800d7e <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e90:	8b 43 48             	mov    0x48(%ebx),%eax
  801e93:	39 f0                	cmp    %esi,%eax
  801e95:	75 07                	jne    801e9e <wait+0x48>
  801e97:	8b 43 54             	mov    0x54(%ebx),%eax
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	75 ed                	jne    801e8b <wait+0x35>
}
  801e9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea1:	5b                   	pop    %ebx
  801ea2:	5e                   	pop    %esi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    

00801ea5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801eab:	68 bc 2e 80 00       	push   $0x802ebc
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	e8 ec ea ff ff       	call   8009a4 <strcpy>
	return 0;
}
  801eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <devsock_close>:
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	53                   	push   %ebx
  801ec3:	83 ec 10             	sub    $0x10,%esp
  801ec6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ec9:	53                   	push   %ebx
  801eca:	e8 52 07 00 00       	call   802621 <pageref>
  801ecf:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ed2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ed7:	83 f8 01             	cmp    $0x1,%eax
  801eda:	74 07                	je     801ee3 <devsock_close+0x24>
}
  801edc:	89 d0                	mov    %edx,%eax
  801ede:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	ff 73 0c             	pushl  0xc(%ebx)
  801ee9:	e8 b7 02 00 00       	call   8021a5 <nsipc_close>
  801eee:	89 c2                	mov    %eax,%edx
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	eb e7                	jmp    801edc <devsock_close+0x1d>

00801ef5 <devsock_write>:
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	ff 75 10             	pushl  0x10(%ebp)
  801f00:	ff 75 0c             	pushl  0xc(%ebp)
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	ff 70 0c             	pushl  0xc(%eax)
  801f09:	e8 74 03 00 00       	call   802282 <nsipc_send>
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <devsock_read>:
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	ff 75 10             	pushl  0x10(%ebp)
  801f1b:	ff 75 0c             	pushl  0xc(%ebp)
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	ff 70 0c             	pushl  0xc(%eax)
  801f24:	e8 ed 02 00 00       	call   802216 <nsipc_recv>
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <fd2sockid>:
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f31:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f34:	52                   	push   %edx
  801f35:	50                   	push   %eax
  801f36:	e8 14 f4 ff ff       	call   80134f <fd_lookup>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 10                	js     801f52 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801f4b:	39 08                	cmp    %ecx,(%eax)
  801f4d:	75 05                	jne    801f54 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f4f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    
		return -E_NOT_SUPP;
  801f54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f59:	eb f7                	jmp    801f52 <fd2sockid+0x27>

00801f5b <alloc_sockfd>:
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 1c             	sub    $0x1c,%esp
  801f63:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f68:	50                   	push   %eax
  801f69:	e8 92 f3 ff ff       	call   801300 <fd_alloc>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	78 43                	js     801fba <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	68 07 04 00 00       	push   $0x407
  801f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f82:	6a 00                	push   $0x0
  801f84:	e8 14 ee ff ff       	call   800d9d <sys_page_alloc>
  801f89:	89 c3                	mov    %eax,%ebx
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 28                	js     801fba <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f9b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fa7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	50                   	push   %eax
  801fae:	e8 26 f3 ff ff       	call   8012d9 <fd2num>
  801fb3:	89 c3                	mov    %eax,%ebx
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	eb 0c                	jmp    801fc6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	56                   	push   %esi
  801fbe:	e8 e2 01 00 00       	call   8021a5 <nsipc_close>
		return r;
  801fc3:	83 c4 10             	add    $0x10,%esp
}
  801fc6:	89 d8                	mov    %ebx,%eax
  801fc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <accept>:
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	e8 4e ff ff ff       	call   801f2b <fd2sockid>
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	78 1b                	js     801ffc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	ff 75 10             	pushl  0x10(%ebp)
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	50                   	push   %eax
  801feb:	e8 0e 01 00 00       	call   8020fe <nsipc_accept>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 05                	js     801ffc <accept+0x2d>
	return alloc_sockfd(r);
  801ff7:	e8 5f ff ff ff       	call   801f5b <alloc_sockfd>
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <bind>:
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	e8 1f ff ff ff       	call   801f2b <fd2sockid>
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 12                	js     802022 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	ff 75 10             	pushl  0x10(%ebp)
  802016:	ff 75 0c             	pushl  0xc(%ebp)
  802019:	50                   	push   %eax
  80201a:	e8 2f 01 00 00       	call   80214e <nsipc_bind>
  80201f:	83 c4 10             	add    $0x10,%esp
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <shutdown>:
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	e8 f9 fe ff ff       	call   801f2b <fd2sockid>
  802032:	85 c0                	test   %eax,%eax
  802034:	78 0f                	js     802045 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	50                   	push   %eax
  80203d:	e8 41 01 00 00       	call   802183 <nsipc_shutdown>
  802042:	83 c4 10             	add    $0x10,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <connect>:
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	e8 d6 fe ff ff       	call   801f2b <fd2sockid>
  802055:	85 c0                	test   %eax,%eax
  802057:	78 12                	js     80206b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	ff 75 10             	pushl  0x10(%ebp)
  80205f:	ff 75 0c             	pushl  0xc(%ebp)
  802062:	50                   	push   %eax
  802063:	e8 57 01 00 00       	call   8021bf <nsipc_connect>
  802068:	83 c4 10             	add    $0x10,%esp
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <listen>:
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	e8 b0 fe ff ff       	call   801f2b <fd2sockid>
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 0f                	js     80208e <listen+0x21>
	return nsipc_listen(r, backlog);
  80207f:	83 ec 08             	sub    $0x8,%esp
  802082:	ff 75 0c             	pushl  0xc(%ebp)
  802085:	50                   	push   %eax
  802086:	e8 69 01 00 00       	call   8021f4 <nsipc_listen>
  80208b:	83 c4 10             	add    $0x10,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <socket>:

int
socket(int domain, int type, int protocol)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802096:	ff 75 10             	pushl  0x10(%ebp)
  802099:	ff 75 0c             	pushl  0xc(%ebp)
  80209c:	ff 75 08             	pushl  0x8(%ebp)
  80209f:	e8 3c 02 00 00       	call   8022e0 <nsipc_socket>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	85 c0                	test   %eax,%eax
  8020a9:	78 05                	js     8020b0 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020ab:	e8 ab fe ff ff       	call   801f5b <alloc_sockfd>
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	53                   	push   %ebx
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020bb:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8020c2:	74 26                	je     8020ea <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020c4:	6a 07                	push   $0x7
  8020c6:	68 00 60 80 00       	push   $0x806000
  8020cb:	53                   	push   %ebx
  8020cc:	ff 35 04 40 80 00    	pushl  0x804004
  8020d2:	e8 b8 04 00 00       	call   80258f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020d7:	83 c4 0c             	add    $0xc,%esp
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	e8 41 04 00 00       	call   802526 <ipc_recv>
}
  8020e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020ea:	83 ec 0c             	sub    $0xc,%esp
  8020ed:	6a 02                	push   $0x2
  8020ef:	e8 f4 04 00 00       	call   8025e8 <ipc_find_env>
  8020f4:	a3 04 40 80 00       	mov    %eax,0x804004
  8020f9:	83 c4 10             	add    $0x10,%esp
  8020fc:	eb c6                	jmp    8020c4 <nsipc+0x12>

008020fe <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	56                   	push   %esi
  802102:	53                   	push   %ebx
  802103:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80210e:	8b 06                	mov    (%esi),%eax
  802110:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802115:	b8 01 00 00 00       	mov    $0x1,%eax
  80211a:	e8 93 ff ff ff       	call   8020b2 <nsipc>
  80211f:	89 c3                	mov    %eax,%ebx
  802121:	85 c0                	test   %eax,%eax
  802123:	78 20                	js     802145 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	ff 35 10 60 80 00    	pushl  0x806010
  80212e:	68 00 60 80 00       	push   $0x806000
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	e8 f7 e9 ff ff       	call   800b32 <memmove>
		*addrlen = ret->ret_addrlen;
  80213b:	a1 10 60 80 00       	mov    0x806010,%eax
  802140:	89 06                	mov    %eax,(%esi)
  802142:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802145:	89 d8                	mov    %ebx,%eax
  802147:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80214a:	5b                   	pop    %ebx
  80214b:	5e                   	pop    %esi
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    

0080214e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	53                   	push   %ebx
  802152:	83 ec 08             	sub    $0x8,%esp
  802155:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802160:	53                   	push   %ebx
  802161:	ff 75 0c             	pushl  0xc(%ebp)
  802164:	68 04 60 80 00       	push   $0x806004
  802169:	e8 c4 e9 ff ff       	call   800b32 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80216e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802174:	b8 02 00 00 00       	mov    $0x2,%eax
  802179:	e8 34 ff ff ff       	call   8020b2 <nsipc>
}
  80217e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802191:	8b 45 0c             	mov    0xc(%ebp),%eax
  802194:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802199:	b8 03 00 00 00       	mov    $0x3,%eax
  80219e:	e8 0f ff ff ff       	call   8020b2 <nsipc>
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <nsipc_close>:

int
nsipc_close(int s)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8021b3:	b8 04 00 00 00       	mov    $0x4,%eax
  8021b8:	e8 f5 fe ff ff       	call   8020b2 <nsipc>
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	53                   	push   %ebx
  8021c3:	83 ec 08             	sub    $0x8,%esp
  8021c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021d1:	53                   	push   %ebx
  8021d2:	ff 75 0c             	pushl  0xc(%ebp)
  8021d5:	68 04 60 80 00       	push   $0x806004
  8021da:	e8 53 e9 ff ff       	call   800b32 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021df:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8021e5:	b8 05 00 00 00       	mov    $0x5,%eax
  8021ea:	e8 c3 fe ff ff       	call   8020b2 <nsipc>
}
  8021ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802202:	8b 45 0c             	mov    0xc(%ebp),%eax
  802205:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80220a:	b8 06 00 00 00       	mov    $0x6,%eax
  80220f:	e8 9e fe ff ff       	call   8020b2 <nsipc>
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	56                   	push   %esi
  80221a:	53                   	push   %ebx
  80221b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802226:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80222c:	8b 45 14             	mov    0x14(%ebp),%eax
  80222f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802234:	b8 07 00 00 00       	mov    $0x7,%eax
  802239:	e8 74 fe ff ff       	call   8020b2 <nsipc>
  80223e:	89 c3                	mov    %eax,%ebx
  802240:	85 c0                	test   %eax,%eax
  802242:	78 1f                	js     802263 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802244:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802249:	7f 21                	jg     80226c <nsipc_recv+0x56>
  80224b:	39 c6                	cmp    %eax,%esi
  80224d:	7c 1d                	jl     80226c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	50                   	push   %eax
  802253:	68 00 60 80 00       	push   $0x806000
  802258:	ff 75 0c             	pushl  0xc(%ebp)
  80225b:	e8 d2 e8 ff ff       	call   800b32 <memmove>
  802260:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802263:	89 d8                	mov    %ebx,%eax
  802265:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802268:	5b                   	pop    %ebx
  802269:	5e                   	pop    %esi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80226c:	68 c8 2e 80 00       	push   $0x802ec8
  802271:	68 54 2e 80 00       	push   $0x802e54
  802276:	6a 62                	push   $0x62
  802278:	68 dd 2e 80 00       	push   $0x802edd
  80227d:	e8 aa df ff ff       	call   80022c <_panic>

00802282 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	53                   	push   %ebx
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802294:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80229a:	7f 2e                	jg     8022ca <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	53                   	push   %ebx
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	68 0c 60 80 00       	push   $0x80600c
  8022a8:	e8 85 e8 ff ff       	call   800b32 <memmove>
	nsipcbuf.send.req_size = size;
  8022ad:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8022c0:	e8 ed fd ff ff       	call   8020b2 <nsipc>
}
  8022c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    
	assert(size < 1600);
  8022ca:	68 e9 2e 80 00       	push   $0x802ee9
  8022cf:	68 54 2e 80 00       	push   $0x802e54
  8022d4:	6a 6d                	push   $0x6d
  8022d6:	68 dd 2e 80 00       	push   $0x802edd
  8022db:	e8 4c df ff ff       	call   80022c <_panic>

008022e0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8022ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f1:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022fe:	b8 09 00 00 00       	mov    $0x9,%eax
  802303:	e8 aa fd ff ff       	call   8020b2 <nsipc>
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80230d:	b8 00 00 00 00       	mov    $0x0,%eax
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80231a:	68 f5 2e 80 00       	push   $0x802ef5
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	e8 7d e6 ff ff       	call   8009a4 <strcpy>
	return 0;
}
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <devcons_write>:
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80233a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80233f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802345:	eb 2f                	jmp    802376 <devcons_write+0x48>
		m = n - tot;
  802347:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80234a:	29 f3                	sub    %esi,%ebx
  80234c:	83 fb 7f             	cmp    $0x7f,%ebx
  80234f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802354:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	53                   	push   %ebx
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	03 45 0c             	add    0xc(%ebp),%eax
  802360:	50                   	push   %eax
  802361:	57                   	push   %edi
  802362:	e8 cb e7 ff ff       	call   800b32 <memmove>
		sys_cputs(buf, m);
  802367:	83 c4 08             	add    $0x8,%esp
  80236a:	53                   	push   %ebx
  80236b:	57                   	push   %edi
  80236c:	e8 70 e9 ff ff       	call   800ce1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802371:	01 de                	add    %ebx,%esi
  802373:	83 c4 10             	add    $0x10,%esp
  802376:	3b 75 10             	cmp    0x10(%ebp),%esi
  802379:	72 cc                	jb     802347 <devcons_write+0x19>
}
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5f                   	pop    %edi
  802383:	5d                   	pop    %ebp
  802384:	c3                   	ret    

00802385 <devcons_read>:
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 08             	sub    $0x8,%esp
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802390:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802394:	75 07                	jne    80239d <devcons_read+0x18>
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    
		sys_yield();
  802398:	e8 e1 e9 ff ff       	call   800d7e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80239d:	e8 5d e9 ff ff       	call   800cff <sys_cgetc>
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 f2                	je     802398 <devcons_read+0x13>
	if (c < 0)
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	78 ec                	js     802396 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8023aa:	83 f8 04             	cmp    $0x4,%eax
  8023ad:	74 0c                	je     8023bb <devcons_read+0x36>
	*(char*)vbuf = c;
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	88 02                	mov    %al,(%edx)
	return 1;
  8023b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b9:	eb db                	jmp    802396 <devcons_read+0x11>
		return 0;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	eb d4                	jmp    802396 <devcons_read+0x11>

008023c2 <cputchar>:
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023ce:	6a 01                	push   $0x1
  8023d0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023d3:	50                   	push   %eax
  8023d4:	e8 08 e9 ff ff       	call   800ce1 <sys_cputs>
}
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <getchar>:
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023e4:	6a 01                	push   $0x1
  8023e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023e9:	50                   	push   %eax
  8023ea:	6a 00                	push   $0x0
  8023ec:	e8 cf f1 ff ff       	call   8015c0 <read>
	if (r < 0)
  8023f1:	83 c4 10             	add    $0x10,%esp
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	78 08                	js     802400 <getchar+0x22>
	if (r < 1)
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	7e 06                	jle    802402 <getchar+0x24>
	return c;
  8023fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    
		return -E_EOF;
  802402:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802407:	eb f7                	jmp    802400 <getchar+0x22>

00802409 <iscons>:
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80240f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802412:	50                   	push   %eax
  802413:	ff 75 08             	pushl  0x8(%ebp)
  802416:	e8 34 ef ff ff       	call   80134f <fd_lookup>
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 11                	js     802433 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80242b:	39 10                	cmp    %edx,(%eax)
  80242d:	0f 94 c0             	sete   %al
  802430:	0f b6 c0             	movzbl %al,%eax
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <opencons>:
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80243b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243e:	50                   	push   %eax
  80243f:	e8 bc ee ff ff       	call   801300 <fd_alloc>
  802444:	83 c4 10             	add    $0x10,%esp
  802447:	85 c0                	test   %eax,%eax
  802449:	78 3a                	js     802485 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	68 07 04 00 00       	push   $0x407
  802453:	ff 75 f4             	pushl  -0xc(%ebp)
  802456:	6a 00                	push   $0x0
  802458:	e8 40 e9 ff ff       	call   800d9d <sys_page_alloc>
  80245d:	83 c4 10             	add    $0x10,%esp
  802460:	85 c0                	test   %eax,%eax
  802462:	78 21                	js     802485 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80246d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	50                   	push   %eax
  80247d:	e8 57 ee ff ff       	call   8012d9 <fd2num>
  802482:	83 c4 10             	add    $0x10,%esp
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
  80248a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80248d:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802494:	74 0a                	je     8024a0 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8024a0:	a1 20 44 80 00       	mov    0x804420,%eax
  8024a5:	8b 40 48             	mov    0x48(%eax),%eax
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	6a 07                	push   $0x7
  8024ad:	68 00 f0 bf ee       	push   $0xeebff000
  8024b2:	50                   	push   %eax
  8024b3:	e8 e5 e8 ff ff       	call   800d9d <sys_page_alloc>
  8024b8:	83 c4 10             	add    $0x10,%esp
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	75 2f                	jne    8024ee <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8024bf:	a1 20 44 80 00       	mov    0x804420,%eax
  8024c4:	8b 40 48             	mov    0x48(%eax),%eax
  8024c7:	83 ec 08             	sub    $0x8,%esp
  8024ca:	68 00 25 80 00       	push   $0x802500
  8024cf:	50                   	push   %eax
  8024d0:	e8 13 ea ff ff       	call   800ee8 <sys_env_set_pgfault_upcall>
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	74 ba                	je     802496 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8024dc:	50                   	push   %eax
  8024dd:	68 01 2f 80 00       	push   $0x802f01
  8024e2:	6a 24                	push   $0x24
  8024e4:	68 19 2f 80 00       	push   $0x802f19
  8024e9:	e8 3e dd ff ff       	call   80022c <_panic>
		    panic("set_pgfault_handler: %e", r);
  8024ee:	50                   	push   %eax
  8024ef:	68 01 2f 80 00       	push   $0x802f01
  8024f4:	6a 21                	push   $0x21
  8024f6:	68 19 2f 80 00       	push   $0x802f19
  8024fb:	e8 2c dd ff ff       	call   80022c <_panic>

00802500 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802500:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802501:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802506:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802508:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  80250b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  80250f:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  802512:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802516:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  80251a:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  80251c:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  80251f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  802520:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  802523:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802524:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802525:	c3                   	ret    

00802526 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	56                   	push   %esi
  80252a:	53                   	push   %ebx
  80252b:	8b 75 08             	mov    0x8(%ebp),%esi
  80252e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802531:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802534:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802536:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80253b:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80253e:	83 ec 0c             	sub    $0xc,%esp
  802541:	50                   	push   %eax
  802542:	e8 06 ea ff ff       	call   800f4d <sys_ipc_recv>
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	85 c0                	test   %eax,%eax
  80254c:	78 2b                	js     802579 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80254e:	85 f6                	test   %esi,%esi
  802550:	74 0a                	je     80255c <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802552:	a1 20 44 80 00       	mov    0x804420,%eax
  802557:	8b 40 74             	mov    0x74(%eax),%eax
  80255a:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80255c:	85 db                	test   %ebx,%ebx
  80255e:	74 0a                	je     80256a <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802560:	a1 20 44 80 00       	mov    0x804420,%eax
  802565:	8b 40 78             	mov    0x78(%eax),%eax
  802568:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80256a:	a1 20 44 80 00       	mov    0x804420,%eax
  80256f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802572:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802575:	5b                   	pop    %ebx
  802576:	5e                   	pop    %esi
  802577:	5d                   	pop    %ebp
  802578:	c3                   	ret    
	    if (from_env_store != NULL) {
  802579:	85 f6                	test   %esi,%esi
  80257b:	74 06                	je     802583 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80257d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802583:	85 db                	test   %ebx,%ebx
  802585:	74 eb                	je     802572 <ipc_recv+0x4c>
	        *perm_store = 0;
  802587:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80258d:	eb e3                	jmp    802572 <ipc_recv+0x4c>

0080258f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	57                   	push   %edi
  802593:	56                   	push   %esi
  802594:	53                   	push   %ebx
  802595:	83 ec 0c             	sub    $0xc,%esp
  802598:	8b 7d 08             	mov    0x8(%ebp),%edi
  80259b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80259e:	85 f6                	test   %esi,%esi
  8025a0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8025a5:	0f 44 f0             	cmove  %eax,%esi
  8025a8:	eb 09                	jmp    8025b3 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8025aa:	e8 cf e7 ff ff       	call   800d7e <sys_yield>
	} while(r != 0);
  8025af:	85 db                	test   %ebx,%ebx
  8025b1:	74 2d                	je     8025e0 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8025b3:	ff 75 14             	pushl  0x14(%ebp)
  8025b6:	56                   	push   %esi
  8025b7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ba:	57                   	push   %edi
  8025bb:	e8 6a e9 ff ff       	call   800f2a <sys_ipc_try_send>
  8025c0:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8025c2:	83 c4 10             	add    $0x10,%esp
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	79 e1                	jns    8025aa <ipc_send+0x1b>
  8025c9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025cc:	74 dc                	je     8025aa <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8025ce:	50                   	push   %eax
  8025cf:	68 27 2f 80 00       	push   $0x802f27
  8025d4:	6a 45                	push   $0x45
  8025d6:	68 34 2f 80 00       	push   $0x802f34
  8025db:	e8 4c dc ff ff       	call   80022c <_panic>
}
  8025e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025e3:	5b                   	pop    %ebx
  8025e4:	5e                   	pop    %esi
  8025e5:	5f                   	pop    %edi
  8025e6:	5d                   	pop    %ebp
  8025e7:	c3                   	ret    

008025e8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
  8025eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025f3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025f6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025fc:	8b 52 50             	mov    0x50(%edx),%edx
  8025ff:	39 ca                	cmp    %ecx,%edx
  802601:	74 11                	je     802614 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802603:	83 c0 01             	add    $0x1,%eax
  802606:	3d 00 04 00 00       	cmp    $0x400,%eax
  80260b:	75 e6                	jne    8025f3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80260d:	b8 00 00 00 00       	mov    $0x0,%eax
  802612:	eb 0b                	jmp    80261f <ipc_find_env+0x37>
			return envs[i].env_id;
  802614:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802617:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80261c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    

00802621 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
  802624:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802627:	89 d0                	mov    %edx,%eax
  802629:	c1 e8 16             	shr    $0x16,%eax
  80262c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802633:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802638:	f6 c1 01             	test   $0x1,%cl
  80263b:	74 1d                	je     80265a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80263d:	c1 ea 0c             	shr    $0xc,%edx
  802640:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802647:	f6 c2 01             	test   $0x1,%dl
  80264a:	74 0e                	je     80265a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80264c:	c1 ea 0c             	shr    $0xc,%edx
  80264f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802656:	ef 
  802657:	0f b7 c0             	movzwl %ax,%eax
}
  80265a:	5d                   	pop    %ebp
  80265b:	c3                   	ret    
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__udivdi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80266b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80266f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802673:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802677:	85 d2                	test   %edx,%edx
  802679:	75 35                	jne    8026b0 <__udivdi3+0x50>
  80267b:	39 f3                	cmp    %esi,%ebx
  80267d:	0f 87 bd 00 00 00    	ja     802740 <__udivdi3+0xe0>
  802683:	85 db                	test   %ebx,%ebx
  802685:	89 d9                	mov    %ebx,%ecx
  802687:	75 0b                	jne    802694 <__udivdi3+0x34>
  802689:	b8 01 00 00 00       	mov    $0x1,%eax
  80268e:	31 d2                	xor    %edx,%edx
  802690:	f7 f3                	div    %ebx
  802692:	89 c1                	mov    %eax,%ecx
  802694:	31 d2                	xor    %edx,%edx
  802696:	89 f0                	mov    %esi,%eax
  802698:	f7 f1                	div    %ecx
  80269a:	89 c6                	mov    %eax,%esi
  80269c:	89 e8                	mov    %ebp,%eax
  80269e:	89 f7                	mov    %esi,%edi
  8026a0:	f7 f1                	div    %ecx
  8026a2:	89 fa                	mov    %edi,%edx
  8026a4:	83 c4 1c             	add    $0x1c,%esp
  8026a7:	5b                   	pop    %ebx
  8026a8:	5e                   	pop    %esi
  8026a9:	5f                   	pop    %edi
  8026aa:	5d                   	pop    %ebp
  8026ab:	c3                   	ret    
  8026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	39 f2                	cmp    %esi,%edx
  8026b2:	77 7c                	ja     802730 <__udivdi3+0xd0>
  8026b4:	0f bd fa             	bsr    %edx,%edi
  8026b7:	83 f7 1f             	xor    $0x1f,%edi
  8026ba:	0f 84 98 00 00 00    	je     802758 <__udivdi3+0xf8>
  8026c0:	89 f9                	mov    %edi,%ecx
  8026c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026c7:	29 f8                	sub    %edi,%eax
  8026c9:	d3 e2                	shl    %cl,%edx
  8026cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026cf:	89 c1                	mov    %eax,%ecx
  8026d1:	89 da                	mov    %ebx,%edx
  8026d3:	d3 ea                	shr    %cl,%edx
  8026d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026d9:	09 d1                	or     %edx,%ecx
  8026db:	89 f2                	mov    %esi,%edx
  8026dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026e1:	89 f9                	mov    %edi,%ecx
  8026e3:	d3 e3                	shl    %cl,%ebx
  8026e5:	89 c1                	mov    %eax,%ecx
  8026e7:	d3 ea                	shr    %cl,%edx
  8026e9:	89 f9                	mov    %edi,%ecx
  8026eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026ef:	d3 e6                	shl    %cl,%esi
  8026f1:	89 eb                	mov    %ebp,%ebx
  8026f3:	89 c1                	mov    %eax,%ecx
  8026f5:	d3 eb                	shr    %cl,%ebx
  8026f7:	09 de                	or     %ebx,%esi
  8026f9:	89 f0                	mov    %esi,%eax
  8026fb:	f7 74 24 08          	divl   0x8(%esp)
  8026ff:	89 d6                	mov    %edx,%esi
  802701:	89 c3                	mov    %eax,%ebx
  802703:	f7 64 24 0c          	mull   0xc(%esp)
  802707:	39 d6                	cmp    %edx,%esi
  802709:	72 0c                	jb     802717 <__udivdi3+0xb7>
  80270b:	89 f9                	mov    %edi,%ecx
  80270d:	d3 e5                	shl    %cl,%ebp
  80270f:	39 c5                	cmp    %eax,%ebp
  802711:	73 5d                	jae    802770 <__udivdi3+0x110>
  802713:	39 d6                	cmp    %edx,%esi
  802715:	75 59                	jne    802770 <__udivdi3+0x110>
  802717:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80271a:	31 ff                	xor    %edi,%edi
  80271c:	89 fa                	mov    %edi,%edx
  80271e:	83 c4 1c             	add    $0x1c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    
  802726:	8d 76 00             	lea    0x0(%esi),%esi
  802729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802730:	31 ff                	xor    %edi,%edi
  802732:	31 c0                	xor    %eax,%eax
  802734:	89 fa                	mov    %edi,%edx
  802736:	83 c4 1c             	add    $0x1c,%esp
  802739:	5b                   	pop    %ebx
  80273a:	5e                   	pop    %esi
  80273b:	5f                   	pop    %edi
  80273c:	5d                   	pop    %ebp
  80273d:	c3                   	ret    
  80273e:	66 90                	xchg   %ax,%ax
  802740:	31 ff                	xor    %edi,%edi
  802742:	89 e8                	mov    %ebp,%eax
  802744:	89 f2                	mov    %esi,%edx
  802746:	f7 f3                	div    %ebx
  802748:	89 fa                	mov    %edi,%edx
  80274a:	83 c4 1c             	add    $0x1c,%esp
  80274d:	5b                   	pop    %ebx
  80274e:	5e                   	pop    %esi
  80274f:	5f                   	pop    %edi
  802750:	5d                   	pop    %ebp
  802751:	c3                   	ret    
  802752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802758:	39 f2                	cmp    %esi,%edx
  80275a:	72 06                	jb     802762 <__udivdi3+0x102>
  80275c:	31 c0                	xor    %eax,%eax
  80275e:	39 eb                	cmp    %ebp,%ebx
  802760:	77 d2                	ja     802734 <__udivdi3+0xd4>
  802762:	b8 01 00 00 00       	mov    $0x1,%eax
  802767:	eb cb                	jmp    802734 <__udivdi3+0xd4>
  802769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802770:	89 d8                	mov    %ebx,%eax
  802772:	31 ff                	xor    %edi,%edi
  802774:	eb be                	jmp    802734 <__udivdi3+0xd4>
  802776:	66 90                	xchg   %ax,%ax
  802778:	66 90                	xchg   %ax,%ax
  80277a:	66 90                	xchg   %ax,%ax
  80277c:	66 90                	xchg   %ax,%ax
  80277e:	66 90                	xchg   %ax,%ax

00802780 <__umoddi3>:
  802780:	55                   	push   %ebp
  802781:	57                   	push   %edi
  802782:	56                   	push   %esi
  802783:	53                   	push   %ebx
  802784:	83 ec 1c             	sub    $0x1c,%esp
  802787:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80278b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80278f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802793:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802797:	85 ed                	test   %ebp,%ebp
  802799:	89 f0                	mov    %esi,%eax
  80279b:	89 da                	mov    %ebx,%edx
  80279d:	75 19                	jne    8027b8 <__umoddi3+0x38>
  80279f:	39 df                	cmp    %ebx,%edi
  8027a1:	0f 86 b1 00 00 00    	jbe    802858 <__umoddi3+0xd8>
  8027a7:	f7 f7                	div    %edi
  8027a9:	89 d0                	mov    %edx,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	83 c4 1c             	add    $0x1c,%esp
  8027b0:	5b                   	pop    %ebx
  8027b1:	5e                   	pop    %esi
  8027b2:	5f                   	pop    %edi
  8027b3:	5d                   	pop    %ebp
  8027b4:	c3                   	ret    
  8027b5:	8d 76 00             	lea    0x0(%esi),%esi
  8027b8:	39 dd                	cmp    %ebx,%ebp
  8027ba:	77 f1                	ja     8027ad <__umoddi3+0x2d>
  8027bc:	0f bd cd             	bsr    %ebp,%ecx
  8027bf:	83 f1 1f             	xor    $0x1f,%ecx
  8027c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027c6:	0f 84 b4 00 00 00    	je     802880 <__umoddi3+0x100>
  8027cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8027d1:	89 c2                	mov    %eax,%edx
  8027d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027d7:	29 c2                	sub    %eax,%edx
  8027d9:	89 c1                	mov    %eax,%ecx
  8027db:	89 f8                	mov    %edi,%eax
  8027dd:	d3 e5                	shl    %cl,%ebp
  8027df:	89 d1                	mov    %edx,%ecx
  8027e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027e5:	d3 e8                	shr    %cl,%eax
  8027e7:	09 c5                	or     %eax,%ebp
  8027e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027ed:	89 c1                	mov    %eax,%ecx
  8027ef:	d3 e7                	shl    %cl,%edi
  8027f1:	89 d1                	mov    %edx,%ecx
  8027f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027f7:	89 df                	mov    %ebx,%edi
  8027f9:	d3 ef                	shr    %cl,%edi
  8027fb:	89 c1                	mov    %eax,%ecx
  8027fd:	89 f0                	mov    %esi,%eax
  8027ff:	d3 e3                	shl    %cl,%ebx
  802801:	89 d1                	mov    %edx,%ecx
  802803:	89 fa                	mov    %edi,%edx
  802805:	d3 e8                	shr    %cl,%eax
  802807:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80280c:	09 d8                	or     %ebx,%eax
  80280e:	f7 f5                	div    %ebp
  802810:	d3 e6                	shl    %cl,%esi
  802812:	89 d1                	mov    %edx,%ecx
  802814:	f7 64 24 08          	mull   0x8(%esp)
  802818:	39 d1                	cmp    %edx,%ecx
  80281a:	89 c3                	mov    %eax,%ebx
  80281c:	89 d7                	mov    %edx,%edi
  80281e:	72 06                	jb     802826 <__umoddi3+0xa6>
  802820:	75 0e                	jne    802830 <__umoddi3+0xb0>
  802822:	39 c6                	cmp    %eax,%esi
  802824:	73 0a                	jae    802830 <__umoddi3+0xb0>
  802826:	2b 44 24 08          	sub    0x8(%esp),%eax
  80282a:	19 ea                	sbb    %ebp,%edx
  80282c:	89 d7                	mov    %edx,%edi
  80282e:	89 c3                	mov    %eax,%ebx
  802830:	89 ca                	mov    %ecx,%edx
  802832:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802837:	29 de                	sub    %ebx,%esi
  802839:	19 fa                	sbb    %edi,%edx
  80283b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80283f:	89 d0                	mov    %edx,%eax
  802841:	d3 e0                	shl    %cl,%eax
  802843:	89 d9                	mov    %ebx,%ecx
  802845:	d3 ee                	shr    %cl,%esi
  802847:	d3 ea                	shr    %cl,%edx
  802849:	09 f0                	or     %esi,%eax
  80284b:	83 c4 1c             	add    $0x1c,%esp
  80284e:	5b                   	pop    %ebx
  80284f:	5e                   	pop    %esi
  802850:	5f                   	pop    %edi
  802851:	5d                   	pop    %ebp
  802852:	c3                   	ret    
  802853:	90                   	nop
  802854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802858:	85 ff                	test   %edi,%edi
  80285a:	89 f9                	mov    %edi,%ecx
  80285c:	75 0b                	jne    802869 <__umoddi3+0xe9>
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
  802863:	31 d2                	xor    %edx,%edx
  802865:	f7 f7                	div    %edi
  802867:	89 c1                	mov    %eax,%ecx
  802869:	89 d8                	mov    %ebx,%eax
  80286b:	31 d2                	xor    %edx,%edx
  80286d:	f7 f1                	div    %ecx
  80286f:	89 f0                	mov    %esi,%eax
  802871:	f7 f1                	div    %ecx
  802873:	e9 31 ff ff ff       	jmp    8027a9 <__umoddi3+0x29>
  802878:	90                   	nop
  802879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802880:	39 dd                	cmp    %ebx,%ebp
  802882:	72 08                	jb     80288c <__umoddi3+0x10c>
  802884:	39 f7                	cmp    %esi,%edi
  802886:	0f 87 21 ff ff ff    	ja     8027ad <__umoddi3+0x2d>
  80288c:	89 da                	mov    %ebx,%edx
  80288e:	89 f0                	mov    %esi,%eax
  802890:	29 f8                	sub    %edi,%eax
  802892:	19 ea                	sbb    %ebp,%edx
  802894:	e9 14 ff ff ff       	jmp    8027ad <__umoddi3+0x2d>
