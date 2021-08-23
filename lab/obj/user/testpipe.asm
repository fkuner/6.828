
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 40 80 00 c0 	movl   $0x8029c0,0x804004
  800042:	29 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 96 1d 00 00       	call   801de4 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1f 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 41 11 00 00       	call   8011a1 <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 22 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	85 c0                	test   %eax,%eax
  80006c:	0f 85 58 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800072:	a1 08 50 80 00       	mov    0x805008,%eax
  800077:	8b 40 48             	mov    0x48(%eax),%eax
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	ff 75 90             	pushl  -0x70(%ebp)
  800080:	50                   	push   %eax
  800081:	68 e5 29 80 00       	push   $0x8029e5
  800086:	e8 86 03 00 00       	call   800411 <cprintf>
		close(p[1]);
  80008b:	83 c4 04             	add    $0x4,%esp
  80008e:	ff 75 90             	pushl  -0x70(%ebp)
  800091:	e8 f8 14 00 00       	call   80158e <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800096:	a1 08 50 80 00       	mov    0x805008,%eax
  80009b:	8b 40 48             	mov    0x48(%eax),%eax
  80009e:	83 c4 0c             	add    $0xc,%esp
  8000a1:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a4:	50                   	push   %eax
  8000a5:	68 02 2a 80 00       	push   $0x802a02
  8000aa:	e8 62 03 00 00       	call   800411 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000af:	83 c4 0c             	add    $0xc,%esp
  8000b2:	6a 63                	push   $0x63
  8000b4:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b7:	50                   	push   %eax
  8000b8:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bb:	e8 91 16 00 00       	call   801751 <readn>
  8000c0:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	0f 88 d1 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cd:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	ff 35 00 40 80 00    	pushl  0x804000
  8000db:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000de:	50                   	push   %eax
  8000df:	e8 70 0a 00 00       	call   800b54 <strcmp>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	0f 85 c1 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 28 2a 80 00       	push   $0x802a28
  8000f7:	e8 15 03 00 00       	call   800411 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000ff:	e8 18 02 00 00       	call   80031c <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	53                   	push   %ebx
  800108:	e8 53 1e 00 00       	call   801f60 <wait>

	binaryname = "pipewriteeof";
  80010d:	c7 05 04 40 80 00 7e 	movl   $0x802a7e,0x804004
  800114:	2a 80 00 
	if ((i = pipe(p)) < 0)
  800117:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 c2 1c 00 00       	call   801de4 <pipe>
  800122:	89 c6                	mov    %eax,%esi
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	85 c0                	test   %eax,%eax
  800129:	0f 88 34 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012f:	e8 6d 10 00 00       	call   8011a1 <fork>
  800134:	89 c3                	mov    %eax,%ebx
  800136:	85 c0                	test   %eax,%eax
  800138:	0f 88 37 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  80013e:	85 c0                	test   %eax,%eax
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 3d 14 00 00       	call   80158e <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 32 14 00 00       	call   80158e <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 fc 1d 00 00       	call   801f60 <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 ac 2a 80 00 	movl   $0x802aac,(%esp)
  80016b:	e8 a1 02 00 00       	call   800411 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 cc 29 80 00       	push   $0x8029cc
  800180:	6a 0e                	push   $0xe
  800182:	68 d5 29 80 00       	push   $0x8029d5
  800187:	e8 aa 01 00 00       	call   800336 <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 a6 2e 80 00       	push   $0x802ea6
  800192:	6a 11                	push   $0x11
  800194:	68 d5 29 80 00       	push   $0x8029d5
  800199:	e8 98 01 00 00       	call   800336 <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 1f 2a 80 00       	push   $0x802a1f
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 d5 29 80 00       	push   $0x8029d5
  8001ab:	e8 86 01 00 00       	call   800336 <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 44 2a 80 00       	push   $0x802a44
  8001bd:	e8 4f 02 00 00       	call   800411 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 35 ff ff ff       	jmp    8000ff <umain+0xcc>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 e5 29 80 00       	push   $0x8029e5
  8001de:	e8 2e 02 00 00       	call   800411 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 a0 13 00 00       	call   80158e <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 08 50 80 00       	mov    0x805008,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 57 2a 80 00       	push   $0x802a57
  800202:	e8 0a 02 00 00       	call   800411 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 40 80 00    	pushl  0x804000
  800210:	e8 62 08 00 00       	call   800a77 <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 40 80 00    	pushl  0x804000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 71 15 00 00       	call   801798 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 40 80 00    	pushl  0x804000
  800232:	e8 40 08 00 00       	call   800a77 <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 45 13 00 00       	call   80158e <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b3 fe ff ff       	jmp    800104 <umain+0xd1>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 74 2a 80 00       	push   $0x802a74
  800257:	6a 25                	push   $0x25
  800259:	68 d5 29 80 00       	push   $0x8029d5
  80025e:	e8 d3 00 00 00       	call   800336 <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 cc 29 80 00       	push   $0x8029cc
  800269:	6a 2c                	push   $0x2c
  80026b:	68 d5 29 80 00       	push   $0x8029d5
  800270:	e8 c1 00 00 00       	call   800336 <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 a6 2e 80 00       	push   $0x802ea6
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 d5 29 80 00       	push   $0x8029d5
  800282:	e8 af 00 00 00       	call   800336 <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 fc 12 00 00       	call   80158e <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 8b 2a 80 00       	push   $0x802a8b
  80029d:	e8 6f 01 00 00       	call   800411 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 8d 2a 80 00       	push   $0x802a8d
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 e4 14 00 00       	call   801798 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 8f 2a 80 00       	push   $0x802a8f
  8002c4:	e8 48 01 00 00       	call   800411 <cprintf>
		exit();
  8002c9:	e8 4e 00 00 00       	call   80031c <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8002e1:	e8 83 0b 00 00       	call   800e69 <sys_getenvid>
  8002e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	85 db                	test   %ebx,%ebx
  8002fa:	7e 07                	jle    800303 <libmain+0x2d>
		binaryname = argv[0];
  8002fc:	8b 06                	mov    (%esi),%eax
  8002fe:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	e8 26 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030d:	e8 0a 00 00 00       	call   80031c <exit>
}
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800322:	e8 92 12 00 00       	call   8015b9 <close_all>
	sys_env_destroy(0);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	e8 f7 0a 00 00       	call   800e28 <sys_env_destroy>
}
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	c9                   	leave  
  800335:	c3                   	ret    

00800336 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80033b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80033e:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800344:	e8 20 0b 00 00       	call   800e69 <sys_getenvid>
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	56                   	push   %esi
  800353:	50                   	push   %eax
  800354:	68 10 2b 80 00       	push   $0x802b10
  800359:	e8 b3 00 00 00       	call   800411 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035e:	83 c4 18             	add    $0x18,%esp
  800361:	53                   	push   %ebx
  800362:	ff 75 10             	pushl  0x10(%ebp)
  800365:	e8 56 00 00 00       	call   8003c0 <vcprintf>
	cprintf("\n");
  80036a:	c7 04 24 00 2a 80 00 	movl   $0x802a00,(%esp)
  800371:	e8 9b 00 00 00       	call   800411 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800379:	cc                   	int3   
  80037a:	eb fd                	jmp    800379 <_panic+0x43>

0080037c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	53                   	push   %ebx
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800386:	8b 13                	mov    (%ebx),%edx
  800388:	8d 42 01             	lea    0x1(%edx),%eax
  80038b:	89 03                	mov    %eax,(%ebx)
  80038d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800390:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800394:	3d ff 00 00 00       	cmp    $0xff,%eax
  800399:	74 09                	je     8003a4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80039b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80039f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	68 ff 00 00 00       	push   $0xff
  8003ac:	8d 43 08             	lea    0x8(%ebx),%eax
  8003af:	50                   	push   %eax
  8003b0:	e8 36 0a 00 00       	call   800deb <sys_cputs>
		b->idx = 0;
  8003b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	eb db                	jmp    80039b <putch+0x1f>

008003c0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d0:	00 00 00 
	b.cnt = 0;
  8003d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003dd:	ff 75 0c             	pushl  0xc(%ebp)
  8003e0:	ff 75 08             	pushl  0x8(%ebp)
  8003e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e9:	50                   	push   %eax
  8003ea:	68 7c 03 80 00       	push   $0x80037c
  8003ef:	e8 1a 01 00 00       	call   80050e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f4:	83 c4 08             	add    $0x8,%esp
  8003f7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003fd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800403:	50                   	push   %eax
  800404:	e8 e2 09 00 00       	call   800deb <sys_cputs>

	return b.cnt;
}
  800409:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80040f:	c9                   	leave  
  800410:	c3                   	ret    

00800411 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800417:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80041a:	50                   	push   %eax
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 9d ff ff ff       	call   8003c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	57                   	push   %edi
  800429:	56                   	push   %esi
  80042a:	53                   	push   %ebx
  80042b:	83 ec 1c             	sub    $0x1c,%esp
  80042e:	89 c7                	mov    %eax,%edi
  800430:	89 d6                	mov    %edx,%esi
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 55 0c             	mov    0xc(%ebp),%edx
  800438:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800441:	bb 00 00 00 00       	mov    $0x0,%ebx
  800446:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80044c:	39 d3                	cmp    %edx,%ebx
  80044e:	72 05                	jb     800455 <printnum+0x30>
  800450:	39 45 10             	cmp    %eax,0x10(%ebp)
  800453:	77 7a                	ja     8004cf <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	ff 75 18             	pushl  0x18(%ebp)
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800461:	53                   	push   %ebx
  800462:	ff 75 10             	pushl  0x10(%ebp)
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046b:	ff 75 e0             	pushl  -0x20(%ebp)
  80046e:	ff 75 dc             	pushl  -0x24(%ebp)
  800471:	ff 75 d8             	pushl  -0x28(%ebp)
  800474:	e8 f7 22 00 00       	call   802770 <__udivdi3>
  800479:	83 c4 18             	add    $0x18,%esp
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	89 f2                	mov    %esi,%edx
  800480:	89 f8                	mov    %edi,%eax
  800482:	e8 9e ff ff ff       	call   800425 <printnum>
  800487:	83 c4 20             	add    $0x20,%esp
  80048a:	eb 13                	jmp    80049f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	56                   	push   %esi
  800490:	ff 75 18             	pushl  0x18(%ebp)
  800493:	ff d7                	call   *%edi
  800495:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800498:	83 eb 01             	sub    $0x1,%ebx
  80049b:	85 db                	test   %ebx,%ebx
  80049d:	7f ed                	jg     80048c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	56                   	push   %esi
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8004af:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b2:	e8 d9 23 00 00       	call   802890 <__umoddi3>
  8004b7:	83 c4 14             	add    $0x14,%esp
  8004ba:	0f be 80 33 2b 80 00 	movsbl 0x802b33(%eax),%eax
  8004c1:	50                   	push   %eax
  8004c2:	ff d7                	call   *%edi
}
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ca:	5b                   	pop    %ebx
  8004cb:	5e                   	pop    %esi
  8004cc:	5f                   	pop    %edi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    
  8004cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004d2:	eb c4                	jmp    800498 <printnum+0x73>

008004d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004da:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004de:	8b 10                	mov    (%eax),%edx
  8004e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e3:	73 0a                	jae    8004ef <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e8:	89 08                	mov    %ecx,(%eax)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	88 02                	mov    %al,(%edx)
}
  8004ef:	5d                   	pop    %ebp
  8004f0:	c3                   	ret    

008004f1 <printfmt>:
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004fa:	50                   	push   %eax
  8004fb:	ff 75 10             	pushl  0x10(%ebp)
  8004fe:	ff 75 0c             	pushl  0xc(%ebp)
  800501:	ff 75 08             	pushl  0x8(%ebp)
  800504:	e8 05 00 00 00       	call   80050e <vprintfmt>
}
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vprintfmt>:
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	57                   	push   %edi
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 2c             	sub    $0x2c,%esp
  800517:	8b 75 08             	mov    0x8(%ebp),%esi
  80051a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800520:	e9 21 04 00 00       	jmp    800946 <vprintfmt+0x438>
		padc = ' ';
  800525:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800529:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800530:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800537:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80053e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8d 47 01             	lea    0x1(%edi),%eax
  800546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800549:	0f b6 17             	movzbl (%edi),%edx
  80054c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80054f:	3c 55                	cmp    $0x55,%al
  800551:	0f 87 90 04 00 00    	ja     8009e7 <vprintfmt+0x4d9>
  800557:	0f b6 c0             	movzbl %al,%eax
  80055a:	ff 24 85 80 2c 80 00 	jmp    *0x802c80(,%eax,4)
  800561:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800564:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800568:	eb d9                	jmp    800543 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80056d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800571:	eb d0                	jmp    800543 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800573:	0f b6 d2             	movzbl %dl,%edx
  800576:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800581:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800584:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800588:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80058e:	83 f9 09             	cmp    $0x9,%ecx
  800591:	77 55                	ja     8005e8 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800593:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800596:	eb e9                	jmp    800581 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 40 04             	lea    0x4(%eax),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b0:	79 91                	jns    800543 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005bf:	eb 82                	jmp    800543 <vprintfmt+0x35>
  8005c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	0f 49 d0             	cmovns %eax,%edx
  8005ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d4:	e9 6a ff ff ff       	jmp    800543 <vprintfmt+0x35>
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005dc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005e3:	e9 5b ff ff ff       	jmp    800543 <vprintfmt+0x35>
  8005e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ee:	eb bc                	jmp    8005ac <vprintfmt+0x9e>
			lflag++;
  8005f0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f6:	e9 48 ff ff ff       	jmp    800543 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 78 04             	lea    0x4(%eax),%edi
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	53                   	push   %ebx
  800605:	ff 30                	pushl  (%eax)
  800607:	ff d6                	call   *%esi
			break;
  800609:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80060c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80060f:	e9 2f 03 00 00       	jmp    800943 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 78 04             	lea    0x4(%eax),%edi
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	99                   	cltd   
  80061d:	31 d0                	xor    %edx,%eax
  80061f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800621:	83 f8 0f             	cmp    $0xf,%eax
  800624:	7f 23                	jg     800649 <vprintfmt+0x13b>
  800626:	8b 14 85 e0 2d 80 00 	mov    0x802de0(,%eax,4),%edx
  80062d:	85 d2                	test   %edx,%edx
  80062f:	74 18                	je     800649 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800631:	52                   	push   %edx
  800632:	68 a6 2f 80 00       	push   $0x802fa6
  800637:	53                   	push   %ebx
  800638:	56                   	push   %esi
  800639:	e8 b3 fe ff ff       	call   8004f1 <printfmt>
  80063e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800641:	89 7d 14             	mov    %edi,0x14(%ebp)
  800644:	e9 fa 02 00 00       	jmp    800943 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800649:	50                   	push   %eax
  80064a:	68 4b 2b 80 00       	push   $0x802b4b
  80064f:	53                   	push   %ebx
  800650:	56                   	push   %esi
  800651:	e8 9b fe ff ff       	call   8004f1 <printfmt>
  800656:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800659:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80065c:	e9 e2 02 00 00       	jmp    800943 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 c0 04             	add    $0x4,%eax
  800667:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80066f:	85 ff                	test   %edi,%edi
  800671:	b8 44 2b 80 00       	mov    $0x802b44,%eax
  800676:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800679:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067d:	0f 8e bd 00 00 00    	jle    800740 <vprintfmt+0x232>
  800683:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800687:	75 0e                	jne    800697 <vprintfmt+0x189>
  800689:	89 75 08             	mov    %esi,0x8(%ebp)
  80068c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80068f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800692:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800695:	eb 6d                	jmp    800704 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 d0             	pushl  -0x30(%ebp)
  80069d:	57                   	push   %edi
  80069e:	e8 ec 03 00 00       	call   800a8f <strnlen>
  8006a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006a6:	29 c1                	sub    %eax,%ecx
  8006a8:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006ab:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006ae:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006b8:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c5:	83 ef 01             	sub    $0x1,%edi
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	85 ff                	test   %edi,%edi
  8006cd:	7f ed                	jg     8006bc <vprintfmt+0x1ae>
  8006cf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006d2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d5:	85 c9                	test   %ecx,%ecx
  8006d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006dc:	0f 49 c1             	cmovns %ecx,%eax
  8006df:	29 c1                	sub    %eax,%ecx
  8006e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8006e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006e7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006ea:	89 cb                	mov    %ecx,%ebx
  8006ec:	eb 16                	jmp    800704 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f2:	75 31                	jne    800725 <vprintfmt+0x217>
					putch(ch, putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	ff 55 08             	call   *0x8(%ebp)
  8006fe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800701:	83 eb 01             	sub    $0x1,%ebx
  800704:	83 c7 01             	add    $0x1,%edi
  800707:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80070b:	0f be c2             	movsbl %dl,%eax
  80070e:	85 c0                	test   %eax,%eax
  800710:	74 59                	je     80076b <vprintfmt+0x25d>
  800712:	85 f6                	test   %esi,%esi
  800714:	78 d8                	js     8006ee <vprintfmt+0x1e0>
  800716:	83 ee 01             	sub    $0x1,%esi
  800719:	79 d3                	jns    8006ee <vprintfmt+0x1e0>
  80071b:	89 df                	mov    %ebx,%edi
  80071d:	8b 75 08             	mov    0x8(%ebp),%esi
  800720:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800723:	eb 37                	jmp    80075c <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800725:	0f be d2             	movsbl %dl,%edx
  800728:	83 ea 20             	sub    $0x20,%edx
  80072b:	83 fa 5e             	cmp    $0x5e,%edx
  80072e:	76 c4                	jbe    8006f4 <vprintfmt+0x1e6>
					putch('?', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	6a 3f                	push   $0x3f
  800738:	ff 55 08             	call   *0x8(%ebp)
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	eb c1                	jmp    800701 <vprintfmt+0x1f3>
  800740:	89 75 08             	mov    %esi,0x8(%ebp)
  800743:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800746:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800749:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80074c:	eb b6                	jmp    800704 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 20                	push   $0x20
  800754:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800756:	83 ef 01             	sub    $0x1,%edi
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 ff                	test   %edi,%edi
  80075e:	7f ee                	jg     80074e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800760:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
  800766:	e9 d8 01 00 00       	jmp    800943 <vprintfmt+0x435>
  80076b:	89 df                	mov    %ebx,%edi
  80076d:	8b 75 08             	mov    0x8(%ebp),%esi
  800770:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800773:	eb e7                	jmp    80075c <vprintfmt+0x24e>
	if (lflag >= 2)
  800775:	83 f9 01             	cmp    $0x1,%ecx
  800778:	7e 45                	jle    8007bf <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 50 04             	mov    0x4(%eax),%edx
  800780:	8b 00                	mov    (%eax),%eax
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800785:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 08             	lea    0x8(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800791:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800795:	79 62                	jns    8007f9 <vprintfmt+0x2eb>
				putch('-', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	6a 2d                	push   $0x2d
  80079d:	ff d6                	call   *%esi
				num = -(long long) num;
  80079f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007a5:	f7 d8                	neg    %eax
  8007a7:	83 d2 00             	adc    $0x0,%edx
  8007aa:	f7 da                	neg    %edx
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007b5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007ba:	e9 66 01 00 00       	jmp    800925 <vprintfmt+0x417>
	else if (lflag)
  8007bf:	85 c9                	test   %ecx,%ecx
  8007c1:	75 1b                	jne    8007de <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cb:	89 c1                	mov    %eax,%ecx
  8007cd:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8d 40 04             	lea    0x4(%eax),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	eb b3                	jmp    800791 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e6:	89 c1                	mov    %eax,%ecx
  8007e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8007eb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 40 04             	lea    0x4(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f7:	eb 98                	jmp    800791 <vprintfmt+0x283>
			base = 10;
  8007f9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007fe:	e9 22 01 00 00       	jmp    800925 <vprintfmt+0x417>
	if (lflag >= 2)
  800803:	83 f9 01             	cmp    $0x1,%ecx
  800806:	7e 21                	jle    800829 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 50 04             	mov    0x4(%eax),%edx
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800813:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8d 40 08             	lea    0x8(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081f:	ba 0a 00 00 00       	mov    $0xa,%edx
  800824:	e9 fc 00 00 00       	jmp    800925 <vprintfmt+0x417>
	else if (lflag)
  800829:	85 c9                	test   %ecx,%ecx
  80082b:	75 23                	jne    800850 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 04             	lea    0x4(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800846:	ba 0a 00 00 00       	mov    $0xa,%edx
  80084b:	e9 d5 00 00 00       	jmp    800925 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	ba 00 00 00 00       	mov    $0x0,%edx
  80085a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8d 40 04             	lea    0x4(%eax),%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800869:	ba 0a 00 00 00       	mov    $0xa,%edx
  80086e:	e9 b2 00 00 00       	jmp    800925 <vprintfmt+0x417>
	if (lflag >= 2)
  800873:	83 f9 01             	cmp    $0x1,%ecx
  800876:	7e 42                	jle    8008ba <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8b 50 04             	mov    0x4(%eax),%edx
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800883:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	8d 40 08             	lea    0x8(%eax),%eax
  80088c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80088f:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800894:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800898:	0f 89 87 00 00 00    	jns    800925 <vprintfmt+0x417>
				putch('-', putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	53                   	push   %ebx
  8008a2:	6a 2d                	push   $0x2d
  8008a4:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a6:	f7 5d d8             	negl   -0x28(%ebp)
  8008a9:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8008ad:	f7 5d dc             	negl   -0x24(%ebp)
  8008b0:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8008b3:	ba 08 00 00 00       	mov    $0x8,%edx
  8008b8:	eb 6b                	jmp    800925 <vprintfmt+0x417>
	else if (lflag)
  8008ba:	85 c9                	test   %ecx,%ecx
  8008bc:	75 1b                	jne    8008d9 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8d 40 04             	lea    0x4(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	eb b6                	jmp    80088f <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8d 40 04             	lea    0x4(%eax),%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f2:	eb 9b                	jmp    80088f <vprintfmt+0x381>
			putch('0', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	6a 30                	push   $0x30
  8008fa:	ff d6                	call   *%esi
			putch('x', putdat);
  8008fc:	83 c4 08             	add    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 78                	push   $0x78
  800902:	ff d6                	call   *%esi
			num = (unsigned long long)
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
  80090e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800911:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800914:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	8d 40 04             	lea    0x4(%eax),%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800920:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800925:	83 ec 0c             	sub    $0xc,%esp
  800928:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80092c:	50                   	push   %eax
  80092d:	ff 75 e0             	pushl  -0x20(%ebp)
  800930:	52                   	push   %edx
  800931:	ff 75 dc             	pushl  -0x24(%ebp)
  800934:	ff 75 d8             	pushl  -0x28(%ebp)
  800937:	89 da                	mov    %ebx,%edx
  800939:	89 f0                	mov    %esi,%eax
  80093b:	e8 e5 fa ff ff       	call   800425 <printnum>
			break;
  800940:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800943:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800946:	83 c7 01             	add    $0x1,%edi
  800949:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80094d:	83 f8 25             	cmp    $0x25,%eax
  800950:	0f 84 cf fb ff ff    	je     800525 <vprintfmt+0x17>
			if (ch == '\0')
  800956:	85 c0                	test   %eax,%eax
  800958:	0f 84 a9 00 00 00    	je     800a07 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	53                   	push   %ebx
  800962:	50                   	push   %eax
  800963:	ff d6                	call   *%esi
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	eb dc                	jmp    800946 <vprintfmt+0x438>
	if (lflag >= 2)
  80096a:	83 f9 01             	cmp    $0x1,%ecx
  80096d:	7e 1e                	jle    80098d <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	8b 50 04             	mov    0x4(%eax),%edx
  800975:	8b 00                	mov    (%eax),%eax
  800977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8d 40 08             	lea    0x8(%eax),%eax
  800983:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800986:	ba 10 00 00 00       	mov    $0x10,%edx
  80098b:	eb 98                	jmp    800925 <vprintfmt+0x417>
	else if (lflag)
  80098d:	85 c9                	test   %ecx,%ecx
  80098f:	75 23                	jne    8009b4 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	8d 40 04             	lea    0x4(%eax),%eax
  8009a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009aa:	ba 10 00 00 00       	mov    $0x10,%edx
  8009af:	e9 71 ff ff ff       	jmp    800925 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009cd:	ba 10 00 00 00       	mov    $0x10,%edx
  8009d2:	e9 4e ff ff ff       	jmp    800925 <vprintfmt+0x417>
			putch(ch, putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	53                   	push   %ebx
  8009db:	6a 25                	push   $0x25
  8009dd:	ff d6                	call   *%esi
			break;
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	e9 5c ff ff ff       	jmp    800943 <vprintfmt+0x435>
			putch('%', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	53                   	push   %ebx
  8009eb:	6a 25                	push   $0x25
  8009ed:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	89 f8                	mov    %edi,%eax
  8009f4:	eb 03                	jmp    8009f9 <vprintfmt+0x4eb>
  8009f6:	83 e8 01             	sub    $0x1,%eax
  8009f9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009fd:	75 f7                	jne    8009f6 <vprintfmt+0x4e8>
  8009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a02:	e9 3c ff ff ff       	jmp    800943 <vprintfmt+0x435>
}
  800a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5f                   	pop    %edi
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	83 ec 18             	sub    $0x18,%esp
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a1e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a22:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a2c:	85 c0                	test   %eax,%eax
  800a2e:	74 26                	je     800a56 <vsnprintf+0x47>
  800a30:	85 d2                	test   %edx,%edx
  800a32:	7e 22                	jle    800a56 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a34:	ff 75 14             	pushl  0x14(%ebp)
  800a37:	ff 75 10             	pushl  0x10(%ebp)
  800a3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a3d:	50                   	push   %eax
  800a3e:	68 d4 04 80 00       	push   $0x8004d4
  800a43:	e8 c6 fa ff ff       	call   80050e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a4b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a51:	83 c4 10             	add    $0x10,%esp
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    
		return -E_INVAL;
  800a56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a5b:	eb f7                	jmp    800a54 <vsnprintf+0x45>

00800a5d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a63:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a66:	50                   	push   %eax
  800a67:	ff 75 10             	pushl  0x10(%ebp)
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	ff 75 08             	pushl  0x8(%ebp)
  800a70:	e8 9a ff ff ff       	call   800a0f <vsnprintf>
	va_end(ap);

	return rc;
}
  800a75:	c9                   	leave  
  800a76:	c3                   	ret    

00800a77 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a82:	eb 03                	jmp    800a87 <strlen+0x10>
		n++;
  800a84:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a87:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a8b:	75 f7                	jne    800a84 <strlen+0xd>
	return n;
}
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a98:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9d:	eb 03                	jmp    800aa2 <strnlen+0x13>
		n++;
  800a9f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa2:	39 d0                	cmp    %edx,%eax
  800aa4:	74 06                	je     800aac <strnlen+0x1d>
  800aa6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800aaa:	75 f3                	jne    800a9f <strnlen+0x10>
	return n;
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	53                   	push   %ebx
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab8:	89 c2                	mov    %eax,%edx
  800aba:	83 c1 01             	add    $0x1,%ecx
  800abd:	83 c2 01             	add    $0x1,%edx
  800ac0:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800ac4:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ac7:	84 db                	test   %bl,%bl
  800ac9:	75 ef                	jne    800aba <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800acb:	5b                   	pop    %ebx
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	53                   	push   %ebx
  800ad2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad5:	53                   	push   %ebx
  800ad6:	e8 9c ff ff ff       	call   800a77 <strlen>
  800adb:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	01 d8                	add    %ebx,%eax
  800ae3:	50                   	push   %eax
  800ae4:	e8 c5 ff ff ff       	call   800aae <strcpy>
	return dst;
}
  800ae9:	89 d8                	mov    %ebx,%eax
  800aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 75 08             	mov    0x8(%ebp),%esi
  800af8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afb:	89 f3                	mov    %esi,%ebx
  800afd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b00:	89 f2                	mov    %esi,%edx
  800b02:	eb 0f                	jmp    800b13 <strncpy+0x23>
		*dst++ = *src;
  800b04:	83 c2 01             	add    $0x1,%edx
  800b07:	0f b6 01             	movzbl (%ecx),%eax
  800b0a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b0d:	80 39 01             	cmpb   $0x1,(%ecx)
  800b10:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b13:	39 da                	cmp    %ebx,%edx
  800b15:	75 ed                	jne    800b04 <strncpy+0x14>
	}
	return ret;
}
  800b17:	89 f0                	mov    %esi,%eax
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
  800b22:	8b 75 08             	mov    0x8(%ebp),%esi
  800b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b2b:	89 f0                	mov    %esi,%eax
  800b2d:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b31:	85 c9                	test   %ecx,%ecx
  800b33:	75 0b                	jne    800b40 <strlcpy+0x23>
  800b35:	eb 17                	jmp    800b4e <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b40:	39 d8                	cmp    %ebx,%eax
  800b42:	74 07                	je     800b4b <strlcpy+0x2e>
  800b44:	0f b6 0a             	movzbl (%edx),%ecx
  800b47:	84 c9                	test   %cl,%cl
  800b49:	75 ec                	jne    800b37 <strlcpy+0x1a>
		*dst = '\0';
  800b4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4e:	29 f0                	sub    %esi,%eax
}
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b5d:	eb 06                	jmp    800b65 <strcmp+0x11>
		p++, q++;
  800b5f:	83 c1 01             	add    $0x1,%ecx
  800b62:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b65:	0f b6 01             	movzbl (%ecx),%eax
  800b68:	84 c0                	test   %al,%al
  800b6a:	74 04                	je     800b70 <strcmp+0x1c>
  800b6c:	3a 02                	cmp    (%edx),%al
  800b6e:	74 ef                	je     800b5f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b70:	0f b6 c0             	movzbl %al,%eax
  800b73:	0f b6 12             	movzbl (%edx),%edx
  800b76:	29 d0                	sub    %edx,%eax
}
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	53                   	push   %ebx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b84:	89 c3                	mov    %eax,%ebx
  800b86:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b89:	eb 06                	jmp    800b91 <strncmp+0x17>
		n--, p++, q++;
  800b8b:	83 c0 01             	add    $0x1,%eax
  800b8e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b91:	39 d8                	cmp    %ebx,%eax
  800b93:	74 16                	je     800bab <strncmp+0x31>
  800b95:	0f b6 08             	movzbl (%eax),%ecx
  800b98:	84 c9                	test   %cl,%cl
  800b9a:	74 04                	je     800ba0 <strncmp+0x26>
  800b9c:	3a 0a                	cmp    (%edx),%cl
  800b9e:	74 eb                	je     800b8b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba0:	0f b6 00             	movzbl (%eax),%eax
  800ba3:	0f b6 12             	movzbl (%edx),%edx
  800ba6:	29 d0                	sub    %edx,%eax
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    
		return 0;
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	eb f6                	jmp    800ba8 <strncmp+0x2e>

00800bb2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bbc:	0f b6 10             	movzbl (%eax),%edx
  800bbf:	84 d2                	test   %dl,%dl
  800bc1:	74 09                	je     800bcc <strchr+0x1a>
		if (*s == c)
  800bc3:	38 ca                	cmp    %cl,%dl
  800bc5:	74 0a                	je     800bd1 <strchr+0x1f>
	for (; *s; s++)
  800bc7:	83 c0 01             	add    $0x1,%eax
  800bca:	eb f0                	jmp    800bbc <strchr+0xa>
			return (char *) s;
	return 0;
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bdd:	eb 03                	jmp    800be2 <strfind+0xf>
  800bdf:	83 c0 01             	add    $0x1,%eax
  800be2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800be5:	38 ca                	cmp    %cl,%dl
  800be7:	74 04                	je     800bed <strfind+0x1a>
  800be9:	84 d2                	test   %dl,%dl
  800beb:	75 f2                	jne    800bdf <strfind+0xc>
			break;
	return (char *) s;
}
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bfb:	85 c9                	test   %ecx,%ecx
  800bfd:	74 13                	je     800c12 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bff:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c05:	75 05                	jne    800c0c <memset+0x1d>
  800c07:	f6 c1 03             	test   $0x3,%cl
  800c0a:	74 0d                	je     800c19 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	fc                   	cld    
  800c10:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c12:	89 f8                	mov    %edi,%eax
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
		c &= 0xFF;
  800c19:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c1d:	89 d3                	mov    %edx,%ebx
  800c1f:	c1 e3 08             	shl    $0x8,%ebx
  800c22:	89 d0                	mov    %edx,%eax
  800c24:	c1 e0 18             	shl    $0x18,%eax
  800c27:	89 d6                	mov    %edx,%esi
  800c29:	c1 e6 10             	shl    $0x10,%esi
  800c2c:	09 f0                	or     %esi,%eax
  800c2e:	09 c2                	or     %eax,%edx
  800c30:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800c32:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c35:	89 d0                	mov    %edx,%eax
  800c37:	fc                   	cld    
  800c38:	f3 ab                	rep stos %eax,%es:(%edi)
  800c3a:	eb d6                	jmp    800c12 <memset+0x23>

00800c3c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c4a:	39 c6                	cmp    %eax,%esi
  800c4c:	73 35                	jae    800c83 <memmove+0x47>
  800c4e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c51:	39 c2                	cmp    %eax,%edx
  800c53:	76 2e                	jbe    800c83 <memmove+0x47>
		s += n;
		d += n;
  800c55:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c58:	89 d6                	mov    %edx,%esi
  800c5a:	09 fe                	or     %edi,%esi
  800c5c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c62:	74 0c                	je     800c70 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c64:	83 ef 01             	sub    $0x1,%edi
  800c67:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c6a:	fd                   	std    
  800c6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c6d:	fc                   	cld    
  800c6e:	eb 21                	jmp    800c91 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c70:	f6 c1 03             	test   $0x3,%cl
  800c73:	75 ef                	jne    800c64 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c75:	83 ef 04             	sub    $0x4,%edi
  800c78:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c7e:	fd                   	std    
  800c7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c81:	eb ea                	jmp    800c6d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c83:	89 f2                	mov    %esi,%edx
  800c85:	09 c2                	or     %eax,%edx
  800c87:	f6 c2 03             	test   $0x3,%dl
  800c8a:	74 09                	je     800c95 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c8c:	89 c7                	mov    %eax,%edi
  800c8e:	fc                   	cld    
  800c8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c95:	f6 c1 03             	test   $0x3,%cl
  800c98:	75 f2                	jne    800c8c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c9d:	89 c7                	mov    %eax,%edi
  800c9f:	fc                   	cld    
  800ca0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca2:	eb ed                	jmp    800c91 <memmove+0x55>

00800ca4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ca7:	ff 75 10             	pushl  0x10(%ebp)
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	ff 75 08             	pushl  0x8(%ebp)
  800cb0:	e8 87 ff ff ff       	call   800c3c <memmove>
}
  800cb5:	c9                   	leave  
  800cb6:	c3                   	ret    

00800cb7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc2:	89 c6                	mov    %eax,%esi
  800cc4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cc7:	39 f0                	cmp    %esi,%eax
  800cc9:	74 1c                	je     800ce7 <memcmp+0x30>
		if (*s1 != *s2)
  800ccb:	0f b6 08             	movzbl (%eax),%ecx
  800cce:	0f b6 1a             	movzbl (%edx),%ebx
  800cd1:	38 d9                	cmp    %bl,%cl
  800cd3:	75 08                	jne    800cdd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cd5:	83 c0 01             	add    $0x1,%eax
  800cd8:	83 c2 01             	add    $0x1,%edx
  800cdb:	eb ea                	jmp    800cc7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cdd:	0f b6 c1             	movzbl %cl,%eax
  800ce0:	0f b6 db             	movzbl %bl,%ebx
  800ce3:	29 d8                	sub    %ebx,%eax
  800ce5:	eb 05                	jmp    800cec <memcmp+0x35>
	}

	return 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cf9:	89 c2                	mov    %eax,%edx
  800cfb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cfe:	39 d0                	cmp    %edx,%eax
  800d00:	73 09                	jae    800d0b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d02:	38 08                	cmp    %cl,(%eax)
  800d04:	74 05                	je     800d0b <memfind+0x1b>
	for (; s < ends; s++)
  800d06:	83 c0 01             	add    $0x1,%eax
  800d09:	eb f3                	jmp    800cfe <memfind+0xe>
			break;
	return (void *) s;
}
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d19:	eb 03                	jmp    800d1e <strtol+0x11>
		s++;
  800d1b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d1e:	0f b6 01             	movzbl (%ecx),%eax
  800d21:	3c 20                	cmp    $0x20,%al
  800d23:	74 f6                	je     800d1b <strtol+0xe>
  800d25:	3c 09                	cmp    $0x9,%al
  800d27:	74 f2                	je     800d1b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d29:	3c 2b                	cmp    $0x2b,%al
  800d2b:	74 2e                	je     800d5b <strtol+0x4e>
	int neg = 0;
  800d2d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d32:	3c 2d                	cmp    $0x2d,%al
  800d34:	74 2f                	je     800d65 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d36:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d3c:	75 05                	jne    800d43 <strtol+0x36>
  800d3e:	80 39 30             	cmpb   $0x30,(%ecx)
  800d41:	74 2c                	je     800d6f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d43:	85 db                	test   %ebx,%ebx
  800d45:	75 0a                	jne    800d51 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d47:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d4c:	80 39 30             	cmpb   $0x30,(%ecx)
  800d4f:	74 28                	je     800d79 <strtol+0x6c>
		base = 10;
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d59:	eb 50                	jmp    800dab <strtol+0x9e>
		s++;
  800d5b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d63:	eb d1                	jmp    800d36 <strtol+0x29>
		s++, neg = 1;
  800d65:	83 c1 01             	add    $0x1,%ecx
  800d68:	bf 01 00 00 00       	mov    $0x1,%edi
  800d6d:	eb c7                	jmp    800d36 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d6f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d73:	74 0e                	je     800d83 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d75:	85 db                	test   %ebx,%ebx
  800d77:	75 d8                	jne    800d51 <strtol+0x44>
		s++, base = 8;
  800d79:	83 c1 01             	add    $0x1,%ecx
  800d7c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d81:	eb ce                	jmp    800d51 <strtol+0x44>
		s += 2, base = 16;
  800d83:	83 c1 02             	add    $0x2,%ecx
  800d86:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d8b:	eb c4                	jmp    800d51 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d8d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d90:	89 f3                	mov    %esi,%ebx
  800d92:	80 fb 19             	cmp    $0x19,%bl
  800d95:	77 29                	ja     800dc0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d97:	0f be d2             	movsbl %dl,%edx
  800d9a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d9d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800da0:	7d 30                	jge    800dd2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800da2:	83 c1 01             	add    $0x1,%ecx
  800da5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800da9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dab:	0f b6 11             	movzbl (%ecx),%edx
  800dae:	8d 72 d0             	lea    -0x30(%edx),%esi
  800db1:	89 f3                	mov    %esi,%ebx
  800db3:	80 fb 09             	cmp    $0x9,%bl
  800db6:	77 d5                	ja     800d8d <strtol+0x80>
			dig = *s - '0';
  800db8:	0f be d2             	movsbl %dl,%edx
  800dbb:	83 ea 30             	sub    $0x30,%edx
  800dbe:	eb dd                	jmp    800d9d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800dc0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dc3:	89 f3                	mov    %esi,%ebx
  800dc5:	80 fb 19             	cmp    $0x19,%bl
  800dc8:	77 08                	ja     800dd2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800dca:	0f be d2             	movsbl %dl,%edx
  800dcd:	83 ea 37             	sub    $0x37,%edx
  800dd0:	eb cb                	jmp    800d9d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd6:	74 05                	je     800ddd <strtol+0xd0>
		*endptr = (char *) s;
  800dd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ddb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ddd:	89 c2                	mov    %eax,%edx
  800ddf:	f7 da                	neg    %edx
  800de1:	85 ff                	test   %edi,%edi
  800de3:	0f 45 c2             	cmovne %edx,%eax
}
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	89 c3                	mov    %eax,%ebx
  800dfe:	89 c7                	mov    %eax,%edi
  800e00:	89 c6                	mov    %eax,%esi
  800e02:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e14:	b8 01 00 00 00       	mov    $0x1,%eax
  800e19:	89 d1                	mov    %edx,%ecx
  800e1b:	89 d3                	mov    %edx,%ebx
  800e1d:	89 d7                	mov    %edx,%edi
  800e1f:	89 d6                	mov    %edx,%esi
  800e21:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	b8 03 00 00 00       	mov    $0x3,%eax
  800e3e:	89 cb                	mov    %ecx,%ebx
  800e40:	89 cf                	mov    %ecx,%edi
  800e42:	89 ce                	mov    %ecx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 03                	push   $0x3
  800e58:	68 3f 2e 80 00       	push   $0x802e3f
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 5c 2e 80 00       	push   $0x802e5c
  800e64:	e8 cd f4 ff ff       	call   800336 <_panic>

00800e69 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e74:	b8 02 00 00 00       	mov    $0x2,%eax
  800e79:	89 d1                	mov    %edx,%ecx
  800e7b:	89 d3                	mov    %edx,%ebx
  800e7d:	89 d7                	mov    %edx,%edi
  800e7f:	89 d6                	mov    %edx,%esi
  800e81:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <sys_yield>:

void
sys_yield(void)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e93:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e98:	89 d1                	mov    %edx,%ecx
  800e9a:	89 d3                	mov    %edx,%ebx
  800e9c:	89 d7                	mov    %edx,%edi
  800e9e:	89 d6                	mov    %edx,%esi
  800ea0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	57                   	push   %edi
  800eab:	56                   	push   %esi
  800eac:	53                   	push   %ebx
  800ead:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb0:	be 00 00 00 00       	mov    $0x0,%esi
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebb:	b8 04 00 00 00       	mov    $0x4,%eax
  800ec0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec3:	89 f7                	mov    %esi,%edi
  800ec5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7f 08                	jg     800ed3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed3:	83 ec 0c             	sub    $0xc,%esp
  800ed6:	50                   	push   %eax
  800ed7:	6a 04                	push   $0x4
  800ed9:	68 3f 2e 80 00       	push   $0x802e3f
  800ede:	6a 23                	push   $0x23
  800ee0:	68 5c 2e 80 00       	push   $0x802e5c
  800ee5:	e8 4c f4 ff ff       	call   800336 <_panic>

00800eea <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
  800ef0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	b8 05 00 00 00       	mov    $0x5,%eax
  800efe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f01:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f04:	8b 75 18             	mov    0x18(%ebp),%esi
  800f07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	7f 08                	jg     800f15 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	50                   	push   %eax
  800f19:	6a 05                	push   $0x5
  800f1b:	68 3f 2e 80 00       	push   $0x802e3f
  800f20:	6a 23                	push   $0x23
  800f22:	68 5c 2e 80 00       	push   $0x802e5c
  800f27:	e8 0a f4 ff ff       	call   800336 <_panic>

00800f2c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
  800f32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f40:	b8 06 00 00 00       	mov    $0x6,%eax
  800f45:	89 df                	mov    %ebx,%edi
  800f47:	89 de                	mov    %ebx,%esi
  800f49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	7f 08                	jg     800f57 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f52:	5b                   	pop    %ebx
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f57:	83 ec 0c             	sub    $0xc,%esp
  800f5a:	50                   	push   %eax
  800f5b:	6a 06                	push   $0x6
  800f5d:	68 3f 2e 80 00       	push   $0x802e3f
  800f62:	6a 23                	push   $0x23
  800f64:	68 5c 2e 80 00       	push   $0x802e5c
  800f69:	e8 c8 f3 ff ff       	call   800336 <_panic>

00800f6e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f82:	b8 08 00 00 00       	mov    $0x8,%eax
  800f87:	89 df                	mov    %ebx,%edi
  800f89:	89 de                	mov    %ebx,%esi
  800f8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	7f 08                	jg     800f99 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f94:	5b                   	pop    %ebx
  800f95:	5e                   	pop    %esi
  800f96:	5f                   	pop    %edi
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f99:	83 ec 0c             	sub    $0xc,%esp
  800f9c:	50                   	push   %eax
  800f9d:	6a 08                	push   $0x8
  800f9f:	68 3f 2e 80 00       	push   $0x802e3f
  800fa4:	6a 23                	push   $0x23
  800fa6:	68 5c 2e 80 00       	push   $0x802e5c
  800fab:	e8 86 f3 ff ff       	call   800336 <_panic>

00800fb0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	7f 08                	jg     800fdb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	50                   	push   %eax
  800fdf:	6a 09                	push   $0x9
  800fe1:	68 3f 2e 80 00       	push   $0x802e3f
  800fe6:	6a 23                	push   $0x23
  800fe8:	68 5c 2e 80 00       	push   $0x802e5c
  800fed:	e8 44 f3 ff ff       	call   800336 <_panic>

00800ff2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
  800ff8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801006:	b8 0a 00 00 00       	mov    $0xa,%eax
  80100b:	89 df                	mov    %ebx,%edi
  80100d:	89 de                	mov    %ebx,%esi
  80100f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801011:	85 c0                	test   %eax,%eax
  801013:	7f 08                	jg     80101d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801015:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	50                   	push   %eax
  801021:	6a 0a                	push   $0xa
  801023:	68 3f 2e 80 00       	push   $0x802e3f
  801028:	6a 23                	push   $0x23
  80102a:	68 5c 2e 80 00       	push   $0x802e5c
  80102f:	e8 02 f3 ff ff       	call   800336 <_panic>

00801034 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	57                   	push   %edi
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103a:	8b 55 08             	mov    0x8(%ebp),%edx
  80103d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801040:	b8 0c 00 00 00       	mov    $0xc,%eax
  801045:	be 00 00 00 00       	mov    $0x0,%esi
  80104a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80104d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801050:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801060:	b9 00 00 00 00       	mov    $0x0,%ecx
  801065:	8b 55 08             	mov    0x8(%ebp),%edx
  801068:	b8 0d 00 00 00       	mov    $0xd,%eax
  80106d:	89 cb                	mov    %ecx,%ebx
  80106f:	89 cf                	mov    %ecx,%edi
  801071:	89 ce                	mov    %ecx,%esi
  801073:	cd 30                	int    $0x30
	if(check && ret > 0)
  801075:	85 c0                	test   %eax,%eax
  801077:	7f 08                	jg     801081 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801079:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	50                   	push   %eax
  801085:	6a 0d                	push   $0xd
  801087:	68 3f 2e 80 00       	push   $0x802e3f
  80108c:	6a 23                	push   $0x23
  80108e:	68 5c 2e 80 00       	push   $0x802e5c
  801093:	e8 9e f2 ff ff       	call   800336 <_panic>

00801098 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	57                   	push   %edi
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109e:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010a8:	89 d1                	mov    %edx,%ecx
  8010aa:	89 d3                	mov    %edx,%ebx
  8010ac:	89 d7                	mov    %edx,%edi
  8010ae:	89 d6                	mov    %edx,%esi
  8010b0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	57                   	push   %edi
  8010bb:	56                   	push   %esi
  8010bc:	53                   	push   %ebx
  8010bd:	83 ec 1c             	sub    $0x1c,%esp
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  8010c3:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  8010c5:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  8010c8:	89 d8                	mov    %ebx,%eax
  8010ca:	c1 e8 0c             	shr    $0xc,%eax
  8010cd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  8010d7:	e8 8d fd ff ff       	call   800e69 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  8010dc:	f7 c7 02 00 00 00    	test   $0x2,%edi
  8010e2:	74 73                	je     801157 <pgfault+0xa0>
  8010e4:	89 c6                	mov    %eax,%esi
  8010e6:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  8010ed:	74 68                	je     801157 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  8010ef:	83 ec 04             	sub    $0x4,%esp
  8010f2:	6a 07                	push   $0x7
  8010f4:	68 00 f0 7f 00       	push   $0x7ff000
  8010f9:	50                   	push   %eax
  8010fa:	e8 a8 fd ff ff       	call   800ea7 <sys_page_alloc>
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	85 c0                	test   %eax,%eax
  801104:	75 65                	jne    80116b <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801106:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	68 00 10 00 00       	push   $0x1000
  801114:	53                   	push   %ebx
  801115:	68 00 f0 7f 00       	push   $0x7ff000
  80111a:	e8 85 fb ff ff       	call   800ca4 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80111f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801126:	53                   	push   %ebx
  801127:	56                   	push   %esi
  801128:	68 00 f0 7f 00       	push   $0x7ff000
  80112d:	56                   	push   %esi
  80112e:	e8 b7 fd ff ff       	call   800eea <sys_page_map>
  801133:	83 c4 20             	add    $0x20,%esp
  801136:	85 c0                	test   %eax,%eax
  801138:	75 43                	jne    80117d <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  80113a:	83 ec 08             	sub    $0x8,%esp
  80113d:	68 00 f0 7f 00       	push   $0x7ff000
  801142:	56                   	push   %esi
  801143:	e8 e4 fd ff ff       	call   800f2c <sys_page_unmap>
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	85 c0                	test   %eax,%eax
  80114d:	75 40                	jne    80118f <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  80114f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801152:	5b                   	pop    %ebx
  801153:	5e                   	pop    %esi
  801154:	5f                   	pop    %edi
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	68 6a 2e 80 00       	push   $0x802e6a
  80115f:	6a 1f                	push   $0x1f
  801161:	68 88 2e 80 00       	push   $0x802e88
  801166:	e8 cb f1 ff ff       	call   800336 <_panic>
	    panic("pgfault: %e", r);
  80116b:	50                   	push   %eax
  80116c:	68 93 2e 80 00       	push   $0x802e93
  801171:	6a 2a                	push   $0x2a
  801173:	68 88 2e 80 00       	push   $0x802e88
  801178:	e8 b9 f1 ff ff       	call   800336 <_panic>
	    panic("pgfault: %e", r);
  80117d:	50                   	push   %eax
  80117e:	68 93 2e 80 00       	push   $0x802e93
  801183:	6a 2e                	push   $0x2e
  801185:	68 88 2e 80 00       	push   $0x802e88
  80118a:	e8 a7 f1 ff ff       	call   800336 <_panic>
	    panic("pgfault: %e", r);
  80118f:	50                   	push   %eax
  801190:	68 93 2e 80 00       	push   $0x802e93
  801195:	6a 31                	push   $0x31
  801197:	68 88 2e 80 00       	push   $0x802e88
  80119c:	e8 95 f1 ff ff       	call   800336 <_panic>

008011a1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	57                   	push   %edi
  8011a5:	56                   	push   %esi
  8011a6:	53                   	push   %ebx
  8011a7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  8011aa:	68 b7 10 80 00       	push   $0x8010b7
  8011af:	e8 dd 13 00 00       	call   802591 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011b4:	b8 07 00 00 00       	mov    $0x7,%eax
  8011b9:	cd 30                	int    $0x30
  8011bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011be:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	78 2b                	js     8011f3 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8011c8:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8011cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011d1:	0f 85 b5 00 00 00    	jne    80128c <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  8011d7:	e8 8d fc ff ff       	call   800e69 <sys_getenvid>
  8011dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011e9:	a3 08 50 80 00       	mov    %eax,0x805008
	    return 0;
  8011ee:	e9 8c 01 00 00       	jmp    80137f <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  8011f3:	50                   	push   %eax
  8011f4:	68 9f 2e 80 00       	push   $0x802e9f
  8011f9:	6a 77                	push   $0x77
  8011fb:	68 88 2e 80 00       	push   $0x802e88
  801200:	e8 31 f1 ff ff       	call   800336 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801205:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	25 07 0e 00 00       	and    $0xe07,%eax
  801214:	50                   	push   %eax
  801215:	57                   	push   %edi
  801216:	ff 75 e0             	pushl  -0x20(%ebp)
  801219:	57                   	push   %edi
  80121a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80121d:	e8 c8 fc ff ff       	call   800eea <sys_page_map>
  801222:	83 c4 20             	add    $0x20,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	74 51                	je     80127a <fork+0xd9>
           panic("duppage: %e", r);
  801229:	50                   	push   %eax
  80122a:	68 af 2e 80 00       	push   $0x802eaf
  80122f:	6a 4a                	push   $0x4a
  801231:	68 88 2e 80 00       	push   $0x802e88
  801236:	e8 fb f0 ff ff       	call   800336 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	68 05 08 00 00       	push   $0x805
  801243:	57                   	push   %edi
  801244:	ff 75 e0             	pushl  -0x20(%ebp)
  801247:	57                   	push   %edi
  801248:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124b:	e8 9a fc ff ff       	call   800eea <sys_page_map>
  801250:	83 c4 20             	add    $0x20,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	0f 85 bc 00 00 00    	jne    801317 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	68 05 08 00 00       	push   $0x805
  801263:	57                   	push   %edi
  801264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801267:	50                   	push   %eax
  801268:	57                   	push   %edi
  801269:	50                   	push   %eax
  80126a:	e8 7b fc ff ff       	call   800eea <sys_page_map>
  80126f:	83 c4 20             	add    $0x20,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	0f 85 af 00 00 00    	jne    801329 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80127a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801280:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801286:	0f 84 af 00 00 00    	je     80133b <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  80128c:	89 d8                	mov    %ebx,%eax
  80128e:	c1 e8 16             	shr    $0x16,%eax
  801291:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801298:	a8 01                	test   $0x1,%al
  80129a:	74 de                	je     80127a <fork+0xd9>
  80129c:	89 de                	mov    %ebx,%esi
  80129e:	c1 ee 0c             	shr    $0xc,%esi
  8012a1:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012a8:	a8 01                	test   $0x1,%al
  8012aa:	74 ce                	je     80127a <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  8012ac:	e8 b8 fb ff ff       	call   800e69 <sys_getenvid>
  8012b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  8012b4:	89 f7                	mov    %esi,%edi
  8012b6:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8012b9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012c0:	f6 c4 04             	test   $0x4,%ah
  8012c3:	0f 85 3c ff ff ff    	jne    801205 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8012c9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012d0:	a8 02                	test   $0x2,%al
  8012d2:	0f 85 63 ff ff ff    	jne    80123b <fork+0x9a>
  8012d8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012df:	f6 c4 08             	test   $0x8,%ah
  8012e2:	0f 85 53 ff ff ff    	jne    80123b <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	6a 05                	push   $0x5
  8012ed:	57                   	push   %edi
  8012ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8012f1:	57                   	push   %edi
  8012f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012f5:	e8 f0 fb ff ff       	call   800eea <sys_page_map>
  8012fa:	83 c4 20             	add    $0x20,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	0f 84 75 ff ff ff    	je     80127a <fork+0xd9>
	        panic("duppage: %e", r);
  801305:	50                   	push   %eax
  801306:	68 af 2e 80 00       	push   $0x802eaf
  80130b:	6a 55                	push   $0x55
  80130d:	68 88 2e 80 00       	push   $0x802e88
  801312:	e8 1f f0 ff ff       	call   800336 <_panic>
	        panic("duppage: %e", r);
  801317:	50                   	push   %eax
  801318:	68 af 2e 80 00       	push   $0x802eaf
  80131d:	6a 4e                	push   $0x4e
  80131f:	68 88 2e 80 00       	push   $0x802e88
  801324:	e8 0d f0 ff ff       	call   800336 <_panic>
	        panic("duppage: %e", r);
  801329:	50                   	push   %eax
  80132a:	68 af 2e 80 00       	push   $0x802eaf
  80132f:	6a 51                	push   $0x51
  801331:	68 88 2e 80 00       	push   $0x802e88
  801336:	e8 fb ef ff ff       	call   800336 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80133b:	83 ec 04             	sub    $0x4,%esp
  80133e:	6a 07                	push   $0x7
  801340:	68 00 f0 bf ee       	push   $0xeebff000
  801345:	ff 75 dc             	pushl  -0x24(%ebp)
  801348:	e8 5a fb ff ff       	call   800ea7 <sys_page_alloc>
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	75 36                	jne    80138a <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  801354:	83 ec 08             	sub    $0x8,%esp
  801357:	68 0a 26 80 00       	push   $0x80260a
  80135c:	ff 75 dc             	pushl  -0x24(%ebp)
  80135f:	e8 8e fc ff ff       	call   800ff2 <sys_env_set_pgfault_upcall>
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	75 34                	jne    80139f <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	6a 02                	push   $0x2
  801370:	ff 75 dc             	pushl  -0x24(%ebp)
  801373:	e8 f6 fb ff ff       	call   800f6e <sys_env_set_status>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	75 35                	jne    8013b4 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  80137f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    
	    panic("fork: %e", r);
  80138a:	50                   	push   %eax
  80138b:	68 a6 2e 80 00       	push   $0x802ea6
  801390:	68 8a 00 00 00       	push   $0x8a
  801395:	68 88 2e 80 00       	push   $0x802e88
  80139a:	e8 97 ef ff ff       	call   800336 <_panic>
	    panic("fork: %e", r);
  80139f:	50                   	push   %eax
  8013a0:	68 a6 2e 80 00       	push   $0x802ea6
  8013a5:	68 8d 00 00 00       	push   $0x8d
  8013aa:	68 88 2e 80 00       	push   $0x802e88
  8013af:	e8 82 ef ff ff       	call   800336 <_panic>
	    panic("fork: %e", r);
  8013b4:	50                   	push   %eax
  8013b5:	68 a6 2e 80 00       	push   $0x802ea6
  8013ba:	68 92 00 00 00       	push   $0x92
  8013bf:	68 88 2e 80 00       	push   $0x802e88
  8013c4:	e8 6d ef ff ff       	call   800336 <_panic>

008013c9 <sfork>:

// Challenge!
int
sfork(void)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8013cf:	68 bb 2e 80 00       	push   $0x802ebb
  8013d4:	68 9b 00 00 00       	push   $0x9b
  8013d9:	68 88 2e 80 00       	push   $0x802e88
  8013de:	e8 53 ef ff ff       	call   800336 <_panic>

008013e3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ee:	c1 e8 0c             	shr    $0xc,%eax
}
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    

008013f3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801403:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    

0080140a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801410:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801415:	89 c2                	mov    %eax,%edx
  801417:	c1 ea 16             	shr    $0x16,%edx
  80141a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801421:	f6 c2 01             	test   $0x1,%dl
  801424:	74 2a                	je     801450 <fd_alloc+0x46>
  801426:	89 c2                	mov    %eax,%edx
  801428:	c1 ea 0c             	shr    $0xc,%edx
  80142b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801432:	f6 c2 01             	test   $0x1,%dl
  801435:	74 19                	je     801450 <fd_alloc+0x46>
  801437:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80143c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801441:	75 d2                	jne    801415 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801443:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801449:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80144e:	eb 07                	jmp    801457 <fd_alloc+0x4d>
			*fd_store = fd;
  801450:	89 01                	mov    %eax,(%ecx)
			return 0;
  801452:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80145f:	83 f8 1f             	cmp    $0x1f,%eax
  801462:	77 36                	ja     80149a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801464:	c1 e0 0c             	shl    $0xc,%eax
  801467:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80146c:	89 c2                	mov    %eax,%edx
  80146e:	c1 ea 16             	shr    $0x16,%edx
  801471:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801478:	f6 c2 01             	test   $0x1,%dl
  80147b:	74 24                	je     8014a1 <fd_lookup+0x48>
  80147d:	89 c2                	mov    %eax,%edx
  80147f:	c1 ea 0c             	shr    $0xc,%edx
  801482:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801489:	f6 c2 01             	test   $0x1,%dl
  80148c:	74 1a                	je     8014a8 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80148e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801491:	89 02                	mov    %eax,(%edx)
	return 0;
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    
		return -E_INVAL;
  80149a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149f:	eb f7                	jmp    801498 <fd_lookup+0x3f>
		return -E_INVAL;
  8014a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a6:	eb f0                	jmp    801498 <fd_lookup+0x3f>
  8014a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ad:	eb e9                	jmp    801498 <fd_lookup+0x3f>

008014af <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014b8:	ba 50 2f 80 00       	mov    $0x802f50,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014bd:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014c2:	39 08                	cmp    %ecx,(%eax)
  8014c4:	74 33                	je     8014f9 <dev_lookup+0x4a>
  8014c6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014c9:	8b 02                	mov    (%edx),%eax
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	75 f3                	jne    8014c2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8014d4:	8b 40 48             	mov    0x48(%eax),%eax
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	51                   	push   %ecx
  8014db:	50                   	push   %eax
  8014dc:	68 d4 2e 80 00       	push   $0x802ed4
  8014e1:	e8 2b ef ff ff       	call   800411 <cprintf>
	*dev = 0;
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    
			*dev = devtab[i];
  8014f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801503:	eb f2                	jmp    8014f7 <dev_lookup+0x48>

00801505 <fd_close>:
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	57                   	push   %edi
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
  80150b:	83 ec 1c             	sub    $0x1c,%esp
  80150e:	8b 75 08             	mov    0x8(%ebp),%esi
  801511:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801514:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801517:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801518:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80151e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801521:	50                   	push   %eax
  801522:	e8 32 ff ff ff       	call   801459 <fd_lookup>
  801527:	89 c3                	mov    %eax,%ebx
  801529:	83 c4 08             	add    $0x8,%esp
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 05                	js     801535 <fd_close+0x30>
	    || fd != fd2)
  801530:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801533:	74 16                	je     80154b <fd_close+0x46>
		return (must_exist ? r : 0);
  801535:	89 f8                	mov    %edi,%eax
  801537:	84 c0                	test   %al,%al
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	0f 44 d8             	cmove  %eax,%ebx
}
  801541:	89 d8                	mov    %ebx,%eax
  801543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5f                   	pop    %edi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	ff 36                	pushl  (%esi)
  801554:	e8 56 ff ff ff       	call   8014af <dev_lookup>
  801559:	89 c3                	mov    %eax,%ebx
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	78 15                	js     801577 <fd_close+0x72>
		if (dev->dev_close)
  801562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801565:	8b 40 10             	mov    0x10(%eax),%eax
  801568:	85 c0                	test   %eax,%eax
  80156a:	74 1b                	je     801587 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	56                   	push   %esi
  801570:	ff d0                	call   *%eax
  801572:	89 c3                	mov    %eax,%ebx
  801574:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801577:	83 ec 08             	sub    $0x8,%esp
  80157a:	56                   	push   %esi
  80157b:	6a 00                	push   $0x0
  80157d:	e8 aa f9 ff ff       	call   800f2c <sys_page_unmap>
	return r;
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	eb ba                	jmp    801541 <fd_close+0x3c>
			r = 0;
  801587:	bb 00 00 00 00       	mov    $0x0,%ebx
  80158c:	eb e9                	jmp    801577 <fd_close+0x72>

0080158e <close>:

int
close(int fdnum)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801597:	50                   	push   %eax
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 b9 fe ff ff       	call   801459 <fd_lookup>
  8015a0:	83 c4 08             	add    $0x8,%esp
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 10                	js     8015b7 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	6a 01                	push   $0x1
  8015ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8015af:	e8 51 ff ff ff       	call   801505 <fd_close>
  8015b4:	83 c4 10             	add    $0x10,%esp
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <close_all>:

void
close_all(void)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	53                   	push   %ebx
  8015c9:	e8 c0 ff ff ff       	call   80158e <close>
	for (i = 0; i < MAXFD; i++)
  8015ce:	83 c3 01             	add    $0x1,%ebx
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	83 fb 20             	cmp    $0x20,%ebx
  8015d7:	75 ec                	jne    8015c5 <close_all+0xc>
}
  8015d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	57                   	push   %edi
  8015e2:	56                   	push   %esi
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 66 fe ff ff       	call   801459 <fd_lookup>
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 08             	add    $0x8,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	0f 88 81 00 00 00    	js     801681 <dup+0xa3>
		return r;
	close(newfdnum);
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	e8 83 ff ff ff       	call   80158e <close>

	newfd = INDEX2FD(newfdnum);
  80160b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80160e:	c1 e6 0c             	shl    $0xc,%esi
  801611:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801617:	83 c4 04             	add    $0x4,%esp
  80161a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80161d:	e8 d1 fd ff ff       	call   8013f3 <fd2data>
  801622:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801624:	89 34 24             	mov    %esi,(%esp)
  801627:	e8 c7 fd ff ff       	call   8013f3 <fd2data>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801631:	89 d8                	mov    %ebx,%eax
  801633:	c1 e8 16             	shr    $0x16,%eax
  801636:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80163d:	a8 01                	test   $0x1,%al
  80163f:	74 11                	je     801652 <dup+0x74>
  801641:	89 d8                	mov    %ebx,%eax
  801643:	c1 e8 0c             	shr    $0xc,%eax
  801646:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80164d:	f6 c2 01             	test   $0x1,%dl
  801650:	75 39                	jne    80168b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801655:	89 d0                	mov    %edx,%eax
  801657:	c1 e8 0c             	shr    $0xc,%eax
  80165a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	25 07 0e 00 00       	and    $0xe07,%eax
  801669:	50                   	push   %eax
  80166a:	56                   	push   %esi
  80166b:	6a 00                	push   $0x0
  80166d:	52                   	push   %edx
  80166e:	6a 00                	push   $0x0
  801670:	e8 75 f8 ff ff       	call   800eea <sys_page_map>
  801675:	89 c3                	mov    %eax,%ebx
  801677:	83 c4 20             	add    $0x20,%esp
  80167a:	85 c0                	test   %eax,%eax
  80167c:	78 31                	js     8016af <dup+0xd1>
		goto err;

	return newfdnum;
  80167e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801681:	89 d8                	mov    %ebx,%eax
  801683:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801686:	5b                   	pop    %ebx
  801687:	5e                   	pop    %esi
  801688:	5f                   	pop    %edi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80168b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	25 07 0e 00 00       	and    $0xe07,%eax
  80169a:	50                   	push   %eax
  80169b:	57                   	push   %edi
  80169c:	6a 00                	push   $0x0
  80169e:	53                   	push   %ebx
  80169f:	6a 00                	push   $0x0
  8016a1:	e8 44 f8 ff ff       	call   800eea <sys_page_map>
  8016a6:	89 c3                	mov    %eax,%ebx
  8016a8:	83 c4 20             	add    $0x20,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	79 a3                	jns    801652 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	56                   	push   %esi
  8016b3:	6a 00                	push   $0x0
  8016b5:	e8 72 f8 ff ff       	call   800f2c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016ba:	83 c4 08             	add    $0x8,%esp
  8016bd:	57                   	push   %edi
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 67 f8 ff ff       	call   800f2c <sys_page_unmap>
	return r;
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	eb b7                	jmp    801681 <dup+0xa3>

008016ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 14             	sub    $0x14,%esp
  8016d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d7:	50                   	push   %eax
  8016d8:	53                   	push   %ebx
  8016d9:	e8 7b fd ff ff       	call   801459 <fd_lookup>
  8016de:	83 c4 08             	add    $0x8,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 3f                	js     801724 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e5:	83 ec 08             	sub    $0x8,%esp
  8016e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016eb:	50                   	push   %eax
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	ff 30                	pushl  (%eax)
  8016f1:	e8 b9 fd ff ff       	call   8014af <dev_lookup>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 27                	js     801724 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801700:	8b 42 08             	mov    0x8(%edx),%eax
  801703:	83 e0 03             	and    $0x3,%eax
  801706:	83 f8 01             	cmp    $0x1,%eax
  801709:	74 1e                	je     801729 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170e:	8b 40 08             	mov    0x8(%eax),%eax
  801711:	85 c0                	test   %eax,%eax
  801713:	74 35                	je     80174a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	ff 75 10             	pushl  0x10(%ebp)
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	52                   	push   %edx
  80171f:	ff d0                	call   *%eax
  801721:	83 c4 10             	add    $0x10,%esp
}
  801724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801727:	c9                   	leave  
  801728:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801729:	a1 08 50 80 00       	mov    0x805008,%eax
  80172e:	8b 40 48             	mov    0x48(%eax),%eax
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	53                   	push   %ebx
  801735:	50                   	push   %eax
  801736:	68 15 2f 80 00       	push   $0x802f15
  80173b:	e8 d1 ec ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801748:	eb da                	jmp    801724 <read+0x5a>
		return -E_NOT_SUPP;
  80174a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174f:	eb d3                	jmp    801724 <read+0x5a>

00801751 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	57                   	push   %edi
  801755:	56                   	push   %esi
  801756:	53                   	push   %ebx
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80175d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801760:	bb 00 00 00 00       	mov    $0x0,%ebx
  801765:	39 f3                	cmp    %esi,%ebx
  801767:	73 25                	jae    80178e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	89 f0                	mov    %esi,%eax
  80176e:	29 d8                	sub    %ebx,%eax
  801770:	50                   	push   %eax
  801771:	89 d8                	mov    %ebx,%eax
  801773:	03 45 0c             	add    0xc(%ebp),%eax
  801776:	50                   	push   %eax
  801777:	57                   	push   %edi
  801778:	e8 4d ff ff ff       	call   8016ca <read>
		if (m < 0)
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	85 c0                	test   %eax,%eax
  801782:	78 08                	js     80178c <readn+0x3b>
			return m;
		if (m == 0)
  801784:	85 c0                	test   %eax,%eax
  801786:	74 06                	je     80178e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801788:	01 c3                	add    %eax,%ebx
  80178a:	eb d9                	jmp    801765 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80178c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80178e:	89 d8                	mov    %ebx,%eax
  801790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5f                   	pop    %edi
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    

00801798 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	53                   	push   %ebx
  80179c:	83 ec 14             	sub    $0x14,%esp
  80179f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a5:	50                   	push   %eax
  8017a6:	53                   	push   %ebx
  8017a7:	e8 ad fc ff ff       	call   801459 <fd_lookup>
  8017ac:	83 c4 08             	add    $0x8,%esp
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 3a                	js     8017ed <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b9:	50                   	push   %eax
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bd:	ff 30                	pushl  (%eax)
  8017bf:	e8 eb fc ff ff       	call   8014af <dev_lookup>
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 22                	js     8017ed <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017d2:	74 1e                	je     8017f2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8017da:	85 d2                	test   %edx,%edx
  8017dc:	74 35                	je     801813 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017de:	83 ec 04             	sub    $0x4,%esp
  8017e1:	ff 75 10             	pushl  0x10(%ebp)
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	50                   	push   %eax
  8017e8:	ff d2                	call   *%edx
  8017ea:	83 c4 10             	add    $0x10,%esp
}
  8017ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017f2:	a1 08 50 80 00       	mov    0x805008,%eax
  8017f7:	8b 40 48             	mov    0x48(%eax),%eax
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	53                   	push   %ebx
  8017fe:	50                   	push   %eax
  8017ff:	68 31 2f 80 00       	push   $0x802f31
  801804:	e8 08 ec ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801811:	eb da                	jmp    8017ed <write+0x55>
		return -E_NOT_SUPP;
  801813:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801818:	eb d3                	jmp    8017ed <write+0x55>

0080181a <seek>:

int
seek(int fdnum, off_t offset)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801820:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801823:	50                   	push   %eax
  801824:	ff 75 08             	pushl  0x8(%ebp)
  801827:	e8 2d fc ff ff       	call   801459 <fd_lookup>
  80182c:	83 c4 08             	add    $0x8,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 0e                	js     801841 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801833:	8b 55 0c             	mov    0xc(%ebp),%edx
  801836:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801839:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	53                   	push   %ebx
  801847:	83 ec 14             	sub    $0x14,%esp
  80184a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801850:	50                   	push   %eax
  801851:	53                   	push   %ebx
  801852:	e8 02 fc ff ff       	call   801459 <fd_lookup>
  801857:	83 c4 08             	add    $0x8,%esp
  80185a:	85 c0                	test   %eax,%eax
  80185c:	78 37                	js     801895 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185e:	83 ec 08             	sub    $0x8,%esp
  801861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801864:	50                   	push   %eax
  801865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801868:	ff 30                	pushl  (%eax)
  80186a:	e8 40 fc ff ff       	call   8014af <dev_lookup>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	78 1f                	js     801895 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80187d:	74 1b                	je     80189a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80187f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801882:	8b 52 18             	mov    0x18(%edx),%edx
  801885:	85 d2                	test   %edx,%edx
  801887:	74 32                	je     8018bb <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	50                   	push   %eax
  801890:	ff d2                	call   *%edx
  801892:	83 c4 10             	add    $0x10,%esp
}
  801895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801898:	c9                   	leave  
  801899:	c3                   	ret    
			thisenv->env_id, fdnum);
  80189a:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80189f:	8b 40 48             	mov    0x48(%eax),%eax
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	53                   	push   %ebx
  8018a6:	50                   	push   %eax
  8018a7:	68 f4 2e 80 00       	push   $0x802ef4
  8018ac:	e8 60 eb ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b9:	eb da                	jmp    801895 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c0:	eb d3                	jmp    801895 <ftruncate+0x52>

008018c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 14             	sub    $0x14,%esp
  8018c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cf:	50                   	push   %eax
  8018d0:	ff 75 08             	pushl  0x8(%ebp)
  8018d3:	e8 81 fb ff ff       	call   801459 <fd_lookup>
  8018d8:	83 c4 08             	add    $0x8,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 4b                	js     80192a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018df:	83 ec 08             	sub    $0x8,%esp
  8018e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e5:	50                   	push   %eax
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e9:	ff 30                	pushl  (%eax)
  8018eb:	e8 bf fb ff ff       	call   8014af <dev_lookup>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 33                	js     80192a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018fe:	74 2f                	je     80192f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801900:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801903:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80190a:	00 00 00 
	stat->st_isdir = 0;
  80190d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801914:	00 00 00 
	stat->st_dev = dev;
  801917:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	53                   	push   %ebx
  801921:	ff 75 f0             	pushl  -0x10(%ebp)
  801924:	ff 50 14             	call   *0x14(%eax)
  801927:	83 c4 10             	add    $0x10,%esp
}
  80192a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    
		return -E_NOT_SUPP;
  80192f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801934:	eb f4                	jmp    80192a <fstat+0x68>

00801936 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	56                   	push   %esi
  80193a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80193b:	83 ec 08             	sub    $0x8,%esp
  80193e:	6a 00                	push   $0x0
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	e8 26 02 00 00       	call   801b6e <open>
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 1b                	js     80196c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	50                   	push   %eax
  801958:	e8 65 ff ff ff       	call   8018c2 <fstat>
  80195d:	89 c6                	mov    %eax,%esi
	close(fd);
  80195f:	89 1c 24             	mov    %ebx,(%esp)
  801962:	e8 27 fc ff ff       	call   80158e <close>
	return r;
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	89 f3                	mov    %esi,%ebx
}
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
  80197a:	89 c6                	mov    %eax,%esi
  80197c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80197e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801985:	74 27                	je     8019ae <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801987:	6a 07                	push   $0x7
  801989:	68 00 60 80 00       	push   $0x806000
  80198e:	56                   	push   %esi
  80198f:	ff 35 00 50 80 00    	pushl  0x805000
  801995:	e8 ff 0c 00 00       	call   802699 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80199a:	83 c4 0c             	add    $0xc,%esp
  80199d:	6a 00                	push   $0x0
  80199f:	53                   	push   %ebx
  8019a0:	6a 00                	push   $0x0
  8019a2:	e8 89 0c 00 00       	call   802630 <ipc_recv>
}
  8019a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019aa:	5b                   	pop    %ebx
  8019ab:	5e                   	pop    %esi
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019ae:	83 ec 0c             	sub    $0xc,%esp
  8019b1:	6a 01                	push   $0x1
  8019b3:	e8 3a 0d 00 00       	call   8026f2 <ipc_find_env>
  8019b8:	a3 00 50 80 00       	mov    %eax,0x805000
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	eb c5                	jmp    801987 <fsipc+0x12>

008019c2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ce:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d6:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019db:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e0:	b8 02 00 00 00       	mov    $0x2,%eax
  8019e5:	e8 8b ff ff ff       	call   801975 <fsipc>
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <devfile_flush>:
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f8:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801a02:	b8 06 00 00 00       	mov    $0x6,%eax
  801a07:	e8 69 ff ff ff       	call   801975 <fsipc>
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <devfile_stat>:
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	53                   	push   %ebx
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	b8 05 00 00 00       	mov    $0x5,%eax
  801a2d:	e8 43 ff ff ff       	call   801975 <fsipc>
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 2c                	js     801a62 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a36:	83 ec 08             	sub    $0x8,%esp
  801a39:	68 00 60 80 00       	push   $0x806000
  801a3e:	53                   	push   %ebx
  801a3f:	e8 6a f0 ff ff       	call   800aae <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a44:	a1 80 60 80 00       	mov    0x806080,%eax
  801a49:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a4f:	a1 84 60 80 00       	mov    0x806084,%eax
  801a54:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <devfile_write>:
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	53                   	push   %ebx
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8b 40 0c             	mov    0xc(%eax),%eax
  801a77:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801a7c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a82:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a88:	77 30                	ja     801aba <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	53                   	push   %ebx
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	68 08 60 80 00       	push   $0x806008
  801a96:	e8 a1 f1 ff ff       	call   800c3c <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	b8 04 00 00 00       	mov    $0x4,%eax
  801aa5:	e8 cb fe ff ff       	call   801975 <fsipc>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 04                	js     801ab5 <devfile_write+0x4e>
	assert(r <= n);
  801ab1:	39 d8                	cmp    %ebx,%eax
  801ab3:	77 1e                	ja     801ad3 <devfile_write+0x6c>
}
  801ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801aba:	68 64 2f 80 00       	push   $0x802f64
  801abf:	68 94 2f 80 00       	push   $0x802f94
  801ac4:	68 94 00 00 00       	push   $0x94
  801ac9:	68 a9 2f 80 00       	push   $0x802fa9
  801ace:	e8 63 e8 ff ff       	call   800336 <_panic>
	assert(r <= n);
  801ad3:	68 b4 2f 80 00       	push   $0x802fb4
  801ad8:	68 94 2f 80 00       	push   $0x802f94
  801add:	68 98 00 00 00       	push   $0x98
  801ae2:	68 a9 2f 80 00       	push   $0x802fa9
  801ae7:	e8 4a e8 ff ff       	call   800336 <_panic>

00801aec <devfile_read>:
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	56                   	push   %esi
  801af0:	53                   	push   %ebx
  801af1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	8b 40 0c             	mov    0xc(%eax),%eax
  801afa:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801aff:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b05:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801b0f:	e8 61 fe ff ff       	call   801975 <fsipc>
  801b14:	89 c3                	mov    %eax,%ebx
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 1f                	js     801b39 <devfile_read+0x4d>
	assert(r <= n);
  801b1a:	39 f0                	cmp    %esi,%eax
  801b1c:	77 24                	ja     801b42 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b1e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b23:	7f 33                	jg     801b58 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	50                   	push   %eax
  801b29:	68 00 60 80 00       	push   $0x806000
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	e8 06 f1 ff ff       	call   800c3c <memmove>
	return r;
  801b36:	83 c4 10             	add    $0x10,%esp
}
  801b39:	89 d8                	mov    %ebx,%eax
  801b3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    
	assert(r <= n);
  801b42:	68 b4 2f 80 00       	push   $0x802fb4
  801b47:	68 94 2f 80 00       	push   $0x802f94
  801b4c:	6a 7c                	push   $0x7c
  801b4e:	68 a9 2f 80 00       	push   $0x802fa9
  801b53:	e8 de e7 ff ff       	call   800336 <_panic>
	assert(r <= PGSIZE);
  801b58:	68 bb 2f 80 00       	push   $0x802fbb
  801b5d:	68 94 2f 80 00       	push   $0x802f94
  801b62:	6a 7d                	push   $0x7d
  801b64:	68 a9 2f 80 00       	push   $0x802fa9
  801b69:	e8 c8 e7 ff ff       	call   800336 <_panic>

00801b6e <open>:
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	83 ec 1c             	sub    $0x1c,%esp
  801b76:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b79:	56                   	push   %esi
  801b7a:	e8 f8 ee ff ff       	call   800a77 <strlen>
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b87:	7f 6c                	jg     801bf5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b89:	83 ec 0c             	sub    $0xc,%esp
  801b8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8f:	50                   	push   %eax
  801b90:	e8 75 f8 ff ff       	call   80140a <fd_alloc>
  801b95:	89 c3                	mov    %eax,%ebx
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 3c                	js     801bda <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	56                   	push   %esi
  801ba2:	68 00 60 80 00       	push   $0x806000
  801ba7:	e8 02 ef ff ff       	call   800aae <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801baf:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbc:	e8 b4 fd ff ff       	call   801975 <fsipc>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 19                	js     801be3 <open+0x75>
	return fd2num(fd);
  801bca:	83 ec 0c             	sub    $0xc,%esp
  801bcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd0:	e8 0e f8 ff ff       	call   8013e3 <fd2num>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
}
  801bda:	89 d8                	mov    %ebx,%eax
  801bdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    
		fd_close(fd, 0);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 f4             	pushl  -0xc(%ebp)
  801beb:	e8 15 f9 ff ff       	call   801505 <fd_close>
		return r;
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	eb e5                	jmp    801bda <open+0x6c>
		return -E_BAD_PATH;
  801bf5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bfa:	eb de                	jmp    801bda <open+0x6c>

00801bfc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
  801c07:	b8 08 00 00 00       	mov    $0x8,%eax
  801c0c:	e8 64 fd ff ff       	call   801975 <fsipc>
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	56                   	push   %esi
  801c17:	53                   	push   %ebx
  801c18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c1b:	83 ec 0c             	sub    $0xc,%esp
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 cd f7 ff ff       	call   8013f3 <fd2data>
  801c26:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c28:	83 c4 08             	add    $0x8,%esp
  801c2b:	68 c7 2f 80 00       	push   $0x802fc7
  801c30:	53                   	push   %ebx
  801c31:	e8 78 ee ff ff       	call   800aae <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c36:	8b 46 04             	mov    0x4(%esi),%eax
  801c39:	2b 06                	sub    (%esi),%eax
  801c3b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c41:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c48:	00 00 00 
	stat->st_dev = &devpipe;
  801c4b:	c7 83 88 00 00 00 24 	movl   $0x804024,0x88(%ebx)
  801c52:	40 80 00 
	return 0;
}
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5d:	5b                   	pop    %ebx
  801c5e:	5e                   	pop    %esi
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    

00801c61 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	53                   	push   %ebx
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c6b:	53                   	push   %ebx
  801c6c:	6a 00                	push   $0x0
  801c6e:	e8 b9 f2 ff ff       	call   800f2c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c73:	89 1c 24             	mov    %ebx,(%esp)
  801c76:	e8 78 f7 ff ff       	call   8013f3 <fd2data>
  801c7b:	83 c4 08             	add    $0x8,%esp
  801c7e:	50                   	push   %eax
  801c7f:	6a 00                	push   $0x0
  801c81:	e8 a6 f2 ff ff       	call   800f2c <sys_page_unmap>
}
  801c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <_pipeisclosed>:
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	57                   	push   %edi
  801c8f:	56                   	push   %esi
  801c90:	53                   	push   %ebx
  801c91:	83 ec 1c             	sub    $0x1c,%esp
  801c94:	89 c7                	mov    %eax,%edi
  801c96:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c98:	a1 08 50 80 00       	mov    0x805008,%eax
  801c9d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	57                   	push   %edi
  801ca4:	e8 82 0a 00 00       	call   80272b <pageref>
  801ca9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cac:	89 34 24             	mov    %esi,(%esp)
  801caf:	e8 77 0a 00 00       	call   80272b <pageref>
		nn = thisenv->env_runs;
  801cb4:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801cba:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	39 cb                	cmp    %ecx,%ebx
  801cc2:	74 1b                	je     801cdf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cc4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cc7:	75 cf                	jne    801c98 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cc9:	8b 42 58             	mov    0x58(%edx),%eax
  801ccc:	6a 01                	push   $0x1
  801cce:	50                   	push   %eax
  801ccf:	53                   	push   %ebx
  801cd0:	68 ce 2f 80 00       	push   $0x802fce
  801cd5:	e8 37 e7 ff ff       	call   800411 <cprintf>
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	eb b9                	jmp    801c98 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cdf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ce2:	0f 94 c0             	sete   %al
  801ce5:	0f b6 c0             	movzbl %al,%eax
}
  801ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <devpipe_write>:
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	57                   	push   %edi
  801cf4:	56                   	push   %esi
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 28             	sub    $0x28,%esp
  801cf9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cfc:	56                   	push   %esi
  801cfd:	e8 f1 f6 ff ff       	call   8013f3 <fd2data>
  801d02:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	bf 00 00 00 00       	mov    $0x0,%edi
  801d0c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d0f:	74 4f                	je     801d60 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d11:	8b 43 04             	mov    0x4(%ebx),%eax
  801d14:	8b 0b                	mov    (%ebx),%ecx
  801d16:	8d 51 20             	lea    0x20(%ecx),%edx
  801d19:	39 d0                	cmp    %edx,%eax
  801d1b:	72 14                	jb     801d31 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d1d:	89 da                	mov    %ebx,%edx
  801d1f:	89 f0                	mov    %esi,%eax
  801d21:	e8 65 ff ff ff       	call   801c8b <_pipeisclosed>
  801d26:	85 c0                	test   %eax,%eax
  801d28:	75 3a                	jne    801d64 <devpipe_write+0x74>
			sys_yield();
  801d2a:	e8 59 f1 ff ff       	call   800e88 <sys_yield>
  801d2f:	eb e0                	jmp    801d11 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d34:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d38:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d3b:	89 c2                	mov    %eax,%edx
  801d3d:	c1 fa 1f             	sar    $0x1f,%edx
  801d40:	89 d1                	mov    %edx,%ecx
  801d42:	c1 e9 1b             	shr    $0x1b,%ecx
  801d45:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d48:	83 e2 1f             	and    $0x1f,%edx
  801d4b:	29 ca                	sub    %ecx,%edx
  801d4d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d51:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d55:	83 c0 01             	add    $0x1,%eax
  801d58:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d5b:	83 c7 01             	add    $0x1,%edi
  801d5e:	eb ac                	jmp    801d0c <devpipe_write+0x1c>
	return i;
  801d60:	89 f8                	mov    %edi,%eax
  801d62:	eb 05                	jmp    801d69 <devpipe_write+0x79>
				return 0;
  801d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5f                   	pop    %edi
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <devpipe_read>:
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	57                   	push   %edi
  801d75:	56                   	push   %esi
  801d76:	53                   	push   %ebx
  801d77:	83 ec 18             	sub    $0x18,%esp
  801d7a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d7d:	57                   	push   %edi
  801d7e:	e8 70 f6 ff ff       	call   8013f3 <fd2data>
  801d83:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	be 00 00 00 00       	mov    $0x0,%esi
  801d8d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d90:	74 47                	je     801dd9 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d92:	8b 03                	mov    (%ebx),%eax
  801d94:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d97:	75 22                	jne    801dbb <devpipe_read+0x4a>
			if (i > 0)
  801d99:	85 f6                	test   %esi,%esi
  801d9b:	75 14                	jne    801db1 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d9d:	89 da                	mov    %ebx,%edx
  801d9f:	89 f8                	mov    %edi,%eax
  801da1:	e8 e5 fe ff ff       	call   801c8b <_pipeisclosed>
  801da6:	85 c0                	test   %eax,%eax
  801da8:	75 33                	jne    801ddd <devpipe_read+0x6c>
			sys_yield();
  801daa:	e8 d9 f0 ff ff       	call   800e88 <sys_yield>
  801daf:	eb e1                	jmp    801d92 <devpipe_read+0x21>
				return i;
  801db1:	89 f0                	mov    %esi,%eax
}
  801db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5e                   	pop    %esi
  801db8:	5f                   	pop    %edi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dbb:	99                   	cltd   
  801dbc:	c1 ea 1b             	shr    $0x1b,%edx
  801dbf:	01 d0                	add    %edx,%eax
  801dc1:	83 e0 1f             	and    $0x1f,%eax
  801dc4:	29 d0                	sub    %edx,%eax
  801dc6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dce:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dd1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dd4:	83 c6 01             	add    $0x1,%esi
  801dd7:	eb b4                	jmp    801d8d <devpipe_read+0x1c>
	return i;
  801dd9:	89 f0                	mov    %esi,%eax
  801ddb:	eb d6                	jmp    801db3 <devpipe_read+0x42>
				return 0;
  801ddd:	b8 00 00 00 00       	mov    $0x0,%eax
  801de2:	eb cf                	jmp    801db3 <devpipe_read+0x42>

00801de4 <pipe>:
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	56                   	push   %esi
  801de8:	53                   	push   %ebx
  801de9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801def:	50                   	push   %eax
  801df0:	e8 15 f6 ff ff       	call   80140a <fd_alloc>
  801df5:	89 c3                	mov    %eax,%ebx
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 5b                	js     801e59 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dfe:	83 ec 04             	sub    $0x4,%esp
  801e01:	68 07 04 00 00       	push   $0x407
  801e06:	ff 75 f4             	pushl  -0xc(%ebp)
  801e09:	6a 00                	push   $0x0
  801e0b:	e8 97 f0 ff ff       	call   800ea7 <sys_page_alloc>
  801e10:	89 c3                	mov    %eax,%ebx
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 40                	js     801e59 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e1f:	50                   	push   %eax
  801e20:	e8 e5 f5 ff ff       	call   80140a <fd_alloc>
  801e25:	89 c3                	mov    %eax,%ebx
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	78 1b                	js     801e49 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	68 07 04 00 00       	push   $0x407
  801e36:	ff 75 f0             	pushl  -0x10(%ebp)
  801e39:	6a 00                	push   $0x0
  801e3b:	e8 67 f0 ff ff       	call   800ea7 <sys_page_alloc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	79 19                	jns    801e62 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e49:	83 ec 08             	sub    $0x8,%esp
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	6a 00                	push   $0x0
  801e51:	e8 d6 f0 ff ff       	call   800f2c <sys_page_unmap>
  801e56:	83 c4 10             	add    $0x10,%esp
}
  801e59:	89 d8                	mov    %ebx,%eax
  801e5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5e                   	pop    %esi
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    
	va = fd2data(fd0);
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	ff 75 f4             	pushl  -0xc(%ebp)
  801e68:	e8 86 f5 ff ff       	call   8013f3 <fd2data>
  801e6d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6f:	83 c4 0c             	add    $0xc,%esp
  801e72:	68 07 04 00 00       	push   $0x407
  801e77:	50                   	push   %eax
  801e78:	6a 00                	push   $0x0
  801e7a:	e8 28 f0 ff ff       	call   800ea7 <sys_page_alloc>
  801e7f:	89 c3                	mov    %eax,%ebx
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	85 c0                	test   %eax,%eax
  801e86:	0f 88 8c 00 00 00    	js     801f18 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e92:	e8 5c f5 ff ff       	call   8013f3 <fd2data>
  801e97:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e9e:	50                   	push   %eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	56                   	push   %esi
  801ea2:	6a 00                	push   $0x0
  801ea4:	e8 41 f0 ff ff       	call   800eea <sys_page_map>
  801ea9:	89 c3                	mov    %eax,%ebx
  801eab:	83 c4 20             	add    $0x20,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 58                	js     801f0a <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801ebb:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eca:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801ed0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee2:	e8 fc f4 ff ff       	call   8013e3 <fd2num>
  801ee7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eea:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801eec:	83 c4 04             	add    $0x4,%esp
  801eef:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef2:	e8 ec f4 ff ff       	call   8013e3 <fd2num>
  801ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801efa:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f05:	e9 4f ff ff ff       	jmp    801e59 <pipe+0x75>
	sys_page_unmap(0, va);
  801f0a:	83 ec 08             	sub    $0x8,%esp
  801f0d:	56                   	push   %esi
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 17 f0 ff ff       	call   800f2c <sys_page_unmap>
  801f15:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f18:	83 ec 08             	sub    $0x8,%esp
  801f1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 07 f0 ff ff       	call   800f2c <sys_page_unmap>
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	e9 1c ff ff ff       	jmp    801e49 <pipe+0x65>

00801f2d <pipeisclosed>:
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f36:	50                   	push   %eax
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	e8 1a f5 ff ff       	call   801459 <fd_lookup>
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	78 18                	js     801f5e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4c:	e8 a2 f4 ff ff       	call   8013f3 <fd2data>
	return _pipeisclosed(fd, p);
  801f51:	89 c2                	mov    %eax,%edx
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	e8 30 fd ff ff       	call   801c8b <_pipeisclosed>
  801f5b:	83 c4 10             	add    $0x10,%esp
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	56                   	push   %esi
  801f64:	53                   	push   %ebx
  801f65:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801f68:	85 f6                	test   %esi,%esi
  801f6a:	74 13                	je     801f7f <wait+0x1f>
	e = &envs[ENVX(envid)];
  801f6c:	89 f3                	mov    %esi,%ebx
  801f6e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f74:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801f77:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801f7d:	eb 1b                	jmp    801f9a <wait+0x3a>
	assert(envid != 0);
  801f7f:	68 e6 2f 80 00       	push   $0x802fe6
  801f84:	68 94 2f 80 00       	push   $0x802f94
  801f89:	6a 09                	push   $0x9
  801f8b:	68 f1 2f 80 00       	push   $0x802ff1
  801f90:	e8 a1 e3 ff ff       	call   800336 <_panic>
		sys_yield();
  801f95:	e8 ee ee ff ff       	call   800e88 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f9a:	8b 43 48             	mov    0x48(%ebx),%eax
  801f9d:	39 f0                	cmp    %esi,%eax
  801f9f:	75 07                	jne    801fa8 <wait+0x48>
  801fa1:	8b 43 54             	mov    0x54(%ebx),%eax
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	75 ed                	jne    801f95 <wait+0x35>
}
  801fa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fb5:	68 fc 2f 80 00       	push   $0x802ffc
  801fba:	ff 75 0c             	pushl  0xc(%ebp)
  801fbd:	e8 ec ea ff ff       	call   800aae <strcpy>
	return 0;
}
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <devsock_close>:
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	53                   	push   %ebx
  801fcd:	83 ec 10             	sub    $0x10,%esp
  801fd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fd3:	53                   	push   %ebx
  801fd4:	e8 52 07 00 00       	call   80272b <pageref>
  801fd9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fdc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fe1:	83 f8 01             	cmp    $0x1,%eax
  801fe4:	74 07                	je     801fed <devsock_close+0x24>
}
  801fe6:	89 d0                	mov    %edx,%eax
  801fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	ff 73 0c             	pushl  0xc(%ebx)
  801ff3:	e8 b7 02 00 00       	call   8022af <nsipc_close>
  801ff8:	89 c2                	mov    %eax,%edx
  801ffa:	83 c4 10             	add    $0x10,%esp
  801ffd:	eb e7                	jmp    801fe6 <devsock_close+0x1d>

00801fff <devsock_write>:
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802005:	6a 00                	push   $0x0
  802007:	ff 75 10             	pushl  0x10(%ebp)
  80200a:	ff 75 0c             	pushl  0xc(%ebp)
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	ff 70 0c             	pushl  0xc(%eax)
  802013:	e8 74 03 00 00       	call   80238c <nsipc_send>
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <devsock_read>:
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802020:	6a 00                	push   $0x0
  802022:	ff 75 10             	pushl  0x10(%ebp)
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	ff 70 0c             	pushl  0xc(%eax)
  80202e:	e8 ed 02 00 00       	call   802320 <nsipc_recv>
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <fd2sockid>:
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80203b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80203e:	52                   	push   %edx
  80203f:	50                   	push   %eax
  802040:	e8 14 f4 ff ff       	call   801459 <fd_lookup>
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 10                	js     80205c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  802055:	39 08                	cmp    %ecx,(%eax)
  802057:	75 05                	jne    80205e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802059:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    
		return -E_NOT_SUPP;
  80205e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802063:	eb f7                	jmp    80205c <fd2sockid+0x27>

00802065 <alloc_sockfd>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	56                   	push   %esi
  802069:	53                   	push   %ebx
  80206a:	83 ec 1c             	sub    $0x1c,%esp
  80206d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80206f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802072:	50                   	push   %eax
  802073:	e8 92 f3 ff ff       	call   80140a <fd_alloc>
  802078:	89 c3                	mov    %eax,%ebx
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	85 c0                	test   %eax,%eax
  80207f:	78 43                	js     8020c4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	68 07 04 00 00       	push   $0x407
  802089:	ff 75 f4             	pushl  -0xc(%ebp)
  80208c:	6a 00                	push   $0x0
  80208e:	e8 14 ee ff ff       	call   800ea7 <sys_page_alloc>
  802093:	89 c3                	mov    %eax,%ebx
  802095:	83 c4 10             	add    $0x10,%esp
  802098:	85 c0                	test   %eax,%eax
  80209a:	78 28                	js     8020c4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020a5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020b1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	50                   	push   %eax
  8020b8:	e8 26 f3 ff ff       	call   8013e3 <fd2num>
  8020bd:	89 c3                	mov    %eax,%ebx
  8020bf:	83 c4 10             	add    $0x10,%esp
  8020c2:	eb 0c                	jmp    8020d0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	56                   	push   %esi
  8020c8:	e8 e2 01 00 00       	call   8022af <nsipc_close>
		return r;
  8020cd:	83 c4 10             	add    $0x10,%esp
}
  8020d0:	89 d8                	mov    %ebx,%eax
  8020d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d5:	5b                   	pop    %ebx
  8020d6:	5e                   	pop    %esi
  8020d7:	5d                   	pop    %ebp
  8020d8:	c3                   	ret    

008020d9 <accept>:
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	e8 4e ff ff ff       	call   802035 <fd2sockid>
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 1b                	js     802106 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	ff 75 10             	pushl  0x10(%ebp)
  8020f1:	ff 75 0c             	pushl  0xc(%ebp)
  8020f4:	50                   	push   %eax
  8020f5:	e8 0e 01 00 00       	call   802208 <nsipc_accept>
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	78 05                	js     802106 <accept+0x2d>
	return alloc_sockfd(r);
  802101:	e8 5f ff ff ff       	call   802065 <alloc_sockfd>
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <bind>:
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	e8 1f ff ff ff       	call   802035 <fd2sockid>
  802116:	85 c0                	test   %eax,%eax
  802118:	78 12                	js     80212c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80211a:	83 ec 04             	sub    $0x4,%esp
  80211d:	ff 75 10             	pushl  0x10(%ebp)
  802120:	ff 75 0c             	pushl  0xc(%ebp)
  802123:	50                   	push   %eax
  802124:	e8 2f 01 00 00       	call   802258 <nsipc_bind>
  802129:	83 c4 10             	add    $0x10,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <shutdown>:
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	e8 f9 fe ff ff       	call   802035 <fd2sockid>
  80213c:	85 c0                	test   %eax,%eax
  80213e:	78 0f                	js     80214f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802140:	83 ec 08             	sub    $0x8,%esp
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	50                   	push   %eax
  802147:	e8 41 01 00 00       	call   80228d <nsipc_shutdown>
  80214c:	83 c4 10             	add    $0x10,%esp
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <connect>:
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	e8 d6 fe ff ff       	call   802035 <fd2sockid>
  80215f:	85 c0                	test   %eax,%eax
  802161:	78 12                	js     802175 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	ff 75 10             	pushl  0x10(%ebp)
  802169:	ff 75 0c             	pushl  0xc(%ebp)
  80216c:	50                   	push   %eax
  80216d:	e8 57 01 00 00       	call   8022c9 <nsipc_connect>
  802172:	83 c4 10             	add    $0x10,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <listen>:
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	e8 b0 fe ff ff       	call   802035 <fd2sockid>
  802185:	85 c0                	test   %eax,%eax
  802187:	78 0f                	js     802198 <listen+0x21>
	return nsipc_listen(r, backlog);
  802189:	83 ec 08             	sub    $0x8,%esp
  80218c:	ff 75 0c             	pushl  0xc(%ebp)
  80218f:	50                   	push   %eax
  802190:	e8 69 01 00 00       	call   8022fe <nsipc_listen>
  802195:	83 c4 10             	add    $0x10,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <socket>:

int
socket(int domain, int type, int protocol)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021a0:	ff 75 10             	pushl  0x10(%ebp)
  8021a3:	ff 75 0c             	pushl  0xc(%ebp)
  8021a6:	ff 75 08             	pushl  0x8(%ebp)
  8021a9:	e8 3c 02 00 00       	call   8023ea <nsipc_socket>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	78 05                	js     8021ba <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021b5:	e8 ab fe ff ff       	call   802065 <alloc_sockfd>
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	53                   	push   %ebx
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021c5:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021cc:	74 26                	je     8021f4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021ce:	6a 07                	push   $0x7
  8021d0:	68 00 70 80 00       	push   $0x807000
  8021d5:	53                   	push   %ebx
  8021d6:	ff 35 04 50 80 00    	pushl  0x805004
  8021dc:	e8 b8 04 00 00       	call   802699 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021e1:	83 c4 0c             	add    $0xc,%esp
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	e8 41 04 00 00       	call   802630 <ipc_recv>
}
  8021ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	6a 02                	push   $0x2
  8021f9:	e8 f4 04 00 00       	call   8026f2 <ipc_find_env>
  8021fe:	a3 04 50 80 00       	mov    %eax,0x805004
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	eb c6                	jmp    8021ce <nsipc+0x12>

00802208 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	56                   	push   %esi
  80220c:	53                   	push   %ebx
  80220d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802218:	8b 06                	mov    (%esi),%eax
  80221a:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80221f:	b8 01 00 00 00       	mov    $0x1,%eax
  802224:	e8 93 ff ff ff       	call   8021bc <nsipc>
  802229:	89 c3                	mov    %eax,%ebx
  80222b:	85 c0                	test   %eax,%eax
  80222d:	78 20                	js     80224f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	ff 35 10 70 80 00    	pushl  0x807010
  802238:	68 00 70 80 00       	push   $0x807000
  80223d:	ff 75 0c             	pushl  0xc(%ebp)
  802240:	e8 f7 e9 ff ff       	call   800c3c <memmove>
		*addrlen = ret->ret_addrlen;
  802245:	a1 10 70 80 00       	mov    0x807010,%eax
  80224a:	89 06                	mov    %eax,(%esi)
  80224c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80224f:	89 d8                	mov    %ebx,%eax
  802251:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802254:	5b                   	pop    %ebx
  802255:	5e                   	pop    %esi
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    

00802258 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	53                   	push   %ebx
  80225c:	83 ec 08             	sub    $0x8,%esp
  80225f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80226a:	53                   	push   %ebx
  80226b:	ff 75 0c             	pushl  0xc(%ebp)
  80226e:	68 04 70 80 00       	push   $0x807004
  802273:	e8 c4 e9 ff ff       	call   800c3c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802278:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80227e:	b8 02 00 00 00       	mov    $0x2,%eax
  802283:	e8 34 ff ff ff       	call   8021bc <nsipc>
}
  802288:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80229b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8022a8:	e8 0f ff ff ff       	call   8021bc <nsipc>
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <nsipc_close>:

int
nsipc_close(int s)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022bd:	b8 04 00 00 00       	mov    $0x4,%eax
  8022c2:	e8 f5 fe ff ff       	call   8021bc <nsipc>
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	53                   	push   %ebx
  8022cd:	83 ec 08             	sub    $0x8,%esp
  8022d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022db:	53                   	push   %ebx
  8022dc:	ff 75 0c             	pushl  0xc(%ebp)
  8022df:	68 04 70 80 00       	push   $0x807004
  8022e4:	e8 53 e9 ff ff       	call   800c3c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022e9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8022f4:	e8 c3 fe ff ff       	call   8021bc <nsipc>
}
  8022f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80230c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802314:	b8 06 00 00 00       	mov    $0x6,%eax
  802319:	e8 9e fe ff ff       	call   8021bc <nsipc>
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	56                   	push   %esi
  802324:	53                   	push   %ebx
  802325:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802330:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802336:	8b 45 14             	mov    0x14(%ebp),%eax
  802339:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80233e:	b8 07 00 00 00       	mov    $0x7,%eax
  802343:	e8 74 fe ff ff       	call   8021bc <nsipc>
  802348:	89 c3                	mov    %eax,%ebx
  80234a:	85 c0                	test   %eax,%eax
  80234c:	78 1f                	js     80236d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80234e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802353:	7f 21                	jg     802376 <nsipc_recv+0x56>
  802355:	39 c6                	cmp    %eax,%esi
  802357:	7c 1d                	jl     802376 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	50                   	push   %eax
  80235d:	68 00 70 80 00       	push   $0x807000
  802362:	ff 75 0c             	pushl  0xc(%ebp)
  802365:	e8 d2 e8 ff ff       	call   800c3c <memmove>
  80236a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80236d:	89 d8                	mov    %ebx,%eax
  80236f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802372:	5b                   	pop    %ebx
  802373:	5e                   	pop    %esi
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802376:	68 08 30 80 00       	push   $0x803008
  80237b:	68 94 2f 80 00       	push   $0x802f94
  802380:	6a 62                	push   $0x62
  802382:	68 1d 30 80 00       	push   $0x80301d
  802387:	e8 aa df ff ff       	call   800336 <_panic>

0080238c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	53                   	push   %ebx
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80239e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023a4:	7f 2e                	jg     8023d4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	53                   	push   %ebx
  8023aa:	ff 75 0c             	pushl  0xc(%ebp)
  8023ad:	68 0c 70 80 00       	push   $0x80700c
  8023b2:	e8 85 e8 ff ff       	call   800c3c <memmove>
	nsipcbuf.send.req_size = size;
  8023b7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8023ca:	e8 ed fd ff ff       	call   8021bc <nsipc>
}
  8023cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    
	assert(size < 1600);
  8023d4:	68 29 30 80 00       	push   $0x803029
  8023d9:	68 94 2f 80 00       	push   $0x802f94
  8023de:	6a 6d                	push   $0x6d
  8023e0:	68 1d 30 80 00       	push   $0x80301d
  8023e5:	e8 4c df ff ff       	call   800336 <_panic>

008023ea <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802400:	8b 45 10             	mov    0x10(%ebp),%eax
  802403:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802408:	b8 09 00 00 00       	mov    $0x9,%eax
  80240d:	e8 aa fd ff ff       	call   8021bc <nsipc>
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802424:	68 35 30 80 00       	push   $0x803035
  802429:	ff 75 0c             	pushl  0xc(%ebp)
  80242c:	e8 7d e6 ff ff       	call   800aae <strcpy>
	return 0;
}
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <devcons_write>:
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	57                   	push   %edi
  80243c:	56                   	push   %esi
  80243d:	53                   	push   %ebx
  80243e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802444:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802449:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80244f:	eb 2f                	jmp    802480 <devcons_write+0x48>
		m = n - tot;
  802451:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802454:	29 f3                	sub    %esi,%ebx
  802456:	83 fb 7f             	cmp    $0x7f,%ebx
  802459:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80245e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	53                   	push   %ebx
  802465:	89 f0                	mov    %esi,%eax
  802467:	03 45 0c             	add    0xc(%ebp),%eax
  80246a:	50                   	push   %eax
  80246b:	57                   	push   %edi
  80246c:	e8 cb e7 ff ff       	call   800c3c <memmove>
		sys_cputs(buf, m);
  802471:	83 c4 08             	add    $0x8,%esp
  802474:	53                   	push   %ebx
  802475:	57                   	push   %edi
  802476:	e8 70 e9 ff ff       	call   800deb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80247b:	01 de                	add    %ebx,%esi
  80247d:	83 c4 10             	add    $0x10,%esp
  802480:	3b 75 10             	cmp    0x10(%ebp),%esi
  802483:	72 cc                	jb     802451 <devcons_write+0x19>
}
  802485:	89 f0                	mov    %esi,%eax
  802487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248a:	5b                   	pop    %ebx
  80248b:	5e                   	pop    %esi
  80248c:	5f                   	pop    %edi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    

0080248f <devcons_read>:
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	83 ec 08             	sub    $0x8,%esp
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80249a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80249e:	75 07                	jne    8024a7 <devcons_read+0x18>
}
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    
		sys_yield();
  8024a2:	e8 e1 e9 ff ff       	call   800e88 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8024a7:	e8 5d e9 ff ff       	call   800e09 <sys_cgetc>
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 f2                	je     8024a2 <devcons_read+0x13>
	if (c < 0)
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	78 ec                	js     8024a0 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8024b4:	83 f8 04             	cmp    $0x4,%eax
  8024b7:	74 0c                	je     8024c5 <devcons_read+0x36>
	*(char*)vbuf = c;
  8024b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bc:	88 02                	mov    %al,(%edx)
	return 1;
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	eb db                	jmp    8024a0 <devcons_read+0x11>
		return 0;
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	eb d4                	jmp    8024a0 <devcons_read+0x11>

008024cc <cputchar>:
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024d8:	6a 01                	push   $0x1
  8024da:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024dd:	50                   	push   %eax
  8024de:	e8 08 e9 ff ff       	call   800deb <sys_cputs>
}
  8024e3:	83 c4 10             	add    $0x10,%esp
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <getchar>:
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024ee:	6a 01                	push   $0x1
  8024f0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024f3:	50                   	push   %eax
  8024f4:	6a 00                	push   $0x0
  8024f6:	e8 cf f1 ff ff       	call   8016ca <read>
	if (r < 0)
  8024fb:	83 c4 10             	add    $0x10,%esp
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 08                	js     80250a <getchar+0x22>
	if (r < 1)
  802502:	85 c0                	test   %eax,%eax
  802504:	7e 06                	jle    80250c <getchar+0x24>
	return c;
  802506:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    
		return -E_EOF;
  80250c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802511:	eb f7                	jmp    80250a <getchar+0x22>

00802513 <iscons>:
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802519:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251c:	50                   	push   %eax
  80251d:	ff 75 08             	pushl  0x8(%ebp)
  802520:	e8 34 ef ff ff       	call   801459 <fd_lookup>
  802525:	83 c4 10             	add    $0x10,%esp
  802528:	85 c0                	test   %eax,%eax
  80252a:	78 11                	js     80253d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802535:	39 10                	cmp    %edx,(%eax)
  802537:	0f 94 c0             	sete   %al
  80253a:	0f b6 c0             	movzbl %al,%eax
}
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <opencons>:
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802545:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802548:	50                   	push   %eax
  802549:	e8 bc ee ff ff       	call   80140a <fd_alloc>
  80254e:	83 c4 10             	add    $0x10,%esp
  802551:	85 c0                	test   %eax,%eax
  802553:	78 3a                	js     80258f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	68 07 04 00 00       	push   $0x407
  80255d:	ff 75 f4             	pushl  -0xc(%ebp)
  802560:	6a 00                	push   $0x0
  802562:	e8 40 e9 ff ff       	call   800ea7 <sys_page_alloc>
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	85 c0                	test   %eax,%eax
  80256c:	78 21                	js     80258f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802577:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802583:	83 ec 0c             	sub    $0xc,%esp
  802586:	50                   	push   %eax
  802587:	e8 57 ee ff ff       	call   8013e3 <fd2num>
  80258c:	83 c4 10             	add    $0x10,%esp
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802597:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80259e:	74 0a                	je     8025aa <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8025aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8025af:	8b 40 48             	mov    0x48(%eax),%eax
  8025b2:	83 ec 04             	sub    $0x4,%esp
  8025b5:	6a 07                	push   $0x7
  8025b7:	68 00 f0 bf ee       	push   $0xeebff000
  8025bc:	50                   	push   %eax
  8025bd:	e8 e5 e8 ff ff       	call   800ea7 <sys_page_alloc>
  8025c2:	83 c4 10             	add    $0x10,%esp
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	75 2f                	jne    8025f8 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8025c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8025ce:	8b 40 48             	mov    0x48(%eax),%eax
  8025d1:	83 ec 08             	sub    $0x8,%esp
  8025d4:	68 0a 26 80 00       	push   $0x80260a
  8025d9:	50                   	push   %eax
  8025da:	e8 13 ea ff ff       	call   800ff2 <sys_env_set_pgfault_upcall>
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	74 ba                	je     8025a0 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8025e6:	50                   	push   %eax
  8025e7:	68 41 30 80 00       	push   $0x803041
  8025ec:	6a 24                	push   $0x24
  8025ee:	68 59 30 80 00       	push   $0x803059
  8025f3:	e8 3e dd ff ff       	call   800336 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8025f8:	50                   	push   %eax
  8025f9:	68 41 30 80 00       	push   $0x803041
  8025fe:	6a 21                	push   $0x21
  802600:	68 59 30 80 00       	push   $0x803059
  802605:	e8 2c dd ff ff       	call   800336 <_panic>

0080260a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80260a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80260b:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802610:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802612:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  802615:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  802619:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  80261c:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802620:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802624:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  802626:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  802629:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  80262a:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  80262d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80262e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80262f:	c3                   	ret    

00802630 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	56                   	push   %esi
  802634:	53                   	push   %ebx
  802635:	8b 75 08             	mov    0x8(%ebp),%esi
  802638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80263e:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802640:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802645:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802648:	83 ec 0c             	sub    $0xc,%esp
  80264b:	50                   	push   %eax
  80264c:	e8 06 ea ff ff       	call   801057 <sys_ipc_recv>
  802651:	83 c4 10             	add    $0x10,%esp
  802654:	85 c0                	test   %eax,%eax
  802656:	78 2b                	js     802683 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802658:	85 f6                	test   %esi,%esi
  80265a:	74 0a                	je     802666 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80265c:	a1 08 50 80 00       	mov    0x805008,%eax
  802661:	8b 40 74             	mov    0x74(%eax),%eax
  802664:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802666:	85 db                	test   %ebx,%ebx
  802668:	74 0a                	je     802674 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80266a:	a1 08 50 80 00       	mov    0x805008,%eax
  80266f:	8b 40 78             	mov    0x78(%eax),%eax
  802672:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802674:	a1 08 50 80 00       	mov    0x805008,%eax
  802679:	8b 40 70             	mov    0x70(%eax),%eax
}
  80267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80267f:	5b                   	pop    %ebx
  802680:	5e                   	pop    %esi
  802681:	5d                   	pop    %ebp
  802682:	c3                   	ret    
	    if (from_env_store != NULL) {
  802683:	85 f6                	test   %esi,%esi
  802685:	74 06                	je     80268d <ipc_recv+0x5d>
	        *from_env_store = 0;
  802687:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80268d:	85 db                	test   %ebx,%ebx
  80268f:	74 eb                	je     80267c <ipc_recv+0x4c>
	        *perm_store = 0;
  802691:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802697:	eb e3                	jmp    80267c <ipc_recv+0x4c>

00802699 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
  80269c:	57                   	push   %edi
  80269d:	56                   	push   %esi
  80269e:	53                   	push   %ebx
  80269f:	83 ec 0c             	sub    $0xc,%esp
  8026a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026a5:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8026a8:	85 f6                	test   %esi,%esi
  8026aa:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026af:	0f 44 f0             	cmove  %eax,%esi
  8026b2:	eb 09                	jmp    8026bd <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8026b4:	e8 cf e7 ff ff       	call   800e88 <sys_yield>
	} while(r != 0);
  8026b9:	85 db                	test   %ebx,%ebx
  8026bb:	74 2d                	je     8026ea <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8026bd:	ff 75 14             	pushl  0x14(%ebp)
  8026c0:	56                   	push   %esi
  8026c1:	ff 75 0c             	pushl  0xc(%ebp)
  8026c4:	57                   	push   %edi
  8026c5:	e8 6a e9 ff ff       	call   801034 <sys_ipc_try_send>
  8026ca:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8026cc:	83 c4 10             	add    $0x10,%esp
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	79 e1                	jns    8026b4 <ipc_send+0x1b>
  8026d3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026d6:	74 dc                	je     8026b4 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8026d8:	50                   	push   %eax
  8026d9:	68 67 30 80 00       	push   $0x803067
  8026de:	6a 45                	push   $0x45
  8026e0:	68 74 30 80 00       	push   $0x803074
  8026e5:	e8 4c dc ff ff       	call   800336 <_panic>
}
  8026ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5e                   	pop    %esi
  8026ef:	5f                   	pop    %edi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    

008026f2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026f8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026fd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802700:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802706:	8b 52 50             	mov    0x50(%edx),%edx
  802709:	39 ca                	cmp    %ecx,%edx
  80270b:	74 11                	je     80271e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80270d:	83 c0 01             	add    $0x1,%eax
  802710:	3d 00 04 00 00       	cmp    $0x400,%eax
  802715:	75 e6                	jne    8026fd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	eb 0b                	jmp    802729 <ipc_find_env+0x37>
			return envs[i].env_id;
  80271e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802721:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802726:	8b 40 48             	mov    0x48(%eax),%eax
}
  802729:	5d                   	pop    %ebp
  80272a:	c3                   	ret    

0080272b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
  80272e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802731:	89 d0                	mov    %edx,%eax
  802733:	c1 e8 16             	shr    $0x16,%eax
  802736:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802742:	f6 c1 01             	test   $0x1,%cl
  802745:	74 1d                	je     802764 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802747:	c1 ea 0c             	shr    $0xc,%edx
  80274a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802751:	f6 c2 01             	test   $0x1,%dl
  802754:	74 0e                	je     802764 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802756:	c1 ea 0c             	shr    $0xc,%edx
  802759:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802760:	ef 
  802761:	0f b7 c0             	movzwl %ax,%eax
}
  802764:	5d                   	pop    %ebp
  802765:	c3                   	ret    
  802766:	66 90                	xchg   %ax,%ax
  802768:	66 90                	xchg   %ax,%ax
  80276a:	66 90                	xchg   %ax,%ax
  80276c:	66 90                	xchg   %ax,%ax
  80276e:	66 90                	xchg   %ax,%ax

00802770 <__udivdi3>:
  802770:	55                   	push   %ebp
  802771:	57                   	push   %edi
  802772:	56                   	push   %esi
  802773:	53                   	push   %ebx
  802774:	83 ec 1c             	sub    $0x1c,%esp
  802777:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80277b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80277f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802783:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802787:	85 d2                	test   %edx,%edx
  802789:	75 35                	jne    8027c0 <__udivdi3+0x50>
  80278b:	39 f3                	cmp    %esi,%ebx
  80278d:	0f 87 bd 00 00 00    	ja     802850 <__udivdi3+0xe0>
  802793:	85 db                	test   %ebx,%ebx
  802795:	89 d9                	mov    %ebx,%ecx
  802797:	75 0b                	jne    8027a4 <__udivdi3+0x34>
  802799:	b8 01 00 00 00       	mov    $0x1,%eax
  80279e:	31 d2                	xor    %edx,%edx
  8027a0:	f7 f3                	div    %ebx
  8027a2:	89 c1                	mov    %eax,%ecx
  8027a4:	31 d2                	xor    %edx,%edx
  8027a6:	89 f0                	mov    %esi,%eax
  8027a8:	f7 f1                	div    %ecx
  8027aa:	89 c6                	mov    %eax,%esi
  8027ac:	89 e8                	mov    %ebp,%eax
  8027ae:	89 f7                	mov    %esi,%edi
  8027b0:	f7 f1                	div    %ecx
  8027b2:	89 fa                	mov    %edi,%edx
  8027b4:	83 c4 1c             	add    $0x1c,%esp
  8027b7:	5b                   	pop    %ebx
  8027b8:	5e                   	pop    %esi
  8027b9:	5f                   	pop    %edi
  8027ba:	5d                   	pop    %ebp
  8027bb:	c3                   	ret    
  8027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027c0:	39 f2                	cmp    %esi,%edx
  8027c2:	77 7c                	ja     802840 <__udivdi3+0xd0>
  8027c4:	0f bd fa             	bsr    %edx,%edi
  8027c7:	83 f7 1f             	xor    $0x1f,%edi
  8027ca:	0f 84 98 00 00 00    	je     802868 <__udivdi3+0xf8>
  8027d0:	89 f9                	mov    %edi,%ecx
  8027d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027d7:	29 f8                	sub    %edi,%eax
  8027d9:	d3 e2                	shl    %cl,%edx
  8027db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027df:	89 c1                	mov    %eax,%ecx
  8027e1:	89 da                	mov    %ebx,%edx
  8027e3:	d3 ea                	shr    %cl,%edx
  8027e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027e9:	09 d1                	or     %edx,%ecx
  8027eb:	89 f2                	mov    %esi,%edx
  8027ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027f1:	89 f9                	mov    %edi,%ecx
  8027f3:	d3 e3                	shl    %cl,%ebx
  8027f5:	89 c1                	mov    %eax,%ecx
  8027f7:	d3 ea                	shr    %cl,%edx
  8027f9:	89 f9                	mov    %edi,%ecx
  8027fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027ff:	d3 e6                	shl    %cl,%esi
  802801:	89 eb                	mov    %ebp,%ebx
  802803:	89 c1                	mov    %eax,%ecx
  802805:	d3 eb                	shr    %cl,%ebx
  802807:	09 de                	or     %ebx,%esi
  802809:	89 f0                	mov    %esi,%eax
  80280b:	f7 74 24 08          	divl   0x8(%esp)
  80280f:	89 d6                	mov    %edx,%esi
  802811:	89 c3                	mov    %eax,%ebx
  802813:	f7 64 24 0c          	mull   0xc(%esp)
  802817:	39 d6                	cmp    %edx,%esi
  802819:	72 0c                	jb     802827 <__udivdi3+0xb7>
  80281b:	89 f9                	mov    %edi,%ecx
  80281d:	d3 e5                	shl    %cl,%ebp
  80281f:	39 c5                	cmp    %eax,%ebp
  802821:	73 5d                	jae    802880 <__udivdi3+0x110>
  802823:	39 d6                	cmp    %edx,%esi
  802825:	75 59                	jne    802880 <__udivdi3+0x110>
  802827:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80282a:	31 ff                	xor    %edi,%edi
  80282c:	89 fa                	mov    %edi,%edx
  80282e:	83 c4 1c             	add    $0x1c,%esp
  802831:	5b                   	pop    %ebx
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    
  802836:	8d 76 00             	lea    0x0(%esi),%esi
  802839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802840:	31 ff                	xor    %edi,%edi
  802842:	31 c0                	xor    %eax,%eax
  802844:	89 fa                	mov    %edi,%edx
  802846:	83 c4 1c             	add    $0x1c,%esp
  802849:	5b                   	pop    %ebx
  80284a:	5e                   	pop    %esi
  80284b:	5f                   	pop    %edi
  80284c:	5d                   	pop    %ebp
  80284d:	c3                   	ret    
  80284e:	66 90                	xchg   %ax,%ax
  802850:	31 ff                	xor    %edi,%edi
  802852:	89 e8                	mov    %ebp,%eax
  802854:	89 f2                	mov    %esi,%edx
  802856:	f7 f3                	div    %ebx
  802858:	89 fa                	mov    %edi,%edx
  80285a:	83 c4 1c             	add    $0x1c,%esp
  80285d:	5b                   	pop    %ebx
  80285e:	5e                   	pop    %esi
  80285f:	5f                   	pop    %edi
  802860:	5d                   	pop    %ebp
  802861:	c3                   	ret    
  802862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802868:	39 f2                	cmp    %esi,%edx
  80286a:	72 06                	jb     802872 <__udivdi3+0x102>
  80286c:	31 c0                	xor    %eax,%eax
  80286e:	39 eb                	cmp    %ebp,%ebx
  802870:	77 d2                	ja     802844 <__udivdi3+0xd4>
  802872:	b8 01 00 00 00       	mov    $0x1,%eax
  802877:	eb cb                	jmp    802844 <__udivdi3+0xd4>
  802879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802880:	89 d8                	mov    %ebx,%eax
  802882:	31 ff                	xor    %edi,%edi
  802884:	eb be                	jmp    802844 <__udivdi3+0xd4>
  802886:	66 90                	xchg   %ax,%ax
  802888:	66 90                	xchg   %ax,%ax
  80288a:	66 90                	xchg   %ax,%ax
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

00802890 <__umoddi3>:
  802890:	55                   	push   %ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	53                   	push   %ebx
  802894:	83 ec 1c             	sub    $0x1c,%esp
  802897:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80289b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80289f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028a7:	85 ed                	test   %ebp,%ebp
  8028a9:	89 f0                	mov    %esi,%eax
  8028ab:	89 da                	mov    %ebx,%edx
  8028ad:	75 19                	jne    8028c8 <__umoddi3+0x38>
  8028af:	39 df                	cmp    %ebx,%edi
  8028b1:	0f 86 b1 00 00 00    	jbe    802968 <__umoddi3+0xd8>
  8028b7:	f7 f7                	div    %edi
  8028b9:	89 d0                	mov    %edx,%eax
  8028bb:	31 d2                	xor    %edx,%edx
  8028bd:	83 c4 1c             	add    $0x1c,%esp
  8028c0:	5b                   	pop    %ebx
  8028c1:	5e                   	pop    %esi
  8028c2:	5f                   	pop    %edi
  8028c3:	5d                   	pop    %ebp
  8028c4:	c3                   	ret    
  8028c5:	8d 76 00             	lea    0x0(%esi),%esi
  8028c8:	39 dd                	cmp    %ebx,%ebp
  8028ca:	77 f1                	ja     8028bd <__umoddi3+0x2d>
  8028cc:	0f bd cd             	bsr    %ebp,%ecx
  8028cf:	83 f1 1f             	xor    $0x1f,%ecx
  8028d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028d6:	0f 84 b4 00 00 00    	je     802990 <__umoddi3+0x100>
  8028dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8028e1:	89 c2                	mov    %eax,%edx
  8028e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028e7:	29 c2                	sub    %eax,%edx
  8028e9:	89 c1                	mov    %eax,%ecx
  8028eb:	89 f8                	mov    %edi,%eax
  8028ed:	d3 e5                	shl    %cl,%ebp
  8028ef:	89 d1                	mov    %edx,%ecx
  8028f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8028f5:	d3 e8                	shr    %cl,%eax
  8028f7:	09 c5                	or     %eax,%ebp
  8028f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028fd:	89 c1                	mov    %eax,%ecx
  8028ff:	d3 e7                	shl    %cl,%edi
  802901:	89 d1                	mov    %edx,%ecx
  802903:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802907:	89 df                	mov    %ebx,%edi
  802909:	d3 ef                	shr    %cl,%edi
  80290b:	89 c1                	mov    %eax,%ecx
  80290d:	89 f0                	mov    %esi,%eax
  80290f:	d3 e3                	shl    %cl,%ebx
  802911:	89 d1                	mov    %edx,%ecx
  802913:	89 fa                	mov    %edi,%edx
  802915:	d3 e8                	shr    %cl,%eax
  802917:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80291c:	09 d8                	or     %ebx,%eax
  80291e:	f7 f5                	div    %ebp
  802920:	d3 e6                	shl    %cl,%esi
  802922:	89 d1                	mov    %edx,%ecx
  802924:	f7 64 24 08          	mull   0x8(%esp)
  802928:	39 d1                	cmp    %edx,%ecx
  80292a:	89 c3                	mov    %eax,%ebx
  80292c:	89 d7                	mov    %edx,%edi
  80292e:	72 06                	jb     802936 <__umoddi3+0xa6>
  802930:	75 0e                	jne    802940 <__umoddi3+0xb0>
  802932:	39 c6                	cmp    %eax,%esi
  802934:	73 0a                	jae    802940 <__umoddi3+0xb0>
  802936:	2b 44 24 08          	sub    0x8(%esp),%eax
  80293a:	19 ea                	sbb    %ebp,%edx
  80293c:	89 d7                	mov    %edx,%edi
  80293e:	89 c3                	mov    %eax,%ebx
  802940:	89 ca                	mov    %ecx,%edx
  802942:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802947:	29 de                	sub    %ebx,%esi
  802949:	19 fa                	sbb    %edi,%edx
  80294b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80294f:	89 d0                	mov    %edx,%eax
  802951:	d3 e0                	shl    %cl,%eax
  802953:	89 d9                	mov    %ebx,%ecx
  802955:	d3 ee                	shr    %cl,%esi
  802957:	d3 ea                	shr    %cl,%edx
  802959:	09 f0                	or     %esi,%eax
  80295b:	83 c4 1c             	add    $0x1c,%esp
  80295e:	5b                   	pop    %ebx
  80295f:	5e                   	pop    %esi
  802960:	5f                   	pop    %edi
  802961:	5d                   	pop    %ebp
  802962:	c3                   	ret    
  802963:	90                   	nop
  802964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802968:	85 ff                	test   %edi,%edi
  80296a:	89 f9                	mov    %edi,%ecx
  80296c:	75 0b                	jne    802979 <__umoddi3+0xe9>
  80296e:	b8 01 00 00 00       	mov    $0x1,%eax
  802973:	31 d2                	xor    %edx,%edx
  802975:	f7 f7                	div    %edi
  802977:	89 c1                	mov    %eax,%ecx
  802979:	89 d8                	mov    %ebx,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	f7 f1                	div    %ecx
  80297f:	89 f0                	mov    %esi,%eax
  802981:	f7 f1                	div    %ecx
  802983:	e9 31 ff ff ff       	jmp    8028b9 <__umoddi3+0x29>
  802988:	90                   	nop
  802989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802990:	39 dd                	cmp    %ebx,%ebp
  802992:	72 08                	jb     80299c <__umoddi3+0x10c>
  802994:	39 f7                	cmp    %esi,%edi
  802996:	0f 87 21 ff ff ff    	ja     8028bd <__umoddi3+0x2d>
  80299c:	89 da                	mov    %ebx,%edx
  80299e:	89 f0                	mov    %esi,%eax
  8029a0:	29 f8                	sub    %edi,%eax
  8029a2:	19 ea                	sbb    %ebp,%edx
  8029a4:	e9 14 ff ff ff       	jmp    8028bd <__umoddi3+0x2d>
