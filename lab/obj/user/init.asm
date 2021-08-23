
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 6f 03 00 00       	call   8003a0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	eb 0c                	jmp    800056 <sum+0x23>
		tot ^= i * s[i];
  80004a:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80004e:	0f af ca             	imul   %edx,%ecx
  800051:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800053:	83 c2 01             	add    $0x1,%edx
  800056:	39 da                	cmp    %ebx,%edx
  800058:	7c f0                	jl     80004a <sum+0x17>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 20 2b 80 00       	push   $0x802b20
  800072:	e8 64 04 00 00       	call   8004db <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 40 80 00       	push   $0x804000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 e8 2b 80 00       	push   $0x802be8
  8000a5:	e8 31 04 00 00       	call   8004db <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 60 80 00       	push   $0x806020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 24 2c 80 00       	push   $0x802c24
  8000cf:	e8 07 04 00 00       	call   8004db <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 5c 2b 80 00       	push   $0x802b5c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 ad 0a 00 00       	call   800b98 <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 68 2b 80 00       	push   $0x802b68
  800105:	56                   	push   %esi
  800106:	e8 8d 0a 00 00       	call   800b98 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 7e 0a 00 00       	call   800b98 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 69 2b 80 00       	push   $0x802b69
  800122:	56                   	push   %esi
  800123:	e8 70 0a 00 00       	call   800b98 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 2f 2b 80 00       	push   $0x802b2f
  800138:	e8 9e 03 00 00       	call   8004db <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 46 2b 80 00       	push   $0x802b46
  80014d:	e8 89 03 00 00       	call   8004db <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 6b 2b 80 00       	push   $0x802b6b
  800166:	e8 70 03 00 00       	call   8004db <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 6f 2b 80 00 	movl   $0x802b6f,(%esp)
  800172:	e8 64 03 00 00       	call   8004db <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 a9 11 00 00       	call   80132c <close>
	if ((r = opencons()) < 0)
  800183:	e8 c6 01 00 00       	call   80034e <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 16                	js     8001a5 <umain+0x147>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	85 c0                	test   %eax,%eax
  800191:	74 24                	je     8001b7 <umain+0x159>
		panic("first opencons used fd %d", r);
  800193:	50                   	push   %eax
  800194:	68 9a 2b 80 00       	push   $0x802b9a
  800199:	6a 39                	push   $0x39
  80019b:	68 8e 2b 80 00       	push   $0x802b8e
  8001a0:	e8 5b 02 00 00       	call   800400 <_panic>
		panic("opencons: %e", r);
  8001a5:	50                   	push   %eax
  8001a6:	68 81 2b 80 00       	push   $0x802b81
  8001ab:	6a 37                	push   $0x37
  8001ad:	68 8e 2b 80 00       	push   $0x802b8e
  8001b2:	e8 49 02 00 00       	call   800400 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	6a 01                	push   $0x1
  8001bc:	6a 00                	push   $0x0
  8001be:	e8 b9 11 00 00       	call   80137c <dup>
  8001c3:	83 c4 10             	add    $0x10,%esp
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	79 23                	jns    8001ed <umain+0x18f>
		panic("dup: %e", r);
  8001ca:	50                   	push   %eax
  8001cb:	68 b4 2b 80 00       	push   $0x802bb4
  8001d0:	6a 3b                	push   $0x3b
  8001d2:	68 8e 2b 80 00       	push   $0x802b8e
  8001d7:	e8 24 02 00 00       	call   800400 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	68 d3 2b 80 00       	push   $0x802bd3
  8001e5:	e8 f1 02 00 00       	call   8004db <cprintf>
			continue;
  8001ea:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	68 bc 2b 80 00       	push   $0x802bbc
  8001f5:	e8 e1 02 00 00       	call   8004db <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001fa:	83 c4 0c             	add    $0xc,%esp
  8001fd:	6a 00                	push   $0x0
  8001ff:	68 d0 2b 80 00       	push   $0x802bd0
  800204:	68 cf 2b 80 00       	push   $0x802bcf
  800209:	e8 1b 1d 00 00       	call   801f29 <spawnl>
		if (r < 0) {
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	85 c0                	test   %eax,%eax
  800213:	78 c7                	js     8001dc <umain+0x17e>
		}
		wait(r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	e8 d5 20 00 00       	call   8022f3 <wait>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	eb ca                	jmp    8001ed <umain+0x18f>

00800223 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    

0080022d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800233:	68 53 2c 80 00       	push   $0x802c53
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	e8 38 09 00 00       	call   800b78 <strcpy>
	return 0;
}
  800240:	b8 00 00 00 00       	mov    $0x0,%eax
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <devcons_write>:
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800253:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800258:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80025e:	eb 2f                	jmp    80028f <devcons_write+0x48>
		m = n - tot;
  800260:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800263:	29 f3                	sub    %esi,%ebx
  800265:	83 fb 7f             	cmp    $0x7f,%ebx
  800268:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	53                   	push   %ebx
  800274:	89 f0                	mov    %esi,%eax
  800276:	03 45 0c             	add    0xc(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	57                   	push   %edi
  80027b:	e8 86 0a 00 00       	call   800d06 <memmove>
		sys_cputs(buf, m);
  800280:	83 c4 08             	add    $0x8,%esp
  800283:	53                   	push   %ebx
  800284:	57                   	push   %edi
  800285:	e8 2b 0c 00 00       	call   800eb5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80028a:	01 de                	add    %ebx,%esi
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800292:	72 cc                	jb     800260 <devcons_write+0x19>
}
  800294:	89 f0                	mov    %esi,%eax
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <devcons_read>:
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002ad:	75 07                	jne    8002b6 <devcons_read+0x18>
}
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    
		sys_yield();
  8002b1:	e8 9c 0c 00 00       	call   800f52 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8002b6:	e8 18 0c 00 00       	call   800ed3 <sys_cgetc>
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	74 f2                	je     8002b1 <devcons_read+0x13>
	if (c < 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	78 ec                	js     8002af <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8002c3:	83 f8 04             	cmp    $0x4,%eax
  8002c6:	74 0c                	je     8002d4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8002c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cb:	88 02                	mov    %al,(%edx)
	return 1;
  8002cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8002d2:	eb db                	jmp    8002af <devcons_read+0x11>
		return 0;
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	eb d4                	jmp    8002af <devcons_read+0x11>

008002db <cputchar>:
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002e7:	6a 01                	push   $0x1
  8002e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002ec:	50                   	push   %eax
  8002ed:	e8 c3 0b 00 00       	call   800eb5 <sys_cputs>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <getchar>:
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002fd:	6a 01                	push   $0x1
  8002ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	6a 00                	push   $0x0
  800305:	e8 5e 11 00 00       	call   801468 <read>
	if (r < 0)
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	85 c0                	test   %eax,%eax
  80030f:	78 08                	js     800319 <getchar+0x22>
	if (r < 1)
  800311:	85 c0                	test   %eax,%eax
  800313:	7e 06                	jle    80031b <getchar+0x24>
	return c;
  800315:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    
		return -E_EOF;
  80031b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800320:	eb f7                	jmp    800319 <getchar+0x22>

00800322 <iscons>:
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800328:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80032b:	50                   	push   %eax
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 c3 0e 00 00       	call   8011f7 <fd_lookup>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	85 c0                	test   %eax,%eax
  800339:	78 11                	js     80034c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80033b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80033e:	8b 15 70 57 80 00    	mov    0x805770,%edx
  800344:	39 10                	cmp    %edx,(%eax)
  800346:	0f 94 c0             	sete   %al
  800349:	0f b6 c0             	movzbl %al,%eax
}
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <opencons>:
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800354:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	e8 4b 0e 00 00       	call   8011a8 <fd_alloc>
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	85 c0                	test   %eax,%eax
  800362:	78 3a                	js     80039e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	68 07 04 00 00       	push   $0x407
  80036c:	ff 75 f4             	pushl  -0xc(%ebp)
  80036f:	6a 00                	push   $0x0
  800371:	e8 fb 0b 00 00       	call   800f71 <sys_page_alloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	85 c0                	test   %eax,%eax
  80037b:	78 21                	js     80039e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80037d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800380:	8b 15 70 57 80 00    	mov    0x805770,%edx
  800386:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	50                   	push   %eax
  800396:	e8 e6 0d 00 00       	call   801181 <fd2num>
  80039b:	83 c4 10             	add    $0x10,%esp
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8003ab:	e8 83 0b 00 00       	call   800f33 <sys_getenvid>
  8003b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003bd:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c2:	85 db                	test   %ebx,%ebx
  8003c4:	7e 07                	jle    8003cd <libmain+0x2d>
		binaryname = argv[0];
  8003c6:	8b 06                	mov    (%esi),%eax
  8003c8:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
  8003d2:	e8 87 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003d7:	e8 0a 00 00 00       	call   8003e6 <exit>
}
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003e2:	5b                   	pop    %ebx
  8003e3:	5e                   	pop    %esi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8003ec:	e8 66 0f 00 00       	call   801357 <close_all>
	sys_env_destroy(0);
  8003f1:	83 ec 0c             	sub    $0xc,%esp
  8003f4:	6a 00                	push   $0x0
  8003f6:	e8 f7 0a 00 00       	call   800ef2 <sys_env_destroy>
}
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	56                   	push   %esi
  800404:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800405:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800408:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  80040e:	e8 20 0b 00 00       	call   800f33 <sys_getenvid>
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	56                   	push   %esi
  80041d:	50                   	push   %eax
  80041e:	68 6c 2c 80 00       	push   $0x802c6c
  800423:	e8 b3 00 00 00       	call   8004db <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800428:	83 c4 18             	add    $0x18,%esp
  80042b:	53                   	push   %ebx
  80042c:	ff 75 10             	pushl  0x10(%ebp)
  80042f:	e8 56 00 00 00       	call   80048a <vcprintf>
	cprintf("\n");
  800434:	c7 04 24 88 31 80 00 	movl   $0x803188,(%esp)
  80043b:	e8 9b 00 00 00       	call   8004db <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800443:	cc                   	int3   
  800444:	eb fd                	jmp    800443 <_panic+0x43>

00800446 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	53                   	push   %ebx
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800450:	8b 13                	mov    (%ebx),%edx
  800452:	8d 42 01             	lea    0x1(%edx),%eax
  800455:	89 03                	mov    %eax,(%ebx)
  800457:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80045e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800463:	74 09                	je     80046e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800465:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	68 ff 00 00 00       	push   $0xff
  800476:	8d 43 08             	lea    0x8(%ebx),%eax
  800479:	50                   	push   %eax
  80047a:	e8 36 0a 00 00       	call   800eb5 <sys_cputs>
		b->idx = 0;
  80047f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	eb db                	jmp    800465 <putch+0x1f>

0080048a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800493:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80049a:	00 00 00 
	b.cnt = 0;
  80049d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a7:	ff 75 0c             	pushl  0xc(%ebp)
  8004aa:	ff 75 08             	pushl  0x8(%ebp)
  8004ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	68 46 04 80 00       	push   $0x800446
  8004b9:	e8 1a 01 00 00       	call   8005d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004be:	83 c4 08             	add    $0x8,%esp
  8004c1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 e2 09 00 00       	call   800eb5 <sys_cputs>

	return b.cnt;
}
  8004d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004e1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004e4:	50                   	push   %eax
  8004e5:	ff 75 08             	pushl  0x8(%ebp)
  8004e8:	e8 9d ff ff ff       	call   80048a <vcprintf>
	va_end(ap);

	return cnt;
}
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	57                   	push   %edi
  8004f3:	56                   	push   %esi
  8004f4:	53                   	push   %ebx
  8004f5:	83 ec 1c             	sub    $0x1c,%esp
  8004f8:	89 c7                	mov    %eax,%edi
  8004fa:	89 d6                	mov    %edx,%esi
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80050b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800510:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800513:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800516:	39 d3                	cmp    %edx,%ebx
  800518:	72 05                	jb     80051f <printnum+0x30>
  80051a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80051d:	77 7a                	ja     800599 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	ff 75 18             	pushl  0x18(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80052b:	53                   	push   %ebx
  80052c:	ff 75 10             	pushl  0x10(%ebp)
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 e4             	pushl  -0x1c(%ebp)
  800535:	ff 75 e0             	pushl  -0x20(%ebp)
  800538:	ff 75 dc             	pushl  -0x24(%ebp)
  80053b:	ff 75 d8             	pushl  -0x28(%ebp)
  80053e:	e8 9d 23 00 00       	call   8028e0 <__udivdi3>
  800543:	83 c4 18             	add    $0x18,%esp
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	89 f2                	mov    %esi,%edx
  80054a:	89 f8                	mov    %edi,%eax
  80054c:	e8 9e ff ff ff       	call   8004ef <printnum>
  800551:	83 c4 20             	add    $0x20,%esp
  800554:	eb 13                	jmp    800569 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	56                   	push   %esi
  80055a:	ff 75 18             	pushl  0x18(%ebp)
  80055d:	ff d7                	call   *%edi
  80055f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800562:	83 eb 01             	sub    $0x1,%ebx
  800565:	85 db                	test   %ebx,%ebx
  800567:	7f ed                	jg     800556 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	56                   	push   %esi
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	ff 75 e4             	pushl  -0x1c(%ebp)
  800573:	ff 75 e0             	pushl  -0x20(%ebp)
  800576:	ff 75 dc             	pushl  -0x24(%ebp)
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	e8 7f 24 00 00       	call   802a00 <__umoddi3>
  800581:	83 c4 14             	add    $0x14,%esp
  800584:	0f be 80 8f 2c 80 00 	movsbl 0x802c8f(%eax),%eax
  80058b:	50                   	push   %eax
  80058c:	ff d7                	call   *%edi
}
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800594:	5b                   	pop    %ebx
  800595:	5e                   	pop    %esi
  800596:	5f                   	pop    %edi
  800597:	5d                   	pop    %ebp
  800598:	c3                   	ret    
  800599:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80059c:	eb c4                	jmp    800562 <printnum+0x73>

0080059e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005a4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005a8:	8b 10                	mov    (%eax),%edx
  8005aa:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ad:	73 0a                	jae    8005b9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005b2:	89 08                	mov    %ecx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	88 02                	mov    %al,(%edx)
}
  8005b9:	5d                   	pop    %ebp
  8005ba:	c3                   	ret    

008005bb <printfmt>:
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005c1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005c4:	50                   	push   %eax
  8005c5:	ff 75 10             	pushl  0x10(%ebp)
  8005c8:	ff 75 0c             	pushl  0xc(%ebp)
  8005cb:	ff 75 08             	pushl  0x8(%ebp)
  8005ce:	e8 05 00 00 00       	call   8005d8 <vprintfmt>
}
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	c9                   	leave  
  8005d7:	c3                   	ret    

008005d8 <vprintfmt>:
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
  8005db:	57                   	push   %edi
  8005dc:	56                   	push   %esi
  8005dd:	53                   	push   %ebx
  8005de:	83 ec 2c             	sub    $0x2c,%esp
  8005e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ea:	e9 21 04 00 00       	jmp    800a10 <vprintfmt+0x438>
		padc = ' ';
  8005ef:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8005f3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8005fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800601:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800608:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8d 47 01             	lea    0x1(%edi),%eax
  800610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800613:	0f b6 17             	movzbl (%edi),%edx
  800616:	8d 42 dd             	lea    -0x23(%edx),%eax
  800619:	3c 55                	cmp    $0x55,%al
  80061b:	0f 87 90 04 00 00    	ja     800ab1 <vprintfmt+0x4d9>
  800621:	0f b6 c0             	movzbl %al,%eax
  800624:	ff 24 85 e0 2d 80 00 	jmp    *0x802de0(,%eax,4)
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80062e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800632:	eb d9                	jmp    80060d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800634:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800637:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80063b:	eb d0                	jmp    80060d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80063d:	0f b6 d2             	movzbl %dl,%edx
  800640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800643:	b8 00 00 00 00       	mov    $0x0,%eax
  800648:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80064b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80064e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800652:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800655:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800658:	83 f9 09             	cmp    $0x9,%ecx
  80065b:	77 55                	ja     8006b2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80065d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800660:	eb e9                	jmp    80064b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 04             	lea    0x4(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	79 91                	jns    80060d <vprintfmt+0x35>
				width = precision, precision = -1;
  80067c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800682:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800689:	eb 82                	jmp    80060d <vprintfmt+0x35>
  80068b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068e:	85 c0                	test   %eax,%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	0f 49 d0             	cmovns %eax,%edx
  800698:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80069e:	e9 6a ff ff ff       	jmp    80060d <vprintfmt+0x35>
  8006a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006a6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006ad:	e9 5b ff ff ff       	jmp    80060d <vprintfmt+0x35>
  8006b2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b8:	eb bc                	jmp    800676 <vprintfmt+0x9e>
			lflag++;
  8006ba:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006c0:	e9 48 ff ff ff       	jmp    80060d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 78 04             	lea    0x4(%eax),%edi
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	ff 30                	pushl  (%eax)
  8006d1:	ff d6                	call   *%esi
			break;
  8006d3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006d6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006d9:	e9 2f 03 00 00       	jmp    800a0d <vprintfmt+0x435>
			err = va_arg(ap, int);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 78 04             	lea    0x4(%eax),%edi
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
  8006e7:	31 d0                	xor    %edx,%eax
  8006e9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006eb:	83 f8 0f             	cmp    $0xf,%eax
  8006ee:	7f 23                	jg     800713 <vprintfmt+0x13b>
  8006f0:	8b 14 85 40 2f 80 00 	mov    0x802f40(,%eax,4),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	74 18                	je     800713 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8006fb:	52                   	push   %edx
  8006fc:	68 9b 30 80 00       	push   $0x80309b
  800701:	53                   	push   %ebx
  800702:	56                   	push   %esi
  800703:	e8 b3 fe ff ff       	call   8005bb <printfmt>
  800708:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80070b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80070e:	e9 fa 02 00 00       	jmp    800a0d <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800713:	50                   	push   %eax
  800714:	68 a7 2c 80 00       	push   $0x802ca7
  800719:	53                   	push   %ebx
  80071a:	56                   	push   %esi
  80071b:	e8 9b fe ff ff       	call   8005bb <printfmt>
  800720:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800723:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800726:	e9 e2 02 00 00       	jmp    800a0d <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	83 c0 04             	add    $0x4,%eax
  800731:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800739:	85 ff                	test   %edi,%edi
  80073b:	b8 a0 2c 80 00       	mov    $0x802ca0,%eax
  800740:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800743:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800747:	0f 8e bd 00 00 00    	jle    80080a <vprintfmt+0x232>
  80074d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800751:	75 0e                	jne    800761 <vprintfmt+0x189>
  800753:	89 75 08             	mov    %esi,0x8(%ebp)
  800756:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800759:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80075c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80075f:	eb 6d                	jmp    8007ce <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 d0             	pushl  -0x30(%ebp)
  800767:	57                   	push   %edi
  800768:	e8 ec 03 00 00       	call   800b59 <strnlen>
  80076d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800770:	29 c1                	sub    %eax,%ecx
  800772:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800775:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800778:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80077c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800782:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800784:	eb 0f                	jmp    800795 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	ff 75 e0             	pushl  -0x20(%ebp)
  80078d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80078f:	83 ef 01             	sub    $0x1,%edi
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	85 ff                	test   %edi,%edi
  800797:	7f ed                	jg     800786 <vprintfmt+0x1ae>
  800799:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80079c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80079f:	85 c9                	test   %ecx,%ecx
  8007a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a6:	0f 49 c1             	cmovns %ecx,%eax
  8007a9:	29 c1                	sub    %eax,%ecx
  8007ab:	89 75 08             	mov    %esi,0x8(%ebp)
  8007ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8007b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8007b4:	89 cb                	mov    %ecx,%ebx
  8007b6:	eb 16                	jmp    8007ce <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007bc:	75 31                	jne    8007ef <vprintfmt+0x217>
					putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	ff 55 08             	call   *0x8(%ebp)
  8007c8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007cb:	83 eb 01             	sub    $0x1,%ebx
  8007ce:	83 c7 01             	add    $0x1,%edi
  8007d1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8007d5:	0f be c2             	movsbl %dl,%eax
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	74 59                	je     800835 <vprintfmt+0x25d>
  8007dc:	85 f6                	test   %esi,%esi
  8007de:	78 d8                	js     8007b8 <vprintfmt+0x1e0>
  8007e0:	83 ee 01             	sub    $0x1,%esi
  8007e3:	79 d3                	jns    8007b8 <vprintfmt+0x1e0>
  8007e5:	89 df                	mov    %ebx,%edi
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007ed:	eb 37                	jmp    800826 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ef:	0f be d2             	movsbl %dl,%edx
  8007f2:	83 ea 20             	sub    $0x20,%edx
  8007f5:	83 fa 5e             	cmp    $0x5e,%edx
  8007f8:	76 c4                	jbe    8007be <vprintfmt+0x1e6>
					putch('?', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	6a 3f                	push   $0x3f
  800802:	ff 55 08             	call   *0x8(%ebp)
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	eb c1                	jmp    8007cb <vprintfmt+0x1f3>
  80080a:	89 75 08             	mov    %esi,0x8(%ebp)
  80080d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800810:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800813:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800816:	eb b6                	jmp    8007ce <vprintfmt+0x1f6>
				putch(' ', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 20                	push   $0x20
  80081e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800820:	83 ef 01             	sub    $0x1,%edi
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	85 ff                	test   %edi,%edi
  800828:	7f ee                	jg     800818 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80082a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	e9 d8 01 00 00       	jmp    800a0d <vprintfmt+0x435>
  800835:	89 df                	mov    %ebx,%edi
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80083d:	eb e7                	jmp    800826 <vprintfmt+0x24e>
	if (lflag >= 2)
  80083f:	83 f9 01             	cmp    $0x1,%ecx
  800842:	7e 45                	jle    800889 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8d 40 08             	lea    0x8(%eax),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80085b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80085f:	79 62                	jns    8008c3 <vprintfmt+0x2eb>
				putch('-', putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	53                   	push   %ebx
  800865:	6a 2d                	push   $0x2d
  800867:	ff d6                	call   *%esi
				num = -(long long) num;
  800869:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80086f:	f7 d8                	neg    %eax
  800871:	83 d2 00             	adc    $0x0,%edx
  800874:	f7 da                	neg    %edx
  800876:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800879:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80087f:	ba 0a 00 00 00       	mov    $0xa,%edx
  800884:	e9 66 01 00 00       	jmp    8009ef <vprintfmt+0x417>
	else if (lflag)
  800889:	85 c9                	test   %ecx,%ecx
  80088b:	75 1b                	jne    8008a8 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800895:	89 c1                	mov    %eax,%ecx
  800897:	c1 f9 1f             	sar    $0x1f,%ecx
  80089a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a6:	eb b3                	jmp    80085b <vprintfmt+0x283>
		return va_arg(*ap, long);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b0:	89 c1                	mov    %eax,%ecx
  8008b2:	c1 f9 1f             	sar    $0x1f,%ecx
  8008b5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bb:	8d 40 04             	lea    0x4(%eax),%eax
  8008be:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c1:	eb 98                	jmp    80085b <vprintfmt+0x283>
			base = 10;
  8008c3:	ba 0a 00 00 00       	mov    $0xa,%edx
  8008c8:	e9 22 01 00 00       	jmp    8009ef <vprintfmt+0x417>
	if (lflag >= 2)
  8008cd:	83 f9 01             	cmp    $0x1,%ecx
  8008d0:	7e 21                	jle    8008f3 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 50 04             	mov    0x4(%eax),%edx
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8d 40 08             	lea    0x8(%eax),%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8008ee:	e9 fc 00 00 00       	jmp    8009ef <vprintfmt+0x417>
	else if (lflag)
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	75 23                	jne    80091a <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800904:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	8d 40 04             	lea    0x4(%eax),%eax
  80090d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800910:	ba 0a 00 00 00       	mov    $0xa,%edx
  800915:	e9 d5 00 00 00       	jmp    8009ef <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800927:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 04             	lea    0x4(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800933:	ba 0a 00 00 00       	mov    $0xa,%edx
  800938:	e9 b2 00 00 00       	jmp    8009ef <vprintfmt+0x417>
	if (lflag >= 2)
  80093d:	83 f9 01             	cmp    $0x1,%ecx
  800940:	7e 42                	jle    800984 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8b 50 04             	mov    0x4(%eax),%edx
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8d 40 08             	lea    0x8(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800959:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  80095e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800962:	0f 89 87 00 00 00    	jns    8009ef <vprintfmt+0x417>
				putch('-', putdat);
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	53                   	push   %ebx
  80096c:	6a 2d                	push   $0x2d
  80096e:	ff d6                	call   *%esi
				num = -(long long) num;
  800970:	f7 5d d8             	negl   -0x28(%ebp)
  800973:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800977:	f7 5d dc             	negl   -0x24(%ebp)
  80097a:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80097d:	ba 08 00 00 00       	mov    $0x8,%edx
  800982:	eb 6b                	jmp    8009ef <vprintfmt+0x417>
	else if (lflag)
  800984:	85 c9                	test   %ecx,%ecx
  800986:	75 1b                	jne    8009a3 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	ba 00 00 00 00       	mov    $0x0,%edx
  800992:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800995:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	8d 40 04             	lea    0x4(%eax),%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	eb b6                	jmp    800959 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	8d 40 04             	lea    0x4(%eax),%eax
  8009b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bc:	eb 9b                	jmp    800959 <vprintfmt+0x381>
			putch('0', putdat);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	53                   	push   %ebx
  8009c2:	6a 30                	push   $0x30
  8009c4:	ff d6                	call   *%esi
			putch('x', putdat);
  8009c6:	83 c4 08             	add    $0x8,%esp
  8009c9:	53                   	push   %ebx
  8009ca:	6a 78                	push   $0x78
  8009cc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009db:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009de:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	8d 40 04             	lea    0x4(%eax),%eax
  8009e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ea:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009f6:	50                   	push   %eax
  8009f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8009fa:	52                   	push   %edx
  8009fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8009fe:	ff 75 d8             	pushl  -0x28(%ebp)
  800a01:	89 da                	mov    %ebx,%edx
  800a03:	89 f0                	mov    %esi,%eax
  800a05:	e8 e5 fa ff ff       	call   8004ef <printnum>
			break;
  800a0a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800a0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a10:	83 c7 01             	add    $0x1,%edi
  800a13:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a17:	83 f8 25             	cmp    $0x25,%eax
  800a1a:	0f 84 cf fb ff ff    	je     8005ef <vprintfmt+0x17>
			if (ch == '\0')
  800a20:	85 c0                	test   %eax,%eax
  800a22:	0f 84 a9 00 00 00    	je     800ad1 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	53                   	push   %ebx
  800a2c:	50                   	push   %eax
  800a2d:	ff d6                	call   *%esi
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	eb dc                	jmp    800a10 <vprintfmt+0x438>
	if (lflag >= 2)
  800a34:	83 f9 01             	cmp    $0x1,%ecx
  800a37:	7e 1e                	jle    800a57 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	8b 50 04             	mov    0x4(%eax),%edx
  800a3f:	8b 00                	mov    (%eax),%eax
  800a41:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a44:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	8d 40 08             	lea    0x8(%eax),%eax
  800a4d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a50:	ba 10 00 00 00       	mov    $0x10,%edx
  800a55:	eb 98                	jmp    8009ef <vprintfmt+0x417>
	else if (lflag)
  800a57:	85 c9                	test   %ecx,%ecx
  800a59:	75 23                	jne    800a7e <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5e:	8b 00                	mov    (%eax),%eax
  800a60:	ba 00 00 00 00       	mov    $0x0,%edx
  800a65:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a68:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8d 40 04             	lea    0x4(%eax),%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a74:	ba 10 00 00 00       	mov    $0x10,%edx
  800a79:	e9 71 ff ff ff       	jmp    8009ef <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	ba 00 00 00 00       	mov    $0x0,%edx
  800a88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	8d 40 04             	lea    0x4(%eax),%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a97:	ba 10 00 00 00       	mov    $0x10,%edx
  800a9c:	e9 4e ff ff ff       	jmp    8009ef <vprintfmt+0x417>
			putch(ch, putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	53                   	push   %ebx
  800aa5:	6a 25                	push   $0x25
  800aa7:	ff d6                	call   *%esi
			break;
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	e9 5c ff ff ff       	jmp    800a0d <vprintfmt+0x435>
			putch('%', putdat);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	53                   	push   %ebx
  800ab5:	6a 25                	push   $0x25
  800ab7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	89 f8                	mov    %edi,%eax
  800abe:	eb 03                	jmp    800ac3 <vprintfmt+0x4eb>
  800ac0:	83 e8 01             	sub    $0x1,%eax
  800ac3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ac7:	75 f7                	jne    800ac0 <vprintfmt+0x4e8>
  800ac9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800acc:	e9 3c ff ff ff       	jmp    800a0d <vprintfmt+0x435>
}
  800ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ae8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800aec:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800af6:	85 c0                	test   %eax,%eax
  800af8:	74 26                	je     800b20 <vsnprintf+0x47>
  800afa:	85 d2                	test   %edx,%edx
  800afc:	7e 22                	jle    800b20 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800afe:	ff 75 14             	pushl  0x14(%ebp)
  800b01:	ff 75 10             	pushl  0x10(%ebp)
  800b04:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b07:	50                   	push   %eax
  800b08:	68 9e 05 80 00       	push   $0x80059e
  800b0d:	e8 c6 fa ff ff       	call   8005d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b15:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
}
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    
		return -E_INVAL;
  800b20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b25:	eb f7                	jmp    800b1e <vsnprintf+0x45>

00800b27 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b2d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b30:	50                   	push   %eax
  800b31:	ff 75 10             	pushl  0x10(%ebp)
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 08             	pushl  0x8(%ebp)
  800b3a:	e8 9a ff ff ff       	call   800ad9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	eb 03                	jmp    800b51 <strlen+0x10>
		n++;
  800b4e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800b51:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b55:	75 f7                	jne    800b4e <strlen+0xd>
	return n;
}
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
  800b67:	eb 03                	jmp    800b6c <strnlen+0x13>
		n++;
  800b69:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b6c:	39 d0                	cmp    %edx,%eax
  800b6e:	74 06                	je     800b76 <strnlen+0x1d>
  800b70:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b74:	75 f3                	jne    800b69 <strnlen+0x10>
	return n;
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	53                   	push   %ebx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	83 c1 01             	add    $0x1,%ecx
  800b87:	83 c2 01             	add    $0x1,%edx
  800b8a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b8e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b91:	84 db                	test   %bl,%bl
  800b93:	75 ef                	jne    800b84 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b95:	5b                   	pop    %ebx
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	53                   	push   %ebx
  800b9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b9f:	53                   	push   %ebx
  800ba0:	e8 9c ff ff ff       	call   800b41 <strlen>
  800ba5:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	01 d8                	add    %ebx,%eax
  800bad:	50                   	push   %eax
  800bae:	e8 c5 ff ff ff       	call   800b78 <strcpy>
	return dst;
}
  800bb3:	89 d8                	mov    %ebx,%eax
  800bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	8b 75 08             	mov    0x8(%ebp),%esi
  800bc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc5:	89 f3                	mov    %esi,%ebx
  800bc7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bca:	89 f2                	mov    %esi,%edx
  800bcc:	eb 0f                	jmp    800bdd <strncpy+0x23>
		*dst++ = *src;
  800bce:	83 c2 01             	add    $0x1,%edx
  800bd1:	0f b6 01             	movzbl (%ecx),%eax
  800bd4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bd7:	80 39 01             	cmpb   $0x1,(%ecx)
  800bda:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800bdd:	39 da                	cmp    %ebx,%edx
  800bdf:	75 ed                	jne    800bce <strncpy+0x14>
	}
	return ret;
}
  800be1:	89 f0                	mov    %esi,%eax
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	8b 75 08             	mov    0x8(%ebp),%esi
  800bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bf5:	89 f0                	mov    %esi,%eax
  800bf7:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bfb:	85 c9                	test   %ecx,%ecx
  800bfd:	75 0b                	jne    800c0a <strlcpy+0x23>
  800bff:	eb 17                	jmp    800c18 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c01:	83 c2 01             	add    $0x1,%edx
  800c04:	83 c0 01             	add    $0x1,%eax
  800c07:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800c0a:	39 d8                	cmp    %ebx,%eax
  800c0c:	74 07                	je     800c15 <strlcpy+0x2e>
  800c0e:	0f b6 0a             	movzbl (%edx),%ecx
  800c11:	84 c9                	test   %cl,%cl
  800c13:	75 ec                	jne    800c01 <strlcpy+0x1a>
		*dst = '\0';
  800c15:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c18:	29 f0                	sub    %esi,%eax
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c24:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c27:	eb 06                	jmp    800c2f <strcmp+0x11>
		p++, q++;
  800c29:	83 c1 01             	add    $0x1,%ecx
  800c2c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800c2f:	0f b6 01             	movzbl (%ecx),%eax
  800c32:	84 c0                	test   %al,%al
  800c34:	74 04                	je     800c3a <strcmp+0x1c>
  800c36:	3a 02                	cmp    (%edx),%al
  800c38:	74 ef                	je     800c29 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c3a:	0f b6 c0             	movzbl %al,%eax
  800c3d:	0f b6 12             	movzbl (%edx),%edx
  800c40:	29 d0                	sub    %edx,%eax
}
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	53                   	push   %ebx
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4e:	89 c3                	mov    %eax,%ebx
  800c50:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c53:	eb 06                	jmp    800c5b <strncmp+0x17>
		n--, p++, q++;
  800c55:	83 c0 01             	add    $0x1,%eax
  800c58:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c5b:	39 d8                	cmp    %ebx,%eax
  800c5d:	74 16                	je     800c75 <strncmp+0x31>
  800c5f:	0f b6 08             	movzbl (%eax),%ecx
  800c62:	84 c9                	test   %cl,%cl
  800c64:	74 04                	je     800c6a <strncmp+0x26>
  800c66:	3a 0a                	cmp    (%edx),%cl
  800c68:	74 eb                	je     800c55 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6a:	0f b6 00             	movzbl (%eax),%eax
  800c6d:	0f b6 12             	movzbl (%edx),%edx
  800c70:	29 d0                	sub    %edx,%eax
}
  800c72:	5b                   	pop    %ebx
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    
		return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7a:	eb f6                	jmp    800c72 <strncmp+0x2e>

00800c7c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c86:	0f b6 10             	movzbl (%eax),%edx
  800c89:	84 d2                	test   %dl,%dl
  800c8b:	74 09                	je     800c96 <strchr+0x1a>
		if (*s == c)
  800c8d:	38 ca                	cmp    %cl,%dl
  800c8f:	74 0a                	je     800c9b <strchr+0x1f>
	for (; *s; s++)
  800c91:	83 c0 01             	add    $0x1,%eax
  800c94:	eb f0                	jmp    800c86 <strchr+0xa>
			return (char *) s;
	return 0;
  800c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca7:	eb 03                	jmp    800cac <strfind+0xf>
  800ca9:	83 c0 01             	add    $0x1,%eax
  800cac:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800caf:	38 ca                	cmp    %cl,%dl
  800cb1:	74 04                	je     800cb7 <strfind+0x1a>
  800cb3:	84 d2                	test   %dl,%dl
  800cb5:	75 f2                	jne    800ca9 <strfind+0xc>
			break;
	return (char *) s;
}
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	57                   	push   %edi
  800cbd:	56                   	push   %esi
  800cbe:	53                   	push   %ebx
  800cbf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cc5:	85 c9                	test   %ecx,%ecx
  800cc7:	74 13                	je     800cdc <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cc9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ccf:	75 05                	jne    800cd6 <memset+0x1d>
  800cd1:	f6 c1 03             	test   $0x3,%cl
  800cd4:	74 0d                	je     800ce3 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd9:	fc                   	cld    
  800cda:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cdc:	89 f8                	mov    %edi,%eax
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		c &= 0xFF;
  800ce3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ce7:	89 d3                	mov    %edx,%ebx
  800ce9:	c1 e3 08             	shl    $0x8,%ebx
  800cec:	89 d0                	mov    %edx,%eax
  800cee:	c1 e0 18             	shl    $0x18,%eax
  800cf1:	89 d6                	mov    %edx,%esi
  800cf3:	c1 e6 10             	shl    $0x10,%esi
  800cf6:	09 f0                	or     %esi,%eax
  800cf8:	09 c2                	or     %eax,%edx
  800cfa:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800cfc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	fc                   	cld    
  800d02:	f3 ab                	rep stos %eax,%es:(%edi)
  800d04:	eb d6                	jmp    800cdc <memset+0x23>

00800d06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d14:	39 c6                	cmp    %eax,%esi
  800d16:	73 35                	jae    800d4d <memmove+0x47>
  800d18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d1b:	39 c2                	cmp    %eax,%edx
  800d1d:	76 2e                	jbe    800d4d <memmove+0x47>
		s += n;
		d += n;
  800d1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d22:	89 d6                	mov    %edx,%esi
  800d24:	09 fe                	or     %edi,%esi
  800d26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d2c:	74 0c                	je     800d3a <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d2e:	83 ef 01             	sub    $0x1,%edi
  800d31:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d34:	fd                   	std    
  800d35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d37:	fc                   	cld    
  800d38:	eb 21                	jmp    800d5b <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d3a:	f6 c1 03             	test   $0x3,%cl
  800d3d:	75 ef                	jne    800d2e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d3f:	83 ef 04             	sub    $0x4,%edi
  800d42:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d45:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d48:	fd                   	std    
  800d49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d4b:	eb ea                	jmp    800d37 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d4d:	89 f2                	mov    %esi,%edx
  800d4f:	09 c2                	or     %eax,%edx
  800d51:	f6 c2 03             	test   $0x3,%dl
  800d54:	74 09                	je     800d5f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d56:	89 c7                	mov    %eax,%edi
  800d58:	fc                   	cld    
  800d59:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d5f:	f6 c1 03             	test   $0x3,%cl
  800d62:	75 f2                	jne    800d56 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d64:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d67:	89 c7                	mov    %eax,%edi
  800d69:	fc                   	cld    
  800d6a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6c:	eb ed                	jmp    800d5b <memmove+0x55>

00800d6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800d71:	ff 75 10             	pushl  0x10(%ebp)
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	ff 75 08             	pushl  0x8(%ebp)
  800d7a:	e8 87 ff ff ff       	call   800d06 <memmove>
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8c:	89 c6                	mov    %eax,%esi
  800d8e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d91:	39 f0                	cmp    %esi,%eax
  800d93:	74 1c                	je     800db1 <memcmp+0x30>
		if (*s1 != *s2)
  800d95:	0f b6 08             	movzbl (%eax),%ecx
  800d98:	0f b6 1a             	movzbl (%edx),%ebx
  800d9b:	38 d9                	cmp    %bl,%cl
  800d9d:	75 08                	jne    800da7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d9f:	83 c0 01             	add    $0x1,%eax
  800da2:	83 c2 01             	add    $0x1,%edx
  800da5:	eb ea                	jmp    800d91 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800da7:	0f b6 c1             	movzbl %cl,%eax
  800daa:	0f b6 db             	movzbl %bl,%ebx
  800dad:	29 d8                	sub    %ebx,%eax
  800daf:	eb 05                	jmp    800db6 <memcmp+0x35>
	}

	return 0;
  800db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dc3:	89 c2                	mov    %eax,%edx
  800dc5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dc8:	39 d0                	cmp    %edx,%eax
  800dca:	73 09                	jae    800dd5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dcc:	38 08                	cmp    %cl,(%eax)
  800dce:	74 05                	je     800dd5 <memfind+0x1b>
	for (; s < ends; s++)
  800dd0:	83 c0 01             	add    $0x1,%eax
  800dd3:	eb f3                	jmp    800dc8 <memfind+0xe>
			break;
	return (void *) s;
}
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de3:	eb 03                	jmp    800de8 <strtol+0x11>
		s++;
  800de5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800de8:	0f b6 01             	movzbl (%ecx),%eax
  800deb:	3c 20                	cmp    $0x20,%al
  800ded:	74 f6                	je     800de5 <strtol+0xe>
  800def:	3c 09                	cmp    $0x9,%al
  800df1:	74 f2                	je     800de5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800df3:	3c 2b                	cmp    $0x2b,%al
  800df5:	74 2e                	je     800e25 <strtol+0x4e>
	int neg = 0;
  800df7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dfc:	3c 2d                	cmp    $0x2d,%al
  800dfe:	74 2f                	je     800e2f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e00:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e06:	75 05                	jne    800e0d <strtol+0x36>
  800e08:	80 39 30             	cmpb   $0x30,(%ecx)
  800e0b:	74 2c                	je     800e39 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e0d:	85 db                	test   %ebx,%ebx
  800e0f:	75 0a                	jne    800e1b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e11:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800e16:	80 39 30             	cmpb   $0x30,(%ecx)
  800e19:	74 28                	je     800e43 <strtol+0x6c>
		base = 10;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e20:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e23:	eb 50                	jmp    800e75 <strtol+0x9e>
		s++;
  800e25:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e28:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2d:	eb d1                	jmp    800e00 <strtol+0x29>
		s++, neg = 1;
  800e2f:	83 c1 01             	add    $0x1,%ecx
  800e32:	bf 01 00 00 00       	mov    $0x1,%edi
  800e37:	eb c7                	jmp    800e00 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e39:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e3d:	74 0e                	je     800e4d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800e3f:	85 db                	test   %ebx,%ebx
  800e41:	75 d8                	jne    800e1b <strtol+0x44>
		s++, base = 8;
  800e43:	83 c1 01             	add    $0x1,%ecx
  800e46:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e4b:	eb ce                	jmp    800e1b <strtol+0x44>
		s += 2, base = 16;
  800e4d:	83 c1 02             	add    $0x2,%ecx
  800e50:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e55:	eb c4                	jmp    800e1b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e57:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e5a:	89 f3                	mov    %esi,%ebx
  800e5c:	80 fb 19             	cmp    $0x19,%bl
  800e5f:	77 29                	ja     800e8a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e61:	0f be d2             	movsbl %dl,%edx
  800e64:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e67:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e6a:	7d 30                	jge    800e9c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e6c:	83 c1 01             	add    $0x1,%ecx
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e75:	0f b6 11             	movzbl (%ecx),%edx
  800e78:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e7b:	89 f3                	mov    %esi,%ebx
  800e7d:	80 fb 09             	cmp    $0x9,%bl
  800e80:	77 d5                	ja     800e57 <strtol+0x80>
			dig = *s - '0';
  800e82:	0f be d2             	movsbl %dl,%edx
  800e85:	83 ea 30             	sub    $0x30,%edx
  800e88:	eb dd                	jmp    800e67 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800e8a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e8d:	89 f3                	mov    %esi,%ebx
  800e8f:	80 fb 19             	cmp    $0x19,%bl
  800e92:	77 08                	ja     800e9c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e94:	0f be d2             	movsbl %dl,%edx
  800e97:	83 ea 37             	sub    $0x37,%edx
  800e9a:	eb cb                	jmp    800e67 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea0:	74 05                	je     800ea7 <strtol+0xd0>
		*endptr = (char *) s;
  800ea2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ea5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ea7:	89 c2                	mov    %eax,%edx
  800ea9:	f7 da                	neg    %edx
  800eab:	85 ff                	test   %edi,%edi
  800ead:	0f 45 c2             	cmovne %edx,%eax
}
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec6:	89 c3                	mov    %eax,%ebx
  800ec8:	89 c7                	mov    %eax,%edi
  800eca:	89 c6                	mov    %eax,%esi
  800ecc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ede:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee3:	89 d1                	mov    %edx,%ecx
  800ee5:	89 d3                	mov    %edx,%ebx
  800ee7:	89 d7                	mov    %edx,%edi
  800ee9:	89 d6                	mov    %edx,%esi
  800eeb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f00:	8b 55 08             	mov    0x8(%ebp),%edx
  800f03:	b8 03 00 00 00       	mov    $0x3,%eax
  800f08:	89 cb                	mov    %ecx,%ebx
  800f0a:	89 cf                	mov    %ecx,%edi
  800f0c:	89 ce                	mov    %ecx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 03                	push   $0x3
  800f22:	68 9f 2f 80 00       	push   $0x802f9f
  800f27:	6a 23                	push   $0x23
  800f29:	68 bc 2f 80 00       	push   $0x802fbc
  800f2e:	e8 cd f4 ff ff       	call   800400 <_panic>

00800f33 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f39:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3e:	b8 02 00 00 00       	mov    $0x2,%eax
  800f43:	89 d1                	mov    %edx,%ecx
  800f45:	89 d3                	mov    %edx,%ebx
  800f47:	89 d7                	mov    %edx,%edi
  800f49:	89 d6                	mov    %edx,%esi
  800f4b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <sys_yield>:

void
sys_yield(void)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f58:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f62:	89 d1                	mov    %edx,%ecx
  800f64:	89 d3                	mov    %edx,%ebx
  800f66:	89 d7                	mov    %edx,%edi
  800f68:	89 d6                	mov    %edx,%esi
  800f6a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	57                   	push   %edi
  800f75:	56                   	push   %esi
  800f76:	53                   	push   %ebx
  800f77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7a:	be 00 00 00 00       	mov    $0x0,%esi
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f85:	b8 04 00 00 00       	mov    $0x4,%eax
  800f8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8d:	89 f7                	mov    %esi,%edi
  800f8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f91:	85 c0                	test   %eax,%eax
  800f93:	7f 08                	jg     800f9d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9d:	83 ec 0c             	sub    $0xc,%esp
  800fa0:	50                   	push   %eax
  800fa1:	6a 04                	push   $0x4
  800fa3:	68 9f 2f 80 00       	push   $0x802f9f
  800fa8:	6a 23                	push   $0x23
  800faa:	68 bc 2f 80 00       	push   $0x802fbc
  800faf:	e8 4c f4 ff ff       	call   800400 <_panic>

00800fb4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	b8 05 00 00 00       	mov    $0x5,%eax
  800fc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fcb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fce:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	7f 08                	jg     800fdf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fda:	5b                   	pop    %ebx
  800fdb:	5e                   	pop    %esi
  800fdc:	5f                   	pop    %edi
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdf:	83 ec 0c             	sub    $0xc,%esp
  800fe2:	50                   	push   %eax
  800fe3:	6a 05                	push   $0x5
  800fe5:	68 9f 2f 80 00       	push   $0x802f9f
  800fea:	6a 23                	push   $0x23
  800fec:	68 bc 2f 80 00       	push   $0x802fbc
  800ff1:	e8 0a f4 ff ff       	call   800400 <_panic>

00800ff6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801004:	8b 55 08             	mov    0x8(%ebp),%edx
  801007:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100a:	b8 06 00 00 00       	mov    $0x6,%eax
  80100f:	89 df                	mov    %ebx,%edi
  801011:	89 de                	mov    %ebx,%esi
  801013:	cd 30                	int    $0x30
	if(check && ret > 0)
  801015:	85 c0                	test   %eax,%eax
  801017:	7f 08                	jg     801021 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801019:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801021:	83 ec 0c             	sub    $0xc,%esp
  801024:	50                   	push   %eax
  801025:	6a 06                	push   $0x6
  801027:	68 9f 2f 80 00       	push   $0x802f9f
  80102c:	6a 23                	push   $0x23
  80102e:	68 bc 2f 80 00       	push   $0x802fbc
  801033:	e8 c8 f3 ff ff       	call   800400 <_panic>

00801038 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801041:	bb 00 00 00 00       	mov    $0x0,%ebx
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104c:	b8 08 00 00 00       	mov    $0x8,%eax
  801051:	89 df                	mov    %ebx,%edi
  801053:	89 de                	mov    %ebx,%esi
  801055:	cd 30                	int    $0x30
	if(check && ret > 0)
  801057:	85 c0                	test   %eax,%eax
  801059:	7f 08                	jg     801063 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80105b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801063:	83 ec 0c             	sub    $0xc,%esp
  801066:	50                   	push   %eax
  801067:	6a 08                	push   $0x8
  801069:	68 9f 2f 80 00       	push   $0x802f9f
  80106e:	6a 23                	push   $0x23
  801070:	68 bc 2f 80 00       	push   $0x802fbc
  801075:	e8 86 f3 ff ff       	call   800400 <_panic>

0080107a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	57                   	push   %edi
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
  801080:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801083:	bb 00 00 00 00       	mov    $0x0,%ebx
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108e:	b8 09 00 00 00       	mov    $0x9,%eax
  801093:	89 df                	mov    %ebx,%edi
  801095:	89 de                	mov    %ebx,%esi
  801097:	cd 30                	int    $0x30
	if(check && ret > 0)
  801099:	85 c0                	test   %eax,%eax
  80109b:	7f 08                	jg     8010a5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80109d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a5:	83 ec 0c             	sub    $0xc,%esp
  8010a8:	50                   	push   %eax
  8010a9:	6a 09                	push   $0x9
  8010ab:	68 9f 2f 80 00       	push   $0x802f9f
  8010b0:	6a 23                	push   $0x23
  8010b2:	68 bc 2f 80 00       	push   $0x802fbc
  8010b7:	e8 44 f3 ff ff       	call   800400 <_panic>

008010bc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	53                   	push   %ebx
  8010c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010d5:	89 df                	mov    %ebx,%edi
  8010d7:	89 de                	mov    %ebx,%esi
  8010d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	7f 08                	jg     8010e7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e7:	83 ec 0c             	sub    $0xc,%esp
  8010ea:	50                   	push   %eax
  8010eb:	6a 0a                	push   $0xa
  8010ed:	68 9f 2f 80 00       	push   $0x802f9f
  8010f2:	6a 23                	push   $0x23
  8010f4:	68 bc 2f 80 00       	push   $0x802fbc
  8010f9:	e8 02 f3 ff ff       	call   800400 <_panic>

008010fe <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
	asm volatile("int %1\n"
  801104:	8b 55 08             	mov    0x8(%ebp),%edx
  801107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80110f:	be 00 00 00 00       	mov    $0x0,%esi
  801114:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801117:	8b 7d 14             	mov    0x14(%ebp),%edi
  80111a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    

00801121 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	57                   	push   %edi
  801125:	56                   	push   %esi
  801126:	53                   	push   %ebx
  801127:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	b8 0d 00 00 00       	mov    $0xd,%eax
  801137:	89 cb                	mov    %ecx,%ebx
  801139:	89 cf                	mov    %ecx,%edi
  80113b:	89 ce                	mov    %ecx,%esi
  80113d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113f:	85 c0                	test   %eax,%eax
  801141:	7f 08                	jg     80114b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	50                   	push   %eax
  80114f:	6a 0d                	push   $0xd
  801151:	68 9f 2f 80 00       	push   $0x802f9f
  801156:	6a 23                	push   $0x23
  801158:	68 bc 2f 80 00       	push   $0x802fbc
  80115d:	e8 9e f2 ff ff       	call   800400 <_panic>

00801162 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	57                   	push   %edi
  801166:	56                   	push   %esi
  801167:	53                   	push   %ebx
	asm volatile("int %1\n"
  801168:	ba 00 00 00 00       	mov    $0x0,%edx
  80116d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801172:	89 d1                	mov    %edx,%ecx
  801174:	89 d3                	mov    %edx,%ebx
  801176:	89 d7                	mov    %edx,%edi
  801178:	89 d6                	mov    %edx,%esi
  80117a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80117c:	5b                   	pop    %ebx
  80117d:	5e                   	pop    %esi
  80117e:	5f                   	pop    %edi
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	05 00 00 00 30       	add    $0x30000000,%eax
  80118c:	c1 e8 0c             	shr    $0xc,%eax
}
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80119c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a6:	5d                   	pop    %ebp
  8011a7:	c3                   	ret    

008011a8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ae:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011b3:	89 c2                	mov    %eax,%edx
  8011b5:	c1 ea 16             	shr    $0x16,%edx
  8011b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011bf:	f6 c2 01             	test   $0x1,%dl
  8011c2:	74 2a                	je     8011ee <fd_alloc+0x46>
  8011c4:	89 c2                	mov    %eax,%edx
  8011c6:	c1 ea 0c             	shr    $0xc,%edx
  8011c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d0:	f6 c2 01             	test   $0x1,%dl
  8011d3:	74 19                	je     8011ee <fd_alloc+0x46>
  8011d5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011da:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011df:	75 d2                	jne    8011b3 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011e7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011ec:	eb 07                	jmp    8011f5 <fd_alloc+0x4d>
			*fd_store = fd;
  8011ee:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    

008011f7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011fd:	83 f8 1f             	cmp    $0x1f,%eax
  801200:	77 36                	ja     801238 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801202:	c1 e0 0c             	shl    $0xc,%eax
  801205:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80120a:	89 c2                	mov    %eax,%edx
  80120c:	c1 ea 16             	shr    $0x16,%edx
  80120f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801216:	f6 c2 01             	test   $0x1,%dl
  801219:	74 24                	je     80123f <fd_lookup+0x48>
  80121b:	89 c2                	mov    %eax,%edx
  80121d:	c1 ea 0c             	shr    $0xc,%edx
  801220:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801227:	f6 c2 01             	test   $0x1,%dl
  80122a:	74 1a                	je     801246 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80122c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122f:	89 02                	mov    %eax,(%edx)
	return 0;
  801231:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    
		return -E_INVAL;
  801238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123d:	eb f7                	jmp    801236 <fd_lookup+0x3f>
		return -E_INVAL;
  80123f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801244:	eb f0                	jmp    801236 <fd_lookup+0x3f>
  801246:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124b:	eb e9                	jmp    801236 <fd_lookup+0x3f>

0080124d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801256:	ba 48 30 80 00       	mov    $0x803048,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80125b:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  801260:	39 08                	cmp    %ecx,(%eax)
  801262:	74 33                	je     801297 <dev_lookup+0x4a>
  801264:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801267:	8b 02                	mov    (%edx),%eax
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 f3                	jne    801260 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80126d:	a1 90 77 80 00       	mov    0x807790,%eax
  801272:	8b 40 48             	mov    0x48(%eax),%eax
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	51                   	push   %ecx
  801279:	50                   	push   %eax
  80127a:	68 cc 2f 80 00       	push   $0x802fcc
  80127f:	e8 57 f2 ff ff       	call   8004db <cprintf>
	*dev = 0;
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    
			*dev = devtab[i];
  801297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a1:	eb f2                	jmp    801295 <dev_lookup+0x48>

008012a3 <fd_close>:
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 1c             	sub    $0x1c,%esp
  8012ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8012af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012bc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bf:	50                   	push   %eax
  8012c0:	e8 32 ff ff ff       	call   8011f7 <fd_lookup>
  8012c5:	89 c3                	mov    %eax,%ebx
  8012c7:	83 c4 08             	add    $0x8,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	78 05                	js     8012d3 <fd_close+0x30>
	    || fd != fd2)
  8012ce:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012d1:	74 16                	je     8012e9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012d3:	89 f8                	mov    %edi,%eax
  8012d5:	84 c0                	test   %al,%al
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	0f 44 d8             	cmove  %eax,%ebx
}
  8012df:	89 d8                	mov    %ebx,%eax
  8012e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012ef:	50                   	push   %eax
  8012f0:	ff 36                	pushl  (%esi)
  8012f2:	e8 56 ff ff ff       	call   80124d <dev_lookup>
  8012f7:	89 c3                	mov    %eax,%ebx
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 15                	js     801315 <fd_close+0x72>
		if (dev->dev_close)
  801300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801303:	8b 40 10             	mov    0x10(%eax),%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1b                	je     801325 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80130a:	83 ec 0c             	sub    $0xc,%esp
  80130d:	56                   	push   %esi
  80130e:	ff d0                	call   *%eax
  801310:	89 c3                	mov    %eax,%ebx
  801312:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	56                   	push   %esi
  801319:	6a 00                	push   $0x0
  80131b:	e8 d6 fc ff ff       	call   800ff6 <sys_page_unmap>
	return r;
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	eb ba                	jmp    8012df <fd_close+0x3c>
			r = 0;
  801325:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132a:	eb e9                	jmp    801315 <fd_close+0x72>

0080132c <close>:

int
close(int fdnum)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801332:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801335:	50                   	push   %eax
  801336:	ff 75 08             	pushl  0x8(%ebp)
  801339:	e8 b9 fe ff ff       	call   8011f7 <fd_lookup>
  80133e:	83 c4 08             	add    $0x8,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	78 10                	js     801355 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	6a 01                	push   $0x1
  80134a:	ff 75 f4             	pushl  -0xc(%ebp)
  80134d:	e8 51 ff ff ff       	call   8012a3 <fd_close>
  801352:	83 c4 10             	add    $0x10,%esp
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <close_all>:

void
close_all(void)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	53                   	push   %ebx
  80135b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80135e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	53                   	push   %ebx
  801367:	e8 c0 ff ff ff       	call   80132c <close>
	for (i = 0; i < MAXFD; i++)
  80136c:	83 c3 01             	add    $0x1,%ebx
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	83 fb 20             	cmp    $0x20,%ebx
  801375:	75 ec                	jne    801363 <close_all+0xc>
}
  801377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801385:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801388:	50                   	push   %eax
  801389:	ff 75 08             	pushl  0x8(%ebp)
  80138c:	e8 66 fe ff ff       	call   8011f7 <fd_lookup>
  801391:	89 c3                	mov    %eax,%ebx
  801393:	83 c4 08             	add    $0x8,%esp
  801396:	85 c0                	test   %eax,%eax
  801398:	0f 88 81 00 00 00    	js     80141f <dup+0xa3>
		return r;
	close(newfdnum);
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 83 ff ff ff       	call   80132c <close>

	newfd = INDEX2FD(newfdnum);
  8013a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ac:	c1 e6 0c             	shl    $0xc,%esi
  8013af:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013b5:	83 c4 04             	add    $0x4,%esp
  8013b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013bb:	e8 d1 fd ff ff       	call   801191 <fd2data>
  8013c0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013c2:	89 34 24             	mov    %esi,(%esp)
  8013c5:	e8 c7 fd ff ff       	call   801191 <fd2data>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013cf:	89 d8                	mov    %ebx,%eax
  8013d1:	c1 e8 16             	shr    $0x16,%eax
  8013d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013db:	a8 01                	test   $0x1,%al
  8013dd:	74 11                	je     8013f0 <dup+0x74>
  8013df:	89 d8                	mov    %ebx,%eax
  8013e1:	c1 e8 0c             	shr    $0xc,%eax
  8013e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013eb:	f6 c2 01             	test   $0x1,%dl
  8013ee:	75 39                	jne    801429 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f3:	89 d0                	mov    %edx,%eax
  8013f5:	c1 e8 0c             	shr    $0xc,%eax
  8013f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	25 07 0e 00 00       	and    $0xe07,%eax
  801407:	50                   	push   %eax
  801408:	56                   	push   %esi
  801409:	6a 00                	push   $0x0
  80140b:	52                   	push   %edx
  80140c:	6a 00                	push   $0x0
  80140e:	e8 a1 fb ff ff       	call   800fb4 <sys_page_map>
  801413:	89 c3                	mov    %eax,%ebx
  801415:	83 c4 20             	add    $0x20,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 31                	js     80144d <dup+0xd1>
		goto err;

	return newfdnum;
  80141c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80141f:	89 d8                	mov    %ebx,%eax
  801421:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801429:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	25 07 0e 00 00       	and    $0xe07,%eax
  801438:	50                   	push   %eax
  801439:	57                   	push   %edi
  80143a:	6a 00                	push   $0x0
  80143c:	53                   	push   %ebx
  80143d:	6a 00                	push   $0x0
  80143f:	e8 70 fb ff ff       	call   800fb4 <sys_page_map>
  801444:	89 c3                	mov    %eax,%ebx
  801446:	83 c4 20             	add    $0x20,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	79 a3                	jns    8013f0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80144d:	83 ec 08             	sub    $0x8,%esp
  801450:	56                   	push   %esi
  801451:	6a 00                	push   $0x0
  801453:	e8 9e fb ff ff       	call   800ff6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801458:	83 c4 08             	add    $0x8,%esp
  80145b:	57                   	push   %edi
  80145c:	6a 00                	push   $0x0
  80145e:	e8 93 fb ff ff       	call   800ff6 <sys_page_unmap>
	return r;
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	eb b7                	jmp    80141f <dup+0xa3>

00801468 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	53                   	push   %ebx
  80146c:	83 ec 14             	sub    $0x14,%esp
  80146f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801472:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801475:	50                   	push   %eax
  801476:	53                   	push   %ebx
  801477:	e8 7b fd ff ff       	call   8011f7 <fd_lookup>
  80147c:	83 c4 08             	add    $0x8,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 3f                	js     8014c2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801489:	50                   	push   %eax
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148d:	ff 30                	pushl  (%eax)
  80148f:	e8 b9 fd ff ff       	call   80124d <dev_lookup>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 27                	js     8014c2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80149b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80149e:	8b 42 08             	mov    0x8(%edx),%eax
  8014a1:	83 e0 03             	and    $0x3,%eax
  8014a4:	83 f8 01             	cmp    $0x1,%eax
  8014a7:	74 1e                	je     8014c7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ac:	8b 40 08             	mov    0x8(%eax),%eax
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 35                	je     8014e8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	ff 75 10             	pushl  0x10(%ebp)
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	52                   	push   %edx
  8014bd:	ff d0                	call   *%eax
  8014bf:	83 c4 10             	add    $0x10,%esp
}
  8014c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c7:	a1 90 77 80 00       	mov    0x807790,%eax
  8014cc:	8b 40 48             	mov    0x48(%eax),%eax
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	53                   	push   %ebx
  8014d3:	50                   	push   %eax
  8014d4:	68 0d 30 80 00       	push   $0x80300d
  8014d9:	e8 fd ef ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e6:	eb da                	jmp    8014c2 <read+0x5a>
		return -E_NOT_SUPP;
  8014e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ed:	eb d3                	jmp    8014c2 <read+0x5a>

008014ef <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	57                   	push   %edi
  8014f3:	56                   	push   %esi
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 0c             	sub    $0xc,%esp
  8014f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014fb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801503:	39 f3                	cmp    %esi,%ebx
  801505:	73 25                	jae    80152c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	89 f0                	mov    %esi,%eax
  80150c:	29 d8                	sub    %ebx,%eax
  80150e:	50                   	push   %eax
  80150f:	89 d8                	mov    %ebx,%eax
  801511:	03 45 0c             	add    0xc(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	57                   	push   %edi
  801516:	e8 4d ff ff ff       	call   801468 <read>
		if (m < 0)
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 08                	js     80152a <readn+0x3b>
			return m;
		if (m == 0)
  801522:	85 c0                	test   %eax,%eax
  801524:	74 06                	je     80152c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801526:	01 c3                	add    %eax,%ebx
  801528:	eb d9                	jmp    801503 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80152a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	53                   	push   %ebx
  80153a:	83 ec 14             	sub    $0x14,%esp
  80153d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801540:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801543:	50                   	push   %eax
  801544:	53                   	push   %ebx
  801545:	e8 ad fc ff ff       	call   8011f7 <fd_lookup>
  80154a:	83 c4 08             	add    $0x8,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 3a                	js     80158b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801551:	83 ec 08             	sub    $0x8,%esp
  801554:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801557:	50                   	push   %eax
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	ff 30                	pushl  (%eax)
  80155d:	e8 eb fc ff ff       	call   80124d <dev_lookup>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 22                	js     80158b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801570:	74 1e                	je     801590 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801575:	8b 52 0c             	mov    0xc(%edx),%edx
  801578:	85 d2                	test   %edx,%edx
  80157a:	74 35                	je     8015b1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	ff 75 10             	pushl  0x10(%ebp)
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	50                   	push   %eax
  801586:	ff d2                	call   *%edx
  801588:	83 c4 10             	add    $0x10,%esp
}
  80158b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801590:	a1 90 77 80 00       	mov    0x807790,%eax
  801595:	8b 40 48             	mov    0x48(%eax),%eax
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	53                   	push   %ebx
  80159c:	50                   	push   %eax
  80159d:	68 29 30 80 00       	push   $0x803029
  8015a2:	e8 34 ef ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015af:	eb da                	jmp    80158b <write+0x55>
		return -E_NOT_SUPP;
  8015b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b6:	eb d3                	jmp    80158b <write+0x55>

008015b8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015be:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015c1:	50                   	push   %eax
  8015c2:	ff 75 08             	pushl  0x8(%ebp)
  8015c5:	e8 2d fc ff ff       	call   8011f7 <fd_lookup>
  8015ca:	83 c4 08             	add    $0x8,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 0e                	js     8015df <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 14             	sub    $0x14,%esp
  8015e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ee:	50                   	push   %eax
  8015ef:	53                   	push   %ebx
  8015f0:	e8 02 fc ff ff       	call   8011f7 <fd_lookup>
  8015f5:	83 c4 08             	add    $0x8,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 37                	js     801633 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801602:	50                   	push   %eax
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	ff 30                	pushl  (%eax)
  801608:	e8 40 fc ff ff       	call   80124d <dev_lookup>
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	78 1f                	js     801633 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80161b:	74 1b                	je     801638 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80161d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801620:	8b 52 18             	mov    0x18(%edx),%edx
  801623:	85 d2                	test   %edx,%edx
  801625:	74 32                	je     801659 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	ff 75 0c             	pushl  0xc(%ebp)
  80162d:	50                   	push   %eax
  80162e:	ff d2                	call   *%edx
  801630:	83 c4 10             	add    $0x10,%esp
}
  801633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801636:	c9                   	leave  
  801637:	c3                   	ret    
			thisenv->env_id, fdnum);
  801638:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80163d:	8b 40 48             	mov    0x48(%eax),%eax
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	53                   	push   %ebx
  801644:	50                   	push   %eax
  801645:	68 ec 2f 80 00       	push   $0x802fec
  80164a:	e8 8c ee ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801657:	eb da                	jmp    801633 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801659:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165e:	eb d3                	jmp    801633 <ftruncate+0x52>

00801660 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	53                   	push   %ebx
  801664:	83 ec 14             	sub    $0x14,%esp
  801667:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166d:	50                   	push   %eax
  80166e:	ff 75 08             	pushl  0x8(%ebp)
  801671:	e8 81 fb ff ff       	call   8011f7 <fd_lookup>
  801676:	83 c4 08             	add    $0x8,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 4b                	js     8016c8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801683:	50                   	push   %eax
  801684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801687:	ff 30                	pushl  (%eax)
  801689:	e8 bf fb ff ff       	call   80124d <dev_lookup>
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 33                	js     8016c8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801698:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80169c:	74 2f                	je     8016cd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016a1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a8:	00 00 00 
	stat->st_isdir = 0;
  8016ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b2:	00 00 00 
	stat->st_dev = dev;
  8016b5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	53                   	push   %ebx
  8016bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c2:	ff 50 14             	call   *0x14(%eax)
  8016c5:	83 c4 10             	add    $0x10,%esp
}
  8016c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    
		return -E_NOT_SUPP;
  8016cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d2:	eb f4                	jmp    8016c8 <fstat+0x68>

008016d4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	56                   	push   %esi
  8016d8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d9:	83 ec 08             	sub    $0x8,%esp
  8016dc:	6a 00                	push   $0x0
  8016de:	ff 75 08             	pushl  0x8(%ebp)
  8016e1:	e8 26 02 00 00       	call   80190c <open>
  8016e6:	89 c3                	mov    %eax,%ebx
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 1b                	js     80170a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	50                   	push   %eax
  8016f6:	e8 65 ff ff ff       	call   801660 <fstat>
  8016fb:	89 c6                	mov    %eax,%esi
	close(fd);
  8016fd:	89 1c 24             	mov    %ebx,(%esp)
  801700:	e8 27 fc ff ff       	call   80132c <close>
	return r;
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	89 f3                	mov    %esi,%ebx
}
  80170a:	89 d8                	mov    %ebx,%eax
  80170c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5d                   	pop    %ebp
  801712:	c3                   	ret    

00801713 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	89 c6                	mov    %eax,%esi
  80171a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801723:	74 27                	je     80174c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801725:	6a 07                	push   $0x7
  801727:	68 00 80 80 00       	push   $0x808000
  80172c:	56                   	push   %esi
  80172d:	ff 35 00 60 80 00    	pushl  0x806000
  801733:	e8 d8 10 00 00       	call   802810 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801738:	83 c4 0c             	add    $0xc,%esp
  80173b:	6a 00                	push   $0x0
  80173d:	53                   	push   %ebx
  80173e:	6a 00                	push   $0x0
  801740:	e8 62 10 00 00       	call   8027a7 <ipc_recv>
}
  801745:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	6a 01                	push   $0x1
  801751:	e8 13 11 00 00       	call   802869 <ipc_find_env>
  801756:	a3 00 60 80 00       	mov    %eax,0x806000
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	eb c5                	jmp    801725 <fsipc+0x12>

00801760 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8b 40 0c             	mov    0xc(%eax),%eax
  80176c:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801779:	ba 00 00 00 00       	mov    $0x0,%edx
  80177e:	b8 02 00 00 00       	mov    $0x2,%eax
  801783:	e8 8b ff ff ff       	call   801713 <fsipc>
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <devfile_flush>:
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8b 40 0c             	mov    0xc(%eax),%eax
  801796:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  80179b:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a0:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a5:	e8 69 ff ff ff       	call   801713 <fsipc>
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <devfile_stat>:
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bc:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8017cb:	e8 43 ff ff ff       	call   801713 <fsipc>
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	78 2c                	js     801800 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	68 00 80 80 00       	push   $0x808000
  8017dc:	53                   	push   %ebx
  8017dd:	e8 96 f3 ff ff       	call   800b78 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e2:	a1 80 80 80 00       	mov    0x808080,%eax
  8017e7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ed:	a1 84 80 80 00       	mov    0x808084,%eax
  8017f2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <devfile_write>:
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	8b 40 0c             	mov    0xc(%eax),%eax
  801815:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n;
  80181a:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801820:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801826:	77 30                	ja     801858 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801828:	83 ec 04             	sub    $0x4,%esp
  80182b:	53                   	push   %ebx
  80182c:	ff 75 0c             	pushl  0xc(%ebp)
  80182f:	68 08 80 80 00       	push   $0x808008
  801834:	e8 cd f4 ff ff       	call   800d06 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801839:	ba 00 00 00 00       	mov    $0x0,%edx
  80183e:	b8 04 00 00 00       	mov    $0x4,%eax
  801843:	e8 cb fe ff ff       	call   801713 <fsipc>
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	85 c0                	test   %eax,%eax
  80184d:	78 04                	js     801853 <devfile_write+0x4e>
	assert(r <= n);
  80184f:	39 d8                	cmp    %ebx,%eax
  801851:	77 1e                	ja     801871 <devfile_write+0x6c>
}
  801853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801856:	c9                   	leave  
  801857:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801858:	68 5c 30 80 00       	push   $0x80305c
  80185d:	68 89 30 80 00       	push   $0x803089
  801862:	68 94 00 00 00       	push   $0x94
  801867:	68 9e 30 80 00       	push   $0x80309e
  80186c:	e8 8f eb ff ff       	call   800400 <_panic>
	assert(r <= n);
  801871:	68 a9 30 80 00       	push   $0x8030a9
  801876:	68 89 30 80 00       	push   $0x803089
  80187b:	68 98 00 00 00       	push   $0x98
  801880:	68 9e 30 80 00       	push   $0x80309e
  801885:	e8 76 eb ff ff       	call   800400 <_panic>

0080188a <devfile_read>:
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	56                   	push   %esi
  80188e:	53                   	push   %ebx
  80188f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	8b 40 0c             	mov    0xc(%eax),%eax
  801898:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  80189d:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8018ad:	e8 61 fe ff ff       	call   801713 <fsipc>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 1f                	js     8018d7 <devfile_read+0x4d>
	assert(r <= n);
  8018b8:	39 f0                	cmp    %esi,%eax
  8018ba:	77 24                	ja     8018e0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018bc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018c1:	7f 33                	jg     8018f6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	50                   	push   %eax
  8018c7:	68 00 80 80 00       	push   $0x808000
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	e8 32 f4 ff ff       	call   800d06 <memmove>
	return r;
  8018d4:	83 c4 10             	add    $0x10,%esp
}
  8018d7:	89 d8                	mov    %ebx,%eax
  8018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018dc:	5b                   	pop    %ebx
  8018dd:	5e                   	pop    %esi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    
	assert(r <= n);
  8018e0:	68 a9 30 80 00       	push   $0x8030a9
  8018e5:	68 89 30 80 00       	push   $0x803089
  8018ea:	6a 7c                	push   $0x7c
  8018ec:	68 9e 30 80 00       	push   $0x80309e
  8018f1:	e8 0a eb ff ff       	call   800400 <_panic>
	assert(r <= PGSIZE);
  8018f6:	68 b0 30 80 00       	push   $0x8030b0
  8018fb:	68 89 30 80 00       	push   $0x803089
  801900:	6a 7d                	push   $0x7d
  801902:	68 9e 30 80 00       	push   $0x80309e
  801907:	e8 f4 ea ff ff       	call   800400 <_panic>

0080190c <open>:
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
  801911:	83 ec 1c             	sub    $0x1c,%esp
  801914:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801917:	56                   	push   %esi
  801918:	e8 24 f2 ff ff       	call   800b41 <strlen>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801925:	7f 6c                	jg     801993 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801927:	83 ec 0c             	sub    $0xc,%esp
  80192a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192d:	50                   	push   %eax
  80192e:	e8 75 f8 ff ff       	call   8011a8 <fd_alloc>
  801933:	89 c3                	mov    %eax,%ebx
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 3c                	js     801978 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80193c:	83 ec 08             	sub    $0x8,%esp
  80193f:	56                   	push   %esi
  801940:	68 00 80 80 00       	push   $0x808000
  801945:	e8 2e f2 ff ff       	call   800b78 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80194a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194d:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801955:	b8 01 00 00 00       	mov    $0x1,%eax
  80195a:	e8 b4 fd ff ff       	call   801713 <fsipc>
  80195f:	89 c3                	mov    %eax,%ebx
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	85 c0                	test   %eax,%eax
  801966:	78 19                	js     801981 <open+0x75>
	return fd2num(fd);
  801968:	83 ec 0c             	sub    $0xc,%esp
  80196b:	ff 75 f4             	pushl  -0xc(%ebp)
  80196e:	e8 0e f8 ff ff       	call   801181 <fd2num>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	83 c4 10             	add    $0x10,%esp
}
  801978:	89 d8                	mov    %ebx,%eax
  80197a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5e                   	pop    %esi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    
		fd_close(fd, 0);
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	6a 00                	push   $0x0
  801986:	ff 75 f4             	pushl  -0xc(%ebp)
  801989:	e8 15 f9 ff ff       	call   8012a3 <fd_close>
		return r;
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	eb e5                	jmp    801978 <open+0x6c>
		return -E_BAD_PATH;
  801993:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801998:	eb de                	jmp    801978 <open+0x6c>

0080199a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019aa:	e8 64 fd ff ff       	call   801713 <fsipc>
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	57                   	push   %edi
  8019b5:	56                   	push   %esi
  8019b6:	53                   	push   %ebx
  8019b7:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019bd:	6a 00                	push   $0x0
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	e8 45 ff ff ff       	call   80190c <open>
  8019c7:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	0f 88 40 03 00 00    	js     801d18 <spawn+0x367>
  8019d8:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	68 00 02 00 00       	push   $0x200
  8019e2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	52                   	push   %edx
  8019ea:	e8 00 fb ff ff       	call   8014ef <readn>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	3d 00 02 00 00       	cmp    $0x200,%eax
  8019f7:	75 5d                	jne    801a56 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8019f9:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a00:	45 4c 46 
  801a03:	75 51                	jne    801a56 <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a05:	b8 07 00 00 00       	mov    $0x7,%eax
  801a0a:	cd 30                	int    $0x30
  801a0c:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a12:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	0f 88 b6 04 00 00    	js     801ed6 <spawn+0x525>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a20:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a25:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801a28:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a2e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a34:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a3b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a41:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a47:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a4c:	be 00 00 00 00       	mov    $0x0,%esi
  801a51:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a54:	eb 4b                	jmp    801aa1 <spawn+0xf0>
		close(fd);
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801a5f:	e8 c8 f8 ff ff       	call   80132c <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a64:	83 c4 0c             	add    $0xc,%esp
  801a67:	68 7f 45 4c 46       	push   $0x464c457f
  801a6c:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a72:	68 bc 30 80 00       	push   $0x8030bc
  801a77:	e8 5f ea ff ff       	call   8004db <cprintf>
		return -E_NOT_EXEC;
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801a86:	ff ff ff 
  801a89:	e9 8a 02 00 00       	jmp    801d18 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801a8e:	83 ec 0c             	sub    $0xc,%esp
  801a91:	50                   	push   %eax
  801a92:	e8 aa f0 ff ff       	call   800b41 <strlen>
  801a97:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a9b:	83 c3 01             	add    $0x1,%ebx
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801aa8:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801aab:	85 c0                	test   %eax,%eax
  801aad:	75 df                	jne    801a8e <spawn+0xdd>
  801aaf:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801ab5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801abb:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ac0:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ac2:	89 fa                	mov    %edi,%edx
  801ac4:	83 e2 fc             	and    $0xfffffffc,%edx
  801ac7:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ace:	29 c2                	sub    %eax,%edx
  801ad0:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ad6:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ad9:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ade:	0f 86 03 04 00 00    	jbe    801ee7 <spawn+0x536>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	6a 07                	push   $0x7
  801ae9:	68 00 00 40 00       	push   $0x400000
  801aee:	6a 00                	push   $0x0
  801af0:	e8 7c f4 ff ff       	call   800f71 <sys_page_alloc>
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	85 c0                	test   %eax,%eax
  801afa:	0f 88 ec 03 00 00    	js     801eec <spawn+0x53b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b00:	be 00 00 00 00       	mov    $0x0,%esi
  801b05:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b0b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b0e:	eb 30                	jmp    801b40 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b10:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b16:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801b1c:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801b1f:	83 ec 08             	sub    $0x8,%esp
  801b22:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b25:	57                   	push   %edi
  801b26:	e8 4d f0 ff ff       	call   800b78 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b2b:	83 c4 04             	add    $0x4,%esp
  801b2e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b31:	e8 0b f0 ff ff       	call   800b41 <strlen>
  801b36:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b3a:	83 c6 01             	add    $0x1,%esi
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b46:	7f c8                	jg     801b10 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801b48:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b4e:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b54:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b5b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b61:	0f 85 8c 00 00 00    	jne    801bf3 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b67:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801b6d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b73:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801b76:	89 f8                	mov    %edi,%eax
  801b78:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801b7e:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b81:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b86:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b8c:	83 ec 0c             	sub    $0xc,%esp
  801b8f:	6a 07                	push   $0x7
  801b91:	68 00 d0 bf ee       	push   $0xeebfd000
  801b96:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b9c:	68 00 00 40 00       	push   $0x400000
  801ba1:	6a 00                	push   $0x0
  801ba3:	e8 0c f4 ff ff       	call   800fb4 <sys_page_map>
  801ba8:	89 c3                	mov    %eax,%ebx
  801baa:	83 c4 20             	add    $0x20,%esp
  801bad:	85 c0                	test   %eax,%eax
  801baf:	0f 88 57 03 00 00    	js     801f0c <spawn+0x55b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801bb5:	83 ec 08             	sub    $0x8,%esp
  801bb8:	68 00 00 40 00       	push   $0x400000
  801bbd:	6a 00                	push   $0x0
  801bbf:	e8 32 f4 ff ff       	call   800ff6 <sys_page_unmap>
  801bc4:	89 c3                	mov    %eax,%ebx
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	85 c0                	test   %eax,%eax
  801bcb:	0f 88 3b 03 00 00    	js     801f0c <spawn+0x55b>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bd1:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bd7:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801bde:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801be4:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801beb:	00 00 00 
  801bee:	e9 56 01 00 00       	jmp    801d49 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801bf3:	68 48 31 80 00       	push   $0x803148
  801bf8:	68 89 30 80 00       	push   $0x803089
  801bfd:	68 f2 00 00 00       	push   $0xf2
  801c02:	68 d6 30 80 00       	push   $0x8030d6
  801c07:	e8 f4 e7 ff ff       	call   800400 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	6a 07                	push   $0x7
  801c11:	68 00 00 40 00       	push   $0x400000
  801c16:	6a 00                	push   $0x0
  801c18:	e8 54 f3 ff ff       	call   800f71 <sys_page_alloc>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	85 c0                	test   %eax,%eax
  801c22:	0f 88 cf 02 00 00    	js     801ef7 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c28:	83 ec 08             	sub    $0x8,%esp
  801c2b:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c31:	01 f0                	add    %esi,%eax
  801c33:	50                   	push   %eax
  801c34:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c3a:	e8 79 f9 ff ff       	call   8015b8 <seek>
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	85 c0                	test   %eax,%eax
  801c44:	0f 88 b4 02 00 00    	js     801efe <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c53:	29 f0                	sub    %esi,%eax
  801c55:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c5f:	0f 47 c1             	cmova  %ecx,%eax
  801c62:	50                   	push   %eax
  801c63:	68 00 00 40 00       	push   $0x400000
  801c68:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c6e:	e8 7c f8 ff ff       	call   8014ef <readn>
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	85 c0                	test   %eax,%eax
  801c78:	0f 88 87 02 00 00    	js     801f05 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c7e:	83 ec 0c             	sub    $0xc,%esp
  801c81:	57                   	push   %edi
  801c82:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801c88:	56                   	push   %esi
  801c89:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801c8f:	68 00 00 40 00       	push   $0x400000
  801c94:	6a 00                	push   $0x0
  801c96:	e8 19 f3 ff ff       	call   800fb4 <sys_page_map>
  801c9b:	83 c4 20             	add    $0x20,%esp
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	0f 88 80 00 00 00    	js     801d26 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ca6:	83 ec 08             	sub    $0x8,%esp
  801ca9:	68 00 00 40 00       	push   $0x400000
  801cae:	6a 00                	push   $0x0
  801cb0:	e8 41 f3 ff ff       	call   800ff6 <sys_page_unmap>
  801cb5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cbe:	89 de                	mov    %ebx,%esi
  801cc0:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801cc6:	76 73                	jbe    801d3b <spawn+0x38a>
		if (i >= filesz) {
  801cc8:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801cce:	0f 87 38 ff ff ff    	ja     801c0c <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	57                   	push   %edi
  801cd8:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801cde:	56                   	push   %esi
  801cdf:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801ce5:	e8 87 f2 ff ff       	call   800f71 <sys_page_alloc>
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	85 c0                	test   %eax,%eax
  801cef:	79 c7                	jns    801cb8 <spawn+0x307>
  801cf1:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801cfc:	e8 f1 f1 ff ff       	call   800ef2 <sys_env_destroy>
	close(fd);
  801d01:	83 c4 04             	add    $0x4,%esp
  801d04:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801d0a:	e8 1d f6 ff ff       	call   80132c <close>
	return r;
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801d18:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801d26:	50                   	push   %eax
  801d27:	68 e2 30 80 00       	push   $0x8030e2
  801d2c:	68 25 01 00 00       	push   $0x125
  801d31:	68 d6 30 80 00       	push   $0x8030d6
  801d36:	e8 c5 e6 ff ff       	call   800400 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d3b:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801d42:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801d49:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d50:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801d56:	7e 71                	jle    801dc9 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801d58:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801d5e:	83 39 01             	cmpl   $0x1,(%ecx)
  801d61:	75 d8                	jne    801d3b <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d63:	8b 41 18             	mov    0x18(%ecx),%eax
  801d66:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d69:	83 f8 01             	cmp    $0x1,%eax
  801d6c:	19 ff                	sbb    %edi,%edi
  801d6e:	83 e7 fe             	and    $0xfffffffe,%edi
  801d71:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d74:	8b 71 04             	mov    0x4(%ecx),%esi
  801d77:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801d7d:	8b 59 10             	mov    0x10(%ecx),%ebx
  801d80:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801d86:	8b 41 14             	mov    0x14(%ecx),%eax
  801d89:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801d8f:	8b 51 08             	mov    0x8(%ecx),%edx
  801d92:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  801d98:	89 d0                	mov    %edx,%eax
  801d9a:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d9f:	74 1e                	je     801dbf <spawn+0x40e>
		va -= i;
  801da1:	29 c2                	sub    %eax,%edx
  801da3:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  801da9:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801daf:	01 c3                	add    %eax,%ebx
  801db1:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801db7:	29 c6                	sub    %eax,%esi
  801db9:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dc4:	e9 f5 fe ff ff       	jmp    801cbe <spawn+0x30d>
	close(fd);
  801dc9:	83 ec 0c             	sub    $0xc,%esp
  801dcc:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801dd2:	e8 55 f5 ff ff       	call   80132c <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	envid_t parent_envid = sys_getenvid();
  801dd7:	e8 57 f1 ff ff       	call   800f33 <sys_getenvid>
  801ddc:	89 c6                	mov    %eax,%esi
  801dde:	83 c4 10             	add    $0x10,%esp
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801de1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de6:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801dec:	eb 0e                	jmp    801dfc <spawn+0x44b>
  801dee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801df4:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801dfa:	74 62                	je     801e5e <spawn+0x4ad>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_SHARE) == PTE_SHARE) {
  801dfc:	89 d8                	mov    %ebx,%eax
  801dfe:	c1 e8 16             	shr    $0x16,%eax
  801e01:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e08:	a8 01                	test   $0x1,%al
  801e0a:	74 e2                	je     801dee <spawn+0x43d>
  801e0c:	89 d8                	mov    %ebx,%eax
  801e0e:	c1 e8 0c             	shr    $0xc,%eax
  801e11:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e18:	f6 c2 01             	test   $0x1,%dl
  801e1b:	74 d1                	je     801dee <spawn+0x43d>
  801e1d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e24:	f6 c6 04             	test   $0x4,%dh
  801e27:	74 c5                	je     801dee <spawn+0x43d>
	        if ((r = sys_page_map(parent_envid, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
  801e29:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	25 07 0e 00 00       	and    $0xe07,%eax
  801e38:	50                   	push   %eax
  801e39:	53                   	push   %ebx
  801e3a:	57                   	push   %edi
  801e3b:	53                   	push   %ebx
  801e3c:	56                   	push   %esi
  801e3d:	e8 72 f1 ff ff       	call   800fb4 <sys_page_map>
  801e42:	83 c4 20             	add    $0x20,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	74 a5                	je     801dee <spawn+0x43d>
	            panic("copy_shared_pages: %e", r);
  801e49:	50                   	push   %eax
  801e4a:	68 ff 30 80 00       	push   $0x8030ff
  801e4f:	68 38 01 00 00       	push   $0x138
  801e54:	68 d6 30 80 00       	push   $0x8030d6
  801e59:	e8 a2 e5 ff ff       	call   800400 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801e5e:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e65:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e68:	83 ec 08             	sub    $0x8,%esp
  801e6b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e71:	50                   	push   %eax
  801e72:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e78:	e8 fd f1 ff ff       	call   80107a <sys_env_set_trapframe>
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	85 c0                	test   %eax,%eax
  801e82:	78 28                	js     801eac <spawn+0x4fb>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e84:	83 ec 08             	sub    $0x8,%esp
  801e87:	6a 02                	push   $0x2
  801e89:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e8f:	e8 a4 f1 ff ff       	call   801038 <sys_env_set_status>
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	78 26                	js     801ec1 <spawn+0x510>
	return child;
  801e9b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ea1:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ea7:	e9 6c fe ff ff       	jmp    801d18 <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  801eac:	50                   	push   %eax
  801ead:	68 15 31 80 00       	push   $0x803115
  801eb2:	68 86 00 00 00       	push   $0x86
  801eb7:	68 d6 30 80 00       	push   $0x8030d6
  801ebc:	e8 3f e5 ff ff       	call   800400 <_panic>
		panic("sys_env_set_status: %e", r);
  801ec1:	50                   	push   %eax
  801ec2:	68 2f 31 80 00       	push   $0x80312f
  801ec7:	68 89 00 00 00       	push   $0x89
  801ecc:	68 d6 30 80 00       	push   $0x8030d6
  801ed1:	e8 2a e5 ff ff       	call   800400 <_panic>
		return r;
  801ed6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801edc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ee2:	e9 31 fe ff ff       	jmp    801d18 <spawn+0x367>
		return -E_NO_MEM;
  801ee7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801eec:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ef2:	e9 21 fe ff ff       	jmp    801d18 <spawn+0x367>
  801ef7:	89 c7                	mov    %eax,%edi
  801ef9:	e9 f5 fd ff ff       	jmp    801cf3 <spawn+0x342>
  801efe:	89 c7                	mov    %eax,%edi
  801f00:	e9 ee fd ff ff       	jmp    801cf3 <spawn+0x342>
  801f05:	89 c7                	mov    %eax,%edi
  801f07:	e9 e7 fd ff ff       	jmp    801cf3 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  801f0c:	83 ec 08             	sub    $0x8,%esp
  801f0f:	68 00 00 40 00       	push   $0x400000
  801f14:	6a 00                	push   $0x0
  801f16:	e8 db f0 ff ff       	call   800ff6 <sys_page_unmap>
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801f24:	e9 ef fd ff ff       	jmp    801d18 <spawn+0x367>

00801f29 <spawnl>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	57                   	push   %edi
  801f2d:	56                   	push   %esi
  801f2e:	53                   	push   %ebx
  801f2f:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801f32:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f3a:	eb 05                	jmp    801f41 <spawnl+0x18>
		argc++;
  801f3c:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f3f:	89 ca                	mov    %ecx,%edx
  801f41:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f44:	83 3a 00             	cmpl   $0x0,(%edx)
  801f47:	75 f3                	jne    801f3c <spawnl+0x13>
	const char *argv[argc+2];
  801f49:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801f50:	83 e2 f0             	and    $0xfffffff0,%edx
  801f53:	29 d4                	sub    %edx,%esp
  801f55:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f59:	c1 ea 02             	shr    $0x2,%edx
  801f5c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f63:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f68:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f6f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f76:	00 
	va_start(vl, arg0);
  801f77:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f7a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f81:	eb 0b                	jmp    801f8e <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801f83:	83 c0 01             	add    $0x1,%eax
  801f86:	8b 39                	mov    (%ecx),%edi
  801f88:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801f8b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801f8e:	39 d0                	cmp    %edx,%eax
  801f90:	75 f1                	jne    801f83 <spawnl+0x5a>
	return spawn(prog, argv);
  801f92:	83 ec 08             	sub    $0x8,%esp
  801f95:	56                   	push   %esi
  801f96:	ff 75 08             	pushl  0x8(%ebp)
  801f99:	e8 13 fa ff ff       	call   8019b1 <spawn>
}
  801f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa1:	5b                   	pop    %ebx
  801fa2:	5e                   	pop    %esi
  801fa3:	5f                   	pop    %edi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    

00801fa6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	56                   	push   %esi
  801faa:	53                   	push   %ebx
  801fab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff 75 08             	pushl  0x8(%ebp)
  801fb4:	e8 d8 f1 ff ff       	call   801191 <fd2data>
  801fb9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fbb:	83 c4 08             	add    $0x8,%esp
  801fbe:	68 70 31 80 00       	push   $0x803170
  801fc3:	53                   	push   %ebx
  801fc4:	e8 af eb ff ff       	call   800b78 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801fc9:	8b 46 04             	mov    0x4(%esi),%eax
  801fcc:	2b 06                	sub    (%esi),%eax
  801fce:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fd4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fdb:	00 00 00 
	stat->st_dev = &devpipe;
  801fde:	c7 83 88 00 00 00 ac 	movl   $0x8057ac,0x88(%ebx)
  801fe5:	57 80 00 
	return 0;
}
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5e                   	pop    %esi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    

00801ff4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ffe:	53                   	push   %ebx
  801fff:	6a 00                	push   $0x0
  802001:	e8 f0 ef ff ff       	call   800ff6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802006:	89 1c 24             	mov    %ebx,(%esp)
  802009:	e8 83 f1 ff ff       	call   801191 <fd2data>
  80200e:	83 c4 08             	add    $0x8,%esp
  802011:	50                   	push   %eax
  802012:	6a 00                	push   $0x0
  802014:	e8 dd ef ff ff       	call   800ff6 <sys_page_unmap>
}
  802019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <_pipeisclosed>:
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	57                   	push   %edi
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	83 ec 1c             	sub    $0x1c,%esp
  802027:	89 c7                	mov    %eax,%edi
  802029:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80202b:	a1 90 77 80 00       	mov    0x807790,%eax
  802030:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	57                   	push   %edi
  802037:	e8 66 08 00 00       	call   8028a2 <pageref>
  80203c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80203f:	89 34 24             	mov    %esi,(%esp)
  802042:	e8 5b 08 00 00       	call   8028a2 <pageref>
		nn = thisenv->env_runs;
  802047:	8b 15 90 77 80 00    	mov    0x807790,%edx
  80204d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	39 cb                	cmp    %ecx,%ebx
  802055:	74 1b                	je     802072 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802057:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80205a:	75 cf                	jne    80202b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80205c:	8b 42 58             	mov    0x58(%edx),%eax
  80205f:	6a 01                	push   $0x1
  802061:	50                   	push   %eax
  802062:	53                   	push   %ebx
  802063:	68 77 31 80 00       	push   $0x803177
  802068:	e8 6e e4 ff ff       	call   8004db <cprintf>
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	eb b9                	jmp    80202b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802072:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802075:	0f 94 c0             	sete   %al
  802078:	0f b6 c0             	movzbl %al,%eax
}
  80207b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80207e:	5b                   	pop    %ebx
  80207f:	5e                   	pop    %esi
  802080:	5f                   	pop    %edi
  802081:	5d                   	pop    %ebp
  802082:	c3                   	ret    

00802083 <devpipe_write>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	57                   	push   %edi
  802087:	56                   	push   %esi
  802088:	53                   	push   %ebx
  802089:	83 ec 28             	sub    $0x28,%esp
  80208c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80208f:	56                   	push   %esi
  802090:	e8 fc f0 ff ff       	call   801191 <fd2data>
  802095:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	bf 00 00 00 00       	mov    $0x0,%edi
  80209f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020a2:	74 4f                	je     8020f3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020a4:	8b 43 04             	mov    0x4(%ebx),%eax
  8020a7:	8b 0b                	mov    (%ebx),%ecx
  8020a9:	8d 51 20             	lea    0x20(%ecx),%edx
  8020ac:	39 d0                	cmp    %edx,%eax
  8020ae:	72 14                	jb     8020c4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8020b0:	89 da                	mov    %ebx,%edx
  8020b2:	89 f0                	mov    %esi,%eax
  8020b4:	e8 65 ff ff ff       	call   80201e <_pipeisclosed>
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	75 3a                	jne    8020f7 <devpipe_write+0x74>
			sys_yield();
  8020bd:	e8 90 ee ff ff       	call   800f52 <sys_yield>
  8020c2:	eb e0                	jmp    8020a4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020cb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020ce:	89 c2                	mov    %eax,%edx
  8020d0:	c1 fa 1f             	sar    $0x1f,%edx
  8020d3:	89 d1                	mov    %edx,%ecx
  8020d5:	c1 e9 1b             	shr    $0x1b,%ecx
  8020d8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020db:	83 e2 1f             	and    $0x1f,%edx
  8020de:	29 ca                	sub    %ecx,%edx
  8020e0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020e8:	83 c0 01             	add    $0x1,%eax
  8020eb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020ee:	83 c7 01             	add    $0x1,%edi
  8020f1:	eb ac                	jmp    80209f <devpipe_write+0x1c>
	return i;
  8020f3:	89 f8                	mov    %edi,%eax
  8020f5:	eb 05                	jmp    8020fc <devpipe_write+0x79>
				return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <devpipe_read>:
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	57                   	push   %edi
  802108:	56                   	push   %esi
  802109:	53                   	push   %ebx
  80210a:	83 ec 18             	sub    $0x18,%esp
  80210d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802110:	57                   	push   %edi
  802111:	e8 7b f0 ff ff       	call   801191 <fd2data>
  802116:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	be 00 00 00 00       	mov    $0x0,%esi
  802120:	3b 75 10             	cmp    0x10(%ebp),%esi
  802123:	74 47                	je     80216c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802125:	8b 03                	mov    (%ebx),%eax
  802127:	3b 43 04             	cmp    0x4(%ebx),%eax
  80212a:	75 22                	jne    80214e <devpipe_read+0x4a>
			if (i > 0)
  80212c:	85 f6                	test   %esi,%esi
  80212e:	75 14                	jne    802144 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802130:	89 da                	mov    %ebx,%edx
  802132:	89 f8                	mov    %edi,%eax
  802134:	e8 e5 fe ff ff       	call   80201e <_pipeisclosed>
  802139:	85 c0                	test   %eax,%eax
  80213b:	75 33                	jne    802170 <devpipe_read+0x6c>
			sys_yield();
  80213d:	e8 10 ee ff ff       	call   800f52 <sys_yield>
  802142:	eb e1                	jmp    802125 <devpipe_read+0x21>
				return i;
  802144:	89 f0                	mov    %esi,%eax
}
  802146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802149:	5b                   	pop    %ebx
  80214a:	5e                   	pop    %esi
  80214b:	5f                   	pop    %edi
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80214e:	99                   	cltd   
  80214f:	c1 ea 1b             	shr    $0x1b,%edx
  802152:	01 d0                	add    %edx,%eax
  802154:	83 e0 1f             	and    $0x1f,%eax
  802157:	29 d0                	sub    %edx,%eax
  802159:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80215e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802161:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802164:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802167:	83 c6 01             	add    $0x1,%esi
  80216a:	eb b4                	jmp    802120 <devpipe_read+0x1c>
	return i;
  80216c:	89 f0                	mov    %esi,%eax
  80216e:	eb d6                	jmp    802146 <devpipe_read+0x42>
				return 0;
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	eb cf                	jmp    802146 <devpipe_read+0x42>

00802177 <pipe>:
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	56                   	push   %esi
  80217b:	53                   	push   %ebx
  80217c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80217f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802182:	50                   	push   %eax
  802183:	e8 20 f0 ff ff       	call   8011a8 <fd_alloc>
  802188:	89 c3                	mov    %eax,%ebx
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	85 c0                	test   %eax,%eax
  80218f:	78 5b                	js     8021ec <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 07 04 00 00       	push   $0x407
  802199:	ff 75 f4             	pushl  -0xc(%ebp)
  80219c:	6a 00                	push   $0x0
  80219e:	e8 ce ed ff ff       	call   800f71 <sys_page_alloc>
  8021a3:	89 c3                	mov    %eax,%ebx
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	78 40                	js     8021ec <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021b2:	50                   	push   %eax
  8021b3:	e8 f0 ef ff ff       	call   8011a8 <fd_alloc>
  8021b8:	89 c3                	mov    %eax,%ebx
  8021ba:	83 c4 10             	add    $0x10,%esp
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	78 1b                	js     8021dc <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	68 07 04 00 00       	push   $0x407
  8021c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8021cc:	6a 00                	push   $0x0
  8021ce:	e8 9e ed ff ff       	call   800f71 <sys_page_alloc>
  8021d3:	89 c3                	mov    %eax,%ebx
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	79 19                	jns    8021f5 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8021dc:	83 ec 08             	sub    $0x8,%esp
  8021df:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e2:	6a 00                	push   $0x0
  8021e4:	e8 0d ee ff ff       	call   800ff6 <sys_page_unmap>
  8021e9:	83 c4 10             	add    $0x10,%esp
}
  8021ec:	89 d8                	mov    %ebx,%eax
  8021ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f1:	5b                   	pop    %ebx
  8021f2:	5e                   	pop    %esi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
	va = fd2data(fd0);
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021fb:	e8 91 ef ff ff       	call   801191 <fd2data>
  802200:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802202:	83 c4 0c             	add    $0xc,%esp
  802205:	68 07 04 00 00       	push   $0x407
  80220a:	50                   	push   %eax
  80220b:	6a 00                	push   $0x0
  80220d:	e8 5f ed ff ff       	call   800f71 <sys_page_alloc>
  802212:	89 c3                	mov    %eax,%ebx
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	85 c0                	test   %eax,%eax
  802219:	0f 88 8c 00 00 00    	js     8022ab <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221f:	83 ec 0c             	sub    $0xc,%esp
  802222:	ff 75 f0             	pushl  -0x10(%ebp)
  802225:	e8 67 ef ff ff       	call   801191 <fd2data>
  80222a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802231:	50                   	push   %eax
  802232:	6a 00                	push   $0x0
  802234:	56                   	push   %esi
  802235:	6a 00                	push   $0x0
  802237:	e8 78 ed ff ff       	call   800fb4 <sys_page_map>
  80223c:	89 c3                	mov    %eax,%ebx
  80223e:	83 c4 20             	add    $0x20,%esp
  802241:	85 c0                	test   %eax,%eax
  802243:	78 58                	js     80229d <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  80224e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80225a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225d:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  802263:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802268:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	ff 75 f4             	pushl  -0xc(%ebp)
  802275:	e8 07 ef ff ff       	call   801181 <fd2num>
  80227a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80227d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80227f:	83 c4 04             	add    $0x4,%esp
  802282:	ff 75 f0             	pushl  -0x10(%ebp)
  802285:	e8 f7 ee ff ff       	call   801181 <fd2num>
  80228a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80228d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	bb 00 00 00 00       	mov    $0x0,%ebx
  802298:	e9 4f ff ff ff       	jmp    8021ec <pipe+0x75>
	sys_page_unmap(0, va);
  80229d:	83 ec 08             	sub    $0x8,%esp
  8022a0:	56                   	push   %esi
  8022a1:	6a 00                	push   $0x0
  8022a3:	e8 4e ed ff ff       	call   800ff6 <sys_page_unmap>
  8022a8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022ab:	83 ec 08             	sub    $0x8,%esp
  8022ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8022b1:	6a 00                	push   $0x0
  8022b3:	e8 3e ed ff ff       	call   800ff6 <sys_page_unmap>
  8022b8:	83 c4 10             	add    $0x10,%esp
  8022bb:	e9 1c ff ff ff       	jmp    8021dc <pipe+0x65>

008022c0 <pipeisclosed>:
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c9:	50                   	push   %eax
  8022ca:	ff 75 08             	pushl  0x8(%ebp)
  8022cd:	e8 25 ef ff ff       	call   8011f7 <fd_lookup>
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	78 18                	js     8022f1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8022d9:	83 ec 0c             	sub    $0xc,%esp
  8022dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8022df:	e8 ad ee ff ff       	call   801191 <fd2data>
	return _pipeisclosed(fd, p);
  8022e4:	89 c2                	mov    %eax,%edx
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	e8 30 fd ff ff       	call   80201e <_pipeisclosed>
  8022ee:	83 c4 10             	add    $0x10,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8022fb:	85 f6                	test   %esi,%esi
  8022fd:	74 13                	je     802312 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8022ff:	89 f3                	mov    %esi,%ebx
  802301:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802307:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80230a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802310:	eb 1b                	jmp    80232d <wait+0x3a>
	assert(envid != 0);
  802312:	68 8f 31 80 00       	push   $0x80318f
  802317:	68 89 30 80 00       	push   $0x803089
  80231c:	6a 09                	push   $0x9
  80231e:	68 9a 31 80 00       	push   $0x80319a
  802323:	e8 d8 e0 ff ff       	call   800400 <_panic>
		sys_yield();
  802328:	e8 25 ec ff ff       	call   800f52 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80232d:	8b 43 48             	mov    0x48(%ebx),%eax
  802330:	39 f0                	cmp    %esi,%eax
  802332:	75 07                	jne    80233b <wait+0x48>
  802334:	8b 43 54             	mov    0x54(%ebx),%eax
  802337:	85 c0                	test   %eax,%eax
  802339:	75 ed                	jne    802328 <wait+0x35>
}
  80233b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233e:	5b                   	pop    %ebx
  80233f:	5e                   	pop    %esi
  802340:	5d                   	pop    %ebp
  802341:	c3                   	ret    

00802342 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802348:	68 a5 31 80 00       	push   $0x8031a5
  80234d:	ff 75 0c             	pushl  0xc(%ebp)
  802350:	e8 23 e8 ff ff       	call   800b78 <strcpy>
	return 0;
}
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <devsock_close>:
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	53                   	push   %ebx
  802360:	83 ec 10             	sub    $0x10,%esp
  802363:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802366:	53                   	push   %ebx
  802367:	e8 36 05 00 00       	call   8028a2 <pageref>
  80236c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80236f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802374:	83 f8 01             	cmp    $0x1,%eax
  802377:	74 07                	je     802380 <devsock_close+0x24>
}
  802379:	89 d0                	mov    %edx,%eax
  80237b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	ff 73 0c             	pushl  0xc(%ebx)
  802386:	e8 b7 02 00 00       	call   802642 <nsipc_close>
  80238b:	89 c2                	mov    %eax,%edx
  80238d:	83 c4 10             	add    $0x10,%esp
  802390:	eb e7                	jmp    802379 <devsock_close+0x1d>

00802392 <devsock_write>:
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802398:	6a 00                	push   $0x0
  80239a:	ff 75 10             	pushl  0x10(%ebp)
  80239d:	ff 75 0c             	pushl  0xc(%ebp)
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	ff 70 0c             	pushl  0xc(%eax)
  8023a6:	e8 74 03 00 00       	call   80271f <nsipc_send>
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <devsock_read>:
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	ff 75 10             	pushl  0x10(%ebp)
  8023b8:	ff 75 0c             	pushl  0xc(%ebp)
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	ff 70 0c             	pushl  0xc(%eax)
  8023c1:	e8 ed 02 00 00       	call   8026b3 <nsipc_recv>
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <fd2sockid>:
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8023ce:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8023d1:	52                   	push   %edx
  8023d2:	50                   	push   %eax
  8023d3:	e8 1f ee ff ff       	call   8011f7 <fd_lookup>
  8023d8:	83 c4 10             	add    $0x10,%esp
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	78 10                	js     8023ef <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 0d c8 57 80 00    	mov    0x8057c8,%ecx
  8023e8:	39 08                	cmp    %ecx,(%eax)
  8023ea:	75 05                	jne    8023f1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8023ec:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8023f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023f6:	eb f7                	jmp    8023ef <fd2sockid+0x27>

008023f8 <alloc_sockfd>:
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	83 ec 1c             	sub    $0x1c,%esp
  802400:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802405:	50                   	push   %eax
  802406:	e8 9d ed ff ff       	call   8011a8 <fd_alloc>
  80240b:	89 c3                	mov    %eax,%ebx
  80240d:	83 c4 10             	add    $0x10,%esp
  802410:	85 c0                	test   %eax,%eax
  802412:	78 43                	js     802457 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802414:	83 ec 04             	sub    $0x4,%esp
  802417:	68 07 04 00 00       	push   $0x407
  80241c:	ff 75 f4             	pushl  -0xc(%ebp)
  80241f:	6a 00                	push   $0x0
  802421:	e8 4b eb ff ff       	call   800f71 <sys_page_alloc>
  802426:	89 c3                	mov    %eax,%ebx
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	85 c0                	test   %eax,%eax
  80242d:	78 28                	js     802457 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  802438:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802444:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802447:	83 ec 0c             	sub    $0xc,%esp
  80244a:	50                   	push   %eax
  80244b:	e8 31 ed ff ff       	call   801181 <fd2num>
  802450:	89 c3                	mov    %eax,%ebx
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	eb 0c                	jmp    802463 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802457:	83 ec 0c             	sub    $0xc,%esp
  80245a:	56                   	push   %esi
  80245b:	e8 e2 01 00 00       	call   802642 <nsipc_close>
		return r;
  802460:	83 c4 10             	add    $0x10,%esp
}
  802463:	89 d8                	mov    %ebx,%eax
  802465:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802468:	5b                   	pop    %ebx
  802469:	5e                   	pop    %esi
  80246a:	5d                   	pop    %ebp
  80246b:	c3                   	ret    

0080246c <accept>:
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	e8 4e ff ff ff       	call   8023c8 <fd2sockid>
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 1b                	js     802499 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	ff 75 10             	pushl  0x10(%ebp)
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	50                   	push   %eax
  802488:	e8 0e 01 00 00       	call   80259b <nsipc_accept>
  80248d:	83 c4 10             	add    $0x10,%esp
  802490:	85 c0                	test   %eax,%eax
  802492:	78 05                	js     802499 <accept+0x2d>
	return alloc_sockfd(r);
  802494:	e8 5f ff ff ff       	call   8023f8 <alloc_sockfd>
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <bind>:
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	e8 1f ff ff ff       	call   8023c8 <fd2sockid>
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	78 12                	js     8024bf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8024ad:	83 ec 04             	sub    $0x4,%esp
  8024b0:	ff 75 10             	pushl  0x10(%ebp)
  8024b3:	ff 75 0c             	pushl  0xc(%ebp)
  8024b6:	50                   	push   %eax
  8024b7:	e8 2f 01 00 00       	call   8025eb <nsipc_bind>
  8024bc:	83 c4 10             	add    $0x10,%esp
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <shutdown>:
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	e8 f9 fe ff ff       	call   8023c8 <fd2sockid>
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	78 0f                	js     8024e2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8024d3:	83 ec 08             	sub    $0x8,%esp
  8024d6:	ff 75 0c             	pushl  0xc(%ebp)
  8024d9:	50                   	push   %eax
  8024da:	e8 41 01 00 00       	call   802620 <nsipc_shutdown>
  8024df:	83 c4 10             	add    $0x10,%esp
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <connect>:
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	e8 d6 fe ff ff       	call   8023c8 <fd2sockid>
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	78 12                	js     802508 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8024f6:	83 ec 04             	sub    $0x4,%esp
  8024f9:	ff 75 10             	pushl  0x10(%ebp)
  8024fc:	ff 75 0c             	pushl  0xc(%ebp)
  8024ff:	50                   	push   %eax
  802500:	e8 57 01 00 00       	call   80265c <nsipc_connect>
  802505:	83 c4 10             	add    $0x10,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <listen>:
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	e8 b0 fe ff ff       	call   8023c8 <fd2sockid>
  802518:	85 c0                	test   %eax,%eax
  80251a:	78 0f                	js     80252b <listen+0x21>
	return nsipc_listen(r, backlog);
  80251c:	83 ec 08             	sub    $0x8,%esp
  80251f:	ff 75 0c             	pushl  0xc(%ebp)
  802522:	50                   	push   %eax
  802523:	e8 69 01 00 00       	call   802691 <nsipc_listen>
  802528:	83 c4 10             	add    $0x10,%esp
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <socket>:

int
socket(int domain, int type, int protocol)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802533:	ff 75 10             	pushl  0x10(%ebp)
  802536:	ff 75 0c             	pushl  0xc(%ebp)
  802539:	ff 75 08             	pushl  0x8(%ebp)
  80253c:	e8 3c 02 00 00       	call   80277d <nsipc_socket>
  802541:	83 c4 10             	add    $0x10,%esp
  802544:	85 c0                	test   %eax,%eax
  802546:	78 05                	js     80254d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802548:	e8 ab fe ff ff       	call   8023f8 <alloc_sockfd>
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
  802552:	53                   	push   %ebx
  802553:	83 ec 04             	sub    $0x4,%esp
  802556:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802558:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  80255f:	74 26                	je     802587 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802561:	6a 07                	push   $0x7
  802563:	68 00 90 80 00       	push   $0x809000
  802568:	53                   	push   %ebx
  802569:	ff 35 04 60 80 00    	pushl  0x806004
  80256f:	e8 9c 02 00 00       	call   802810 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802574:	83 c4 0c             	add    $0xc,%esp
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	e8 25 02 00 00       	call   8027a7 <ipc_recv>
}
  802582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802585:	c9                   	leave  
  802586:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802587:	83 ec 0c             	sub    $0xc,%esp
  80258a:	6a 02                	push   $0x2
  80258c:	e8 d8 02 00 00       	call   802869 <ipc_find_env>
  802591:	a3 04 60 80 00       	mov    %eax,0x806004
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	eb c6                	jmp    802561 <nsipc+0x12>

0080259b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	56                   	push   %esi
  80259f:	53                   	push   %ebx
  8025a0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8025ab:	8b 06                	mov    (%esi),%eax
  8025ad:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b7:	e8 93 ff ff ff       	call   80254f <nsipc>
  8025bc:	89 c3                	mov    %eax,%ebx
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	78 20                	js     8025e2 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	ff 35 10 90 80 00    	pushl  0x809010
  8025cb:	68 00 90 80 00       	push   $0x809000
  8025d0:	ff 75 0c             	pushl  0xc(%ebp)
  8025d3:	e8 2e e7 ff ff       	call   800d06 <memmove>
		*addrlen = ret->ret_addrlen;
  8025d8:	a1 10 90 80 00       	mov    0x809010,%eax
  8025dd:	89 06                	mov    %eax,(%esi)
  8025df:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8025e2:	89 d8                	mov    %ebx,%eax
  8025e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025e7:	5b                   	pop    %ebx
  8025e8:	5e                   	pop    %esi
  8025e9:	5d                   	pop    %ebp
  8025ea:	c3                   	ret    

008025eb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	53                   	push   %ebx
  8025ef:	83 ec 08             	sub    $0x8,%esp
  8025f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025fd:	53                   	push   %ebx
  8025fe:	ff 75 0c             	pushl  0xc(%ebp)
  802601:	68 04 90 80 00       	push   $0x809004
  802606:	e8 fb e6 ff ff       	call   800d06 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80260b:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  802611:	b8 02 00 00 00       	mov    $0x2,%eax
  802616:	e8 34 ff ff ff       	call   80254f <nsipc>
}
  80261b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  80262e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802631:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  802636:	b8 03 00 00 00       	mov    $0x3,%eax
  80263b:	e8 0f ff ff ff       	call   80254f <nsipc>
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <nsipc_close>:

int
nsipc_close(int s)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  802650:	b8 04 00 00 00       	mov    $0x4,%eax
  802655:	e8 f5 fe ff ff       	call   80254f <nsipc>
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	53                   	push   %ebx
  802660:	83 ec 08             	sub    $0x8,%esp
  802663:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80266e:	53                   	push   %ebx
  80266f:	ff 75 0c             	pushl  0xc(%ebp)
  802672:	68 04 90 80 00       	push   $0x809004
  802677:	e8 8a e6 ff ff       	call   800d06 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80267c:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802682:	b8 05 00 00 00       	mov    $0x5,%eax
  802687:	e8 c3 fe ff ff       	call   80254f <nsipc>
}
  80268c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  80269f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a2:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  8026a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8026ac:	e8 9e fe ff ff       	call   80254f <nsipc>
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	56                   	push   %esi
  8026b7:	53                   	push   %ebx
  8026b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  8026c3:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  8026c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8026cc:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8026d1:	b8 07 00 00 00       	mov    $0x7,%eax
  8026d6:	e8 74 fe ff ff       	call   80254f <nsipc>
  8026db:	89 c3                	mov    %eax,%ebx
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	78 1f                	js     802700 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8026e1:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8026e6:	7f 21                	jg     802709 <nsipc_recv+0x56>
  8026e8:	39 c6                	cmp    %eax,%esi
  8026ea:	7c 1d                	jl     802709 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	50                   	push   %eax
  8026f0:	68 00 90 80 00       	push   $0x809000
  8026f5:	ff 75 0c             	pushl  0xc(%ebp)
  8026f8:	e8 09 e6 ff ff       	call   800d06 <memmove>
  8026fd:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802700:	89 d8                	mov    %ebx,%eax
  802702:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802705:	5b                   	pop    %ebx
  802706:	5e                   	pop    %esi
  802707:	5d                   	pop    %ebp
  802708:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802709:	68 b1 31 80 00       	push   $0x8031b1
  80270e:	68 89 30 80 00       	push   $0x803089
  802713:	6a 62                	push   $0x62
  802715:	68 c6 31 80 00       	push   $0x8031c6
  80271a:	e8 e1 dc ff ff       	call   800400 <_panic>

0080271f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
  802722:	53                   	push   %ebx
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  802731:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802737:	7f 2e                	jg     802767 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802739:	83 ec 04             	sub    $0x4,%esp
  80273c:	53                   	push   %ebx
  80273d:	ff 75 0c             	pushl  0xc(%ebp)
  802740:	68 0c 90 80 00       	push   $0x80900c
  802745:	e8 bc e5 ff ff       	call   800d06 <memmove>
	nsipcbuf.send.req_size = size;
  80274a:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802750:	8b 45 14             	mov    0x14(%ebp),%eax
  802753:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  802758:	b8 08 00 00 00       	mov    $0x8,%eax
  80275d:	e8 ed fd ff ff       	call   80254f <nsipc>
}
  802762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802765:	c9                   	leave  
  802766:	c3                   	ret    
	assert(size < 1600);
  802767:	68 d2 31 80 00       	push   $0x8031d2
  80276c:	68 89 30 80 00       	push   $0x803089
  802771:	6a 6d                	push   $0x6d
  802773:	68 c6 31 80 00       	push   $0x8031c6
  802778:	e8 83 dc ff ff       	call   800400 <_panic>

0080277d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  80278b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278e:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  802793:	8b 45 10             	mov    0x10(%ebp),%eax
  802796:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  80279b:	b8 09 00 00 00       	mov    $0x9,%eax
  8027a0:	e8 aa fd ff ff       	call   80254f <nsipc>
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	56                   	push   %esi
  8027ab:	53                   	push   %ebx
  8027ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8027af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8027b5:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8027b7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027bc:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8027bf:	83 ec 0c             	sub    $0xc,%esp
  8027c2:	50                   	push   %eax
  8027c3:	e8 59 e9 ff ff       	call   801121 <sys_ipc_recv>
  8027c8:	83 c4 10             	add    $0x10,%esp
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	78 2b                	js     8027fa <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8027cf:	85 f6                	test   %esi,%esi
  8027d1:	74 0a                	je     8027dd <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8027d3:	a1 90 77 80 00       	mov    0x807790,%eax
  8027d8:	8b 40 74             	mov    0x74(%eax),%eax
  8027db:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8027dd:	85 db                	test   %ebx,%ebx
  8027df:	74 0a                	je     8027eb <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8027e1:	a1 90 77 80 00       	mov    0x807790,%eax
  8027e6:	8b 40 78             	mov    0x78(%eax),%eax
  8027e9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8027eb:	a1 90 77 80 00       	mov    0x807790,%eax
  8027f0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027f6:	5b                   	pop    %ebx
  8027f7:	5e                   	pop    %esi
  8027f8:	5d                   	pop    %ebp
  8027f9:	c3                   	ret    
	    if (from_env_store != NULL) {
  8027fa:	85 f6                	test   %esi,%esi
  8027fc:	74 06                	je     802804 <ipc_recv+0x5d>
	        *from_env_store = 0;
  8027fe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802804:	85 db                	test   %ebx,%ebx
  802806:	74 eb                	je     8027f3 <ipc_recv+0x4c>
	        *perm_store = 0;
  802808:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80280e:	eb e3                	jmp    8027f3 <ipc_recv+0x4c>

00802810 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	57                   	push   %edi
  802814:	56                   	push   %esi
  802815:	53                   	push   %ebx
  802816:	83 ec 0c             	sub    $0xc,%esp
  802819:	8b 7d 08             	mov    0x8(%ebp),%edi
  80281c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80281f:	85 f6                	test   %esi,%esi
  802821:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802826:	0f 44 f0             	cmove  %eax,%esi
  802829:	eb 09                	jmp    802834 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80282b:	e8 22 e7 ff ff       	call   800f52 <sys_yield>
	} while(r != 0);
  802830:	85 db                	test   %ebx,%ebx
  802832:	74 2d                	je     802861 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802834:	ff 75 14             	pushl  0x14(%ebp)
  802837:	56                   	push   %esi
  802838:	ff 75 0c             	pushl  0xc(%ebp)
  80283b:	57                   	push   %edi
  80283c:	e8 bd e8 ff ff       	call   8010fe <sys_ipc_try_send>
  802841:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802843:	83 c4 10             	add    $0x10,%esp
  802846:	85 c0                	test   %eax,%eax
  802848:	79 e1                	jns    80282b <ipc_send+0x1b>
  80284a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80284d:	74 dc                	je     80282b <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80284f:	50                   	push   %eax
  802850:	68 de 31 80 00       	push   $0x8031de
  802855:	6a 45                	push   $0x45
  802857:	68 eb 31 80 00       	push   $0x8031eb
  80285c:	e8 9f db ff ff       	call   800400 <_panic>
}
  802861:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802864:	5b                   	pop    %ebx
  802865:	5e                   	pop    %esi
  802866:	5f                   	pop    %edi
  802867:	5d                   	pop    %ebp
  802868:	c3                   	ret    

00802869 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80286f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802874:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802877:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80287d:	8b 52 50             	mov    0x50(%edx),%edx
  802880:	39 ca                	cmp    %ecx,%edx
  802882:	74 11                	je     802895 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802884:	83 c0 01             	add    $0x1,%eax
  802887:	3d 00 04 00 00       	cmp    $0x400,%eax
  80288c:	75 e6                	jne    802874 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	eb 0b                	jmp    8028a0 <ipc_find_env+0x37>
			return envs[i].env_id;
  802895:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802898:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80289d:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028a0:	5d                   	pop    %ebp
  8028a1:	c3                   	ret    

008028a2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028a8:	89 d0                	mov    %edx,%eax
  8028aa:	c1 e8 16             	shr    $0x16,%eax
  8028ad:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028b4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028b9:	f6 c1 01             	test   $0x1,%cl
  8028bc:	74 1d                	je     8028db <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028be:	c1 ea 0c             	shr    $0xc,%edx
  8028c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028c8:	f6 c2 01             	test   $0x1,%dl
  8028cb:	74 0e                	je     8028db <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028cd:	c1 ea 0c             	shr    $0xc,%edx
  8028d0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028d7:	ef 
  8028d8:	0f b7 c0             	movzwl %ax,%eax
}
  8028db:	5d                   	pop    %ebp
  8028dc:	c3                   	ret    
  8028dd:	66 90                	xchg   %ax,%ax
  8028df:	90                   	nop

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	53                   	push   %ebx
  8028e4:	83 ec 1c             	sub    $0x1c,%esp
  8028e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028f7:	85 d2                	test   %edx,%edx
  8028f9:	75 35                	jne    802930 <__udivdi3+0x50>
  8028fb:	39 f3                	cmp    %esi,%ebx
  8028fd:	0f 87 bd 00 00 00    	ja     8029c0 <__udivdi3+0xe0>
  802903:	85 db                	test   %ebx,%ebx
  802905:	89 d9                	mov    %ebx,%ecx
  802907:	75 0b                	jne    802914 <__udivdi3+0x34>
  802909:	b8 01 00 00 00       	mov    $0x1,%eax
  80290e:	31 d2                	xor    %edx,%edx
  802910:	f7 f3                	div    %ebx
  802912:	89 c1                	mov    %eax,%ecx
  802914:	31 d2                	xor    %edx,%edx
  802916:	89 f0                	mov    %esi,%eax
  802918:	f7 f1                	div    %ecx
  80291a:	89 c6                	mov    %eax,%esi
  80291c:	89 e8                	mov    %ebp,%eax
  80291e:	89 f7                	mov    %esi,%edi
  802920:	f7 f1                	div    %ecx
  802922:	89 fa                	mov    %edi,%edx
  802924:	83 c4 1c             	add    $0x1c,%esp
  802927:	5b                   	pop    %ebx
  802928:	5e                   	pop    %esi
  802929:	5f                   	pop    %edi
  80292a:	5d                   	pop    %ebp
  80292b:	c3                   	ret    
  80292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802930:	39 f2                	cmp    %esi,%edx
  802932:	77 7c                	ja     8029b0 <__udivdi3+0xd0>
  802934:	0f bd fa             	bsr    %edx,%edi
  802937:	83 f7 1f             	xor    $0x1f,%edi
  80293a:	0f 84 98 00 00 00    	je     8029d8 <__udivdi3+0xf8>
  802940:	89 f9                	mov    %edi,%ecx
  802942:	b8 20 00 00 00       	mov    $0x20,%eax
  802947:	29 f8                	sub    %edi,%eax
  802949:	d3 e2                	shl    %cl,%edx
  80294b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80294f:	89 c1                	mov    %eax,%ecx
  802951:	89 da                	mov    %ebx,%edx
  802953:	d3 ea                	shr    %cl,%edx
  802955:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802959:	09 d1                	or     %edx,%ecx
  80295b:	89 f2                	mov    %esi,%edx
  80295d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802961:	89 f9                	mov    %edi,%ecx
  802963:	d3 e3                	shl    %cl,%ebx
  802965:	89 c1                	mov    %eax,%ecx
  802967:	d3 ea                	shr    %cl,%edx
  802969:	89 f9                	mov    %edi,%ecx
  80296b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80296f:	d3 e6                	shl    %cl,%esi
  802971:	89 eb                	mov    %ebp,%ebx
  802973:	89 c1                	mov    %eax,%ecx
  802975:	d3 eb                	shr    %cl,%ebx
  802977:	09 de                	or     %ebx,%esi
  802979:	89 f0                	mov    %esi,%eax
  80297b:	f7 74 24 08          	divl   0x8(%esp)
  80297f:	89 d6                	mov    %edx,%esi
  802981:	89 c3                	mov    %eax,%ebx
  802983:	f7 64 24 0c          	mull   0xc(%esp)
  802987:	39 d6                	cmp    %edx,%esi
  802989:	72 0c                	jb     802997 <__udivdi3+0xb7>
  80298b:	89 f9                	mov    %edi,%ecx
  80298d:	d3 e5                	shl    %cl,%ebp
  80298f:	39 c5                	cmp    %eax,%ebp
  802991:	73 5d                	jae    8029f0 <__udivdi3+0x110>
  802993:	39 d6                	cmp    %edx,%esi
  802995:	75 59                	jne    8029f0 <__udivdi3+0x110>
  802997:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80299a:	31 ff                	xor    %edi,%edi
  80299c:	89 fa                	mov    %edi,%edx
  80299e:	83 c4 1c             	add    $0x1c,%esp
  8029a1:	5b                   	pop    %ebx
  8029a2:	5e                   	pop    %esi
  8029a3:	5f                   	pop    %edi
  8029a4:	5d                   	pop    %ebp
  8029a5:	c3                   	ret    
  8029a6:	8d 76 00             	lea    0x0(%esi),%esi
  8029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8029b0:	31 ff                	xor    %edi,%edi
  8029b2:	31 c0                	xor    %eax,%eax
  8029b4:	89 fa                	mov    %edi,%edx
  8029b6:	83 c4 1c             	add    $0x1c,%esp
  8029b9:	5b                   	pop    %ebx
  8029ba:	5e                   	pop    %esi
  8029bb:	5f                   	pop    %edi
  8029bc:	5d                   	pop    %ebp
  8029bd:	c3                   	ret    
  8029be:	66 90                	xchg   %ax,%ax
  8029c0:	31 ff                	xor    %edi,%edi
  8029c2:	89 e8                	mov    %ebp,%eax
  8029c4:	89 f2                	mov    %esi,%edx
  8029c6:	f7 f3                	div    %ebx
  8029c8:	89 fa                	mov    %edi,%edx
  8029ca:	83 c4 1c             	add    $0x1c,%esp
  8029cd:	5b                   	pop    %ebx
  8029ce:	5e                   	pop    %esi
  8029cf:	5f                   	pop    %edi
  8029d0:	5d                   	pop    %ebp
  8029d1:	c3                   	ret    
  8029d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029d8:	39 f2                	cmp    %esi,%edx
  8029da:	72 06                	jb     8029e2 <__udivdi3+0x102>
  8029dc:	31 c0                	xor    %eax,%eax
  8029de:	39 eb                	cmp    %ebp,%ebx
  8029e0:	77 d2                	ja     8029b4 <__udivdi3+0xd4>
  8029e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e7:	eb cb                	jmp    8029b4 <__udivdi3+0xd4>
  8029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	89 d8                	mov    %ebx,%eax
  8029f2:	31 ff                	xor    %edi,%edi
  8029f4:	eb be                	jmp    8029b4 <__udivdi3+0xd4>
  8029f6:	66 90                	xchg   %ax,%ax
  8029f8:	66 90                	xchg   %ax,%ax
  8029fa:	66 90                	xchg   %ax,%ax
  8029fc:	66 90                	xchg   %ax,%ax
  8029fe:	66 90                	xchg   %ax,%ax

00802a00 <__umoddi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 1c             	sub    $0x1c,%esp
  802a07:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  802a0b:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a0f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a17:	85 ed                	test   %ebp,%ebp
  802a19:	89 f0                	mov    %esi,%eax
  802a1b:	89 da                	mov    %ebx,%edx
  802a1d:	75 19                	jne    802a38 <__umoddi3+0x38>
  802a1f:	39 df                	cmp    %ebx,%edi
  802a21:	0f 86 b1 00 00 00    	jbe    802ad8 <__umoddi3+0xd8>
  802a27:	f7 f7                	div    %edi
  802a29:	89 d0                	mov    %edx,%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	83 c4 1c             	add    $0x1c,%esp
  802a30:	5b                   	pop    %ebx
  802a31:	5e                   	pop    %esi
  802a32:	5f                   	pop    %edi
  802a33:	5d                   	pop    %ebp
  802a34:	c3                   	ret    
  802a35:	8d 76 00             	lea    0x0(%esi),%esi
  802a38:	39 dd                	cmp    %ebx,%ebp
  802a3a:	77 f1                	ja     802a2d <__umoddi3+0x2d>
  802a3c:	0f bd cd             	bsr    %ebp,%ecx
  802a3f:	83 f1 1f             	xor    $0x1f,%ecx
  802a42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a46:	0f 84 b4 00 00 00    	je     802b00 <__umoddi3+0x100>
  802a4c:	b8 20 00 00 00       	mov    $0x20,%eax
  802a51:	89 c2                	mov    %eax,%edx
  802a53:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a57:	29 c2                	sub    %eax,%edx
  802a59:	89 c1                	mov    %eax,%ecx
  802a5b:	89 f8                	mov    %edi,%eax
  802a5d:	d3 e5                	shl    %cl,%ebp
  802a5f:	89 d1                	mov    %edx,%ecx
  802a61:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802a65:	d3 e8                	shr    %cl,%eax
  802a67:	09 c5                	or     %eax,%ebp
  802a69:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a6d:	89 c1                	mov    %eax,%ecx
  802a6f:	d3 e7                	shl    %cl,%edi
  802a71:	89 d1                	mov    %edx,%ecx
  802a73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a77:	89 df                	mov    %ebx,%edi
  802a79:	d3 ef                	shr    %cl,%edi
  802a7b:	89 c1                	mov    %eax,%ecx
  802a7d:	89 f0                	mov    %esi,%eax
  802a7f:	d3 e3                	shl    %cl,%ebx
  802a81:	89 d1                	mov    %edx,%ecx
  802a83:	89 fa                	mov    %edi,%edx
  802a85:	d3 e8                	shr    %cl,%eax
  802a87:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a8c:	09 d8                	or     %ebx,%eax
  802a8e:	f7 f5                	div    %ebp
  802a90:	d3 e6                	shl    %cl,%esi
  802a92:	89 d1                	mov    %edx,%ecx
  802a94:	f7 64 24 08          	mull   0x8(%esp)
  802a98:	39 d1                	cmp    %edx,%ecx
  802a9a:	89 c3                	mov    %eax,%ebx
  802a9c:	89 d7                	mov    %edx,%edi
  802a9e:	72 06                	jb     802aa6 <__umoddi3+0xa6>
  802aa0:	75 0e                	jne    802ab0 <__umoddi3+0xb0>
  802aa2:	39 c6                	cmp    %eax,%esi
  802aa4:	73 0a                	jae    802ab0 <__umoddi3+0xb0>
  802aa6:	2b 44 24 08          	sub    0x8(%esp),%eax
  802aaa:	19 ea                	sbb    %ebp,%edx
  802aac:	89 d7                	mov    %edx,%edi
  802aae:	89 c3                	mov    %eax,%ebx
  802ab0:	89 ca                	mov    %ecx,%edx
  802ab2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802ab7:	29 de                	sub    %ebx,%esi
  802ab9:	19 fa                	sbb    %edi,%edx
  802abb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802abf:	89 d0                	mov    %edx,%eax
  802ac1:	d3 e0                	shl    %cl,%eax
  802ac3:	89 d9                	mov    %ebx,%ecx
  802ac5:	d3 ee                	shr    %cl,%esi
  802ac7:	d3 ea                	shr    %cl,%edx
  802ac9:	09 f0                	or     %esi,%eax
  802acb:	83 c4 1c             	add    $0x1c,%esp
  802ace:	5b                   	pop    %ebx
  802acf:	5e                   	pop    %esi
  802ad0:	5f                   	pop    %edi
  802ad1:	5d                   	pop    %ebp
  802ad2:	c3                   	ret    
  802ad3:	90                   	nop
  802ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	85 ff                	test   %edi,%edi
  802ada:	89 f9                	mov    %edi,%ecx
  802adc:	75 0b                	jne    802ae9 <__umoddi3+0xe9>
  802ade:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae3:	31 d2                	xor    %edx,%edx
  802ae5:	f7 f7                	div    %edi
  802ae7:	89 c1                	mov    %eax,%ecx
  802ae9:	89 d8                	mov    %ebx,%eax
  802aeb:	31 d2                	xor    %edx,%edx
  802aed:	f7 f1                	div    %ecx
  802aef:	89 f0                	mov    %esi,%eax
  802af1:	f7 f1                	div    %ecx
  802af3:	e9 31 ff ff ff       	jmp    802a29 <__umoddi3+0x29>
  802af8:	90                   	nop
  802af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b00:	39 dd                	cmp    %ebx,%ebp
  802b02:	72 08                	jb     802b0c <__umoddi3+0x10c>
  802b04:	39 f7                	cmp    %esi,%edi
  802b06:	0f 87 21 ff ff ff    	ja     802a2d <__umoddi3+0x2d>
  802b0c:	89 da                	mov    %ebx,%edx
  802b0e:	89 f0                	mov    %esi,%eax
  802b10:	29 f8                	sub    %edi,%eax
  802b12:	19 ea                	sbb    %ebp,%edx
  802b14:	e9 14 ff ff ff       	jmp    802a2d <__umoddi3+0x2d>
