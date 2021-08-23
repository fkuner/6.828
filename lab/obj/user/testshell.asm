
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 5f 04 00 00       	call   800490 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 85 19 00 00       	call   8019d4 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 7b 19 00 00       	call   8019d4 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 e0 2f 80 00 	movl   $0x802fe0,(%esp)
  800060:	e8 66 05 00 00       	call   8005cb <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 4b 30 80 00 	movl   $0x80304b,(%esp)
  80006c:	e8 5a 05 00 00       	call   8005cb <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	eb 0d                	jmp    800086 <wrong+0x53>
		sys_cputs(buf, n);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	e8 22 0f 00 00       	call   800fa5 <sys_cputs>
  800083:	83 c4 10             	add    $0x10,%esp
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 63                	push   $0x63
  80008b:	53                   	push   %ebx
  80008c:	57                   	push   %edi
  80008d:	e8 f2 17 00 00       	call   801884 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7f e0                	jg     800079 <wrong+0x46>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 5a 30 80 00       	push   $0x80305a
  8000a1:	e8 25 05 00 00       	call   8005cb <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 ed 0e 00 00       	call   800fa5 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 bd 17 00 00       	call   801884 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 55 30 80 00       	push   $0x803055
  8000d6:	e8 f0 04 00 00       	call   8005cb <cprintf>
	exit();
  8000db:	e8 f6 03 00 00       	call   8004d6 <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 4d 16 00 00       	call   801748 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 41 16 00 00       	call   801748 <close>
	opencons();
  800107:	e8 32 03 00 00       	call   80043e <opencons>
	opencons();
  80010c:	e8 2d 03 00 00       	call   80043e <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 68 30 80 00       	push   $0x803068
  80011b:	e8 08 1c 00 00       	call   801d28 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e9 00 00 00    	js     800216 <umain+0x12b>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 5a 24 00 00       	call   802593 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e4 00 00 00    	js     800228 <umain+0x13d>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 04 30 80 00       	push   $0x803004
  80014f:	e8 77 04 00 00       	call   8005cb <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 02 12 00 00       	call   80135b <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d6 00 00 00    	js     80023a <umain+0x14f>
	if (r == 0) {
  800164:	85 c0                	test   %eax,%eax
  800166:	75 6f                	jne    8001d7 <umain+0xec>
		dup(rfd, 0);
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	53                   	push   %ebx
  80016e:	e8 25 16 00 00       	call   801798 <dup>
		dup(wfd, 1);
  800173:	83 c4 08             	add    $0x8,%esp
  800176:	6a 01                	push   $0x1
  800178:	56                   	push   %esi
  800179:	e8 1a 16 00 00       	call   801798 <dup>
		close(rfd);
  80017e:	89 1c 24             	mov    %ebx,(%esp)
  800181:	e8 c2 15 00 00       	call   801748 <close>
		close(wfd);
  800186:	89 34 24             	mov    %esi,(%esp)
  800189:	e8 ba 15 00 00       	call   801748 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018e:	6a 00                	push   $0x0
  800190:	68 a5 30 80 00       	push   $0x8030a5
  800195:	68 72 30 80 00       	push   $0x803072
  80019a:	68 a8 30 80 00       	push   $0x8030a8
  80019f:	e8 a1 21 00 00       	call   802345 <spawnl>
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	83 c4 20             	add    $0x20,%esp
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	0f 88 9b 00 00 00    	js     80024c <umain+0x161>
		close(0);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	e8 8d 15 00 00       	call   801748 <close>
		close(1);
  8001bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c2:	e8 81 15 00 00       	call   801748 <close>
		wait(r);
  8001c7:	89 3c 24             	mov    %edi,(%esp)
  8001ca:	e8 40 25 00 00       	call   80270f <wait>
		exit();
  8001cf:	e8 02 03 00 00       	call   8004d6 <exit>
  8001d4:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	53                   	push   %ebx
  8001db:	e8 68 15 00 00       	call   801748 <close>
	close(wfd);
  8001e0:	89 34 24             	mov    %esi,(%esp)
  8001e3:	e8 60 15 00 00       	call   801748 <close>
	rfd = pfds[0];
  8001e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ee:	83 c4 08             	add    $0x8,%esp
  8001f1:	6a 00                	push   $0x0
  8001f3:	68 b6 30 80 00       	push   $0x8030b6
  8001f8:	e8 2b 1b 00 00       	call   801d28 <open>
  8001fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	85 c0                	test   %eax,%eax
  800205:	78 57                	js     80025e <umain+0x173>
  800207:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020c:	bf 00 00 00 00       	mov    $0x0,%edi
  800211:	e9 9a 00 00 00       	jmp    8002b0 <umain+0x1c5>
		panic("open testshell.sh: %e", rfd);
  800216:	50                   	push   %eax
  800217:	68 75 30 80 00       	push   $0x803075
  80021c:	6a 13                	push   $0x13
  80021e:	68 8b 30 80 00       	push   $0x80308b
  800223:	e8 c8 02 00 00       	call   8004f0 <_panic>
		panic("pipe: %e", wfd);
  800228:	50                   	push   %eax
  800229:	68 9c 30 80 00       	push   $0x80309c
  80022e:	6a 15                	push   $0x15
  800230:	68 8b 30 80 00       	push   $0x80308b
  800235:	e8 b6 02 00 00       	call   8004f0 <_panic>
		panic("fork: %e", r);
  80023a:	50                   	push   %eax
  80023b:	68 a6 34 80 00       	push   $0x8034a6
  800240:	6a 1a                	push   $0x1a
  800242:	68 8b 30 80 00       	push   $0x80308b
  800247:	e8 a4 02 00 00       	call   8004f0 <_panic>
			panic("spawn: %e", r);
  80024c:	50                   	push   %eax
  80024d:	68 ac 30 80 00       	push   $0x8030ac
  800252:	6a 21                	push   $0x21
  800254:	68 8b 30 80 00       	push   $0x80308b
  800259:	e8 92 02 00 00       	call   8004f0 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025e:	50                   	push   %eax
  80025f:	68 28 30 80 00       	push   $0x803028
  800264:	6a 2c                	push   $0x2c
  800266:	68 8b 30 80 00       	push   $0x80308b
  80026b:	e8 80 02 00 00       	call   8004f0 <_panic>
			panic("reading testshell.out: %e", n1);
  800270:	53                   	push   %ebx
  800271:	68 c4 30 80 00       	push   $0x8030c4
  800276:	6a 33                	push   $0x33
  800278:	68 8b 30 80 00       	push   $0x80308b
  80027d:	e8 6e 02 00 00       	call   8004f0 <_panic>
			panic("reading testshell.key: %e", n2);
  800282:	50                   	push   %eax
  800283:	68 de 30 80 00       	push   $0x8030de
  800288:	6a 35                	push   $0x35
  80028a:	68 8b 30 80 00       	push   $0x80308b
  80028f:	e8 5c 02 00 00       	call   8004f0 <_panic>
			wrong(rfd, kfd, nloff);
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 d4             	pushl  -0x2c(%ebp)
  80029b:	ff 75 d0             	pushl  -0x30(%ebp)
  80029e:	e8 90 fd ff ff       	call   800033 <wrong>
  8002a3:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a6:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002aa:	0f 44 fe             	cmove  %esi,%edi
  8002ad:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	6a 01                	push   $0x1
  8002b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002bc:	e8 c3 15 00 00       	call   801884 <read>
  8002c1:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c3:	83 c4 0c             	add    $0xc,%esp
  8002c6:	6a 01                	push   $0x1
  8002c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002cb:	50                   	push   %eax
  8002cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cf:	e8 b0 15 00 00       	call   801884 <read>
		if (n1 < 0)
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	85 db                	test   %ebx,%ebx
  8002d9:	78 95                	js     800270 <umain+0x185>
		if (n2 < 0)
  8002db:	85 c0                	test   %eax,%eax
  8002dd:	78 a3                	js     800282 <umain+0x197>
		if (n1 == 0 && n2 == 0)
  8002df:	89 da                	mov    %ebx,%edx
  8002e1:	09 c2                	or     %eax,%edx
  8002e3:	74 15                	je     8002fa <umain+0x20f>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e5:	83 fb 01             	cmp    $0x1,%ebx
  8002e8:	75 aa                	jne    800294 <umain+0x1a9>
  8002ea:	83 f8 01             	cmp    $0x1,%eax
  8002ed:	75 a5                	jne    800294 <umain+0x1a9>
  8002ef:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f3:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f6:	75 9c                	jne    800294 <umain+0x1a9>
  8002f8:	eb ac                	jmp    8002a6 <umain+0x1bb>
	cprintf("shell ran correctly\n");
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 f8 30 80 00       	push   $0x8030f8
  800302:	e8 c4 02 00 00       	call   8005cb <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800307:	cc                   	int3   
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800323:	68 0d 31 80 00       	push   $0x80310d
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	e8 38 09 00 00       	call   800c68 <strcpy>
	return 0;
}
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <devcons_write>:
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	57                   	push   %edi
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
  80033d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800343:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800348:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80034e:	eb 2f                	jmp    80037f <devcons_write+0x48>
		m = n - tot;
  800350:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800353:	29 f3                	sub    %esi,%ebx
  800355:	83 fb 7f             	cmp    $0x7f,%ebx
  800358:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	53                   	push   %ebx
  800364:	89 f0                	mov    %esi,%eax
  800366:	03 45 0c             	add    0xc(%ebp),%eax
  800369:	50                   	push   %eax
  80036a:	57                   	push   %edi
  80036b:	e8 86 0a 00 00       	call   800df6 <memmove>
		sys_cputs(buf, m);
  800370:	83 c4 08             	add    $0x8,%esp
  800373:	53                   	push   %ebx
  800374:	57                   	push   %edi
  800375:	e8 2b 0c 00 00       	call   800fa5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80037a:	01 de                	add    %ebx,%esi
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800382:	72 cc                	jb     800350 <devcons_write+0x19>
}
  800384:	89 f0                	mov    %esi,%eax
  800386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800389:	5b                   	pop    %ebx
  80038a:	5e                   	pop    %esi
  80038b:	5f                   	pop    %edi
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <devcons_read>:
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80039d:	75 07                	jne    8003a6 <devcons_read+0x18>
}
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    
		sys_yield();
  8003a1:	e8 9c 0c 00 00       	call   801042 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8003a6:	e8 18 0c 00 00       	call   800fc3 <sys_cgetc>
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	74 f2                	je     8003a1 <devcons_read+0x13>
	if (c < 0)
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	78 ec                	js     80039f <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8003b3:	83 f8 04             	cmp    $0x4,%eax
  8003b6:	74 0c                	je     8003c4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8003b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bb:	88 02                	mov    %al,(%edx)
	return 1;
  8003bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8003c2:	eb db                	jmp    80039f <devcons_read+0x11>
		return 0;
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	eb d4                	jmp    80039f <devcons_read+0x11>

008003cb <cputchar>:
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003d7:	6a 01                	push   $0x1
  8003d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003dc:	50                   	push   %eax
  8003dd:	e8 c3 0b 00 00       	call   800fa5 <sys_cputs>
}
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <getchar>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003ed:	6a 01                	push   $0x1
  8003ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f2:	50                   	push   %eax
  8003f3:	6a 00                	push   $0x0
  8003f5:	e8 8a 14 00 00       	call   801884 <read>
	if (r < 0)
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	85 c0                	test   %eax,%eax
  8003ff:	78 08                	js     800409 <getchar+0x22>
	if (r < 1)
  800401:	85 c0                	test   %eax,%eax
  800403:	7e 06                	jle    80040b <getchar+0x24>
	return c;
  800405:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800409:	c9                   	leave  
  80040a:	c3                   	ret    
		return -E_EOF;
  80040b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800410:	eb f7                	jmp    800409 <getchar+0x22>

00800412 <iscons>:
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800418:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 ef 11 00 00       	call   801613 <fd_lookup>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	85 c0                	test   %eax,%eax
  800429:	78 11                	js     80043c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80042b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800434:	39 10                	cmp    %edx,(%eax)
  800436:	0f 94 c0             	sete   %al
  800439:	0f b6 c0             	movzbl %al,%eax
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <opencons>:
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800447:	50                   	push   %eax
  800448:	e8 77 11 00 00       	call   8015c4 <fd_alloc>
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 c0                	test   %eax,%eax
  800452:	78 3a                	js     80048e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 07 04 00 00       	push   $0x407
  80045c:	ff 75 f4             	pushl  -0xc(%ebp)
  80045f:	6a 00                	push   $0x0
  800461:	e8 fb 0b 00 00       	call   801061 <sys_page_alloc>
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	85 c0                	test   %eax,%eax
  80046b:	78 21                	js     80048e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80046d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800470:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800476:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	50                   	push   %eax
  800486:	e8 12 11 00 00       	call   80159d <fd2num>
  80048b:	83 c4 10             	add    $0x10,%esp
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	56                   	push   %esi
  800494:	53                   	push   %ebx
  800495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800498:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80049b:	e8 83 0b 00 00       	call   801023 <sys_getenvid>
  8004a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ad:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7e 07                	jle    8004bd <libmain+0x2d>
		binaryname = argv[0];
  8004b6:	8b 06                	mov    (%esi),%eax
  8004b8:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	56                   	push   %esi
  8004c1:	53                   	push   %ebx
  8004c2:	e8 24 fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c7:	e8 0a 00 00 00       	call   8004d6 <exit>
}
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004d2:	5b                   	pop    %ebx
  8004d3:	5e                   	pop    %esi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004dc:	e8 92 12 00 00       	call   801773 <close_all>
	sys_env_destroy(0);
  8004e1:	83 ec 0c             	sub    $0xc,%esp
  8004e4:	6a 00                	push   $0x0
  8004e6:	e8 f7 0a 00 00       	call   800fe2 <sys_env_destroy>
}
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	56                   	push   %esi
  8004f4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004f5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004f8:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004fe:	e8 20 0b 00 00       	call   801023 <sys_getenvid>
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	56                   	push   %esi
  80050d:	50                   	push   %eax
  80050e:	68 24 31 80 00       	push   $0x803124
  800513:	e8 b3 00 00 00       	call   8005cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800518:	83 c4 18             	add    $0x18,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 75 10             	pushl  0x10(%ebp)
  80051f:	e8 56 00 00 00       	call   80057a <vcprintf>
	cprintf("\n");
  800524:	c7 04 24 58 30 80 00 	movl   $0x803058,(%esp)
  80052b:	e8 9b 00 00 00       	call   8005cb <cprintf>
  800530:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800533:	cc                   	int3   
  800534:	eb fd                	jmp    800533 <_panic+0x43>

00800536 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	53                   	push   %ebx
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800540:	8b 13                	mov    (%ebx),%edx
  800542:	8d 42 01             	lea    0x1(%edx),%eax
  800545:	89 03                	mov    %eax,(%ebx)
  800547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80054a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80054e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800553:	74 09                	je     80055e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800555:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	68 ff 00 00 00       	push   $0xff
  800566:	8d 43 08             	lea    0x8(%ebx),%eax
  800569:	50                   	push   %eax
  80056a:	e8 36 0a 00 00       	call   800fa5 <sys_cputs>
		b->idx = 0;
  80056f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	eb db                	jmp    800555 <putch+0x1f>

0080057a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800583:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058a:	00 00 00 
	b.cnt = 0;
  80058d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800594:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800597:	ff 75 0c             	pushl  0xc(%ebp)
  80059a:	ff 75 08             	pushl  0x8(%ebp)
  80059d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a3:	50                   	push   %eax
  8005a4:	68 36 05 80 00       	push   $0x800536
  8005a9:	e8 1a 01 00 00       	call   8006c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ae:	83 c4 08             	add    $0x8,%esp
  8005b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	e8 e2 09 00 00       	call   800fa5 <sys_cputs>

	return b.cnt;
}
  8005c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	e8 9d ff ff ff       	call   80057a <vcprintf>
	va_end(ap);

	return cnt;
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	57                   	push   %edi
  8005e3:	56                   	push   %esi
  8005e4:	53                   	push   %ebx
  8005e5:	83 ec 1c             	sub    $0x1c,%esp
  8005e8:	89 c7                	mov    %eax,%edi
  8005ea:	89 d6                	mov    %edx,%esi
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800603:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800606:	39 d3                	cmp    %edx,%ebx
  800608:	72 05                	jb     80060f <printnum+0x30>
  80060a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80060d:	77 7a                	ja     800689 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80061b:	53                   	push   %ebx
  80061c:	ff 75 10             	pushl  0x10(%ebp)
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 e4             	pushl  -0x1c(%ebp)
  800625:	ff 75 e0             	pushl  -0x20(%ebp)
  800628:	ff 75 dc             	pushl  -0x24(%ebp)
  80062b:	ff 75 d8             	pushl  -0x28(%ebp)
  80062e:	e8 6d 27 00 00       	call   802da0 <__udivdi3>
  800633:	83 c4 18             	add    $0x18,%esp
  800636:	52                   	push   %edx
  800637:	50                   	push   %eax
  800638:	89 f2                	mov    %esi,%edx
  80063a:	89 f8                	mov    %edi,%eax
  80063c:	e8 9e ff ff ff       	call   8005df <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 13                	jmp    800659 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	56                   	push   %esi
  80064a:	ff 75 18             	pushl  0x18(%ebp)
  80064d:	ff d7                	call   *%edi
  80064f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800652:	83 eb 01             	sub    $0x1,%ebx
  800655:	85 db                	test   %ebx,%ebx
  800657:	7f ed                	jg     800646 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	56                   	push   %esi
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	ff 75 e4             	pushl  -0x1c(%ebp)
  800663:	ff 75 e0             	pushl  -0x20(%ebp)
  800666:	ff 75 dc             	pushl  -0x24(%ebp)
  800669:	ff 75 d8             	pushl  -0x28(%ebp)
  80066c:	e8 4f 28 00 00       	call   802ec0 <__umoddi3>
  800671:	83 c4 14             	add    $0x14,%esp
  800674:	0f be 80 47 31 80 00 	movsbl 0x803147(%eax),%eax
  80067b:	50                   	push   %eax
  80067c:	ff d7                	call   *%edi
}
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800684:	5b                   	pop    %ebx
  800685:	5e                   	pop    %esi
  800686:	5f                   	pop    %edi
  800687:	5d                   	pop    %ebp
  800688:	c3                   	ret    
  800689:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80068c:	eb c4                	jmp    800652 <printnum+0x73>

0080068e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800694:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	3b 50 04             	cmp    0x4(%eax),%edx
  80069d:	73 0a                	jae    8006a9 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006a2:	89 08                	mov    %ecx,(%eax)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	88 02                	mov    %al,(%edx)
}
  8006a9:	5d                   	pop    %ebp
  8006aa:	c3                   	ret    

008006ab <printfmt>:
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 10             	pushl  0x10(%ebp)
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 05 00 00 00       	call   8006c8 <vprintfmt>
}
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <vprintfmt>:
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	57                   	push   %edi
  8006cc:	56                   	push   %esi
  8006cd:	53                   	push   %ebx
  8006ce:	83 ec 2c             	sub    $0x2c,%esp
  8006d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006da:	e9 21 04 00 00       	jmp    800b00 <vprintfmt+0x438>
		padc = ' ';
  8006df:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006e3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006fd:	8d 47 01             	lea    0x1(%edi),%eax
  800700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800703:	0f b6 17             	movzbl (%edi),%edx
  800706:	8d 42 dd             	lea    -0x23(%edx),%eax
  800709:	3c 55                	cmp    $0x55,%al
  80070b:	0f 87 90 04 00 00    	ja     800ba1 <vprintfmt+0x4d9>
  800711:	0f b6 c0             	movzbl %al,%eax
  800714:	ff 24 85 80 32 80 00 	jmp    *0x803280(,%eax,4)
  80071b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80071e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800722:	eb d9                	jmp    8006fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800724:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800727:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80072b:	eb d0                	jmp    8006fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80072d:	0f b6 d2             	movzbl %dl,%edx
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80073b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80073e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800742:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800745:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800748:	83 f9 09             	cmp    $0x9,%ecx
  80074b:	77 55                	ja     8007a2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80074d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800750:	eb e9                	jmp    80073b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 40 04             	lea    0x4(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800763:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800766:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076a:	79 91                	jns    8006fd <vprintfmt+0x35>
				width = precision, precision = -1;
  80076c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80076f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800772:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800779:	eb 82                	jmp    8006fd <vprintfmt+0x35>
  80077b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80077e:	85 c0                	test   %eax,%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	0f 49 d0             	cmovns %eax,%edx
  800788:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80078e:	e9 6a ff ff ff       	jmp    8006fd <vprintfmt+0x35>
  800793:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800796:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80079d:	e9 5b ff ff ff       	jmp    8006fd <vprintfmt+0x35>
  8007a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a8:	eb bc                	jmp    800766 <vprintfmt+0x9e>
			lflag++;
  8007aa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007b0:	e9 48 ff ff ff       	jmp    8006fd <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 78 04             	lea    0x4(%eax),%edi
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	ff 30                	pushl  (%eax)
  8007c1:	ff d6                	call   *%esi
			break;
  8007c3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007c6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007c9:	e9 2f 03 00 00       	jmp    800afd <vprintfmt+0x435>
			err = va_arg(ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 78 04             	lea    0x4(%eax),%edi
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	99                   	cltd   
  8007d7:	31 d0                	xor    %edx,%eax
  8007d9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007db:	83 f8 0f             	cmp    $0xf,%eax
  8007de:	7f 23                	jg     800803 <vprintfmt+0x13b>
  8007e0:	8b 14 85 e0 33 80 00 	mov    0x8033e0(,%eax,4),%edx
  8007e7:	85 d2                	test   %edx,%edx
  8007e9:	74 18                	je     800803 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007eb:	52                   	push   %edx
  8007ec:	68 a3 35 80 00       	push   $0x8035a3
  8007f1:	53                   	push   %ebx
  8007f2:	56                   	push   %esi
  8007f3:	e8 b3 fe ff ff       	call   8006ab <printfmt>
  8007f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007fb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007fe:	e9 fa 02 00 00       	jmp    800afd <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800803:	50                   	push   %eax
  800804:	68 5f 31 80 00       	push   $0x80315f
  800809:	53                   	push   %ebx
  80080a:	56                   	push   %esi
  80080b:	e8 9b fe ff ff       	call   8006ab <printfmt>
  800810:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800813:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800816:	e9 e2 02 00 00       	jmp    800afd <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800829:	85 ff                	test   %edi,%edi
  80082b:	b8 58 31 80 00       	mov    $0x803158,%eax
  800830:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800833:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800837:	0f 8e bd 00 00 00    	jle    8008fa <vprintfmt+0x232>
  80083d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800841:	75 0e                	jne    800851 <vprintfmt+0x189>
  800843:	89 75 08             	mov    %esi,0x8(%ebp)
  800846:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800849:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80084c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80084f:	eb 6d                	jmp    8008be <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 d0             	pushl  -0x30(%ebp)
  800857:	57                   	push   %edi
  800858:	e8 ec 03 00 00       	call   800c49 <strnlen>
  80085d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800860:	29 c1                	sub    %eax,%ecx
  800862:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800865:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800868:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80086c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800872:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800874:	eb 0f                	jmp    800885 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	ff 75 e0             	pushl  -0x20(%ebp)
  80087d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80087f:	83 ef 01             	sub    $0x1,%edi
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	85 ff                	test   %edi,%edi
  800887:	7f ed                	jg     800876 <vprintfmt+0x1ae>
  800889:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80088c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80088f:	85 c9                	test   %ecx,%ecx
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	0f 49 c1             	cmovns %ecx,%eax
  800899:	29 c1                	sub    %eax,%ecx
  80089b:	89 75 08             	mov    %esi,0x8(%ebp)
  80089e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008a4:	89 cb                	mov    %ecx,%ebx
  8008a6:	eb 16                	jmp    8008be <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8008a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008ac:	75 31                	jne    8008df <vprintfmt+0x217>
					putch(ch, putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	ff 55 08             	call   *0x8(%ebp)
  8008b8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bb:	83 eb 01             	sub    $0x1,%ebx
  8008be:	83 c7 01             	add    $0x1,%edi
  8008c1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008c5:	0f be c2             	movsbl %dl,%eax
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	74 59                	je     800925 <vprintfmt+0x25d>
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	78 d8                	js     8008a8 <vprintfmt+0x1e0>
  8008d0:	83 ee 01             	sub    $0x1,%esi
  8008d3:	79 d3                	jns    8008a8 <vprintfmt+0x1e0>
  8008d5:	89 df                	mov    %ebx,%edi
  8008d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008dd:	eb 37                	jmp    800916 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008df:	0f be d2             	movsbl %dl,%edx
  8008e2:	83 ea 20             	sub    $0x20,%edx
  8008e5:	83 fa 5e             	cmp    $0x5e,%edx
  8008e8:	76 c4                	jbe    8008ae <vprintfmt+0x1e6>
					putch('?', putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	6a 3f                	push   $0x3f
  8008f2:	ff 55 08             	call   *0x8(%ebp)
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	eb c1                	jmp    8008bb <vprintfmt+0x1f3>
  8008fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8008fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800900:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800903:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800906:	eb b6                	jmp    8008be <vprintfmt+0x1f6>
				putch(' ', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	6a 20                	push   $0x20
  80090e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800910:	83 ef 01             	sub    $0x1,%edi
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	85 ff                	test   %edi,%edi
  800918:	7f ee                	jg     800908 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80091a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
  800920:	e9 d8 01 00 00       	jmp    800afd <vprintfmt+0x435>
  800925:	89 df                	mov    %ebx,%edi
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80092d:	eb e7                	jmp    800916 <vprintfmt+0x24e>
	if (lflag >= 2)
  80092f:	83 f9 01             	cmp    $0x1,%ecx
  800932:	7e 45                	jle    800979 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 50 04             	mov    0x4(%eax),%edx
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8d 40 08             	lea    0x8(%eax),%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80094b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094f:	79 62                	jns    8009b3 <vprintfmt+0x2eb>
				putch('-', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	53                   	push   %ebx
  800955:	6a 2d                	push   $0x2d
  800957:	ff d6                	call   *%esi
				num = -(long long) num;
  800959:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80095f:	f7 d8                	neg    %eax
  800961:	83 d2 00             	adc    $0x0,%edx
  800964:	f7 da                	neg    %edx
  800966:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800969:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80096f:	ba 0a 00 00 00       	mov    $0xa,%edx
  800974:	e9 66 01 00 00       	jmp    800adf <vprintfmt+0x417>
	else if (lflag)
  800979:	85 c9                	test   %ecx,%ecx
  80097b:	75 1b                	jne    800998 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800985:	89 c1                	mov    %eax,%ecx
  800987:	c1 f9 1f             	sar    $0x1f,%ecx
  80098a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	8d 40 04             	lea    0x4(%eax),%eax
  800993:	89 45 14             	mov    %eax,0x14(%ebp)
  800996:	eb b3                	jmp    80094b <vprintfmt+0x283>
		return va_arg(*ap, long);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a0:	89 c1                	mov    %eax,%ecx
  8009a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8009a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	8d 40 04             	lea    0x4(%eax),%eax
  8009ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b1:	eb 98                	jmp    80094b <vprintfmt+0x283>
			base = 10;
  8009b3:	ba 0a 00 00 00       	mov    $0xa,%edx
  8009b8:	e9 22 01 00 00       	jmp    800adf <vprintfmt+0x417>
	if (lflag >= 2)
  8009bd:	83 f9 01             	cmp    $0x1,%ecx
  8009c0:	7e 21                	jle    8009e3 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	8b 50 04             	mov    0x4(%eax),%edx
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d3:	8d 40 08             	lea    0x8(%eax),%eax
  8009d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8009de:	e9 fc 00 00 00       	jmp    800adf <vprintfmt+0x417>
	else if (lflag)
  8009e3:	85 c9                	test   %ecx,%ecx
  8009e5:	75 23                	jne    800a0a <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8009e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	8d 40 04             	lea    0x4(%eax),%eax
  8009fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a00:	ba 0a 00 00 00       	mov    $0xa,%edx
  800a05:	e9 d5 00 00 00       	jmp    800adf <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a17:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	8d 40 04             	lea    0x4(%eax),%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a23:	ba 0a 00 00 00       	mov    $0xa,%edx
  800a28:	e9 b2 00 00 00       	jmp    800adf <vprintfmt+0x417>
	if (lflag >= 2)
  800a2d:	83 f9 01             	cmp    $0x1,%ecx
  800a30:	7e 42                	jle    800a74 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	8b 50 04             	mov    0x4(%eax),%edx
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8d 40 08             	lea    0x8(%eax),%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a49:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800a4e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a52:	0f 89 87 00 00 00    	jns    800adf <vprintfmt+0x417>
				putch('-', putdat);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	53                   	push   %ebx
  800a5c:	6a 2d                	push   $0x2d
  800a5e:	ff d6                	call   *%esi
				num = -(long long) num;
  800a60:	f7 5d d8             	negl   -0x28(%ebp)
  800a63:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800a67:	f7 5d dc             	negl   -0x24(%ebp)
  800a6a:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800a6d:	ba 08 00 00 00       	mov    $0x8,%edx
  800a72:	eb 6b                	jmp    800adf <vprintfmt+0x417>
	else if (lflag)
  800a74:	85 c9                	test   %ecx,%ecx
  800a76:	75 1b                	jne    800a93 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800a78:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a85:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	8d 40 04             	lea    0x4(%eax),%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a91:	eb b6                	jmp    800a49 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	8b 00                	mov    (%eax),%eax
  800a98:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	8d 40 04             	lea    0x4(%eax),%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	eb 9b                	jmp    800a49 <vprintfmt+0x381>
			putch('0', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	53                   	push   %ebx
  800ab2:	6a 30                	push   $0x30
  800ab4:	ff d6                	call   *%esi
			putch('x', putdat);
  800ab6:	83 c4 08             	add    $0x8,%esp
  800ab9:	53                   	push   %ebx
  800aba:	6a 78                	push   $0x78
  800abc:	ff d6                	call   *%esi
			num = (unsigned long long)
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	8b 00                	mov    (%eax),%eax
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acb:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800ace:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad4:	8d 40 04             	lea    0x4(%eax),%eax
  800ad7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ada:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800adf:	83 ec 0c             	sub    $0xc,%esp
  800ae2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800ae6:	50                   	push   %eax
  800ae7:	ff 75 e0             	pushl  -0x20(%ebp)
  800aea:	52                   	push   %edx
  800aeb:	ff 75 dc             	pushl  -0x24(%ebp)
  800aee:	ff 75 d8             	pushl  -0x28(%ebp)
  800af1:	89 da                	mov    %ebx,%edx
  800af3:	89 f0                	mov    %esi,%eax
  800af5:	e8 e5 fa ff ff       	call   8005df <printnum>
			break;
  800afa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800afd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b00:	83 c7 01             	add    $0x1,%edi
  800b03:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b07:	83 f8 25             	cmp    $0x25,%eax
  800b0a:	0f 84 cf fb ff ff    	je     8006df <vprintfmt+0x17>
			if (ch == '\0')
  800b10:	85 c0                	test   %eax,%eax
  800b12:	0f 84 a9 00 00 00    	je     800bc1 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	53                   	push   %ebx
  800b1c:	50                   	push   %eax
  800b1d:	ff d6                	call   *%esi
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	eb dc                	jmp    800b00 <vprintfmt+0x438>
	if (lflag >= 2)
  800b24:	83 f9 01             	cmp    $0x1,%ecx
  800b27:	7e 1e                	jle    800b47 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800b29:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2c:	8b 50 04             	mov    0x4(%eax),%edx
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b37:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3a:	8d 40 08             	lea    0x8(%eax),%eax
  800b3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b40:	ba 10 00 00 00       	mov    $0x10,%edx
  800b45:	eb 98                	jmp    800adf <vprintfmt+0x417>
	else if (lflag)
  800b47:	85 c9                	test   %ecx,%ecx
  800b49:	75 23                	jne    800b6e <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	ba 00 00 00 00       	mov    $0x0,%edx
  800b55:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b58:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5e:	8d 40 04             	lea    0x4(%eax),%eax
  800b61:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b64:	ba 10 00 00 00       	mov    $0x10,%edx
  800b69:	e9 71 ff ff ff       	jmp    800adf <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	ba 00 00 00 00       	mov    $0x0,%edx
  800b78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b81:	8d 40 04             	lea    0x4(%eax),%eax
  800b84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b87:	ba 10 00 00 00       	mov    $0x10,%edx
  800b8c:	e9 4e ff ff ff       	jmp    800adf <vprintfmt+0x417>
			putch(ch, putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	53                   	push   %ebx
  800b95:	6a 25                	push   $0x25
  800b97:	ff d6                	call   *%esi
			break;
  800b99:	83 c4 10             	add    $0x10,%esp
  800b9c:	e9 5c ff ff ff       	jmp    800afd <vprintfmt+0x435>
			putch('%', putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	53                   	push   %ebx
  800ba5:	6a 25                	push   $0x25
  800ba7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba9:	83 c4 10             	add    $0x10,%esp
  800bac:	89 f8                	mov    %edi,%eax
  800bae:	eb 03                	jmp    800bb3 <vprintfmt+0x4eb>
  800bb0:	83 e8 01             	sub    $0x1,%eax
  800bb3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bb7:	75 f7                	jne    800bb0 <vprintfmt+0x4e8>
  800bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bbc:	e9 3c ff ff ff       	jmp    800afd <vprintfmt+0x435>
}
  800bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bdc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800be6:	85 c0                	test   %eax,%eax
  800be8:	74 26                	je     800c10 <vsnprintf+0x47>
  800bea:	85 d2                	test   %edx,%edx
  800bec:	7e 22                	jle    800c10 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bee:	ff 75 14             	pushl  0x14(%ebp)
  800bf1:	ff 75 10             	pushl  0x10(%ebp)
  800bf4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf7:	50                   	push   %eax
  800bf8:	68 8e 06 80 00       	push   $0x80068e
  800bfd:	e8 c6 fa ff ff       	call   8006c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c05:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c0b:	83 c4 10             	add    $0x10,%esp
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    
		return -E_INVAL;
  800c10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c15:	eb f7                	jmp    800c0e <vsnprintf+0x45>

00800c17 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c1d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c20:	50                   	push   %eax
  800c21:	ff 75 10             	pushl  0x10(%ebp)
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	ff 75 08             	pushl  0x8(%ebp)
  800c2a:	e8 9a ff ff ff       	call   800bc9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	eb 03                	jmp    800c41 <strlen+0x10>
		n++;
  800c3e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800c41:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c45:	75 f7                	jne    800c3e <strlen+0xd>
	return n;
}
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c52:	b8 00 00 00 00       	mov    $0x0,%eax
  800c57:	eb 03                	jmp    800c5c <strnlen+0x13>
		n++;
  800c59:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5c:	39 d0                	cmp    %edx,%eax
  800c5e:	74 06                	je     800c66 <strnlen+0x1d>
  800c60:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c64:	75 f3                	jne    800c59 <strnlen+0x10>
	return n;
}
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	53                   	push   %ebx
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c72:	89 c2                	mov    %eax,%edx
  800c74:	83 c1 01             	add    $0x1,%ecx
  800c77:	83 c2 01             	add    $0x1,%edx
  800c7a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c7e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c81:	84 db                	test   %bl,%bl
  800c83:	75 ef                	jne    800c74 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c85:	5b                   	pop    %ebx
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	53                   	push   %ebx
  800c8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c8f:	53                   	push   %ebx
  800c90:	e8 9c ff ff ff       	call   800c31 <strlen>
  800c95:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	01 d8                	add    %ebx,%eax
  800c9d:	50                   	push   %eax
  800c9e:	e8 c5 ff ff ff       	call   800c68 <strcpy>
	return dst;
}
  800ca3:	89 d8                	mov    %ebx,%eax
  800ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	8b 75 08             	mov    0x8(%ebp),%esi
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb5:	89 f3                	mov    %esi,%ebx
  800cb7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cba:	89 f2                	mov    %esi,%edx
  800cbc:	eb 0f                	jmp    800ccd <strncpy+0x23>
		*dst++ = *src;
  800cbe:	83 c2 01             	add    $0x1,%edx
  800cc1:	0f b6 01             	movzbl (%ecx),%eax
  800cc4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cc7:	80 39 01             	cmpb   $0x1,(%ecx)
  800cca:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ccd:	39 da                	cmp    %ebx,%edx
  800ccf:	75 ed                	jne    800cbe <strncpy+0x14>
	}
	return ret;
}
  800cd1:	89 f0                	mov    %esi,%eax
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	8b 75 08             	mov    0x8(%ebp),%esi
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ce5:	89 f0                	mov    %esi,%eax
  800ce7:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ceb:	85 c9                	test   %ecx,%ecx
  800ced:	75 0b                	jne    800cfa <strlcpy+0x23>
  800cef:	eb 17                	jmp    800d08 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cf1:	83 c2 01             	add    $0x1,%edx
  800cf4:	83 c0 01             	add    $0x1,%eax
  800cf7:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800cfa:	39 d8                	cmp    %ebx,%eax
  800cfc:	74 07                	je     800d05 <strlcpy+0x2e>
  800cfe:	0f b6 0a             	movzbl (%edx),%ecx
  800d01:	84 c9                	test   %cl,%cl
  800d03:	75 ec                	jne    800cf1 <strlcpy+0x1a>
		*dst = '\0';
  800d05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d08:	29 f0                	sub    %esi,%eax
}
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d14:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d17:	eb 06                	jmp    800d1f <strcmp+0x11>
		p++, q++;
  800d19:	83 c1 01             	add    $0x1,%ecx
  800d1c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800d1f:	0f b6 01             	movzbl (%ecx),%eax
  800d22:	84 c0                	test   %al,%al
  800d24:	74 04                	je     800d2a <strcmp+0x1c>
  800d26:	3a 02                	cmp    (%edx),%al
  800d28:	74 ef                	je     800d19 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2a:	0f b6 c0             	movzbl %al,%eax
  800d2d:	0f b6 12             	movzbl (%edx),%edx
  800d30:	29 d0                	sub    %edx,%eax
}
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	53                   	push   %ebx
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	89 c3                	mov    %eax,%ebx
  800d40:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d43:	eb 06                	jmp    800d4b <strncmp+0x17>
		n--, p++, q++;
  800d45:	83 c0 01             	add    $0x1,%eax
  800d48:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d4b:	39 d8                	cmp    %ebx,%eax
  800d4d:	74 16                	je     800d65 <strncmp+0x31>
  800d4f:	0f b6 08             	movzbl (%eax),%ecx
  800d52:	84 c9                	test   %cl,%cl
  800d54:	74 04                	je     800d5a <strncmp+0x26>
  800d56:	3a 0a                	cmp    (%edx),%cl
  800d58:	74 eb                	je     800d45 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5a:	0f b6 00             	movzbl (%eax),%eax
  800d5d:	0f b6 12             	movzbl (%edx),%edx
  800d60:	29 d0                	sub    %edx,%eax
}
  800d62:	5b                   	pop    %ebx
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    
		return 0;
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6a:	eb f6                	jmp    800d62 <strncmp+0x2e>

00800d6c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d76:	0f b6 10             	movzbl (%eax),%edx
  800d79:	84 d2                	test   %dl,%dl
  800d7b:	74 09                	je     800d86 <strchr+0x1a>
		if (*s == c)
  800d7d:	38 ca                	cmp    %cl,%dl
  800d7f:	74 0a                	je     800d8b <strchr+0x1f>
	for (; *s; s++)
  800d81:	83 c0 01             	add    $0x1,%eax
  800d84:	eb f0                	jmp    800d76 <strchr+0xa>
			return (char *) s;
	return 0;
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d97:	eb 03                	jmp    800d9c <strfind+0xf>
  800d99:	83 c0 01             	add    $0x1,%eax
  800d9c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d9f:	38 ca                	cmp    %cl,%dl
  800da1:	74 04                	je     800da7 <strfind+0x1a>
  800da3:	84 d2                	test   %dl,%dl
  800da5:	75 f2                	jne    800d99 <strfind+0xc>
			break;
	return (char *) s;
}
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800db2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800db5:	85 c9                	test   %ecx,%ecx
  800db7:	74 13                	je     800dcc <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800db9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dbf:	75 05                	jne    800dc6 <memset+0x1d>
  800dc1:	f6 c1 03             	test   $0x3,%cl
  800dc4:	74 0d                	je     800dd3 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	fc                   	cld    
  800dca:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dcc:	89 f8                	mov    %edi,%eax
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    
		c &= 0xFF;
  800dd3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dd7:	89 d3                	mov    %edx,%ebx
  800dd9:	c1 e3 08             	shl    $0x8,%ebx
  800ddc:	89 d0                	mov    %edx,%eax
  800dde:	c1 e0 18             	shl    $0x18,%eax
  800de1:	89 d6                	mov    %edx,%esi
  800de3:	c1 e6 10             	shl    $0x10,%esi
  800de6:	09 f0                	or     %esi,%eax
  800de8:	09 c2                	or     %eax,%edx
  800dea:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800dec:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800def:	89 d0                	mov    %edx,%eax
  800df1:	fc                   	cld    
  800df2:	f3 ab                	rep stos %eax,%es:(%edi)
  800df4:	eb d6                	jmp    800dcc <memset+0x23>

00800df6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e04:	39 c6                	cmp    %eax,%esi
  800e06:	73 35                	jae    800e3d <memmove+0x47>
  800e08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e0b:	39 c2                	cmp    %eax,%edx
  800e0d:	76 2e                	jbe    800e3d <memmove+0x47>
		s += n;
		d += n;
  800e0f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e12:	89 d6                	mov    %edx,%esi
  800e14:	09 fe                	or     %edi,%esi
  800e16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e1c:	74 0c                	je     800e2a <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e1e:	83 ef 01             	sub    $0x1,%edi
  800e21:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e24:	fd                   	std    
  800e25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e27:	fc                   	cld    
  800e28:	eb 21                	jmp    800e4b <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e2a:	f6 c1 03             	test   $0x3,%cl
  800e2d:	75 ef                	jne    800e1e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e2f:	83 ef 04             	sub    $0x4,%edi
  800e32:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e38:	fd                   	std    
  800e39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e3b:	eb ea                	jmp    800e27 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e3d:	89 f2                	mov    %esi,%edx
  800e3f:	09 c2                	or     %eax,%edx
  800e41:	f6 c2 03             	test   $0x3,%dl
  800e44:	74 09                	je     800e4f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e46:	89 c7                	mov    %eax,%edi
  800e48:	fc                   	cld    
  800e49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e4f:	f6 c1 03             	test   $0x3,%cl
  800e52:	75 f2                	jne    800e46 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e57:	89 c7                	mov    %eax,%edi
  800e59:	fc                   	cld    
  800e5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e5c:	eb ed                	jmp    800e4b <memmove+0x55>

00800e5e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800e61:	ff 75 10             	pushl  0x10(%ebp)
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	ff 75 08             	pushl  0x8(%ebp)
  800e6a:	e8 87 ff ff ff       	call   800df6 <memmove>
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7c:	89 c6                	mov    %eax,%esi
  800e7e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e81:	39 f0                	cmp    %esi,%eax
  800e83:	74 1c                	je     800ea1 <memcmp+0x30>
		if (*s1 != *s2)
  800e85:	0f b6 08             	movzbl (%eax),%ecx
  800e88:	0f b6 1a             	movzbl (%edx),%ebx
  800e8b:	38 d9                	cmp    %bl,%cl
  800e8d:	75 08                	jne    800e97 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e8f:	83 c0 01             	add    $0x1,%eax
  800e92:	83 c2 01             	add    $0x1,%edx
  800e95:	eb ea                	jmp    800e81 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e97:	0f b6 c1             	movzbl %cl,%eax
  800e9a:	0f b6 db             	movzbl %bl,%ebx
  800e9d:	29 d8                	sub    %ebx,%eax
  800e9f:	eb 05                	jmp    800ea6 <memcmp+0x35>
	}

	return 0;
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    

00800eaa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800eb8:	39 d0                	cmp    %edx,%eax
  800eba:	73 09                	jae    800ec5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ebc:	38 08                	cmp    %cl,(%eax)
  800ebe:	74 05                	je     800ec5 <memfind+0x1b>
	for (; s < ends; s++)
  800ec0:	83 c0 01             	add    $0x1,%eax
  800ec3:	eb f3                	jmp    800eb8 <memfind+0xe>
			break;
	return (void *) s;
}
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed3:	eb 03                	jmp    800ed8 <strtol+0x11>
		s++;
  800ed5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ed8:	0f b6 01             	movzbl (%ecx),%eax
  800edb:	3c 20                	cmp    $0x20,%al
  800edd:	74 f6                	je     800ed5 <strtol+0xe>
  800edf:	3c 09                	cmp    $0x9,%al
  800ee1:	74 f2                	je     800ed5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ee3:	3c 2b                	cmp    $0x2b,%al
  800ee5:	74 2e                	je     800f15 <strtol+0x4e>
	int neg = 0;
  800ee7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eec:	3c 2d                	cmp    $0x2d,%al
  800eee:	74 2f                	je     800f1f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ef0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ef6:	75 05                	jne    800efd <strtol+0x36>
  800ef8:	80 39 30             	cmpb   $0x30,(%ecx)
  800efb:	74 2c                	je     800f29 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800efd:	85 db                	test   %ebx,%ebx
  800eff:	75 0a                	jne    800f0b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f01:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800f06:	80 39 30             	cmpb   $0x30,(%ecx)
  800f09:	74 28                	je     800f33 <strtol+0x6c>
		base = 10;
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f10:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f13:	eb 50                	jmp    800f65 <strtol+0x9e>
		s++;
  800f15:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f18:	bf 00 00 00 00       	mov    $0x0,%edi
  800f1d:	eb d1                	jmp    800ef0 <strtol+0x29>
		s++, neg = 1;
  800f1f:	83 c1 01             	add    $0x1,%ecx
  800f22:	bf 01 00 00 00       	mov    $0x1,%edi
  800f27:	eb c7                	jmp    800ef0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f29:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f2d:	74 0e                	je     800f3d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f2f:	85 db                	test   %ebx,%ebx
  800f31:	75 d8                	jne    800f0b <strtol+0x44>
		s++, base = 8;
  800f33:	83 c1 01             	add    $0x1,%ecx
  800f36:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f3b:	eb ce                	jmp    800f0b <strtol+0x44>
		s += 2, base = 16;
  800f3d:	83 c1 02             	add    $0x2,%ecx
  800f40:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f45:	eb c4                	jmp    800f0b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f47:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f4a:	89 f3                	mov    %esi,%ebx
  800f4c:	80 fb 19             	cmp    $0x19,%bl
  800f4f:	77 29                	ja     800f7a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f51:	0f be d2             	movsbl %dl,%edx
  800f54:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f57:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f5a:	7d 30                	jge    800f8c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f5c:	83 c1 01             	add    $0x1,%ecx
  800f5f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f65:	0f b6 11             	movzbl (%ecx),%edx
  800f68:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f6b:	89 f3                	mov    %esi,%ebx
  800f6d:	80 fb 09             	cmp    $0x9,%bl
  800f70:	77 d5                	ja     800f47 <strtol+0x80>
			dig = *s - '0';
  800f72:	0f be d2             	movsbl %dl,%edx
  800f75:	83 ea 30             	sub    $0x30,%edx
  800f78:	eb dd                	jmp    800f57 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800f7a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f7d:	89 f3                	mov    %esi,%ebx
  800f7f:	80 fb 19             	cmp    $0x19,%bl
  800f82:	77 08                	ja     800f8c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f84:	0f be d2             	movsbl %dl,%edx
  800f87:	83 ea 37             	sub    $0x37,%edx
  800f8a:	eb cb                	jmp    800f57 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f90:	74 05                	je     800f97 <strtol+0xd0>
		*endptr = (char *) s;
  800f92:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f95:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f97:	89 c2                	mov    %eax,%edx
  800f99:	f7 da                	neg    %edx
  800f9b:	85 ff                	test   %edi,%edi
  800f9d:	0f 45 c2             	cmovne %edx,%eax
}
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fab:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	89 c3                	mov    %eax,%ebx
  800fb8:	89 c7                	mov    %eax,%edi
  800fba:	89 c6                	mov    %eax,%esi
  800fbc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	89 d1                	mov    %edx,%ecx
  800fd5:	89 d3                	mov    %edx,%ebx
  800fd7:	89 d7                	mov    %edx,%edi
  800fd9:	89 d6                	mov    %edx,%esi
  800fdb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fdd:	5b                   	pop    %ebx
  800fde:	5e                   	pop    %esi
  800fdf:	5f                   	pop    %edi
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800feb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff8:	89 cb                	mov    %ecx,%ebx
  800ffa:	89 cf                	mov    %ecx,%edi
  800ffc:	89 ce                	mov    %ecx,%esi
  800ffe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801000:	85 c0                	test   %eax,%eax
  801002:	7f 08                	jg     80100c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801004:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100c:	83 ec 0c             	sub    $0xc,%esp
  80100f:	50                   	push   %eax
  801010:	6a 03                	push   $0x3
  801012:	68 3f 34 80 00       	push   $0x80343f
  801017:	6a 23                	push   $0x23
  801019:	68 5c 34 80 00       	push   $0x80345c
  80101e:	e8 cd f4 ff ff       	call   8004f0 <_panic>

00801023 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
	asm volatile("int %1\n"
  801029:	ba 00 00 00 00       	mov    $0x0,%edx
  80102e:	b8 02 00 00 00       	mov    $0x2,%eax
  801033:	89 d1                	mov    %edx,%ecx
  801035:	89 d3                	mov    %edx,%ebx
  801037:	89 d7                	mov    %edx,%edi
  801039:	89 d6                	mov    %edx,%esi
  80103b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80103d:	5b                   	pop    %ebx
  80103e:	5e                   	pop    %esi
  80103f:	5f                   	pop    %edi
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    

00801042 <sys_yield>:

void
sys_yield(void)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
	asm volatile("int %1\n"
  801048:	ba 00 00 00 00       	mov    $0x0,%edx
  80104d:	b8 0b 00 00 00       	mov    $0xb,%eax
  801052:	89 d1                	mov    %edx,%ecx
  801054:	89 d3                	mov    %edx,%ebx
  801056:	89 d7                	mov    %edx,%edi
  801058:	89 d6                	mov    %edx,%esi
  80105a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    

00801061 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	57                   	push   %edi
  801065:	56                   	push   %esi
  801066:	53                   	push   %ebx
  801067:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80106a:	be 00 00 00 00       	mov    $0x0,%esi
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801075:	b8 04 00 00 00       	mov    $0x4,%eax
  80107a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80107d:	89 f7                	mov    %esi,%edi
  80107f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801081:	85 c0                	test   %eax,%eax
  801083:	7f 08                	jg     80108d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801085:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	50                   	push   %eax
  801091:	6a 04                	push   $0x4
  801093:	68 3f 34 80 00       	push   $0x80343f
  801098:	6a 23                	push   $0x23
  80109a:	68 5c 34 80 00       	push   $0x80345c
  80109f:	e8 4c f4 ff ff       	call   8004f0 <_panic>

008010a4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	57                   	push   %edi
  8010a8:	56                   	push   %esi
  8010a9:	53                   	push   %ebx
  8010aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8010b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010bb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010be:	8b 75 18             	mov    0x18(%ebp),%esi
  8010c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	7f 08                	jg     8010cf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	50                   	push   %eax
  8010d3:	6a 05                	push   $0x5
  8010d5:	68 3f 34 80 00       	push   $0x80343f
  8010da:	6a 23                	push   $0x23
  8010dc:	68 5c 34 80 00       	push   $0x80345c
  8010e1:	e8 0a f4 ff ff       	call   8004f0 <_panic>

008010e6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	57                   	push   %edi
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
  8010ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fa:	b8 06 00 00 00       	mov    $0x6,%eax
  8010ff:	89 df                	mov    %ebx,%edi
  801101:	89 de                	mov    %ebx,%esi
  801103:	cd 30                	int    $0x30
	if(check && ret > 0)
  801105:	85 c0                	test   %eax,%eax
  801107:	7f 08                	jg     801111 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5f                   	pop    %edi
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	50                   	push   %eax
  801115:	6a 06                	push   $0x6
  801117:	68 3f 34 80 00       	push   $0x80343f
  80111c:	6a 23                	push   $0x23
  80111e:	68 5c 34 80 00       	push   $0x80345c
  801123:	e8 c8 f3 ff ff       	call   8004f0 <_panic>

00801128 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
  80112e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801131:	bb 00 00 00 00       	mov    $0x0,%ebx
  801136:	8b 55 08             	mov    0x8(%ebp),%edx
  801139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113c:	b8 08 00 00 00       	mov    $0x8,%eax
  801141:	89 df                	mov    %ebx,%edi
  801143:	89 de                	mov    %ebx,%esi
  801145:	cd 30                	int    $0x30
	if(check && ret > 0)
  801147:	85 c0                	test   %eax,%eax
  801149:	7f 08                	jg     801153 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80114b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	50                   	push   %eax
  801157:	6a 08                	push   $0x8
  801159:	68 3f 34 80 00       	push   $0x80343f
  80115e:	6a 23                	push   $0x23
  801160:	68 5c 34 80 00       	push   $0x80345c
  801165:	e8 86 f3 ff ff       	call   8004f0 <_panic>

0080116a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	57                   	push   %edi
  80116e:	56                   	push   %esi
  80116f:	53                   	push   %ebx
  801170:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801173:	bb 00 00 00 00       	mov    $0x0,%ebx
  801178:	8b 55 08             	mov    0x8(%ebp),%edx
  80117b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117e:	b8 09 00 00 00       	mov    $0x9,%eax
  801183:	89 df                	mov    %ebx,%edi
  801185:	89 de                	mov    %ebx,%esi
  801187:	cd 30                	int    $0x30
	if(check && ret > 0)
  801189:	85 c0                	test   %eax,%eax
  80118b:	7f 08                	jg     801195 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80118d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5f                   	pop    %edi
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	50                   	push   %eax
  801199:	6a 09                	push   $0x9
  80119b:	68 3f 34 80 00       	push   $0x80343f
  8011a0:	6a 23                	push   $0x23
  8011a2:	68 5c 34 80 00       	push   $0x80345c
  8011a7:	e8 44 f3 ff ff       	call   8004f0 <_panic>

008011ac <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011c5:	89 df                	mov    %ebx,%edi
  8011c7:	89 de                	mov    %ebx,%esi
  8011c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	7f 08                	jg     8011d7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	50                   	push   %eax
  8011db:	6a 0a                	push   $0xa
  8011dd:	68 3f 34 80 00       	push   $0x80343f
  8011e2:	6a 23                	push   $0x23
  8011e4:	68 5c 34 80 00       	push   $0x80345c
  8011e9:	e8 02 f3 ff ff       	call   8004f0 <_panic>

008011ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fa:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ff:	be 00 00 00 00       	mov    $0x0,%esi
  801204:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801207:	8b 7d 14             	mov    0x14(%ebp),%edi
  80120a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80121a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	b8 0d 00 00 00       	mov    $0xd,%eax
  801227:	89 cb                	mov    %ecx,%ebx
  801229:	89 cf                	mov    %ecx,%edi
  80122b:	89 ce                	mov    %ecx,%esi
  80122d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80122f:	85 c0                	test   %eax,%eax
  801231:	7f 08                	jg     80123b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801233:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801236:	5b                   	pop    %ebx
  801237:	5e                   	pop    %esi
  801238:	5f                   	pop    %edi
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	50                   	push   %eax
  80123f:	6a 0d                	push   $0xd
  801241:	68 3f 34 80 00       	push   $0x80343f
  801246:	6a 23                	push   $0x23
  801248:	68 5c 34 80 00       	push   $0x80345c
  80124d:	e8 9e f2 ff ff       	call   8004f0 <_panic>

00801252 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	57                   	push   %edi
  801256:	56                   	push   %esi
  801257:	53                   	push   %ebx
	asm volatile("int %1\n"
  801258:	ba 00 00 00 00       	mov    $0x0,%edx
  80125d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801262:	89 d1                	mov    %edx,%ecx
  801264:	89 d3                	mov    %edx,%ebx
  801266:	89 d7                	mov    %edx,%edi
  801268:	89 d6                	mov    %edx,%esi
  80126a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80126c:	5b                   	pop    %ebx
  80126d:	5e                   	pop    %esi
  80126e:	5f                   	pop    %edi
  80126f:	5d                   	pop    %ebp
  801270:	c3                   	ret    

00801271 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	57                   	push   %edi
  801275:	56                   	push   %esi
  801276:	53                   	push   %ebx
  801277:	83 ec 1c             	sub    $0x1c,%esp
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  80127d:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  80127f:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  801282:	89 d8                	mov    %ebx,%eax
  801284:	c1 e8 0c             	shr    $0xc,%eax
  801287:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  801291:	e8 8d fd ff ff       	call   801023 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  801296:	f7 c7 02 00 00 00    	test   $0x2,%edi
  80129c:	74 73                	je     801311 <pgfault+0xa0>
  80129e:	89 c6                	mov    %eax,%esi
  8012a0:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  8012a7:	74 68                	je     801311 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	6a 07                	push   $0x7
  8012ae:	68 00 f0 7f 00       	push   $0x7ff000
  8012b3:	50                   	push   %eax
  8012b4:	e8 a8 fd ff ff       	call   801061 <sys_page_alloc>
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	75 65                	jne    801325 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8012c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	68 00 10 00 00       	push   $0x1000
  8012ce:	53                   	push   %ebx
  8012cf:	68 00 f0 7f 00       	push   $0x7ff000
  8012d4:	e8 85 fb ff ff       	call   800e5e <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8012d9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012e0:	53                   	push   %ebx
  8012e1:	56                   	push   %esi
  8012e2:	68 00 f0 7f 00       	push   $0x7ff000
  8012e7:	56                   	push   %esi
  8012e8:	e8 b7 fd ff ff       	call   8010a4 <sys_page_map>
  8012ed:	83 c4 20             	add    $0x20,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	75 43                	jne    801337 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	68 00 f0 7f 00       	push   $0x7ff000
  8012fc:	56                   	push   %esi
  8012fd:	e8 e4 fd ff ff       	call   8010e6 <sys_page_unmap>
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	75 40                	jne    801349 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  801309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130c:	5b                   	pop    %ebx
  80130d:	5e                   	pop    %esi
  80130e:	5f                   	pop    %edi
  80130f:	5d                   	pop    %ebp
  801310:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	68 6a 34 80 00       	push   $0x80346a
  801319:	6a 1f                	push   $0x1f
  80131b:	68 88 34 80 00       	push   $0x803488
  801320:	e8 cb f1 ff ff       	call   8004f0 <_panic>
	    panic("pgfault: %e", r);
  801325:	50                   	push   %eax
  801326:	68 93 34 80 00       	push   $0x803493
  80132b:	6a 2a                	push   $0x2a
  80132d:	68 88 34 80 00       	push   $0x803488
  801332:	e8 b9 f1 ff ff       	call   8004f0 <_panic>
	    panic("pgfault: %e", r);
  801337:	50                   	push   %eax
  801338:	68 93 34 80 00       	push   $0x803493
  80133d:	6a 2e                	push   $0x2e
  80133f:	68 88 34 80 00       	push   $0x803488
  801344:	e8 a7 f1 ff ff       	call   8004f0 <_panic>
	    panic("pgfault: %e", r);
  801349:	50                   	push   %eax
  80134a:	68 93 34 80 00       	push   $0x803493
  80134f:	6a 31                	push   $0x31
  801351:	68 88 34 80 00       	push   $0x803488
  801356:	e8 95 f1 ff ff       	call   8004f0 <_panic>

0080135b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	57                   	push   %edi
  80135f:	56                   	push   %esi
  801360:	53                   	push   %ebx
  801361:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  801364:	68 71 12 80 00       	push   $0x801271
  801369:	e8 55 18 00 00       	call   802bc3 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80136e:	b8 07 00 00 00       	mov    $0x7,%eax
  801373:	cd 30                	int    $0x30
  801375:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801378:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	85 c0                	test   %eax,%eax
  801380:	78 2b                	js     8013ad <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801382:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801387:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80138b:	0f 85 b5 00 00 00    	jne    801446 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  801391:	e8 8d fc ff ff       	call   801023 <sys_getenvid>
  801396:	25 ff 03 00 00       	and    $0x3ff,%eax
  80139b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80139e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013a3:	a3 08 50 80 00       	mov    %eax,0x805008
	    return 0;
  8013a8:	e9 8c 01 00 00       	jmp    801539 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  8013ad:	50                   	push   %eax
  8013ae:	68 9f 34 80 00       	push   $0x80349f
  8013b3:	6a 77                	push   $0x77
  8013b5:	68 88 34 80 00       	push   $0x803488
  8013ba:	e8 31 f1 ff ff       	call   8004f0 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  8013bf:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013c6:	83 ec 0c             	sub    $0xc,%esp
  8013c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ce:	50                   	push   %eax
  8013cf:	57                   	push   %edi
  8013d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8013d3:	57                   	push   %edi
  8013d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013d7:	e8 c8 fc ff ff       	call   8010a4 <sys_page_map>
  8013dc:	83 c4 20             	add    $0x20,%esp
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	74 51                	je     801434 <fork+0xd9>
           panic("duppage: %e", r);
  8013e3:	50                   	push   %eax
  8013e4:	68 af 34 80 00       	push   $0x8034af
  8013e9:	6a 4a                	push   $0x4a
  8013eb:	68 88 34 80 00       	push   $0x803488
  8013f0:	e8 fb f0 ff ff       	call   8004f0 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	68 05 08 00 00       	push   $0x805
  8013fd:	57                   	push   %edi
  8013fe:	ff 75 e0             	pushl  -0x20(%ebp)
  801401:	57                   	push   %edi
  801402:	ff 75 e4             	pushl  -0x1c(%ebp)
  801405:	e8 9a fc ff ff       	call   8010a4 <sys_page_map>
  80140a:	83 c4 20             	add    $0x20,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	0f 85 bc 00 00 00    	jne    8014d1 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801415:	83 ec 0c             	sub    $0xc,%esp
  801418:	68 05 08 00 00       	push   $0x805
  80141d:	57                   	push   %edi
  80141e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801421:	50                   	push   %eax
  801422:	57                   	push   %edi
  801423:	50                   	push   %eax
  801424:	e8 7b fc ff ff       	call   8010a4 <sys_page_map>
  801429:	83 c4 20             	add    $0x20,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	0f 85 af 00 00 00    	jne    8014e3 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801434:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80143a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801440:	0f 84 af 00 00 00    	je     8014f5 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801446:	89 d8                	mov    %ebx,%eax
  801448:	c1 e8 16             	shr    $0x16,%eax
  80144b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801452:	a8 01                	test   $0x1,%al
  801454:	74 de                	je     801434 <fork+0xd9>
  801456:	89 de                	mov    %ebx,%esi
  801458:	c1 ee 0c             	shr    $0xc,%esi
  80145b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801462:	a8 01                	test   $0x1,%al
  801464:	74 ce                	je     801434 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  801466:	e8 b8 fb ff ff       	call   801023 <sys_getenvid>
  80146b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  80146e:	89 f7                	mov    %esi,%edi
  801470:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  801473:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80147a:	f6 c4 04             	test   $0x4,%ah
  80147d:	0f 85 3c ff ff ff    	jne    8013bf <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  801483:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80148a:	a8 02                	test   $0x2,%al
  80148c:	0f 85 63 ff ff ff    	jne    8013f5 <fork+0x9a>
  801492:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801499:	f6 c4 08             	test   $0x8,%ah
  80149c:	0f 85 53 ff ff ff    	jne    8013f5 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	6a 05                	push   $0x5
  8014a7:	57                   	push   %edi
  8014a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8014ab:	57                   	push   %edi
  8014ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014af:	e8 f0 fb ff ff       	call   8010a4 <sys_page_map>
  8014b4:	83 c4 20             	add    $0x20,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	0f 84 75 ff ff ff    	je     801434 <fork+0xd9>
	        panic("duppage: %e", r);
  8014bf:	50                   	push   %eax
  8014c0:	68 af 34 80 00       	push   $0x8034af
  8014c5:	6a 55                	push   $0x55
  8014c7:	68 88 34 80 00       	push   $0x803488
  8014cc:	e8 1f f0 ff ff       	call   8004f0 <_panic>
	        panic("duppage: %e", r);
  8014d1:	50                   	push   %eax
  8014d2:	68 af 34 80 00       	push   $0x8034af
  8014d7:	6a 4e                	push   $0x4e
  8014d9:	68 88 34 80 00       	push   $0x803488
  8014de:	e8 0d f0 ff ff       	call   8004f0 <_panic>
	        panic("duppage: %e", r);
  8014e3:	50                   	push   %eax
  8014e4:	68 af 34 80 00       	push   $0x8034af
  8014e9:	6a 51                	push   $0x51
  8014eb:	68 88 34 80 00       	push   $0x803488
  8014f0:	e8 fb ef ff ff       	call   8004f0 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8014f5:	83 ec 04             	sub    $0x4,%esp
  8014f8:	6a 07                	push   $0x7
  8014fa:	68 00 f0 bf ee       	push   $0xeebff000
  8014ff:	ff 75 dc             	pushl  -0x24(%ebp)
  801502:	e8 5a fb ff ff       	call   801061 <sys_page_alloc>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 36                	jne    801544 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	68 3c 2c 80 00       	push   $0x802c3c
  801516:	ff 75 dc             	pushl  -0x24(%ebp)
  801519:	e8 8e fc ff ff       	call   8011ac <sys_env_set_pgfault_upcall>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	75 34                	jne    801559 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	6a 02                	push   $0x2
  80152a:	ff 75 dc             	pushl  -0x24(%ebp)
  80152d:	e8 f6 fb ff ff       	call   801128 <sys_env_set_status>
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	85 c0                	test   %eax,%eax
  801537:	75 35                	jne    80156e <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80153c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153f:	5b                   	pop    %ebx
  801540:	5e                   	pop    %esi
  801541:	5f                   	pop    %edi
  801542:	5d                   	pop    %ebp
  801543:	c3                   	ret    
	    panic("fork: %e", r);
  801544:	50                   	push   %eax
  801545:	68 a6 34 80 00       	push   $0x8034a6
  80154a:	68 8a 00 00 00       	push   $0x8a
  80154f:	68 88 34 80 00       	push   $0x803488
  801554:	e8 97 ef ff ff       	call   8004f0 <_panic>
	    panic("fork: %e", r);
  801559:	50                   	push   %eax
  80155a:	68 a6 34 80 00       	push   $0x8034a6
  80155f:	68 8d 00 00 00       	push   $0x8d
  801564:	68 88 34 80 00       	push   $0x803488
  801569:	e8 82 ef ff ff       	call   8004f0 <_panic>
	    panic("fork: %e", r);
  80156e:	50                   	push   %eax
  80156f:	68 a6 34 80 00       	push   $0x8034a6
  801574:	68 92 00 00 00       	push   $0x92
  801579:	68 88 34 80 00       	push   $0x803488
  80157e:	e8 6d ef ff ff       	call   8004f0 <_panic>

00801583 <sfork>:

// Challenge!
int
sfork(void)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801589:	68 bb 34 80 00       	push   $0x8034bb
  80158e:	68 9b 00 00 00       	push   $0x9b
  801593:	68 88 34 80 00       	push   $0x803488
  801598:	e8 53 ef ff ff       	call   8004f0 <_panic>

0080159d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	05 00 00 00 30       	add    $0x30000000,%eax
  8015a8:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ab:	5d                   	pop    %ebp
  8015ac:	c3                   	ret    

008015ad <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015bd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    

008015c4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ca:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015cf:	89 c2                	mov    %eax,%edx
  8015d1:	c1 ea 16             	shr    $0x16,%edx
  8015d4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015db:	f6 c2 01             	test   $0x1,%dl
  8015de:	74 2a                	je     80160a <fd_alloc+0x46>
  8015e0:	89 c2                	mov    %eax,%edx
  8015e2:	c1 ea 0c             	shr    $0xc,%edx
  8015e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ec:	f6 c2 01             	test   $0x1,%dl
  8015ef:	74 19                	je     80160a <fd_alloc+0x46>
  8015f1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015f6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015fb:	75 d2                	jne    8015cf <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015fd:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801603:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801608:	eb 07                	jmp    801611 <fd_alloc+0x4d>
			*fd_store = fd;
  80160a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    

00801613 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801619:	83 f8 1f             	cmp    $0x1f,%eax
  80161c:	77 36                	ja     801654 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80161e:	c1 e0 0c             	shl    $0xc,%eax
  801621:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801626:	89 c2                	mov    %eax,%edx
  801628:	c1 ea 16             	shr    $0x16,%edx
  80162b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801632:	f6 c2 01             	test   $0x1,%dl
  801635:	74 24                	je     80165b <fd_lookup+0x48>
  801637:	89 c2                	mov    %eax,%edx
  801639:	c1 ea 0c             	shr    $0xc,%edx
  80163c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801643:	f6 c2 01             	test   $0x1,%dl
  801646:	74 1a                	je     801662 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	89 02                	mov    %eax,(%edx)
	return 0;
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801652:	5d                   	pop    %ebp
  801653:	c3                   	ret    
		return -E_INVAL;
  801654:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801659:	eb f7                	jmp    801652 <fd_lookup+0x3f>
		return -E_INVAL;
  80165b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801660:	eb f0                	jmp    801652 <fd_lookup+0x3f>
  801662:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801667:	eb e9                	jmp    801652 <fd_lookup+0x3f>

00801669 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 08             	sub    $0x8,%esp
  80166f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801672:	ba 50 35 80 00       	mov    $0x803550,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801677:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80167c:	39 08                	cmp    %ecx,(%eax)
  80167e:	74 33                	je     8016b3 <dev_lookup+0x4a>
  801680:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801683:	8b 02                	mov    (%edx),%eax
  801685:	85 c0                	test   %eax,%eax
  801687:	75 f3                	jne    80167c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801689:	a1 08 50 80 00       	mov    0x805008,%eax
  80168e:	8b 40 48             	mov    0x48(%eax),%eax
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	51                   	push   %ecx
  801695:	50                   	push   %eax
  801696:	68 d4 34 80 00       	push   $0x8034d4
  80169b:	e8 2b ef ff ff       	call   8005cb <cprintf>
	*dev = 0;
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    
			*dev = devtab[i];
  8016b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bd:	eb f2                	jmp    8016b1 <dev_lookup+0x48>

008016bf <fd_close>:
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	57                   	push   %edi
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
  8016c5:	83 ec 1c             	sub    $0x1c,%esp
  8016c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8016cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016d1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016d2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016d8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016db:	50                   	push   %eax
  8016dc:	e8 32 ff ff ff       	call   801613 <fd_lookup>
  8016e1:	89 c3                	mov    %eax,%ebx
  8016e3:	83 c4 08             	add    $0x8,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 05                	js     8016ef <fd_close+0x30>
	    || fd != fd2)
  8016ea:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016ed:	74 16                	je     801705 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016ef:	89 f8                	mov    %edi,%eax
  8016f1:	84 c0                	test   %al,%al
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f8:	0f 44 d8             	cmove  %eax,%ebx
}
  8016fb:	89 d8                	mov    %ebx,%eax
  8016fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801700:	5b                   	pop    %ebx
  801701:	5e                   	pop    %esi
  801702:	5f                   	pop    %edi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801705:	83 ec 08             	sub    $0x8,%esp
  801708:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80170b:	50                   	push   %eax
  80170c:	ff 36                	pushl  (%esi)
  80170e:	e8 56 ff ff ff       	call   801669 <dev_lookup>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 15                	js     801731 <fd_close+0x72>
		if (dev->dev_close)
  80171c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80171f:	8b 40 10             	mov    0x10(%eax),%eax
  801722:	85 c0                	test   %eax,%eax
  801724:	74 1b                	je     801741 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801726:	83 ec 0c             	sub    $0xc,%esp
  801729:	56                   	push   %esi
  80172a:	ff d0                	call   *%eax
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	56                   	push   %esi
  801735:	6a 00                	push   $0x0
  801737:	e8 aa f9 ff ff       	call   8010e6 <sys_page_unmap>
	return r;
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	eb ba                	jmp    8016fb <fd_close+0x3c>
			r = 0;
  801741:	bb 00 00 00 00       	mov    $0x0,%ebx
  801746:	eb e9                	jmp    801731 <fd_close+0x72>

00801748 <close>:

int
close(int fdnum)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801751:	50                   	push   %eax
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	e8 b9 fe ff ff       	call   801613 <fd_lookup>
  80175a:	83 c4 08             	add    $0x8,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 10                	js     801771 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	6a 01                	push   $0x1
  801766:	ff 75 f4             	pushl  -0xc(%ebp)
  801769:	e8 51 ff ff ff       	call   8016bf <fd_close>
  80176e:	83 c4 10             	add    $0x10,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <close_all>:

void
close_all(void)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	53                   	push   %ebx
  801777:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80177a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80177f:	83 ec 0c             	sub    $0xc,%esp
  801782:	53                   	push   %ebx
  801783:	e8 c0 ff ff ff       	call   801748 <close>
	for (i = 0; i < MAXFD; i++)
  801788:	83 c3 01             	add    $0x1,%ebx
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	83 fb 20             	cmp    $0x20,%ebx
  801791:	75 ec                	jne    80177f <close_all+0xc>
}
  801793:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	57                   	push   %edi
  80179c:	56                   	push   %esi
  80179d:	53                   	push   %ebx
  80179e:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a4:	50                   	push   %eax
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	e8 66 fe ff ff       	call   801613 <fd_lookup>
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	83 c4 08             	add    $0x8,%esp
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	0f 88 81 00 00 00    	js     80183b <dup+0xa3>
		return r;
	close(newfdnum);
  8017ba:	83 ec 0c             	sub    $0xc,%esp
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	e8 83 ff ff ff       	call   801748 <close>

	newfd = INDEX2FD(newfdnum);
  8017c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017c8:	c1 e6 0c             	shl    $0xc,%esi
  8017cb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017d1:	83 c4 04             	add    $0x4,%esp
  8017d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017d7:	e8 d1 fd ff ff       	call   8015ad <fd2data>
  8017dc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017de:	89 34 24             	mov    %esi,(%esp)
  8017e1:	e8 c7 fd ff ff       	call   8015ad <fd2data>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017eb:	89 d8                	mov    %ebx,%eax
  8017ed:	c1 e8 16             	shr    $0x16,%eax
  8017f0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017f7:	a8 01                	test   $0x1,%al
  8017f9:	74 11                	je     80180c <dup+0x74>
  8017fb:	89 d8                	mov    %ebx,%eax
  8017fd:	c1 e8 0c             	shr    $0xc,%eax
  801800:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801807:	f6 c2 01             	test   $0x1,%dl
  80180a:	75 39                	jne    801845 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80180c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80180f:	89 d0                	mov    %edx,%eax
  801811:	c1 e8 0c             	shr    $0xc,%eax
  801814:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80181b:	83 ec 0c             	sub    $0xc,%esp
  80181e:	25 07 0e 00 00       	and    $0xe07,%eax
  801823:	50                   	push   %eax
  801824:	56                   	push   %esi
  801825:	6a 00                	push   $0x0
  801827:	52                   	push   %edx
  801828:	6a 00                	push   $0x0
  80182a:	e8 75 f8 ff ff       	call   8010a4 <sys_page_map>
  80182f:	89 c3                	mov    %eax,%ebx
  801831:	83 c4 20             	add    $0x20,%esp
  801834:	85 c0                	test   %eax,%eax
  801836:	78 31                	js     801869 <dup+0xd1>
		goto err;

	return newfdnum;
  801838:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80183b:	89 d8                	mov    %ebx,%eax
  80183d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5f                   	pop    %edi
  801843:	5d                   	pop    %ebp
  801844:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801845:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80184c:	83 ec 0c             	sub    $0xc,%esp
  80184f:	25 07 0e 00 00       	and    $0xe07,%eax
  801854:	50                   	push   %eax
  801855:	57                   	push   %edi
  801856:	6a 00                	push   $0x0
  801858:	53                   	push   %ebx
  801859:	6a 00                	push   $0x0
  80185b:	e8 44 f8 ff ff       	call   8010a4 <sys_page_map>
  801860:	89 c3                	mov    %eax,%ebx
  801862:	83 c4 20             	add    $0x20,%esp
  801865:	85 c0                	test   %eax,%eax
  801867:	79 a3                	jns    80180c <dup+0x74>
	sys_page_unmap(0, newfd);
  801869:	83 ec 08             	sub    $0x8,%esp
  80186c:	56                   	push   %esi
  80186d:	6a 00                	push   $0x0
  80186f:	e8 72 f8 ff ff       	call   8010e6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801874:	83 c4 08             	add    $0x8,%esp
  801877:	57                   	push   %edi
  801878:	6a 00                	push   $0x0
  80187a:	e8 67 f8 ff ff       	call   8010e6 <sys_page_unmap>
	return r;
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	eb b7                	jmp    80183b <dup+0xa3>

00801884 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	53                   	push   %ebx
  801888:	83 ec 14             	sub    $0x14,%esp
  80188b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80188e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801891:	50                   	push   %eax
  801892:	53                   	push   %ebx
  801893:	e8 7b fd ff ff       	call   801613 <fd_lookup>
  801898:	83 c4 08             	add    $0x8,%esp
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 3f                	js     8018de <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80189f:	83 ec 08             	sub    $0x8,%esp
  8018a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a5:	50                   	push   %eax
  8018a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a9:	ff 30                	pushl  (%eax)
  8018ab:	e8 b9 fd ff ff       	call   801669 <dev_lookup>
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	78 27                	js     8018de <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ba:	8b 42 08             	mov    0x8(%edx),%eax
  8018bd:	83 e0 03             	and    $0x3,%eax
  8018c0:	83 f8 01             	cmp    $0x1,%eax
  8018c3:	74 1e                	je     8018e3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c8:	8b 40 08             	mov    0x8(%eax),%eax
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	74 35                	je     801904 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	ff 75 10             	pushl  0x10(%ebp)
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	52                   	push   %edx
  8018d9:	ff d0                	call   *%eax
  8018db:	83 c4 10             	add    $0x10,%esp
}
  8018de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018e3:	a1 08 50 80 00       	mov    0x805008,%eax
  8018e8:	8b 40 48             	mov    0x48(%eax),%eax
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	53                   	push   %ebx
  8018ef:	50                   	push   %eax
  8018f0:	68 15 35 80 00       	push   $0x803515
  8018f5:	e8 d1 ec ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801902:	eb da                	jmp    8018de <read+0x5a>
		return -E_NOT_SUPP;
  801904:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801909:	eb d3                	jmp    8018de <read+0x5a>

0080190b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	57                   	push   %edi
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
  801911:	83 ec 0c             	sub    $0xc,%esp
  801914:	8b 7d 08             	mov    0x8(%ebp),%edi
  801917:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80191a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80191f:	39 f3                	cmp    %esi,%ebx
  801921:	73 25                	jae    801948 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	89 f0                	mov    %esi,%eax
  801928:	29 d8                	sub    %ebx,%eax
  80192a:	50                   	push   %eax
  80192b:	89 d8                	mov    %ebx,%eax
  80192d:	03 45 0c             	add    0xc(%ebp),%eax
  801930:	50                   	push   %eax
  801931:	57                   	push   %edi
  801932:	e8 4d ff ff ff       	call   801884 <read>
		if (m < 0)
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 08                	js     801946 <readn+0x3b>
			return m;
		if (m == 0)
  80193e:	85 c0                	test   %eax,%eax
  801940:	74 06                	je     801948 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801942:	01 c3                	add    %eax,%ebx
  801944:	eb d9                	jmp    80191f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801946:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5e                   	pop    %esi
  80194f:	5f                   	pop    %edi
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    

00801952 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	53                   	push   %ebx
  801956:	83 ec 14             	sub    $0x14,%esp
  801959:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80195c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80195f:	50                   	push   %eax
  801960:	53                   	push   %ebx
  801961:	e8 ad fc ff ff       	call   801613 <fd_lookup>
  801966:	83 c4 08             	add    $0x8,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 3a                	js     8019a7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801973:	50                   	push   %eax
  801974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801977:	ff 30                	pushl  (%eax)
  801979:	e8 eb fc ff ff       	call   801669 <dev_lookup>
  80197e:	83 c4 10             	add    $0x10,%esp
  801981:	85 c0                	test   %eax,%eax
  801983:	78 22                	js     8019a7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801988:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80198c:	74 1e                	je     8019ac <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80198e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801991:	8b 52 0c             	mov    0xc(%edx),%edx
  801994:	85 d2                	test   %edx,%edx
  801996:	74 35                	je     8019cd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	ff 75 10             	pushl  0x10(%ebp)
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	50                   	push   %eax
  8019a2:	ff d2                	call   *%edx
  8019a4:	83 c4 10             	add    $0x10,%esp
}
  8019a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ac:	a1 08 50 80 00       	mov    0x805008,%eax
  8019b1:	8b 40 48             	mov    0x48(%eax),%eax
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	53                   	push   %ebx
  8019b8:	50                   	push   %eax
  8019b9:	68 31 35 80 00       	push   $0x803531
  8019be:	e8 08 ec ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019cb:	eb da                	jmp    8019a7 <write+0x55>
		return -E_NOT_SUPP;
  8019cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d2:	eb d3                	jmp    8019a7 <write+0x55>

008019d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019dd:	50                   	push   %eax
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	e8 2d fc ff ff       	call   801613 <fd_lookup>
  8019e6:	83 c4 08             	add    $0x8,%esp
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	78 0e                	js     8019fb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	53                   	push   %ebx
  801a01:	83 ec 14             	sub    $0x14,%esp
  801a04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a07:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a0a:	50                   	push   %eax
  801a0b:	53                   	push   %ebx
  801a0c:	e8 02 fc ff ff       	call   801613 <fd_lookup>
  801a11:	83 c4 08             	add    $0x8,%esp
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 37                	js     801a4f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1e:	50                   	push   %eax
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a22:	ff 30                	pushl  (%eax)
  801a24:	e8 40 fc ff ff       	call   801669 <dev_lookup>
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 1f                	js     801a4f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a33:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a37:	74 1b                	je     801a54 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3c:	8b 52 18             	mov    0x18(%edx),%edx
  801a3f:	85 d2                	test   %edx,%edx
  801a41:	74 32                	je     801a75 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	50                   	push   %eax
  801a4a:	ff d2                	call   *%edx
  801a4c:	83 c4 10             	add    $0x10,%esp
}
  801a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a54:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a59:	8b 40 48             	mov    0x48(%eax),%eax
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	53                   	push   %ebx
  801a60:	50                   	push   %eax
  801a61:	68 f4 34 80 00       	push   $0x8034f4
  801a66:	e8 60 eb ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a73:	eb da                	jmp    801a4f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a7a:	eb d3                	jmp    801a4f <ftruncate+0x52>

00801a7c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 14             	sub    $0x14,%esp
  801a83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	e8 81 fb ff ff       	call   801613 <fd_lookup>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 4b                	js     801ae4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9f:	50                   	push   %eax
  801aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa3:	ff 30                	pushl  (%eax)
  801aa5:	e8 bf fb ff ff       	call   801669 <dev_lookup>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 33                	js     801ae4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ab8:	74 2f                	je     801ae9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aba:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801abd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ac4:	00 00 00 
	stat->st_isdir = 0;
  801ac7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ace:	00 00 00 
	stat->st_dev = dev;
  801ad1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ad7:	83 ec 08             	sub    $0x8,%esp
  801ada:	53                   	push   %ebx
  801adb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ade:	ff 50 14             	call   *0x14(%eax)
  801ae1:	83 c4 10             	add    $0x10,%esp
}
  801ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    
		return -E_NOT_SUPP;
  801ae9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aee:	eb f4                	jmp    801ae4 <fstat+0x68>

00801af0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	6a 00                	push   $0x0
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	e8 26 02 00 00       	call   801d28 <open>
  801b02:	89 c3                	mov    %eax,%ebx
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 1b                	js     801b26 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	e8 65 ff ff ff       	call   801a7c <fstat>
  801b17:	89 c6                	mov    %eax,%esi
	close(fd);
  801b19:	89 1c 24             	mov    %ebx,(%esp)
  801b1c:	e8 27 fc ff ff       	call   801748 <close>
	return r;
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	89 f3                	mov    %esi,%ebx
}
  801b26:	89 d8                	mov    %ebx,%eax
  801b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    

00801b2f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	89 c6                	mov    %eax,%esi
  801b36:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b38:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b3f:	74 27                	je     801b68 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b41:	6a 07                	push   $0x7
  801b43:	68 00 60 80 00       	push   $0x806000
  801b48:	56                   	push   %esi
  801b49:	ff 35 00 50 80 00    	pushl  0x805000
  801b4f:	e8 77 11 00 00       	call   802ccb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b54:	83 c4 0c             	add    $0xc,%esp
  801b57:	6a 00                	push   $0x0
  801b59:	53                   	push   %ebx
  801b5a:	6a 00                	push   $0x0
  801b5c:	e8 01 11 00 00       	call   802c62 <ipc_recv>
}
  801b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b68:	83 ec 0c             	sub    $0xc,%esp
  801b6b:	6a 01                	push   $0x1
  801b6d:	e8 b2 11 00 00       	call   802d24 <ipc_find_env>
  801b72:	a3 00 50 80 00       	mov    %eax,0x805000
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	eb c5                	jmp    801b41 <fsipc+0x12>

00801b7c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	8b 40 0c             	mov    0xc(%eax),%eax
  801b88:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b90:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b95:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b9f:	e8 8b ff ff ff       	call   801b2f <fsipc>
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <devfile_flush>:
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbc:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc1:	e8 69 ff ff ff       	call   801b2f <fsipc>
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <devfile_stat>:
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  801be2:	b8 05 00 00 00       	mov    $0x5,%eax
  801be7:	e8 43 ff ff ff       	call   801b2f <fsipc>
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 2c                	js     801c1c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bf0:	83 ec 08             	sub    $0x8,%esp
  801bf3:	68 00 60 80 00       	push   $0x806000
  801bf8:	53                   	push   %ebx
  801bf9:	e8 6a f0 ff ff       	call   800c68 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bfe:	a1 80 60 80 00       	mov    0x806080,%eax
  801c03:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c09:	a1 84 60 80 00       	mov    0x806084,%eax
  801c0e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <devfile_write>:
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	53                   	push   %ebx
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c31:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c36:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801c3c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801c42:	77 30                	ja     801c74 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	53                   	push   %ebx
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	68 08 60 80 00       	push   $0x806008
  801c50:	e8 a1 f1 ff ff       	call   800df6 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c55:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5a:	b8 04 00 00 00       	mov    $0x4,%eax
  801c5f:	e8 cb fe ff ff       	call   801b2f <fsipc>
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	78 04                	js     801c6f <devfile_write+0x4e>
	assert(r <= n);
  801c6b:	39 d8                	cmp    %ebx,%eax
  801c6d:	77 1e                	ja     801c8d <devfile_write+0x6c>
}
  801c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801c74:	68 64 35 80 00       	push   $0x803564
  801c79:	68 91 35 80 00       	push   $0x803591
  801c7e:	68 94 00 00 00       	push   $0x94
  801c83:	68 a6 35 80 00       	push   $0x8035a6
  801c88:	e8 63 e8 ff ff       	call   8004f0 <_panic>
	assert(r <= n);
  801c8d:	68 b1 35 80 00       	push   $0x8035b1
  801c92:	68 91 35 80 00       	push   $0x803591
  801c97:	68 98 00 00 00       	push   $0x98
  801c9c:	68 a6 35 80 00       	push   $0x8035a6
  801ca1:	e8 4a e8 ff ff       	call   8004f0 <_panic>

00801ca6 <devfile_read>:
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	56                   	push   %esi
  801caa:	53                   	push   %ebx
  801cab:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cb9:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc9:	e8 61 fe ff ff       	call   801b2f <fsipc>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	78 1f                	js     801cf3 <devfile_read+0x4d>
	assert(r <= n);
  801cd4:	39 f0                	cmp    %esi,%eax
  801cd6:	77 24                	ja     801cfc <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cd8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cdd:	7f 33                	jg     801d12 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	50                   	push   %eax
  801ce3:	68 00 60 80 00       	push   $0x806000
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	e8 06 f1 ff ff       	call   800df6 <memmove>
	return r;
  801cf0:	83 c4 10             	add    $0x10,%esp
}
  801cf3:	89 d8                	mov    %ebx,%eax
  801cf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
	assert(r <= n);
  801cfc:	68 b1 35 80 00       	push   $0x8035b1
  801d01:	68 91 35 80 00       	push   $0x803591
  801d06:	6a 7c                	push   $0x7c
  801d08:	68 a6 35 80 00       	push   $0x8035a6
  801d0d:	e8 de e7 ff ff       	call   8004f0 <_panic>
	assert(r <= PGSIZE);
  801d12:	68 b8 35 80 00       	push   $0x8035b8
  801d17:	68 91 35 80 00       	push   $0x803591
  801d1c:	6a 7d                	push   $0x7d
  801d1e:	68 a6 35 80 00       	push   $0x8035a6
  801d23:	e8 c8 e7 ff ff       	call   8004f0 <_panic>

00801d28 <open>:
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	56                   	push   %esi
  801d2c:	53                   	push   %ebx
  801d2d:	83 ec 1c             	sub    $0x1c,%esp
  801d30:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d33:	56                   	push   %esi
  801d34:	e8 f8 ee ff ff       	call   800c31 <strlen>
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d41:	7f 6c                	jg     801daf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d49:	50                   	push   %eax
  801d4a:	e8 75 f8 ff ff       	call   8015c4 <fd_alloc>
  801d4f:	89 c3                	mov    %eax,%ebx
  801d51:	83 c4 10             	add    $0x10,%esp
  801d54:	85 c0                	test   %eax,%eax
  801d56:	78 3c                	js     801d94 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d58:	83 ec 08             	sub    $0x8,%esp
  801d5b:	56                   	push   %esi
  801d5c:	68 00 60 80 00       	push   $0x806000
  801d61:	e8 02 ef ff ff       	call   800c68 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d69:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d71:	b8 01 00 00 00       	mov    $0x1,%eax
  801d76:	e8 b4 fd ff ff       	call   801b2f <fsipc>
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	85 c0                	test   %eax,%eax
  801d82:	78 19                	js     801d9d <open+0x75>
	return fd2num(fd);
  801d84:	83 ec 0c             	sub    $0xc,%esp
  801d87:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8a:	e8 0e f8 ff ff       	call   80159d <fd2num>
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	83 c4 10             	add    $0x10,%esp
}
  801d94:	89 d8                	mov    %ebx,%eax
  801d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d99:	5b                   	pop    %ebx
  801d9a:	5e                   	pop    %esi
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    
		fd_close(fd, 0);
  801d9d:	83 ec 08             	sub    $0x8,%esp
  801da0:	6a 00                	push   $0x0
  801da2:	ff 75 f4             	pushl  -0xc(%ebp)
  801da5:	e8 15 f9 ff ff       	call   8016bf <fd_close>
		return r;
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	eb e5                	jmp    801d94 <open+0x6c>
		return -E_BAD_PATH;
  801daf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801db4:	eb de                	jmp    801d94 <open+0x6c>

00801db6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc1:	b8 08 00 00 00       	mov    $0x8,%eax
  801dc6:	e8 64 fd ff ff       	call   801b2f <fsipc>
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	57                   	push   %edi
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801dd9:	6a 00                	push   $0x0
  801ddb:	ff 75 08             	pushl  0x8(%ebp)
  801dde:	e8 45 ff ff ff       	call   801d28 <open>
  801de3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	85 c0                	test   %eax,%eax
  801dee:	0f 88 40 03 00 00    	js     802134 <spawn+0x367>
  801df4:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	68 00 02 00 00       	push   $0x200
  801dfe:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801e04:	50                   	push   %eax
  801e05:	52                   	push   %edx
  801e06:	e8 00 fb ff ff       	call   80190b <readn>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e13:	75 5d                	jne    801e72 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  801e15:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801e1c:	45 4c 46 
  801e1f:	75 51                	jne    801e72 <spawn+0xa5>
  801e21:	b8 07 00 00 00       	mov    $0x7,%eax
  801e26:	cd 30                	int    $0x30
  801e28:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801e2e:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801e34:	85 c0                	test   %eax,%eax
  801e36:	0f 88 b6 04 00 00    	js     8022f2 <spawn+0x525>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e3c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e41:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801e44:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e4a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e50:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801e57:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e5d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e63:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801e68:	be 00 00 00 00       	mov    $0x0,%esi
  801e6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e70:	eb 4b                	jmp    801ebd <spawn+0xf0>
		close(fd);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801e7b:	e8 c8 f8 ff ff       	call   801748 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e80:	83 c4 0c             	add    $0xc,%esp
  801e83:	68 7f 45 4c 46       	push   $0x464c457f
  801e88:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801e8e:	68 c4 35 80 00       	push   $0x8035c4
  801e93:	e8 33 e7 ff ff       	call   8005cb <cprintf>
		return -E_NOT_EXEC;
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801ea2:	ff ff ff 
  801ea5:	e9 8a 02 00 00       	jmp    802134 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801eaa:	83 ec 0c             	sub    $0xc,%esp
  801ead:	50                   	push   %eax
  801eae:	e8 7e ed ff ff       	call   800c31 <strlen>
  801eb3:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801eb7:	83 c3 01             	add    $0x1,%ebx
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801ec4:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	75 df                	jne    801eaa <spawn+0xdd>
  801ecb:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801ed1:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ed7:	bf 00 10 40 00       	mov    $0x401000,%edi
  801edc:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ede:	89 fa                	mov    %edi,%edx
  801ee0:	83 e2 fc             	and    $0xfffffffc,%edx
  801ee3:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801eea:	29 c2                	sub    %eax,%edx
  801eec:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ef2:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ef5:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801efa:	0f 86 03 04 00 00    	jbe    802303 <spawn+0x536>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	6a 07                	push   $0x7
  801f05:	68 00 00 40 00       	push   $0x400000
  801f0a:	6a 00                	push   $0x0
  801f0c:	e8 50 f1 ff ff       	call   801061 <sys_page_alloc>
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	85 c0                	test   %eax,%eax
  801f16:	0f 88 ec 03 00 00    	js     802308 <spawn+0x53b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801f1c:	be 00 00 00 00       	mov    $0x0,%esi
  801f21:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801f27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f2a:	eb 30                	jmp    801f5c <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801f2c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f32:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f38:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801f3b:	83 ec 08             	sub    $0x8,%esp
  801f3e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f41:	57                   	push   %edi
  801f42:	e8 21 ed ff ff       	call   800c68 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f47:	83 c4 04             	add    $0x4,%esp
  801f4a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f4d:	e8 df ec ff ff       	call   800c31 <strlen>
  801f52:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801f56:	83 c6 01             	add    $0x1,%esi
  801f59:	83 c4 10             	add    $0x10,%esp
  801f5c:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801f62:	7f c8                	jg     801f2c <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801f64:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f6a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801f70:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f77:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f7d:	0f 85 8c 00 00 00    	jne    80200f <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f83:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801f89:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f8f:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801f92:	89 f8                	mov    %edi,%eax
  801f94:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801f9a:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f9d:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801fa2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	6a 07                	push   $0x7
  801fad:	68 00 d0 bf ee       	push   $0xeebfd000
  801fb2:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801fb8:	68 00 00 40 00       	push   $0x400000
  801fbd:	6a 00                	push   $0x0
  801fbf:	e8 e0 f0 ff ff       	call   8010a4 <sys_page_map>
  801fc4:	89 c3                	mov    %eax,%ebx
  801fc6:	83 c4 20             	add    $0x20,%esp
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	0f 88 57 03 00 00    	js     802328 <spawn+0x55b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801fd1:	83 ec 08             	sub    $0x8,%esp
  801fd4:	68 00 00 40 00       	push   $0x400000
  801fd9:	6a 00                	push   $0x0
  801fdb:	e8 06 f1 ff ff       	call   8010e6 <sys_page_unmap>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	0f 88 3b 03 00 00    	js     802328 <spawn+0x55b>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fed:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ff3:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801ffa:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802000:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802007:	00 00 00 
  80200a:	e9 56 01 00 00       	jmp    802165 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80200f:	68 50 36 80 00       	push   $0x803650
  802014:	68 91 35 80 00       	push   $0x803591
  802019:	68 f2 00 00 00       	push   $0xf2
  80201e:	68 de 35 80 00       	push   $0x8035de
  802023:	e8 c8 e4 ff ff       	call   8004f0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	6a 07                	push   $0x7
  80202d:	68 00 00 40 00       	push   $0x400000
  802032:	6a 00                	push   $0x0
  802034:	e8 28 f0 ff ff       	call   801061 <sys_page_alloc>
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	85 c0                	test   %eax,%eax
  80203e:	0f 88 cf 02 00 00    	js     802313 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802044:	83 ec 08             	sub    $0x8,%esp
  802047:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80204d:	01 f0                	add    %esi,%eax
  80204f:	50                   	push   %eax
  802050:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802056:	e8 79 f9 ff ff       	call   8019d4 <seek>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	85 c0                	test   %eax,%eax
  802060:	0f 88 b4 02 00 00    	js     80231a <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802066:	83 ec 04             	sub    $0x4,%esp
  802069:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80206f:	29 f0                	sub    %esi,%eax
  802071:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802076:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80207b:	0f 47 c1             	cmova  %ecx,%eax
  80207e:	50                   	push   %eax
  80207f:	68 00 00 40 00       	push   $0x400000
  802084:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80208a:	e8 7c f8 ff ff       	call   80190b <readn>
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	85 c0                	test   %eax,%eax
  802094:	0f 88 87 02 00 00    	js     802321 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	57                   	push   %edi
  80209e:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8020a4:	56                   	push   %esi
  8020a5:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8020ab:	68 00 00 40 00       	push   $0x400000
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 ed ef ff ff       	call   8010a4 <sys_page_map>
  8020b7:	83 c4 20             	add    $0x20,%esp
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	0f 88 80 00 00 00    	js     802142 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8020c2:	83 ec 08             	sub    $0x8,%esp
  8020c5:	68 00 00 40 00       	push   $0x400000
  8020ca:	6a 00                	push   $0x0
  8020cc:	e8 15 f0 ff ff       	call   8010e6 <sys_page_unmap>
  8020d1:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8020d4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020da:	89 de                	mov    %ebx,%esi
  8020dc:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8020e2:	76 73                	jbe    802157 <spawn+0x38a>
		if (i >= filesz) {
  8020e4:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8020ea:	0f 87 38 ff ff ff    	ja     802028 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	57                   	push   %edi
  8020f4:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8020fa:	56                   	push   %esi
  8020fb:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  802101:	e8 5b ef ff ff       	call   801061 <sys_page_alloc>
  802106:	83 c4 10             	add    $0x10,%esp
  802109:	85 c0                	test   %eax,%eax
  80210b:	79 c7                	jns    8020d4 <spawn+0x307>
  80210d:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80210f:	83 ec 0c             	sub    $0xc,%esp
  802112:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802118:	e8 c5 ee ff ff       	call   800fe2 <sys_env_destroy>
	close(fd);
  80211d:	83 c4 04             	add    $0x4,%esp
  802120:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802126:	e8 1d f6 ff ff       	call   801748 <close>
	return r;
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  802134:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80213a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80213d:	5b                   	pop    %ebx
  80213e:	5e                   	pop    %esi
  80213f:	5f                   	pop    %edi
  802140:	5d                   	pop    %ebp
  802141:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  802142:	50                   	push   %eax
  802143:	68 ea 35 80 00       	push   $0x8035ea
  802148:	68 25 01 00 00       	push   $0x125
  80214d:	68 de 35 80 00       	push   $0x8035de
  802152:	e8 99 e3 ff ff       	call   8004f0 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802157:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80215e:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  802165:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80216c:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802172:	7e 71                	jle    8021e5 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  802174:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  80217a:	83 39 01             	cmpl   $0x1,(%ecx)
  80217d:	75 d8                	jne    802157 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80217f:	8b 41 18             	mov    0x18(%ecx),%eax
  802182:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802185:	83 f8 01             	cmp    $0x1,%eax
  802188:	19 ff                	sbb    %edi,%edi
  80218a:	83 e7 fe             	and    $0xfffffffe,%edi
  80218d:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802190:	8b 71 04             	mov    0x4(%ecx),%esi
  802193:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  802199:	8b 59 10             	mov    0x10(%ecx),%ebx
  80219c:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8021a2:	8b 41 14             	mov    0x14(%ecx),%eax
  8021a5:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8021ab:	8b 51 08             	mov    0x8(%ecx),%edx
  8021ae:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  8021b4:	89 d0                	mov    %edx,%eax
  8021b6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021bb:	74 1e                	je     8021db <spawn+0x40e>
		va -= i;
  8021bd:	29 c2                	sub    %eax,%edx
  8021bf:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  8021c5:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  8021cb:	01 c3                	add    %eax,%ebx
  8021cd:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  8021d3:	29 c6                	sub    %eax,%esi
  8021d5:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8021db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021e0:	e9 f5 fe ff ff       	jmp    8020da <spawn+0x30d>
	close(fd);
  8021e5:	83 ec 0c             	sub    $0xc,%esp
  8021e8:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8021ee:	e8 55 f5 ff ff       	call   801748 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	envid_t parent_envid = sys_getenvid();
  8021f3:	e8 2b ee ff ff       	call   801023 <sys_getenvid>
  8021f8:	89 c6                	mov    %eax,%esi
  8021fa:	83 c4 10             	add    $0x10,%esp
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8021fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  802202:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  802208:	eb 0e                	jmp    802218 <spawn+0x44b>
  80220a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802210:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802216:	74 62                	je     80227a <spawn+0x4ad>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_SHARE) == PTE_SHARE) {
  802218:	89 d8                	mov    %ebx,%eax
  80221a:	c1 e8 16             	shr    $0x16,%eax
  80221d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802224:	a8 01                	test   $0x1,%al
  802226:	74 e2                	je     80220a <spawn+0x43d>
  802228:	89 d8                	mov    %ebx,%eax
  80222a:	c1 e8 0c             	shr    $0xc,%eax
  80222d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802234:	f6 c2 01             	test   $0x1,%dl
  802237:	74 d1                	je     80220a <spawn+0x43d>
  802239:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802240:	f6 c6 04             	test   $0x4,%dh
  802243:	74 c5                	je     80220a <spawn+0x43d>
	        if ((r = sys_page_map(parent_envid, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
  802245:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80224c:	83 ec 0c             	sub    $0xc,%esp
  80224f:	25 07 0e 00 00       	and    $0xe07,%eax
  802254:	50                   	push   %eax
  802255:	53                   	push   %ebx
  802256:	57                   	push   %edi
  802257:	53                   	push   %ebx
  802258:	56                   	push   %esi
  802259:	e8 46 ee ff ff       	call   8010a4 <sys_page_map>
  80225e:	83 c4 20             	add    $0x20,%esp
  802261:	85 c0                	test   %eax,%eax
  802263:	74 a5                	je     80220a <spawn+0x43d>
	            panic("copy_shared_pages: %e", r);
  802265:	50                   	push   %eax
  802266:	68 07 36 80 00       	push   $0x803607
  80226b:	68 38 01 00 00       	push   $0x138
  802270:	68 de 35 80 00       	push   $0x8035de
  802275:	e8 76 e2 ff ff       	call   8004f0 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  80227a:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802281:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802284:	83 ec 08             	sub    $0x8,%esp
  802287:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80228d:	50                   	push   %eax
  80228e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802294:	e8 d1 ee ff ff       	call   80116a <sys_env_set_trapframe>
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	85 c0                	test   %eax,%eax
  80229e:	78 28                	js     8022c8 <spawn+0x4fb>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8022a0:	83 ec 08             	sub    $0x8,%esp
  8022a3:	6a 02                	push   $0x2
  8022a5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8022ab:	e8 78 ee ff ff       	call   801128 <sys_env_set_status>
  8022b0:	83 c4 10             	add    $0x10,%esp
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	78 26                	js     8022dd <spawn+0x510>
	return child;
  8022b7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8022bd:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8022c3:	e9 6c fe ff ff       	jmp    802134 <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  8022c8:	50                   	push   %eax
  8022c9:	68 1d 36 80 00       	push   $0x80361d
  8022ce:	68 86 00 00 00       	push   $0x86
  8022d3:	68 de 35 80 00       	push   $0x8035de
  8022d8:	e8 13 e2 ff ff       	call   8004f0 <_panic>
		panic("sys_env_set_status: %e", r);
  8022dd:	50                   	push   %eax
  8022de:	68 37 36 80 00       	push   $0x803637
  8022e3:	68 89 00 00 00       	push   $0x89
  8022e8:	68 de 35 80 00       	push   $0x8035de
  8022ed:	e8 fe e1 ff ff       	call   8004f0 <_panic>
		return r;
  8022f2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8022f8:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8022fe:	e9 31 fe ff ff       	jmp    802134 <spawn+0x367>
		return -E_NO_MEM;
  802303:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  802308:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  80230e:	e9 21 fe ff ff       	jmp    802134 <spawn+0x367>
  802313:	89 c7                	mov    %eax,%edi
  802315:	e9 f5 fd ff ff       	jmp    80210f <spawn+0x342>
  80231a:	89 c7                	mov    %eax,%edi
  80231c:	e9 ee fd ff ff       	jmp    80210f <spawn+0x342>
  802321:	89 c7                	mov    %eax,%edi
  802323:	e9 e7 fd ff ff       	jmp    80210f <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  802328:	83 ec 08             	sub    $0x8,%esp
  80232b:	68 00 00 40 00       	push   $0x400000
  802330:	6a 00                	push   $0x0
  802332:	e8 af ed ff ff       	call   8010e6 <sys_page_unmap>
  802337:	83 c4 10             	add    $0x10,%esp
  80233a:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802340:	e9 ef fd ff ff       	jmp    802134 <spawn+0x367>

00802345 <spawnl>:
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	57                   	push   %edi
  802349:	56                   	push   %esi
  80234a:	53                   	push   %ebx
  80234b:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  80234e:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802351:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802356:	eb 05                	jmp    80235d <spawnl+0x18>
		argc++;
  802358:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80235b:	89 ca                	mov    %ecx,%edx
  80235d:	8d 4a 04             	lea    0x4(%edx),%ecx
  802360:	83 3a 00             	cmpl   $0x0,(%edx)
  802363:	75 f3                	jne    802358 <spawnl+0x13>
	const char *argv[argc+2];
  802365:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  80236c:	83 e2 f0             	and    $0xfffffff0,%edx
  80236f:	29 d4                	sub    %edx,%esp
  802371:	8d 54 24 03          	lea    0x3(%esp),%edx
  802375:	c1 ea 02             	shr    $0x2,%edx
  802378:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80237f:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802381:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802384:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80238b:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802392:	00 
	va_start(vl, arg0);
  802393:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802396:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802398:	b8 00 00 00 00       	mov    $0x0,%eax
  80239d:	eb 0b                	jmp    8023aa <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  80239f:	83 c0 01             	add    $0x1,%eax
  8023a2:	8b 39                	mov    (%ecx),%edi
  8023a4:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8023a7:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8023aa:	39 d0                	cmp    %edx,%eax
  8023ac:	75 f1                	jne    80239f <spawnl+0x5a>
	return spawn(prog, argv);
  8023ae:	83 ec 08             	sub    $0x8,%esp
  8023b1:	56                   	push   %esi
  8023b2:	ff 75 08             	pushl  0x8(%ebp)
  8023b5:	e8 13 fa ff ff       	call   801dcd <spawn>
}
  8023ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023bd:	5b                   	pop    %ebx
  8023be:	5e                   	pop    %esi
  8023bf:	5f                   	pop    %edi
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    

008023c2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	56                   	push   %esi
  8023c6:	53                   	push   %ebx
  8023c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023ca:	83 ec 0c             	sub    $0xc,%esp
  8023cd:	ff 75 08             	pushl  0x8(%ebp)
  8023d0:	e8 d8 f1 ff ff       	call   8015ad <fd2data>
  8023d5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023d7:	83 c4 08             	add    $0x8,%esp
  8023da:	68 78 36 80 00       	push   $0x803678
  8023df:	53                   	push   %ebx
  8023e0:	e8 83 e8 ff ff       	call   800c68 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023e5:	8b 46 04             	mov    0x4(%esi),%eax
  8023e8:	2b 06                	sub    (%esi),%eax
  8023ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023f7:	00 00 00 
	stat->st_dev = &devpipe;
  8023fa:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802401:	40 80 00 
	return 0;
}
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	53                   	push   %ebx
  802414:	83 ec 0c             	sub    $0xc,%esp
  802417:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80241a:	53                   	push   %ebx
  80241b:	6a 00                	push   $0x0
  80241d:	e8 c4 ec ff ff       	call   8010e6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802422:	89 1c 24             	mov    %ebx,(%esp)
  802425:	e8 83 f1 ff ff       	call   8015ad <fd2data>
  80242a:	83 c4 08             	add    $0x8,%esp
  80242d:	50                   	push   %eax
  80242e:	6a 00                	push   $0x0
  802430:	e8 b1 ec ff ff       	call   8010e6 <sys_page_unmap>
}
  802435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <_pipeisclosed>:
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	57                   	push   %edi
  80243e:	56                   	push   %esi
  80243f:	53                   	push   %ebx
  802440:	83 ec 1c             	sub    $0x1c,%esp
  802443:	89 c7                	mov    %eax,%edi
  802445:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802447:	a1 08 50 80 00       	mov    0x805008,%eax
  80244c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80244f:	83 ec 0c             	sub    $0xc,%esp
  802452:	57                   	push   %edi
  802453:	e8 05 09 00 00       	call   802d5d <pageref>
  802458:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80245b:	89 34 24             	mov    %esi,(%esp)
  80245e:	e8 fa 08 00 00       	call   802d5d <pageref>
		nn = thisenv->env_runs;
  802463:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802469:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	39 cb                	cmp    %ecx,%ebx
  802471:	74 1b                	je     80248e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802473:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802476:	75 cf                	jne    802447 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802478:	8b 42 58             	mov    0x58(%edx),%eax
  80247b:	6a 01                	push   $0x1
  80247d:	50                   	push   %eax
  80247e:	53                   	push   %ebx
  80247f:	68 7f 36 80 00       	push   $0x80367f
  802484:	e8 42 e1 ff ff       	call   8005cb <cprintf>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	eb b9                	jmp    802447 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80248e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802491:	0f 94 c0             	sete   %al
  802494:	0f b6 c0             	movzbl %al,%eax
}
  802497:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249a:	5b                   	pop    %ebx
  80249b:	5e                   	pop    %esi
  80249c:	5f                   	pop    %edi
  80249d:	5d                   	pop    %ebp
  80249e:	c3                   	ret    

0080249f <devpipe_write>:
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	57                   	push   %edi
  8024a3:	56                   	push   %esi
  8024a4:	53                   	push   %ebx
  8024a5:	83 ec 28             	sub    $0x28,%esp
  8024a8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024ab:	56                   	push   %esi
  8024ac:	e8 fc f0 ff ff       	call   8015ad <fd2data>
  8024b1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024b3:	83 c4 10             	add    $0x10,%esp
  8024b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024bb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024be:	74 4f                	je     80250f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024c0:	8b 43 04             	mov    0x4(%ebx),%eax
  8024c3:	8b 0b                	mov    (%ebx),%ecx
  8024c5:	8d 51 20             	lea    0x20(%ecx),%edx
  8024c8:	39 d0                	cmp    %edx,%eax
  8024ca:	72 14                	jb     8024e0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024cc:	89 da                	mov    %ebx,%edx
  8024ce:	89 f0                	mov    %esi,%eax
  8024d0:	e8 65 ff ff ff       	call   80243a <_pipeisclosed>
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	75 3a                	jne    802513 <devpipe_write+0x74>
			sys_yield();
  8024d9:	e8 64 eb ff ff       	call   801042 <sys_yield>
  8024de:	eb e0                	jmp    8024c0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024e3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024e7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024ea:	89 c2                	mov    %eax,%edx
  8024ec:	c1 fa 1f             	sar    $0x1f,%edx
  8024ef:	89 d1                	mov    %edx,%ecx
  8024f1:	c1 e9 1b             	shr    $0x1b,%ecx
  8024f4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024f7:	83 e2 1f             	and    $0x1f,%edx
  8024fa:	29 ca                	sub    %ecx,%edx
  8024fc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802500:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802504:	83 c0 01             	add    $0x1,%eax
  802507:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80250a:	83 c7 01             	add    $0x1,%edi
  80250d:	eb ac                	jmp    8024bb <devpipe_write+0x1c>
	return i;
  80250f:	89 f8                	mov    %edi,%eax
  802511:	eb 05                	jmp    802518 <devpipe_write+0x79>
				return 0;
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802518:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80251b:	5b                   	pop    %ebx
  80251c:	5e                   	pop    %esi
  80251d:	5f                   	pop    %edi
  80251e:	5d                   	pop    %ebp
  80251f:	c3                   	ret    

00802520 <devpipe_read>:
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	57                   	push   %edi
  802524:	56                   	push   %esi
  802525:	53                   	push   %ebx
  802526:	83 ec 18             	sub    $0x18,%esp
  802529:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80252c:	57                   	push   %edi
  80252d:	e8 7b f0 ff ff       	call   8015ad <fd2data>
  802532:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	be 00 00 00 00       	mov    $0x0,%esi
  80253c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80253f:	74 47                	je     802588 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802541:	8b 03                	mov    (%ebx),%eax
  802543:	3b 43 04             	cmp    0x4(%ebx),%eax
  802546:	75 22                	jne    80256a <devpipe_read+0x4a>
			if (i > 0)
  802548:	85 f6                	test   %esi,%esi
  80254a:	75 14                	jne    802560 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80254c:	89 da                	mov    %ebx,%edx
  80254e:	89 f8                	mov    %edi,%eax
  802550:	e8 e5 fe ff ff       	call   80243a <_pipeisclosed>
  802555:	85 c0                	test   %eax,%eax
  802557:	75 33                	jne    80258c <devpipe_read+0x6c>
			sys_yield();
  802559:	e8 e4 ea ff ff       	call   801042 <sys_yield>
  80255e:	eb e1                	jmp    802541 <devpipe_read+0x21>
				return i;
  802560:	89 f0                	mov    %esi,%eax
}
  802562:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802565:	5b                   	pop    %ebx
  802566:	5e                   	pop    %esi
  802567:	5f                   	pop    %edi
  802568:	5d                   	pop    %ebp
  802569:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80256a:	99                   	cltd   
  80256b:	c1 ea 1b             	shr    $0x1b,%edx
  80256e:	01 d0                	add    %edx,%eax
  802570:	83 e0 1f             	and    $0x1f,%eax
  802573:	29 d0                	sub    %edx,%eax
  802575:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80257a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80257d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802580:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802583:	83 c6 01             	add    $0x1,%esi
  802586:	eb b4                	jmp    80253c <devpipe_read+0x1c>
	return i;
  802588:	89 f0                	mov    %esi,%eax
  80258a:	eb d6                	jmp    802562 <devpipe_read+0x42>
				return 0;
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
  802591:	eb cf                	jmp    802562 <devpipe_read+0x42>

00802593 <pipe>:
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	56                   	push   %esi
  802597:	53                   	push   %ebx
  802598:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80259b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259e:	50                   	push   %eax
  80259f:	e8 20 f0 ff ff       	call   8015c4 <fd_alloc>
  8025a4:	89 c3                	mov    %eax,%ebx
  8025a6:	83 c4 10             	add    $0x10,%esp
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	78 5b                	js     802608 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 07 04 00 00       	push   $0x407
  8025b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b8:	6a 00                	push   $0x0
  8025ba:	e8 a2 ea ff ff       	call   801061 <sys_page_alloc>
  8025bf:	89 c3                	mov    %eax,%ebx
  8025c1:	83 c4 10             	add    $0x10,%esp
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	78 40                	js     802608 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025ce:	50                   	push   %eax
  8025cf:	e8 f0 ef ff ff       	call   8015c4 <fd_alloc>
  8025d4:	89 c3                	mov    %eax,%ebx
  8025d6:	83 c4 10             	add    $0x10,%esp
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	78 1b                	js     8025f8 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025dd:	83 ec 04             	sub    $0x4,%esp
  8025e0:	68 07 04 00 00       	push   $0x407
  8025e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e8:	6a 00                	push   $0x0
  8025ea:	e8 72 ea ff ff       	call   801061 <sys_page_alloc>
  8025ef:	89 c3                	mov    %eax,%ebx
  8025f1:	83 c4 10             	add    $0x10,%esp
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	79 19                	jns    802611 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8025f8:	83 ec 08             	sub    $0x8,%esp
  8025fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fe:	6a 00                	push   $0x0
  802600:	e8 e1 ea ff ff       	call   8010e6 <sys_page_unmap>
  802605:	83 c4 10             	add    $0x10,%esp
}
  802608:	89 d8                	mov    %ebx,%eax
  80260a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80260d:	5b                   	pop    %ebx
  80260e:	5e                   	pop    %esi
  80260f:	5d                   	pop    %ebp
  802610:	c3                   	ret    
	va = fd2data(fd0);
  802611:	83 ec 0c             	sub    $0xc,%esp
  802614:	ff 75 f4             	pushl  -0xc(%ebp)
  802617:	e8 91 ef ff ff       	call   8015ad <fd2data>
  80261c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261e:	83 c4 0c             	add    $0xc,%esp
  802621:	68 07 04 00 00       	push   $0x407
  802626:	50                   	push   %eax
  802627:	6a 00                	push   $0x0
  802629:	e8 33 ea ff ff       	call   801061 <sys_page_alloc>
  80262e:	89 c3                	mov    %eax,%ebx
  802630:	83 c4 10             	add    $0x10,%esp
  802633:	85 c0                	test   %eax,%eax
  802635:	0f 88 8c 00 00 00    	js     8026c7 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	ff 75 f0             	pushl  -0x10(%ebp)
  802641:	e8 67 ef ff ff       	call   8015ad <fd2data>
  802646:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80264d:	50                   	push   %eax
  80264e:	6a 00                	push   $0x0
  802650:	56                   	push   %esi
  802651:	6a 00                	push   $0x0
  802653:	e8 4c ea ff ff       	call   8010a4 <sys_page_map>
  802658:	89 c3                	mov    %eax,%ebx
  80265a:	83 c4 20             	add    $0x20,%esp
  80265d:	85 c0                	test   %eax,%eax
  80265f:	78 58                	js     8026b9 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80266a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802679:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80267f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802684:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80268b:	83 ec 0c             	sub    $0xc,%esp
  80268e:	ff 75 f4             	pushl  -0xc(%ebp)
  802691:	e8 07 ef ff ff       	call   80159d <fd2num>
  802696:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802699:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80269b:	83 c4 04             	add    $0x4,%esp
  80269e:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a1:	e8 f7 ee ff ff       	call   80159d <fd2num>
  8026a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026a9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ac:	83 c4 10             	add    $0x10,%esp
  8026af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026b4:	e9 4f ff ff ff       	jmp    802608 <pipe+0x75>
	sys_page_unmap(0, va);
  8026b9:	83 ec 08             	sub    $0x8,%esp
  8026bc:	56                   	push   %esi
  8026bd:	6a 00                	push   $0x0
  8026bf:	e8 22 ea ff ff       	call   8010e6 <sys_page_unmap>
  8026c4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026c7:	83 ec 08             	sub    $0x8,%esp
  8026ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8026cd:	6a 00                	push   $0x0
  8026cf:	e8 12 ea ff ff       	call   8010e6 <sys_page_unmap>
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	e9 1c ff ff ff       	jmp    8025f8 <pipe+0x65>

008026dc <pipeisclosed>:
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026e5:	50                   	push   %eax
  8026e6:	ff 75 08             	pushl  0x8(%ebp)
  8026e9:	e8 25 ef ff ff       	call   801613 <fd_lookup>
  8026ee:	83 c4 10             	add    $0x10,%esp
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	78 18                	js     80270d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026f5:	83 ec 0c             	sub    $0xc,%esp
  8026f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026fb:	e8 ad ee ff ff       	call   8015ad <fd2data>
	return _pipeisclosed(fd, p);
  802700:	89 c2                	mov    %eax,%edx
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	e8 30 fd ff ff       	call   80243a <_pipeisclosed>
  80270a:	83 c4 10             	add    $0x10,%esp
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	56                   	push   %esi
  802713:	53                   	push   %ebx
  802714:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802717:	85 f6                	test   %esi,%esi
  802719:	74 13                	je     80272e <wait+0x1f>
	e = &envs[ENVX(envid)];
  80271b:	89 f3                	mov    %esi,%ebx
  80271d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802723:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802726:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80272c:	eb 1b                	jmp    802749 <wait+0x3a>
	assert(envid != 0);
  80272e:	68 97 36 80 00       	push   $0x803697
  802733:	68 91 35 80 00       	push   $0x803591
  802738:	6a 09                	push   $0x9
  80273a:	68 a2 36 80 00       	push   $0x8036a2
  80273f:	e8 ac dd ff ff       	call   8004f0 <_panic>
		sys_yield();
  802744:	e8 f9 e8 ff ff       	call   801042 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802749:	8b 43 48             	mov    0x48(%ebx),%eax
  80274c:	39 f0                	cmp    %esi,%eax
  80274e:	75 07                	jne    802757 <wait+0x48>
  802750:	8b 43 54             	mov    0x54(%ebx),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	75 ed                	jne    802744 <wait+0x35>
}
  802757:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80275a:	5b                   	pop    %ebx
  80275b:	5e                   	pop    %esi
  80275c:	5d                   	pop    %ebp
  80275d:	c3                   	ret    

0080275e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802764:	68 ad 36 80 00       	push   $0x8036ad
  802769:	ff 75 0c             	pushl  0xc(%ebp)
  80276c:	e8 f7 e4 ff ff       	call   800c68 <strcpy>
	return 0;
}
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <devsock_close>:
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	53                   	push   %ebx
  80277c:	83 ec 10             	sub    $0x10,%esp
  80277f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802782:	53                   	push   %ebx
  802783:	e8 d5 05 00 00       	call   802d5d <pageref>
  802788:	83 c4 10             	add    $0x10,%esp
		return 0;
  80278b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802790:	83 f8 01             	cmp    $0x1,%eax
  802793:	74 07                	je     80279c <devsock_close+0x24>
}
  802795:	89 d0                	mov    %edx,%eax
  802797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80279c:	83 ec 0c             	sub    $0xc,%esp
  80279f:	ff 73 0c             	pushl  0xc(%ebx)
  8027a2:	e8 b7 02 00 00       	call   802a5e <nsipc_close>
  8027a7:	89 c2                	mov    %eax,%edx
  8027a9:	83 c4 10             	add    $0x10,%esp
  8027ac:	eb e7                	jmp    802795 <devsock_close+0x1d>

008027ae <devsock_write>:
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8027b4:	6a 00                	push   $0x0
  8027b6:	ff 75 10             	pushl  0x10(%ebp)
  8027b9:	ff 75 0c             	pushl  0xc(%ebp)
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	ff 70 0c             	pushl  0xc(%eax)
  8027c2:	e8 74 03 00 00       	call   802b3b <nsipc_send>
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <devsock_read>:
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8027cf:	6a 00                	push   $0x0
  8027d1:	ff 75 10             	pushl  0x10(%ebp)
  8027d4:	ff 75 0c             	pushl  0xc(%ebp)
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	ff 70 0c             	pushl  0xc(%eax)
  8027dd:	e8 ed 02 00 00       	call   802acf <nsipc_recv>
}
  8027e2:	c9                   	leave  
  8027e3:	c3                   	ret    

008027e4 <fd2sockid>:
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8027ea:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8027ed:	52                   	push   %edx
  8027ee:	50                   	push   %eax
  8027ef:	e8 1f ee ff ff       	call   801613 <fd_lookup>
  8027f4:	83 c4 10             	add    $0x10,%esp
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	78 10                	js     80280b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 0d 58 40 80 00    	mov    0x804058,%ecx
  802804:	39 08                	cmp    %ecx,(%eax)
  802806:	75 05                	jne    80280d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802808:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    
		return -E_NOT_SUPP;
  80280d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802812:	eb f7                	jmp    80280b <fd2sockid+0x27>

00802814 <alloc_sockfd>:
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	56                   	push   %esi
  802818:	53                   	push   %ebx
  802819:	83 ec 1c             	sub    $0x1c,%esp
  80281c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80281e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802821:	50                   	push   %eax
  802822:	e8 9d ed ff ff       	call   8015c4 <fd_alloc>
  802827:	89 c3                	mov    %eax,%ebx
  802829:	83 c4 10             	add    $0x10,%esp
  80282c:	85 c0                	test   %eax,%eax
  80282e:	78 43                	js     802873 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802830:	83 ec 04             	sub    $0x4,%esp
  802833:	68 07 04 00 00       	push   $0x407
  802838:	ff 75 f4             	pushl  -0xc(%ebp)
  80283b:	6a 00                	push   $0x0
  80283d:	e8 1f e8 ff ff       	call   801061 <sys_page_alloc>
  802842:	89 c3                	mov    %eax,%ebx
  802844:	83 c4 10             	add    $0x10,%esp
  802847:	85 c0                	test   %eax,%eax
  802849:	78 28                	js     802873 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802854:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802860:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	50                   	push   %eax
  802867:	e8 31 ed ff ff       	call   80159d <fd2num>
  80286c:	89 c3                	mov    %eax,%ebx
  80286e:	83 c4 10             	add    $0x10,%esp
  802871:	eb 0c                	jmp    80287f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802873:	83 ec 0c             	sub    $0xc,%esp
  802876:	56                   	push   %esi
  802877:	e8 e2 01 00 00       	call   802a5e <nsipc_close>
		return r;
  80287c:	83 c4 10             	add    $0x10,%esp
}
  80287f:	89 d8                	mov    %ebx,%eax
  802881:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802884:	5b                   	pop    %ebx
  802885:	5e                   	pop    %esi
  802886:	5d                   	pop    %ebp
  802887:	c3                   	ret    

00802888 <accept>:
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
  80288b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	e8 4e ff ff ff       	call   8027e4 <fd2sockid>
  802896:	85 c0                	test   %eax,%eax
  802898:	78 1b                	js     8028b5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80289a:	83 ec 04             	sub    $0x4,%esp
  80289d:	ff 75 10             	pushl  0x10(%ebp)
  8028a0:	ff 75 0c             	pushl  0xc(%ebp)
  8028a3:	50                   	push   %eax
  8028a4:	e8 0e 01 00 00       	call   8029b7 <nsipc_accept>
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	78 05                	js     8028b5 <accept+0x2d>
	return alloc_sockfd(r);
  8028b0:	e8 5f ff ff ff       	call   802814 <alloc_sockfd>
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <bind>:
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	e8 1f ff ff ff       	call   8027e4 <fd2sockid>
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	78 12                	js     8028db <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	ff 75 10             	pushl  0x10(%ebp)
  8028cf:	ff 75 0c             	pushl  0xc(%ebp)
  8028d2:	50                   	push   %eax
  8028d3:	e8 2f 01 00 00       	call   802a07 <nsipc_bind>
  8028d8:	83 c4 10             	add    $0x10,%esp
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <shutdown>:
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	e8 f9 fe ff ff       	call   8027e4 <fd2sockid>
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	78 0f                	js     8028fe <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8028ef:	83 ec 08             	sub    $0x8,%esp
  8028f2:	ff 75 0c             	pushl  0xc(%ebp)
  8028f5:	50                   	push   %eax
  8028f6:	e8 41 01 00 00       	call   802a3c <nsipc_shutdown>
  8028fb:	83 c4 10             	add    $0x10,%esp
}
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <connect>:
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	e8 d6 fe ff ff       	call   8027e4 <fd2sockid>
  80290e:	85 c0                	test   %eax,%eax
  802910:	78 12                	js     802924 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802912:	83 ec 04             	sub    $0x4,%esp
  802915:	ff 75 10             	pushl  0x10(%ebp)
  802918:	ff 75 0c             	pushl  0xc(%ebp)
  80291b:	50                   	push   %eax
  80291c:	e8 57 01 00 00       	call   802a78 <nsipc_connect>
  802921:	83 c4 10             	add    $0x10,%esp
}
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <listen>:
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	e8 b0 fe ff ff       	call   8027e4 <fd2sockid>
  802934:	85 c0                	test   %eax,%eax
  802936:	78 0f                	js     802947 <listen+0x21>
	return nsipc_listen(r, backlog);
  802938:	83 ec 08             	sub    $0x8,%esp
  80293b:	ff 75 0c             	pushl  0xc(%ebp)
  80293e:	50                   	push   %eax
  80293f:	e8 69 01 00 00       	call   802aad <nsipc_listen>
  802944:	83 c4 10             	add    $0x10,%esp
}
  802947:	c9                   	leave  
  802948:	c3                   	ret    

00802949 <socket>:

int
socket(int domain, int type, int protocol)
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80294f:	ff 75 10             	pushl  0x10(%ebp)
  802952:	ff 75 0c             	pushl  0xc(%ebp)
  802955:	ff 75 08             	pushl  0x8(%ebp)
  802958:	e8 3c 02 00 00       	call   802b99 <nsipc_socket>
  80295d:	83 c4 10             	add    $0x10,%esp
  802960:	85 c0                	test   %eax,%eax
  802962:	78 05                	js     802969 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802964:	e8 ab fe ff ff       	call   802814 <alloc_sockfd>
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	53                   	push   %ebx
  80296f:	83 ec 04             	sub    $0x4,%esp
  802972:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802974:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80297b:	74 26                	je     8029a3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80297d:	6a 07                	push   $0x7
  80297f:	68 00 70 80 00       	push   $0x807000
  802984:	53                   	push   %ebx
  802985:	ff 35 04 50 80 00    	pushl  0x805004
  80298b:	e8 3b 03 00 00       	call   802ccb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802990:	83 c4 0c             	add    $0xc,%esp
  802993:	6a 00                	push   $0x0
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	e8 c4 02 00 00       	call   802c62 <ipc_recv>
}
  80299e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8029a3:	83 ec 0c             	sub    $0xc,%esp
  8029a6:	6a 02                	push   $0x2
  8029a8:	e8 77 03 00 00       	call   802d24 <ipc_find_env>
  8029ad:	a3 04 50 80 00       	mov    %eax,0x805004
  8029b2:	83 c4 10             	add    $0x10,%esp
  8029b5:	eb c6                	jmp    80297d <nsipc+0x12>

008029b7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029b7:	55                   	push   %ebp
  8029b8:	89 e5                	mov    %esp,%ebp
  8029ba:	56                   	push   %esi
  8029bb:	53                   	push   %ebx
  8029bc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8029c7:	8b 06                	mov    (%esi),%eax
  8029c9:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	e8 93 ff ff ff       	call   80296b <nsipc>
  8029d8:	89 c3                	mov    %eax,%ebx
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	78 20                	js     8029fe <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8029de:	83 ec 04             	sub    $0x4,%esp
  8029e1:	ff 35 10 70 80 00    	pushl  0x807010
  8029e7:	68 00 70 80 00       	push   $0x807000
  8029ec:	ff 75 0c             	pushl  0xc(%ebp)
  8029ef:	e8 02 e4 ff ff       	call   800df6 <memmove>
		*addrlen = ret->ret_addrlen;
  8029f4:	a1 10 70 80 00       	mov    0x807010,%eax
  8029f9:	89 06                	mov    %eax,(%esi)
  8029fb:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8029fe:	89 d8                	mov    %ebx,%eax
  802a00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a03:	5b                   	pop    %ebx
  802a04:	5e                   	pop    %esi
  802a05:	5d                   	pop    %ebp
  802a06:	c3                   	ret    

00802a07 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a07:	55                   	push   %ebp
  802a08:	89 e5                	mov    %esp,%ebp
  802a0a:	53                   	push   %ebx
  802a0b:	83 ec 08             	sub    $0x8,%esp
  802a0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802a19:	53                   	push   %ebx
  802a1a:	ff 75 0c             	pushl  0xc(%ebp)
  802a1d:	68 04 70 80 00       	push   $0x807004
  802a22:	e8 cf e3 ff ff       	call   800df6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802a27:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802a2d:	b8 02 00 00 00       	mov    $0x2,%eax
  802a32:	e8 34 ff ff ff       	call   80296b <nsipc>
}
  802a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a4d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802a52:	b8 03 00 00 00       	mov    $0x3,%eax
  802a57:	e8 0f ff ff ff       	call   80296b <nsipc>
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

00802a5e <nsipc_close>:

int
nsipc_close(int s)
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
  802a61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802a6c:	b8 04 00 00 00       	mov    $0x4,%eax
  802a71:	e8 f5 fe ff ff       	call   80296b <nsipc>
}
  802a76:	c9                   	leave  
  802a77:	c3                   	ret    

00802a78 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a78:	55                   	push   %ebp
  802a79:	89 e5                	mov    %esp,%ebp
  802a7b:	53                   	push   %ebx
  802a7c:	83 ec 08             	sub    $0x8,%esp
  802a7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802a8a:	53                   	push   %ebx
  802a8b:	ff 75 0c             	pushl  0xc(%ebp)
  802a8e:	68 04 70 80 00       	push   $0x807004
  802a93:	e8 5e e3 ff ff       	call   800df6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802a98:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802a9e:	b8 05 00 00 00       	mov    $0x5,%eax
  802aa3:	e8 c3 fe ff ff       	call   80296b <nsipc>
}
  802aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802aab:	c9                   	leave  
  802aac:	c3                   	ret    

00802aad <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
  802ab0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802abe:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802ac3:	b8 06 00 00 00       	mov    $0x6,%eax
  802ac8:	e8 9e fe ff ff       	call   80296b <nsipc>
}
  802acd:	c9                   	leave  
  802ace:	c3                   	ret    

00802acf <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
  802ad2:	56                   	push   %esi
  802ad3:	53                   	push   %ebx
  802ad4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802adf:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  802ae8:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802aed:	b8 07 00 00 00       	mov    $0x7,%eax
  802af2:	e8 74 fe ff ff       	call   80296b <nsipc>
  802af7:	89 c3                	mov    %eax,%ebx
  802af9:	85 c0                	test   %eax,%eax
  802afb:	78 1f                	js     802b1c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802afd:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802b02:	7f 21                	jg     802b25 <nsipc_recv+0x56>
  802b04:	39 c6                	cmp    %eax,%esi
  802b06:	7c 1d                	jl     802b25 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802b08:	83 ec 04             	sub    $0x4,%esp
  802b0b:	50                   	push   %eax
  802b0c:	68 00 70 80 00       	push   $0x807000
  802b11:	ff 75 0c             	pushl  0xc(%ebp)
  802b14:	e8 dd e2 ff ff       	call   800df6 <memmove>
  802b19:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802b1c:	89 d8                	mov    %ebx,%eax
  802b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b21:	5b                   	pop    %ebx
  802b22:	5e                   	pop    %esi
  802b23:	5d                   	pop    %ebp
  802b24:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802b25:	68 b9 36 80 00       	push   $0x8036b9
  802b2a:	68 91 35 80 00       	push   $0x803591
  802b2f:	6a 62                	push   $0x62
  802b31:	68 ce 36 80 00       	push   $0x8036ce
  802b36:	e8 b5 d9 ff ff       	call   8004f0 <_panic>

00802b3b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	53                   	push   %ebx
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b4d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b53:	7f 2e                	jg     802b83 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b55:	83 ec 04             	sub    $0x4,%esp
  802b58:	53                   	push   %ebx
  802b59:	ff 75 0c             	pushl  0xc(%ebp)
  802b5c:	68 0c 70 80 00       	push   $0x80700c
  802b61:	e8 90 e2 ff ff       	call   800df6 <memmove>
	nsipcbuf.send.req_size = size;
  802b66:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  802b6f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802b74:	b8 08 00 00 00       	mov    $0x8,%eax
  802b79:	e8 ed fd ff ff       	call   80296b <nsipc>
}
  802b7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b81:	c9                   	leave  
  802b82:	c3                   	ret    
	assert(size < 1600);
  802b83:	68 da 36 80 00       	push   $0x8036da
  802b88:	68 91 35 80 00       	push   $0x803591
  802b8d:	6a 6d                	push   $0x6d
  802b8f:	68 ce 36 80 00       	push   $0x8036ce
  802b94:	e8 57 d9 ff ff       	call   8004f0 <_panic>

00802b99 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
  802b9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802baa:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802baf:	8b 45 10             	mov    0x10(%ebp),%eax
  802bb2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802bb7:	b8 09 00 00 00       	mov    $0x9,%eax
  802bbc:	e8 aa fd ff ff       	call   80296b <nsipc>
}
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    

00802bc3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802bc3:	55                   	push   %ebp
  802bc4:	89 e5                	mov    %esp,%ebp
  802bc6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802bc9:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802bd0:	74 0a                	je     802bdc <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802bdc:	a1 08 50 80 00       	mov    0x805008,%eax
  802be1:	8b 40 48             	mov    0x48(%eax),%eax
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	6a 07                	push   $0x7
  802be9:	68 00 f0 bf ee       	push   $0xeebff000
  802bee:	50                   	push   %eax
  802bef:	e8 6d e4 ff ff       	call   801061 <sys_page_alloc>
  802bf4:	83 c4 10             	add    $0x10,%esp
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	75 2f                	jne    802c2a <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802bfb:	a1 08 50 80 00       	mov    0x805008,%eax
  802c00:	8b 40 48             	mov    0x48(%eax),%eax
  802c03:	83 ec 08             	sub    $0x8,%esp
  802c06:	68 3c 2c 80 00       	push   $0x802c3c
  802c0b:	50                   	push   %eax
  802c0c:	e8 9b e5 ff ff       	call   8011ac <sys_env_set_pgfault_upcall>
  802c11:	83 c4 10             	add    $0x10,%esp
  802c14:	85 c0                	test   %eax,%eax
  802c16:	74 ba                	je     802bd2 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  802c18:	50                   	push   %eax
  802c19:	68 e6 36 80 00       	push   $0x8036e6
  802c1e:	6a 24                	push   $0x24
  802c20:	68 fe 36 80 00       	push   $0x8036fe
  802c25:	e8 c6 d8 ff ff       	call   8004f0 <_panic>
		    panic("set_pgfault_handler: %e", r);
  802c2a:	50                   	push   %eax
  802c2b:	68 e6 36 80 00       	push   $0x8036e6
  802c30:	6a 21                	push   $0x21
  802c32:	68 fe 36 80 00       	push   $0x8036fe
  802c37:	e8 b4 d8 ff ff       	call   8004f0 <_panic>

00802c3c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c3c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c3d:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802c42:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c44:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  802c47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  802c4b:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  802c4e:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802c52:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802c56:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  802c58:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  802c5b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  802c5c:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  802c5f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802c60:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802c61:	c3                   	ret    

00802c62 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c62:	55                   	push   %ebp
  802c63:	89 e5                	mov    %esp,%ebp
  802c65:	56                   	push   %esi
  802c66:	53                   	push   %ebx
  802c67:	8b 75 08             	mov    0x8(%ebp),%esi
  802c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802c70:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802c72:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c77:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802c7a:	83 ec 0c             	sub    $0xc,%esp
  802c7d:	50                   	push   %eax
  802c7e:	e8 8e e5 ff ff       	call   801211 <sys_ipc_recv>
  802c83:	83 c4 10             	add    $0x10,%esp
  802c86:	85 c0                	test   %eax,%eax
  802c88:	78 2b                	js     802cb5 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802c8a:	85 f6                	test   %esi,%esi
  802c8c:	74 0a                	je     802c98 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802c8e:	a1 08 50 80 00       	mov    0x805008,%eax
  802c93:	8b 40 74             	mov    0x74(%eax),%eax
  802c96:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802c98:	85 db                	test   %ebx,%ebx
  802c9a:	74 0a                	je     802ca6 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802c9c:	a1 08 50 80 00       	mov    0x805008,%eax
  802ca1:	8b 40 78             	mov    0x78(%eax),%eax
  802ca4:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802ca6:	a1 08 50 80 00       	mov    0x805008,%eax
  802cab:	8b 40 70             	mov    0x70(%eax),%eax
}
  802cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cb1:	5b                   	pop    %ebx
  802cb2:	5e                   	pop    %esi
  802cb3:	5d                   	pop    %ebp
  802cb4:	c3                   	ret    
	    if (from_env_store != NULL) {
  802cb5:	85 f6                	test   %esi,%esi
  802cb7:	74 06                	je     802cbf <ipc_recv+0x5d>
	        *from_env_store = 0;
  802cb9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802cbf:	85 db                	test   %ebx,%ebx
  802cc1:	74 eb                	je     802cae <ipc_recv+0x4c>
	        *perm_store = 0;
  802cc3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802cc9:	eb e3                	jmp    802cae <ipc_recv+0x4c>

00802ccb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	57                   	push   %edi
  802ccf:	56                   	push   %esi
  802cd0:	53                   	push   %ebx
  802cd1:	83 ec 0c             	sub    $0xc,%esp
  802cd4:	8b 7d 08             	mov    0x8(%ebp),%edi
  802cd7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802cda:	85 f6                	test   %esi,%esi
  802cdc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802ce1:	0f 44 f0             	cmove  %eax,%esi
  802ce4:	eb 09                	jmp    802cef <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802ce6:	e8 57 e3 ff ff       	call   801042 <sys_yield>
	} while(r != 0);
  802ceb:	85 db                	test   %ebx,%ebx
  802ced:	74 2d                	je     802d1c <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802cef:	ff 75 14             	pushl  0x14(%ebp)
  802cf2:	56                   	push   %esi
  802cf3:	ff 75 0c             	pushl  0xc(%ebp)
  802cf6:	57                   	push   %edi
  802cf7:	e8 f2 e4 ff ff       	call   8011ee <sys_ipc_try_send>
  802cfc:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	85 c0                	test   %eax,%eax
  802d03:	79 e1                	jns    802ce6 <ipc_send+0x1b>
  802d05:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d08:	74 dc                	je     802ce6 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802d0a:	50                   	push   %eax
  802d0b:	68 0c 37 80 00       	push   $0x80370c
  802d10:	6a 45                	push   $0x45
  802d12:	68 19 37 80 00       	push   $0x803719
  802d17:	e8 d4 d7 ff ff       	call   8004f0 <_panic>
}
  802d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d1f:	5b                   	pop    %ebx
  802d20:	5e                   	pop    %esi
  802d21:	5f                   	pop    %edi
  802d22:	5d                   	pop    %ebp
  802d23:	c3                   	ret    

00802d24 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d24:	55                   	push   %ebp
  802d25:	89 e5                	mov    %esp,%ebp
  802d27:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d2a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d2f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802d32:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d38:	8b 52 50             	mov    0x50(%edx),%edx
  802d3b:	39 ca                	cmp    %ecx,%edx
  802d3d:	74 11                	je     802d50 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802d3f:	83 c0 01             	add    $0x1,%eax
  802d42:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d47:	75 e6                	jne    802d2f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d49:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4e:	eb 0b                	jmp    802d5b <ipc_find_env+0x37>
			return envs[i].env_id;
  802d50:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802d53:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d58:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d5b:	5d                   	pop    %ebp
  802d5c:	c3                   	ret    

00802d5d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d5d:	55                   	push   %ebp
  802d5e:	89 e5                	mov    %esp,%ebp
  802d60:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d63:	89 d0                	mov    %edx,%eax
  802d65:	c1 e8 16             	shr    $0x16,%eax
  802d68:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d6f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802d74:	f6 c1 01             	test   $0x1,%cl
  802d77:	74 1d                	je     802d96 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802d79:	c1 ea 0c             	shr    $0xc,%edx
  802d7c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d83:	f6 c2 01             	test   $0x1,%dl
  802d86:	74 0e                	je     802d96 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d88:	c1 ea 0c             	shr    $0xc,%edx
  802d8b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d92:	ef 
  802d93:	0f b7 c0             	movzwl %ax,%eax
}
  802d96:	5d                   	pop    %ebp
  802d97:	c3                   	ret    
  802d98:	66 90                	xchg   %ax,%ax
  802d9a:	66 90                	xchg   %ax,%ax
  802d9c:	66 90                	xchg   %ax,%ax
  802d9e:	66 90                	xchg   %ax,%ax

00802da0 <__udivdi3>:
  802da0:	55                   	push   %ebp
  802da1:	57                   	push   %edi
  802da2:	56                   	push   %esi
  802da3:	53                   	push   %ebx
  802da4:	83 ec 1c             	sub    $0x1c,%esp
  802da7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802dab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802daf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802db3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802db7:	85 d2                	test   %edx,%edx
  802db9:	75 35                	jne    802df0 <__udivdi3+0x50>
  802dbb:	39 f3                	cmp    %esi,%ebx
  802dbd:	0f 87 bd 00 00 00    	ja     802e80 <__udivdi3+0xe0>
  802dc3:	85 db                	test   %ebx,%ebx
  802dc5:	89 d9                	mov    %ebx,%ecx
  802dc7:	75 0b                	jne    802dd4 <__udivdi3+0x34>
  802dc9:	b8 01 00 00 00       	mov    $0x1,%eax
  802dce:	31 d2                	xor    %edx,%edx
  802dd0:	f7 f3                	div    %ebx
  802dd2:	89 c1                	mov    %eax,%ecx
  802dd4:	31 d2                	xor    %edx,%edx
  802dd6:	89 f0                	mov    %esi,%eax
  802dd8:	f7 f1                	div    %ecx
  802dda:	89 c6                	mov    %eax,%esi
  802ddc:	89 e8                	mov    %ebp,%eax
  802dde:	89 f7                	mov    %esi,%edi
  802de0:	f7 f1                	div    %ecx
  802de2:	89 fa                	mov    %edi,%edx
  802de4:	83 c4 1c             	add    $0x1c,%esp
  802de7:	5b                   	pop    %ebx
  802de8:	5e                   	pop    %esi
  802de9:	5f                   	pop    %edi
  802dea:	5d                   	pop    %ebp
  802deb:	c3                   	ret    
  802dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df0:	39 f2                	cmp    %esi,%edx
  802df2:	77 7c                	ja     802e70 <__udivdi3+0xd0>
  802df4:	0f bd fa             	bsr    %edx,%edi
  802df7:	83 f7 1f             	xor    $0x1f,%edi
  802dfa:	0f 84 98 00 00 00    	je     802e98 <__udivdi3+0xf8>
  802e00:	89 f9                	mov    %edi,%ecx
  802e02:	b8 20 00 00 00       	mov    $0x20,%eax
  802e07:	29 f8                	sub    %edi,%eax
  802e09:	d3 e2                	shl    %cl,%edx
  802e0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e0f:	89 c1                	mov    %eax,%ecx
  802e11:	89 da                	mov    %ebx,%edx
  802e13:	d3 ea                	shr    %cl,%edx
  802e15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e19:	09 d1                	or     %edx,%ecx
  802e1b:	89 f2                	mov    %esi,%edx
  802e1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e21:	89 f9                	mov    %edi,%ecx
  802e23:	d3 e3                	shl    %cl,%ebx
  802e25:	89 c1                	mov    %eax,%ecx
  802e27:	d3 ea                	shr    %cl,%edx
  802e29:	89 f9                	mov    %edi,%ecx
  802e2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e2f:	d3 e6                	shl    %cl,%esi
  802e31:	89 eb                	mov    %ebp,%ebx
  802e33:	89 c1                	mov    %eax,%ecx
  802e35:	d3 eb                	shr    %cl,%ebx
  802e37:	09 de                	or     %ebx,%esi
  802e39:	89 f0                	mov    %esi,%eax
  802e3b:	f7 74 24 08          	divl   0x8(%esp)
  802e3f:	89 d6                	mov    %edx,%esi
  802e41:	89 c3                	mov    %eax,%ebx
  802e43:	f7 64 24 0c          	mull   0xc(%esp)
  802e47:	39 d6                	cmp    %edx,%esi
  802e49:	72 0c                	jb     802e57 <__udivdi3+0xb7>
  802e4b:	89 f9                	mov    %edi,%ecx
  802e4d:	d3 e5                	shl    %cl,%ebp
  802e4f:	39 c5                	cmp    %eax,%ebp
  802e51:	73 5d                	jae    802eb0 <__udivdi3+0x110>
  802e53:	39 d6                	cmp    %edx,%esi
  802e55:	75 59                	jne    802eb0 <__udivdi3+0x110>
  802e57:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e5a:	31 ff                	xor    %edi,%edi
  802e5c:	89 fa                	mov    %edi,%edx
  802e5e:	83 c4 1c             	add    $0x1c,%esp
  802e61:	5b                   	pop    %ebx
  802e62:	5e                   	pop    %esi
  802e63:	5f                   	pop    %edi
  802e64:	5d                   	pop    %ebp
  802e65:	c3                   	ret    
  802e66:	8d 76 00             	lea    0x0(%esi),%esi
  802e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802e70:	31 ff                	xor    %edi,%edi
  802e72:	31 c0                	xor    %eax,%eax
  802e74:	89 fa                	mov    %edi,%edx
  802e76:	83 c4 1c             	add    $0x1c,%esp
  802e79:	5b                   	pop    %ebx
  802e7a:	5e                   	pop    %esi
  802e7b:	5f                   	pop    %edi
  802e7c:	5d                   	pop    %ebp
  802e7d:	c3                   	ret    
  802e7e:	66 90                	xchg   %ax,%ax
  802e80:	31 ff                	xor    %edi,%edi
  802e82:	89 e8                	mov    %ebp,%eax
  802e84:	89 f2                	mov    %esi,%edx
  802e86:	f7 f3                	div    %ebx
  802e88:	89 fa                	mov    %edi,%edx
  802e8a:	83 c4 1c             	add    $0x1c,%esp
  802e8d:	5b                   	pop    %ebx
  802e8e:	5e                   	pop    %esi
  802e8f:	5f                   	pop    %edi
  802e90:	5d                   	pop    %ebp
  802e91:	c3                   	ret    
  802e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e98:	39 f2                	cmp    %esi,%edx
  802e9a:	72 06                	jb     802ea2 <__udivdi3+0x102>
  802e9c:	31 c0                	xor    %eax,%eax
  802e9e:	39 eb                	cmp    %ebp,%ebx
  802ea0:	77 d2                	ja     802e74 <__udivdi3+0xd4>
  802ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ea7:	eb cb                	jmp    802e74 <__udivdi3+0xd4>
  802ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802eb0:	89 d8                	mov    %ebx,%eax
  802eb2:	31 ff                	xor    %edi,%edi
  802eb4:	eb be                	jmp    802e74 <__udivdi3+0xd4>
  802eb6:	66 90                	xchg   %ax,%ax
  802eb8:	66 90                	xchg   %ax,%ax
  802eba:	66 90                	xchg   %ax,%ax
  802ebc:	66 90                	xchg   %ax,%ax
  802ebe:	66 90                	xchg   %ax,%ax

00802ec0 <__umoddi3>:
  802ec0:	55                   	push   %ebp
  802ec1:	57                   	push   %edi
  802ec2:	56                   	push   %esi
  802ec3:	53                   	push   %ebx
  802ec4:	83 ec 1c             	sub    $0x1c,%esp
  802ec7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  802ecb:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ecf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802ed3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ed7:	85 ed                	test   %ebp,%ebp
  802ed9:	89 f0                	mov    %esi,%eax
  802edb:	89 da                	mov    %ebx,%edx
  802edd:	75 19                	jne    802ef8 <__umoddi3+0x38>
  802edf:	39 df                	cmp    %ebx,%edi
  802ee1:	0f 86 b1 00 00 00    	jbe    802f98 <__umoddi3+0xd8>
  802ee7:	f7 f7                	div    %edi
  802ee9:	89 d0                	mov    %edx,%eax
  802eeb:	31 d2                	xor    %edx,%edx
  802eed:	83 c4 1c             	add    $0x1c,%esp
  802ef0:	5b                   	pop    %ebx
  802ef1:	5e                   	pop    %esi
  802ef2:	5f                   	pop    %edi
  802ef3:	5d                   	pop    %ebp
  802ef4:	c3                   	ret    
  802ef5:	8d 76 00             	lea    0x0(%esi),%esi
  802ef8:	39 dd                	cmp    %ebx,%ebp
  802efa:	77 f1                	ja     802eed <__umoddi3+0x2d>
  802efc:	0f bd cd             	bsr    %ebp,%ecx
  802eff:	83 f1 1f             	xor    $0x1f,%ecx
  802f02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f06:	0f 84 b4 00 00 00    	je     802fc0 <__umoddi3+0x100>
  802f0c:	b8 20 00 00 00       	mov    $0x20,%eax
  802f11:	89 c2                	mov    %eax,%edx
  802f13:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f17:	29 c2                	sub    %eax,%edx
  802f19:	89 c1                	mov    %eax,%ecx
  802f1b:	89 f8                	mov    %edi,%eax
  802f1d:	d3 e5                	shl    %cl,%ebp
  802f1f:	89 d1                	mov    %edx,%ecx
  802f21:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802f25:	d3 e8                	shr    %cl,%eax
  802f27:	09 c5                	or     %eax,%ebp
  802f29:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f2d:	89 c1                	mov    %eax,%ecx
  802f2f:	d3 e7                	shl    %cl,%edi
  802f31:	89 d1                	mov    %edx,%ecx
  802f33:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802f37:	89 df                	mov    %ebx,%edi
  802f39:	d3 ef                	shr    %cl,%edi
  802f3b:	89 c1                	mov    %eax,%ecx
  802f3d:	89 f0                	mov    %esi,%eax
  802f3f:	d3 e3                	shl    %cl,%ebx
  802f41:	89 d1                	mov    %edx,%ecx
  802f43:	89 fa                	mov    %edi,%edx
  802f45:	d3 e8                	shr    %cl,%eax
  802f47:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f4c:	09 d8                	or     %ebx,%eax
  802f4e:	f7 f5                	div    %ebp
  802f50:	d3 e6                	shl    %cl,%esi
  802f52:	89 d1                	mov    %edx,%ecx
  802f54:	f7 64 24 08          	mull   0x8(%esp)
  802f58:	39 d1                	cmp    %edx,%ecx
  802f5a:	89 c3                	mov    %eax,%ebx
  802f5c:	89 d7                	mov    %edx,%edi
  802f5e:	72 06                	jb     802f66 <__umoddi3+0xa6>
  802f60:	75 0e                	jne    802f70 <__umoddi3+0xb0>
  802f62:	39 c6                	cmp    %eax,%esi
  802f64:	73 0a                	jae    802f70 <__umoddi3+0xb0>
  802f66:	2b 44 24 08          	sub    0x8(%esp),%eax
  802f6a:	19 ea                	sbb    %ebp,%edx
  802f6c:	89 d7                	mov    %edx,%edi
  802f6e:	89 c3                	mov    %eax,%ebx
  802f70:	89 ca                	mov    %ecx,%edx
  802f72:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802f77:	29 de                	sub    %ebx,%esi
  802f79:	19 fa                	sbb    %edi,%edx
  802f7b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802f7f:	89 d0                	mov    %edx,%eax
  802f81:	d3 e0                	shl    %cl,%eax
  802f83:	89 d9                	mov    %ebx,%ecx
  802f85:	d3 ee                	shr    %cl,%esi
  802f87:	d3 ea                	shr    %cl,%edx
  802f89:	09 f0                	or     %esi,%eax
  802f8b:	83 c4 1c             	add    $0x1c,%esp
  802f8e:	5b                   	pop    %ebx
  802f8f:	5e                   	pop    %esi
  802f90:	5f                   	pop    %edi
  802f91:	5d                   	pop    %ebp
  802f92:	c3                   	ret    
  802f93:	90                   	nop
  802f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f98:	85 ff                	test   %edi,%edi
  802f9a:	89 f9                	mov    %edi,%ecx
  802f9c:	75 0b                	jne    802fa9 <__umoddi3+0xe9>
  802f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802fa3:	31 d2                	xor    %edx,%edx
  802fa5:	f7 f7                	div    %edi
  802fa7:	89 c1                	mov    %eax,%ecx
  802fa9:	89 d8                	mov    %ebx,%eax
  802fab:	31 d2                	xor    %edx,%edx
  802fad:	f7 f1                	div    %ecx
  802faf:	89 f0                	mov    %esi,%eax
  802fb1:	f7 f1                	div    %ecx
  802fb3:	e9 31 ff ff ff       	jmp    802ee9 <__umoddi3+0x29>
  802fb8:	90                   	nop
  802fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fc0:	39 dd                	cmp    %ebx,%ebp
  802fc2:	72 08                	jb     802fcc <__umoddi3+0x10c>
  802fc4:	39 f7                	cmp    %esi,%edi
  802fc6:	0f 87 21 ff ff ff    	ja     802eed <__umoddi3+0x2d>
  802fcc:	89 da                	mov    %ebx,%edx
  802fce:	89 f0                	mov    %esi,%eax
  802fd0:	29 f8                	sub    %edi,%eax
  802fd2:	19 ea                	sbb    %ebp,%edx
  802fd4:	e9 14 ff ff ff       	jmp    802eed <__umoddi3+0x2d>
