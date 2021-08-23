
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 97 02 00 00       	call   8002c8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 02 28 80 00       	push   $0x802802
  80005f:	e8 c8 1a 00 00       	call   801b2c <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 68 28 80 00       	mov    $0x802868,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 0b 28 80 00       	push   $0x80280b
  80007f:	e8 a8 1a 00 00       	call   801b2c <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 be 2c 80 00       	push   $0x802cbe
  800092:	e8 95 1a 00 00       	call   801b2c <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 67 28 80 00       	push   $0x802867
  8000b1:	e8 76 1a 00 00       	call   801b2c <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 a0 09 00 00       	call   800a69 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 00 28 80 00       	mov    $0x802800,%eax
  8000d6:	ba 68 28 80 00       	mov    $0x802868,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 00 28 80 00       	push   $0x802800
  8000e8:	e8 3f 1a 00 00       	call   801b2c <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 7f 18 00 00       	call   801988 <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 44 14 00 00       	call   80156b <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 10 28 80 00       	push   $0x802810
  800166:	6a 1d                	push   $0x1d
  800168:	68 1c 28 80 00       	push   $0x80281c
  80016d:	e8 b6 01 00 00       	call   800328 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0c                	jg     800182 <lsdir+0x90>
	if (n < 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	78 1a                	js     800194 <lsdir+0xa2>
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("short read in directory %s", path);
  800182:	57                   	push   %edi
  800183:	68 26 28 80 00       	push   $0x802826
  800188:	6a 22                	push   $0x22
  80018a:	68 1c 28 80 00       	push   $0x80281c
  80018f:	e8 94 01 00 00       	call   800328 <_panic>
		panic("error reading directory %s: %e", path, n);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	57                   	push   %edi
  800199:	68 6c 28 80 00       	push   $0x80286c
  80019e:	6a 24                	push   $0x24
  8001a0:	68 1c 28 80 00       	push   $0x80281c
  8001a5:	e8 7e 01 00 00       	call   800328 <_panic>

008001aa <ls>:
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	53                   	push   %ebx
  8001ae:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b7:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bd:	50                   	push   %eax
  8001be:	53                   	push   %ebx
  8001bf:	e8 8c 15 00 00       	call   801750 <stat>
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	78 2c                	js     8001f7 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	74 09                	je     8001db <ls+0x31>
  8001d2:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001d9:	74 32                	je     80020d <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001db:	53                   	push   %ebx
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	85 c0                	test   %eax,%eax
  8001e1:	0f 95 c0             	setne  %al
  8001e4:	0f b6 c0             	movzbl %al,%eax
  8001e7:	50                   	push   %eax
  8001e8:	6a 00                	push   $0x0
  8001ea:	e8 44 fe ff ff       	call   800033 <ls1>
  8001ef:	83 c4 10             	add    $0x10,%esp
}
  8001f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	50                   	push   %eax
  8001fb:	53                   	push   %ebx
  8001fc:	68 41 28 80 00       	push   $0x802841
  800201:	6a 0f                	push   $0xf
  800203:	68 1c 28 80 00       	push   $0x80281c
  800208:	e8 1b 01 00 00       	call   800328 <_panic>
		lsdir(path, prefix);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	53                   	push   %ebx
  800214:	e8 d9 fe ff ff       	call   8000f2 <lsdir>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb d4                	jmp    8001f2 <ls+0x48>

0080021e <usage>:

void
usage(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800224:	68 4d 28 80 00       	push   $0x80284d
  800229:	e8 fe 18 00 00       	call   801b2c <printf>
	exit();
  80022e:	e8 db 00 00 00       	call   80030e <exit>
}
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	c9                   	leave  
  800237:	c3                   	ret    

00800238 <umain>:

void
umain(int argc, char **argv)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 14             	sub    $0x14,%esp
  800240:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800243:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800246:	50                   	push   %eax
  800247:	56                   	push   %esi
  800248:	8d 45 08             	lea    0x8(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 58 0e 00 00       	call   8010a9 <argstart>
	while ((i = argnext(&args)) >= 0)
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800257:	eb 08                	jmp    800261 <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800259:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  800260:	01 
	while ((i = argnext(&args)) >= 0)
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	53                   	push   %ebx
  800265:	e8 6f 0e 00 00       	call   8010d9 <argnext>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	85 c0                	test   %eax,%eax
  80026f:	78 16                	js     800287 <umain+0x4f>
		switch (i) {
  800271:	83 f8 64             	cmp    $0x64,%eax
  800274:	74 e3                	je     800259 <umain+0x21>
  800276:	83 f8 6c             	cmp    $0x6c,%eax
  800279:	74 de                	je     800259 <umain+0x21>
  80027b:	83 f8 46             	cmp    $0x46,%eax
  80027e:	74 d9                	je     800259 <umain+0x21>
			break;
		default:
			usage();
  800280:	e8 99 ff ff ff       	call   80021e <usage>
  800285:	eb da                	jmp    800261 <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800287:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800290:	75 2a                	jne    8002bc <umain+0x84>
		ls("/", "");
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 68 28 80 00       	push   $0x802868
  80029a:	68 00 28 80 00       	push   $0x802800
  80029f:	e8 06 ff ff ff       	call   8001aa <ls>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	eb 18                	jmp    8002c1 <umain+0x89>
			ls(argv[i], argv[i]);
  8002a9:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	50                   	push   %eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 f4 fe ff ff       	call   8001aa <ls>
		for (i = 1; i < argc; i++)
  8002b6:	83 c3 01             	add    $0x1,%ebx
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bf:	7f e8                	jg     8002a9 <umain+0x71>
	}
}
  8002c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8002d3:	e8 83 0b 00 00       	call   800e5b <sys_getenvid>
  8002d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ea:	85 db                	test   %ebx,%ebx
  8002ec:	7e 07                	jle    8002f5 <libmain+0x2d>
		binaryname = argv[0];
  8002ee:	8b 06                	mov    (%esi),%eax
  8002f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	e8 39 ff ff ff       	call   800238 <umain>

	// exit gracefully
	exit();
  8002ff:	e8 0a 00 00 00       	call   80030e <exit>
}
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800314:	e8 ba 10 00 00       	call   8013d3 <close_all>
	sys_env_destroy(0);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	6a 00                	push   $0x0
  80031e:	e8 f7 0a 00 00       	call   800e1a <sys_env_destroy>
}
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80032d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800330:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800336:	e8 20 0b 00 00       	call   800e5b <sys_getenvid>
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	56                   	push   %esi
  800345:	50                   	push   %eax
  800346:	68 98 28 80 00       	push   $0x802898
  80034b:	e8 b3 00 00 00       	call   800403 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	53                   	push   %ebx
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	e8 56 00 00 00       	call   8003b2 <vcprintf>
	cprintf("\n");
  80035c:	c7 04 24 67 28 80 00 	movl   $0x802867,(%esp)
  800363:	e8 9b 00 00 00       	call   800403 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036b:	cc                   	int3   
  80036c:	eb fd                	jmp    80036b <_panic+0x43>

0080036e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	53                   	push   %ebx
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800378:	8b 13                	mov    (%ebx),%edx
  80037a:	8d 42 01             	lea    0x1(%edx),%eax
  80037d:	89 03                	mov    %eax,(%ebx)
  80037f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800382:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800386:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038b:	74 09                	je     800396 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80038d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800394:	c9                   	leave  
  800395:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	68 ff 00 00 00       	push   $0xff
  80039e:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a1:	50                   	push   %eax
  8003a2:	e8 36 0a 00 00       	call   800ddd <sys_cputs>
		b->idx = 0;
  8003a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb db                	jmp    80038d <putch+0x1f>

008003b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c2:	00 00 00 
	b.cnt = 0;
  8003c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003cc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	ff 75 08             	pushl  0x8(%ebp)
  8003d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003db:	50                   	push   %eax
  8003dc:	68 6e 03 80 00       	push   $0x80036e
  8003e1:	e8 1a 01 00 00       	call   800500 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e6:	83 c4 08             	add    $0x8,%esp
  8003e9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003ef:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f5:	50                   	push   %eax
  8003f6:	e8 e2 09 00 00       	call   800ddd <sys_cputs>

	return b.cnt;
}
  8003fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800409:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 08             	pushl  0x8(%ebp)
  800410:	e8 9d ff ff ff       	call   8003b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	57                   	push   %edi
  80041b:	56                   	push   %esi
  80041c:	53                   	push   %ebx
  80041d:	83 ec 1c             	sub    $0x1c,%esp
  800420:	89 c7                	mov    %eax,%edi
  800422:	89 d6                	mov    %edx,%esi
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800433:	bb 00 00 00 00       	mov    $0x0,%ebx
  800438:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80043b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80043e:	39 d3                	cmp    %edx,%ebx
  800440:	72 05                	jb     800447 <printnum+0x30>
  800442:	39 45 10             	cmp    %eax,0x10(%ebp)
  800445:	77 7a                	ja     8004c1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	ff 75 18             	pushl  0x18(%ebp)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800453:	53                   	push   %ebx
  800454:	ff 75 10             	pushl  0x10(%ebp)
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80045d:	ff 75 e0             	pushl  -0x20(%ebp)
  800460:	ff 75 dc             	pushl  -0x24(%ebp)
  800463:	ff 75 d8             	pushl  -0x28(%ebp)
  800466:	e8 45 21 00 00       	call   8025b0 <__udivdi3>
  80046b:	83 c4 18             	add    $0x18,%esp
  80046e:	52                   	push   %edx
  80046f:	50                   	push   %eax
  800470:	89 f2                	mov    %esi,%edx
  800472:	89 f8                	mov    %edi,%eax
  800474:	e8 9e ff ff ff       	call   800417 <printnum>
  800479:	83 c4 20             	add    $0x20,%esp
  80047c:	eb 13                	jmp    800491 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	56                   	push   %esi
  800482:	ff 75 18             	pushl  0x18(%ebp)
  800485:	ff d7                	call   *%edi
  800487:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80048a:	83 eb 01             	sub    $0x1,%ebx
  80048d:	85 db                	test   %ebx,%ebx
  80048f:	7f ed                	jg     80047e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	56                   	push   %esi
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049b:	ff 75 e0             	pushl  -0x20(%ebp)
  80049e:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a4:	e8 27 22 00 00       	call   8026d0 <__umoddi3>
  8004a9:	83 c4 14             	add    $0x14,%esp
  8004ac:	0f be 80 bb 28 80 00 	movsbl 0x8028bb(%eax),%eax
  8004b3:	50                   	push   %eax
  8004b4:	ff d7                	call   *%edi
}
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bc:	5b                   	pop    %ebx
  8004bd:	5e                   	pop    %esi
  8004be:	5f                   	pop    %edi
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    
  8004c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004c4:	eb c4                	jmp    80048a <printnum+0x73>

008004c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d0:	8b 10                	mov    (%eax),%edx
  8004d2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d5:	73 0a                	jae    8004e1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004da:	89 08                	mov    %ecx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	88 02                	mov    %al,(%edx)
}
  8004e1:	5d                   	pop    %ebp
  8004e2:	c3                   	ret    

008004e3 <printfmt>:
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ec:	50                   	push   %eax
  8004ed:	ff 75 10             	pushl  0x10(%ebp)
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	ff 75 08             	pushl  0x8(%ebp)
  8004f6:	e8 05 00 00 00       	call   800500 <vprintfmt>
}
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <vprintfmt>:
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	57                   	push   %edi
  800504:	56                   	push   %esi
  800505:	53                   	push   %ebx
  800506:	83 ec 2c             	sub    $0x2c,%esp
  800509:	8b 75 08             	mov    0x8(%ebp),%esi
  80050c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800512:	e9 21 04 00 00       	jmp    800938 <vprintfmt+0x438>
		padc = ' ';
  800517:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80051b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800522:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800529:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800530:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8d 47 01             	lea    0x1(%edi),%eax
  800538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053b:	0f b6 17             	movzbl (%edi),%edx
  80053e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800541:	3c 55                	cmp    $0x55,%al
  800543:	0f 87 90 04 00 00    	ja     8009d9 <vprintfmt+0x4d9>
  800549:	0f b6 c0             	movzbl %al,%eax
  80054c:	ff 24 85 00 2a 80 00 	jmp    *0x802a00(,%eax,4)
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800556:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80055a:	eb d9                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80055f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800563:	eb d0                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800565:	0f b6 d2             	movzbl %dl,%edx
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80056b:	b8 00 00 00 00       	mov    $0x0,%eax
  800570:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800573:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800576:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80057a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80057d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800580:	83 f9 09             	cmp    $0x9,%ecx
  800583:	77 55                	ja     8005da <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800585:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800588:	eb e9                	jmp    800573 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80059e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a2:	79 91                	jns    800535 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005b1:	eb 82                	jmp    800535 <vprintfmt+0x35>
  8005b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b6:	85 c0                	test   %eax,%eax
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bd:	0f 49 d0             	cmovns %eax,%edx
  8005c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c6:	e9 6a ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ce:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005d5:	e9 5b ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e0:	eb bc                	jmp    80059e <vprintfmt+0x9e>
			lflag++;
  8005e2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005e8:	e9 48 ff ff ff       	jmp    800535 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 78 04             	lea    0x4(%eax),%edi
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	ff 30                	pushl  (%eax)
  8005f9:	ff d6                	call   *%esi
			break;
  8005fb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005fe:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800601:	e9 2f 03 00 00       	jmp    800935 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 78 04             	lea    0x4(%eax),%edi
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	99                   	cltd   
  80060f:	31 d0                	xor    %edx,%eax
  800611:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800613:	83 f8 0f             	cmp    $0xf,%eax
  800616:	7f 23                	jg     80063b <vprintfmt+0x13b>
  800618:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  80061f:	85 d2                	test   %edx,%edx
  800621:	74 18                	je     80063b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800623:	52                   	push   %edx
  800624:	68 be 2c 80 00       	push   $0x802cbe
  800629:	53                   	push   %ebx
  80062a:	56                   	push   %esi
  80062b:	e8 b3 fe ff ff       	call   8004e3 <printfmt>
  800630:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800633:	89 7d 14             	mov    %edi,0x14(%ebp)
  800636:	e9 fa 02 00 00       	jmp    800935 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80063b:	50                   	push   %eax
  80063c:	68 d3 28 80 00       	push   $0x8028d3
  800641:	53                   	push   %ebx
  800642:	56                   	push   %esi
  800643:	e8 9b fe ff ff       	call   8004e3 <printfmt>
  800648:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80064b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80064e:	e9 e2 02 00 00       	jmp    800935 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 c0 04             	add    $0x4,%eax
  800659:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800661:	85 ff                	test   %edi,%edi
  800663:	b8 cc 28 80 00       	mov    $0x8028cc,%eax
  800668:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80066b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066f:	0f 8e bd 00 00 00    	jle    800732 <vprintfmt+0x232>
  800675:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800679:	75 0e                	jne    800689 <vprintfmt+0x189>
  80067b:	89 75 08             	mov    %esi,0x8(%ebp)
  80067e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800681:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800684:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800687:	eb 6d                	jmp    8006f6 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 d0             	pushl  -0x30(%ebp)
  80068f:	57                   	push   %edi
  800690:	e8 ec 03 00 00       	call   800a81 <strnlen>
  800695:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800698:	29 c1                	sub    %eax,%ecx
  80069a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80069d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006a0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006aa:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ac:	eb 0f                	jmp    8006bd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	53                   	push   %ebx
  8006b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b7:	83 ef 01             	sub    $0x1,%edi
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	85 ff                	test   %edi,%edi
  8006bf:	7f ed                	jg     8006ae <vprintfmt+0x1ae>
  8006c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006c4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006c7:	85 c9                	test   %ecx,%ecx
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	0f 49 c1             	cmovns %ecx,%eax
  8006d1:	29 c1                	sub    %eax,%ecx
  8006d3:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006dc:	89 cb                	mov    %ecx,%ebx
  8006de:	eb 16                	jmp    8006f6 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006e4:	75 31                	jne    800717 <vprintfmt+0x217>
					putch(ch, putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	ff 55 08             	call   *0x8(%ebp)
  8006f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f3:	83 eb 01             	sub    $0x1,%ebx
  8006f6:	83 c7 01             	add    $0x1,%edi
  8006f9:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006fd:	0f be c2             	movsbl %dl,%eax
  800700:	85 c0                	test   %eax,%eax
  800702:	74 59                	je     80075d <vprintfmt+0x25d>
  800704:	85 f6                	test   %esi,%esi
  800706:	78 d8                	js     8006e0 <vprintfmt+0x1e0>
  800708:	83 ee 01             	sub    $0x1,%esi
  80070b:	79 d3                	jns    8006e0 <vprintfmt+0x1e0>
  80070d:	89 df                	mov    %ebx,%edi
  80070f:	8b 75 08             	mov    0x8(%ebp),%esi
  800712:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800715:	eb 37                	jmp    80074e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800717:	0f be d2             	movsbl %dl,%edx
  80071a:	83 ea 20             	sub    $0x20,%edx
  80071d:	83 fa 5e             	cmp    $0x5e,%edx
  800720:	76 c4                	jbe    8006e6 <vprintfmt+0x1e6>
					putch('?', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 3f                	push   $0x3f
  80072a:	ff 55 08             	call   *0x8(%ebp)
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb c1                	jmp    8006f3 <vprintfmt+0x1f3>
  800732:	89 75 08             	mov    %esi,0x8(%ebp)
  800735:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800738:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80073b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80073e:	eb b6                	jmp    8006f6 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 20                	push   $0x20
  800746:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800748:	83 ef 01             	sub    $0x1,%edi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 ff                	test   %edi,%edi
  800750:	7f ee                	jg     800740 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800752:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
  800758:	e9 d8 01 00 00       	jmp    800935 <vprintfmt+0x435>
  80075d:	89 df                	mov    %ebx,%edi
  80075f:	8b 75 08             	mov    0x8(%ebp),%esi
  800762:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800765:	eb e7                	jmp    80074e <vprintfmt+0x24e>
	if (lflag >= 2)
  800767:	83 f9 01             	cmp    $0x1,%ecx
  80076a:	7e 45                	jle    8007b1 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 50 04             	mov    0x4(%eax),%edx
  800772:	8b 00                	mov    (%eax),%eax
  800774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800777:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 40 08             	lea    0x8(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800783:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800787:	79 62                	jns    8007eb <vprintfmt+0x2eb>
				putch('-', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 2d                	push   $0x2d
  80078f:	ff d6                	call   *%esi
				num = -(long long) num;
  800791:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800794:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800797:	f7 d8                	neg    %eax
  800799:	83 d2 00             	adc    $0x0,%edx
  80079c:	f7 da                	neg    %edx
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007ac:	e9 66 01 00 00       	jmp    800917 <vprintfmt+0x417>
	else if (lflag)
  8007b1:	85 c9                	test   %ecx,%ecx
  8007b3:	75 1b                	jne    8007d0 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bd:	89 c1                	mov    %eax,%ecx
  8007bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8007c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 40 04             	lea    0x4(%eax),%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	eb b3                	jmp    800783 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d8:	89 c1                	mov    %eax,%ecx
  8007da:	c1 f9 1f             	sar    $0x1f,%ecx
  8007dd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 40 04             	lea    0x4(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e9:	eb 98                	jmp    800783 <vprintfmt+0x283>
			base = 10;
  8007eb:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007f0:	e9 22 01 00 00       	jmp    800917 <vprintfmt+0x417>
	if (lflag >= 2)
  8007f5:	83 f9 01             	cmp    $0x1,%ecx
  8007f8:	7e 21                	jle    80081b <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 50 04             	mov    0x4(%eax),%edx
  800800:	8b 00                	mov    (%eax),%eax
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8d 40 08             	lea    0x8(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800811:	ba 0a 00 00 00       	mov    $0xa,%edx
  800816:	e9 fc 00 00 00       	jmp    800917 <vprintfmt+0x417>
	else if (lflag)
  80081b:	85 c9                	test   %ecx,%ecx
  80081d:	75 23                	jne    800842 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
  800829:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800838:	ba 0a 00 00 00       	mov    $0xa,%edx
  80083d:	e9 d5 00 00 00       	jmp    800917 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	ba 00 00 00 00       	mov    $0x0,%edx
  80084c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8d 40 04             	lea    0x4(%eax),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800860:	e9 b2 00 00 00       	jmp    800917 <vprintfmt+0x417>
	if (lflag >= 2)
  800865:	83 f9 01             	cmp    $0x1,%ecx
  800868:	7e 42                	jle    8008ac <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 50 04             	mov    0x4(%eax),%edx
  800870:	8b 00                	mov    (%eax),%eax
  800872:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800875:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 40 08             	lea    0x8(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800881:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800886:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80088a:	0f 89 87 00 00 00    	jns    800917 <vprintfmt+0x417>
				putch('-', putdat);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	53                   	push   %ebx
  800894:	6a 2d                	push   $0x2d
  800896:	ff d6                	call   *%esi
				num = -(long long) num;
  800898:	f7 5d d8             	negl   -0x28(%ebp)
  80089b:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80089f:	f7 5d dc             	negl   -0x24(%ebp)
  8008a2:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8008a5:	ba 08 00 00 00       	mov    $0x8,%edx
  8008aa:	eb 6b                	jmp    800917 <vprintfmt+0x417>
	else if (lflag)
  8008ac:	85 c9                	test   %ecx,%ecx
  8008ae:	75 1b                	jne    8008cb <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8d 40 04             	lea    0x4(%eax),%eax
  8008c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c9:	eb b6                	jmp    800881 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8d 40 04             	lea    0x4(%eax),%eax
  8008e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e4:	eb 9b                	jmp    800881 <vprintfmt+0x381>
			putch('0', putdat);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	53                   	push   %ebx
  8008ea:	6a 30                	push   $0x30
  8008ec:	ff d6                	call   *%esi
			putch('x', putdat);
  8008ee:	83 c4 08             	add    $0x8,%esp
  8008f1:	53                   	push   %ebx
  8008f2:	6a 78                	push   $0x78
  8008f4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800900:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800903:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800906:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8d 40 04             	lea    0x4(%eax),%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800912:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800917:	83 ec 0c             	sub    $0xc,%esp
  80091a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80091e:	50                   	push   %eax
  80091f:	ff 75 e0             	pushl  -0x20(%ebp)
  800922:	52                   	push   %edx
  800923:	ff 75 dc             	pushl  -0x24(%ebp)
  800926:	ff 75 d8             	pushl  -0x28(%ebp)
  800929:	89 da                	mov    %ebx,%edx
  80092b:	89 f0                	mov    %esi,%eax
  80092d:	e8 e5 fa ff ff       	call   800417 <printnum>
			break;
  800932:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800935:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	83 c7 01             	add    $0x1,%edi
  80093b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80093f:	83 f8 25             	cmp    $0x25,%eax
  800942:	0f 84 cf fb ff ff    	je     800517 <vprintfmt+0x17>
			if (ch == '\0')
  800948:	85 c0                	test   %eax,%eax
  80094a:	0f 84 a9 00 00 00    	je     8009f9 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	53                   	push   %ebx
  800954:	50                   	push   %eax
  800955:	ff d6                	call   *%esi
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	eb dc                	jmp    800938 <vprintfmt+0x438>
	if (lflag >= 2)
  80095c:	83 f9 01             	cmp    $0x1,%ecx
  80095f:	7e 1e                	jle    80097f <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8b 50 04             	mov    0x4(%eax),%edx
  800967:	8b 00                	mov    (%eax),%eax
  800969:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	8d 40 08             	lea    0x8(%eax),%eax
  800975:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800978:	ba 10 00 00 00       	mov    $0x10,%edx
  80097d:	eb 98                	jmp    800917 <vprintfmt+0x417>
	else if (lflag)
  80097f:	85 c9                	test   %ecx,%ecx
  800981:	75 23                	jne    8009a6 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800983:	8b 45 14             	mov    0x14(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
  80098d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800990:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8d 40 04             	lea    0x4(%eax),%eax
  800999:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80099c:	ba 10 00 00 00       	mov    $0x10,%edx
  8009a1:	e9 71 ff ff ff       	jmp    800917 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8d 40 04             	lea    0x4(%eax),%eax
  8009bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009bf:	ba 10 00 00 00       	mov    $0x10,%edx
  8009c4:	e9 4e ff ff ff       	jmp    800917 <vprintfmt+0x417>
			putch(ch, putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	53                   	push   %ebx
  8009cd:	6a 25                	push   $0x25
  8009cf:	ff d6                	call   *%esi
			break;
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	e9 5c ff ff ff       	jmp    800935 <vprintfmt+0x435>
			putch('%', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	53                   	push   %ebx
  8009dd:	6a 25                	push   $0x25
  8009df:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	89 f8                	mov    %edi,%eax
  8009e6:	eb 03                	jmp    8009eb <vprintfmt+0x4eb>
  8009e8:	83 e8 01             	sub    $0x1,%eax
  8009eb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009ef:	75 f7                	jne    8009e8 <vprintfmt+0x4e8>
  8009f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f4:	e9 3c ff ff ff       	jmp    800935 <vprintfmt+0x435>
}
  8009f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009fc:	5b                   	pop    %ebx
  8009fd:	5e                   	pop    %esi
  8009fe:	5f                   	pop    %edi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 18             	sub    $0x18,%esp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a10:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a14:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a1e:	85 c0                	test   %eax,%eax
  800a20:	74 26                	je     800a48 <vsnprintf+0x47>
  800a22:	85 d2                	test   %edx,%edx
  800a24:	7e 22                	jle    800a48 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a26:	ff 75 14             	pushl  0x14(%ebp)
  800a29:	ff 75 10             	pushl  0x10(%ebp)
  800a2c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a2f:	50                   	push   %eax
  800a30:	68 c6 04 80 00       	push   $0x8004c6
  800a35:	e8 c6 fa ff ff       	call   800500 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a3d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a43:	83 c4 10             	add    $0x10,%esp
}
  800a46:	c9                   	leave  
  800a47:	c3                   	ret    
		return -E_INVAL;
  800a48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a4d:	eb f7                	jmp    800a46 <vsnprintf+0x45>

00800a4f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a55:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a58:	50                   	push   %eax
  800a59:	ff 75 10             	pushl  0x10(%ebp)
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	ff 75 08             	pushl  0x8(%ebp)
  800a62:	e8 9a ff ff ff       	call   800a01 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a74:	eb 03                	jmp    800a79 <strlen+0x10>
		n++;
  800a76:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a79:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a7d:	75 f7                	jne    800a76 <strlen+0xd>
	return n;
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a87:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8f:	eb 03                	jmp    800a94 <strnlen+0x13>
		n++;
  800a91:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a94:	39 d0                	cmp    %edx,%eax
  800a96:	74 06                	je     800a9e <strnlen+0x1d>
  800a98:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a9c:	75 f3                	jne    800a91 <strnlen+0x10>
	return n;
}
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	53                   	push   %ebx
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aaa:	89 c2                	mov    %eax,%edx
  800aac:	83 c1 01             	add    $0x1,%ecx
  800aaf:	83 c2 01             	add    $0x1,%edx
  800ab2:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800ab6:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab9:	84 db                	test   %bl,%bl
  800abb:	75 ef                	jne    800aac <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800abd:	5b                   	pop    %ebx
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	53                   	push   %ebx
  800ac4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac7:	53                   	push   %ebx
  800ac8:	e8 9c ff ff ff       	call   800a69 <strlen>
  800acd:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	50                   	push   %eax
  800ad6:	e8 c5 ff ff ff       	call   800aa0 <strcpy>
	return dst;
}
  800adb:	89 d8                	mov    %ebx,%eax
  800add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aed:	89 f3                	mov    %esi,%ebx
  800aef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af2:	89 f2                	mov    %esi,%edx
  800af4:	eb 0f                	jmp    800b05 <strncpy+0x23>
		*dst++ = *src;
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aff:	80 39 01             	cmpb   $0x1,(%ecx)
  800b02:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b05:	39 da                	cmp    %ebx,%edx
  800b07:	75 ed                	jne    800af6 <strncpy+0x14>
	}
	return ret;
}
  800b09:	89 f0                	mov    %esi,%eax
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	56                   	push   %esi
  800b13:	53                   	push   %ebx
  800b14:	8b 75 08             	mov    0x8(%ebp),%esi
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b1d:	89 f0                	mov    %esi,%eax
  800b1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b23:	85 c9                	test   %ecx,%ecx
  800b25:	75 0b                	jne    800b32 <strlcpy+0x23>
  800b27:	eb 17                	jmp    800b40 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b29:	83 c2 01             	add    $0x1,%edx
  800b2c:	83 c0 01             	add    $0x1,%eax
  800b2f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b32:	39 d8                	cmp    %ebx,%eax
  800b34:	74 07                	je     800b3d <strlcpy+0x2e>
  800b36:	0f b6 0a             	movzbl (%edx),%ecx
  800b39:	84 c9                	test   %cl,%cl
  800b3b:	75 ec                	jne    800b29 <strlcpy+0x1a>
		*dst = '\0';
  800b3d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b40:	29 f0                	sub    %esi,%eax
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b4f:	eb 06                	jmp    800b57 <strcmp+0x11>
		p++, q++;
  800b51:	83 c1 01             	add    $0x1,%ecx
  800b54:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b57:	0f b6 01             	movzbl (%ecx),%eax
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 04                	je     800b62 <strcmp+0x1c>
  800b5e:	3a 02                	cmp    (%edx),%al
  800b60:	74 ef                	je     800b51 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b62:	0f b6 c0             	movzbl %al,%eax
  800b65:	0f b6 12             	movzbl (%edx),%edx
  800b68:	29 d0                	sub    %edx,%eax
}
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	53                   	push   %ebx
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b76:	89 c3                	mov    %eax,%ebx
  800b78:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b7b:	eb 06                	jmp    800b83 <strncmp+0x17>
		n--, p++, q++;
  800b7d:	83 c0 01             	add    $0x1,%eax
  800b80:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b83:	39 d8                	cmp    %ebx,%eax
  800b85:	74 16                	je     800b9d <strncmp+0x31>
  800b87:	0f b6 08             	movzbl (%eax),%ecx
  800b8a:	84 c9                	test   %cl,%cl
  800b8c:	74 04                	je     800b92 <strncmp+0x26>
  800b8e:	3a 0a                	cmp    (%edx),%cl
  800b90:	74 eb                	je     800b7d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b92:	0f b6 00             	movzbl (%eax),%eax
  800b95:	0f b6 12             	movzbl (%edx),%edx
  800b98:	29 d0                	sub    %edx,%eax
}
  800b9a:	5b                   	pop    %ebx
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    
		return 0;
  800b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba2:	eb f6                	jmp    800b9a <strncmp+0x2e>

00800ba4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bae:	0f b6 10             	movzbl (%eax),%edx
  800bb1:	84 d2                	test   %dl,%dl
  800bb3:	74 09                	je     800bbe <strchr+0x1a>
		if (*s == c)
  800bb5:	38 ca                	cmp    %cl,%dl
  800bb7:	74 0a                	je     800bc3 <strchr+0x1f>
	for (; *s; s++)
  800bb9:	83 c0 01             	add    $0x1,%eax
  800bbc:	eb f0                	jmp    800bae <strchr+0xa>
			return (char *) s;
	return 0;
  800bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bcf:	eb 03                	jmp    800bd4 <strfind+0xf>
  800bd1:	83 c0 01             	add    $0x1,%eax
  800bd4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bd7:	38 ca                	cmp    %cl,%dl
  800bd9:	74 04                	je     800bdf <strfind+0x1a>
  800bdb:	84 d2                	test   %dl,%dl
  800bdd:	75 f2                	jne    800bd1 <strfind+0xc>
			break;
	return (char *) s;
}
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
  800be7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bed:	85 c9                	test   %ecx,%ecx
  800bef:	74 13                	je     800c04 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bf1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bf7:	75 05                	jne    800bfe <memset+0x1d>
  800bf9:	f6 c1 03             	test   $0x3,%cl
  800bfc:	74 0d                	je     800c0b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	fc                   	cld    
  800c02:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c04:	89 f8                	mov    %edi,%eax
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    
		c &= 0xFF;
  800c0b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c0f:	89 d3                	mov    %edx,%ebx
  800c11:	c1 e3 08             	shl    $0x8,%ebx
  800c14:	89 d0                	mov    %edx,%eax
  800c16:	c1 e0 18             	shl    $0x18,%eax
  800c19:	89 d6                	mov    %edx,%esi
  800c1b:	c1 e6 10             	shl    $0x10,%esi
  800c1e:	09 f0                	or     %esi,%eax
  800c20:	09 c2                	or     %eax,%edx
  800c22:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800c24:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c27:	89 d0                	mov    %edx,%eax
  800c29:	fc                   	cld    
  800c2a:	f3 ab                	rep stos %eax,%es:(%edi)
  800c2c:	eb d6                	jmp    800c04 <memset+0x23>

00800c2e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c39:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c3c:	39 c6                	cmp    %eax,%esi
  800c3e:	73 35                	jae    800c75 <memmove+0x47>
  800c40:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c43:	39 c2                	cmp    %eax,%edx
  800c45:	76 2e                	jbe    800c75 <memmove+0x47>
		s += n;
		d += n;
  800c47:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4a:	89 d6                	mov    %edx,%esi
  800c4c:	09 fe                	or     %edi,%esi
  800c4e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c54:	74 0c                	je     800c62 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c56:	83 ef 01             	sub    $0x1,%edi
  800c59:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c5c:	fd                   	std    
  800c5d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c5f:	fc                   	cld    
  800c60:	eb 21                	jmp    800c83 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c62:	f6 c1 03             	test   $0x3,%cl
  800c65:	75 ef                	jne    800c56 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c67:	83 ef 04             	sub    $0x4,%edi
  800c6a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c6d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c70:	fd                   	std    
  800c71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c73:	eb ea                	jmp    800c5f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c75:	89 f2                	mov    %esi,%edx
  800c77:	09 c2                	or     %eax,%edx
  800c79:	f6 c2 03             	test   $0x3,%dl
  800c7c:	74 09                	je     800c87 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c7e:	89 c7                	mov    %eax,%edi
  800c80:	fc                   	cld    
  800c81:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c87:	f6 c1 03             	test   $0x3,%cl
  800c8a:	75 f2                	jne    800c7e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c8c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c8f:	89 c7                	mov    %eax,%edi
  800c91:	fc                   	cld    
  800c92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c94:	eb ed                	jmp    800c83 <memmove+0x55>

00800c96 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c99:	ff 75 10             	pushl  0x10(%ebp)
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	ff 75 08             	pushl  0x8(%ebp)
  800ca2:	e8 87 ff ff ff       	call   800c2e <memmove>
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb4:	89 c6                	mov    %eax,%esi
  800cb6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cb9:	39 f0                	cmp    %esi,%eax
  800cbb:	74 1c                	je     800cd9 <memcmp+0x30>
		if (*s1 != *s2)
  800cbd:	0f b6 08             	movzbl (%eax),%ecx
  800cc0:	0f b6 1a             	movzbl (%edx),%ebx
  800cc3:	38 d9                	cmp    %bl,%cl
  800cc5:	75 08                	jne    800ccf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cc7:	83 c0 01             	add    $0x1,%eax
  800cca:	83 c2 01             	add    $0x1,%edx
  800ccd:	eb ea                	jmp    800cb9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ccf:	0f b6 c1             	movzbl %cl,%eax
  800cd2:	0f b6 db             	movzbl %bl,%ebx
  800cd5:	29 d8                	sub    %ebx,%eax
  800cd7:	eb 05                	jmp    800cde <memcmp+0x35>
	}

	return 0;
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ceb:	89 c2                	mov    %eax,%edx
  800ced:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf0:	39 d0                	cmp    %edx,%eax
  800cf2:	73 09                	jae    800cfd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf4:	38 08                	cmp    %cl,(%eax)
  800cf6:	74 05                	je     800cfd <memfind+0x1b>
	for (; s < ends; s++)
  800cf8:	83 c0 01             	add    $0x1,%eax
  800cfb:	eb f3                	jmp    800cf0 <memfind+0xe>
			break;
	return (void *) s;
}
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
  800d05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d08:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0b:	eb 03                	jmp    800d10 <strtol+0x11>
		s++;
  800d0d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d10:	0f b6 01             	movzbl (%ecx),%eax
  800d13:	3c 20                	cmp    $0x20,%al
  800d15:	74 f6                	je     800d0d <strtol+0xe>
  800d17:	3c 09                	cmp    $0x9,%al
  800d19:	74 f2                	je     800d0d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d1b:	3c 2b                	cmp    $0x2b,%al
  800d1d:	74 2e                	je     800d4d <strtol+0x4e>
	int neg = 0;
  800d1f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d24:	3c 2d                	cmp    $0x2d,%al
  800d26:	74 2f                	je     800d57 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d28:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d2e:	75 05                	jne    800d35 <strtol+0x36>
  800d30:	80 39 30             	cmpb   $0x30,(%ecx)
  800d33:	74 2c                	je     800d61 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	75 0a                	jne    800d43 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d39:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d3e:	80 39 30             	cmpb   $0x30,(%ecx)
  800d41:	74 28                	je     800d6b <strtol+0x6c>
		base = 10;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d4b:	eb 50                	jmp    800d9d <strtol+0x9e>
		s++;
  800d4d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d50:	bf 00 00 00 00       	mov    $0x0,%edi
  800d55:	eb d1                	jmp    800d28 <strtol+0x29>
		s++, neg = 1;
  800d57:	83 c1 01             	add    $0x1,%ecx
  800d5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800d5f:	eb c7                	jmp    800d28 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d61:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d65:	74 0e                	je     800d75 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d67:	85 db                	test   %ebx,%ebx
  800d69:	75 d8                	jne    800d43 <strtol+0x44>
		s++, base = 8;
  800d6b:	83 c1 01             	add    $0x1,%ecx
  800d6e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d73:	eb ce                	jmp    800d43 <strtol+0x44>
		s += 2, base = 16;
  800d75:	83 c1 02             	add    $0x2,%ecx
  800d78:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d7d:	eb c4                	jmp    800d43 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d7f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d82:	89 f3                	mov    %esi,%ebx
  800d84:	80 fb 19             	cmp    $0x19,%bl
  800d87:	77 29                	ja     800db2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d89:	0f be d2             	movsbl %dl,%edx
  800d8c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d8f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d92:	7d 30                	jge    800dc4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d94:	83 c1 01             	add    $0x1,%ecx
  800d97:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d9b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d9d:	0f b6 11             	movzbl (%ecx),%edx
  800da0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da3:	89 f3                	mov    %esi,%ebx
  800da5:	80 fb 09             	cmp    $0x9,%bl
  800da8:	77 d5                	ja     800d7f <strtol+0x80>
			dig = *s - '0';
  800daa:	0f be d2             	movsbl %dl,%edx
  800dad:	83 ea 30             	sub    $0x30,%edx
  800db0:	eb dd                	jmp    800d8f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800db2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800db5:	89 f3                	mov    %esi,%ebx
  800db7:	80 fb 19             	cmp    $0x19,%bl
  800dba:	77 08                	ja     800dc4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800dbc:	0f be d2             	movsbl %dl,%edx
  800dbf:	83 ea 37             	sub    $0x37,%edx
  800dc2:	eb cb                	jmp    800d8f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc8:	74 05                	je     800dcf <strtol+0xd0>
		*endptr = (char *) s;
  800dca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dcf:	89 c2                	mov    %eax,%edx
  800dd1:	f7 da                	neg    %edx
  800dd3:	85 ff                	test   %edi,%edi
  800dd5:	0f 45 c2             	cmovne %edx,%eax
}
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	89 c3                	mov    %eax,%ebx
  800df0:	89 c7                	mov    %eax,%edi
  800df2:	89 c6                	mov    %eax,%esi
  800df4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <sys_cgetc>:

int
sys_cgetc(void)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e01:	ba 00 00 00 00       	mov    $0x0,%edx
  800e06:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0b:	89 d1                	mov    %edx,%ecx
  800e0d:	89 d3                	mov    %edx,%ebx
  800e0f:	89 d7                	mov    %edx,%edi
  800e11:	89 d6                	mov    %edx,%esi
  800e13:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	89 cb                	mov    %ecx,%ebx
  800e32:	89 cf                	mov    %ecx,%edi
  800e34:	89 ce                	mov    %ecx,%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 03                	push   $0x3
  800e4a:	68 bf 2b 80 00       	push   $0x802bbf
  800e4f:	6a 23                	push   $0x23
  800e51:	68 dc 2b 80 00       	push   $0x802bdc
  800e56:	e8 cd f4 ff ff       	call   800328 <_panic>

00800e5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e61:	ba 00 00 00 00       	mov    $0x0,%edx
  800e66:	b8 02 00 00 00       	mov    $0x2,%eax
  800e6b:	89 d1                	mov    %edx,%ecx
  800e6d:	89 d3                	mov    %edx,%ebx
  800e6f:	89 d7                	mov    %edx,%edi
  800e71:	89 d6                	mov    %edx,%esi
  800e73:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <sys_yield>:

void
sys_yield(void)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e80:	ba 00 00 00 00       	mov    $0x0,%edx
  800e85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e8a:	89 d1                	mov    %edx,%ecx
  800e8c:	89 d3                	mov    %edx,%ebx
  800e8e:	89 d7                	mov    %edx,%edi
  800e90:	89 d6                	mov    %edx,%esi
  800e92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea2:	be 00 00 00 00       	mov    $0x0,%esi
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb5:	89 f7                	mov    %esi,%edi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 04                	push   $0x4
  800ecb:	68 bf 2b 80 00       	push   $0x802bbf
  800ed0:	6a 23                	push   $0x23
  800ed2:	68 dc 2b 80 00       	push   $0x802bdc
  800ed7:	e8 4c f4 ff ff       	call   800328 <_panic>

00800edc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef6:	8b 75 18             	mov    0x18(%ebp),%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 05                	push   $0x5
  800f0d:	68 bf 2b 80 00       	push   $0x802bbf
  800f12:	6a 23                	push   $0x23
  800f14:	68 dc 2b 80 00       	push   $0x802bdc
  800f19:	e8 0a f4 ff ff       	call   800328 <_panic>

00800f1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	b8 06 00 00 00       	mov    $0x6,%eax
  800f37:	89 df                	mov    %ebx,%edi
  800f39:	89 de                	mov    %ebx,%esi
  800f3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7f 08                	jg     800f49 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	50                   	push   %eax
  800f4d:	6a 06                	push   $0x6
  800f4f:	68 bf 2b 80 00       	push   $0x802bbf
  800f54:	6a 23                	push   $0x23
  800f56:	68 dc 2b 80 00       	push   $0x802bdc
  800f5b:	e8 c8 f3 ff ff       	call   800328 <_panic>

00800f60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f74:	b8 08 00 00 00       	mov    $0x8,%eax
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	89 de                	mov    %ebx,%esi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 08                	push   $0x8
  800f91:	68 bf 2b 80 00       	push   $0x802bbf
  800f96:	6a 23                	push   $0x23
  800f98:	68 dc 2b 80 00       	push   $0x802bdc
  800f9d:	e8 86 f3 ff ff       	call   800328 <_panic>

00800fa2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 09 00 00 00       	mov    $0x9,%eax
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	7f 08                	jg     800fcd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	83 ec 0c             	sub    $0xc,%esp
  800fd0:	50                   	push   %eax
  800fd1:	6a 09                	push   $0x9
  800fd3:	68 bf 2b 80 00       	push   $0x802bbf
  800fd8:	6a 23                	push   $0x23
  800fda:	68 dc 2b 80 00       	push   $0x802bdc
  800fdf:	e8 44 f3 ff ff       	call   800328 <_panic>

00800fe4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffd:	89 df                	mov    %ebx,%edi
  800fff:	89 de                	mov    %ebx,%esi
  801001:	cd 30                	int    $0x30
	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7f 08                	jg     80100f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	50                   	push   %eax
  801013:	6a 0a                	push   $0xa
  801015:	68 bf 2b 80 00       	push   $0x802bbf
  80101a:	6a 23                	push   $0x23
  80101c:	68 dc 2b 80 00       	push   $0x802bdc
  801021:	e8 02 f3 ff ff       	call   800328 <_panic>

00801026 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	b8 0c 00 00 00       	mov    $0xc,%eax
  801037:	be 00 00 00 00       	mov    $0x0,%esi
  80103c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801042:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
  80104f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801052:	b9 00 00 00 00       	mov    $0x0,%ecx
  801057:	8b 55 08             	mov    0x8(%ebp),%edx
  80105a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105f:	89 cb                	mov    %ecx,%ebx
  801061:	89 cf                	mov    %ecx,%edi
  801063:	89 ce                	mov    %ecx,%esi
  801065:	cd 30                	int    $0x30
	if(check && ret > 0)
  801067:	85 c0                	test   %eax,%eax
  801069:	7f 08                	jg     801073 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80106b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	50                   	push   %eax
  801077:	6a 0d                	push   $0xd
  801079:	68 bf 2b 80 00       	push   $0x802bbf
  80107e:	6a 23                	push   $0x23
  801080:	68 dc 2b 80 00       	push   $0x802bdc
  801085:	e8 9e f2 ff ff       	call   800328 <_panic>

0080108a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	ba 00 00 00 00       	mov    $0x0,%edx
  801095:	b8 0e 00 00 00       	mov    $0xe,%eax
  80109a:	89 d1                	mov    %edx,%ecx
  80109c:	89 d3                	mov    %edx,%ebx
  80109e:	89 d7                	mov    %edx,%edi
  8010a0:	89 d6                	mov    %edx,%esi
  8010a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8010af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8010b5:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8010b7:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8010ba:	83 3a 01             	cmpl   $0x1,(%edx)
  8010bd:	7e 09                	jle    8010c8 <argstart+0x1f>
  8010bf:	ba 68 28 80 00       	mov    $0x802868,%edx
  8010c4:	85 c9                	test   %ecx,%ecx
  8010c6:	75 05                	jne    8010cd <argstart+0x24>
  8010c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cd:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8010d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <argnext>:

int
argnext(struct Argstate *args)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	53                   	push   %ebx
  8010dd:	83 ec 04             	sub    $0x4,%esp
  8010e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8010e3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8010ea:	8b 43 08             	mov    0x8(%ebx),%eax
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	74 72                	je     801163 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  8010f1:	80 38 00             	cmpb   $0x0,(%eax)
  8010f4:	75 48                	jne    80113e <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8010f6:	8b 0b                	mov    (%ebx),%ecx
  8010f8:	83 39 01             	cmpl   $0x1,(%ecx)
  8010fb:	74 58                	je     801155 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  8010fd:	8b 53 04             	mov    0x4(%ebx),%edx
  801100:	8b 42 04             	mov    0x4(%edx),%eax
  801103:	80 38 2d             	cmpb   $0x2d,(%eax)
  801106:	75 4d                	jne    801155 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801108:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80110c:	74 47                	je     801155 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80110e:	83 c0 01             	add    $0x1,%eax
  801111:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	8b 01                	mov    (%ecx),%eax
  801119:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801120:	50                   	push   %eax
  801121:	8d 42 08             	lea    0x8(%edx),%eax
  801124:	50                   	push   %eax
  801125:	83 c2 04             	add    $0x4,%edx
  801128:	52                   	push   %edx
  801129:	e8 00 fb ff ff       	call   800c2e <memmove>
		(*args->argc)--;
  80112e:	8b 03                	mov    (%ebx),%eax
  801130:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801133:	8b 43 08             	mov    0x8(%ebx),%eax
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	80 38 2d             	cmpb   $0x2d,(%eax)
  80113c:	74 11                	je     80114f <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80113e:	8b 53 08             	mov    0x8(%ebx),%edx
  801141:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801144:	83 c2 01             	add    $0x1,%edx
  801147:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80114a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80114f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801153:	75 e9                	jne    80113e <argnext+0x65>
	args->curarg = 0;
  801155:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80115c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801161:	eb e7                	jmp    80114a <argnext+0x71>
		return -1;
  801163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801168:	eb e0                	jmp    80114a <argnext+0x71>

0080116a <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	53                   	push   %ebx
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801174:	8b 43 08             	mov    0x8(%ebx),%eax
  801177:	85 c0                	test   %eax,%eax
  801179:	74 5b                	je     8011d6 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  80117b:	80 38 00             	cmpb   $0x0,(%eax)
  80117e:	74 12                	je     801192 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801180:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801183:	c7 43 08 68 28 80 00 	movl   $0x802868,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80118a:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80118d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801190:	c9                   	leave  
  801191:	c3                   	ret    
	} else if (*args->argc > 1) {
  801192:	8b 13                	mov    (%ebx),%edx
  801194:	83 3a 01             	cmpl   $0x1,(%edx)
  801197:	7f 10                	jg     8011a9 <argnextvalue+0x3f>
		args->argvalue = 0;
  801199:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8011a0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8011a7:	eb e1                	jmp    80118a <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8011a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8011ac:	8b 48 04             	mov    0x4(%eax),%ecx
  8011af:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	8b 12                	mov    (%edx),%edx
  8011b7:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8011be:	52                   	push   %edx
  8011bf:	8d 50 08             	lea    0x8(%eax),%edx
  8011c2:	52                   	push   %edx
  8011c3:	83 c0 04             	add    $0x4,%eax
  8011c6:	50                   	push   %eax
  8011c7:	e8 62 fa ff ff       	call   800c2e <memmove>
		(*args->argc)--;
  8011cc:	8b 03                	mov    (%ebx),%eax
  8011ce:	83 28 01             	subl   $0x1,(%eax)
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	eb b4                	jmp    80118a <argnextvalue+0x20>
		return 0;
  8011d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011db:	eb b0                	jmp    80118d <argnextvalue+0x23>

008011dd <argvalue>:
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 08             	sub    $0x8,%esp
  8011e3:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011e6:	8b 42 0c             	mov    0xc(%edx),%eax
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	74 02                	je     8011ef <argvalue+0x12>
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	52                   	push   %edx
  8011f3:	e8 72 ff ff ff       	call   80116a <argnextvalue>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	eb f0                	jmp    8011ed <argvalue+0x10>

008011fd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	05 00 00 00 30       	add    $0x30000000,%eax
  801208:	c1 e8 0c             	shr    $0xc,%eax
}
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80121d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    

00801224 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80122f:	89 c2                	mov    %eax,%edx
  801231:	c1 ea 16             	shr    $0x16,%edx
  801234:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80123b:	f6 c2 01             	test   $0x1,%dl
  80123e:	74 2a                	je     80126a <fd_alloc+0x46>
  801240:	89 c2                	mov    %eax,%edx
  801242:	c1 ea 0c             	shr    $0xc,%edx
  801245:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124c:	f6 c2 01             	test   $0x1,%dl
  80124f:	74 19                	je     80126a <fd_alloc+0x46>
  801251:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801256:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80125b:	75 d2                	jne    80122f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80125d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801263:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801268:	eb 07                	jmp    801271 <fd_alloc+0x4d>
			*fd_store = fd;
  80126a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80126c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    

00801273 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801279:	83 f8 1f             	cmp    $0x1f,%eax
  80127c:	77 36                	ja     8012b4 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80127e:	c1 e0 0c             	shl    $0xc,%eax
  801281:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801286:	89 c2                	mov    %eax,%edx
  801288:	c1 ea 16             	shr    $0x16,%edx
  80128b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801292:	f6 c2 01             	test   $0x1,%dl
  801295:	74 24                	je     8012bb <fd_lookup+0x48>
  801297:	89 c2                	mov    %eax,%edx
  801299:	c1 ea 0c             	shr    $0xc,%edx
  80129c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012a3:	f6 c2 01             	test   $0x1,%dl
  8012a6:	74 1a                	je     8012c2 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ab:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    
		return -E_INVAL;
  8012b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b9:	eb f7                	jmp    8012b2 <fd_lookup+0x3f>
		return -E_INVAL;
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c0:	eb f0                	jmp    8012b2 <fd_lookup+0x3f>
  8012c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c7:	eb e9                	jmp    8012b2 <fd_lookup+0x3f>

008012c9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d2:	ba 68 2c 80 00       	mov    $0x802c68,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012d7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012dc:	39 08                	cmp    %ecx,(%eax)
  8012de:	74 33                	je     801313 <dev_lookup+0x4a>
  8012e0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012e3:	8b 02                	mov    (%edx),%eax
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	75 f3                	jne    8012dc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012e9:	a1 20 44 80 00       	mov    0x804420,%eax
  8012ee:	8b 40 48             	mov    0x48(%eax),%eax
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	51                   	push   %ecx
  8012f5:	50                   	push   %eax
  8012f6:	68 ec 2b 80 00       	push   $0x802bec
  8012fb:	e8 03 f1 ff ff       	call   800403 <cprintf>
	*dev = 0;
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    
			*dev = devtab[i];
  801313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801316:	89 01                	mov    %eax,(%ecx)
			return 0;
  801318:	b8 00 00 00 00       	mov    $0x0,%eax
  80131d:	eb f2                	jmp    801311 <dev_lookup+0x48>

0080131f <fd_close>:
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	57                   	push   %edi
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
  801325:	83 ec 1c             	sub    $0x1c,%esp
  801328:	8b 75 08             	mov    0x8(%ebp),%esi
  80132b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80132e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801331:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801332:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801338:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80133b:	50                   	push   %eax
  80133c:	e8 32 ff ff ff       	call   801273 <fd_lookup>
  801341:	89 c3                	mov    %eax,%ebx
  801343:	83 c4 08             	add    $0x8,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	78 05                	js     80134f <fd_close+0x30>
	    || fd != fd2)
  80134a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80134d:	74 16                	je     801365 <fd_close+0x46>
		return (must_exist ? r : 0);
  80134f:	89 f8                	mov    %edi,%eax
  801351:	84 c0                	test   %al,%al
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	0f 44 d8             	cmove  %eax,%ebx
}
  80135b:	89 d8                	mov    %ebx,%eax
  80135d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801360:	5b                   	pop    %ebx
  801361:	5e                   	pop    %esi
  801362:	5f                   	pop    %edi
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80136b:	50                   	push   %eax
  80136c:	ff 36                	pushl  (%esi)
  80136e:	e8 56 ff ff ff       	call   8012c9 <dev_lookup>
  801373:	89 c3                	mov    %eax,%ebx
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 15                	js     801391 <fd_close+0x72>
		if (dev->dev_close)
  80137c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80137f:	8b 40 10             	mov    0x10(%eax),%eax
  801382:	85 c0                	test   %eax,%eax
  801384:	74 1b                	je     8013a1 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801386:	83 ec 0c             	sub    $0xc,%esp
  801389:	56                   	push   %esi
  80138a:	ff d0                	call   *%eax
  80138c:	89 c3                	mov    %eax,%ebx
  80138e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	56                   	push   %esi
  801395:	6a 00                	push   $0x0
  801397:	e8 82 fb ff ff       	call   800f1e <sys_page_unmap>
	return r;
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	eb ba                	jmp    80135b <fd_close+0x3c>
			r = 0;
  8013a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a6:	eb e9                	jmp    801391 <fd_close+0x72>

008013a8 <close>:

int
close(int fdnum)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b1:	50                   	push   %eax
  8013b2:	ff 75 08             	pushl  0x8(%ebp)
  8013b5:	e8 b9 fe ff ff       	call   801273 <fd_lookup>
  8013ba:	83 c4 08             	add    $0x8,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 10                	js     8013d1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	6a 01                	push   $0x1
  8013c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c9:	e8 51 ff ff ff       	call   80131f <fd_close>
  8013ce:	83 c4 10             	add    $0x10,%esp
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <close_all>:

void
close_all(void)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	53                   	push   %ebx
  8013d7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013da:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	53                   	push   %ebx
  8013e3:	e8 c0 ff ff ff       	call   8013a8 <close>
	for (i = 0; i < MAXFD; i++)
  8013e8:	83 c3 01             	add    $0x1,%ebx
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	83 fb 20             	cmp    $0x20,%ebx
  8013f1:	75 ec                	jne    8013df <close_all+0xc>
}
  8013f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	57                   	push   %edi
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
  8013fe:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801401:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	e8 66 fe ff ff       	call   801273 <fd_lookup>
  80140d:	89 c3                	mov    %eax,%ebx
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	0f 88 81 00 00 00    	js     80149b <dup+0xa3>
		return r;
	close(newfdnum);
  80141a:	83 ec 0c             	sub    $0xc,%esp
  80141d:	ff 75 0c             	pushl  0xc(%ebp)
  801420:	e8 83 ff ff ff       	call   8013a8 <close>

	newfd = INDEX2FD(newfdnum);
  801425:	8b 75 0c             	mov    0xc(%ebp),%esi
  801428:	c1 e6 0c             	shl    $0xc,%esi
  80142b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801431:	83 c4 04             	add    $0x4,%esp
  801434:	ff 75 e4             	pushl  -0x1c(%ebp)
  801437:	e8 d1 fd ff ff       	call   80120d <fd2data>
  80143c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80143e:	89 34 24             	mov    %esi,(%esp)
  801441:	e8 c7 fd ff ff       	call   80120d <fd2data>
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80144b:	89 d8                	mov    %ebx,%eax
  80144d:	c1 e8 16             	shr    $0x16,%eax
  801450:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801457:	a8 01                	test   $0x1,%al
  801459:	74 11                	je     80146c <dup+0x74>
  80145b:	89 d8                	mov    %ebx,%eax
  80145d:	c1 e8 0c             	shr    $0xc,%eax
  801460:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801467:	f6 c2 01             	test   $0x1,%dl
  80146a:	75 39                	jne    8014a5 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80146c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80146f:	89 d0                	mov    %edx,%eax
  801471:	c1 e8 0c             	shr    $0xc,%eax
  801474:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	25 07 0e 00 00       	and    $0xe07,%eax
  801483:	50                   	push   %eax
  801484:	56                   	push   %esi
  801485:	6a 00                	push   $0x0
  801487:	52                   	push   %edx
  801488:	6a 00                	push   $0x0
  80148a:	e8 4d fa ff ff       	call   800edc <sys_page_map>
  80148f:	89 c3                	mov    %eax,%ebx
  801491:	83 c4 20             	add    $0x20,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	78 31                	js     8014c9 <dup+0xd1>
		goto err;

	return newfdnum;
  801498:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80149b:	89 d8                	mov    %ebx,%eax
  80149d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a0:	5b                   	pop    %ebx
  8014a1:	5e                   	pop    %esi
  8014a2:	5f                   	pop    %edi
  8014a3:	5d                   	pop    %ebp
  8014a4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ac:	83 ec 0c             	sub    $0xc,%esp
  8014af:	25 07 0e 00 00       	and    $0xe07,%eax
  8014b4:	50                   	push   %eax
  8014b5:	57                   	push   %edi
  8014b6:	6a 00                	push   $0x0
  8014b8:	53                   	push   %ebx
  8014b9:	6a 00                	push   $0x0
  8014bb:	e8 1c fa ff ff       	call   800edc <sys_page_map>
  8014c0:	89 c3                	mov    %eax,%ebx
  8014c2:	83 c4 20             	add    $0x20,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	79 a3                	jns    80146c <dup+0x74>
	sys_page_unmap(0, newfd);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	56                   	push   %esi
  8014cd:	6a 00                	push   $0x0
  8014cf:	e8 4a fa ff ff       	call   800f1e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014d4:	83 c4 08             	add    $0x8,%esp
  8014d7:	57                   	push   %edi
  8014d8:	6a 00                	push   $0x0
  8014da:	e8 3f fa ff ff       	call   800f1e <sys_page_unmap>
	return r;
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	eb b7                	jmp    80149b <dup+0xa3>

008014e4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	53                   	push   %ebx
  8014e8:	83 ec 14             	sub    $0x14,%esp
  8014eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	53                   	push   %ebx
  8014f3:	e8 7b fd ff ff       	call   801273 <fd_lookup>
  8014f8:	83 c4 08             	add    $0x8,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 3f                	js     80153e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801505:	50                   	push   %eax
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	ff 30                	pushl  (%eax)
  80150b:	e8 b9 fd ff ff       	call   8012c9 <dev_lookup>
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 27                	js     80153e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801517:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80151a:	8b 42 08             	mov    0x8(%edx),%eax
  80151d:	83 e0 03             	and    $0x3,%eax
  801520:	83 f8 01             	cmp    $0x1,%eax
  801523:	74 1e                	je     801543 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801528:	8b 40 08             	mov    0x8(%eax),%eax
  80152b:	85 c0                	test   %eax,%eax
  80152d:	74 35                	je     801564 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	ff 75 10             	pushl  0x10(%ebp)
  801535:	ff 75 0c             	pushl  0xc(%ebp)
  801538:	52                   	push   %edx
  801539:	ff d0                	call   *%eax
  80153b:	83 c4 10             	add    $0x10,%esp
}
  80153e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801541:	c9                   	leave  
  801542:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801543:	a1 20 44 80 00       	mov    0x804420,%eax
  801548:	8b 40 48             	mov    0x48(%eax),%eax
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	53                   	push   %ebx
  80154f:	50                   	push   %eax
  801550:	68 2d 2c 80 00       	push   $0x802c2d
  801555:	e8 a9 ee ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801562:	eb da                	jmp    80153e <read+0x5a>
		return -E_NOT_SUPP;
  801564:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801569:	eb d3                	jmp    80153e <read+0x5a>

0080156b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	57                   	push   %edi
  80156f:	56                   	push   %esi
  801570:	53                   	push   %ebx
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	8b 7d 08             	mov    0x8(%ebp),%edi
  801577:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80157a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80157f:	39 f3                	cmp    %esi,%ebx
  801581:	73 25                	jae    8015a8 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	89 f0                	mov    %esi,%eax
  801588:	29 d8                	sub    %ebx,%eax
  80158a:	50                   	push   %eax
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	03 45 0c             	add    0xc(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	57                   	push   %edi
  801592:	e8 4d ff ff ff       	call   8014e4 <read>
		if (m < 0)
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 08                	js     8015a6 <readn+0x3b>
			return m;
		if (m == 0)
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	74 06                	je     8015a8 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015a2:	01 c3                	add    %eax,%ebx
  8015a4:	eb d9                	jmp    80157f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015a6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015a8:	89 d8                	mov    %ebx,%eax
  8015aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5e                   	pop    %esi
  8015af:	5f                   	pop    %edi
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    

008015b2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	53                   	push   %ebx
  8015b6:	83 ec 14             	sub    $0x14,%esp
  8015b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bf:	50                   	push   %eax
  8015c0:	53                   	push   %ebx
  8015c1:	e8 ad fc ff ff       	call   801273 <fd_lookup>
  8015c6:	83 c4 08             	add    $0x8,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 3a                	js     801607 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cd:	83 ec 08             	sub    $0x8,%esp
  8015d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d3:	50                   	push   %eax
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	ff 30                	pushl  (%eax)
  8015d9:	e8 eb fc ff ff       	call   8012c9 <dev_lookup>
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 22                	js     801607 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ec:	74 1e                	je     80160c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f1:	8b 52 0c             	mov    0xc(%edx),%edx
  8015f4:	85 d2                	test   %edx,%edx
  8015f6:	74 35                	je     80162d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	ff 75 10             	pushl  0x10(%ebp)
  8015fe:	ff 75 0c             	pushl  0xc(%ebp)
  801601:	50                   	push   %eax
  801602:	ff d2                	call   *%edx
  801604:	83 c4 10             	add    $0x10,%esp
}
  801607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80160c:	a1 20 44 80 00       	mov    0x804420,%eax
  801611:	8b 40 48             	mov    0x48(%eax),%eax
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	53                   	push   %ebx
  801618:	50                   	push   %eax
  801619:	68 49 2c 80 00       	push   $0x802c49
  80161e:	e8 e0 ed ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162b:	eb da                	jmp    801607 <write+0x55>
		return -E_NOT_SUPP;
  80162d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801632:	eb d3                	jmp    801607 <write+0x55>

00801634 <seek>:

int
seek(int fdnum, off_t offset)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80163a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80163d:	50                   	push   %eax
  80163e:	ff 75 08             	pushl  0x8(%ebp)
  801641:	e8 2d fc ff ff       	call   801273 <fd_lookup>
  801646:	83 c4 08             	add    $0x8,%esp
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 0e                	js     80165b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80164d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801650:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801653:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	53                   	push   %ebx
  801661:	83 ec 14             	sub    $0x14,%esp
  801664:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801667:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	53                   	push   %ebx
  80166c:	e8 02 fc ff ff       	call   801273 <fd_lookup>
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 37                	js     8016af <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167e:	50                   	push   %eax
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	ff 30                	pushl  (%eax)
  801684:	e8 40 fc ff ff       	call   8012c9 <dev_lookup>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 1f                	js     8016af <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801693:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801697:	74 1b                	je     8016b4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801699:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169c:	8b 52 18             	mov    0x18(%edx),%edx
  80169f:	85 d2                	test   %edx,%edx
  8016a1:	74 32                	je     8016d5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	50                   	push   %eax
  8016aa:	ff d2                	call   *%edx
  8016ac:	83 c4 10             	add    $0x10,%esp
}
  8016af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016b4:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016b9:	8b 40 48             	mov    0x48(%eax),%eax
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	53                   	push   %ebx
  8016c0:	50                   	push   %eax
  8016c1:	68 0c 2c 80 00       	push   $0x802c0c
  8016c6:	e8 38 ed ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d3:	eb da                	jmp    8016af <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016da:	eb d3                	jmp    8016af <ftruncate+0x52>

008016dc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	53                   	push   %ebx
  8016e0:	83 ec 14             	sub    $0x14,%esp
  8016e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e9:	50                   	push   %eax
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	e8 81 fb ff ff       	call   801273 <fd_lookup>
  8016f2:	83 c4 08             	add    $0x8,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	78 4b                	js     801744 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ff:	50                   	push   %eax
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	ff 30                	pushl  (%eax)
  801705:	e8 bf fb ff ff       	call   8012c9 <dev_lookup>
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 33                	js     801744 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801714:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801718:	74 2f                	je     801749 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80171a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80171d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801724:	00 00 00 
	stat->st_isdir = 0;
  801727:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80172e:	00 00 00 
	stat->st_dev = dev;
  801731:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	53                   	push   %ebx
  80173b:	ff 75 f0             	pushl  -0x10(%ebp)
  80173e:	ff 50 14             	call   *0x14(%eax)
  801741:	83 c4 10             	add    $0x10,%esp
}
  801744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801747:	c9                   	leave  
  801748:	c3                   	ret    
		return -E_NOT_SUPP;
  801749:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174e:	eb f4                	jmp    801744 <fstat+0x68>

00801750 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	6a 00                	push   $0x0
  80175a:	ff 75 08             	pushl  0x8(%ebp)
  80175d:	e8 26 02 00 00       	call   801988 <open>
  801762:	89 c3                	mov    %eax,%ebx
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	85 c0                	test   %eax,%eax
  801769:	78 1b                	js     801786 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	50                   	push   %eax
  801772:	e8 65 ff ff ff       	call   8016dc <fstat>
  801777:	89 c6                	mov    %eax,%esi
	close(fd);
  801779:	89 1c 24             	mov    %ebx,(%esp)
  80177c:	e8 27 fc ff ff       	call   8013a8 <close>
	return r;
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	89 f3                	mov    %esi,%ebx
}
  801786:	89 d8                	mov    %ebx,%eax
  801788:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178b:	5b                   	pop    %ebx
  80178c:	5e                   	pop    %esi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    

0080178f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	89 c6                	mov    %eax,%esi
  801796:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801798:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80179f:	74 27                	je     8017c8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017a1:	6a 07                	push   $0x7
  8017a3:	68 00 50 80 00       	push   $0x805000
  8017a8:	56                   	push   %esi
  8017a9:	ff 35 00 40 80 00    	pushl  0x804000
  8017af:	e8 26 0d 00 00       	call   8024da <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017b4:	83 c4 0c             	add    $0xc,%esp
  8017b7:	6a 00                	push   $0x0
  8017b9:	53                   	push   %ebx
  8017ba:	6a 00                	push   $0x0
  8017bc:	e8 b0 0c 00 00       	call   802471 <ipc_recv>
}
  8017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	6a 01                	push   $0x1
  8017cd:	e8 61 0d 00 00       	call   802533 <ipc_find_env>
  8017d2:	a3 00 40 80 00       	mov    %eax,0x804000
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	eb c5                	jmp    8017a1 <fsipc+0x12>

008017dc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fa:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ff:	e8 8b ff ff ff       	call   80178f <fsipc>
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <devfile_flush>:
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8b 40 0c             	mov    0xc(%eax),%eax
  801812:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801817:	ba 00 00 00 00       	mov    $0x0,%edx
  80181c:	b8 06 00 00 00       	mov    $0x6,%eax
  801821:	e8 69 ff ff ff       	call   80178f <fsipc>
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <devfile_stat>:
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	53                   	push   %ebx
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	8b 40 0c             	mov    0xc(%eax),%eax
  801838:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80183d:	ba 00 00 00 00       	mov    $0x0,%edx
  801842:	b8 05 00 00 00       	mov    $0x5,%eax
  801847:	e8 43 ff ff ff       	call   80178f <fsipc>
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 2c                	js     80187c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801850:	83 ec 08             	sub    $0x8,%esp
  801853:	68 00 50 80 00       	push   $0x805000
  801858:	53                   	push   %ebx
  801859:	e8 42 f2 ff ff       	call   800aa0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80185e:	a1 80 50 80 00       	mov    0x805080,%eax
  801863:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801869:	a1 84 50 80 00       	mov    0x805084,%eax
  80186e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <devfile_write>:
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	53                   	push   %ebx
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	8b 40 0c             	mov    0xc(%eax),%eax
  801891:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801896:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80189c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8018a2:	77 30                	ja     8018d4 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	53                   	push   %ebx
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	68 08 50 80 00       	push   $0x805008
  8018b0:	e8 79 f3 ff ff       	call   800c2e <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ba:	b8 04 00 00 00       	mov    $0x4,%eax
  8018bf:	e8 cb fe ff ff       	call   80178f <fsipc>
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 04                	js     8018cf <devfile_write+0x4e>
	assert(r <= n);
  8018cb:	39 d8                	cmp    %ebx,%eax
  8018cd:	77 1e                	ja     8018ed <devfile_write+0x6c>
}
  8018cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8018d4:	68 7c 2c 80 00       	push   $0x802c7c
  8018d9:	68 ac 2c 80 00       	push   $0x802cac
  8018de:	68 94 00 00 00       	push   $0x94
  8018e3:	68 c1 2c 80 00       	push   $0x802cc1
  8018e8:	e8 3b ea ff ff       	call   800328 <_panic>
	assert(r <= n);
  8018ed:	68 cc 2c 80 00       	push   $0x802ccc
  8018f2:	68 ac 2c 80 00       	push   $0x802cac
  8018f7:	68 98 00 00 00       	push   $0x98
  8018fc:	68 c1 2c 80 00       	push   $0x802cc1
  801901:	e8 22 ea ff ff       	call   800328 <_panic>

00801906 <devfile_read>:
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
  80190b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8b 40 0c             	mov    0xc(%eax),%eax
  801914:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801919:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80191f:	ba 00 00 00 00       	mov    $0x0,%edx
  801924:	b8 03 00 00 00       	mov    $0x3,%eax
  801929:	e8 61 fe ff ff       	call   80178f <fsipc>
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	85 c0                	test   %eax,%eax
  801932:	78 1f                	js     801953 <devfile_read+0x4d>
	assert(r <= n);
  801934:	39 f0                	cmp    %esi,%eax
  801936:	77 24                	ja     80195c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801938:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80193d:	7f 33                	jg     801972 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	50                   	push   %eax
  801943:	68 00 50 80 00       	push   $0x805000
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	e8 de f2 ff ff       	call   800c2e <memmove>
	return r;
  801950:	83 c4 10             	add    $0x10,%esp
}
  801953:	89 d8                	mov    %ebx,%eax
  801955:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    
	assert(r <= n);
  80195c:	68 cc 2c 80 00       	push   $0x802ccc
  801961:	68 ac 2c 80 00       	push   $0x802cac
  801966:	6a 7c                	push   $0x7c
  801968:	68 c1 2c 80 00       	push   $0x802cc1
  80196d:	e8 b6 e9 ff ff       	call   800328 <_panic>
	assert(r <= PGSIZE);
  801972:	68 d3 2c 80 00       	push   $0x802cd3
  801977:	68 ac 2c 80 00       	push   $0x802cac
  80197c:	6a 7d                	push   $0x7d
  80197e:	68 c1 2c 80 00       	push   $0x802cc1
  801983:	e8 a0 e9 ff ff       	call   800328 <_panic>

00801988 <open>:
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	83 ec 1c             	sub    $0x1c,%esp
  801990:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801993:	56                   	push   %esi
  801994:	e8 d0 f0 ff ff       	call   800a69 <strlen>
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019a1:	7f 6c                	jg     801a0f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019a3:	83 ec 0c             	sub    $0xc,%esp
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	e8 75 f8 ff ff       	call   801224 <fd_alloc>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 3c                	js     8019f4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019b8:	83 ec 08             	sub    $0x8,%esp
  8019bb:	56                   	push   %esi
  8019bc:	68 00 50 80 00       	push   $0x805000
  8019c1:	e8 da f0 ff ff       	call   800aa0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d6:	e8 b4 fd ff ff       	call   80178f <fsipc>
  8019db:	89 c3                	mov    %eax,%ebx
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	78 19                	js     8019fd <open+0x75>
	return fd2num(fd);
  8019e4:	83 ec 0c             	sub    $0xc,%esp
  8019e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ea:	e8 0e f8 ff ff       	call   8011fd <fd2num>
  8019ef:	89 c3                	mov    %eax,%ebx
  8019f1:	83 c4 10             	add    $0x10,%esp
}
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    
		fd_close(fd, 0);
  8019fd:	83 ec 08             	sub    $0x8,%esp
  801a00:	6a 00                	push   $0x0
  801a02:	ff 75 f4             	pushl  -0xc(%ebp)
  801a05:	e8 15 f9 ff ff       	call   80131f <fd_close>
		return r;
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	eb e5                	jmp    8019f4 <open+0x6c>
		return -E_BAD_PATH;
  801a0f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a14:	eb de                	jmp    8019f4 <open+0x6c>

00801a16 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a21:	b8 08 00 00 00       	mov    $0x8,%eax
  801a26:	e8 64 fd ff ff       	call   80178f <fsipc>
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a2d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a31:	7e 38                	jle    801a6b <writebuf+0x3e>
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	53                   	push   %ebx
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a3c:	ff 70 04             	pushl  0x4(%eax)
  801a3f:	8d 40 10             	lea    0x10(%eax),%eax
  801a42:	50                   	push   %eax
  801a43:	ff 33                	pushl  (%ebx)
  801a45:	e8 68 fb ff ff       	call   8015b2 <write>
		if (result > 0)
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	7e 03                	jle    801a54 <writebuf+0x27>
			b->result += result;
  801a51:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a54:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a57:	74 0d                	je     801a66 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a60:	0f 4f c2             	cmovg  %edx,%eax
  801a63:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    
  801a6b:	f3 c3                	repz ret 

00801a6d <putch>:

static void
putch(int ch, void *thunk)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	53                   	push   %ebx
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a77:	8b 53 04             	mov    0x4(%ebx),%edx
  801a7a:	8d 42 01             	lea    0x1(%edx),%eax
  801a7d:	89 43 04             	mov    %eax,0x4(%ebx)
  801a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a83:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a87:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a8c:	74 06                	je     801a94 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a8e:	83 c4 04             	add    $0x4,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    
		writebuf(b);
  801a94:	89 d8                	mov    %ebx,%eax
  801a96:	e8 92 ff ff ff       	call   801a2d <writebuf>
		b->idx = 0;
  801a9b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801aa2:	eb ea                	jmp    801a8e <putch+0x21>

00801aa4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801ab6:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801abd:	00 00 00 
	b.result = 0;
  801ac0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ac7:	00 00 00 
	b.error = 1;
  801aca:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801ad1:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801ad4:	ff 75 10             	pushl  0x10(%ebp)
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ae0:	50                   	push   %eax
  801ae1:	68 6d 1a 80 00       	push   $0x801a6d
  801ae6:	e8 15 ea ff ff       	call   800500 <vprintfmt>
	if (b.idx > 0)
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801af5:	7f 11                	jg     801b08 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801af7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801afd:	85 c0                	test   %eax,%eax
  801aff:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    
		writebuf(&b);
  801b08:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b0e:	e8 1a ff ff ff       	call   801a2d <writebuf>
  801b13:	eb e2                	jmp    801af7 <vfprintf+0x53>

00801b15 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b1b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b1e:	50                   	push   %eax
  801b1f:	ff 75 0c             	pushl  0xc(%ebp)
  801b22:	ff 75 08             	pushl  0x8(%ebp)
  801b25:	e8 7a ff ff ff       	call   801aa4 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <printf>:

int
printf(const char *fmt, ...)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b32:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b35:	50                   	push   %eax
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	6a 01                	push   $0x1
  801b3b:	e8 64 ff ff ff       	call   801aa4 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	56                   	push   %esi
  801b46:	53                   	push   %ebx
  801b47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	ff 75 08             	pushl  0x8(%ebp)
  801b50:	e8 b8 f6 ff ff       	call   80120d <fd2data>
  801b55:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b57:	83 c4 08             	add    $0x8,%esp
  801b5a:	68 df 2c 80 00       	push   $0x802cdf
  801b5f:	53                   	push   %ebx
  801b60:	e8 3b ef ff ff       	call   800aa0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b65:	8b 46 04             	mov    0x4(%esi),%eax
  801b68:	2b 06                	sub    (%esi),%eax
  801b6a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b70:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b77:	00 00 00 
	stat->st_dev = &devpipe;
  801b7a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b81:	30 80 00 
	return 0;
}
  801b84:	b8 00 00 00 00       	mov    $0x0,%eax
  801b89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8c:	5b                   	pop    %ebx
  801b8d:	5e                   	pop    %esi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	53                   	push   %ebx
  801b94:	83 ec 0c             	sub    $0xc,%esp
  801b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b9a:	53                   	push   %ebx
  801b9b:	6a 00                	push   $0x0
  801b9d:	e8 7c f3 ff ff       	call   800f1e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ba2:	89 1c 24             	mov    %ebx,(%esp)
  801ba5:	e8 63 f6 ff ff       	call   80120d <fd2data>
  801baa:	83 c4 08             	add    $0x8,%esp
  801bad:	50                   	push   %eax
  801bae:	6a 00                	push   $0x0
  801bb0:	e8 69 f3 ff ff       	call   800f1e <sys_page_unmap>
}
  801bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <_pipeisclosed>:
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 1c             	sub    $0x1c,%esp
  801bc3:	89 c7                	mov    %eax,%edi
  801bc5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bc7:	a1 20 44 80 00       	mov    0x804420,%eax
  801bcc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	57                   	push   %edi
  801bd3:	e8 94 09 00 00       	call   80256c <pageref>
  801bd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bdb:	89 34 24             	mov    %esi,(%esp)
  801bde:	e8 89 09 00 00       	call   80256c <pageref>
		nn = thisenv->env_runs;
  801be3:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801be9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	39 cb                	cmp    %ecx,%ebx
  801bf1:	74 1b                	je     801c0e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bf3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bf6:	75 cf                	jne    801bc7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bf8:	8b 42 58             	mov    0x58(%edx),%eax
  801bfb:	6a 01                	push   $0x1
  801bfd:	50                   	push   %eax
  801bfe:	53                   	push   %ebx
  801bff:	68 e6 2c 80 00       	push   $0x802ce6
  801c04:	e8 fa e7 ff ff       	call   800403 <cprintf>
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	eb b9                	jmp    801bc7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c0e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c11:	0f 94 c0             	sete   %al
  801c14:	0f b6 c0             	movzbl %al,%eax
}
  801c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5f                   	pop    %edi
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    

00801c1f <devpipe_write>:
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	57                   	push   %edi
  801c23:	56                   	push   %esi
  801c24:	53                   	push   %ebx
  801c25:	83 ec 28             	sub    $0x28,%esp
  801c28:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c2b:	56                   	push   %esi
  801c2c:	e8 dc f5 ff ff       	call   80120d <fd2data>
  801c31:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	bf 00 00 00 00       	mov    $0x0,%edi
  801c3b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c3e:	74 4f                	je     801c8f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c40:	8b 43 04             	mov    0x4(%ebx),%eax
  801c43:	8b 0b                	mov    (%ebx),%ecx
  801c45:	8d 51 20             	lea    0x20(%ecx),%edx
  801c48:	39 d0                	cmp    %edx,%eax
  801c4a:	72 14                	jb     801c60 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c4c:	89 da                	mov    %ebx,%edx
  801c4e:	89 f0                	mov    %esi,%eax
  801c50:	e8 65 ff ff ff       	call   801bba <_pipeisclosed>
  801c55:	85 c0                	test   %eax,%eax
  801c57:	75 3a                	jne    801c93 <devpipe_write+0x74>
			sys_yield();
  801c59:	e8 1c f2 ff ff       	call   800e7a <sys_yield>
  801c5e:	eb e0                	jmp    801c40 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c63:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c67:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c6a:	89 c2                	mov    %eax,%edx
  801c6c:	c1 fa 1f             	sar    $0x1f,%edx
  801c6f:	89 d1                	mov    %edx,%ecx
  801c71:	c1 e9 1b             	shr    $0x1b,%ecx
  801c74:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c77:	83 e2 1f             	and    $0x1f,%edx
  801c7a:	29 ca                	sub    %ecx,%edx
  801c7c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c80:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c84:	83 c0 01             	add    $0x1,%eax
  801c87:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c8a:	83 c7 01             	add    $0x1,%edi
  801c8d:	eb ac                	jmp    801c3b <devpipe_write+0x1c>
	return i;
  801c8f:	89 f8                	mov    %edi,%eax
  801c91:	eb 05                	jmp    801c98 <devpipe_write+0x79>
				return 0;
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    

00801ca0 <devpipe_read>:
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	57                   	push   %edi
  801ca4:	56                   	push   %esi
  801ca5:	53                   	push   %ebx
  801ca6:	83 ec 18             	sub    $0x18,%esp
  801ca9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cac:	57                   	push   %edi
  801cad:	e8 5b f5 ff ff       	call   80120d <fd2data>
  801cb2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	be 00 00 00 00       	mov    $0x0,%esi
  801cbc:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cbf:	74 47                	je     801d08 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801cc1:	8b 03                	mov    (%ebx),%eax
  801cc3:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cc6:	75 22                	jne    801cea <devpipe_read+0x4a>
			if (i > 0)
  801cc8:	85 f6                	test   %esi,%esi
  801cca:	75 14                	jne    801ce0 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801ccc:	89 da                	mov    %ebx,%edx
  801cce:	89 f8                	mov    %edi,%eax
  801cd0:	e8 e5 fe ff ff       	call   801bba <_pipeisclosed>
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	75 33                	jne    801d0c <devpipe_read+0x6c>
			sys_yield();
  801cd9:	e8 9c f1 ff ff       	call   800e7a <sys_yield>
  801cde:	eb e1                	jmp    801cc1 <devpipe_read+0x21>
				return i;
  801ce0:	89 f0                	mov    %esi,%eax
}
  801ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cea:	99                   	cltd   
  801ceb:	c1 ea 1b             	shr    $0x1b,%edx
  801cee:	01 d0                	add    %edx,%eax
  801cf0:	83 e0 1f             	and    $0x1f,%eax
  801cf3:	29 d0                	sub    %edx,%eax
  801cf5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cfd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d00:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d03:	83 c6 01             	add    $0x1,%esi
  801d06:	eb b4                	jmp    801cbc <devpipe_read+0x1c>
	return i;
  801d08:	89 f0                	mov    %esi,%eax
  801d0a:	eb d6                	jmp    801ce2 <devpipe_read+0x42>
				return 0;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d11:	eb cf                	jmp    801ce2 <devpipe_read+0x42>

00801d13 <pipe>:
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1e:	50                   	push   %eax
  801d1f:	e8 00 f5 ff ff       	call   801224 <fd_alloc>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 5b                	js     801d88 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	68 07 04 00 00       	push   $0x407
  801d35:	ff 75 f4             	pushl  -0xc(%ebp)
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 5a f1 ff ff       	call   800e99 <sys_page_alloc>
  801d3f:	89 c3                	mov    %eax,%ebx
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 40                	js     801d88 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d4e:	50                   	push   %eax
  801d4f:	e8 d0 f4 ff ff       	call   801224 <fd_alloc>
  801d54:	89 c3                	mov    %eax,%ebx
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 1b                	js     801d78 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	68 07 04 00 00       	push   $0x407
  801d65:	ff 75 f0             	pushl  -0x10(%ebp)
  801d68:	6a 00                	push   $0x0
  801d6a:	e8 2a f1 ff ff       	call   800e99 <sys_page_alloc>
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	85 c0                	test   %eax,%eax
  801d76:	79 19                	jns    801d91 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d78:	83 ec 08             	sub    $0x8,%esp
  801d7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7e:	6a 00                	push   $0x0
  801d80:	e8 99 f1 ff ff       	call   800f1e <sys_page_unmap>
  801d85:	83 c4 10             	add    $0x10,%esp
}
  801d88:	89 d8                	mov    %ebx,%eax
  801d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8d:	5b                   	pop    %ebx
  801d8e:	5e                   	pop    %esi
  801d8f:	5d                   	pop    %ebp
  801d90:	c3                   	ret    
	va = fd2data(fd0);
  801d91:	83 ec 0c             	sub    $0xc,%esp
  801d94:	ff 75 f4             	pushl  -0xc(%ebp)
  801d97:	e8 71 f4 ff ff       	call   80120d <fd2data>
  801d9c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d9e:	83 c4 0c             	add    $0xc,%esp
  801da1:	68 07 04 00 00       	push   $0x407
  801da6:	50                   	push   %eax
  801da7:	6a 00                	push   $0x0
  801da9:	e8 eb f0 ff ff       	call   800e99 <sys_page_alloc>
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	85 c0                	test   %eax,%eax
  801db5:	0f 88 8c 00 00 00    	js     801e47 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbb:	83 ec 0c             	sub    $0xc,%esp
  801dbe:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc1:	e8 47 f4 ff ff       	call   80120d <fd2data>
  801dc6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dcd:	50                   	push   %eax
  801dce:	6a 00                	push   $0x0
  801dd0:	56                   	push   %esi
  801dd1:	6a 00                	push   $0x0
  801dd3:	e8 04 f1 ff ff       	call   800edc <sys_page_map>
  801dd8:	89 c3                	mov    %eax,%ebx
  801dda:	83 c4 20             	add    $0x20,%esp
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	78 58                	js     801e39 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dea:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dff:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e04:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e0b:	83 ec 0c             	sub    $0xc,%esp
  801e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e11:	e8 e7 f3 ff ff       	call   8011fd <fd2num>
  801e16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e19:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e1b:	83 c4 04             	add    $0x4,%esp
  801e1e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e21:	e8 d7 f3 ff ff       	call   8011fd <fd2num>
  801e26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e29:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e34:	e9 4f ff ff ff       	jmp    801d88 <pipe+0x75>
	sys_page_unmap(0, va);
  801e39:	83 ec 08             	sub    $0x8,%esp
  801e3c:	56                   	push   %esi
  801e3d:	6a 00                	push   $0x0
  801e3f:	e8 da f0 ff ff       	call   800f1e <sys_page_unmap>
  801e44:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e47:	83 ec 08             	sub    $0x8,%esp
  801e4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e4d:	6a 00                	push   $0x0
  801e4f:	e8 ca f0 ff ff       	call   800f1e <sys_page_unmap>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	e9 1c ff ff ff       	jmp    801d78 <pipe+0x65>

00801e5c <pipeisclosed>:
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e65:	50                   	push   %eax
  801e66:	ff 75 08             	pushl  0x8(%ebp)
  801e69:	e8 05 f4 ff ff       	call   801273 <fd_lookup>
  801e6e:	83 c4 10             	add    $0x10,%esp
  801e71:	85 c0                	test   %eax,%eax
  801e73:	78 18                	js     801e8d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7b:	e8 8d f3 ff ff       	call   80120d <fd2data>
	return _pipeisclosed(fd, p);
  801e80:	89 c2                	mov    %eax,%edx
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	e8 30 fd ff ff       	call   801bba <_pipeisclosed>
  801e8a:	83 c4 10             	add    $0x10,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e95:	68 fe 2c 80 00       	push   $0x802cfe
  801e9a:	ff 75 0c             	pushl  0xc(%ebp)
  801e9d:	e8 fe eb ff ff       	call   800aa0 <strcpy>
	return 0;
}
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <devsock_close>:
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	53                   	push   %ebx
  801ead:	83 ec 10             	sub    $0x10,%esp
  801eb0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eb3:	53                   	push   %ebx
  801eb4:	e8 b3 06 00 00       	call   80256c <pageref>
  801eb9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ebc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ec1:	83 f8 01             	cmp    $0x1,%eax
  801ec4:	74 07                	je     801ecd <devsock_close+0x24>
}
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	ff 73 0c             	pushl  0xc(%ebx)
  801ed3:	e8 b7 02 00 00       	call   80218f <nsipc_close>
  801ed8:	89 c2                	mov    %eax,%edx
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	eb e7                	jmp    801ec6 <devsock_close+0x1d>

00801edf <devsock_write>:
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	ff 75 10             	pushl  0x10(%ebp)
  801eea:	ff 75 0c             	pushl  0xc(%ebp)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	ff 70 0c             	pushl  0xc(%eax)
  801ef3:	e8 74 03 00 00       	call   80226c <nsipc_send>
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <devsock_read>:
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	ff 75 10             	pushl  0x10(%ebp)
  801f05:	ff 75 0c             	pushl  0xc(%ebp)
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	ff 70 0c             	pushl  0xc(%eax)
  801f0e:	e8 ed 02 00 00       	call   802200 <nsipc_recv>
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <fd2sockid>:
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f1b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f1e:	52                   	push   %edx
  801f1f:	50                   	push   %eax
  801f20:	e8 4e f3 ff ff       	call   801273 <fd_lookup>
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 10                	js     801f3c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801f35:	39 08                	cmp    %ecx,(%eax)
  801f37:	75 05                	jne    801f3e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f39:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    
		return -E_NOT_SUPP;
  801f3e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f43:	eb f7                	jmp    801f3c <fd2sockid+0x27>

00801f45 <alloc_sockfd>:
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	56                   	push   %esi
  801f49:	53                   	push   %ebx
  801f4a:	83 ec 1c             	sub    $0x1c,%esp
  801f4d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f52:	50                   	push   %eax
  801f53:	e8 cc f2 ff ff       	call   801224 <fd_alloc>
  801f58:	89 c3                	mov    %eax,%ebx
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	78 43                	js     801fa4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	68 07 04 00 00       	push   $0x407
  801f69:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6c:	6a 00                	push   $0x0
  801f6e:	e8 26 ef ff ff       	call   800e99 <sys_page_alloc>
  801f73:	89 c3                	mov    %eax,%ebx
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	78 28                	js     801fa4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f85:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f91:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	50                   	push   %eax
  801f98:	e8 60 f2 ff ff       	call   8011fd <fd2num>
  801f9d:	89 c3                	mov    %eax,%ebx
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	eb 0c                	jmp    801fb0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fa4:	83 ec 0c             	sub    $0xc,%esp
  801fa7:	56                   	push   %esi
  801fa8:	e8 e2 01 00 00       	call   80218f <nsipc_close>
		return r;
  801fad:	83 c4 10             	add    $0x10,%esp
}
  801fb0:	89 d8                	mov    %ebx,%eax
  801fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb5:	5b                   	pop    %ebx
  801fb6:	5e                   	pop    %esi
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <accept>:
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	e8 4e ff ff ff       	call   801f15 <fd2sockid>
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	78 1b                	js     801fe6 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fcb:	83 ec 04             	sub    $0x4,%esp
  801fce:	ff 75 10             	pushl  0x10(%ebp)
  801fd1:	ff 75 0c             	pushl  0xc(%ebp)
  801fd4:	50                   	push   %eax
  801fd5:	e8 0e 01 00 00       	call   8020e8 <nsipc_accept>
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	78 05                	js     801fe6 <accept+0x2d>
	return alloc_sockfd(r);
  801fe1:	e8 5f ff ff ff       	call   801f45 <alloc_sockfd>
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <bind>:
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	e8 1f ff ff ff       	call   801f15 <fd2sockid>
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 12                	js     80200c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	ff 75 10             	pushl  0x10(%ebp)
  802000:	ff 75 0c             	pushl  0xc(%ebp)
  802003:	50                   	push   %eax
  802004:	e8 2f 01 00 00       	call   802138 <nsipc_bind>
  802009:	83 c4 10             	add    $0x10,%esp
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <shutdown>:
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	e8 f9 fe ff ff       	call   801f15 <fd2sockid>
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 0f                	js     80202f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802020:	83 ec 08             	sub    $0x8,%esp
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	50                   	push   %eax
  802027:	e8 41 01 00 00       	call   80216d <nsipc_shutdown>
  80202c:	83 c4 10             	add    $0x10,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <connect>:
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	e8 d6 fe ff ff       	call   801f15 <fd2sockid>
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 12                	js     802055 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	ff 75 10             	pushl  0x10(%ebp)
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	50                   	push   %eax
  80204d:	e8 57 01 00 00       	call   8021a9 <nsipc_connect>
  802052:	83 c4 10             	add    $0x10,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <listen>:
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	e8 b0 fe ff ff       	call   801f15 <fd2sockid>
  802065:	85 c0                	test   %eax,%eax
  802067:	78 0f                	js     802078 <listen+0x21>
	return nsipc_listen(r, backlog);
  802069:	83 ec 08             	sub    $0x8,%esp
  80206c:	ff 75 0c             	pushl  0xc(%ebp)
  80206f:	50                   	push   %eax
  802070:	e8 69 01 00 00       	call   8021de <nsipc_listen>
  802075:	83 c4 10             	add    $0x10,%esp
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <socket>:

int
socket(int domain, int type, int protocol)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802080:	ff 75 10             	pushl  0x10(%ebp)
  802083:	ff 75 0c             	pushl  0xc(%ebp)
  802086:	ff 75 08             	pushl  0x8(%ebp)
  802089:	e8 3c 02 00 00       	call   8022ca <nsipc_socket>
  80208e:	83 c4 10             	add    $0x10,%esp
  802091:	85 c0                	test   %eax,%eax
  802093:	78 05                	js     80209a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802095:	e8 ab fe ff ff       	call   801f45 <alloc_sockfd>
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	53                   	push   %ebx
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020a5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8020ac:	74 26                	je     8020d4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020ae:	6a 07                	push   $0x7
  8020b0:	68 00 60 80 00       	push   $0x806000
  8020b5:	53                   	push   %ebx
  8020b6:	ff 35 04 40 80 00    	pushl  0x804004
  8020bc:	e8 19 04 00 00       	call   8024da <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020c1:	83 c4 0c             	add    $0xc,%esp
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	e8 a2 03 00 00       	call   802471 <ipc_recv>
}
  8020cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	6a 02                	push   $0x2
  8020d9:	e8 55 04 00 00       	call   802533 <ipc_find_env>
  8020de:	a3 04 40 80 00       	mov    %eax,0x804004
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	eb c6                	jmp    8020ae <nsipc+0x12>

008020e8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	56                   	push   %esi
  8020ec:	53                   	push   %ebx
  8020ed:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020f8:	8b 06                	mov    (%esi),%eax
  8020fa:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802104:	e8 93 ff ff ff       	call   80209c <nsipc>
  802109:	89 c3                	mov    %eax,%ebx
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 20                	js     80212f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	ff 35 10 60 80 00    	pushl  0x806010
  802118:	68 00 60 80 00       	push   $0x806000
  80211d:	ff 75 0c             	pushl  0xc(%ebp)
  802120:	e8 09 eb ff ff       	call   800c2e <memmove>
		*addrlen = ret->ret_addrlen;
  802125:	a1 10 60 80 00       	mov    0x806010,%eax
  80212a:	89 06                	mov    %eax,(%esi)
  80212c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80212f:	89 d8                	mov    %ebx,%eax
  802131:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    

00802138 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	53                   	push   %ebx
  80213c:	83 ec 08             	sub    $0x8,%esp
  80213f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80214a:	53                   	push   %ebx
  80214b:	ff 75 0c             	pushl  0xc(%ebp)
  80214e:	68 04 60 80 00       	push   $0x806004
  802153:	e8 d6 ea ff ff       	call   800c2e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802158:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80215e:	b8 02 00 00 00       	mov    $0x2,%eax
  802163:	e8 34 ff ff ff       	call   80209c <nsipc>
}
  802168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80217b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802183:	b8 03 00 00 00       	mov    $0x3,%eax
  802188:	e8 0f ff ff ff       	call   80209c <nsipc>
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <nsipc_close>:

int
nsipc_close(int s)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80219d:	b8 04 00 00 00       	mov    $0x4,%eax
  8021a2:	e8 f5 fe ff ff       	call   80209c <nsipc>
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	53                   	push   %ebx
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021bb:	53                   	push   %ebx
  8021bc:	ff 75 0c             	pushl  0xc(%ebp)
  8021bf:	68 04 60 80 00       	push   $0x806004
  8021c4:	e8 65 ea ff ff       	call   800c2e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021c9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8021cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8021d4:	e8 c3 fe ff ff       	call   80209c <nsipc>
}
  8021d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8021f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8021f9:	e8 9e fe ff ff       	call   80209c <nsipc>
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	56                   	push   %esi
  802204:	53                   	push   %ebx
  802205:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802210:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802216:	8b 45 14             	mov    0x14(%ebp),%eax
  802219:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80221e:	b8 07 00 00 00       	mov    $0x7,%eax
  802223:	e8 74 fe ff ff       	call   80209c <nsipc>
  802228:	89 c3                	mov    %eax,%ebx
  80222a:	85 c0                	test   %eax,%eax
  80222c:	78 1f                	js     80224d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80222e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802233:	7f 21                	jg     802256 <nsipc_recv+0x56>
  802235:	39 c6                	cmp    %eax,%esi
  802237:	7c 1d                	jl     802256 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	50                   	push   %eax
  80223d:	68 00 60 80 00       	push   $0x806000
  802242:	ff 75 0c             	pushl  0xc(%ebp)
  802245:	e8 e4 e9 ff ff       	call   800c2e <memmove>
  80224a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80224d:	89 d8                	mov    %ebx,%eax
  80224f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802252:	5b                   	pop    %ebx
  802253:	5e                   	pop    %esi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802256:	68 0a 2d 80 00       	push   $0x802d0a
  80225b:	68 ac 2c 80 00       	push   $0x802cac
  802260:	6a 62                	push   $0x62
  802262:	68 1f 2d 80 00       	push   $0x802d1f
  802267:	e8 bc e0 ff ff       	call   800328 <_panic>

0080226c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	53                   	push   %ebx
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80227e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802284:	7f 2e                	jg     8022b4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	53                   	push   %ebx
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	68 0c 60 80 00       	push   $0x80600c
  802292:	e8 97 e9 ff ff       	call   800c2e <memmove>
	nsipcbuf.send.req_size = size;
  802297:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80229d:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8022aa:	e8 ed fd ff ff       	call   80209c <nsipc>
}
  8022af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    
	assert(size < 1600);
  8022b4:	68 2b 2d 80 00       	push   $0x802d2b
  8022b9:	68 ac 2c 80 00       	push   $0x802cac
  8022be:	6a 6d                	push   $0x6d
  8022c0:	68 1f 2d 80 00       	push   $0x802d1f
  8022c5:	e8 5e e0 ff ff       	call   800328 <_panic>

008022ca <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8022d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022db:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022e8:	b8 09 00 00 00       	mov    $0x9,%eax
  8022ed:	e8 aa fd ff ff       	call   80209c <nsipc>
}
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802304:	68 37 2d 80 00       	push   $0x802d37
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	e8 8f e7 ff ff       	call   800aa0 <strcpy>
	return 0;
}
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <devcons_write>:
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	57                   	push   %edi
  80231c:	56                   	push   %esi
  80231d:	53                   	push   %ebx
  80231e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802324:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802329:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80232f:	eb 2f                	jmp    802360 <devcons_write+0x48>
		m = n - tot;
  802331:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802334:	29 f3                	sub    %esi,%ebx
  802336:	83 fb 7f             	cmp    $0x7f,%ebx
  802339:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80233e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	53                   	push   %ebx
  802345:	89 f0                	mov    %esi,%eax
  802347:	03 45 0c             	add    0xc(%ebp),%eax
  80234a:	50                   	push   %eax
  80234b:	57                   	push   %edi
  80234c:	e8 dd e8 ff ff       	call   800c2e <memmove>
		sys_cputs(buf, m);
  802351:	83 c4 08             	add    $0x8,%esp
  802354:	53                   	push   %ebx
  802355:	57                   	push   %edi
  802356:	e8 82 ea ff ff       	call   800ddd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80235b:	01 de                	add    %ebx,%esi
  80235d:	83 c4 10             	add    $0x10,%esp
  802360:	3b 75 10             	cmp    0x10(%ebp),%esi
  802363:	72 cc                	jb     802331 <devcons_write+0x19>
}
  802365:	89 f0                	mov    %esi,%eax
  802367:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80236a:	5b                   	pop    %ebx
  80236b:	5e                   	pop    %esi
  80236c:	5f                   	pop    %edi
  80236d:	5d                   	pop    %ebp
  80236e:	c3                   	ret    

0080236f <devcons_read>:
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	83 ec 08             	sub    $0x8,%esp
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80237a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80237e:	75 07                	jne    802387 <devcons_read+0x18>
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    
		sys_yield();
  802382:	e8 f3 ea ff ff       	call   800e7a <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802387:	e8 6f ea ff ff       	call   800dfb <sys_cgetc>
  80238c:	85 c0                	test   %eax,%eax
  80238e:	74 f2                	je     802382 <devcons_read+0x13>
	if (c < 0)
  802390:	85 c0                	test   %eax,%eax
  802392:	78 ec                	js     802380 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802394:	83 f8 04             	cmp    $0x4,%eax
  802397:	74 0c                	je     8023a5 <devcons_read+0x36>
	*(char*)vbuf = c;
  802399:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239c:	88 02                	mov    %al,(%edx)
	return 1;
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	eb db                	jmp    802380 <devcons_read+0x11>
		return 0;
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023aa:	eb d4                	jmp    802380 <devcons_read+0x11>

008023ac <cputchar>:
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023b8:	6a 01                	push   $0x1
  8023ba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023bd:	50                   	push   %eax
  8023be:	e8 1a ea ff ff       	call   800ddd <sys_cputs>
}
  8023c3:	83 c4 10             	add    $0x10,%esp
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <getchar>:
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023ce:	6a 01                	push   $0x1
  8023d0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023d3:	50                   	push   %eax
  8023d4:	6a 00                	push   $0x0
  8023d6:	e8 09 f1 ff ff       	call   8014e4 <read>
	if (r < 0)
  8023db:	83 c4 10             	add    $0x10,%esp
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	78 08                	js     8023ea <getchar+0x22>
	if (r < 1)
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	7e 06                	jle    8023ec <getchar+0x24>
	return c;
  8023e6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    
		return -E_EOF;
  8023ec:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023f1:	eb f7                	jmp    8023ea <getchar+0x22>

008023f3 <iscons>:
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023fc:	50                   	push   %eax
  8023fd:	ff 75 08             	pushl  0x8(%ebp)
  802400:	e8 6e ee ff ff       	call   801273 <fd_lookup>
  802405:	83 c4 10             	add    $0x10,%esp
  802408:	85 c0                	test   %eax,%eax
  80240a:	78 11                	js     80241d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802415:	39 10                	cmp    %edx,(%eax)
  802417:	0f 94 c0             	sete   %al
  80241a:	0f b6 c0             	movzbl %al,%eax
}
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <opencons>:
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802425:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802428:	50                   	push   %eax
  802429:	e8 f6 ed ff ff       	call   801224 <fd_alloc>
  80242e:	83 c4 10             	add    $0x10,%esp
  802431:	85 c0                	test   %eax,%eax
  802433:	78 3a                	js     80246f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	68 07 04 00 00       	push   $0x407
  80243d:	ff 75 f4             	pushl  -0xc(%ebp)
  802440:	6a 00                	push   $0x0
  802442:	e8 52 ea ff ff       	call   800e99 <sys_page_alloc>
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	85 c0                	test   %eax,%eax
  80244c:	78 21                	js     80246f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802457:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802463:	83 ec 0c             	sub    $0xc,%esp
  802466:	50                   	push   %eax
  802467:	e8 91 ed ff ff       	call   8011fd <fd2num>
  80246c:	83 c4 10             	add    $0x10,%esp
}
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	56                   	push   %esi
  802475:	53                   	push   %ebx
  802476:	8b 75 08             	mov    0x8(%ebp),%esi
  802479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80247f:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802481:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802486:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802489:	83 ec 0c             	sub    $0xc,%esp
  80248c:	50                   	push   %eax
  80248d:	e8 b7 eb ff ff       	call   801049 <sys_ipc_recv>
  802492:	83 c4 10             	add    $0x10,%esp
  802495:	85 c0                	test   %eax,%eax
  802497:	78 2b                	js     8024c4 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802499:	85 f6                	test   %esi,%esi
  80249b:	74 0a                	je     8024a7 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80249d:	a1 20 44 80 00       	mov    0x804420,%eax
  8024a2:	8b 40 74             	mov    0x74(%eax),%eax
  8024a5:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8024a7:	85 db                	test   %ebx,%ebx
  8024a9:	74 0a                	je     8024b5 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8024ab:	a1 20 44 80 00       	mov    0x804420,%eax
  8024b0:	8b 40 78             	mov    0x78(%eax),%eax
  8024b3:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8024b5:	a1 20 44 80 00       	mov    0x804420,%eax
  8024ba:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024c0:	5b                   	pop    %ebx
  8024c1:	5e                   	pop    %esi
  8024c2:	5d                   	pop    %ebp
  8024c3:	c3                   	ret    
	    if (from_env_store != NULL) {
  8024c4:	85 f6                	test   %esi,%esi
  8024c6:	74 06                	je     8024ce <ipc_recv+0x5d>
	        *from_env_store = 0;
  8024c8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8024ce:	85 db                	test   %ebx,%ebx
  8024d0:	74 eb                	je     8024bd <ipc_recv+0x4c>
	        *perm_store = 0;
  8024d2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024d8:	eb e3                	jmp    8024bd <ipc_recv+0x4c>

008024da <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	57                   	push   %edi
  8024de:	56                   	push   %esi
  8024df:	53                   	push   %ebx
  8024e0:	83 ec 0c             	sub    $0xc,%esp
  8024e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024e6:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8024e9:	85 f6                	test   %esi,%esi
  8024eb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024f0:	0f 44 f0             	cmove  %eax,%esi
  8024f3:	eb 09                	jmp    8024fe <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8024f5:	e8 80 e9 ff ff       	call   800e7a <sys_yield>
	} while(r != 0);
  8024fa:	85 db                	test   %ebx,%ebx
  8024fc:	74 2d                	je     80252b <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8024fe:	ff 75 14             	pushl  0x14(%ebp)
  802501:	56                   	push   %esi
  802502:	ff 75 0c             	pushl  0xc(%ebp)
  802505:	57                   	push   %edi
  802506:	e8 1b eb ff ff       	call   801026 <sys_ipc_try_send>
  80250b:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	85 c0                	test   %eax,%eax
  802512:	79 e1                	jns    8024f5 <ipc_send+0x1b>
  802514:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802517:	74 dc                	je     8024f5 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802519:	50                   	push   %eax
  80251a:	68 43 2d 80 00       	push   $0x802d43
  80251f:	6a 45                	push   $0x45
  802521:	68 50 2d 80 00       	push   $0x802d50
  802526:	e8 fd dd ff ff       	call   800328 <_panic>
}
  80252b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80252e:	5b                   	pop    %ebx
  80252f:	5e                   	pop    %esi
  802530:	5f                   	pop    %edi
  802531:	5d                   	pop    %ebp
  802532:	c3                   	ret    

00802533 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80253e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802541:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802547:	8b 52 50             	mov    0x50(%edx),%edx
  80254a:	39 ca                	cmp    %ecx,%edx
  80254c:	74 11                	je     80255f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80254e:	83 c0 01             	add    $0x1,%eax
  802551:	3d 00 04 00 00       	cmp    $0x400,%eax
  802556:	75 e6                	jne    80253e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
  80255d:	eb 0b                	jmp    80256a <ipc_find_env+0x37>
			return envs[i].env_id;
  80255f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802562:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802567:	8b 40 48             	mov    0x48(%eax),%eax
}
  80256a:	5d                   	pop    %ebp
  80256b:	c3                   	ret    

0080256c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802572:	89 d0                	mov    %edx,%eax
  802574:	c1 e8 16             	shr    $0x16,%eax
  802577:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802583:	f6 c1 01             	test   $0x1,%cl
  802586:	74 1d                	je     8025a5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802588:	c1 ea 0c             	shr    $0xc,%edx
  80258b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802592:	f6 c2 01             	test   $0x1,%dl
  802595:	74 0e                	je     8025a5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802597:	c1 ea 0c             	shr    $0xc,%edx
  80259a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025a1:	ef 
  8025a2:	0f b7 c0             	movzwl %ax,%eax
}
  8025a5:	5d                   	pop    %ebp
  8025a6:	c3                   	ret    
  8025a7:	66 90                	xchg   %ax,%ax
  8025a9:	66 90                	xchg   %ax,%ax
  8025ab:	66 90                	xchg   %ax,%ax
  8025ad:	66 90                	xchg   %ax,%ax
  8025af:	90                   	nop

008025b0 <__udivdi3>:
  8025b0:	55                   	push   %ebp
  8025b1:	57                   	push   %edi
  8025b2:	56                   	push   %esi
  8025b3:	53                   	push   %ebx
  8025b4:	83 ec 1c             	sub    $0x1c,%esp
  8025b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025c7:	85 d2                	test   %edx,%edx
  8025c9:	75 35                	jne    802600 <__udivdi3+0x50>
  8025cb:	39 f3                	cmp    %esi,%ebx
  8025cd:	0f 87 bd 00 00 00    	ja     802690 <__udivdi3+0xe0>
  8025d3:	85 db                	test   %ebx,%ebx
  8025d5:	89 d9                	mov    %ebx,%ecx
  8025d7:	75 0b                	jne    8025e4 <__udivdi3+0x34>
  8025d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8025de:	31 d2                	xor    %edx,%edx
  8025e0:	f7 f3                	div    %ebx
  8025e2:	89 c1                	mov    %eax,%ecx
  8025e4:	31 d2                	xor    %edx,%edx
  8025e6:	89 f0                	mov    %esi,%eax
  8025e8:	f7 f1                	div    %ecx
  8025ea:	89 c6                	mov    %eax,%esi
  8025ec:	89 e8                	mov    %ebp,%eax
  8025ee:	89 f7                	mov    %esi,%edi
  8025f0:	f7 f1                	div    %ecx
  8025f2:	89 fa                	mov    %edi,%edx
  8025f4:	83 c4 1c             	add    $0x1c,%esp
  8025f7:	5b                   	pop    %ebx
  8025f8:	5e                   	pop    %esi
  8025f9:	5f                   	pop    %edi
  8025fa:	5d                   	pop    %ebp
  8025fb:	c3                   	ret    
  8025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802600:	39 f2                	cmp    %esi,%edx
  802602:	77 7c                	ja     802680 <__udivdi3+0xd0>
  802604:	0f bd fa             	bsr    %edx,%edi
  802607:	83 f7 1f             	xor    $0x1f,%edi
  80260a:	0f 84 98 00 00 00    	je     8026a8 <__udivdi3+0xf8>
  802610:	89 f9                	mov    %edi,%ecx
  802612:	b8 20 00 00 00       	mov    $0x20,%eax
  802617:	29 f8                	sub    %edi,%eax
  802619:	d3 e2                	shl    %cl,%edx
  80261b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80261f:	89 c1                	mov    %eax,%ecx
  802621:	89 da                	mov    %ebx,%edx
  802623:	d3 ea                	shr    %cl,%edx
  802625:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802629:	09 d1                	or     %edx,%ecx
  80262b:	89 f2                	mov    %esi,%edx
  80262d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802631:	89 f9                	mov    %edi,%ecx
  802633:	d3 e3                	shl    %cl,%ebx
  802635:	89 c1                	mov    %eax,%ecx
  802637:	d3 ea                	shr    %cl,%edx
  802639:	89 f9                	mov    %edi,%ecx
  80263b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80263f:	d3 e6                	shl    %cl,%esi
  802641:	89 eb                	mov    %ebp,%ebx
  802643:	89 c1                	mov    %eax,%ecx
  802645:	d3 eb                	shr    %cl,%ebx
  802647:	09 de                	or     %ebx,%esi
  802649:	89 f0                	mov    %esi,%eax
  80264b:	f7 74 24 08          	divl   0x8(%esp)
  80264f:	89 d6                	mov    %edx,%esi
  802651:	89 c3                	mov    %eax,%ebx
  802653:	f7 64 24 0c          	mull   0xc(%esp)
  802657:	39 d6                	cmp    %edx,%esi
  802659:	72 0c                	jb     802667 <__udivdi3+0xb7>
  80265b:	89 f9                	mov    %edi,%ecx
  80265d:	d3 e5                	shl    %cl,%ebp
  80265f:	39 c5                	cmp    %eax,%ebp
  802661:	73 5d                	jae    8026c0 <__udivdi3+0x110>
  802663:	39 d6                	cmp    %edx,%esi
  802665:	75 59                	jne    8026c0 <__udivdi3+0x110>
  802667:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80266a:	31 ff                	xor    %edi,%edi
  80266c:	89 fa                	mov    %edi,%edx
  80266e:	83 c4 1c             	add    $0x1c,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	8d 76 00             	lea    0x0(%esi),%esi
  802679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802680:	31 ff                	xor    %edi,%edi
  802682:	31 c0                	xor    %eax,%eax
  802684:	89 fa                	mov    %edi,%edx
  802686:	83 c4 1c             	add    $0x1c,%esp
  802689:	5b                   	pop    %ebx
  80268a:	5e                   	pop    %esi
  80268b:	5f                   	pop    %edi
  80268c:	5d                   	pop    %ebp
  80268d:	c3                   	ret    
  80268e:	66 90                	xchg   %ax,%ax
  802690:	31 ff                	xor    %edi,%edi
  802692:	89 e8                	mov    %ebp,%eax
  802694:	89 f2                	mov    %esi,%edx
  802696:	f7 f3                	div    %ebx
  802698:	89 fa                	mov    %edi,%edx
  80269a:	83 c4 1c             	add    $0x1c,%esp
  80269d:	5b                   	pop    %ebx
  80269e:	5e                   	pop    %esi
  80269f:	5f                   	pop    %edi
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	39 f2                	cmp    %esi,%edx
  8026aa:	72 06                	jb     8026b2 <__udivdi3+0x102>
  8026ac:	31 c0                	xor    %eax,%eax
  8026ae:	39 eb                	cmp    %ebp,%ebx
  8026b0:	77 d2                	ja     802684 <__udivdi3+0xd4>
  8026b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b7:	eb cb                	jmp    802684 <__udivdi3+0xd4>
  8026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c0:	89 d8                	mov    %ebx,%eax
  8026c2:	31 ff                	xor    %edi,%edi
  8026c4:	eb be                	jmp    802684 <__udivdi3+0xd4>
  8026c6:	66 90                	xchg   %ax,%ax
  8026c8:	66 90                	xchg   %ax,%ax
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <__umoddi3>:
  8026d0:	55                   	push   %ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	53                   	push   %ebx
  8026d4:	83 ec 1c             	sub    $0x1c,%esp
  8026d7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8026db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026e7:	85 ed                	test   %ebp,%ebp
  8026e9:	89 f0                	mov    %esi,%eax
  8026eb:	89 da                	mov    %ebx,%edx
  8026ed:	75 19                	jne    802708 <__umoddi3+0x38>
  8026ef:	39 df                	cmp    %ebx,%edi
  8026f1:	0f 86 b1 00 00 00    	jbe    8027a8 <__umoddi3+0xd8>
  8026f7:	f7 f7                	div    %edi
  8026f9:	89 d0                	mov    %edx,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	83 c4 1c             	add    $0x1c,%esp
  802700:	5b                   	pop    %ebx
  802701:	5e                   	pop    %esi
  802702:	5f                   	pop    %edi
  802703:	5d                   	pop    %ebp
  802704:	c3                   	ret    
  802705:	8d 76 00             	lea    0x0(%esi),%esi
  802708:	39 dd                	cmp    %ebx,%ebp
  80270a:	77 f1                	ja     8026fd <__umoddi3+0x2d>
  80270c:	0f bd cd             	bsr    %ebp,%ecx
  80270f:	83 f1 1f             	xor    $0x1f,%ecx
  802712:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802716:	0f 84 b4 00 00 00    	je     8027d0 <__umoddi3+0x100>
  80271c:	b8 20 00 00 00       	mov    $0x20,%eax
  802721:	89 c2                	mov    %eax,%edx
  802723:	8b 44 24 04          	mov    0x4(%esp),%eax
  802727:	29 c2                	sub    %eax,%edx
  802729:	89 c1                	mov    %eax,%ecx
  80272b:	89 f8                	mov    %edi,%eax
  80272d:	d3 e5                	shl    %cl,%ebp
  80272f:	89 d1                	mov    %edx,%ecx
  802731:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802735:	d3 e8                	shr    %cl,%eax
  802737:	09 c5                	or     %eax,%ebp
  802739:	8b 44 24 04          	mov    0x4(%esp),%eax
  80273d:	89 c1                	mov    %eax,%ecx
  80273f:	d3 e7                	shl    %cl,%edi
  802741:	89 d1                	mov    %edx,%ecx
  802743:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802747:	89 df                	mov    %ebx,%edi
  802749:	d3 ef                	shr    %cl,%edi
  80274b:	89 c1                	mov    %eax,%ecx
  80274d:	89 f0                	mov    %esi,%eax
  80274f:	d3 e3                	shl    %cl,%ebx
  802751:	89 d1                	mov    %edx,%ecx
  802753:	89 fa                	mov    %edi,%edx
  802755:	d3 e8                	shr    %cl,%eax
  802757:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80275c:	09 d8                	or     %ebx,%eax
  80275e:	f7 f5                	div    %ebp
  802760:	d3 e6                	shl    %cl,%esi
  802762:	89 d1                	mov    %edx,%ecx
  802764:	f7 64 24 08          	mull   0x8(%esp)
  802768:	39 d1                	cmp    %edx,%ecx
  80276a:	89 c3                	mov    %eax,%ebx
  80276c:	89 d7                	mov    %edx,%edi
  80276e:	72 06                	jb     802776 <__umoddi3+0xa6>
  802770:	75 0e                	jne    802780 <__umoddi3+0xb0>
  802772:	39 c6                	cmp    %eax,%esi
  802774:	73 0a                	jae    802780 <__umoddi3+0xb0>
  802776:	2b 44 24 08          	sub    0x8(%esp),%eax
  80277a:	19 ea                	sbb    %ebp,%edx
  80277c:	89 d7                	mov    %edx,%edi
  80277e:	89 c3                	mov    %eax,%ebx
  802780:	89 ca                	mov    %ecx,%edx
  802782:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802787:	29 de                	sub    %ebx,%esi
  802789:	19 fa                	sbb    %edi,%edx
  80278b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80278f:	89 d0                	mov    %edx,%eax
  802791:	d3 e0                	shl    %cl,%eax
  802793:	89 d9                	mov    %ebx,%ecx
  802795:	d3 ee                	shr    %cl,%esi
  802797:	d3 ea                	shr    %cl,%edx
  802799:	09 f0                	or     %esi,%eax
  80279b:	83 c4 1c             	add    $0x1c,%esp
  80279e:	5b                   	pop    %ebx
  80279f:	5e                   	pop    %esi
  8027a0:	5f                   	pop    %edi
  8027a1:	5d                   	pop    %ebp
  8027a2:	c3                   	ret    
  8027a3:	90                   	nop
  8027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	85 ff                	test   %edi,%edi
  8027aa:	89 f9                	mov    %edi,%ecx
  8027ac:	75 0b                	jne    8027b9 <__umoddi3+0xe9>
  8027ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b3:	31 d2                	xor    %edx,%edx
  8027b5:	f7 f7                	div    %edi
  8027b7:	89 c1                	mov    %eax,%ecx
  8027b9:	89 d8                	mov    %ebx,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	f7 f1                	div    %ecx
  8027bf:	89 f0                	mov    %esi,%eax
  8027c1:	f7 f1                	div    %ecx
  8027c3:	e9 31 ff ff ff       	jmp    8026f9 <__umoddi3+0x29>
  8027c8:	90                   	nop
  8027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027d0:	39 dd                	cmp    %ebx,%ebp
  8027d2:	72 08                	jb     8027dc <__umoddi3+0x10c>
  8027d4:	39 f7                	cmp    %esi,%edi
  8027d6:	0f 87 21 ff ff ff    	ja     8026fd <__umoddi3+0x2d>
  8027dc:	89 da                	mov    %ebx,%edx
  8027de:	89 f0                	mov    %esi,%eax
  8027e0:	29 f8                	sub    %edi,%eax
  8027e2:	19 ea                	sbb    %ebp,%edx
  8027e4:	e9 14 ff ff ff       	jmp    8026fd <__umoddi3+0x2d>
