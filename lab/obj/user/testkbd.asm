
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 33 02 00 00       	call   800264 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 c2 0e 00 00       	call   800f06 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 8d 12 00 00       	call   8012e0 <close>
	if ((r = opencons()) < 0)
  800053:	e8 ba 01 00 00       	call   800212 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 16                	js     800075 <umain+0x42>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	85 c0                	test   %eax,%eax
  800061:	74 24                	je     800087 <umain+0x54>
		panic("first opencons used fd %d", r);
  800063:	50                   	push   %eax
  800064:	68 dc 25 80 00       	push   $0x8025dc
  800069:	6a 11                	push   $0x11
  80006b:	68 cd 25 80 00       	push   $0x8025cd
  800070:	e8 4f 02 00 00       	call   8002c4 <_panic>
		panic("opencons: %e", r);
  800075:	50                   	push   %eax
  800076:	68 c0 25 80 00       	push   $0x8025c0
  80007b:	6a 0f                	push   $0xf
  80007d:	68 cd 25 80 00       	push   $0x8025cd
  800082:	e8 3d 02 00 00       	call   8002c4 <_panic>
	if ((r = dup(0, 1)) < 0)
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	6a 01                	push   $0x1
  80008c:	6a 00                	push   $0x0
  80008e:	e8 9d 12 00 00       	call   801330 <dup>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	79 24                	jns    8000be <umain+0x8b>
		panic("dup: %e", r);
  80009a:	50                   	push   %eax
  80009b:	68 f6 25 80 00       	push   $0x8025f6
  8000a0:	6a 13                	push   $0x13
  8000a2:	68 cd 25 80 00       	push   $0x8025cd
  8000a7:	e8 18 02 00 00       	call   8002c4 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	68 10 26 80 00       	push   $0x802610
  8000b4:	6a 01                	push   $0x1
  8000b6:	e8 92 19 00 00       	call   801a4d <fprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 fe 25 80 00       	push   $0x8025fe
  8000c6:	e8 3a 09 00 00       	call   800a05 <readline>
		if (buf != NULL)
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	74 da                	je     8000ac <umain+0x79>
			fprintf(1, "%s\n", buf);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	50                   	push   %eax
  8000d6:	68 0c 26 80 00       	push   $0x80260c
  8000db:	6a 01                	push   $0x1
  8000dd:	e8 6b 19 00 00       	call   801a4d <fprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb d7                	jmp    8000be <umain+0x8b>

008000e7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f7:	68 28 26 80 00       	push   $0x802628
  8000fc:	ff 75 0c             	pushl  0xc(%ebp)
  8000ff:	e8 28 0a 00 00       	call   800b2c <strcpy>
	return 0;
}
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
  800109:	c9                   	leave  
  80010a:	c3                   	ret    

0080010b <devcons_write>:
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	57                   	push   %edi
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
  800111:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800117:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80011c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800122:	eb 2f                	jmp    800153 <devcons_write+0x48>
		m = n - tot;
  800124:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800127:	29 f3                	sub    %esi,%ebx
  800129:	83 fb 7f             	cmp    $0x7f,%ebx
  80012c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800131:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	53                   	push   %ebx
  800138:	89 f0                	mov    %esi,%eax
  80013a:	03 45 0c             	add    0xc(%ebp),%eax
  80013d:	50                   	push   %eax
  80013e:	57                   	push   %edi
  80013f:	e8 76 0b 00 00       	call   800cba <memmove>
		sys_cputs(buf, m);
  800144:	83 c4 08             	add    $0x8,%esp
  800147:	53                   	push   %ebx
  800148:	57                   	push   %edi
  800149:	e8 1b 0d 00 00       	call   800e69 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80014e:	01 de                	add    %ebx,%esi
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	3b 75 10             	cmp    0x10(%ebp),%esi
  800156:	72 cc                	jb     800124 <devcons_write+0x19>
}
  800158:	89 f0                	mov    %esi,%eax
  80015a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <devcons_read>:
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80016d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800171:	75 07                	jne    80017a <devcons_read+0x18>
}
  800173:	c9                   	leave  
  800174:	c3                   	ret    
		sys_yield();
  800175:	e8 8c 0d 00 00       	call   800f06 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80017a:	e8 08 0d 00 00       	call   800e87 <sys_cgetc>
  80017f:	85 c0                	test   %eax,%eax
  800181:	74 f2                	je     800175 <devcons_read+0x13>
	if (c < 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	78 ec                	js     800173 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800187:	83 f8 04             	cmp    $0x4,%eax
  80018a:	74 0c                	je     800198 <devcons_read+0x36>
	*(char*)vbuf = c;
  80018c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018f:	88 02                	mov    %al,(%edx)
	return 1;
  800191:	b8 01 00 00 00       	mov    $0x1,%eax
  800196:	eb db                	jmp    800173 <devcons_read+0x11>
		return 0;
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	eb d4                	jmp    800173 <devcons_read+0x11>

0080019f <cputchar>:
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8001a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001ab:	6a 01                	push   $0x1
  8001ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 b3 0c 00 00       	call   800e69 <sys_cputs>
}
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <getchar>:
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001c1:	6a 01                	push   $0x1
  8001c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	6a 00                	push   $0x0
  8001c9:	e8 4e 12 00 00       	call   80141c <read>
	if (r < 0)
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 08                	js     8001dd <getchar+0x22>
	if (r < 1)
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	7e 06                	jle    8001df <getchar+0x24>
	return c;
  8001d9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    
		return -E_EOF;
  8001df:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001e4:	eb f7                	jmp    8001dd <getchar+0x22>

008001e6 <iscons>:
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	e8 b3 0f 00 00       	call   8011ab <fd_lookup>
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	85 c0                	test   %eax,%eax
  8001fd:	78 11                	js     800210 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800202:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800208:	39 10                	cmp    %edx,(%eax)
  80020a:	0f 94 c0             	sete   %al
  80020d:	0f b6 c0             	movzbl %al,%eax
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <opencons>:
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	e8 3b 0f 00 00       	call   80115c <fd_alloc>
  800221:	83 c4 10             	add    $0x10,%esp
  800224:	85 c0                	test   %eax,%eax
  800226:	78 3a                	js     800262 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	68 07 04 00 00       	push   $0x407
  800230:	ff 75 f4             	pushl  -0xc(%ebp)
  800233:	6a 00                	push   $0x0
  800235:	e8 eb 0c 00 00       	call   800f25 <sys_page_alloc>
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	85 c0                	test   %eax,%eax
  80023f:	78 21                	js     800262 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800244:	8b 15 00 30 80 00    	mov    0x803000,%edx
  80024a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80024c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80024f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	e8 d6 0e 00 00       	call   801135 <fd2num>
  80025f:	83 c4 10             	add    $0x10,%esp
}
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80026c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80026f:	e8 73 0c 00 00       	call   800ee7 <sys_getenvid>
  800274:	25 ff 03 00 00       	and    $0x3ff,%eax
  800279:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 08 44 80 00       	mov    %eax,0x804408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800286:	85 db                	test   %ebx,%ebx
  800288:	7e 07                	jle    800291 <libmain+0x2d>
		binaryname = argv[0];
  80028a:	8b 06                	mov    (%esi),%eax
  80028c:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	e8 98 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80029b:	e8 0a 00 00 00       	call   8002aa <exit>
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002a6:	5b                   	pop    %ebx
  8002a7:	5e                   	pop    %esi
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002b0:	e8 56 10 00 00       	call   80130b <close_all>
	sys_env_destroy(0);
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	6a 00                	push   $0x0
  8002ba:	e8 e7 0b 00 00       	call   800ea6 <sys_env_destroy>
}
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002c9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002cc:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002d2:	e8 10 0c 00 00       	call   800ee7 <sys_getenvid>
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 0c             	pushl  0xc(%ebp)
  8002dd:	ff 75 08             	pushl  0x8(%ebp)
  8002e0:	56                   	push   %esi
  8002e1:	50                   	push   %eax
  8002e2:	68 40 26 80 00       	push   $0x802640
  8002e7:	e8 b3 00 00 00       	call   80039f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002ec:	83 c4 18             	add    $0x18,%esp
  8002ef:	53                   	push   %ebx
  8002f0:	ff 75 10             	pushl  0x10(%ebp)
  8002f3:	e8 56 00 00 00       	call   80034e <vcprintf>
	cprintf("\n");
  8002f8:	c7 04 24 26 26 80 00 	movl   $0x802626,(%esp)
  8002ff:	e8 9b 00 00 00       	call   80039f <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800307:	cc                   	int3   
  800308:	eb fd                	jmp    800307 <_panic+0x43>

0080030a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	53                   	push   %ebx
  80030e:	83 ec 04             	sub    $0x4,%esp
  800311:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800314:	8b 13                	mov    (%ebx),%edx
  800316:	8d 42 01             	lea    0x1(%edx),%eax
  800319:	89 03                	mov    %eax,(%ebx)
  80031b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80031e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800322:	3d ff 00 00 00       	cmp    $0xff,%eax
  800327:	74 09                	je     800332 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800329:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80032d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800330:	c9                   	leave  
  800331:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	68 ff 00 00 00       	push   $0xff
  80033a:	8d 43 08             	lea    0x8(%ebx),%eax
  80033d:	50                   	push   %eax
  80033e:	e8 26 0b 00 00       	call   800e69 <sys_cputs>
		b->idx = 0;
  800343:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	eb db                	jmp    800329 <putch+0x1f>

0080034e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800357:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80035e:	00 00 00 
	b.cnt = 0;
  800361:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800368:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80036b:	ff 75 0c             	pushl  0xc(%ebp)
  80036e:	ff 75 08             	pushl  0x8(%ebp)
  800371:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800377:	50                   	push   %eax
  800378:	68 0a 03 80 00       	push   $0x80030a
  80037d:	e8 1a 01 00 00       	call   80049c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800382:	83 c4 08             	add    $0x8,%esp
  800385:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80038b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800391:	50                   	push   %eax
  800392:	e8 d2 0a 00 00       	call   800e69 <sys_cputs>

	return b.cnt;
}
  800397:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 08             	pushl  0x8(%ebp)
  8003ac:	e8 9d ff ff ff       	call   80034e <vcprintf>
	va_end(ap);

	return cnt;
}
  8003b1:	c9                   	leave  
  8003b2:	c3                   	ret    

008003b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	57                   	push   %edi
  8003b7:	56                   	push   %esi
  8003b8:	53                   	push   %ebx
  8003b9:	83 ec 1c             	sub    $0x1c,%esp
  8003bc:	89 c7                	mov    %eax,%edi
  8003be:	89 d6                	mov    %edx,%esi
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003d7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003da:	39 d3                	cmp    %edx,%ebx
  8003dc:	72 05                	jb     8003e3 <printnum+0x30>
  8003de:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003e1:	77 7a                	ja     80045d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e3:	83 ec 0c             	sub    $0xc,%esp
  8003e6:	ff 75 18             	pushl  0x18(%ebp)
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003ef:	53                   	push   %ebx
  8003f0:	ff 75 10             	pushl  0x10(%ebp)
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800402:	e8 69 1f 00 00       	call   802370 <__udivdi3>
  800407:	83 c4 18             	add    $0x18,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	89 f2                	mov    %esi,%edx
  80040e:	89 f8                	mov    %edi,%eax
  800410:	e8 9e ff ff ff       	call   8003b3 <printnum>
  800415:	83 c4 20             	add    $0x20,%esp
  800418:	eb 13                	jmp    80042d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	56                   	push   %esi
  80041e:	ff 75 18             	pushl  0x18(%ebp)
  800421:	ff d7                	call   *%edi
  800423:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800426:	83 eb 01             	sub    $0x1,%ebx
  800429:	85 db                	test   %ebx,%ebx
  80042b:	7f ed                	jg     80041a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	56                   	push   %esi
  800431:	83 ec 04             	sub    $0x4,%esp
  800434:	ff 75 e4             	pushl  -0x1c(%ebp)
  800437:	ff 75 e0             	pushl  -0x20(%ebp)
  80043a:	ff 75 dc             	pushl  -0x24(%ebp)
  80043d:	ff 75 d8             	pushl  -0x28(%ebp)
  800440:	e8 4b 20 00 00       	call   802490 <__umoddi3>
  800445:	83 c4 14             	add    $0x14,%esp
  800448:	0f be 80 63 26 80 00 	movsbl 0x802663(%eax),%eax
  80044f:	50                   	push   %eax
  800450:	ff d7                	call   *%edi
}
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800458:	5b                   	pop    %ebx
  800459:	5e                   	pop    %esi
  80045a:	5f                   	pop    %edi
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    
  80045d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800460:	eb c4                	jmp    800426 <printnum+0x73>

00800462 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800468:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046c:	8b 10                	mov    (%eax),%edx
  80046e:	3b 50 04             	cmp    0x4(%eax),%edx
  800471:	73 0a                	jae    80047d <sprintputch+0x1b>
		*b->buf++ = ch;
  800473:	8d 4a 01             	lea    0x1(%edx),%ecx
  800476:	89 08                	mov    %ecx,(%eax)
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	88 02                	mov    %al,(%edx)
}
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <printfmt>:
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800485:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800488:	50                   	push   %eax
  800489:	ff 75 10             	pushl  0x10(%ebp)
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	ff 75 08             	pushl  0x8(%ebp)
  800492:	e8 05 00 00 00       	call   80049c <vprintfmt>
}
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    

0080049c <vprintfmt>:
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	57                   	push   %edi
  8004a0:	56                   	push   %esi
  8004a1:	53                   	push   %ebx
  8004a2:	83 ec 2c             	sub    $0x2c,%esp
  8004a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ab:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004ae:	e9 21 04 00 00       	jmp    8008d4 <vprintfmt+0x438>
		padc = ' ';
  8004b3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004b7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004be:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d1:	8d 47 01             	lea    0x1(%edi),%eax
  8004d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004d7:	0f b6 17             	movzbl (%edi),%edx
  8004da:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004dd:	3c 55                	cmp    $0x55,%al
  8004df:	0f 87 90 04 00 00    	ja     800975 <vprintfmt+0x4d9>
  8004e5:	0f b6 c0             	movzbl %al,%eax
  8004e8:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  8004ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004f2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004f6:	eb d9                	jmp    8004d1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004fb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004ff:	eb d0                	jmp    8004d1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800501:	0f b6 d2             	movzbl %dl,%edx
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
  80050c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80050f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800512:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800516:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800519:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80051c:	83 f9 09             	cmp    $0x9,%ecx
  80051f:	77 55                	ja     800576 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800521:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800524:	eb e9                	jmp    80050f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 40 04             	lea    0x4(%eax),%eax
  800534:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80053a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053e:	79 91                	jns    8004d1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800540:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800546:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80054d:	eb 82                	jmp    8004d1 <vprintfmt+0x35>
  80054f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800552:	85 c0                	test   %eax,%eax
  800554:	ba 00 00 00 00       	mov    $0x0,%edx
  800559:	0f 49 d0             	cmovns %eax,%edx
  80055c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80055f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800562:	e9 6a ff ff ff       	jmp    8004d1 <vprintfmt+0x35>
  800567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80056a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800571:	e9 5b ff ff ff       	jmp    8004d1 <vprintfmt+0x35>
  800576:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800579:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80057c:	eb bc                	jmp    80053a <vprintfmt+0x9e>
			lflag++;
  80057e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800581:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800584:	e9 48 ff ff ff       	jmp    8004d1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8d 78 04             	lea    0x4(%eax),%edi
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	53                   	push   %ebx
  800593:	ff 30                	pushl  (%eax)
  800595:	ff d6                	call   *%esi
			break;
  800597:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80059a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80059d:	e9 2f 03 00 00       	jmp    8008d1 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 78 04             	lea    0x4(%eax),%edi
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	99                   	cltd   
  8005ab:	31 d0                	xor    %edx,%eax
  8005ad:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005af:	83 f8 0f             	cmp    $0xf,%eax
  8005b2:	7f 23                	jg     8005d7 <vprintfmt+0x13b>
  8005b4:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  8005bb:	85 d2                	test   %edx,%edx
  8005bd:	74 18                	je     8005d7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005bf:	52                   	push   %edx
  8005c0:	68 6e 2a 80 00       	push   $0x802a6e
  8005c5:	53                   	push   %ebx
  8005c6:	56                   	push   %esi
  8005c7:	e8 b3 fe ff ff       	call   80047f <printfmt>
  8005cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005cf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005d2:	e9 fa 02 00 00       	jmp    8008d1 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8005d7:	50                   	push   %eax
  8005d8:	68 7b 26 80 00       	push   $0x80267b
  8005dd:	53                   	push   %ebx
  8005de:	56                   	push   %esi
  8005df:	e8 9b fe ff ff       	call   80047f <printfmt>
  8005e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005ea:	e9 e2 02 00 00       	jmp    8008d1 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	83 c0 04             	add    $0x4,%eax
  8005f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005fd:	85 ff                	test   %edi,%edi
  8005ff:	b8 74 26 80 00       	mov    $0x802674,%eax
  800604:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800607:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80060b:	0f 8e bd 00 00 00    	jle    8006ce <vprintfmt+0x232>
  800611:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800615:	75 0e                	jne    800625 <vprintfmt+0x189>
  800617:	89 75 08             	mov    %esi,0x8(%ebp)
  80061a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80061d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800620:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800623:	eb 6d                	jmp    800692 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 d0             	pushl  -0x30(%ebp)
  80062b:	57                   	push   %edi
  80062c:	e8 dc 04 00 00       	call   800b0d <strnlen>
  800631:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800634:	29 c1                	sub    %eax,%ecx
  800636:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80063c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800643:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800646:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	eb 0f                	jmp    800659 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	ff 75 e0             	pushl  -0x20(%ebp)
  800651:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800653:	83 ef 01             	sub    $0x1,%edi
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	85 ff                	test   %edi,%edi
  80065b:	7f ed                	jg     80064a <vprintfmt+0x1ae>
  80065d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800660:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800663:	85 c9                	test   %ecx,%ecx
  800665:	b8 00 00 00 00       	mov    $0x0,%eax
  80066a:	0f 49 c1             	cmovns %ecx,%eax
  80066d:	29 c1                	sub    %eax,%ecx
  80066f:	89 75 08             	mov    %esi,0x8(%ebp)
  800672:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800675:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800678:	89 cb                	mov    %ecx,%ebx
  80067a:	eb 16                	jmp    800692 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80067c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800680:	75 31                	jne    8006b3 <vprintfmt+0x217>
					putch(ch, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	50                   	push   %eax
  800689:	ff 55 08             	call   *0x8(%ebp)
  80068c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068f:	83 eb 01             	sub    $0x1,%ebx
  800692:	83 c7 01             	add    $0x1,%edi
  800695:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800699:	0f be c2             	movsbl %dl,%eax
  80069c:	85 c0                	test   %eax,%eax
  80069e:	74 59                	je     8006f9 <vprintfmt+0x25d>
  8006a0:	85 f6                	test   %esi,%esi
  8006a2:	78 d8                	js     80067c <vprintfmt+0x1e0>
  8006a4:	83 ee 01             	sub    $0x1,%esi
  8006a7:	79 d3                	jns    80067c <vprintfmt+0x1e0>
  8006a9:	89 df                	mov    %ebx,%edi
  8006ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006b1:	eb 37                	jmp    8006ea <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b3:	0f be d2             	movsbl %dl,%edx
  8006b6:	83 ea 20             	sub    $0x20,%edx
  8006b9:	83 fa 5e             	cmp    $0x5e,%edx
  8006bc:	76 c4                	jbe    800682 <vprintfmt+0x1e6>
					putch('?', putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 0c             	pushl  0xc(%ebp)
  8006c4:	6a 3f                	push   $0x3f
  8006c6:	ff 55 08             	call   *0x8(%ebp)
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	eb c1                	jmp    80068f <vprintfmt+0x1f3>
  8006ce:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006d7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006da:	eb b6                	jmp    800692 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	53                   	push   %ebx
  8006e0:	6a 20                	push   $0x20
  8006e2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006e4:	83 ef 01             	sub    $0x1,%edi
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	85 ff                	test   %edi,%edi
  8006ec:	7f ee                	jg     8006dc <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	e9 d8 01 00 00       	jmp    8008d1 <vprintfmt+0x435>
  8006f9:	89 df                	mov    %ebx,%edi
  8006fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800701:	eb e7                	jmp    8006ea <vprintfmt+0x24e>
	if (lflag >= 2)
  800703:	83 f9 01             	cmp    $0x1,%ecx
  800706:	7e 45                	jle    80074d <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 50 04             	mov    0x4(%eax),%edx
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800713:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 40 08             	lea    0x8(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80071f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800723:	79 62                	jns    800787 <vprintfmt+0x2eb>
				putch('-', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	6a 2d                	push   $0x2d
  80072b:	ff d6                	call   *%esi
				num = -(long long) num;
  80072d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800730:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800733:	f7 d8                	neg    %eax
  800735:	83 d2 00             	adc    $0x0,%edx
  800738:	f7 da                	neg    %edx
  80073a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800740:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800743:	ba 0a 00 00 00       	mov    $0xa,%edx
  800748:	e9 66 01 00 00       	jmp    8008b3 <vprintfmt+0x417>
	else if (lflag)
  80074d:	85 c9                	test   %ecx,%ecx
  80074f:	75 1b                	jne    80076c <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 c1                	mov    %eax,%ecx
  80075b:	c1 f9 1f             	sar    $0x1f,%ecx
  80075e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
  80076a:	eb b3                	jmp    80071f <vprintfmt+0x283>
		return va_arg(*ap, long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 c1                	mov    %eax,%ecx
  800776:	c1 f9 1f             	sar    $0x1f,%ecx
  800779:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8d 40 04             	lea    0x4(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
  800785:	eb 98                	jmp    80071f <vprintfmt+0x283>
			base = 10;
  800787:	ba 0a 00 00 00       	mov    $0xa,%edx
  80078c:	e9 22 01 00 00       	jmp    8008b3 <vprintfmt+0x417>
	if (lflag >= 2)
  800791:	83 f9 01             	cmp    $0x1,%ecx
  800794:	7e 21                	jle    8007b7 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 50 04             	mov    0x4(%eax),%edx
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 08             	lea    0x8(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ad:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007b2:	e9 fc 00 00 00       	jmp    8008b3 <vprintfmt+0x417>
	else if (lflag)
  8007b7:	85 c9                	test   %ecx,%ecx
  8007b9:	75 23                	jne    8007de <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007d9:	e9 d5 00 00 00       	jmp    8008b3 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 40 04             	lea    0x4(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007fc:	e9 b2 00 00 00       	jmp    8008b3 <vprintfmt+0x417>
	if (lflag >= 2)
  800801:	83 f9 01             	cmp    $0x1,%ecx
  800804:	7e 42                	jle    800848 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 50 04             	mov    0x4(%eax),%edx
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800811:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 08             	lea    0x8(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80081d:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800822:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800826:	0f 89 87 00 00 00    	jns    8008b3 <vprintfmt+0x417>
				putch('-', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	6a 2d                	push   $0x2d
  800832:	ff d6                	call   *%esi
				num = -(long long) num;
  800834:	f7 5d d8             	negl   -0x28(%ebp)
  800837:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80083b:	f7 5d dc             	negl   -0x24(%ebp)
  80083e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800841:	ba 08 00 00 00       	mov    $0x8,%edx
  800846:	eb 6b                	jmp    8008b3 <vprintfmt+0x417>
	else if (lflag)
  800848:	85 c9                	test   %ecx,%ecx
  80084a:	75 1b                	jne    800867 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	ba 00 00 00 00       	mov    $0x0,%edx
  800856:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800859:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 40 04             	lea    0x4(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
  800865:	eb b6                	jmp    80081d <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	ba 00 00 00 00       	mov    $0x0,%edx
  800871:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800874:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8d 40 04             	lea    0x4(%eax),%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	eb 9b                	jmp    80081d <vprintfmt+0x381>
			putch('0', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	6a 30                	push   $0x30
  800888:	ff d6                	call   *%esi
			putch('x', putdat);
  80088a:	83 c4 08             	add    $0x8,%esp
  80088d:	53                   	push   %ebx
  80088e:	6a 78                	push   $0x78
  800890:	ff d6                	call   *%esi
			num = (unsigned long long)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008a2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 40 04             	lea    0x4(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ae:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8008b3:	83 ec 0c             	sub    $0xc,%esp
  8008b6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8008be:	52                   	push   %edx
  8008bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8008c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8008c5:	89 da                	mov    %ebx,%edx
  8008c7:	89 f0                	mov    %esi,%eax
  8008c9:	e8 e5 fa ff ff       	call   8003b3 <printnum>
			break;
  8008ce:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d4:	83 c7 01             	add    $0x1,%edi
  8008d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008db:	83 f8 25             	cmp    $0x25,%eax
  8008de:	0f 84 cf fb ff ff    	je     8004b3 <vprintfmt+0x17>
			if (ch == '\0')
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	0f 84 a9 00 00 00    	je     800995 <vprintfmt+0x4f9>
			putch(ch, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	53                   	push   %ebx
  8008f0:	50                   	push   %eax
  8008f1:	ff d6                	call   *%esi
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	eb dc                	jmp    8008d4 <vprintfmt+0x438>
	if (lflag >= 2)
  8008f8:	83 f9 01             	cmp    $0x1,%ecx
  8008fb:	7e 1e                	jle    80091b <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	8b 50 04             	mov    0x4(%eax),%edx
  800903:	8b 00                	mov    (%eax),%eax
  800905:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800908:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8d 40 08             	lea    0x8(%eax),%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800914:	ba 10 00 00 00       	mov    $0x10,%edx
  800919:	eb 98                	jmp    8008b3 <vprintfmt+0x417>
	else if (lflag)
  80091b:	85 c9                	test   %ecx,%ecx
  80091d:	75 23                	jne    800942 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
  800929:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8d 40 04             	lea    0x4(%eax),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800938:	ba 10 00 00 00       	mov    $0x10,%edx
  80093d:	e9 71 ff ff ff       	jmp    8008b3 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	ba 00 00 00 00       	mov    $0x0,%edx
  80094c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8d 40 04             	lea    0x4(%eax),%eax
  800958:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095b:	ba 10 00 00 00       	mov    $0x10,%edx
  800960:	e9 4e ff ff ff       	jmp    8008b3 <vprintfmt+0x417>
			putch(ch, putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	6a 25                	push   $0x25
  80096b:	ff d6                	call   *%esi
			break;
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	e9 5c ff ff ff       	jmp    8008d1 <vprintfmt+0x435>
			putch('%', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	53                   	push   %ebx
  800979:	6a 25                	push   $0x25
  80097b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	89 f8                	mov    %edi,%eax
  800982:	eb 03                	jmp    800987 <vprintfmt+0x4eb>
  800984:	83 e8 01             	sub    $0x1,%eax
  800987:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80098b:	75 f7                	jne    800984 <vprintfmt+0x4e8>
  80098d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800990:	e9 3c ff ff ff       	jmp    8008d1 <vprintfmt+0x435>
}
  800995:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5f                   	pop    %edi
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 18             	sub    $0x18,%esp
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ac:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	74 26                	je     8009e4 <vsnprintf+0x47>
  8009be:	85 d2                	test   %edx,%edx
  8009c0:	7e 22                	jle    8009e4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c2:	ff 75 14             	pushl  0x14(%ebp)
  8009c5:	ff 75 10             	pushl  0x10(%ebp)
  8009c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 62 04 80 00       	push   $0x800462
  8009d1:	e8 c6 fa ff ff       	call   80049c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009df:	83 c4 10             	add    $0x10,%esp
}
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    
		return -E_INVAL;
  8009e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e9:	eb f7                	jmp    8009e2 <vsnprintf+0x45>

008009eb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f4:	50                   	push   %eax
  8009f5:	ff 75 10             	pushl  0x10(%ebp)
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	ff 75 08             	pushl  0x8(%ebp)
  8009fe:	e8 9a ff ff ff       	call   80099d <vsnprintf>
	va_end(ap);

	return rc;
}
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	57                   	push   %edi
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	83 ec 0c             	sub    $0xc,%esp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a11:	85 c0                	test   %eax,%eax
  800a13:	74 13                	je     800a28 <readline+0x23>
		fprintf(1, "%s", prompt);
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	50                   	push   %eax
  800a19:	68 6e 2a 80 00       	push   $0x802a6e
  800a1e:	6a 01                	push   $0x1
  800a20:	e8 28 10 00 00       	call   801a4d <fprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	6a 00                	push   $0x0
  800a2d:	e8 b4 f7 ff ff       	call   8001e6 <iscons>
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800a37:	be 00 00 00 00       	mov    $0x0,%esi
  800a3c:	eb 4b                	jmp    800a89 <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800a3e:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800a43:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800a46:	75 08                	jne    800a50 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5f                   	pop    %edi
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	53                   	push   %ebx
  800a54:	68 5f 29 80 00       	push   $0x80295f
  800a59:	e8 41 f9 ff ff       	call   80039f <cprintf>
  800a5e:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
  800a66:	eb e0                	jmp    800a48 <readline+0x43>
			if (echoing)
  800a68:	85 ff                	test   %edi,%edi
  800a6a:	75 05                	jne    800a71 <readline+0x6c>
			i--;
  800a6c:	83 ee 01             	sub    $0x1,%esi
  800a6f:	eb 18                	jmp    800a89 <readline+0x84>
				cputchar('\b');
  800a71:	83 ec 0c             	sub    $0xc,%esp
  800a74:	6a 08                	push   $0x8
  800a76:	e8 24 f7 ff ff       	call   80019f <cputchar>
  800a7b:	83 c4 10             	add    $0x10,%esp
  800a7e:	eb ec                	jmp    800a6c <readline+0x67>
			buf[i++] = c;
  800a80:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800a86:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800a89:	e8 2d f7 ff ff       	call   8001bb <getchar>
  800a8e:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a90:	85 c0                	test   %eax,%eax
  800a92:	78 aa                	js     800a3e <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a94:	83 f8 08             	cmp    $0x8,%eax
  800a97:	0f 94 c2             	sete   %dl
  800a9a:	83 f8 7f             	cmp    $0x7f,%eax
  800a9d:	0f 94 c0             	sete   %al
  800aa0:	08 c2                	or     %al,%dl
  800aa2:	74 04                	je     800aa8 <readline+0xa3>
  800aa4:	85 f6                	test   %esi,%esi
  800aa6:	7f c0                	jg     800a68 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aa8:	83 fb 1f             	cmp    $0x1f,%ebx
  800aab:	7e 1a                	jle    800ac7 <readline+0xc2>
  800aad:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800ab3:	7f 12                	jg     800ac7 <readline+0xc2>
			if (echoing)
  800ab5:	85 ff                	test   %edi,%edi
  800ab7:	74 c7                	je     800a80 <readline+0x7b>
				cputchar(c);
  800ab9:	83 ec 0c             	sub    $0xc,%esp
  800abc:	53                   	push   %ebx
  800abd:	e8 dd f6 ff ff       	call   80019f <cputchar>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	eb b9                	jmp    800a80 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800ac7:	83 fb 0a             	cmp    $0xa,%ebx
  800aca:	74 05                	je     800ad1 <readline+0xcc>
  800acc:	83 fb 0d             	cmp    $0xd,%ebx
  800acf:	75 b8                	jne    800a89 <readline+0x84>
			if (echoing)
  800ad1:	85 ff                	test   %edi,%edi
  800ad3:	75 11                	jne    800ae6 <readline+0xe1>
			buf[i] = 0;
  800ad5:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800adc:	b8 00 40 80 00       	mov    $0x804000,%eax
  800ae1:	e9 62 ff ff ff       	jmp    800a48 <readline+0x43>
				cputchar('\n');
  800ae6:	83 ec 0c             	sub    $0xc,%esp
  800ae9:	6a 0a                	push   $0xa
  800aeb:	e8 af f6 ff ff       	call   80019f <cputchar>
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	eb e0                	jmp    800ad5 <readline+0xd0>

00800af5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
  800b00:	eb 03                	jmp    800b05 <strlen+0x10>
		n++;
  800b02:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800b05:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b09:	75 f7                	jne    800b02 <strlen+0xd>
	return n;
}
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b13:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b16:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1b:	eb 03                	jmp    800b20 <strnlen+0x13>
		n++;
  800b1d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b20:	39 d0                	cmp    %edx,%eax
  800b22:	74 06                	je     800b2a <strnlen+0x1d>
  800b24:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b28:	75 f3                	jne    800b1d <strnlen+0x10>
	return n;
}
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	53                   	push   %ebx
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b36:	89 c2                	mov    %eax,%edx
  800b38:	83 c1 01             	add    $0x1,%ecx
  800b3b:	83 c2 01             	add    $0x1,%edx
  800b3e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b42:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b45:	84 db                	test   %bl,%bl
  800b47:	75 ef                	jne    800b38 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	53                   	push   %ebx
  800b50:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b53:	53                   	push   %ebx
  800b54:	e8 9c ff ff ff       	call   800af5 <strlen>
  800b59:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	01 d8                	add    %ebx,%eax
  800b61:	50                   	push   %eax
  800b62:	e8 c5 ff ff ff       	call   800b2c <strcpy>
	return dst;
}
  800b67:	89 d8                	mov    %ebx,%eax
  800b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
  800b73:	8b 75 08             	mov    0x8(%ebp),%esi
  800b76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b79:	89 f3                	mov    %esi,%ebx
  800b7b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b7e:	89 f2                	mov    %esi,%edx
  800b80:	eb 0f                	jmp    800b91 <strncpy+0x23>
		*dst++ = *src;
  800b82:	83 c2 01             	add    $0x1,%edx
  800b85:	0f b6 01             	movzbl (%ecx),%eax
  800b88:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b8b:	80 39 01             	cmpb   $0x1,(%ecx)
  800b8e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b91:	39 da                	cmp    %ebx,%edx
  800b93:	75 ed                	jne    800b82 <strncpy+0x14>
	}
	return ret;
}
  800b95:	89 f0                	mov    %esi,%eax
  800b97:	5b                   	pop    %ebx
  800b98:	5e                   	pop    %esi
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
  800ba0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ba9:	89 f0                	mov    %esi,%eax
  800bab:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800baf:	85 c9                	test   %ecx,%ecx
  800bb1:	75 0b                	jne    800bbe <strlcpy+0x23>
  800bb3:	eb 17                	jmp    800bcc <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800bb5:	83 c2 01             	add    $0x1,%edx
  800bb8:	83 c0 01             	add    $0x1,%eax
  800bbb:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800bbe:	39 d8                	cmp    %ebx,%eax
  800bc0:	74 07                	je     800bc9 <strlcpy+0x2e>
  800bc2:	0f b6 0a             	movzbl (%edx),%ecx
  800bc5:	84 c9                	test   %cl,%cl
  800bc7:	75 ec                	jne    800bb5 <strlcpy+0x1a>
		*dst = '\0';
  800bc9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bcc:	29 f0                	sub    %esi,%eax
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bdb:	eb 06                	jmp    800be3 <strcmp+0x11>
		p++, q++;
  800bdd:	83 c1 01             	add    $0x1,%ecx
  800be0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800be3:	0f b6 01             	movzbl (%ecx),%eax
  800be6:	84 c0                	test   %al,%al
  800be8:	74 04                	je     800bee <strcmp+0x1c>
  800bea:	3a 02                	cmp    (%edx),%al
  800bec:	74 ef                	je     800bdd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bee:	0f b6 c0             	movzbl %al,%eax
  800bf1:	0f b6 12             	movzbl (%edx),%edx
  800bf4:	29 d0                	sub    %edx,%eax
}
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	53                   	push   %ebx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c02:	89 c3                	mov    %eax,%ebx
  800c04:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c07:	eb 06                	jmp    800c0f <strncmp+0x17>
		n--, p++, q++;
  800c09:	83 c0 01             	add    $0x1,%eax
  800c0c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c0f:	39 d8                	cmp    %ebx,%eax
  800c11:	74 16                	je     800c29 <strncmp+0x31>
  800c13:	0f b6 08             	movzbl (%eax),%ecx
  800c16:	84 c9                	test   %cl,%cl
  800c18:	74 04                	je     800c1e <strncmp+0x26>
  800c1a:	3a 0a                	cmp    (%edx),%cl
  800c1c:	74 eb                	je     800c09 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1e:	0f b6 00             	movzbl (%eax),%eax
  800c21:	0f b6 12             	movzbl (%edx),%edx
  800c24:	29 d0                	sub    %edx,%eax
}
  800c26:	5b                   	pop    %ebx
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    
		return 0;
  800c29:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2e:	eb f6                	jmp    800c26 <strncmp+0x2e>

00800c30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c3a:	0f b6 10             	movzbl (%eax),%edx
  800c3d:	84 d2                	test   %dl,%dl
  800c3f:	74 09                	je     800c4a <strchr+0x1a>
		if (*s == c)
  800c41:	38 ca                	cmp    %cl,%dl
  800c43:	74 0a                	je     800c4f <strchr+0x1f>
	for (; *s; s++)
  800c45:	83 c0 01             	add    $0x1,%eax
  800c48:	eb f0                	jmp    800c3a <strchr+0xa>
			return (char *) s;
	return 0;
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c5b:	eb 03                	jmp    800c60 <strfind+0xf>
  800c5d:	83 c0 01             	add    $0x1,%eax
  800c60:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c63:	38 ca                	cmp    %cl,%dl
  800c65:	74 04                	je     800c6b <strfind+0x1a>
  800c67:	84 d2                	test   %dl,%dl
  800c69:	75 f2                	jne    800c5d <strfind+0xc>
			break;
	return (char *) s;
}
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c79:	85 c9                	test   %ecx,%ecx
  800c7b:	74 13                	je     800c90 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c7d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c83:	75 05                	jne    800c8a <memset+0x1d>
  800c85:	f6 c1 03             	test   $0x3,%cl
  800c88:	74 0d                	je     800c97 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	fc                   	cld    
  800c8e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c90:	89 f8                	mov    %edi,%eax
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    
		c &= 0xFF;
  800c97:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c9b:	89 d3                	mov    %edx,%ebx
  800c9d:	c1 e3 08             	shl    $0x8,%ebx
  800ca0:	89 d0                	mov    %edx,%eax
  800ca2:	c1 e0 18             	shl    $0x18,%eax
  800ca5:	89 d6                	mov    %edx,%esi
  800ca7:	c1 e6 10             	shl    $0x10,%esi
  800caa:	09 f0                	or     %esi,%eax
  800cac:	09 c2                	or     %eax,%edx
  800cae:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800cb0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cb3:	89 d0                	mov    %edx,%eax
  800cb5:	fc                   	cld    
  800cb6:	f3 ab                	rep stos %eax,%es:(%edi)
  800cb8:	eb d6                	jmp    800c90 <memset+0x23>

00800cba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc8:	39 c6                	cmp    %eax,%esi
  800cca:	73 35                	jae    800d01 <memmove+0x47>
  800ccc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ccf:	39 c2                	cmp    %eax,%edx
  800cd1:	76 2e                	jbe    800d01 <memmove+0x47>
		s += n;
		d += n;
  800cd3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd6:	89 d6                	mov    %edx,%esi
  800cd8:	09 fe                	or     %edi,%esi
  800cda:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ce0:	74 0c                	je     800cee <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ce2:	83 ef 01             	sub    $0x1,%edi
  800ce5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ce8:	fd                   	std    
  800ce9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ceb:	fc                   	cld    
  800cec:	eb 21                	jmp    800d0f <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cee:	f6 c1 03             	test   $0x3,%cl
  800cf1:	75 ef                	jne    800ce2 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cf3:	83 ef 04             	sub    $0x4,%edi
  800cf6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cf9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cfc:	fd                   	std    
  800cfd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cff:	eb ea                	jmp    800ceb <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d01:	89 f2                	mov    %esi,%edx
  800d03:	09 c2                	or     %eax,%edx
  800d05:	f6 c2 03             	test   $0x3,%dl
  800d08:	74 09                	je     800d13 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d0a:	89 c7                	mov    %eax,%edi
  800d0c:	fc                   	cld    
  800d0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d13:	f6 c1 03             	test   $0x3,%cl
  800d16:	75 f2                	jne    800d0a <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d18:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d1b:	89 c7                	mov    %eax,%edi
  800d1d:	fc                   	cld    
  800d1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d20:	eb ed                	jmp    800d0f <memmove+0x55>

00800d22 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800d25:	ff 75 10             	pushl  0x10(%ebp)
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 87 ff ff ff       	call   800cba <memmove>
}
  800d33:	c9                   	leave  
  800d34:	c3                   	ret    

00800d35 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d40:	89 c6                	mov    %eax,%esi
  800d42:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d45:	39 f0                	cmp    %esi,%eax
  800d47:	74 1c                	je     800d65 <memcmp+0x30>
		if (*s1 != *s2)
  800d49:	0f b6 08             	movzbl (%eax),%ecx
  800d4c:	0f b6 1a             	movzbl (%edx),%ebx
  800d4f:	38 d9                	cmp    %bl,%cl
  800d51:	75 08                	jne    800d5b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d53:	83 c0 01             	add    $0x1,%eax
  800d56:	83 c2 01             	add    $0x1,%edx
  800d59:	eb ea                	jmp    800d45 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d5b:	0f b6 c1             	movzbl %cl,%eax
  800d5e:	0f b6 db             	movzbl %bl,%ebx
  800d61:	29 d8                	sub    %ebx,%eax
  800d63:	eb 05                	jmp    800d6a <memcmp+0x35>
	}

	return 0;
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d77:	89 c2                	mov    %eax,%edx
  800d79:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d7c:	39 d0                	cmp    %edx,%eax
  800d7e:	73 09                	jae    800d89 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d80:	38 08                	cmp    %cl,(%eax)
  800d82:	74 05                	je     800d89 <memfind+0x1b>
	for (; s < ends; s++)
  800d84:	83 c0 01             	add    $0x1,%eax
  800d87:	eb f3                	jmp    800d7c <memfind+0xe>
			break;
	return (void *) s;
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d97:	eb 03                	jmp    800d9c <strtol+0x11>
		s++;
  800d99:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d9c:	0f b6 01             	movzbl (%ecx),%eax
  800d9f:	3c 20                	cmp    $0x20,%al
  800da1:	74 f6                	je     800d99 <strtol+0xe>
  800da3:	3c 09                	cmp    $0x9,%al
  800da5:	74 f2                	je     800d99 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800da7:	3c 2b                	cmp    $0x2b,%al
  800da9:	74 2e                	je     800dd9 <strtol+0x4e>
	int neg = 0;
  800dab:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800db0:	3c 2d                	cmp    $0x2d,%al
  800db2:	74 2f                	je     800de3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dba:	75 05                	jne    800dc1 <strtol+0x36>
  800dbc:	80 39 30             	cmpb   $0x30,(%ecx)
  800dbf:	74 2c                	je     800ded <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dc1:	85 db                	test   %ebx,%ebx
  800dc3:	75 0a                	jne    800dcf <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dc5:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800dca:	80 39 30             	cmpb   $0x30,(%ecx)
  800dcd:	74 28                	je     800df7 <strtol+0x6c>
		base = 10;
  800dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dd7:	eb 50                	jmp    800e29 <strtol+0x9e>
		s++;
  800dd9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ddc:	bf 00 00 00 00       	mov    $0x0,%edi
  800de1:	eb d1                	jmp    800db4 <strtol+0x29>
		s++, neg = 1;
  800de3:	83 c1 01             	add    $0x1,%ecx
  800de6:	bf 01 00 00 00       	mov    $0x1,%edi
  800deb:	eb c7                	jmp    800db4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ded:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800df1:	74 0e                	je     800e01 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800df3:	85 db                	test   %ebx,%ebx
  800df5:	75 d8                	jne    800dcf <strtol+0x44>
		s++, base = 8;
  800df7:	83 c1 01             	add    $0x1,%ecx
  800dfa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dff:	eb ce                	jmp    800dcf <strtol+0x44>
		s += 2, base = 16;
  800e01:	83 c1 02             	add    $0x2,%ecx
  800e04:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e09:	eb c4                	jmp    800dcf <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e0b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e0e:	89 f3                	mov    %esi,%ebx
  800e10:	80 fb 19             	cmp    $0x19,%bl
  800e13:	77 29                	ja     800e3e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e15:	0f be d2             	movsbl %dl,%edx
  800e18:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e1b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e1e:	7d 30                	jge    800e50 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e20:	83 c1 01             	add    $0x1,%ecx
  800e23:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e29:	0f b6 11             	movzbl (%ecx),%edx
  800e2c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e2f:	89 f3                	mov    %esi,%ebx
  800e31:	80 fb 09             	cmp    $0x9,%bl
  800e34:	77 d5                	ja     800e0b <strtol+0x80>
			dig = *s - '0';
  800e36:	0f be d2             	movsbl %dl,%edx
  800e39:	83 ea 30             	sub    $0x30,%edx
  800e3c:	eb dd                	jmp    800e1b <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800e3e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e41:	89 f3                	mov    %esi,%ebx
  800e43:	80 fb 19             	cmp    $0x19,%bl
  800e46:	77 08                	ja     800e50 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e48:	0f be d2             	movsbl %dl,%edx
  800e4b:	83 ea 37             	sub    $0x37,%edx
  800e4e:	eb cb                	jmp    800e1b <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 05                	je     800e5b <strtol+0xd0>
		*endptr = (char *) s;
  800e56:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e59:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e5b:	89 c2                	mov    %eax,%edx
  800e5d:	f7 da                	neg    %edx
  800e5f:	85 ff                	test   %edi,%edi
  800e61:	0f 45 c2             	cmovne %edx,%eax
}
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7a:	89 c3                	mov    %eax,%ebx
  800e7c:	89 c7                	mov    %eax,%edi
  800e7e:	89 c6                	mov    %eax,%esi
  800e80:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e92:	b8 01 00 00 00       	mov    $0x1,%eax
  800e97:	89 d1                	mov    %edx,%ecx
  800e99:	89 d3                	mov    %edx,%ebx
  800e9b:	89 d7                	mov    %edx,%edi
  800e9d:	89 d6                	mov    %edx,%esi
  800e9f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	b8 03 00 00 00       	mov    $0x3,%eax
  800ebc:	89 cb                	mov    %ecx,%ebx
  800ebe:	89 cf                	mov    %ecx,%edi
  800ec0:	89 ce                	mov    %ecx,%esi
  800ec2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7f 08                	jg     800ed0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	50                   	push   %eax
  800ed4:	6a 03                	push   $0x3
  800ed6:	68 6f 29 80 00       	push   $0x80296f
  800edb:	6a 23                	push   $0x23
  800edd:	68 8c 29 80 00       	push   $0x80298c
  800ee2:	e8 dd f3 ff ff       	call   8002c4 <_panic>

00800ee7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eed:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef7:	89 d1                	mov    %edx,%ecx
  800ef9:	89 d3                	mov    %edx,%ebx
  800efb:	89 d7                	mov    %edx,%edi
  800efd:	89 d6                	mov    %edx,%esi
  800eff:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <sys_yield>:

void
sys_yield(void)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f11:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f16:	89 d1                	mov    %edx,%ecx
  800f18:	89 d3                	mov    %edx,%ebx
  800f1a:	89 d7                	mov    %edx,%edi
  800f1c:	89 d6                	mov    %edx,%esi
  800f1e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f20:	5b                   	pop    %ebx
  800f21:	5e                   	pop    %esi
  800f22:	5f                   	pop    %edi
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    

00800f25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2e:	be 00 00 00 00       	mov    $0x0,%esi
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	b8 04 00 00 00       	mov    $0x4,%eax
  800f3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f41:	89 f7                	mov    %esi,%edi
  800f43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f45:	85 c0                	test   %eax,%eax
  800f47:	7f 08                	jg     800f51 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f51:	83 ec 0c             	sub    $0xc,%esp
  800f54:	50                   	push   %eax
  800f55:	6a 04                	push   $0x4
  800f57:	68 6f 29 80 00       	push   $0x80296f
  800f5c:	6a 23                	push   $0x23
  800f5e:	68 8c 29 80 00       	push   $0x80298c
  800f63:	e8 5c f3 ff ff       	call   8002c4 <_panic>

00800f68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
  800f6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f77:	b8 05 00 00 00       	mov    $0x5,%eax
  800f7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f82:	8b 75 18             	mov    0x18(%ebp),%esi
  800f85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	7f 08                	jg     800f93 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8e:	5b                   	pop    %ebx
  800f8f:	5e                   	pop    %esi
  800f90:	5f                   	pop    %edi
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f93:	83 ec 0c             	sub    $0xc,%esp
  800f96:	50                   	push   %eax
  800f97:	6a 05                	push   $0x5
  800f99:	68 6f 29 80 00       	push   $0x80296f
  800f9e:	6a 23                	push   $0x23
  800fa0:	68 8c 29 80 00       	push   $0x80298c
  800fa5:	e8 1a f3 ff ff       	call   8002c4 <_panic>

00800faa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	57                   	push   %edi
  800fae:	56                   	push   %esi
  800faf:	53                   	push   %ebx
  800fb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbe:	b8 06 00 00 00       	mov    $0x6,%eax
  800fc3:	89 df                	mov    %ebx,%edi
  800fc5:	89 de                	mov    %ebx,%esi
  800fc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	7f 08                	jg     800fd5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd0:	5b                   	pop    %ebx
  800fd1:	5e                   	pop    %esi
  800fd2:	5f                   	pop    %edi
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd5:	83 ec 0c             	sub    $0xc,%esp
  800fd8:	50                   	push   %eax
  800fd9:	6a 06                	push   $0x6
  800fdb:	68 6f 29 80 00       	push   $0x80296f
  800fe0:	6a 23                	push   $0x23
  800fe2:	68 8c 29 80 00       	push   $0x80298c
  800fe7:	e8 d8 f2 ff ff       	call   8002c4 <_panic>

00800fec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
  800ff2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	b8 08 00 00 00       	mov    $0x8,%eax
  801005:	89 df                	mov    %ebx,%edi
  801007:	89 de                	mov    %ebx,%esi
  801009:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	7f 08                	jg     801017 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	50                   	push   %eax
  80101b:	6a 08                	push   $0x8
  80101d:	68 6f 29 80 00       	push   $0x80296f
  801022:	6a 23                	push   $0x23
  801024:	68 8c 29 80 00       	push   $0x80298c
  801029:	e8 96 f2 ff ff       	call   8002c4 <_panic>

0080102e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	57                   	push   %edi
  801032:	56                   	push   %esi
  801033:	53                   	push   %ebx
  801034:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801037:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801042:	b8 09 00 00 00       	mov    $0x9,%eax
  801047:	89 df                	mov    %ebx,%edi
  801049:	89 de                	mov    %ebx,%esi
  80104b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80104d:	85 c0                	test   %eax,%eax
  80104f:	7f 08                	jg     801059 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801051:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801054:	5b                   	pop    %ebx
  801055:	5e                   	pop    %esi
  801056:	5f                   	pop    %edi
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801059:	83 ec 0c             	sub    $0xc,%esp
  80105c:	50                   	push   %eax
  80105d:	6a 09                	push   $0x9
  80105f:	68 6f 29 80 00       	push   $0x80296f
  801064:	6a 23                	push   $0x23
  801066:	68 8c 29 80 00       	push   $0x80298c
  80106b:	e8 54 f2 ff ff       	call   8002c4 <_panic>

00801070 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
  801076:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801084:	b8 0a 00 00 00       	mov    $0xa,%eax
  801089:	89 df                	mov    %ebx,%edi
  80108b:	89 de                	mov    %ebx,%esi
  80108d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108f:	85 c0                	test   %eax,%eax
  801091:	7f 08                	jg     80109b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80109b:	83 ec 0c             	sub    $0xc,%esp
  80109e:	50                   	push   %eax
  80109f:	6a 0a                	push   $0xa
  8010a1:	68 6f 29 80 00       	push   $0x80296f
  8010a6:	6a 23                	push   $0x23
  8010a8:	68 8c 29 80 00       	push   $0x80298c
  8010ad:	e8 12 f2 ff ff       	call   8002c4 <_panic>

008010b2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	57                   	push   %edi
  8010b6:	56                   	push   %esi
  8010b7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010be:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010c3:	be 00 00 00 00       	mov    $0x0,%esi
  8010c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010ce:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010d0:	5b                   	pop    %ebx
  8010d1:	5e                   	pop    %esi
  8010d2:	5f                   	pop    %edi
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	57                   	push   %edi
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010eb:	89 cb                	mov    %ecx,%ebx
  8010ed:	89 cf                	mov    %ecx,%edi
  8010ef:	89 ce                	mov    %ecx,%esi
  8010f1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	7f 08                	jg     8010ff <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	50                   	push   %eax
  801103:	6a 0d                	push   $0xd
  801105:	68 6f 29 80 00       	push   $0x80296f
  80110a:	6a 23                	push   $0x23
  80110c:	68 8c 29 80 00       	push   $0x80298c
  801111:	e8 ae f1 ff ff       	call   8002c4 <_panic>

00801116 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111c:	ba 00 00 00 00       	mov    $0x0,%edx
  801121:	b8 0e 00 00 00       	mov    $0xe,%eax
  801126:	89 d1                	mov    %edx,%ecx
  801128:	89 d3                	mov    %edx,%ebx
  80112a:	89 d7                	mov    %edx,%edi
  80112c:	89 d6                	mov    %edx,%esi
  80112e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	05 00 00 00 30       	add    $0x30000000,%eax
  801140:	c1 e8 0c             	shr    $0xc,%eax
}
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801150:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801155:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801162:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801167:	89 c2                	mov    %eax,%edx
  801169:	c1 ea 16             	shr    $0x16,%edx
  80116c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801173:	f6 c2 01             	test   $0x1,%dl
  801176:	74 2a                	je     8011a2 <fd_alloc+0x46>
  801178:	89 c2                	mov    %eax,%edx
  80117a:	c1 ea 0c             	shr    $0xc,%edx
  80117d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801184:	f6 c2 01             	test   $0x1,%dl
  801187:	74 19                	je     8011a2 <fd_alloc+0x46>
  801189:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80118e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801193:	75 d2                	jne    801167 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801195:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80119b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011a0:	eb 07                	jmp    8011a9 <fd_alloc+0x4d>
			*fd_store = fd;
  8011a2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011b1:	83 f8 1f             	cmp    $0x1f,%eax
  8011b4:	77 36                	ja     8011ec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b6:	c1 e0 0c             	shl    $0xc,%eax
  8011b9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	c1 ea 16             	shr    $0x16,%edx
  8011c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ca:	f6 c2 01             	test   $0x1,%dl
  8011cd:	74 24                	je     8011f3 <fd_lookup+0x48>
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	c1 ea 0c             	shr    $0xc,%edx
  8011d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011db:	f6 c2 01             	test   $0x1,%dl
  8011de:	74 1a                	je     8011fa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e3:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ea:	5d                   	pop    %ebp
  8011eb:	c3                   	ret    
		return -E_INVAL;
  8011ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f1:	eb f7                	jmp    8011ea <fd_lookup+0x3f>
		return -E_INVAL;
  8011f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f8:	eb f0                	jmp    8011ea <fd_lookup+0x3f>
  8011fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ff:	eb e9                	jmp    8011ea <fd_lookup+0x3f>

00801201 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120a:	ba 18 2a 80 00       	mov    $0x802a18,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80120f:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801214:	39 08                	cmp    %ecx,(%eax)
  801216:	74 33                	je     80124b <dev_lookup+0x4a>
  801218:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80121b:	8b 02                	mov    (%edx),%eax
  80121d:	85 c0                	test   %eax,%eax
  80121f:	75 f3                	jne    801214 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801221:	a1 08 44 80 00       	mov    0x804408,%eax
  801226:	8b 40 48             	mov    0x48(%eax),%eax
  801229:	83 ec 04             	sub    $0x4,%esp
  80122c:	51                   	push   %ecx
  80122d:	50                   	push   %eax
  80122e:	68 9c 29 80 00       	push   $0x80299c
  801233:	e8 67 f1 ff ff       	call   80039f <cprintf>
	*dev = 0;
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    
			*dev = devtab[i];
  80124b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801250:	b8 00 00 00 00       	mov    $0x0,%eax
  801255:	eb f2                	jmp    801249 <dev_lookup+0x48>

00801257 <fd_close>:
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	57                   	push   %edi
  80125b:	56                   	push   %esi
  80125c:	53                   	push   %ebx
  80125d:	83 ec 1c             	sub    $0x1c,%esp
  801260:	8b 75 08             	mov    0x8(%ebp),%esi
  801263:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801266:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801269:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801270:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801273:	50                   	push   %eax
  801274:	e8 32 ff ff ff       	call   8011ab <fd_lookup>
  801279:	89 c3                	mov    %eax,%ebx
  80127b:	83 c4 08             	add    $0x8,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 05                	js     801287 <fd_close+0x30>
	    || fd != fd2)
  801282:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801285:	74 16                	je     80129d <fd_close+0x46>
		return (must_exist ? r : 0);
  801287:	89 f8                	mov    %edi,%eax
  801289:	84 c0                	test   %al,%al
  80128b:	b8 00 00 00 00       	mov    $0x0,%eax
  801290:	0f 44 d8             	cmove  %eax,%ebx
}
  801293:	89 d8                	mov    %ebx,%eax
  801295:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801298:	5b                   	pop    %ebx
  801299:	5e                   	pop    %esi
  80129a:	5f                   	pop    %edi
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	ff 36                	pushl  (%esi)
  8012a6:	e8 56 ff ff ff       	call   801201 <dev_lookup>
  8012ab:	89 c3                	mov    %eax,%ebx
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	78 15                	js     8012c9 <fd_close+0x72>
		if (dev->dev_close)
  8012b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b7:	8b 40 10             	mov    0x10(%eax),%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1b                	je     8012d9 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	56                   	push   %esi
  8012c2:	ff d0                	call   *%eax
  8012c4:	89 c3                	mov    %eax,%ebx
  8012c6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012c9:	83 ec 08             	sub    $0x8,%esp
  8012cc:	56                   	push   %esi
  8012cd:	6a 00                	push   $0x0
  8012cf:	e8 d6 fc ff ff       	call   800faa <sys_page_unmap>
	return r;
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb ba                	jmp    801293 <fd_close+0x3c>
			r = 0;
  8012d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012de:	eb e9                	jmp    8012c9 <fd_close+0x72>

008012e0 <close>:

int
close(int fdnum)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff 75 08             	pushl  0x8(%ebp)
  8012ed:	e8 b9 fe ff ff       	call   8011ab <fd_lookup>
  8012f2:	83 c4 08             	add    $0x8,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 10                	js     801309 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012f9:	83 ec 08             	sub    $0x8,%esp
  8012fc:	6a 01                	push   $0x1
  8012fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801301:	e8 51 ff ff ff       	call   801257 <fd_close>
  801306:	83 c4 10             	add    $0x10,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <close_all>:

void
close_all(void)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	53                   	push   %ebx
  80130f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801312:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	53                   	push   %ebx
  80131b:	e8 c0 ff ff ff       	call   8012e0 <close>
	for (i = 0; i < MAXFD; i++)
  801320:	83 c3 01             	add    $0x1,%ebx
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	83 fb 20             	cmp    $0x20,%ebx
  801329:	75 ec                	jne    801317 <close_all+0xc>
}
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801339:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	e8 66 fe ff ff       	call   8011ab <fd_lookup>
  801345:	89 c3                	mov    %eax,%ebx
  801347:	83 c4 08             	add    $0x8,%esp
  80134a:	85 c0                	test   %eax,%eax
  80134c:	0f 88 81 00 00 00    	js     8013d3 <dup+0xa3>
		return r;
	close(newfdnum);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 0c             	pushl  0xc(%ebp)
  801358:	e8 83 ff ff ff       	call   8012e0 <close>

	newfd = INDEX2FD(newfdnum);
  80135d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801360:	c1 e6 0c             	shl    $0xc,%esi
  801363:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801369:	83 c4 04             	add    $0x4,%esp
  80136c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80136f:	e8 d1 fd ff ff       	call   801145 <fd2data>
  801374:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801376:	89 34 24             	mov    %esi,(%esp)
  801379:	e8 c7 fd ff ff       	call   801145 <fd2data>
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801383:	89 d8                	mov    %ebx,%eax
  801385:	c1 e8 16             	shr    $0x16,%eax
  801388:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138f:	a8 01                	test   $0x1,%al
  801391:	74 11                	je     8013a4 <dup+0x74>
  801393:	89 d8                	mov    %ebx,%eax
  801395:	c1 e8 0c             	shr    $0xc,%eax
  801398:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80139f:	f6 c2 01             	test   $0x1,%dl
  8013a2:	75 39                	jne    8013dd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a7:	89 d0                	mov    %edx,%eax
  8013a9:	c1 e8 0c             	shr    $0xc,%eax
  8013ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bb:	50                   	push   %eax
  8013bc:	56                   	push   %esi
  8013bd:	6a 00                	push   $0x0
  8013bf:	52                   	push   %edx
  8013c0:	6a 00                	push   $0x0
  8013c2:	e8 a1 fb ff ff       	call   800f68 <sys_page_map>
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	83 c4 20             	add    $0x20,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 31                	js     801401 <dup+0xd1>
		goto err;

	return newfdnum;
  8013d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013d3:	89 d8                	mov    %ebx,%eax
  8013d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5f                   	pop    %edi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ec:	50                   	push   %eax
  8013ed:	57                   	push   %edi
  8013ee:	6a 00                	push   $0x0
  8013f0:	53                   	push   %ebx
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 70 fb ff ff       	call   800f68 <sys_page_map>
  8013f8:	89 c3                	mov    %eax,%ebx
  8013fa:	83 c4 20             	add    $0x20,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	79 a3                	jns    8013a4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	56                   	push   %esi
  801405:	6a 00                	push   $0x0
  801407:	e8 9e fb ff ff       	call   800faa <sys_page_unmap>
	sys_page_unmap(0, nva);
  80140c:	83 c4 08             	add    $0x8,%esp
  80140f:	57                   	push   %edi
  801410:	6a 00                	push   $0x0
  801412:	e8 93 fb ff ff       	call   800faa <sys_page_unmap>
	return r;
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	eb b7                	jmp    8013d3 <dup+0xa3>

0080141c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	53                   	push   %ebx
  801420:	83 ec 14             	sub    $0x14,%esp
  801423:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801426:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801429:	50                   	push   %eax
  80142a:	53                   	push   %ebx
  80142b:	e8 7b fd ff ff       	call   8011ab <fd_lookup>
  801430:	83 c4 08             	add    $0x8,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 3f                	js     801476 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	ff 30                	pushl  (%eax)
  801443:	e8 b9 fd ff ff       	call   801201 <dev_lookup>
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 27                	js     801476 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80144f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801452:	8b 42 08             	mov    0x8(%edx),%eax
  801455:	83 e0 03             	and    $0x3,%eax
  801458:	83 f8 01             	cmp    $0x1,%eax
  80145b:	74 1e                	je     80147b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80145d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801460:	8b 40 08             	mov    0x8(%eax),%eax
  801463:	85 c0                	test   %eax,%eax
  801465:	74 35                	je     80149c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	ff 75 10             	pushl  0x10(%ebp)
  80146d:	ff 75 0c             	pushl  0xc(%ebp)
  801470:	52                   	push   %edx
  801471:	ff d0                	call   *%eax
  801473:	83 c4 10             	add    $0x10,%esp
}
  801476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801479:	c9                   	leave  
  80147a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147b:	a1 08 44 80 00       	mov    0x804408,%eax
  801480:	8b 40 48             	mov    0x48(%eax),%eax
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	53                   	push   %ebx
  801487:	50                   	push   %eax
  801488:	68 dd 29 80 00       	push   $0x8029dd
  80148d:	e8 0d ef ff ff       	call   80039f <cprintf>
		return -E_INVAL;
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149a:	eb da                	jmp    801476 <read+0x5a>
		return -E_NOT_SUPP;
  80149c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a1:	eb d3                	jmp    801476 <read+0x5a>

008014a3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	57                   	push   %edi
  8014a7:	56                   	push   %esi
  8014a8:	53                   	push   %ebx
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014af:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b7:	39 f3                	cmp    %esi,%ebx
  8014b9:	73 25                	jae    8014e0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	89 f0                	mov    %esi,%eax
  8014c0:	29 d8                	sub    %ebx,%eax
  8014c2:	50                   	push   %eax
  8014c3:	89 d8                	mov    %ebx,%eax
  8014c5:	03 45 0c             	add    0xc(%ebp),%eax
  8014c8:	50                   	push   %eax
  8014c9:	57                   	push   %edi
  8014ca:	e8 4d ff ff ff       	call   80141c <read>
		if (m < 0)
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 08                	js     8014de <readn+0x3b>
			return m;
		if (m == 0)
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	74 06                	je     8014e0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014da:	01 c3                	add    %eax,%ebx
  8014dc:	eb d9                	jmp    8014b7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014de:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014e0:	89 d8                	mov    %ebx,%eax
  8014e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5f                   	pop    %edi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    

008014ea <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 14             	sub    $0x14,%esp
  8014f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f7:	50                   	push   %eax
  8014f8:	53                   	push   %ebx
  8014f9:	e8 ad fc ff ff       	call   8011ab <fd_lookup>
  8014fe:	83 c4 08             	add    $0x8,%esp
  801501:	85 c0                	test   %eax,%eax
  801503:	78 3a                	js     80153f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150b:	50                   	push   %eax
  80150c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150f:	ff 30                	pushl  (%eax)
  801511:	e8 eb fc ff ff       	call   801201 <dev_lookup>
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 22                	js     80153f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801524:	74 1e                	je     801544 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801529:	8b 52 0c             	mov    0xc(%edx),%edx
  80152c:	85 d2                	test   %edx,%edx
  80152e:	74 35                	je     801565 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	ff 75 10             	pushl  0x10(%ebp)
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	50                   	push   %eax
  80153a:	ff d2                	call   *%edx
  80153c:	83 c4 10             	add    $0x10,%esp
}
  80153f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801542:	c9                   	leave  
  801543:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801544:	a1 08 44 80 00       	mov    0x804408,%eax
  801549:	8b 40 48             	mov    0x48(%eax),%eax
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	53                   	push   %ebx
  801550:	50                   	push   %eax
  801551:	68 f9 29 80 00       	push   $0x8029f9
  801556:	e8 44 ee ff ff       	call   80039f <cprintf>
		return -E_INVAL;
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801563:	eb da                	jmp    80153f <write+0x55>
		return -E_NOT_SUPP;
  801565:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156a:	eb d3                	jmp    80153f <write+0x55>

0080156c <seek>:

int
seek(int fdnum, off_t offset)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801572:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	ff 75 08             	pushl  0x8(%ebp)
  801579:	e8 2d fc ff ff       	call   8011ab <fd_lookup>
  80157e:	83 c4 08             	add    $0x8,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 0e                	js     801593 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801585:	8b 55 0c             	mov    0xc(%ebp),%edx
  801588:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 14             	sub    $0x14,%esp
  80159c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80159f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a2:	50                   	push   %eax
  8015a3:	53                   	push   %ebx
  8015a4:	e8 02 fc ff ff       	call   8011ab <fd_lookup>
  8015a9:	83 c4 08             	add    $0x8,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 37                	js     8015e7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	ff 30                	pushl  (%eax)
  8015bc:	e8 40 fc ff ff       	call   801201 <dev_lookup>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 1f                	js     8015e7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015cf:	74 1b                	je     8015ec <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d4:	8b 52 18             	mov    0x18(%edx),%edx
  8015d7:	85 d2                	test   %edx,%edx
  8015d9:	74 32                	je     80160d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	ff d2                	call   *%edx
  8015e4:	83 c4 10             	add    $0x10,%esp
}
  8015e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015ec:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f1:	8b 40 48             	mov    0x48(%eax),%eax
  8015f4:	83 ec 04             	sub    $0x4,%esp
  8015f7:	53                   	push   %ebx
  8015f8:	50                   	push   %eax
  8015f9:	68 bc 29 80 00       	push   $0x8029bc
  8015fe:	e8 9c ed ff ff       	call   80039f <cprintf>
		return -E_INVAL;
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160b:	eb da                	jmp    8015e7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80160d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801612:	eb d3                	jmp    8015e7 <ftruncate+0x52>

00801614 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	53                   	push   %ebx
  801618:	83 ec 14             	sub    $0x14,%esp
  80161b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801621:	50                   	push   %eax
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	e8 81 fb ff ff       	call   8011ab <fd_lookup>
  80162a:	83 c4 08             	add    $0x8,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 4b                	js     80167c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163b:	ff 30                	pushl  (%eax)
  80163d:	e8 bf fb ff ff       	call   801201 <dev_lookup>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 33                	js     80167c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801650:	74 2f                	je     801681 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801652:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801655:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80165c:	00 00 00 
	stat->st_isdir = 0;
  80165f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801666:	00 00 00 
	stat->st_dev = dev;
  801669:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80166f:	83 ec 08             	sub    $0x8,%esp
  801672:	53                   	push   %ebx
  801673:	ff 75 f0             	pushl  -0x10(%ebp)
  801676:	ff 50 14             	call   *0x14(%eax)
  801679:	83 c4 10             	add    $0x10,%esp
}
  80167c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167f:	c9                   	leave  
  801680:	c3                   	ret    
		return -E_NOT_SUPP;
  801681:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801686:	eb f4                	jmp    80167c <fstat+0x68>

00801688 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	56                   	push   %esi
  80168c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80168d:	83 ec 08             	sub    $0x8,%esp
  801690:	6a 00                	push   $0x0
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	e8 26 02 00 00       	call   8018c0 <open>
  80169a:	89 c3                	mov    %eax,%ebx
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	78 1b                	js     8016be <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	50                   	push   %eax
  8016aa:	e8 65 ff ff ff       	call   801614 <fstat>
  8016af:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b1:	89 1c 24             	mov    %ebx,(%esp)
  8016b4:	e8 27 fc ff ff       	call   8012e0 <close>
	return r;
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	89 f3                	mov    %esi,%ebx
}
  8016be:	89 d8                	mov    %ebx,%eax
  8016c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	56                   	push   %esi
  8016cb:	53                   	push   %ebx
  8016cc:	89 c6                	mov    %eax,%esi
  8016ce:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016d0:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  8016d7:	74 27                	je     801700 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016d9:	6a 07                	push   $0x7
  8016db:	68 00 50 80 00       	push   $0x805000
  8016e0:	56                   	push   %esi
  8016e1:	ff 35 00 44 80 00    	pushl  0x804400
  8016e7:	e8 a9 0b 00 00       	call   802295 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ec:	83 c4 0c             	add    $0xc,%esp
  8016ef:	6a 00                	push   $0x0
  8016f1:	53                   	push   %ebx
  8016f2:	6a 00                	push   $0x0
  8016f4:	e8 33 0b 00 00       	call   80222c <ipc_recv>
}
  8016f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fc:	5b                   	pop    %ebx
  8016fd:	5e                   	pop    %esi
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801700:	83 ec 0c             	sub    $0xc,%esp
  801703:	6a 01                	push   $0x1
  801705:	e8 e4 0b 00 00       	call   8022ee <ipc_find_env>
  80170a:	a3 00 44 80 00       	mov    %eax,0x804400
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	eb c5                	jmp    8016d9 <fsipc+0x12>

00801714 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8b 40 0c             	mov    0xc(%eax),%eax
  801720:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801725:	8b 45 0c             	mov    0xc(%ebp),%eax
  801728:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80172d:	ba 00 00 00 00       	mov    $0x0,%edx
  801732:	b8 02 00 00 00       	mov    $0x2,%eax
  801737:	e8 8b ff ff ff       	call   8016c7 <fsipc>
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <devfile_flush>:
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	8b 40 0c             	mov    0xc(%eax),%eax
  80174a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80174f:	ba 00 00 00 00       	mov    $0x0,%edx
  801754:	b8 06 00 00 00       	mov    $0x6,%eax
  801759:	e8 69 ff ff ff       	call   8016c7 <fsipc>
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <devfile_stat>:
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	53                   	push   %ebx
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8b 40 0c             	mov    0xc(%eax),%eax
  801770:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	b8 05 00 00 00       	mov    $0x5,%eax
  80177f:	e8 43 ff ff ff       	call   8016c7 <fsipc>
  801784:	85 c0                	test   %eax,%eax
  801786:	78 2c                	js     8017b4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	68 00 50 80 00       	push   $0x805000
  801790:	53                   	push   %ebx
  801791:	e8 96 f3 ff ff       	call   800b2c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801796:	a1 80 50 80 00       	mov    0x805080,%eax
  80179b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017a1:	a1 84 50 80 00       	mov    0x805084,%eax
  8017a6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <devfile_write>:
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	53                   	push   %ebx
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017ce:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8017d4:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8017da:	77 30                	ja     80180c <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	53                   	push   %ebx
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	68 08 50 80 00       	push   $0x805008
  8017e8:	e8 cd f4 ff ff       	call   800cba <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8017f7:	e8 cb fe ff ff       	call   8016c7 <fsipc>
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 04                	js     801807 <devfile_write+0x4e>
	assert(r <= n);
  801803:	39 d8                	cmp    %ebx,%eax
  801805:	77 1e                	ja     801825 <devfile_write+0x6c>
}
  801807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80180c:	68 2c 2a 80 00       	push   $0x802a2c
  801811:	68 5c 2a 80 00       	push   $0x802a5c
  801816:	68 94 00 00 00       	push   $0x94
  80181b:	68 71 2a 80 00       	push   $0x802a71
  801820:	e8 9f ea ff ff       	call   8002c4 <_panic>
	assert(r <= n);
  801825:	68 7c 2a 80 00       	push   $0x802a7c
  80182a:	68 5c 2a 80 00       	push   $0x802a5c
  80182f:	68 98 00 00 00       	push   $0x98
  801834:	68 71 2a 80 00       	push   $0x802a71
  801839:	e8 86 ea ff ff       	call   8002c4 <_panic>

0080183e <devfile_read>:
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	56                   	push   %esi
  801842:	53                   	push   %ebx
  801843:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8b 40 0c             	mov    0xc(%eax),%eax
  80184c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801851:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	b8 03 00 00 00       	mov    $0x3,%eax
  801861:	e8 61 fe ff ff       	call   8016c7 <fsipc>
  801866:	89 c3                	mov    %eax,%ebx
  801868:	85 c0                	test   %eax,%eax
  80186a:	78 1f                	js     80188b <devfile_read+0x4d>
	assert(r <= n);
  80186c:	39 f0                	cmp    %esi,%eax
  80186e:	77 24                	ja     801894 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801870:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801875:	7f 33                	jg     8018aa <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801877:	83 ec 04             	sub    $0x4,%esp
  80187a:	50                   	push   %eax
  80187b:	68 00 50 80 00       	push   $0x805000
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	e8 32 f4 ff ff       	call   800cba <memmove>
	return r;
  801888:	83 c4 10             	add    $0x10,%esp
}
  80188b:	89 d8                	mov    %ebx,%eax
  80188d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801890:	5b                   	pop    %ebx
  801891:	5e                   	pop    %esi
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    
	assert(r <= n);
  801894:	68 7c 2a 80 00       	push   $0x802a7c
  801899:	68 5c 2a 80 00       	push   $0x802a5c
  80189e:	6a 7c                	push   $0x7c
  8018a0:	68 71 2a 80 00       	push   $0x802a71
  8018a5:	e8 1a ea ff ff       	call   8002c4 <_panic>
	assert(r <= PGSIZE);
  8018aa:	68 83 2a 80 00       	push   $0x802a83
  8018af:	68 5c 2a 80 00       	push   $0x802a5c
  8018b4:	6a 7d                	push   $0x7d
  8018b6:	68 71 2a 80 00       	push   $0x802a71
  8018bb:	e8 04 ea ff ff       	call   8002c4 <_panic>

008018c0 <open>:
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 1c             	sub    $0x1c,%esp
  8018c8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018cb:	56                   	push   %esi
  8018cc:	e8 24 f2 ff ff       	call   800af5 <strlen>
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018d9:	7f 6c                	jg     801947 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018db:	83 ec 0c             	sub    $0xc,%esp
  8018de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e1:	50                   	push   %eax
  8018e2:	e8 75 f8 ff ff       	call   80115c <fd_alloc>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 3c                	js     80192c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	56                   	push   %esi
  8018f4:	68 00 50 80 00       	push   $0x805000
  8018f9:	e8 2e f2 ff ff       	call   800b2c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801901:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801909:	b8 01 00 00 00       	mov    $0x1,%eax
  80190e:	e8 b4 fd ff ff       	call   8016c7 <fsipc>
  801913:	89 c3                	mov    %eax,%ebx
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 19                	js     801935 <open+0x75>
	return fd2num(fd);
  80191c:	83 ec 0c             	sub    $0xc,%esp
  80191f:	ff 75 f4             	pushl  -0xc(%ebp)
  801922:	e8 0e f8 ff ff       	call   801135 <fd2num>
  801927:	89 c3                	mov    %eax,%ebx
  801929:	83 c4 10             	add    $0x10,%esp
}
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801931:	5b                   	pop    %ebx
  801932:	5e                   	pop    %esi
  801933:	5d                   	pop    %ebp
  801934:	c3                   	ret    
		fd_close(fd, 0);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	6a 00                	push   $0x0
  80193a:	ff 75 f4             	pushl  -0xc(%ebp)
  80193d:	e8 15 f9 ff ff       	call   801257 <fd_close>
		return r;
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	eb e5                	jmp    80192c <open+0x6c>
		return -E_BAD_PATH;
  801947:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80194c:	eb de                	jmp    80192c <open+0x6c>

0080194e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801954:	ba 00 00 00 00       	mov    $0x0,%edx
  801959:	b8 08 00 00 00       	mov    $0x8,%eax
  80195e:	e8 64 fd ff ff       	call   8016c7 <fsipc>
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801965:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801969:	7e 38                	jle    8019a3 <writebuf+0x3e>
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	53                   	push   %ebx
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801974:	ff 70 04             	pushl  0x4(%eax)
  801977:	8d 40 10             	lea    0x10(%eax),%eax
  80197a:	50                   	push   %eax
  80197b:	ff 33                	pushl  (%ebx)
  80197d:	e8 68 fb ff ff       	call   8014ea <write>
		if (result > 0)
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	85 c0                	test   %eax,%eax
  801987:	7e 03                	jle    80198c <writebuf+0x27>
			b->result += result;
  801989:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80198c:	39 43 04             	cmp    %eax,0x4(%ebx)
  80198f:	74 0d                	je     80199e <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  801991:	85 c0                	test   %eax,%eax
  801993:	ba 00 00 00 00       	mov    $0x0,%edx
  801998:	0f 4f c2             	cmovg  %edx,%eax
  80199b:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80199e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    
  8019a3:	f3 c3                	repz ret 

008019a5 <putch>:

static void
putch(int ch, void *thunk)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	53                   	push   %ebx
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019af:	8b 53 04             	mov    0x4(%ebx),%edx
  8019b2:	8d 42 01             	lea    0x1(%edx),%eax
  8019b5:	89 43 04             	mov    %eax,0x4(%ebx)
  8019b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bb:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019bf:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019c4:	74 06                	je     8019cc <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019c6:	83 c4 04             	add    $0x4,%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    
		writebuf(b);
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	e8 92 ff ff ff       	call   801965 <writebuf>
		b->idx = 0;
  8019d3:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019da:	eb ea                	jmp    8019c6 <putch+0x21>

008019dc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019ee:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019f5:	00 00 00 
	b.result = 0;
  8019f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019ff:	00 00 00 
	b.error = 1;
  801a02:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a09:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a0c:	ff 75 10             	pushl  0x10(%ebp)
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a18:	50                   	push   %eax
  801a19:	68 a5 19 80 00       	push   $0x8019a5
  801a1e:	e8 79 ea ff ff       	call   80049c <vprintfmt>
	if (b.idx > 0)
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a2d:	7f 11                	jg     801a40 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a2f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a35:	85 c0                	test   %eax,%eax
  801a37:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    
		writebuf(&b);
  801a40:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a46:	e8 1a ff ff ff       	call   801965 <writebuf>
  801a4b:	eb e2                	jmp    801a2f <vfprintf+0x53>

00801a4d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a53:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a56:	50                   	push   %eax
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	e8 7a ff ff ff       	call   8019dc <vfprintf>
	va_end(ap);

	return cnt;
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <printf>:

int
printf(const char *fmt, ...)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a6a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a6d:	50                   	push   %eax
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	6a 01                	push   $0x1
  801a73:	e8 64 ff ff ff       	call   8019dc <vfprintf>
	va_end(ap);

	return cnt;
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	56                   	push   %esi
  801a7e:	53                   	push   %ebx
  801a7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	e8 b8 f6 ff ff       	call   801145 <fd2data>
  801a8d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a8f:	83 c4 08             	add    $0x8,%esp
  801a92:	68 8f 2a 80 00       	push   $0x802a8f
  801a97:	53                   	push   %ebx
  801a98:	e8 8f f0 ff ff       	call   800b2c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a9d:	8b 46 04             	mov    0x4(%esi),%eax
  801aa0:	2b 06                	sub    (%esi),%eax
  801aa2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aa8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aaf:	00 00 00 
	stat->st_dev = &devpipe;
  801ab2:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ab9:	30 80 00 
	return 0;
}
  801abc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    

00801ac8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	53                   	push   %ebx
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ad2:	53                   	push   %ebx
  801ad3:	6a 00                	push   $0x0
  801ad5:	e8 d0 f4 ff ff       	call   800faa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ada:	89 1c 24             	mov    %ebx,(%esp)
  801add:	e8 63 f6 ff ff       	call   801145 <fd2data>
  801ae2:	83 c4 08             	add    $0x8,%esp
  801ae5:	50                   	push   %eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	e8 bd f4 ff ff       	call   800faa <sys_page_unmap>
}
  801aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <_pipeisclosed>:
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	57                   	push   %edi
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	83 ec 1c             	sub    $0x1c,%esp
  801afb:	89 c7                	mov    %eax,%edi
  801afd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801aff:	a1 08 44 80 00       	mov    0x804408,%eax
  801b04:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	57                   	push   %edi
  801b0b:	e8 17 08 00 00       	call   802327 <pageref>
  801b10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b13:	89 34 24             	mov    %esi,(%esp)
  801b16:	e8 0c 08 00 00       	call   802327 <pageref>
		nn = thisenv->env_runs;
  801b1b:	8b 15 08 44 80 00    	mov    0x804408,%edx
  801b21:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	39 cb                	cmp    %ecx,%ebx
  801b29:	74 1b                	je     801b46 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b2b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b2e:	75 cf                	jne    801aff <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b30:	8b 42 58             	mov    0x58(%edx),%eax
  801b33:	6a 01                	push   $0x1
  801b35:	50                   	push   %eax
  801b36:	53                   	push   %ebx
  801b37:	68 96 2a 80 00       	push   $0x802a96
  801b3c:	e8 5e e8 ff ff       	call   80039f <cprintf>
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	eb b9                	jmp    801aff <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b46:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b49:	0f 94 c0             	sete   %al
  801b4c:	0f b6 c0             	movzbl %al,%eax
}
  801b4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b52:	5b                   	pop    %ebx
  801b53:	5e                   	pop    %esi
  801b54:	5f                   	pop    %edi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    

00801b57 <devpipe_write>:
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	57                   	push   %edi
  801b5b:	56                   	push   %esi
  801b5c:	53                   	push   %ebx
  801b5d:	83 ec 28             	sub    $0x28,%esp
  801b60:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b63:	56                   	push   %esi
  801b64:	e8 dc f5 ff ff       	call   801145 <fd2data>
  801b69:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801b73:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b76:	74 4f                	je     801bc7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b78:	8b 43 04             	mov    0x4(%ebx),%eax
  801b7b:	8b 0b                	mov    (%ebx),%ecx
  801b7d:	8d 51 20             	lea    0x20(%ecx),%edx
  801b80:	39 d0                	cmp    %edx,%eax
  801b82:	72 14                	jb     801b98 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b84:	89 da                	mov    %ebx,%edx
  801b86:	89 f0                	mov    %esi,%eax
  801b88:	e8 65 ff ff ff       	call   801af2 <_pipeisclosed>
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	75 3a                	jne    801bcb <devpipe_write+0x74>
			sys_yield();
  801b91:	e8 70 f3 ff ff       	call   800f06 <sys_yield>
  801b96:	eb e0                	jmp    801b78 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b9f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ba2:	89 c2                	mov    %eax,%edx
  801ba4:	c1 fa 1f             	sar    $0x1f,%edx
  801ba7:	89 d1                	mov    %edx,%ecx
  801ba9:	c1 e9 1b             	shr    $0x1b,%ecx
  801bac:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801baf:	83 e2 1f             	and    $0x1f,%edx
  801bb2:	29 ca                	sub    %ecx,%edx
  801bb4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bb8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bbc:	83 c0 01             	add    $0x1,%eax
  801bbf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bc2:	83 c7 01             	add    $0x1,%edi
  801bc5:	eb ac                	jmp    801b73 <devpipe_write+0x1c>
	return i;
  801bc7:	89 f8                	mov    %edi,%eax
  801bc9:	eb 05                	jmp    801bd0 <devpipe_write+0x79>
				return 0;
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    

00801bd8 <devpipe_read>:
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	57                   	push   %edi
  801bdc:	56                   	push   %esi
  801bdd:	53                   	push   %ebx
  801bde:	83 ec 18             	sub    $0x18,%esp
  801be1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801be4:	57                   	push   %edi
  801be5:	e8 5b f5 ff ff       	call   801145 <fd2data>
  801bea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	be 00 00 00 00       	mov    $0x0,%esi
  801bf4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bf7:	74 47                	je     801c40 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801bf9:	8b 03                	mov    (%ebx),%eax
  801bfb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bfe:	75 22                	jne    801c22 <devpipe_read+0x4a>
			if (i > 0)
  801c00:	85 f6                	test   %esi,%esi
  801c02:	75 14                	jne    801c18 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c04:	89 da                	mov    %ebx,%edx
  801c06:	89 f8                	mov    %edi,%eax
  801c08:	e8 e5 fe ff ff       	call   801af2 <_pipeisclosed>
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	75 33                	jne    801c44 <devpipe_read+0x6c>
			sys_yield();
  801c11:	e8 f0 f2 ff ff       	call   800f06 <sys_yield>
  801c16:	eb e1                	jmp    801bf9 <devpipe_read+0x21>
				return i;
  801c18:	89 f0                	mov    %esi,%eax
}
  801c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c22:	99                   	cltd   
  801c23:	c1 ea 1b             	shr    $0x1b,%edx
  801c26:	01 d0                	add    %edx,%eax
  801c28:	83 e0 1f             	and    $0x1f,%eax
  801c2b:	29 d0                	sub    %edx,%eax
  801c2d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c35:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c38:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c3b:	83 c6 01             	add    $0x1,%esi
  801c3e:	eb b4                	jmp    801bf4 <devpipe_read+0x1c>
	return i;
  801c40:	89 f0                	mov    %esi,%eax
  801c42:	eb d6                	jmp    801c1a <devpipe_read+0x42>
				return 0;
  801c44:	b8 00 00 00 00       	mov    $0x0,%eax
  801c49:	eb cf                	jmp    801c1a <devpipe_read+0x42>

00801c4b <pipe>:
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c56:	50                   	push   %eax
  801c57:	e8 00 f5 ff ff       	call   80115c <fd_alloc>
  801c5c:	89 c3                	mov    %eax,%ebx
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	85 c0                	test   %eax,%eax
  801c63:	78 5b                	js     801cc0 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	68 07 04 00 00       	push   $0x407
  801c6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c70:	6a 00                	push   $0x0
  801c72:	e8 ae f2 ff ff       	call   800f25 <sys_page_alloc>
  801c77:	89 c3                	mov    %eax,%ebx
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 40                	js     801cc0 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c86:	50                   	push   %eax
  801c87:	e8 d0 f4 ff ff       	call   80115c <fd_alloc>
  801c8c:	89 c3                	mov    %eax,%ebx
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	85 c0                	test   %eax,%eax
  801c93:	78 1b                	js     801cb0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	68 07 04 00 00       	push   $0x407
  801c9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca0:	6a 00                	push   $0x0
  801ca2:	e8 7e f2 ff ff       	call   800f25 <sys_page_alloc>
  801ca7:	89 c3                	mov    %eax,%ebx
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	85 c0                	test   %eax,%eax
  801cae:	79 19                	jns    801cc9 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801cb0:	83 ec 08             	sub    $0x8,%esp
  801cb3:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb6:	6a 00                	push   $0x0
  801cb8:	e8 ed f2 ff ff       	call   800faa <sys_page_unmap>
  801cbd:	83 c4 10             	add    $0x10,%esp
}
  801cc0:	89 d8                	mov    %ebx,%eax
  801cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
	va = fd2data(fd0);
  801cc9:	83 ec 0c             	sub    $0xc,%esp
  801ccc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccf:	e8 71 f4 ff ff       	call   801145 <fd2data>
  801cd4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd6:	83 c4 0c             	add    $0xc,%esp
  801cd9:	68 07 04 00 00       	push   $0x407
  801cde:	50                   	push   %eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	e8 3f f2 ff ff       	call   800f25 <sys_page_alloc>
  801ce6:	89 c3                	mov    %eax,%ebx
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	0f 88 8c 00 00 00    	js     801d7f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf9:	e8 47 f4 ff ff       	call   801145 <fd2data>
  801cfe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d05:	50                   	push   %eax
  801d06:	6a 00                	push   $0x0
  801d08:	56                   	push   %esi
  801d09:	6a 00                	push   $0x0
  801d0b:	e8 58 f2 ff ff       	call   800f68 <sys_page_map>
  801d10:	89 c3                	mov    %eax,%ebx
  801d12:	83 c4 20             	add    $0x20,%esp
  801d15:	85 c0                	test   %eax,%eax
  801d17:	78 58                	js     801d71 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d22:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d31:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d37:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	ff 75 f4             	pushl  -0xc(%ebp)
  801d49:	e8 e7 f3 ff ff       	call   801135 <fd2num>
  801d4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d51:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d53:	83 c4 04             	add    $0x4,%esp
  801d56:	ff 75 f0             	pushl  -0x10(%ebp)
  801d59:	e8 d7 f3 ff ff       	call   801135 <fd2num>
  801d5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d61:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d6c:	e9 4f ff ff ff       	jmp    801cc0 <pipe+0x75>
	sys_page_unmap(0, va);
  801d71:	83 ec 08             	sub    $0x8,%esp
  801d74:	56                   	push   %esi
  801d75:	6a 00                	push   $0x0
  801d77:	e8 2e f2 ff ff       	call   800faa <sys_page_unmap>
  801d7c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d7f:	83 ec 08             	sub    $0x8,%esp
  801d82:	ff 75 f0             	pushl  -0x10(%ebp)
  801d85:	6a 00                	push   $0x0
  801d87:	e8 1e f2 ff ff       	call   800faa <sys_page_unmap>
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	e9 1c ff ff ff       	jmp    801cb0 <pipe+0x65>

00801d94 <pipeisclosed>:
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 05 f4 ff ff       	call   8011ab <fd_lookup>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	85 c0                	test   %eax,%eax
  801dab:	78 18                	js     801dc5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	ff 75 f4             	pushl  -0xc(%ebp)
  801db3:	e8 8d f3 ff ff       	call   801145 <fd2data>
	return _pipeisclosed(fd, p);
  801db8:	89 c2                	mov    %eax,%edx
  801dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbd:	e8 30 fd ff ff       	call   801af2 <_pipeisclosed>
  801dc2:	83 c4 10             	add    $0x10,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dcd:	68 ae 2a 80 00       	push   $0x802aae
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	e8 52 ed ff ff       	call   800b2c <strcpy>
	return 0;
}
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <devsock_close>:
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	53                   	push   %ebx
  801de5:	83 ec 10             	sub    $0x10,%esp
  801de8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801deb:	53                   	push   %ebx
  801dec:	e8 36 05 00 00       	call   802327 <pageref>
  801df1:	83 c4 10             	add    $0x10,%esp
		return 0;
  801df4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801df9:	83 f8 01             	cmp    $0x1,%eax
  801dfc:	74 07                	je     801e05 <devsock_close+0x24>
}
  801dfe:	89 d0                	mov    %edx,%eax
  801e00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	ff 73 0c             	pushl  0xc(%ebx)
  801e0b:	e8 b7 02 00 00       	call   8020c7 <nsipc_close>
  801e10:	89 c2                	mov    %eax,%edx
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	eb e7                	jmp    801dfe <devsock_close+0x1d>

00801e17 <devsock_write>:
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	ff 75 10             	pushl  0x10(%ebp)
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	ff 70 0c             	pushl  0xc(%eax)
  801e2b:	e8 74 03 00 00       	call   8021a4 <nsipc_send>
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <devsock_read>:
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	ff 75 10             	pushl  0x10(%ebp)
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	ff 70 0c             	pushl  0xc(%eax)
  801e46:	e8 ed 02 00 00       	call   802138 <nsipc_recv>
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <fd2sockid>:
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e53:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e56:	52                   	push   %edx
  801e57:	50                   	push   %eax
  801e58:	e8 4e f3 ff ff       	call   8011ab <fd_lookup>
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 10                	js     801e74 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e67:	8b 0d 58 30 80 00    	mov    0x803058,%ecx
  801e6d:	39 08                	cmp    %ecx,(%eax)
  801e6f:	75 05                	jne    801e76 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e71:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    
		return -E_NOT_SUPP;
  801e76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e7b:	eb f7                	jmp    801e74 <fd2sockid+0x27>

00801e7d <alloc_sockfd>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	56                   	push   %esi
  801e81:	53                   	push   %ebx
  801e82:	83 ec 1c             	sub    $0x1c,%esp
  801e85:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8a:	50                   	push   %eax
  801e8b:	e8 cc f2 ff ff       	call   80115c <fd_alloc>
  801e90:	89 c3                	mov    %eax,%ebx
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 43                	js     801edc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	68 07 04 00 00       	push   $0x407
  801ea1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea4:	6a 00                	push   $0x0
  801ea6:	e8 7a f0 ff ff       	call   800f25 <sys_page_alloc>
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	78 28                	js     801edc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801ebd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ec9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ecc:	83 ec 0c             	sub    $0xc,%esp
  801ecf:	50                   	push   %eax
  801ed0:	e8 60 f2 ff ff       	call   801135 <fd2num>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	eb 0c                	jmp    801ee8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	56                   	push   %esi
  801ee0:	e8 e2 01 00 00       	call   8020c7 <nsipc_close>
		return r;
  801ee5:	83 c4 10             	add    $0x10,%esp
}
  801ee8:	89 d8                	mov    %ebx,%eax
  801eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eed:	5b                   	pop    %ebx
  801eee:	5e                   	pop    %esi
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <accept>:
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	e8 4e ff ff ff       	call   801e4d <fd2sockid>
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 1b                	js     801f1e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	ff 75 10             	pushl  0x10(%ebp)
  801f09:	ff 75 0c             	pushl  0xc(%ebp)
  801f0c:	50                   	push   %eax
  801f0d:	e8 0e 01 00 00       	call   802020 <nsipc_accept>
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 05                	js     801f1e <accept+0x2d>
	return alloc_sockfd(r);
  801f19:	e8 5f ff ff ff       	call   801e7d <alloc_sockfd>
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <bind>:
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	e8 1f ff ff ff       	call   801e4d <fd2sockid>
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 12                	js     801f44 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	ff 75 10             	pushl  0x10(%ebp)
  801f38:	ff 75 0c             	pushl  0xc(%ebp)
  801f3b:	50                   	push   %eax
  801f3c:	e8 2f 01 00 00       	call   802070 <nsipc_bind>
  801f41:	83 c4 10             	add    $0x10,%esp
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <shutdown>:
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	e8 f9 fe ff ff       	call   801e4d <fd2sockid>
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 0f                	js     801f67 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f58:	83 ec 08             	sub    $0x8,%esp
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	50                   	push   %eax
  801f5f:	e8 41 01 00 00       	call   8020a5 <nsipc_shutdown>
  801f64:	83 c4 10             	add    $0x10,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <connect>:
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	e8 d6 fe ff ff       	call   801e4d <fd2sockid>
  801f77:	85 c0                	test   %eax,%eax
  801f79:	78 12                	js     801f8d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f7b:	83 ec 04             	sub    $0x4,%esp
  801f7e:	ff 75 10             	pushl  0x10(%ebp)
  801f81:	ff 75 0c             	pushl  0xc(%ebp)
  801f84:	50                   	push   %eax
  801f85:	e8 57 01 00 00       	call   8020e1 <nsipc_connect>
  801f8a:	83 c4 10             	add    $0x10,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <listen>:
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	e8 b0 fe ff ff       	call   801e4d <fd2sockid>
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	78 0f                	js     801fb0 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fa1:	83 ec 08             	sub    $0x8,%esp
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	50                   	push   %eax
  801fa8:	e8 69 01 00 00       	call   802116 <nsipc_listen>
  801fad:	83 c4 10             	add    $0x10,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fb8:	ff 75 10             	pushl  0x10(%ebp)
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	ff 75 08             	pushl  0x8(%ebp)
  801fc1:	e8 3c 02 00 00       	call   802202 <nsipc_socket>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	78 05                	js     801fd2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fcd:	e8 ab fe ff ff       	call   801e7d <alloc_sockfd>
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	53                   	push   %ebx
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fdd:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801fe4:	74 26                	je     80200c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fe6:	6a 07                	push   $0x7
  801fe8:	68 00 60 80 00       	push   $0x806000
  801fed:	53                   	push   %ebx
  801fee:	ff 35 04 44 80 00    	pushl  0x804404
  801ff4:	e8 9c 02 00 00       	call   802295 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ff9:	83 c4 0c             	add    $0xc,%esp
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	e8 25 02 00 00       	call   80222c <ipc_recv>
}
  802007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	6a 02                	push   $0x2
  802011:	e8 d8 02 00 00       	call   8022ee <ipc_find_env>
  802016:	a3 04 44 80 00       	mov    %eax,0x804404
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	eb c6                	jmp    801fe6 <nsipc+0x12>

00802020 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	56                   	push   %esi
  802024:	53                   	push   %ebx
  802025:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802030:	8b 06                	mov    (%esi),%eax
  802032:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802037:	b8 01 00 00 00       	mov    $0x1,%eax
  80203c:	e8 93 ff ff ff       	call   801fd4 <nsipc>
  802041:	89 c3                	mov    %eax,%ebx
  802043:	85 c0                	test   %eax,%eax
  802045:	78 20                	js     802067 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	ff 35 10 60 80 00    	pushl  0x806010
  802050:	68 00 60 80 00       	push   $0x806000
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	e8 5d ec ff ff       	call   800cba <memmove>
		*addrlen = ret->ret_addrlen;
  80205d:	a1 10 60 80 00       	mov    0x806010,%eax
  802062:	89 06                	mov    %eax,(%esi)
  802064:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802067:	89 d8                	mov    %ebx,%eax
  802069:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206c:	5b                   	pop    %ebx
  80206d:	5e                   	pop    %esi
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    

00802070 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	53                   	push   %ebx
  802074:	83 ec 08             	sub    $0x8,%esp
  802077:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802082:	53                   	push   %ebx
  802083:	ff 75 0c             	pushl  0xc(%ebp)
  802086:	68 04 60 80 00       	push   $0x806004
  80208b:	e8 2a ec ff ff       	call   800cba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802090:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802096:	b8 02 00 00 00       	mov    $0x2,%eax
  80209b:	e8 34 ff ff ff       	call   801fd4 <nsipc>
}
  8020a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8020b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8020bb:	b8 03 00 00 00       	mov    $0x3,%eax
  8020c0:	e8 0f ff ff ff       	call   801fd4 <nsipc>
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <nsipc_close>:

int
nsipc_close(int s)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8020d5:	b8 04 00 00 00       	mov    $0x4,%eax
  8020da:	e8 f5 fe ff ff       	call   801fd4 <nsipc>
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	53                   	push   %ebx
  8020e5:	83 ec 08             	sub    $0x8,%esp
  8020e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020f3:	53                   	push   %ebx
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	68 04 60 80 00       	push   $0x806004
  8020fc:	e8 b9 eb ff ff       	call   800cba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802101:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802107:	b8 05 00 00 00       	mov    $0x5,%eax
  80210c:	e8 c3 fe ff ff       	call   801fd4 <nsipc>
}
  802111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802124:	8b 45 0c             	mov    0xc(%ebp),%eax
  802127:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80212c:	b8 06 00 00 00       	mov    $0x6,%eax
  802131:	e8 9e fe ff ff       	call   801fd4 <nsipc>
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	56                   	push   %esi
  80213c:	53                   	push   %ebx
  80213d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802148:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80214e:	8b 45 14             	mov    0x14(%ebp),%eax
  802151:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802156:	b8 07 00 00 00       	mov    $0x7,%eax
  80215b:	e8 74 fe ff ff       	call   801fd4 <nsipc>
  802160:	89 c3                	mov    %eax,%ebx
  802162:	85 c0                	test   %eax,%eax
  802164:	78 1f                	js     802185 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802166:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80216b:	7f 21                	jg     80218e <nsipc_recv+0x56>
  80216d:	39 c6                	cmp    %eax,%esi
  80216f:	7c 1d                	jl     80218e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	50                   	push   %eax
  802175:	68 00 60 80 00       	push   $0x806000
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	e8 38 eb ff ff       	call   800cba <memmove>
  802182:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802185:	89 d8                	mov    %ebx,%eax
  802187:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218a:	5b                   	pop    %ebx
  80218b:	5e                   	pop    %esi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80218e:	68 ba 2a 80 00       	push   $0x802aba
  802193:	68 5c 2a 80 00       	push   $0x802a5c
  802198:	6a 62                	push   $0x62
  80219a:	68 cf 2a 80 00       	push   $0x802acf
  80219f:	e8 20 e1 ff ff       	call   8002c4 <_panic>

008021a4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	53                   	push   %ebx
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021b6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021bc:	7f 2e                	jg     8021ec <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	53                   	push   %ebx
  8021c2:	ff 75 0c             	pushl  0xc(%ebp)
  8021c5:	68 0c 60 80 00       	push   $0x80600c
  8021ca:	e8 eb ea ff ff       	call   800cba <memmove>
	nsipcbuf.send.req_size = size;
  8021cf:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8021d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8021dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8021e2:	e8 ed fd ff ff       	call   801fd4 <nsipc>
}
  8021e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    
	assert(size < 1600);
  8021ec:	68 db 2a 80 00       	push   $0x802adb
  8021f1:	68 5c 2a 80 00       	push   $0x802a5c
  8021f6:	6a 6d                	push   $0x6d
  8021f8:	68 cf 2a 80 00       	push   $0x802acf
  8021fd:	e8 c2 e0 ff ff       	call   8002c4 <_panic>

00802202 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802218:	8b 45 10             	mov    0x10(%ebp),%eax
  80221b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802220:	b8 09 00 00 00       	mov    $0x9,%eax
  802225:	e8 aa fd ff ff       	call   801fd4 <nsipc>
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	56                   	push   %esi
  802230:	53                   	push   %ebx
  802231:	8b 75 08             	mov    0x8(%ebp),%esi
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80223a:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  80223c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802241:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802244:	83 ec 0c             	sub    $0xc,%esp
  802247:	50                   	push   %eax
  802248:	e8 88 ee ff ff       	call   8010d5 <sys_ipc_recv>
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	85 c0                	test   %eax,%eax
  802252:	78 2b                	js     80227f <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802254:	85 f6                	test   %esi,%esi
  802256:	74 0a                	je     802262 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802258:	a1 08 44 80 00       	mov    0x804408,%eax
  80225d:	8b 40 74             	mov    0x74(%eax),%eax
  802260:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802262:	85 db                	test   %ebx,%ebx
  802264:	74 0a                	je     802270 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802266:	a1 08 44 80 00       	mov    0x804408,%eax
  80226b:	8b 40 78             	mov    0x78(%eax),%eax
  80226e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802270:	a1 08 44 80 00       	mov    0x804408,%eax
  802275:	8b 40 70             	mov    0x70(%eax),%eax
}
  802278:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227b:	5b                   	pop    %ebx
  80227c:	5e                   	pop    %esi
  80227d:	5d                   	pop    %ebp
  80227e:	c3                   	ret    
	    if (from_env_store != NULL) {
  80227f:	85 f6                	test   %esi,%esi
  802281:	74 06                	je     802289 <ipc_recv+0x5d>
	        *from_env_store = 0;
  802283:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802289:	85 db                	test   %ebx,%ebx
  80228b:	74 eb                	je     802278 <ipc_recv+0x4c>
	        *perm_store = 0;
  80228d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802293:	eb e3                	jmp    802278 <ipc_recv+0x4c>

00802295 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	57                   	push   %edi
  802299:	56                   	push   %esi
  80229a:	53                   	push   %ebx
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022a1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8022a4:	85 f6                	test   %esi,%esi
  8022a6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022ab:	0f 44 f0             	cmove  %eax,%esi
  8022ae:	eb 09                	jmp    8022b9 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8022b0:	e8 51 ec ff ff       	call   800f06 <sys_yield>
	} while(r != 0);
  8022b5:	85 db                	test   %ebx,%ebx
  8022b7:	74 2d                	je     8022e6 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8022b9:	ff 75 14             	pushl  0x14(%ebp)
  8022bc:	56                   	push   %esi
  8022bd:	ff 75 0c             	pushl  0xc(%ebp)
  8022c0:	57                   	push   %edi
  8022c1:	e8 ec ed ff ff       	call   8010b2 <sys_ipc_try_send>
  8022c6:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	79 e1                	jns    8022b0 <ipc_send+0x1b>
  8022cf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022d2:	74 dc                	je     8022b0 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8022d4:	50                   	push   %eax
  8022d5:	68 e7 2a 80 00       	push   $0x802ae7
  8022da:	6a 45                	push   $0x45
  8022dc:	68 f4 2a 80 00       	push   $0x802af4
  8022e1:	e8 de df ff ff       	call   8002c4 <_panic>
}
  8022e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e9:	5b                   	pop    %ebx
  8022ea:	5e                   	pop    %esi
  8022eb:	5f                   	pop    %edi
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    

008022ee <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022f4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022f9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022fc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802302:	8b 52 50             	mov    0x50(%edx),%edx
  802305:	39 ca                	cmp    %ecx,%edx
  802307:	74 11                	je     80231a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802309:	83 c0 01             	add    $0x1,%eax
  80230c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802311:	75 e6                	jne    8022f9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	eb 0b                	jmp    802325 <ipc_find_env+0x37>
			return envs[i].env_id;
  80231a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80231d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802322:	8b 40 48             	mov    0x48(%eax),%eax
}
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    

00802327 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80232d:	89 d0                	mov    %edx,%eax
  80232f:	c1 e8 16             	shr    $0x16,%eax
  802332:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80233e:	f6 c1 01             	test   $0x1,%cl
  802341:	74 1d                	je     802360 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802343:	c1 ea 0c             	shr    $0xc,%edx
  802346:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80234d:	f6 c2 01             	test   $0x1,%dl
  802350:	74 0e                	je     802360 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802352:	c1 ea 0c             	shr    $0xc,%edx
  802355:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80235c:	ef 
  80235d:	0f b7 c0             	movzwl %ax,%eax
}
  802360:	5d                   	pop    %ebp
  802361:	c3                   	ret    
  802362:	66 90                	xchg   %ax,%ax
  802364:	66 90                	xchg   %ax,%ax
  802366:	66 90                	xchg   %ax,%ax
  802368:	66 90                	xchg   %ax,%ax
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <__udivdi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80237b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80237f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802383:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802387:	85 d2                	test   %edx,%edx
  802389:	75 35                	jne    8023c0 <__udivdi3+0x50>
  80238b:	39 f3                	cmp    %esi,%ebx
  80238d:	0f 87 bd 00 00 00    	ja     802450 <__udivdi3+0xe0>
  802393:	85 db                	test   %ebx,%ebx
  802395:	89 d9                	mov    %ebx,%ecx
  802397:	75 0b                	jne    8023a4 <__udivdi3+0x34>
  802399:	b8 01 00 00 00       	mov    $0x1,%eax
  80239e:	31 d2                	xor    %edx,%edx
  8023a0:	f7 f3                	div    %ebx
  8023a2:	89 c1                	mov    %eax,%ecx
  8023a4:	31 d2                	xor    %edx,%edx
  8023a6:	89 f0                	mov    %esi,%eax
  8023a8:	f7 f1                	div    %ecx
  8023aa:	89 c6                	mov    %eax,%esi
  8023ac:	89 e8                	mov    %ebp,%eax
  8023ae:	89 f7                	mov    %esi,%edi
  8023b0:	f7 f1                	div    %ecx
  8023b2:	89 fa                	mov    %edi,%edx
  8023b4:	83 c4 1c             	add    $0x1c,%esp
  8023b7:	5b                   	pop    %ebx
  8023b8:	5e                   	pop    %esi
  8023b9:	5f                   	pop    %edi
  8023ba:	5d                   	pop    %ebp
  8023bb:	c3                   	ret    
  8023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c0:	39 f2                	cmp    %esi,%edx
  8023c2:	77 7c                	ja     802440 <__udivdi3+0xd0>
  8023c4:	0f bd fa             	bsr    %edx,%edi
  8023c7:	83 f7 1f             	xor    $0x1f,%edi
  8023ca:	0f 84 98 00 00 00    	je     802468 <__udivdi3+0xf8>
  8023d0:	89 f9                	mov    %edi,%ecx
  8023d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d7:	29 f8                	sub    %edi,%eax
  8023d9:	d3 e2                	shl    %cl,%edx
  8023db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 da                	mov    %ebx,%edx
  8023e3:	d3 ea                	shr    %cl,%edx
  8023e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e9:	09 d1                	or     %edx,%ecx
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f9                	mov    %edi,%ecx
  8023f3:	d3 e3                	shl    %cl,%ebx
  8023f5:	89 c1                	mov    %eax,%ecx
  8023f7:	d3 ea                	shr    %cl,%edx
  8023f9:	89 f9                	mov    %edi,%ecx
  8023fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ff:	d3 e6                	shl    %cl,%esi
  802401:	89 eb                	mov    %ebp,%ebx
  802403:	89 c1                	mov    %eax,%ecx
  802405:	d3 eb                	shr    %cl,%ebx
  802407:	09 de                	or     %ebx,%esi
  802409:	89 f0                	mov    %esi,%eax
  80240b:	f7 74 24 08          	divl   0x8(%esp)
  80240f:	89 d6                	mov    %edx,%esi
  802411:	89 c3                	mov    %eax,%ebx
  802413:	f7 64 24 0c          	mull   0xc(%esp)
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 0c                	jb     802427 <__udivdi3+0xb7>
  80241b:	89 f9                	mov    %edi,%ecx
  80241d:	d3 e5                	shl    %cl,%ebp
  80241f:	39 c5                	cmp    %eax,%ebp
  802421:	73 5d                	jae    802480 <__udivdi3+0x110>
  802423:	39 d6                	cmp    %edx,%esi
  802425:	75 59                	jne    802480 <__udivdi3+0x110>
  802427:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80242a:	31 ff                	xor    %edi,%edi
  80242c:	89 fa                	mov    %edi,%edx
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d 76 00             	lea    0x0(%esi),%esi
  802439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802440:	31 ff                	xor    %edi,%edi
  802442:	31 c0                	xor    %eax,%eax
  802444:	89 fa                	mov    %edi,%edx
  802446:	83 c4 1c             	add    $0x1c,%esp
  802449:	5b                   	pop    %ebx
  80244a:	5e                   	pop    %esi
  80244b:	5f                   	pop    %edi
  80244c:	5d                   	pop    %ebp
  80244d:	c3                   	ret    
  80244e:	66 90                	xchg   %ax,%ax
  802450:	31 ff                	xor    %edi,%edi
  802452:	89 e8                	mov    %ebp,%eax
  802454:	89 f2                	mov    %esi,%edx
  802456:	f7 f3                	div    %ebx
  802458:	89 fa                	mov    %edi,%edx
  80245a:	83 c4 1c             	add    $0x1c,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    
  802462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802468:	39 f2                	cmp    %esi,%edx
  80246a:	72 06                	jb     802472 <__udivdi3+0x102>
  80246c:	31 c0                	xor    %eax,%eax
  80246e:	39 eb                	cmp    %ebp,%ebx
  802470:	77 d2                	ja     802444 <__udivdi3+0xd4>
  802472:	b8 01 00 00 00       	mov    $0x1,%eax
  802477:	eb cb                	jmp    802444 <__udivdi3+0xd4>
  802479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802480:	89 d8                	mov    %ebx,%eax
  802482:	31 ff                	xor    %edi,%edi
  802484:	eb be                	jmp    802444 <__udivdi3+0xd4>
  802486:	66 90                	xchg   %ax,%ax
  802488:	66 90                	xchg   %ax,%ax
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__umoddi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	53                   	push   %ebx
  802494:	83 ec 1c             	sub    $0x1c,%esp
  802497:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80249b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80249f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024a7:	85 ed                	test   %ebp,%ebp
  8024a9:	89 f0                	mov    %esi,%eax
  8024ab:	89 da                	mov    %ebx,%edx
  8024ad:	75 19                	jne    8024c8 <__umoddi3+0x38>
  8024af:	39 df                	cmp    %ebx,%edi
  8024b1:	0f 86 b1 00 00 00    	jbe    802568 <__umoddi3+0xd8>
  8024b7:	f7 f7                	div    %edi
  8024b9:	89 d0                	mov    %edx,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	83 c4 1c             	add    $0x1c,%esp
  8024c0:	5b                   	pop    %ebx
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	39 dd                	cmp    %ebx,%ebp
  8024ca:	77 f1                	ja     8024bd <__umoddi3+0x2d>
  8024cc:	0f bd cd             	bsr    %ebp,%ecx
  8024cf:	83 f1 1f             	xor    $0x1f,%ecx
  8024d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024d6:	0f 84 b4 00 00 00    	je     802590 <__umoddi3+0x100>
  8024dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8024e1:	89 c2                	mov    %eax,%edx
  8024e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024e7:	29 c2                	sub    %eax,%edx
  8024e9:	89 c1                	mov    %eax,%ecx
  8024eb:	89 f8                	mov    %edi,%eax
  8024ed:	d3 e5                	shl    %cl,%ebp
  8024ef:	89 d1                	mov    %edx,%ecx
  8024f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024f5:	d3 e8                	shr    %cl,%eax
  8024f7:	09 c5                	or     %eax,%ebp
  8024f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024fd:	89 c1                	mov    %eax,%ecx
  8024ff:	d3 e7                	shl    %cl,%edi
  802501:	89 d1                	mov    %edx,%ecx
  802503:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802507:	89 df                	mov    %ebx,%edi
  802509:	d3 ef                	shr    %cl,%edi
  80250b:	89 c1                	mov    %eax,%ecx
  80250d:	89 f0                	mov    %esi,%eax
  80250f:	d3 e3                	shl    %cl,%ebx
  802511:	89 d1                	mov    %edx,%ecx
  802513:	89 fa                	mov    %edi,%edx
  802515:	d3 e8                	shr    %cl,%eax
  802517:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	f7 f5                	div    %ebp
  802520:	d3 e6                	shl    %cl,%esi
  802522:	89 d1                	mov    %edx,%ecx
  802524:	f7 64 24 08          	mull   0x8(%esp)
  802528:	39 d1                	cmp    %edx,%ecx
  80252a:	89 c3                	mov    %eax,%ebx
  80252c:	89 d7                	mov    %edx,%edi
  80252e:	72 06                	jb     802536 <__umoddi3+0xa6>
  802530:	75 0e                	jne    802540 <__umoddi3+0xb0>
  802532:	39 c6                	cmp    %eax,%esi
  802534:	73 0a                	jae    802540 <__umoddi3+0xb0>
  802536:	2b 44 24 08          	sub    0x8(%esp),%eax
  80253a:	19 ea                	sbb    %ebp,%edx
  80253c:	89 d7                	mov    %edx,%edi
  80253e:	89 c3                	mov    %eax,%ebx
  802540:	89 ca                	mov    %ecx,%edx
  802542:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802547:	29 de                	sub    %ebx,%esi
  802549:	19 fa                	sbb    %edi,%edx
  80254b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80254f:	89 d0                	mov    %edx,%eax
  802551:	d3 e0                	shl    %cl,%eax
  802553:	89 d9                	mov    %ebx,%ecx
  802555:	d3 ee                	shr    %cl,%esi
  802557:	d3 ea                	shr    %cl,%edx
  802559:	09 f0                	or     %esi,%eax
  80255b:	83 c4 1c             	add    $0x1c,%esp
  80255e:	5b                   	pop    %ebx
  80255f:	5e                   	pop    %esi
  802560:	5f                   	pop    %edi
  802561:	5d                   	pop    %ebp
  802562:	c3                   	ret    
  802563:	90                   	nop
  802564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802568:	85 ff                	test   %edi,%edi
  80256a:	89 f9                	mov    %edi,%ecx
  80256c:	75 0b                	jne    802579 <__umoddi3+0xe9>
  80256e:	b8 01 00 00 00       	mov    $0x1,%eax
  802573:	31 d2                	xor    %edx,%edx
  802575:	f7 f7                	div    %edi
  802577:	89 c1                	mov    %eax,%ecx
  802579:	89 d8                	mov    %ebx,%eax
  80257b:	31 d2                	xor    %edx,%edx
  80257d:	f7 f1                	div    %ecx
  80257f:	89 f0                	mov    %esi,%eax
  802581:	f7 f1                	div    %ecx
  802583:	e9 31 ff ff ff       	jmp    8024b9 <__umoddi3+0x29>
  802588:	90                   	nop
  802589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802590:	39 dd                	cmp    %ebx,%ebp
  802592:	72 08                	jb     80259c <__umoddi3+0x10c>
  802594:	39 f7                	cmp    %esi,%edi
  802596:	0f 87 21 ff ff ff    	ja     8024bd <__umoddi3+0x2d>
  80259c:	89 da                	mov    %ebx,%edx
  80259e:	89 f0                	mov    %esi,%eax
  8025a0:	29 f8                	sub    %edi,%eax
  8025a2:	19 ea                	sbb    %ebp,%edx
  8025a4:	e9 14 ff ff ff       	jmp    8024bd <__umoddi3+0x2d>
