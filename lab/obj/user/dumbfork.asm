
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 5b 0d 00 00       	call   800da5 <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 84 0d 00 00       	call   800de8 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 bc 0a 00 00       	call   800b3a <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 9d 0d 00 00       	call   800e2a <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 a0 24 80 00       	push   $0x8024a0
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 b3 24 80 00       	push   $0x8024b3
  8000a8:	e8 87 01 00 00       	call   800234 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 c3 24 80 00       	push   $0x8024c3
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 b3 24 80 00       	push   $0x8024b3
  8000ba:	e8 75 01 00 00       	call   800234 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 d4 24 80 00       	push   $0x8024d4
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 b3 24 80 00       	push   $0x8024b3
  8000cc:	e8 63 01 00 00       	call   800234 <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 0f                	js     8000f5 <dumbfork+0x24>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	74 1b                	je     800107 <dumbfork+0x36>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ec:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f3:	eb 3f                	jmp    800134 <dumbfork+0x63>
		panic("sys_exofork: %e", envid);
  8000f5:	50                   	push   %eax
  8000f6:	68 e7 24 80 00       	push   $0x8024e7
  8000fb:	6a 37                	push   $0x37
  8000fd:	68 b3 24 80 00       	push   $0x8024b3
  800102:	e8 2d 01 00 00       	call   800234 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800107:	e8 5b 0c 00 00       	call   800d67 <sys_getenvid>
  80010c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800111:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800114:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800119:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80011e:	eb 43                	jmp    800163 <dumbfork+0x92>
		duppage(envid, addr);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	52                   	push   %edx
  800124:	56                   	push   %esi
  800125:	e8 09 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80012a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800137:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  80013d:	72 e1                	jb     800120 <dumbfork+0x4f>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800145:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014a:	50                   	push   %eax
  80014b:	53                   	push   %ebx
  80014c:	e8 e2 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800151:	83 c4 08             	add    $0x8,%esp
  800154:	6a 02                	push   $0x2
  800156:	53                   	push   %ebx
  800157:	e8 10 0d 00 00       	call   800e6c <sys_env_set_status>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	85 c0                	test   %eax,%eax
  800161:	78 09                	js     80016c <dumbfork+0x9b>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800163:	89 d8                	mov    %ebx,%eax
  800165:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016c:	50                   	push   %eax
  80016d:	68 f7 24 80 00       	push   $0x8024f7
  800172:	6a 4c                	push   $0x4c
  800174:	68 b3 24 80 00       	push   $0x8024b3
  800179:	e8 b6 00 00 00       	call   800234 <_panic>

0080017e <umain>:
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
  800184:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800187:	e8 45 ff ff ff       	call   8000d1 <dumbfork>
  80018c:	89 c7                	mov    %eax,%edi
  80018e:	85 c0                	test   %eax,%eax
  800190:	be 0e 25 80 00       	mov    $0x80250e,%esi
  800195:	b8 15 25 80 00       	mov    $0x802515,%eax
  80019a:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a2:	eb 1f                	jmp    8001c3 <umain+0x45>
  8001a4:	83 fb 13             	cmp    $0x13,%ebx
  8001a7:	7f 23                	jg     8001cc <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	68 1b 25 80 00       	push   $0x80251b
  8001b3:	e8 57 01 00 00       	call   80030f <cprintf>
		sys_yield();
  8001b8:	e8 c9 0b 00 00       	call   800d86 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bd:	83 c3 01             	add    $0x1,%ebx
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 ff                	test   %edi,%edi
  8001c5:	74 dd                	je     8001a4 <umain+0x26>
  8001c7:	83 fb 09             	cmp    $0x9,%ebx
  8001ca:	7e dd                	jle    8001a9 <umain+0x2b>
}
  8001cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8001df:	e8 83 0b 00 00       	call   800d67 <sys_getenvid>
  8001e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f1:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f6:	85 db                	test   %ebx,%ebx
  8001f8:	7e 07                	jle    800201 <libmain+0x2d>
		binaryname = argv[0];
  8001fa:	8b 06                	mov    (%esi),%eax
  8001fc:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	e8 73 ff ff ff       	call   80017e <umain>

	// exit gracefully
	exit();
  80020b:	e8 0a 00 00 00       	call   80021a <exit>
}
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    

0080021a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800220:	e8 66 0f 00 00       	call   80118b <close_all>
	sys_env_destroy(0);
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	6a 00                	push   $0x0
  80022a:	e8 f7 0a 00 00       	call   800d26 <sys_env_destroy>
}
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800239:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800242:	e8 20 0b 00 00       	call   800d67 <sys_getenvid>
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	56                   	push   %esi
  800251:	50                   	push   %eax
  800252:	68 38 25 80 00       	push   $0x802538
  800257:	e8 b3 00 00 00       	call   80030f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025c:	83 c4 18             	add    $0x18,%esp
  80025f:	53                   	push   %ebx
  800260:	ff 75 10             	pushl  0x10(%ebp)
  800263:	e8 56 00 00 00       	call   8002be <vcprintf>
	cprintf("\n");
  800268:	c7 04 24 2b 25 80 00 	movl   $0x80252b,(%esp)
  80026f:	e8 9b 00 00 00       	call   80030f <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800277:	cc                   	int3   
  800278:	eb fd                	jmp    800277 <_panic+0x43>

0080027a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	53                   	push   %ebx
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800284:	8b 13                	mov    (%ebx),%edx
  800286:	8d 42 01             	lea    0x1(%edx),%eax
  800289:	89 03                	mov    %eax,(%ebx)
  80028b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800292:	3d ff 00 00 00       	cmp    $0xff,%eax
  800297:	74 09                	je     8002a2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800299:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	68 ff 00 00 00       	push   $0xff
  8002aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ad:	50                   	push   %eax
  8002ae:	e8 36 0a 00 00       	call   800ce9 <sys_cputs>
		b->idx = 0;
  8002b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	eb db                	jmp    800299 <putch+0x1f>

008002be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ce:	00 00 00 
	b.cnt = 0;
  8002d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002db:	ff 75 0c             	pushl  0xc(%ebp)
  8002de:	ff 75 08             	pushl  0x8(%ebp)
  8002e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	68 7a 02 80 00       	push   $0x80027a
  8002ed:	e8 1a 01 00 00       	call   80040c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f2:	83 c4 08             	add    $0x8,%esp
  8002f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800301:	50                   	push   %eax
  800302:	e8 e2 09 00 00       	call   800ce9 <sys_cputs>

	return b.cnt;
}
  800307:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800315:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800318:	50                   	push   %eax
  800319:	ff 75 08             	pushl  0x8(%ebp)
  80031c:	e8 9d ff ff ff       	call   8002be <vcprintf>
	va_end(ap);

	return cnt;
}
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
  800329:	83 ec 1c             	sub    $0x1c,%esp
  80032c:	89 c7                	mov    %eax,%edi
  80032e:	89 d6                	mov    %edx,%esi
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	8b 55 0c             	mov    0xc(%ebp),%edx
  800336:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800339:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800344:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800347:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80034a:	39 d3                	cmp    %edx,%ebx
  80034c:	72 05                	jb     800353 <printnum+0x30>
  80034e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800351:	77 7a                	ja     8003cd <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 18             	pushl  0x18(%ebp)
  800359:	8b 45 14             	mov    0x14(%ebp),%eax
  80035c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035f:	53                   	push   %ebx
  800360:	ff 75 10             	pushl  0x10(%ebp)
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	ff 75 e4             	pushl  -0x1c(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	ff 75 dc             	pushl  -0x24(%ebp)
  80036f:	ff 75 d8             	pushl  -0x28(%ebp)
  800372:	e8 d9 1e 00 00       	call   802250 <__udivdi3>
  800377:	83 c4 18             	add    $0x18,%esp
  80037a:	52                   	push   %edx
  80037b:	50                   	push   %eax
  80037c:	89 f2                	mov    %esi,%edx
  80037e:	89 f8                	mov    %edi,%eax
  800380:	e8 9e ff ff ff       	call   800323 <printnum>
  800385:	83 c4 20             	add    $0x20,%esp
  800388:	eb 13                	jmp    80039d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	56                   	push   %esi
  80038e:	ff 75 18             	pushl  0x18(%ebp)
  800391:	ff d7                	call   *%edi
  800393:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800396:	83 eb 01             	sub    $0x1,%ebx
  800399:	85 db                	test   %ebx,%ebx
  80039b:	7f ed                	jg     80038a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	56                   	push   %esi
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b0:	e8 bb 1f 00 00       	call   802370 <__umoddi3>
  8003b5:	83 c4 14             	add    $0x14,%esp
  8003b8:	0f be 80 5b 25 80 00 	movsbl 0x80255b(%eax),%eax
  8003bf:	50                   	push   %eax
  8003c0:	ff d7                	call   *%edi
}
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c8:	5b                   	pop    %ebx
  8003c9:	5e                   	pop    %esi
  8003ca:	5f                   	pop    %edi
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    
  8003cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003d0:	eb c4                	jmp    800396 <printnum+0x73>

008003d2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003dc:	8b 10                	mov    (%eax),%edx
  8003de:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e1:	73 0a                	jae    8003ed <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e6:	89 08                	mov    %ecx,(%eax)
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	88 02                	mov    %al,(%edx)
}
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <printfmt>:
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 10             	pushl  0x10(%ebp)
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	ff 75 08             	pushl  0x8(%ebp)
  800402:	e8 05 00 00 00       	call   80040c <vprintfmt>
}
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <vprintfmt>:
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	57                   	push   %edi
  800410:	56                   	push   %esi
  800411:	53                   	push   %ebx
  800412:	83 ec 2c             	sub    $0x2c,%esp
  800415:	8b 75 08             	mov    0x8(%ebp),%esi
  800418:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041e:	e9 21 04 00 00       	jmp    800844 <vprintfmt+0x438>
		padc = ' ';
  800423:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800427:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8d 47 01             	lea    0x1(%edi),%eax
  800444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800447:	0f b6 17             	movzbl (%edi),%edx
  80044a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044d:	3c 55                	cmp    $0x55,%al
  80044f:	0f 87 90 04 00 00    	ja     8008e5 <vprintfmt+0x4d9>
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	ff 24 85 a0 26 80 00 	jmp    *0x8026a0(,%eax,4)
  80045f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800462:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800466:	eb d9                	jmp    800441 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80046b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80046f:	eb d0                	jmp    800441 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800471:	0f b6 d2             	movzbl %dl,%edx
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
  80047c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80047f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800482:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800486:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800489:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048c:	83 f9 09             	cmp    $0x9,%ecx
  80048f:	77 55                	ja     8004e6 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800491:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800494:	eb e9                	jmp    80047f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8d 40 04             	lea    0x4(%eax),%eax
  8004a4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ae:	79 91                	jns    800441 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004bd:	eb 82                	jmp    800441 <vprintfmt+0x35>
  8004bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c2:	85 c0                	test   %eax,%eax
  8004c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c9:	0f 49 d0             	cmovns %eax,%edx
  8004cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d2:	e9 6a ff ff ff       	jmp    800441 <vprintfmt+0x35>
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004da:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e1:	e9 5b ff ff ff       	jmp    800441 <vprintfmt+0x35>
  8004e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ec:	eb bc                	jmp    8004aa <vprintfmt+0x9e>
			lflag++;
  8004ee:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f4:	e9 48 ff ff ff       	jmp    800441 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 78 04             	lea    0x4(%eax),%edi
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	53                   	push   %ebx
  800503:	ff 30                	pushl  (%eax)
  800505:	ff d6                	call   *%esi
			break;
  800507:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050d:	e9 2f 03 00 00       	jmp    800841 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 78 04             	lea    0x4(%eax),%edi
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	99                   	cltd   
  80051b:	31 d0                	xor    %edx,%eax
  80051d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051f:	83 f8 0f             	cmp    $0xf,%eax
  800522:	7f 23                	jg     800547 <vprintfmt+0x13b>
  800524:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  80052b:	85 d2                	test   %edx,%edx
  80052d:	74 18                	je     800547 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80052f:	52                   	push   %edx
  800530:	68 5e 29 80 00       	push   $0x80295e
  800535:	53                   	push   %ebx
  800536:	56                   	push   %esi
  800537:	e8 b3 fe ff ff       	call   8003ef <printfmt>
  80053c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800542:	e9 fa 02 00 00       	jmp    800841 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800547:	50                   	push   %eax
  800548:	68 73 25 80 00       	push   $0x802573
  80054d:	53                   	push   %ebx
  80054e:	56                   	push   %esi
  80054f:	e8 9b fe ff ff       	call   8003ef <printfmt>
  800554:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800557:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80055a:	e9 e2 02 00 00       	jmp    800841 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056d:	85 ff                	test   %edi,%edi
  80056f:	b8 6c 25 80 00       	mov    $0x80256c,%eax
  800574:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057b:	0f 8e bd 00 00 00    	jle    80063e <vprintfmt+0x232>
  800581:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800585:	75 0e                	jne    800595 <vprintfmt+0x189>
  800587:	89 75 08             	mov    %esi,0x8(%ebp)
  80058a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800590:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800593:	eb 6d                	jmp    800602 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	ff 75 d0             	pushl  -0x30(%ebp)
  80059b:	57                   	push   %edi
  80059c:	e8 ec 03 00 00       	call   80098d <strnlen>
  8005a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a4:	29 c1                	sub    %eax,%ecx
  8005a6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005ac:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b8:	eb 0f                	jmp    8005c9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	53                   	push   %ebx
  8005be:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	83 ef 01             	sub    $0x1,%edi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	85 ff                	test   %edi,%edi
  8005cb:	7f ed                	jg     8005ba <vprintfmt+0x1ae>
  8005cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005d0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	0f 49 c1             	cmovns %ecx,%eax
  8005dd:	29 c1                	sub    %eax,%ecx
  8005df:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e8:	89 cb                	mov    %ecx,%ebx
  8005ea:	eb 16                	jmp    800602 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f0:	75 31                	jne    800623 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	50                   	push   %eax
  8005f9:	ff 55 08             	call   *0x8(%ebp)
  8005fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ff:	83 eb 01             	sub    $0x1,%ebx
  800602:	83 c7 01             	add    $0x1,%edi
  800605:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800609:	0f be c2             	movsbl %dl,%eax
  80060c:	85 c0                	test   %eax,%eax
  80060e:	74 59                	je     800669 <vprintfmt+0x25d>
  800610:	85 f6                	test   %esi,%esi
  800612:	78 d8                	js     8005ec <vprintfmt+0x1e0>
  800614:	83 ee 01             	sub    $0x1,%esi
  800617:	79 d3                	jns    8005ec <vprintfmt+0x1e0>
  800619:	89 df                	mov    %ebx,%edi
  80061b:	8b 75 08             	mov    0x8(%ebp),%esi
  80061e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800621:	eb 37                	jmp    80065a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800623:	0f be d2             	movsbl %dl,%edx
  800626:	83 ea 20             	sub    $0x20,%edx
  800629:	83 fa 5e             	cmp    $0x5e,%edx
  80062c:	76 c4                	jbe    8005f2 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	6a 3f                	push   $0x3f
  800636:	ff 55 08             	call   *0x8(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb c1                	jmp    8005ff <vprintfmt+0x1f3>
  80063e:	89 75 08             	mov    %esi,0x8(%ebp)
  800641:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800644:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800647:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80064a:	eb b6                	jmp    800602 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	53                   	push   %ebx
  800650:	6a 20                	push   $0x20
  800652:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800654:	83 ef 01             	sub    $0x1,%edi
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	85 ff                	test   %edi,%edi
  80065c:	7f ee                	jg     80064c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
  800664:	e9 d8 01 00 00       	jmp    800841 <vprintfmt+0x435>
  800669:	89 df                	mov    %ebx,%edi
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800671:	eb e7                	jmp    80065a <vprintfmt+0x24e>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7e 45                	jle    8006bd <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 50 04             	mov    0x4(%eax),%edx
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800683:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8d 40 08             	lea    0x8(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800693:	79 62                	jns    8006f7 <vprintfmt+0x2eb>
				putch('-', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	53                   	push   %ebx
  800699:	6a 2d                	push   $0x2d
  80069b:	ff d6                	call   *%esi
				num = -(long long) num;
  80069d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006a3:	f7 d8                	neg    %eax
  8006a5:	83 d2 00             	adc    $0x0,%edx
  8006a8:	f7 da                	neg    %edx
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b3:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006b8:	e9 66 01 00 00       	jmp    800823 <vprintfmt+0x417>
	else if (lflag)
  8006bd:	85 c9                	test   %ecx,%ecx
  8006bf:	75 1b                	jne    8006dc <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c9:	89 c1                	mov    %eax,%ecx
  8006cb:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ce:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006da:	eb b3                	jmp    80068f <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e4:	89 c1                	mov    %eax,%ecx
  8006e6:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f5:	eb 98                	jmp    80068f <vprintfmt+0x283>
			base = 10;
  8006f7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006fc:	e9 22 01 00 00       	jmp    800823 <vprintfmt+0x417>
	if (lflag >= 2)
  800701:	83 f9 01             	cmp    $0x1,%ecx
  800704:	7e 21                	jle    800727 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 50 04             	mov    0x4(%eax),%edx
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800711:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8d 40 08             	lea    0x8(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800722:	e9 fc 00 00 00       	jmp    800823 <vprintfmt+0x417>
	else if (lflag)
  800727:	85 c9                	test   %ecx,%ecx
  800729:	75 23                	jne    80074e <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800738:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800744:	ba 0a 00 00 00       	mov    $0xa,%edx
  800749:	e9 d5 00 00 00       	jmp    800823 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800767:	ba 0a 00 00 00       	mov    $0xa,%edx
  80076c:	e9 b2 00 00 00       	jmp    800823 <vprintfmt+0x417>
	if (lflag >= 2)
  800771:	83 f9 01             	cmp    $0x1,%ecx
  800774:	7e 42                	jle    8007b8 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8b 50 04             	mov    0x4(%eax),%edx
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800781:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 08             	lea    0x8(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078d:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800792:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800796:	0f 89 87 00 00 00    	jns    800823 <vprintfmt+0x417>
				putch('-', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	53                   	push   %ebx
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8007a4:	f7 5d d8             	negl   -0x28(%ebp)
  8007a7:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8007ab:	f7 5d dc             	negl   -0x24(%ebp)
  8007ae:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007b1:	ba 08 00 00 00       	mov    $0x8,%edx
  8007b6:	eb 6b                	jmp    800823 <vprintfmt+0x417>
	else if (lflag)
  8007b8:	85 c9                	test   %ecx,%ecx
  8007ba:	75 1b                	jne    8007d7 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8d 40 04             	lea    0x4(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d5:	eb b6                	jmp    80078d <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f0:	eb 9b                	jmp    80078d <vprintfmt+0x381>
			putch('0', putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	6a 30                	push   $0x30
  8007f8:	ff d6                	call   *%esi
			putch('x', putdat);
  8007fa:	83 c4 08             	add    $0x8,%esp
  8007fd:	53                   	push   %ebx
  8007fe:	6a 78                	push   $0x78
  800800:	ff d6                	call   *%esi
			num = (unsigned long long)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	ba 00 00 00 00       	mov    $0x0,%edx
  80080c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800812:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8d 40 04             	lea    0x4(%eax),%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081e:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800823:	83 ec 0c             	sub    $0xc,%esp
  800826:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80082a:	50                   	push   %eax
  80082b:	ff 75 e0             	pushl  -0x20(%ebp)
  80082e:	52                   	push   %edx
  80082f:	ff 75 dc             	pushl  -0x24(%ebp)
  800832:	ff 75 d8             	pushl  -0x28(%ebp)
  800835:	89 da                	mov    %ebx,%edx
  800837:	89 f0                	mov    %esi,%eax
  800839:	e8 e5 fa ff ff       	call   800323 <printnum>
			break;
  80083e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800841:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800844:	83 c7 01             	add    $0x1,%edi
  800847:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80084b:	83 f8 25             	cmp    $0x25,%eax
  80084e:	0f 84 cf fb ff ff    	je     800423 <vprintfmt+0x17>
			if (ch == '\0')
  800854:	85 c0                	test   %eax,%eax
  800856:	0f 84 a9 00 00 00    	je     800905 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	50                   	push   %eax
  800861:	ff d6                	call   *%esi
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	eb dc                	jmp    800844 <vprintfmt+0x438>
	if (lflag >= 2)
  800868:	83 f9 01             	cmp    $0x1,%ecx
  80086b:	7e 1e                	jle    80088b <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8b 50 04             	mov    0x4(%eax),%edx
  800873:	8b 00                	mov    (%eax),%eax
  800875:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800878:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8d 40 08             	lea    0x8(%eax),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800884:	ba 10 00 00 00       	mov    $0x10,%edx
  800889:	eb 98                	jmp    800823 <vprintfmt+0x417>
	else if (lflag)
  80088b:	85 c9                	test   %ecx,%ecx
  80088d:	75 23                	jne    8008b2 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
  800899:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8d 40 04             	lea    0x4(%eax),%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a8:	ba 10 00 00 00       	mov    $0x10,%edx
  8008ad:	e9 71 ff ff ff       	jmp    800823 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8d 40 04             	lea    0x4(%eax),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cb:	ba 10 00 00 00       	mov    $0x10,%edx
  8008d0:	e9 4e ff ff ff       	jmp    800823 <vprintfmt+0x417>
			putch(ch, putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	53                   	push   %ebx
  8008d9:	6a 25                	push   $0x25
  8008db:	ff d6                	call   *%esi
			break;
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	e9 5c ff ff ff       	jmp    800841 <vprintfmt+0x435>
			putch('%', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	53                   	push   %ebx
  8008e9:	6a 25                	push   $0x25
  8008eb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	89 f8                	mov    %edi,%eax
  8008f2:	eb 03                	jmp    8008f7 <vprintfmt+0x4eb>
  8008f4:	83 e8 01             	sub    $0x1,%eax
  8008f7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008fb:	75 f7                	jne    8008f4 <vprintfmt+0x4e8>
  8008fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800900:	e9 3c ff ff ff       	jmp    800841 <vprintfmt+0x435>
}
  800905:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800908:	5b                   	pop    %ebx
  800909:	5e                   	pop    %esi
  80090a:	5f                   	pop    %edi
  80090b:	5d                   	pop    %ebp
  80090c:	c3                   	ret    

0080090d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	83 ec 18             	sub    $0x18,%esp
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800919:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800920:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800923:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80092a:	85 c0                	test   %eax,%eax
  80092c:	74 26                	je     800954 <vsnprintf+0x47>
  80092e:	85 d2                	test   %edx,%edx
  800930:	7e 22                	jle    800954 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800932:	ff 75 14             	pushl  0x14(%ebp)
  800935:	ff 75 10             	pushl  0x10(%ebp)
  800938:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80093b:	50                   	push   %eax
  80093c:	68 d2 03 80 00       	push   $0x8003d2
  800941:	e8 c6 fa ff ff       	call   80040c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800949:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094f:	83 c4 10             	add    $0x10,%esp
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    
		return -E_INVAL;
  800954:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800959:	eb f7                	jmp    800952 <vsnprintf+0x45>

0080095b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800964:	50                   	push   %eax
  800965:	ff 75 10             	pushl  0x10(%ebp)
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	e8 9a ff ff ff       	call   80090d <vsnprintf>
	va_end(ap);

	return rc;
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
  800980:	eb 03                	jmp    800985 <strlen+0x10>
		n++;
  800982:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800985:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800989:	75 f7                	jne    800982 <strlen+0xd>
	return n;
}
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800996:	b8 00 00 00 00       	mov    $0x0,%eax
  80099b:	eb 03                	jmp    8009a0 <strnlen+0x13>
		n++;
  80099d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a0:	39 d0                	cmp    %edx,%eax
  8009a2:	74 06                	je     8009aa <strnlen+0x1d>
  8009a4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a8:	75 f3                	jne    80099d <strnlen+0x10>
	return n;
}
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	53                   	push   %ebx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b6:	89 c2                	mov    %eax,%edx
  8009b8:	83 c1 01             	add    $0x1,%ecx
  8009bb:	83 c2 01             	add    $0x1,%edx
  8009be:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009c2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c5:	84 db                	test   %bl,%bl
  8009c7:	75 ef                	jne    8009b8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c9:	5b                   	pop    %ebx
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	53                   	push   %ebx
  8009d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d3:	53                   	push   %ebx
  8009d4:	e8 9c ff ff ff       	call   800975 <strlen>
  8009d9:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	50                   	push   %eax
  8009e2:	e8 c5 ff ff ff       	call   8009ac <strcpy>
	return dst;
}
  8009e7:	89 d8                	mov    %ebx,%eax
  8009e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f9:	89 f3                	mov    %esi,%ebx
  8009fb:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009fe:	89 f2                	mov    %esi,%edx
  800a00:	eb 0f                	jmp    800a11 <strncpy+0x23>
		*dst++ = *src;
  800a02:	83 c2 01             	add    $0x1,%edx
  800a05:	0f b6 01             	movzbl (%ecx),%eax
  800a08:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a0b:	80 39 01             	cmpb   $0x1,(%ecx)
  800a0e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a11:	39 da                	cmp    %ebx,%edx
  800a13:	75 ed                	jne    800a02 <strncpy+0x14>
	}
	return ret;
}
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	5b                   	pop    %ebx
  800a18:	5e                   	pop    %esi
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 75 08             	mov    0x8(%ebp),%esi
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a29:	89 f0                	mov    %esi,%eax
  800a2b:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a2f:	85 c9                	test   %ecx,%ecx
  800a31:	75 0b                	jne    800a3e <strlcpy+0x23>
  800a33:	eb 17                	jmp    800a4c <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a35:	83 c2 01             	add    $0x1,%edx
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a3e:	39 d8                	cmp    %ebx,%eax
  800a40:	74 07                	je     800a49 <strlcpy+0x2e>
  800a42:	0f b6 0a             	movzbl (%edx),%ecx
  800a45:	84 c9                	test   %cl,%cl
  800a47:	75 ec                	jne    800a35 <strlcpy+0x1a>
		*dst = '\0';
  800a49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4c:	29 f0                	sub    %esi,%eax
}
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a5b:	eb 06                	jmp    800a63 <strcmp+0x11>
		p++, q++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a63:	0f b6 01             	movzbl (%ecx),%eax
  800a66:	84 c0                	test   %al,%al
  800a68:	74 04                	je     800a6e <strcmp+0x1c>
  800a6a:	3a 02                	cmp    (%edx),%al
  800a6c:	74 ef                	je     800a5d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6e:	0f b6 c0             	movzbl %al,%eax
  800a71:	0f b6 12             	movzbl (%edx),%edx
  800a74:	29 d0                	sub    %edx,%eax
}
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	53                   	push   %ebx
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a82:	89 c3                	mov    %eax,%ebx
  800a84:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a87:	eb 06                	jmp    800a8f <strncmp+0x17>
		n--, p++, q++;
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a8f:	39 d8                	cmp    %ebx,%eax
  800a91:	74 16                	je     800aa9 <strncmp+0x31>
  800a93:	0f b6 08             	movzbl (%eax),%ecx
  800a96:	84 c9                	test   %cl,%cl
  800a98:	74 04                	je     800a9e <strncmp+0x26>
  800a9a:	3a 0a                	cmp    (%edx),%cl
  800a9c:	74 eb                	je     800a89 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9e:	0f b6 00             	movzbl (%eax),%eax
  800aa1:	0f b6 12             	movzbl (%edx),%edx
  800aa4:	29 d0                	sub    %edx,%eax
}
  800aa6:	5b                   	pop    %ebx
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    
		return 0;
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aae:	eb f6                	jmp    800aa6 <strncmp+0x2e>

00800ab0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aba:	0f b6 10             	movzbl (%eax),%edx
  800abd:	84 d2                	test   %dl,%dl
  800abf:	74 09                	je     800aca <strchr+0x1a>
		if (*s == c)
  800ac1:	38 ca                	cmp    %cl,%dl
  800ac3:	74 0a                	je     800acf <strchr+0x1f>
	for (; *s; s++)
  800ac5:	83 c0 01             	add    $0x1,%eax
  800ac8:	eb f0                	jmp    800aba <strchr+0xa>
			return (char *) s;
	return 0;
  800aca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800adb:	eb 03                	jmp    800ae0 <strfind+0xf>
  800add:	83 c0 01             	add    $0x1,%eax
  800ae0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ae3:	38 ca                	cmp    %cl,%dl
  800ae5:	74 04                	je     800aeb <strfind+0x1a>
  800ae7:	84 d2                	test   %dl,%dl
  800ae9:	75 f2                	jne    800add <strfind+0xc>
			break;
	return (char *) s;
}
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	57                   	push   %edi
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af9:	85 c9                	test   %ecx,%ecx
  800afb:	74 13                	je     800b10 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800afd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b03:	75 05                	jne    800b0a <memset+0x1d>
  800b05:	f6 c1 03             	test   $0x3,%cl
  800b08:	74 0d                	je     800b17 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	fc                   	cld    
  800b0e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b10:	89 f8                	mov    %edi,%eax
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    
		c &= 0xFF;
  800b17:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1b:	89 d3                	mov    %edx,%ebx
  800b1d:	c1 e3 08             	shl    $0x8,%ebx
  800b20:	89 d0                	mov    %edx,%eax
  800b22:	c1 e0 18             	shl    $0x18,%eax
  800b25:	89 d6                	mov    %edx,%esi
  800b27:	c1 e6 10             	shl    $0x10,%esi
  800b2a:	09 f0                	or     %esi,%eax
  800b2c:	09 c2                	or     %eax,%edx
  800b2e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b30:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b33:	89 d0                	mov    %edx,%eax
  800b35:	fc                   	cld    
  800b36:	f3 ab                	rep stos %eax,%es:(%edi)
  800b38:	eb d6                	jmp    800b10 <memset+0x23>

00800b3a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	57                   	push   %edi
  800b3e:	56                   	push   %esi
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b48:	39 c6                	cmp    %eax,%esi
  800b4a:	73 35                	jae    800b81 <memmove+0x47>
  800b4c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b4f:	39 c2                	cmp    %eax,%edx
  800b51:	76 2e                	jbe    800b81 <memmove+0x47>
		s += n;
		d += n;
  800b53:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b56:	89 d6                	mov    %edx,%esi
  800b58:	09 fe                	or     %edi,%esi
  800b5a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b60:	74 0c                	je     800b6e <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b62:	83 ef 01             	sub    $0x1,%edi
  800b65:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b68:	fd                   	std    
  800b69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6b:	fc                   	cld    
  800b6c:	eb 21                	jmp    800b8f <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6e:	f6 c1 03             	test   $0x3,%cl
  800b71:	75 ef                	jne    800b62 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b73:	83 ef 04             	sub    $0x4,%edi
  800b76:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7c:	fd                   	std    
  800b7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7f:	eb ea                	jmp    800b6b <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b81:	89 f2                	mov    %esi,%edx
  800b83:	09 c2                	or     %eax,%edx
  800b85:	f6 c2 03             	test   $0x3,%dl
  800b88:	74 09                	je     800b93 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b8a:	89 c7                	mov    %eax,%edi
  800b8c:	fc                   	cld    
  800b8d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b93:	f6 c1 03             	test   $0x3,%cl
  800b96:	75 f2                	jne    800b8a <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b98:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9b:	89 c7                	mov    %eax,%edi
  800b9d:	fc                   	cld    
  800b9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba0:	eb ed                	jmp    800b8f <memmove+0x55>

00800ba2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ba5:	ff 75 10             	pushl  0x10(%ebp)
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	e8 87 ff ff ff       	call   800b3a <memmove>
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc0:	89 c6                	mov    %eax,%esi
  800bc2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc5:	39 f0                	cmp    %esi,%eax
  800bc7:	74 1c                	je     800be5 <memcmp+0x30>
		if (*s1 != *s2)
  800bc9:	0f b6 08             	movzbl (%eax),%ecx
  800bcc:	0f b6 1a             	movzbl (%edx),%ebx
  800bcf:	38 d9                	cmp    %bl,%cl
  800bd1:	75 08                	jne    800bdb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bd3:	83 c0 01             	add    $0x1,%eax
  800bd6:	83 c2 01             	add    $0x1,%edx
  800bd9:	eb ea                	jmp    800bc5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bdb:	0f b6 c1             	movzbl %cl,%eax
  800bde:	0f b6 db             	movzbl %bl,%ebx
  800be1:	29 d8                	sub    %ebx,%eax
  800be3:	eb 05                	jmp    800bea <memcmp+0x35>
	}

	return 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bf7:	89 c2                	mov    %eax,%edx
  800bf9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bfc:	39 d0                	cmp    %edx,%eax
  800bfe:	73 09                	jae    800c09 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c00:	38 08                	cmp    %cl,(%eax)
  800c02:	74 05                	je     800c09 <memfind+0x1b>
	for (; s < ends; s++)
  800c04:	83 c0 01             	add    $0x1,%eax
  800c07:	eb f3                	jmp    800bfc <memfind+0xe>
			break;
	return (void *) s;
}
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c17:	eb 03                	jmp    800c1c <strtol+0x11>
		s++;
  800c19:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c1c:	0f b6 01             	movzbl (%ecx),%eax
  800c1f:	3c 20                	cmp    $0x20,%al
  800c21:	74 f6                	je     800c19 <strtol+0xe>
  800c23:	3c 09                	cmp    $0x9,%al
  800c25:	74 f2                	je     800c19 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c27:	3c 2b                	cmp    $0x2b,%al
  800c29:	74 2e                	je     800c59 <strtol+0x4e>
	int neg = 0;
  800c2b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c30:	3c 2d                	cmp    $0x2d,%al
  800c32:	74 2f                	je     800c63 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c34:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c3a:	75 05                	jne    800c41 <strtol+0x36>
  800c3c:	80 39 30             	cmpb   $0x30,(%ecx)
  800c3f:	74 2c                	je     800c6d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c41:	85 db                	test   %ebx,%ebx
  800c43:	75 0a                	jne    800c4f <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c45:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c4a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c4d:	74 28                	je     800c77 <strtol+0x6c>
		base = 10;
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c54:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c57:	eb 50                	jmp    800ca9 <strtol+0x9e>
		s++;
  800c59:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c5c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c61:	eb d1                	jmp    800c34 <strtol+0x29>
		s++, neg = 1;
  800c63:	83 c1 01             	add    $0x1,%ecx
  800c66:	bf 01 00 00 00       	mov    $0x1,%edi
  800c6b:	eb c7                	jmp    800c34 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c71:	74 0e                	je     800c81 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c73:	85 db                	test   %ebx,%ebx
  800c75:	75 d8                	jne    800c4f <strtol+0x44>
		s++, base = 8;
  800c77:	83 c1 01             	add    $0x1,%ecx
  800c7a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c7f:	eb ce                	jmp    800c4f <strtol+0x44>
		s += 2, base = 16;
  800c81:	83 c1 02             	add    $0x2,%ecx
  800c84:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c89:	eb c4                	jmp    800c4f <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c8b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c8e:	89 f3                	mov    %esi,%ebx
  800c90:	80 fb 19             	cmp    $0x19,%bl
  800c93:	77 29                	ja     800cbe <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c95:	0f be d2             	movsbl %dl,%edx
  800c98:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c9b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c9e:	7d 30                	jge    800cd0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ca0:	83 c1 01             	add    $0x1,%ecx
  800ca3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ca7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ca9:	0f b6 11             	movzbl (%ecx),%edx
  800cac:	8d 72 d0             	lea    -0x30(%edx),%esi
  800caf:	89 f3                	mov    %esi,%ebx
  800cb1:	80 fb 09             	cmp    $0x9,%bl
  800cb4:	77 d5                	ja     800c8b <strtol+0x80>
			dig = *s - '0';
  800cb6:	0f be d2             	movsbl %dl,%edx
  800cb9:	83 ea 30             	sub    $0x30,%edx
  800cbc:	eb dd                	jmp    800c9b <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800cbe:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cc1:	89 f3                	mov    %esi,%ebx
  800cc3:	80 fb 19             	cmp    $0x19,%bl
  800cc6:	77 08                	ja     800cd0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800cc8:	0f be d2             	movsbl %dl,%edx
  800ccb:	83 ea 37             	sub    $0x37,%edx
  800cce:	eb cb                	jmp    800c9b <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd4:	74 05                	je     800cdb <strtol+0xd0>
		*endptr = (char *) s;
  800cd6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cdb:	89 c2                	mov    %eax,%edx
  800cdd:	f7 da                	neg    %edx
  800cdf:	85 ff                	test   %edi,%edi
  800ce1:	0f 45 c2             	cmovne %edx,%eax
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfa:	89 c3                	mov    %eax,%ebx
  800cfc:	89 c7                	mov    %eax,%edi
  800cfe:	89 c6                	mov    %eax,%esi
  800d00:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d12:	b8 01 00 00 00       	mov    $0x1,%eax
  800d17:	89 d1                	mov    %edx,%ecx
  800d19:	89 d3                	mov    %edx,%ebx
  800d1b:	89 d7                	mov    %edx,%edi
  800d1d:	89 d6                	mov    %edx,%esi
  800d1f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	b8 03 00 00 00       	mov    $0x3,%eax
  800d3c:	89 cb                	mov    %ecx,%ebx
  800d3e:	89 cf                	mov    %ecx,%edi
  800d40:	89 ce                	mov    %ecx,%esi
  800d42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d44:	85 c0                	test   %eax,%eax
  800d46:	7f 08                	jg     800d50 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d50:	83 ec 0c             	sub    $0xc,%esp
  800d53:	50                   	push   %eax
  800d54:	6a 03                	push   $0x3
  800d56:	68 5f 28 80 00       	push   $0x80285f
  800d5b:	6a 23                	push   $0x23
  800d5d:	68 7c 28 80 00       	push   $0x80287c
  800d62:	e8 cd f4 ff ff       	call   800234 <_panic>

00800d67 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d72:	b8 02 00 00 00       	mov    $0x2,%eax
  800d77:	89 d1                	mov    %edx,%ecx
  800d79:	89 d3                	mov    %edx,%ebx
  800d7b:	89 d7                	mov    %edx,%edi
  800d7d:	89 d6                	mov    %edx,%esi
  800d7f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <sys_yield>:

void
sys_yield(void)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d91:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d96:	89 d1                	mov    %edx,%ecx
  800d98:	89 d3                	mov    %edx,%ebx
  800d9a:	89 d7                	mov    %edx,%edi
  800d9c:	89 d6                	mov    %edx,%esi
  800d9e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dae:	be 00 00 00 00       	mov    $0x0,%esi
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	b8 04 00 00 00       	mov    $0x4,%eax
  800dbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc1:	89 f7                	mov    %esi,%edi
  800dc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	7f 08                	jg     800dd1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd1:	83 ec 0c             	sub    $0xc,%esp
  800dd4:	50                   	push   %eax
  800dd5:	6a 04                	push   $0x4
  800dd7:	68 5f 28 80 00       	push   $0x80285f
  800ddc:	6a 23                	push   $0x23
  800dde:	68 7c 28 80 00       	push   $0x80287c
  800de3:	e8 4c f4 ff ff       	call   800234 <_panic>

00800de8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df7:	b8 05 00 00 00       	mov    $0x5,%eax
  800dfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dff:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e02:	8b 75 18             	mov    0x18(%ebp),%esi
  800e05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7f 08                	jg     800e13 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	50                   	push   %eax
  800e17:	6a 05                	push   $0x5
  800e19:	68 5f 28 80 00       	push   $0x80285f
  800e1e:	6a 23                	push   $0x23
  800e20:	68 7c 28 80 00       	push   $0x80287c
  800e25:	e8 0a f4 ff ff       	call   800234 <_panic>

00800e2a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e43:	89 df                	mov    %ebx,%edi
  800e45:	89 de                	mov    %ebx,%esi
  800e47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	7f 08                	jg     800e55 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	50                   	push   %eax
  800e59:	6a 06                	push   $0x6
  800e5b:	68 5f 28 80 00       	push   $0x80285f
  800e60:	6a 23                	push   $0x23
  800e62:	68 7c 28 80 00       	push   $0x80287c
  800e67:	e8 c8 f3 ff ff       	call   800234 <_panic>

00800e6c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	b8 08 00 00 00       	mov    $0x8,%eax
  800e85:	89 df                	mov    %ebx,%edi
  800e87:	89 de                	mov    %ebx,%esi
  800e89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	7f 08                	jg     800e97 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	50                   	push   %eax
  800e9b:	6a 08                	push   $0x8
  800e9d:	68 5f 28 80 00       	push   $0x80285f
  800ea2:	6a 23                	push   $0x23
  800ea4:	68 7c 28 80 00       	push   $0x80287c
  800ea9:	e8 86 f3 ff ff       	call   800234 <_panic>

00800eae <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec7:	89 df                	mov    %ebx,%edi
  800ec9:	89 de                	mov    %ebx,%esi
  800ecb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	7f 08                	jg     800ed9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed9:	83 ec 0c             	sub    $0xc,%esp
  800edc:	50                   	push   %eax
  800edd:	6a 09                	push   $0x9
  800edf:	68 5f 28 80 00       	push   $0x80285f
  800ee4:	6a 23                	push   $0x23
  800ee6:	68 7c 28 80 00       	push   $0x80287c
  800eeb:	e8 44 f3 ff ff       	call   800234 <_panic>

00800ef0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f04:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	89 de                	mov    %ebx,%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 0a                	push   $0xa
  800f21:	68 5f 28 80 00       	push   $0x80285f
  800f26:	6a 23                	push   $0x23
  800f28:	68 7c 28 80 00       	push   $0x80287c
  800f2d:	e8 02 f3 ff ff       	call   800234 <_panic>

00800f32 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f43:	be 00 00 00 00       	mov    $0x0,%esi
  800f48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
  800f5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f6b:	89 cb                	mov    %ecx,%ebx
  800f6d:	89 cf                	mov    %ecx,%edi
  800f6f:	89 ce                	mov    %ecx,%esi
  800f71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f73:	85 c0                	test   %eax,%eax
  800f75:	7f 08                	jg     800f7f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	50                   	push   %eax
  800f83:	6a 0d                	push   $0xd
  800f85:	68 5f 28 80 00       	push   $0x80285f
  800f8a:	6a 23                	push   $0x23
  800f8c:	68 7c 28 80 00       	push   $0x80287c
  800f91:	e8 9e f2 ff ff       	call   800234 <_panic>

00800f96 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa1:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fa6:	89 d1                	mov    %edx,%ecx
  800fa8:	89 d3                	mov    %edx,%ebx
  800faa:	89 d7                	mov    %edx,%edi
  800fac:	89 d6                	mov    %edx,%esi
  800fae:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc0:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe7:	89 c2                	mov    %eax,%edx
  800fe9:	c1 ea 16             	shr    $0x16,%edx
  800fec:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff3:	f6 c2 01             	test   $0x1,%dl
  800ff6:	74 2a                	je     801022 <fd_alloc+0x46>
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	c1 ea 0c             	shr    $0xc,%edx
  800ffd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801004:	f6 c2 01             	test   $0x1,%dl
  801007:	74 19                	je     801022 <fd_alloc+0x46>
  801009:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80100e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801013:	75 d2                	jne    800fe7 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801015:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80101b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801020:	eb 07                	jmp    801029 <fd_alloc+0x4d>
			*fd_store = fd;
  801022:	89 01                	mov    %eax,(%ecx)
			return 0;
  801024:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801031:	83 f8 1f             	cmp    $0x1f,%eax
  801034:	77 36                	ja     80106c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801036:	c1 e0 0c             	shl    $0xc,%eax
  801039:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80103e:	89 c2                	mov    %eax,%edx
  801040:	c1 ea 16             	shr    $0x16,%edx
  801043:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104a:	f6 c2 01             	test   $0x1,%dl
  80104d:	74 24                	je     801073 <fd_lookup+0x48>
  80104f:	89 c2                	mov    %eax,%edx
  801051:	c1 ea 0c             	shr    $0xc,%edx
  801054:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105b:	f6 c2 01             	test   $0x1,%dl
  80105e:	74 1a                	je     80107a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801060:	8b 55 0c             	mov    0xc(%ebp),%edx
  801063:	89 02                	mov    %eax,(%edx)
	return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    
		return -E_INVAL;
  80106c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801071:	eb f7                	jmp    80106a <fd_lookup+0x3f>
		return -E_INVAL;
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801078:	eb f0                	jmp    80106a <fd_lookup+0x3f>
  80107a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107f:	eb e9                	jmp    80106a <fd_lookup+0x3f>

00801081 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108a:	ba 08 29 80 00       	mov    $0x802908,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80108f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801094:	39 08                	cmp    %ecx,(%eax)
  801096:	74 33                	je     8010cb <dev_lookup+0x4a>
  801098:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80109b:	8b 02                	mov    (%edx),%eax
  80109d:	85 c0                	test   %eax,%eax
  80109f:	75 f3                	jne    801094 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8010a6:	8b 40 48             	mov    0x48(%eax),%eax
  8010a9:	83 ec 04             	sub    $0x4,%esp
  8010ac:	51                   	push   %ecx
  8010ad:	50                   	push   %eax
  8010ae:	68 8c 28 80 00       	push   $0x80288c
  8010b3:	e8 57 f2 ff ff       	call   80030f <cprintf>
	*dev = 0;
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010c1:	83 c4 10             	add    $0x10,%esp
  8010c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    
			*dev = devtab[i];
  8010cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ce:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d5:	eb f2                	jmp    8010c9 <dev_lookup+0x48>

008010d7 <fd_close>:
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	57                   	push   %edi
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
  8010dd:	83 ec 1c             	sub    $0x1c,%esp
  8010e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ea:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010f0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f3:	50                   	push   %eax
  8010f4:	e8 32 ff ff ff       	call   80102b <fd_lookup>
  8010f9:	89 c3                	mov    %eax,%ebx
  8010fb:	83 c4 08             	add    $0x8,%esp
  8010fe:	85 c0                	test   %eax,%eax
  801100:	78 05                	js     801107 <fd_close+0x30>
	    || fd != fd2)
  801102:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801105:	74 16                	je     80111d <fd_close+0x46>
		return (must_exist ? r : 0);
  801107:	89 f8                	mov    %edi,%eax
  801109:	84 c0                	test   %al,%al
  80110b:	b8 00 00 00 00       	mov    $0x0,%eax
  801110:	0f 44 d8             	cmove  %eax,%ebx
}
  801113:	89 d8                	mov    %ebx,%eax
  801115:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801118:	5b                   	pop    %ebx
  801119:	5e                   	pop    %esi
  80111a:	5f                   	pop    %edi
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80111d:	83 ec 08             	sub    $0x8,%esp
  801120:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801123:	50                   	push   %eax
  801124:	ff 36                	pushl  (%esi)
  801126:	e8 56 ff ff ff       	call   801081 <dev_lookup>
  80112b:	89 c3                	mov    %eax,%ebx
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 15                	js     801149 <fd_close+0x72>
		if (dev->dev_close)
  801134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801137:	8b 40 10             	mov    0x10(%eax),%eax
  80113a:	85 c0                	test   %eax,%eax
  80113c:	74 1b                	je     801159 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80113e:	83 ec 0c             	sub    $0xc,%esp
  801141:	56                   	push   %esi
  801142:	ff d0                	call   *%eax
  801144:	89 c3                	mov    %eax,%ebx
  801146:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801149:	83 ec 08             	sub    $0x8,%esp
  80114c:	56                   	push   %esi
  80114d:	6a 00                	push   $0x0
  80114f:	e8 d6 fc ff ff       	call   800e2a <sys_page_unmap>
	return r;
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	eb ba                	jmp    801113 <fd_close+0x3c>
			r = 0;
  801159:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115e:	eb e9                	jmp    801149 <fd_close+0x72>

00801160 <close>:

int
close(int fdnum)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801166:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801169:	50                   	push   %eax
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 b9 fe ff ff       	call   80102b <fd_lookup>
  801172:	83 c4 08             	add    $0x8,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	78 10                	js     801189 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	6a 01                	push   $0x1
  80117e:	ff 75 f4             	pushl  -0xc(%ebp)
  801181:	e8 51 ff ff ff       	call   8010d7 <fd_close>
  801186:	83 c4 10             	add    $0x10,%esp
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <close_all>:

void
close_all(void)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	53                   	push   %ebx
  80118f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801192:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801197:	83 ec 0c             	sub    $0xc,%esp
  80119a:	53                   	push   %ebx
  80119b:	e8 c0 ff ff ff       	call   801160 <close>
	for (i = 0; i < MAXFD; i++)
  8011a0:	83 c3 01             	add    $0x1,%ebx
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	83 fb 20             	cmp    $0x20,%ebx
  8011a9:	75 ec                	jne    801197 <close_all+0xc>
}
  8011ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	57                   	push   %edi
  8011b4:	56                   	push   %esi
  8011b5:	53                   	push   %ebx
  8011b6:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 66 fe ff ff       	call   80102b <fd_lookup>
  8011c5:	89 c3                	mov    %eax,%ebx
  8011c7:	83 c4 08             	add    $0x8,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	0f 88 81 00 00 00    	js     801253 <dup+0xa3>
		return r;
	close(newfdnum);
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	ff 75 0c             	pushl  0xc(%ebp)
  8011d8:	e8 83 ff ff ff       	call   801160 <close>

	newfd = INDEX2FD(newfdnum);
  8011dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011e0:	c1 e6 0c             	shl    $0xc,%esi
  8011e3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011e9:	83 c4 04             	add    $0x4,%esp
  8011ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ef:	e8 d1 fd ff ff       	call   800fc5 <fd2data>
  8011f4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f6:	89 34 24             	mov    %esi,(%esp)
  8011f9:	e8 c7 fd ff ff       	call   800fc5 <fd2data>
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801203:	89 d8                	mov    %ebx,%eax
  801205:	c1 e8 16             	shr    $0x16,%eax
  801208:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80120f:	a8 01                	test   $0x1,%al
  801211:	74 11                	je     801224 <dup+0x74>
  801213:	89 d8                	mov    %ebx,%eax
  801215:	c1 e8 0c             	shr    $0xc,%eax
  801218:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80121f:	f6 c2 01             	test   $0x1,%dl
  801222:	75 39                	jne    80125d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801224:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801227:	89 d0                	mov    %edx,%eax
  801229:	c1 e8 0c             	shr    $0xc,%eax
  80122c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	25 07 0e 00 00       	and    $0xe07,%eax
  80123b:	50                   	push   %eax
  80123c:	56                   	push   %esi
  80123d:	6a 00                	push   $0x0
  80123f:	52                   	push   %edx
  801240:	6a 00                	push   $0x0
  801242:	e8 a1 fb ff ff       	call   800de8 <sys_page_map>
  801247:	89 c3                	mov    %eax,%ebx
  801249:	83 c4 20             	add    $0x20,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	78 31                	js     801281 <dup+0xd1>
		goto err;

	return newfdnum;
  801250:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801253:	89 d8                	mov    %ebx,%eax
  801255:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801258:	5b                   	pop    %ebx
  801259:	5e                   	pop    %esi
  80125a:	5f                   	pop    %edi
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80125d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801264:	83 ec 0c             	sub    $0xc,%esp
  801267:	25 07 0e 00 00       	and    $0xe07,%eax
  80126c:	50                   	push   %eax
  80126d:	57                   	push   %edi
  80126e:	6a 00                	push   $0x0
  801270:	53                   	push   %ebx
  801271:	6a 00                	push   $0x0
  801273:	e8 70 fb ff ff       	call   800de8 <sys_page_map>
  801278:	89 c3                	mov    %eax,%ebx
  80127a:	83 c4 20             	add    $0x20,%esp
  80127d:	85 c0                	test   %eax,%eax
  80127f:	79 a3                	jns    801224 <dup+0x74>
	sys_page_unmap(0, newfd);
  801281:	83 ec 08             	sub    $0x8,%esp
  801284:	56                   	push   %esi
  801285:	6a 00                	push   $0x0
  801287:	e8 9e fb ff ff       	call   800e2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80128c:	83 c4 08             	add    $0x8,%esp
  80128f:	57                   	push   %edi
  801290:	6a 00                	push   $0x0
  801292:	e8 93 fb ff ff       	call   800e2a <sys_page_unmap>
	return r;
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	eb b7                	jmp    801253 <dup+0xa3>

0080129c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 14             	sub    $0x14,%esp
  8012a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a9:	50                   	push   %eax
  8012aa:	53                   	push   %ebx
  8012ab:	e8 7b fd ff ff       	call   80102b <fd_lookup>
  8012b0:	83 c4 08             	add    $0x8,%esp
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	78 3f                	js     8012f6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b7:	83 ec 08             	sub    $0x8,%esp
  8012ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bd:	50                   	push   %eax
  8012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c1:	ff 30                	pushl  (%eax)
  8012c3:	e8 b9 fd ff ff       	call   801081 <dev_lookup>
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 27                	js     8012f6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d2:	8b 42 08             	mov    0x8(%edx),%eax
  8012d5:	83 e0 03             	and    $0x3,%eax
  8012d8:	83 f8 01             	cmp    $0x1,%eax
  8012db:	74 1e                	je     8012fb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e0:	8b 40 08             	mov    0x8(%eax),%eax
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	74 35                	je     80131c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	ff 75 10             	pushl  0x10(%ebp)
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	52                   	push   %edx
  8012f1:	ff d0                	call   *%eax
  8012f3:	83 c4 10             	add    $0x10,%esp
}
  8012f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012fb:	a1 08 40 80 00       	mov    0x804008,%eax
  801300:	8b 40 48             	mov    0x48(%eax),%eax
  801303:	83 ec 04             	sub    $0x4,%esp
  801306:	53                   	push   %ebx
  801307:	50                   	push   %eax
  801308:	68 cd 28 80 00       	push   $0x8028cd
  80130d:	e8 fd ef ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131a:	eb da                	jmp    8012f6 <read+0x5a>
		return -E_NOT_SUPP;
  80131c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801321:	eb d3                	jmp    8012f6 <read+0x5a>

00801323 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	57                   	push   %edi
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80132f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801332:	bb 00 00 00 00       	mov    $0x0,%ebx
  801337:	39 f3                	cmp    %esi,%ebx
  801339:	73 25                	jae    801360 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80133b:	83 ec 04             	sub    $0x4,%esp
  80133e:	89 f0                	mov    %esi,%eax
  801340:	29 d8                	sub    %ebx,%eax
  801342:	50                   	push   %eax
  801343:	89 d8                	mov    %ebx,%eax
  801345:	03 45 0c             	add    0xc(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	57                   	push   %edi
  80134a:	e8 4d ff ff ff       	call   80129c <read>
		if (m < 0)
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	78 08                	js     80135e <readn+0x3b>
			return m;
		if (m == 0)
  801356:	85 c0                	test   %eax,%eax
  801358:	74 06                	je     801360 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80135a:	01 c3                	add    %eax,%ebx
  80135c:	eb d9                	jmp    801337 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801360:	89 d8                	mov    %ebx,%eax
  801362:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 14             	sub    $0x14,%esp
  801371:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801377:	50                   	push   %eax
  801378:	53                   	push   %ebx
  801379:	e8 ad fc ff ff       	call   80102b <fd_lookup>
  80137e:	83 c4 08             	add    $0x8,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	78 3a                	js     8013bf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801385:	83 ec 08             	sub    $0x8,%esp
  801388:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138b:	50                   	push   %eax
  80138c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138f:	ff 30                	pushl  (%eax)
  801391:	e8 eb fc ff ff       	call   801081 <dev_lookup>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 22                	js     8013bf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a4:	74 1e                	je     8013c4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	74 35                	je     8013e5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	ff 75 10             	pushl  0x10(%ebp)
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	50                   	push   %eax
  8013ba:	ff d2                	call   *%edx
  8013bc:	83 c4 10             	add    $0x10,%esp
}
  8013bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c4:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c9:	8b 40 48             	mov    0x48(%eax),%eax
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	53                   	push   %ebx
  8013d0:	50                   	push   %eax
  8013d1:	68 e9 28 80 00       	push   $0x8028e9
  8013d6:	e8 34 ef ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e3:	eb da                	jmp    8013bf <write+0x55>
		return -E_NOT_SUPP;
  8013e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ea:	eb d3                	jmp    8013bf <write+0x55>

008013ec <seek>:

int
seek(int fdnum, off_t offset)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f2:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013f5:	50                   	push   %eax
  8013f6:	ff 75 08             	pushl  0x8(%ebp)
  8013f9:	e8 2d fc ff ff       	call   80102b <fd_lookup>
  8013fe:	83 c4 08             	add    $0x8,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 0e                	js     801413 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801405:	8b 55 0c             	mov    0xc(%ebp),%edx
  801408:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80140e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	53                   	push   %ebx
  801419:	83 ec 14             	sub    $0x14,%esp
  80141c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801422:	50                   	push   %eax
  801423:	53                   	push   %ebx
  801424:	e8 02 fc ff ff       	call   80102b <fd_lookup>
  801429:	83 c4 08             	add    $0x8,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 37                	js     801467 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801436:	50                   	push   %eax
  801437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143a:	ff 30                	pushl  (%eax)
  80143c:	e8 40 fc ff ff       	call   801081 <dev_lookup>
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 1f                	js     801467 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80144f:	74 1b                	je     80146c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801454:	8b 52 18             	mov    0x18(%edx),%edx
  801457:	85 d2                	test   %edx,%edx
  801459:	74 32                	je     80148d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	ff 75 0c             	pushl  0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	ff d2                	call   *%edx
  801464:	83 c4 10             	add    $0x10,%esp
}
  801467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80146c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801471:	8b 40 48             	mov    0x48(%eax),%eax
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	53                   	push   %ebx
  801478:	50                   	push   %eax
  801479:	68 ac 28 80 00       	push   $0x8028ac
  80147e:	e8 8c ee ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148b:	eb da                	jmp    801467 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80148d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801492:	eb d3                	jmp    801467 <ftruncate+0x52>

00801494 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	53                   	push   %ebx
  801498:	83 ec 14             	sub    $0x14,%esp
  80149b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	ff 75 08             	pushl  0x8(%ebp)
  8014a5:	e8 81 fb ff ff       	call   80102b <fd_lookup>
  8014aa:	83 c4 08             	add    $0x8,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 4b                	js     8014fc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b7:	50                   	push   %eax
  8014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bb:	ff 30                	pushl  (%eax)
  8014bd:	e8 bf fb ff ff       	call   801081 <dev_lookup>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 33                	js     8014fc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d0:	74 2f                	je     801501 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014d2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014d5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014dc:	00 00 00 
	stat->st_isdir = 0;
  8014df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014e6:	00 00 00 
	stat->st_dev = dev;
  8014e9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	53                   	push   %ebx
  8014f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f6:	ff 50 14             	call   *0x14(%eax)
  8014f9:	83 c4 10             	add    $0x10,%esp
}
  8014fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    
		return -E_NOT_SUPP;
  801501:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801506:	eb f4                	jmp    8014fc <fstat+0x68>

00801508 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	56                   	push   %esi
  80150c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	6a 00                	push   $0x0
  801512:	ff 75 08             	pushl  0x8(%ebp)
  801515:	e8 26 02 00 00       	call   801740 <open>
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 1b                	js     80153e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	50                   	push   %eax
  80152a:	e8 65 ff ff ff       	call   801494 <fstat>
  80152f:	89 c6                	mov    %eax,%esi
	close(fd);
  801531:	89 1c 24             	mov    %ebx,(%esp)
  801534:	e8 27 fc ff ff       	call   801160 <close>
	return r;
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	89 f3                	mov    %esi,%ebx
}
  80153e:	89 d8                	mov    %ebx,%eax
  801540:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801543:	5b                   	pop    %ebx
  801544:	5e                   	pop    %esi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	56                   	push   %esi
  80154b:	53                   	push   %ebx
  80154c:	89 c6                	mov    %eax,%esi
  80154e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801550:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801557:	74 27                	je     801580 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801559:	6a 07                	push   $0x7
  80155b:	68 00 50 80 00       	push   $0x805000
  801560:	56                   	push   %esi
  801561:	ff 35 00 40 80 00    	pushl  0x804000
  801567:	e8 11 0c 00 00       	call   80217d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80156c:	83 c4 0c             	add    $0xc,%esp
  80156f:	6a 00                	push   $0x0
  801571:	53                   	push   %ebx
  801572:	6a 00                	push   $0x0
  801574:	e8 9b 0b 00 00       	call   802114 <ipc_recv>
}
  801579:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	6a 01                	push   $0x1
  801585:	e8 4c 0c 00 00       	call   8021d6 <ipc_find_env>
  80158a:	a3 00 40 80 00       	mov    %eax,0x804000
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	eb c5                	jmp    801559 <fsipc+0x12>

00801594 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b2:	b8 02 00 00 00       	mov    $0x2,%eax
  8015b7:	e8 8b ff ff ff       	call   801547 <fsipc>
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <devfile_flush>:
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ca:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d4:	b8 06 00 00 00       	mov    $0x6,%eax
  8015d9:	e8 69 ff ff ff       	call   801547 <fsipc>
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <devfile_stat>:
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8015ff:	e8 43 ff ff ff       	call   801547 <fsipc>
  801604:	85 c0                	test   %eax,%eax
  801606:	78 2c                	js     801634 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	68 00 50 80 00       	push   $0x805000
  801610:	53                   	push   %ebx
  801611:	e8 96 f3 ff ff       	call   8009ac <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801616:	a1 80 50 80 00       	mov    0x805080,%eax
  80161b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801621:	a1 84 50 80 00       	mov    0x805084,%eax
  801626:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <devfile_write>:
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	53                   	push   %ebx
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8b 40 0c             	mov    0xc(%eax),%eax
  801649:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80164e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801654:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80165a:	77 30                	ja     80168c <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	53                   	push   %ebx
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	68 08 50 80 00       	push   $0x805008
  801668:	e8 cd f4 ff ff       	call   800b3a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80166d:	ba 00 00 00 00       	mov    $0x0,%edx
  801672:	b8 04 00 00 00       	mov    $0x4,%eax
  801677:	e8 cb fe ff ff       	call   801547 <fsipc>
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	85 c0                	test   %eax,%eax
  801681:	78 04                	js     801687 <devfile_write+0x4e>
	assert(r <= n);
  801683:	39 d8                	cmp    %ebx,%eax
  801685:	77 1e                	ja     8016a5 <devfile_write+0x6c>
}
  801687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80168c:	68 1c 29 80 00       	push   $0x80291c
  801691:	68 4c 29 80 00       	push   $0x80294c
  801696:	68 94 00 00 00       	push   $0x94
  80169b:	68 61 29 80 00       	push   $0x802961
  8016a0:	e8 8f eb ff ff       	call   800234 <_panic>
	assert(r <= n);
  8016a5:	68 6c 29 80 00       	push   $0x80296c
  8016aa:	68 4c 29 80 00       	push   $0x80294c
  8016af:	68 98 00 00 00       	push   $0x98
  8016b4:	68 61 29 80 00       	push   $0x802961
  8016b9:	e8 76 eb ff ff       	call   800234 <_panic>

008016be <devfile_read>:
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	56                   	push   %esi
  8016c2:	53                   	push   %ebx
  8016c3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016cc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016d1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8016e1:	e8 61 fe ff ff       	call   801547 <fsipc>
  8016e6:	89 c3                	mov    %eax,%ebx
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	78 1f                	js     80170b <devfile_read+0x4d>
	assert(r <= n);
  8016ec:	39 f0                	cmp    %esi,%eax
  8016ee:	77 24                	ja     801714 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016f0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f5:	7f 33                	jg     80172a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016f7:	83 ec 04             	sub    $0x4,%esp
  8016fa:	50                   	push   %eax
  8016fb:	68 00 50 80 00       	push   $0x805000
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	e8 32 f4 ff ff       	call   800b3a <memmove>
	return r;
  801708:	83 c4 10             	add    $0x10,%esp
}
  80170b:	89 d8                	mov    %ebx,%eax
  80170d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801710:	5b                   	pop    %ebx
  801711:	5e                   	pop    %esi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    
	assert(r <= n);
  801714:	68 6c 29 80 00       	push   $0x80296c
  801719:	68 4c 29 80 00       	push   $0x80294c
  80171e:	6a 7c                	push   $0x7c
  801720:	68 61 29 80 00       	push   $0x802961
  801725:	e8 0a eb ff ff       	call   800234 <_panic>
	assert(r <= PGSIZE);
  80172a:	68 73 29 80 00       	push   $0x802973
  80172f:	68 4c 29 80 00       	push   $0x80294c
  801734:	6a 7d                	push   $0x7d
  801736:	68 61 29 80 00       	push   $0x802961
  80173b:	e8 f4 ea ff ff       	call   800234 <_panic>

00801740 <open>:
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	83 ec 1c             	sub    $0x1c,%esp
  801748:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80174b:	56                   	push   %esi
  80174c:	e8 24 f2 ff ff       	call   800975 <strlen>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801759:	7f 6c                	jg     8017c7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801761:	50                   	push   %eax
  801762:	e8 75 f8 ff ff       	call   800fdc <fd_alloc>
  801767:	89 c3                	mov    %eax,%ebx
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 3c                	js     8017ac <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	56                   	push   %esi
  801774:	68 00 50 80 00       	push   $0x805000
  801779:	e8 2e f2 ff ff       	call   8009ac <strcpy>
	fsipcbuf.open.req_omode = mode;
  80177e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801781:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801789:	b8 01 00 00 00       	mov    $0x1,%eax
  80178e:	e8 b4 fd ff ff       	call   801547 <fsipc>
  801793:	89 c3                	mov    %eax,%ebx
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 19                	js     8017b5 <open+0x75>
	return fd2num(fd);
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a2:	e8 0e f8 ff ff       	call   800fb5 <fd2num>
  8017a7:	89 c3                	mov    %eax,%ebx
  8017a9:	83 c4 10             	add    $0x10,%esp
}
  8017ac:	89 d8                	mov    %ebx,%eax
  8017ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b1:	5b                   	pop    %ebx
  8017b2:	5e                   	pop    %esi
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    
		fd_close(fd, 0);
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	6a 00                	push   $0x0
  8017ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bd:	e8 15 f9 ff ff       	call   8010d7 <fd_close>
		return r;
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	eb e5                	jmp    8017ac <open+0x6c>
		return -E_BAD_PATH;
  8017c7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017cc:	eb de                	jmp    8017ac <open+0x6c>

008017ce <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8017de:	e8 64 fd ff ff       	call   801547 <fsipc>
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	56                   	push   %esi
  8017e9:	53                   	push   %ebx
  8017ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	e8 cd f7 ff ff       	call   800fc5 <fd2data>
  8017f8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017fa:	83 c4 08             	add    $0x8,%esp
  8017fd:	68 7f 29 80 00       	push   $0x80297f
  801802:	53                   	push   %ebx
  801803:	e8 a4 f1 ff ff       	call   8009ac <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801808:	8b 46 04             	mov    0x4(%esi),%eax
  80180b:	2b 06                	sub    (%esi),%eax
  80180d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801813:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80181a:	00 00 00 
	stat->st_dev = &devpipe;
  80181d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801824:	30 80 00 
	return 0;
}
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
  80182c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	53                   	push   %ebx
  801837:	83 ec 0c             	sub    $0xc,%esp
  80183a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80183d:	53                   	push   %ebx
  80183e:	6a 00                	push   $0x0
  801840:	e8 e5 f5 ff ff       	call   800e2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801845:	89 1c 24             	mov    %ebx,(%esp)
  801848:	e8 78 f7 ff ff       	call   800fc5 <fd2data>
  80184d:	83 c4 08             	add    $0x8,%esp
  801850:	50                   	push   %eax
  801851:	6a 00                	push   $0x0
  801853:	e8 d2 f5 ff ff       	call   800e2a <sys_page_unmap>
}
  801858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <_pipeisclosed>:
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	57                   	push   %edi
  801861:	56                   	push   %esi
  801862:	53                   	push   %ebx
  801863:	83 ec 1c             	sub    $0x1c,%esp
  801866:	89 c7                	mov    %eax,%edi
  801868:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80186a:	a1 08 40 80 00       	mov    0x804008,%eax
  80186f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801872:	83 ec 0c             	sub    $0xc,%esp
  801875:	57                   	push   %edi
  801876:	e8 94 09 00 00       	call   80220f <pageref>
  80187b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80187e:	89 34 24             	mov    %esi,(%esp)
  801881:	e8 89 09 00 00       	call   80220f <pageref>
		nn = thisenv->env_runs;
  801886:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80188c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	39 cb                	cmp    %ecx,%ebx
  801894:	74 1b                	je     8018b1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801896:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801899:	75 cf                	jne    80186a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80189b:	8b 42 58             	mov    0x58(%edx),%eax
  80189e:	6a 01                	push   $0x1
  8018a0:	50                   	push   %eax
  8018a1:	53                   	push   %ebx
  8018a2:	68 86 29 80 00       	push   $0x802986
  8018a7:	e8 63 ea ff ff       	call   80030f <cprintf>
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	eb b9                	jmp    80186a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018b1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018b4:	0f 94 c0             	sete   %al
  8018b7:	0f b6 c0             	movzbl %al,%eax
}
  8018ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5f                   	pop    %edi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <devpipe_write>:
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 28             	sub    $0x28,%esp
  8018cb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018ce:	56                   	push   %esi
  8018cf:	e8 f1 f6 ff ff       	call   800fc5 <fd2data>
  8018d4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8018de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018e1:	74 4f                	je     801932 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018e3:	8b 43 04             	mov    0x4(%ebx),%eax
  8018e6:	8b 0b                	mov    (%ebx),%ecx
  8018e8:	8d 51 20             	lea    0x20(%ecx),%edx
  8018eb:	39 d0                	cmp    %edx,%eax
  8018ed:	72 14                	jb     801903 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8018ef:	89 da                	mov    %ebx,%edx
  8018f1:	89 f0                	mov    %esi,%eax
  8018f3:	e8 65 ff ff ff       	call   80185d <_pipeisclosed>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	75 3a                	jne    801936 <devpipe_write+0x74>
			sys_yield();
  8018fc:	e8 85 f4 ff ff       	call   800d86 <sys_yield>
  801901:	eb e0                	jmp    8018e3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801903:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801906:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80190a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80190d:	89 c2                	mov    %eax,%edx
  80190f:	c1 fa 1f             	sar    $0x1f,%edx
  801912:	89 d1                	mov    %edx,%ecx
  801914:	c1 e9 1b             	shr    $0x1b,%ecx
  801917:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80191a:	83 e2 1f             	and    $0x1f,%edx
  80191d:	29 ca                	sub    %ecx,%edx
  80191f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801923:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801927:	83 c0 01             	add    $0x1,%eax
  80192a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80192d:	83 c7 01             	add    $0x1,%edi
  801930:	eb ac                	jmp    8018de <devpipe_write+0x1c>
	return i;
  801932:	89 f8                	mov    %edi,%eax
  801934:	eb 05                	jmp    80193b <devpipe_write+0x79>
				return 0;
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5f                   	pop    %edi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <devpipe_read>:
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	57                   	push   %edi
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
  801949:	83 ec 18             	sub    $0x18,%esp
  80194c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80194f:	57                   	push   %edi
  801950:	e8 70 f6 ff ff       	call   800fc5 <fd2data>
  801955:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	be 00 00 00 00       	mov    $0x0,%esi
  80195f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801962:	74 47                	je     8019ab <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801964:	8b 03                	mov    (%ebx),%eax
  801966:	3b 43 04             	cmp    0x4(%ebx),%eax
  801969:	75 22                	jne    80198d <devpipe_read+0x4a>
			if (i > 0)
  80196b:	85 f6                	test   %esi,%esi
  80196d:	75 14                	jne    801983 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80196f:	89 da                	mov    %ebx,%edx
  801971:	89 f8                	mov    %edi,%eax
  801973:	e8 e5 fe ff ff       	call   80185d <_pipeisclosed>
  801978:	85 c0                	test   %eax,%eax
  80197a:	75 33                	jne    8019af <devpipe_read+0x6c>
			sys_yield();
  80197c:	e8 05 f4 ff ff       	call   800d86 <sys_yield>
  801981:	eb e1                	jmp    801964 <devpipe_read+0x21>
				return i;
  801983:	89 f0                	mov    %esi,%eax
}
  801985:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801988:	5b                   	pop    %ebx
  801989:	5e                   	pop    %esi
  80198a:	5f                   	pop    %edi
  80198b:	5d                   	pop    %ebp
  80198c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80198d:	99                   	cltd   
  80198e:	c1 ea 1b             	shr    $0x1b,%edx
  801991:	01 d0                	add    %edx,%eax
  801993:	83 e0 1f             	and    $0x1f,%eax
  801996:	29 d0                	sub    %edx,%eax
  801998:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80199d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8019a3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8019a6:	83 c6 01             	add    $0x1,%esi
  8019a9:	eb b4                	jmp    80195f <devpipe_read+0x1c>
	return i;
  8019ab:	89 f0                	mov    %esi,%eax
  8019ad:	eb d6                	jmp    801985 <devpipe_read+0x42>
				return 0;
  8019af:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b4:	eb cf                	jmp    801985 <devpipe_read+0x42>

008019b6 <pipe>:
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	56                   	push   %esi
  8019ba:	53                   	push   %ebx
  8019bb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c1:	50                   	push   %eax
  8019c2:	e8 15 f6 ff ff       	call   800fdc <fd_alloc>
  8019c7:	89 c3                	mov    %eax,%ebx
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	78 5b                	js     801a2b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	68 07 04 00 00       	push   $0x407
  8019d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019db:	6a 00                	push   $0x0
  8019dd:	e8 c3 f3 ff ff       	call   800da5 <sys_page_alloc>
  8019e2:	89 c3                	mov    %eax,%ebx
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	78 40                	js     801a2b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8019eb:	83 ec 0c             	sub    $0xc,%esp
  8019ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f1:	50                   	push   %eax
  8019f2:	e8 e5 f5 ff ff       	call   800fdc <fd_alloc>
  8019f7:	89 c3                	mov    %eax,%ebx
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 1b                	js     801a1b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	68 07 04 00 00       	push   $0x407
  801a08:	ff 75 f0             	pushl  -0x10(%ebp)
  801a0b:	6a 00                	push   $0x0
  801a0d:	e8 93 f3 ff ff       	call   800da5 <sys_page_alloc>
  801a12:	89 c3                	mov    %eax,%ebx
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	79 19                	jns    801a34 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a1b:	83 ec 08             	sub    $0x8,%esp
  801a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a21:	6a 00                	push   $0x0
  801a23:	e8 02 f4 ff ff       	call   800e2a <sys_page_unmap>
  801a28:	83 c4 10             	add    $0x10,%esp
}
  801a2b:	89 d8                	mov    %ebx,%eax
  801a2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    
	va = fd2data(fd0);
  801a34:	83 ec 0c             	sub    $0xc,%esp
  801a37:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3a:	e8 86 f5 ff ff       	call   800fc5 <fd2data>
  801a3f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a41:	83 c4 0c             	add    $0xc,%esp
  801a44:	68 07 04 00 00       	push   $0x407
  801a49:	50                   	push   %eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 54 f3 ff ff       	call   800da5 <sys_page_alloc>
  801a51:	89 c3                	mov    %eax,%ebx
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	85 c0                	test   %eax,%eax
  801a58:	0f 88 8c 00 00 00    	js     801aea <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a5e:	83 ec 0c             	sub    $0xc,%esp
  801a61:	ff 75 f0             	pushl  -0x10(%ebp)
  801a64:	e8 5c f5 ff ff       	call   800fc5 <fd2data>
  801a69:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a70:	50                   	push   %eax
  801a71:	6a 00                	push   $0x0
  801a73:	56                   	push   %esi
  801a74:	6a 00                	push   $0x0
  801a76:	e8 6d f3 ff ff       	call   800de8 <sys_page_map>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	83 c4 20             	add    $0x20,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 58                	js     801adc <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a87:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a8d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aa2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801aae:	83 ec 0c             	sub    $0xc,%esp
  801ab1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab4:	e8 fc f4 ff ff       	call   800fb5 <fd2num>
  801ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801abe:	83 c4 04             	add    $0x4,%esp
  801ac1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac4:	e8 ec f4 ff ff       	call   800fb5 <fd2num>
  801ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801acc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad7:	e9 4f ff ff ff       	jmp    801a2b <pipe+0x75>
	sys_page_unmap(0, va);
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	56                   	push   %esi
  801ae0:	6a 00                	push   $0x0
  801ae2:	e8 43 f3 ff ff       	call   800e2a <sys_page_unmap>
  801ae7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801aea:	83 ec 08             	sub    $0x8,%esp
  801aed:	ff 75 f0             	pushl  -0x10(%ebp)
  801af0:	6a 00                	push   $0x0
  801af2:	e8 33 f3 ff ff       	call   800e2a <sys_page_unmap>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	e9 1c ff ff ff       	jmp    801a1b <pipe+0x65>

00801aff <pipeisclosed>:
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b08:	50                   	push   %eax
  801b09:	ff 75 08             	pushl  0x8(%ebp)
  801b0c:	e8 1a f5 ff ff       	call   80102b <fd_lookup>
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 18                	js     801b30 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1e:	e8 a2 f4 ff ff       	call   800fc5 <fd2data>
	return _pipeisclosed(fd, p);
  801b23:	89 c2                	mov    %eax,%edx
  801b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b28:	e8 30 fd ff ff       	call   80185d <_pipeisclosed>
  801b2d:	83 c4 10             	add    $0x10,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b38:	68 9e 29 80 00       	push   $0x80299e
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	e8 67 ee ff ff       	call   8009ac <strcpy>
	return 0;
}
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <devsock_close>:
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	53                   	push   %ebx
  801b50:	83 ec 10             	sub    $0x10,%esp
  801b53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b56:	53                   	push   %ebx
  801b57:	e8 b3 06 00 00       	call   80220f <pageref>
  801b5c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b5f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b64:	83 f8 01             	cmp    $0x1,%eax
  801b67:	74 07                	je     801b70 <devsock_close+0x24>
}
  801b69:	89 d0                	mov    %edx,%eax
  801b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b70:	83 ec 0c             	sub    $0xc,%esp
  801b73:	ff 73 0c             	pushl  0xc(%ebx)
  801b76:	e8 b7 02 00 00       	call   801e32 <nsipc_close>
  801b7b:	89 c2                	mov    %eax,%edx
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	eb e7                	jmp    801b69 <devsock_close+0x1d>

00801b82 <devsock_write>:
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	ff 70 0c             	pushl  0xc(%eax)
  801b96:	e8 74 03 00 00       	call   801f0f <nsipc_send>
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <devsock_read>:
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	ff 70 0c             	pushl  0xc(%eax)
  801bb1:	e8 ed 02 00 00       	call   801ea3 <nsipc_recv>
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <fd2sockid>:
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bbe:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bc1:	52                   	push   %edx
  801bc2:	50                   	push   %eax
  801bc3:	e8 63 f4 ff ff       	call   80102b <fd_lookup>
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	78 10                	js     801bdf <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801bd8:	39 08                	cmp    %ecx,(%eax)
  801bda:	75 05                	jne    801be1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bdc:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    
		return -E_NOT_SUPP;
  801be1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801be6:	eb f7                	jmp    801bdf <fd2sockid+0x27>

00801be8 <alloc_sockfd>:
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	56                   	push   %esi
  801bec:	53                   	push   %ebx
  801bed:	83 ec 1c             	sub    $0x1c,%esp
  801bf0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf5:	50                   	push   %eax
  801bf6:	e8 e1 f3 ff ff       	call   800fdc <fd_alloc>
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 43                	js     801c47 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	68 07 04 00 00       	push   $0x407
  801c0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0f:	6a 00                	push   $0x0
  801c11:	e8 8f f1 ff ff       	call   800da5 <sys_page_alloc>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 28                	js     801c47 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c22:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c28:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c34:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	50                   	push   %eax
  801c3b:	e8 75 f3 ff ff       	call   800fb5 <fd2num>
  801c40:	89 c3                	mov    %eax,%ebx
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	eb 0c                	jmp    801c53 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	56                   	push   %esi
  801c4b:	e8 e2 01 00 00       	call   801e32 <nsipc_close>
		return r;
  801c50:	83 c4 10             	add    $0x10,%esp
}
  801c53:	89 d8                	mov    %ebx,%eax
  801c55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c58:	5b                   	pop    %ebx
  801c59:	5e                   	pop    %esi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    

00801c5c <accept>:
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	e8 4e ff ff ff       	call   801bb8 <fd2sockid>
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	78 1b                	js     801c89 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	ff 75 10             	pushl  0x10(%ebp)
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	50                   	push   %eax
  801c78:	e8 0e 01 00 00       	call   801d8b <nsipc_accept>
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 05                	js     801c89 <accept+0x2d>
	return alloc_sockfd(r);
  801c84:	e8 5f ff ff ff       	call   801be8 <alloc_sockfd>
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <bind>:
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	e8 1f ff ff ff       	call   801bb8 <fd2sockid>
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 12                	js     801caf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	ff 75 10             	pushl  0x10(%ebp)
  801ca3:	ff 75 0c             	pushl  0xc(%ebp)
  801ca6:	50                   	push   %eax
  801ca7:	e8 2f 01 00 00       	call   801ddb <nsipc_bind>
  801cac:	83 c4 10             	add    $0x10,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <shutdown>:
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	e8 f9 fe ff ff       	call   801bb8 <fd2sockid>
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 0f                	js     801cd2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801cc3:	83 ec 08             	sub    $0x8,%esp
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	50                   	push   %eax
  801cca:	e8 41 01 00 00       	call   801e10 <nsipc_shutdown>
  801ccf:	83 c4 10             	add    $0x10,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <connect>:
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	e8 d6 fe ff ff       	call   801bb8 <fd2sockid>
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 12                	js     801cf8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	ff 75 10             	pushl  0x10(%ebp)
  801cec:	ff 75 0c             	pushl  0xc(%ebp)
  801cef:	50                   	push   %eax
  801cf0:	e8 57 01 00 00       	call   801e4c <nsipc_connect>
  801cf5:	83 c4 10             	add    $0x10,%esp
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <listen>:
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	e8 b0 fe ff ff       	call   801bb8 <fd2sockid>
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 0f                	js     801d1b <listen+0x21>
	return nsipc_listen(r, backlog);
  801d0c:	83 ec 08             	sub    $0x8,%esp
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	50                   	push   %eax
  801d13:	e8 69 01 00 00       	call   801e81 <nsipc_listen>
  801d18:	83 c4 10             	add    $0x10,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <socket>:

int
socket(int domain, int type, int protocol)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d23:	ff 75 10             	pushl  0x10(%ebp)
  801d26:	ff 75 0c             	pushl  0xc(%ebp)
  801d29:	ff 75 08             	pushl  0x8(%ebp)
  801d2c:	e8 3c 02 00 00       	call   801f6d <nsipc_socket>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	85 c0                	test   %eax,%eax
  801d36:	78 05                	js     801d3d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d38:	e8 ab fe ff ff       	call   801be8 <alloc_sockfd>
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	53                   	push   %ebx
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d48:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d4f:	74 26                	je     801d77 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d51:	6a 07                	push   $0x7
  801d53:	68 00 60 80 00       	push   $0x806000
  801d58:	53                   	push   %ebx
  801d59:	ff 35 04 40 80 00    	pushl  0x804004
  801d5f:	e8 19 04 00 00       	call   80217d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d64:	83 c4 0c             	add    $0xc,%esp
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	e8 a2 03 00 00       	call   802114 <ipc_recv>
}
  801d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	6a 02                	push   $0x2
  801d7c:	e8 55 04 00 00       	call   8021d6 <ipc_find_env>
  801d81:	a3 04 40 80 00       	mov    %eax,0x804004
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	eb c6                	jmp    801d51 <nsipc+0x12>

00801d8b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	56                   	push   %esi
  801d8f:	53                   	push   %ebx
  801d90:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d9b:	8b 06                	mov    (%esi),%eax
  801d9d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801da2:	b8 01 00 00 00       	mov    $0x1,%eax
  801da7:	e8 93 ff ff ff       	call   801d3f <nsipc>
  801dac:	89 c3                	mov    %eax,%ebx
  801dae:	85 c0                	test   %eax,%eax
  801db0:	78 20                	js     801dd2 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	ff 35 10 60 80 00    	pushl  0x806010
  801dbb:	68 00 60 80 00       	push   $0x806000
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	e8 72 ed ff ff       	call   800b3a <memmove>
		*addrlen = ret->ret_addrlen;
  801dc8:	a1 10 60 80 00       	mov    0x806010,%eax
  801dcd:	89 06                	mov    %eax,(%esi)
  801dcf:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801dd2:	89 d8                	mov    %ebx,%eax
  801dd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5d                   	pop    %ebp
  801dda:	c3                   	ret    

00801ddb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 08             	sub    $0x8,%esp
  801de2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ded:	53                   	push   %ebx
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	68 04 60 80 00       	push   $0x806004
  801df6:	e8 3f ed ff ff       	call   800b3a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dfb:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e01:	b8 02 00 00 00       	mov    $0x2,%eax
  801e06:	e8 34 ff ff ff       	call   801d3f <nsipc>
}
  801e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e26:	b8 03 00 00 00       	mov    $0x3,%eax
  801e2b:	e8 0f ff ff ff       	call   801d3f <nsipc>
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <nsipc_close>:

int
nsipc_close(int s)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e40:	b8 04 00 00 00       	mov    $0x4,%eax
  801e45:	e8 f5 fe ff ff       	call   801d3f <nsipc>
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 08             	sub    $0x8,%esp
  801e53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e5e:	53                   	push   %ebx
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	68 04 60 80 00       	push   $0x806004
  801e67:	e8 ce ec ff ff       	call   800b3a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e6c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e72:	b8 05 00 00 00       	mov    $0x5,%eax
  801e77:	e8 c3 fe ff ff       	call   801d3f <nsipc>
}
  801e7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e92:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e97:	b8 06 00 00 00       	mov    $0x6,%eax
  801e9c:	e8 9e fe ff ff       	call   801d3f <nsipc>
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	56                   	push   %esi
  801ea7:	53                   	push   %ebx
  801ea8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801eb3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebc:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ec1:	b8 07 00 00 00       	mov    $0x7,%eax
  801ec6:	e8 74 fe ff ff       	call   801d3f <nsipc>
  801ecb:	89 c3                	mov    %eax,%ebx
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 1f                	js     801ef0 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ed1:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ed6:	7f 21                	jg     801ef9 <nsipc_recv+0x56>
  801ed8:	39 c6                	cmp    %eax,%esi
  801eda:	7c 1d                	jl     801ef9 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	50                   	push   %eax
  801ee0:	68 00 60 80 00       	push   $0x806000
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	e8 4d ec ff ff       	call   800b3a <memmove>
  801eed:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ef0:	89 d8                	mov    %ebx,%eax
  801ef2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ef9:	68 aa 29 80 00       	push   $0x8029aa
  801efe:	68 4c 29 80 00       	push   $0x80294c
  801f03:	6a 62                	push   $0x62
  801f05:	68 bf 29 80 00       	push   $0x8029bf
  801f0a:	e8 25 e3 ff ff       	call   800234 <_panic>

00801f0f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	53                   	push   %ebx
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f21:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f27:	7f 2e                	jg     801f57 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	53                   	push   %ebx
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	68 0c 60 80 00       	push   $0x80600c
  801f35:	e8 00 ec ff ff       	call   800b3a <memmove>
	nsipcbuf.send.req_size = size;
  801f3a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f40:	8b 45 14             	mov    0x14(%ebp),%eax
  801f43:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f48:	b8 08 00 00 00       	mov    $0x8,%eax
  801f4d:	e8 ed fd ff ff       	call   801d3f <nsipc>
}
  801f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    
	assert(size < 1600);
  801f57:	68 cb 29 80 00       	push   $0x8029cb
  801f5c:	68 4c 29 80 00       	push   $0x80294c
  801f61:	6a 6d                	push   $0x6d
  801f63:	68 bf 29 80 00       	push   $0x8029bf
  801f68:	e8 c7 e2 ff ff       	call   800234 <_panic>

00801f6d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7e:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f83:	8b 45 10             	mov    0x10(%ebp),%eax
  801f86:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f8b:	b8 09 00 00 00       	mov    $0x9,%eax
  801f90:	e8 aa fd ff ff       	call   801d3f <nsipc>
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9f:	5d                   	pop    %ebp
  801fa0:	c3                   	ret    

00801fa1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fa7:	68 d7 29 80 00       	push   $0x8029d7
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	e8 f8 e9 ff ff       	call   8009ac <strcpy>
	return 0;
}
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <devcons_write>:
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	57                   	push   %edi
  801fbf:	56                   	push   %esi
  801fc0:	53                   	push   %ebx
  801fc1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fc7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fcc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd2:	eb 2f                	jmp    802003 <devcons_write+0x48>
		m = n - tot;
  801fd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fd7:	29 f3                	sub    %esi,%ebx
  801fd9:	83 fb 7f             	cmp    $0x7f,%ebx
  801fdc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fe4:	83 ec 04             	sub    $0x4,%esp
  801fe7:	53                   	push   %ebx
  801fe8:	89 f0                	mov    %esi,%eax
  801fea:	03 45 0c             	add    0xc(%ebp),%eax
  801fed:	50                   	push   %eax
  801fee:	57                   	push   %edi
  801fef:	e8 46 eb ff ff       	call   800b3a <memmove>
		sys_cputs(buf, m);
  801ff4:	83 c4 08             	add    $0x8,%esp
  801ff7:	53                   	push   %ebx
  801ff8:	57                   	push   %edi
  801ff9:	e8 eb ec ff ff       	call   800ce9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ffe:	01 de                	add    %ebx,%esi
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	3b 75 10             	cmp    0x10(%ebp),%esi
  802006:	72 cc                	jb     801fd4 <devcons_write+0x19>
}
  802008:	89 f0                	mov    %esi,%eax
  80200a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200d:	5b                   	pop    %ebx
  80200e:	5e                   	pop    %esi
  80200f:	5f                   	pop    %edi
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    

00802012 <devcons_read>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 08             	sub    $0x8,%esp
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80201d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802021:	75 07                	jne    80202a <devcons_read+0x18>
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    
		sys_yield();
  802025:	e8 5c ed ff ff       	call   800d86 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80202a:	e8 d8 ec ff ff       	call   800d07 <sys_cgetc>
  80202f:	85 c0                	test   %eax,%eax
  802031:	74 f2                	je     802025 <devcons_read+0x13>
	if (c < 0)
  802033:	85 c0                	test   %eax,%eax
  802035:	78 ec                	js     802023 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802037:	83 f8 04             	cmp    $0x4,%eax
  80203a:	74 0c                	je     802048 <devcons_read+0x36>
	*(char*)vbuf = c;
  80203c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203f:	88 02                	mov    %al,(%edx)
	return 1;
  802041:	b8 01 00 00 00       	mov    $0x1,%eax
  802046:	eb db                	jmp    802023 <devcons_read+0x11>
		return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	eb d4                	jmp    802023 <devcons_read+0x11>

0080204f <cputchar>:
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80205b:	6a 01                	push   $0x1
  80205d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802060:	50                   	push   %eax
  802061:	e8 83 ec ff ff       	call   800ce9 <sys_cputs>
}
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <getchar>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802071:	6a 01                	push   $0x1
  802073:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802076:	50                   	push   %eax
  802077:	6a 00                	push   $0x0
  802079:	e8 1e f2 ff ff       	call   80129c <read>
	if (r < 0)
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	85 c0                	test   %eax,%eax
  802083:	78 08                	js     80208d <getchar+0x22>
	if (r < 1)
  802085:	85 c0                	test   %eax,%eax
  802087:	7e 06                	jle    80208f <getchar+0x24>
	return c;
  802089:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    
		return -E_EOF;
  80208f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802094:	eb f7                	jmp    80208d <getchar+0x22>

00802096 <iscons>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	ff 75 08             	pushl  0x8(%ebp)
  8020a3:	e8 83 ef ff ff       	call   80102b <fd_lookup>
  8020a8:	83 c4 10             	add    $0x10,%esp
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 11                	js     8020c0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020b8:	39 10                	cmp    %edx,(%eax)
  8020ba:	0f 94 c0             	sete   %al
  8020bd:	0f b6 c0             	movzbl %al,%eax
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <opencons>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cb:	50                   	push   %eax
  8020cc:	e8 0b ef ff ff       	call   800fdc <fd_alloc>
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	78 3a                	js     802112 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	68 07 04 00 00       	push   $0x407
  8020e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e3:	6a 00                	push   $0x0
  8020e5:	e8 bb ec ff ff       	call   800da5 <sys_page_alloc>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 21                	js     802112 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	50                   	push   %eax
  80210a:	e8 a6 ee ff ff       	call   800fb5 <fd2num>
  80210f:	83 c4 10             	add    $0x10,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	56                   	push   %esi
  802118:	53                   	push   %ebx
  802119:	8b 75 08             	mov    0x8(%ebp),%esi
  80211c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802122:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802124:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802129:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80212c:	83 ec 0c             	sub    $0xc,%esp
  80212f:	50                   	push   %eax
  802130:	e8 20 ee ff ff       	call   800f55 <sys_ipc_recv>
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 2b                	js     802167 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80213c:	85 f6                	test   %esi,%esi
  80213e:	74 0a                	je     80214a <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802140:	a1 08 40 80 00       	mov    0x804008,%eax
  802145:	8b 40 74             	mov    0x74(%eax),%eax
  802148:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80214a:	85 db                	test   %ebx,%ebx
  80214c:	74 0a                	je     802158 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80214e:	a1 08 40 80 00       	mov    0x804008,%eax
  802153:	8b 40 78             	mov    0x78(%eax),%eax
  802156:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802158:	a1 08 40 80 00       	mov    0x804008,%eax
  80215d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802160:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5d                   	pop    %ebp
  802166:	c3                   	ret    
	    if (from_env_store != NULL) {
  802167:	85 f6                	test   %esi,%esi
  802169:	74 06                	je     802171 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80216b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802171:	85 db                	test   %ebx,%ebx
  802173:	74 eb                	je     802160 <ipc_recv+0x4c>
	        *perm_store = 0;
  802175:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80217b:	eb e3                	jmp    802160 <ipc_recv+0x4c>

0080217d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	57                   	push   %edi
  802181:	56                   	push   %esi
  802182:	53                   	push   %ebx
  802183:	83 ec 0c             	sub    $0xc,%esp
  802186:	8b 7d 08             	mov    0x8(%ebp),%edi
  802189:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80218c:	85 f6                	test   %esi,%esi
  80218e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802193:	0f 44 f0             	cmove  %eax,%esi
  802196:	eb 09                	jmp    8021a1 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802198:	e8 e9 eb ff ff       	call   800d86 <sys_yield>
	} while(r != 0);
  80219d:	85 db                	test   %ebx,%ebx
  80219f:	74 2d                	je     8021ce <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8021a1:	ff 75 14             	pushl  0x14(%ebp)
  8021a4:	56                   	push   %esi
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	57                   	push   %edi
  8021a9:	e8 84 ed ff ff       	call   800f32 <sys_ipc_try_send>
  8021ae:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	79 e1                	jns    802198 <ipc_send+0x1b>
  8021b7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021ba:	74 dc                	je     802198 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8021bc:	50                   	push   %eax
  8021bd:	68 e3 29 80 00       	push   $0x8029e3
  8021c2:	6a 45                	push   $0x45
  8021c4:	68 f0 29 80 00       	push   $0x8029f0
  8021c9:	e8 66 e0 ff ff       	call   800234 <_panic>
}
  8021ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5f                   	pop    %edi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021e1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021e4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021ea:	8b 52 50             	mov    0x50(%edx),%edx
  8021ed:	39 ca                	cmp    %ecx,%edx
  8021ef:	74 11                	je     802202 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8021f1:	83 c0 01             	add    $0x1,%eax
  8021f4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021f9:	75 e6                	jne    8021e1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	eb 0b                	jmp    80220d <ipc_find_env+0x37>
			return envs[i].env_id;
  802202:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802205:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80220a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80220d:	5d                   	pop    %ebp
  80220e:	c3                   	ret    

0080220f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802215:	89 d0                	mov    %edx,%eax
  802217:	c1 e8 16             	shr    $0x16,%eax
  80221a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802226:	f6 c1 01             	test   $0x1,%cl
  802229:	74 1d                	je     802248 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80222b:	c1 ea 0c             	shr    $0xc,%edx
  80222e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802235:	f6 c2 01             	test   $0x1,%dl
  802238:	74 0e                	je     802248 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80223a:	c1 ea 0c             	shr    $0xc,%edx
  80223d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802244:	ef 
  802245:	0f b7 c0             	movzwl %ax,%eax
}
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
  80224a:	66 90                	xchg   %ax,%ax
  80224c:	66 90                	xchg   %ax,%ax
  80224e:	66 90                	xchg   %ax,%ax

00802250 <__udivdi3>:
  802250:	55                   	push   %ebp
  802251:	57                   	push   %edi
  802252:	56                   	push   %esi
  802253:	53                   	push   %ebx
  802254:	83 ec 1c             	sub    $0x1c,%esp
  802257:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80225b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80225f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802263:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802267:	85 d2                	test   %edx,%edx
  802269:	75 35                	jne    8022a0 <__udivdi3+0x50>
  80226b:	39 f3                	cmp    %esi,%ebx
  80226d:	0f 87 bd 00 00 00    	ja     802330 <__udivdi3+0xe0>
  802273:	85 db                	test   %ebx,%ebx
  802275:	89 d9                	mov    %ebx,%ecx
  802277:	75 0b                	jne    802284 <__udivdi3+0x34>
  802279:	b8 01 00 00 00       	mov    $0x1,%eax
  80227e:	31 d2                	xor    %edx,%edx
  802280:	f7 f3                	div    %ebx
  802282:	89 c1                	mov    %eax,%ecx
  802284:	31 d2                	xor    %edx,%edx
  802286:	89 f0                	mov    %esi,%eax
  802288:	f7 f1                	div    %ecx
  80228a:	89 c6                	mov    %eax,%esi
  80228c:	89 e8                	mov    %ebp,%eax
  80228e:	89 f7                	mov    %esi,%edi
  802290:	f7 f1                	div    %ecx
  802292:	89 fa                	mov    %edi,%edx
  802294:	83 c4 1c             	add    $0x1c,%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    
  80229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	39 f2                	cmp    %esi,%edx
  8022a2:	77 7c                	ja     802320 <__udivdi3+0xd0>
  8022a4:	0f bd fa             	bsr    %edx,%edi
  8022a7:	83 f7 1f             	xor    $0x1f,%edi
  8022aa:	0f 84 98 00 00 00    	je     802348 <__udivdi3+0xf8>
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	d3 e6                	shl    %cl,%esi
  8022e1:	89 eb                	mov    %ebp,%ebx
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 0c                	jb     802307 <__udivdi3+0xb7>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 5d                	jae    802360 <__udivdi3+0x110>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	75 59                	jne    802360 <__udivdi3+0x110>
  802307:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80230a:	31 ff                	xor    %edi,%edi
  80230c:	89 fa                	mov    %edi,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d 76 00             	lea    0x0(%esi),%esi
  802319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802320:	31 ff                	xor    %edi,%edi
  802322:	31 c0                	xor    %eax,%eax
  802324:	89 fa                	mov    %edi,%edx
  802326:	83 c4 1c             	add    $0x1c,%esp
  802329:	5b                   	pop    %ebx
  80232a:	5e                   	pop    %esi
  80232b:	5f                   	pop    %edi
  80232c:	5d                   	pop    %ebp
  80232d:	c3                   	ret    
  80232e:	66 90                	xchg   %ax,%ax
  802330:	31 ff                	xor    %edi,%edi
  802332:	89 e8                	mov    %ebp,%eax
  802334:	89 f2                	mov    %esi,%edx
  802336:	f7 f3                	div    %ebx
  802338:	89 fa                	mov    %edi,%edx
  80233a:	83 c4 1c             	add    $0x1c,%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5f                   	pop    %edi
  802340:	5d                   	pop    %ebp
  802341:	c3                   	ret    
  802342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802348:	39 f2                	cmp    %esi,%edx
  80234a:	72 06                	jb     802352 <__udivdi3+0x102>
  80234c:	31 c0                	xor    %eax,%eax
  80234e:	39 eb                	cmp    %ebp,%ebx
  802350:	77 d2                	ja     802324 <__udivdi3+0xd4>
  802352:	b8 01 00 00 00       	mov    $0x1,%eax
  802357:	eb cb                	jmp    802324 <__udivdi3+0xd4>
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	89 d8                	mov    %ebx,%eax
  802362:	31 ff                	xor    %edi,%edi
  802364:	eb be                	jmp    802324 <__udivdi3+0xd4>
  802366:	66 90                	xchg   %ax,%ax
  802368:	66 90                	xchg   %ax,%ax
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <__umoddi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80237b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80237f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802387:	85 ed                	test   %ebp,%ebp
  802389:	89 f0                	mov    %esi,%eax
  80238b:	89 da                	mov    %ebx,%edx
  80238d:	75 19                	jne    8023a8 <__umoddi3+0x38>
  80238f:	39 df                	cmp    %ebx,%edi
  802391:	0f 86 b1 00 00 00    	jbe    802448 <__umoddi3+0xd8>
  802397:	f7 f7                	div    %edi
  802399:	89 d0                	mov    %edx,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	83 c4 1c             	add    $0x1c,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5f                   	pop    %edi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	39 dd                	cmp    %ebx,%ebp
  8023aa:	77 f1                	ja     80239d <__umoddi3+0x2d>
  8023ac:	0f bd cd             	bsr    %ebp,%ecx
  8023af:	83 f1 1f             	xor    $0x1f,%ecx
  8023b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023b6:	0f 84 b4 00 00 00    	je     802470 <__umoddi3+0x100>
  8023bc:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c1:	89 c2                	mov    %eax,%edx
  8023c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023c7:	29 c2                	sub    %eax,%edx
  8023c9:	89 c1                	mov    %eax,%ecx
  8023cb:	89 f8                	mov    %edi,%eax
  8023cd:	d3 e5                	shl    %cl,%ebp
  8023cf:	89 d1                	mov    %edx,%ecx
  8023d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023d5:	d3 e8                	shr    %cl,%eax
  8023d7:	09 c5                	or     %eax,%ebp
  8023d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023dd:	89 c1                	mov    %eax,%ecx
  8023df:	d3 e7                	shl    %cl,%edi
  8023e1:	89 d1                	mov    %edx,%ecx
  8023e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8023e7:	89 df                	mov    %ebx,%edi
  8023e9:	d3 ef                	shr    %cl,%edi
  8023eb:	89 c1                	mov    %eax,%ecx
  8023ed:	89 f0                	mov    %esi,%eax
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 d1                	mov    %edx,%ecx
  8023f3:	89 fa                	mov    %edi,%edx
  8023f5:	d3 e8                	shr    %cl,%eax
  8023f7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023fc:	09 d8                	or     %ebx,%eax
  8023fe:	f7 f5                	div    %ebp
  802400:	d3 e6                	shl    %cl,%esi
  802402:	89 d1                	mov    %edx,%ecx
  802404:	f7 64 24 08          	mull   0x8(%esp)
  802408:	39 d1                	cmp    %edx,%ecx
  80240a:	89 c3                	mov    %eax,%ebx
  80240c:	89 d7                	mov    %edx,%edi
  80240e:	72 06                	jb     802416 <__umoddi3+0xa6>
  802410:	75 0e                	jne    802420 <__umoddi3+0xb0>
  802412:	39 c6                	cmp    %eax,%esi
  802414:	73 0a                	jae    802420 <__umoddi3+0xb0>
  802416:	2b 44 24 08          	sub    0x8(%esp),%eax
  80241a:	19 ea                	sbb    %ebp,%edx
  80241c:	89 d7                	mov    %edx,%edi
  80241e:	89 c3                	mov    %eax,%ebx
  802420:	89 ca                	mov    %ecx,%edx
  802422:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802427:	29 de                	sub    %ebx,%esi
  802429:	19 fa                	sbb    %edi,%edx
  80242b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80242f:	89 d0                	mov    %edx,%eax
  802431:	d3 e0                	shl    %cl,%eax
  802433:	89 d9                	mov    %ebx,%ecx
  802435:	d3 ee                	shr    %cl,%esi
  802437:	d3 ea                	shr    %cl,%edx
  802439:	09 f0                	or     %esi,%eax
  80243b:	83 c4 1c             	add    $0x1c,%esp
  80243e:	5b                   	pop    %ebx
  80243f:	5e                   	pop    %esi
  802440:	5f                   	pop    %edi
  802441:	5d                   	pop    %ebp
  802442:	c3                   	ret    
  802443:	90                   	nop
  802444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802448:	85 ff                	test   %edi,%edi
  80244a:	89 f9                	mov    %edi,%ecx
  80244c:	75 0b                	jne    802459 <__umoddi3+0xe9>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f7                	div    %edi
  802457:	89 c1                	mov    %eax,%ecx
  802459:	89 d8                	mov    %ebx,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f1                	div    %ecx
  80245f:	89 f0                	mov    %esi,%eax
  802461:	f7 f1                	div    %ecx
  802463:	e9 31 ff ff ff       	jmp    802399 <__umoddi3+0x29>
  802468:	90                   	nop
  802469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802470:	39 dd                	cmp    %ebx,%ebp
  802472:	72 08                	jb     80247c <__umoddi3+0x10c>
  802474:	39 f7                	cmp    %esi,%edi
  802476:	0f 87 21 ff ff ff    	ja     80239d <__umoddi3+0x2d>
  80247c:	89 da                	mov    %ebx,%edx
  80247e:	89 f0                	mov    %esi,%eax
  802480:	29 f8                	sub    %edi,%eax
  802482:	19 ea                	sbb    %ebp,%edx
  802484:	e9 14 ff ff ff       	jmp    80239d <__umoddi3+0x2d>
