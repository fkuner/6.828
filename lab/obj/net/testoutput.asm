
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 a4 01 00 00       	call   8001d5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	envid_t ns_envid = sys_getenvid();
  800038:	e8 2b 0d 00 00       	call   800d68 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 30 80 00 60 	movl   $0x802860,0x803000
  800046:	28 80 00 

	output_envid = fork();
  800049:	e8 52 10 00 00       	call   8010a0 <fork>
  80004e:	a3 00 40 80 00       	mov    %eax,0x804000
	if (output_envid < 0)
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 95 00 00 00    	js     8000f0 <umain+0xbd>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80005b:	bb 00 00 00 00       	mov    $0x0,%ebx
	else if (output_envid == 0) {
  800060:	85 c0                	test   %eax,%eax
  800062:	0f 84 9c 00 00 00    	je     800104 <umain+0xd1>
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 07                	push   $0x7
  80006d:	68 00 b0 fe 0f       	push   $0xffeb000
  800072:	6a 00                	push   $0x0
  800074:	e8 2d 0d 00 00       	call   800da6 <sys_page_alloc>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 88 8e 00 00 00    	js     800112 <umain+0xdf>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800084:	53                   	push   %ebx
  800085:	68 9d 28 80 00       	push   $0x80289d
  80008a:	68 fc 0f 00 00       	push   $0xffc
  80008f:	68 04 b0 fe 0f       	push   $0xffeb004
  800094:	e8 c3 08 00 00       	call   80095c <snprintf>
  800099:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009e:	83 c4 08             	add    $0x8,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	68 a9 28 80 00       	push   $0x8028a9
  8000a7:	e8 64 02 00 00       	call   800310 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000ac:	6a 07                	push   $0x7
  8000ae:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b3:	6a 0b                	push   $0xb
  8000b5:	ff 35 00 40 80 00    	pushl  0x804000
  8000bb:	e8 8b 12 00 00       	call   80134b <ipc_send>
		sys_page_unmap(0, pkt);
  8000c0:	83 c4 18             	add    $0x18,%esp
  8000c3:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c8:	6a 00                	push   $0x0
  8000ca:	e8 5c 0d 00 00       	call   800e2b <sys_page_unmap>
	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000cf:	83 c3 01             	add    $0x1,%ebx
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	83 fb 0a             	cmp    $0xa,%ebx
  8000d8:	75 8e                	jne    800068 <umain+0x35>
  8000da:	bb 14 00 00 00       	mov    $0x14,%ebx
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  8000df:	e8 a3 0c 00 00       	call   800d87 <sys_yield>
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  8000e4:	83 eb 01             	sub    $0x1,%ebx
  8000e7:	75 f6                	jne    8000df <umain+0xac>
}
  8000e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5d                   	pop    %ebp
  8000ef:	c3                   	ret    
		panic("error forking");
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	68 6b 28 80 00       	push   $0x80286b
  8000f8:	6a 16                	push   $0x16
  8000fa:	68 79 28 80 00       	push   $0x802879
  8000ff:	e8 31 01 00 00       	call   800235 <_panic>
		output(ns_envid);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	56                   	push   %esi
  800108:	e8 b9 00 00 00       	call   8001c6 <output>
		return;
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb d7                	jmp    8000e9 <umain+0xb6>
			panic("sys_page_alloc: %e", r);
  800112:	50                   	push   %eax
  800113:	68 8a 28 80 00       	push   $0x80288a
  800118:	6a 1e                	push   $0x1e
  80011a:	68 79 28 80 00       	push   $0x802879
  80011f:	e8 11 01 00 00       	call   800235 <_panic>

00800124 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	57                   	push   %edi
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	83 ec 1c             	sub    $0x1c,%esp
  80012d:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  800130:	e8 62 0e 00 00       	call   800f97 <sys_time_msec>
  800135:	03 45 0c             	add    0xc(%ebp),%eax
  800138:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  80013a:	c7 05 00 30 80 00 c1 	movl   $0x8028c1,0x803000
  800141:	28 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800144:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800147:	eb 33                	jmp    80017c <timer+0x58>
		if (r < 0)
  800149:	85 c0                	test   %eax,%eax
  80014b:	78 45                	js     800192 <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  80014d:	6a 00                	push   $0x0
  80014f:	6a 00                	push   $0x0
  800151:	6a 0c                	push   $0xc
  800153:	56                   	push   %esi
  800154:	e8 f2 11 00 00       	call   80134b <ipc_send>
  800159:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	6a 00                	push   $0x0
  800161:	6a 00                	push   $0x0
  800163:	57                   	push   %edi
  800164:	e8 79 11 00 00       	call   8012e2 <ipc_recv>
  800169:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	39 f0                	cmp    %esi,%eax
  800173:	75 2f                	jne    8001a4 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800175:	e8 1d 0e 00 00       	call   800f97 <sys_time_msec>
  80017a:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017c:	e8 16 0e 00 00       	call   800f97 <sys_time_msec>
  800181:	89 c2                	mov    %eax,%edx
  800183:	85 c0                	test   %eax,%eax
  800185:	78 c2                	js     800149 <timer+0x25>
  800187:	39 d8                	cmp    %ebx,%eax
  800189:	73 be                	jae    800149 <timer+0x25>
			sys_yield();
  80018b:	e8 f7 0b 00 00       	call   800d87 <sys_yield>
  800190:	eb ea                	jmp    80017c <timer+0x58>
			panic("sys_time_msec: %e", r);
  800192:	52                   	push   %edx
  800193:	68 ca 28 80 00       	push   $0x8028ca
  800198:	6a 0f                	push   $0xf
  80019a:	68 dc 28 80 00       	push   $0x8028dc
  80019f:	e8 91 00 00 00       	call   800235 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	50                   	push   %eax
  8001a8:	68 e8 28 80 00       	push   $0x8028e8
  8001ad:	e8 5e 01 00 00       	call   800310 <cprintf>
				continue;
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	eb a5                	jmp    80015c <timer+0x38>

008001b7 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_input";
  8001ba:	c7 05 00 30 80 00 23 	movl   $0x802923,0x803000
  8001c1:	29 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    

008001c6 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_output";
  8001c9:	c7 05 00 30 80 00 2c 	movl   $0x80292c,0x803000
  8001d0:	29 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001dd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8001e0:	e8 83 0b 00 00       	call   800d68 <sys_getenvid>
  8001e5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f2:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f7:	85 db                	test   %ebx,%ebx
  8001f9:	7e 07                	jle    800202 <libmain+0x2d>
		binaryname = argv[0];
  8001fb:	8b 06                	mov    (%esi),%eax
  8001fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	e8 27 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80020c:	e8 0a 00 00 00       	call   80021b <exit>
}
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800217:	5b                   	pop    %ebx
  800218:	5e                   	pop    %esi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    

0080021b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800221:	e8 8d 13 00 00       	call   8015b3 <close_all>
	sys_env_destroy(0);
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	6a 00                	push   $0x0
  80022b:	e8 f7 0a 00 00       	call   800d27 <sys_env_destroy>
}
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	56                   	push   %esi
  800239:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80023a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800243:	e8 20 0b 00 00       	call   800d68 <sys_getenvid>
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 0c             	pushl  0xc(%ebp)
  80024e:	ff 75 08             	pushl  0x8(%ebp)
  800251:	56                   	push   %esi
  800252:	50                   	push   %eax
  800253:	68 40 29 80 00       	push   $0x802940
  800258:	e8 b3 00 00 00       	call   800310 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025d:	83 c4 18             	add    $0x18,%esp
  800260:	53                   	push   %ebx
  800261:	ff 75 10             	pushl  0x10(%ebp)
  800264:	e8 56 00 00 00       	call   8002bf <vcprintf>
	cprintf("\n");
  800269:	c7 04 24 bf 28 80 00 	movl   $0x8028bf,(%esp)
  800270:	e8 9b 00 00 00       	call   800310 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800278:	cc                   	int3   
  800279:	eb fd                	jmp    800278 <_panic+0x43>

0080027b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	53                   	push   %ebx
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800285:	8b 13                	mov    (%ebx),%edx
  800287:	8d 42 01             	lea    0x1(%edx),%eax
  80028a:	89 03                	mov    %eax,(%ebx)
  80028c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800293:	3d ff 00 00 00       	cmp    $0xff,%eax
  800298:	74 09                	je     8002a3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80029a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	68 ff 00 00 00       	push   $0xff
  8002ab:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ae:	50                   	push   %eax
  8002af:	e8 36 0a 00 00       	call   800cea <sys_cputs>
		b->idx = 0;
  8002b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	eb db                	jmp    80029a <putch+0x1f>

008002bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cf:	00 00 00 
	b.cnt = 0;
  8002d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002dc:	ff 75 0c             	pushl  0xc(%ebp)
  8002df:	ff 75 08             	pushl  0x8(%ebp)
  8002e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e8:	50                   	push   %eax
  8002e9:	68 7b 02 80 00       	push   $0x80027b
  8002ee:	e8 1a 01 00 00       	call   80040d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f3:	83 c4 08             	add    $0x8,%esp
  8002f6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002fc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	e8 e2 09 00 00       	call   800cea <sys_cputs>

	return b.cnt;
}
  800308:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800316:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800319:	50                   	push   %eax
  80031a:	ff 75 08             	pushl  0x8(%ebp)
  80031d:	e8 9d ff ff ff       	call   8002bf <vcprintf>
	va_end(ap);

	return cnt;
}
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	57                   	push   %edi
  800328:	56                   	push   %esi
  800329:	53                   	push   %ebx
  80032a:	83 ec 1c             	sub    $0x1c,%esp
  80032d:	89 c7                	mov    %eax,%edi
  80032f:	89 d6                	mov    %edx,%esi
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	8b 55 0c             	mov    0xc(%ebp),%edx
  800337:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800340:	bb 00 00 00 00       	mov    $0x0,%ebx
  800345:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800348:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80034b:	39 d3                	cmp    %edx,%ebx
  80034d:	72 05                	jb     800354 <printnum+0x30>
  80034f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800352:	77 7a                	ja     8003ce <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 18             	pushl  0x18(%ebp)
  80035a:	8b 45 14             	mov    0x14(%ebp),%eax
  80035d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800360:	53                   	push   %ebx
  800361:	ff 75 10             	pushl  0x10(%ebp)
  800364:	83 ec 08             	sub    $0x8,%esp
  800367:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036a:	ff 75 e0             	pushl  -0x20(%ebp)
  80036d:	ff 75 dc             	pushl  -0x24(%ebp)
  800370:	ff 75 d8             	pushl  -0x28(%ebp)
  800373:	e8 a8 22 00 00       	call   802620 <__udivdi3>
  800378:	83 c4 18             	add    $0x18,%esp
  80037b:	52                   	push   %edx
  80037c:	50                   	push   %eax
  80037d:	89 f2                	mov    %esi,%edx
  80037f:	89 f8                	mov    %edi,%eax
  800381:	e8 9e ff ff ff       	call   800324 <printnum>
  800386:	83 c4 20             	add    $0x20,%esp
  800389:	eb 13                	jmp    80039e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	56                   	push   %esi
  80038f:	ff 75 18             	pushl  0x18(%ebp)
  800392:	ff d7                	call   *%edi
  800394:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800397:	83 eb 01             	sub    $0x1,%ebx
  80039a:	85 db                	test   %ebx,%ebx
  80039c:	7f ed                	jg     80038b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	56                   	push   %esi
  8003a2:	83 ec 04             	sub    $0x4,%esp
  8003a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b1:	e8 8a 23 00 00       	call   802740 <__umoddi3>
  8003b6:	83 c4 14             	add    $0x14,%esp
  8003b9:	0f be 80 63 29 80 00 	movsbl 0x802963(%eax),%eax
  8003c0:	50                   	push   %eax
  8003c1:	ff d7                	call   *%edi
}
  8003c3:	83 c4 10             	add    $0x10,%esp
  8003c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c9:	5b                   	pop    %ebx
  8003ca:	5e                   	pop    %esi
  8003cb:	5f                   	pop    %edi
  8003cc:	5d                   	pop    %ebp
  8003cd:	c3                   	ret    
  8003ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003d1:	eb c4                	jmp    800397 <printnum+0x73>

008003d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003dd:	8b 10                	mov    (%eax),%edx
  8003df:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e2:	73 0a                	jae    8003ee <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e7:	89 08                	mov    %ecx,(%eax)
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	88 02                	mov    %al,(%edx)
}
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <printfmt>:
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f9:	50                   	push   %eax
  8003fa:	ff 75 10             	pushl  0x10(%ebp)
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 05 00 00 00       	call   80040d <vprintfmt>
}
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <vprintfmt>:
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	57                   	push   %edi
  800411:	56                   	push   %esi
  800412:	53                   	push   %ebx
  800413:	83 ec 2c             	sub    $0x2c,%esp
  800416:	8b 75 08             	mov    0x8(%ebp),%esi
  800419:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041f:	e9 21 04 00 00       	jmp    800845 <vprintfmt+0x438>
		padc = ' ';
  800424:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800428:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800436:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8d 47 01             	lea    0x1(%edi),%eax
  800445:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800448:	0f b6 17             	movzbl (%edi),%edx
  80044b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044e:	3c 55                	cmp    $0x55,%al
  800450:	0f 87 90 04 00 00    	ja     8008e6 <vprintfmt+0x4d9>
  800456:	0f b6 c0             	movzbl %al,%eax
  800459:	ff 24 85 a0 2a 80 00 	jmp    *0x802aa0(,%eax,4)
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800463:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800467:	eb d9                	jmp    800442 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80046c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800470:	eb d0                	jmp    800442 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800472:	0f b6 d2             	movzbl %dl,%edx
  800475:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800480:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800483:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800487:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80048a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048d:	83 f9 09             	cmp    $0x9,%ecx
  800490:	77 55                	ja     8004e7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800492:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800495:	eb e9                	jmp    800480 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	8d 40 04             	lea    0x4(%eax),%eax
  8004a5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004af:	79 91                	jns    800442 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004be:	eb 82                	jmp    800442 <vprintfmt+0x35>
  8004c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ca:	0f 49 d0             	cmovns %eax,%edx
  8004cd:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d3:	e9 6a ff ff ff       	jmp    800442 <vprintfmt+0x35>
  8004d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004db:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e2:	e9 5b ff ff ff       	jmp    800442 <vprintfmt+0x35>
  8004e7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ed:	eb bc                	jmp    8004ab <vprintfmt+0x9e>
			lflag++;
  8004ef:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f5:	e9 48 ff ff ff       	jmp    800442 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	8d 78 04             	lea    0x4(%eax),%edi
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	ff 30                	pushl  (%eax)
  800506:	ff d6                	call   *%esi
			break;
  800508:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050e:	e9 2f 03 00 00       	jmp    800842 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8d 78 04             	lea    0x4(%eax),%edi
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	99                   	cltd   
  80051c:	31 d0                	xor    %edx,%eax
  80051e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800520:	83 f8 0f             	cmp    $0xf,%eax
  800523:	7f 23                	jg     800548 <vprintfmt+0x13b>
  800525:	8b 14 85 00 2c 80 00 	mov    0x802c00(,%eax,4),%edx
  80052c:	85 d2                	test   %edx,%edx
  80052e:	74 18                	je     800548 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800530:	52                   	push   %edx
  800531:	68 da 2d 80 00       	push   $0x802dda
  800536:	53                   	push   %ebx
  800537:	56                   	push   %esi
  800538:	e8 b3 fe ff ff       	call   8003f0 <printfmt>
  80053d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800540:	89 7d 14             	mov    %edi,0x14(%ebp)
  800543:	e9 fa 02 00 00       	jmp    800842 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800548:	50                   	push   %eax
  800549:	68 7b 29 80 00       	push   $0x80297b
  80054e:	53                   	push   %ebx
  80054f:	56                   	push   %esi
  800550:	e8 9b fe ff ff       	call   8003f0 <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800558:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80055b:	e9 e2 02 00 00       	jmp    800842 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	83 c0 04             	add    $0x4,%eax
  800566:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056e:	85 ff                	test   %edi,%edi
  800570:	b8 74 29 80 00       	mov    $0x802974,%eax
  800575:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800578:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057c:	0f 8e bd 00 00 00    	jle    80063f <vprintfmt+0x232>
  800582:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800586:	75 0e                	jne    800596 <vprintfmt+0x189>
  800588:	89 75 08             	mov    %esi,0x8(%ebp)
  80058b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800591:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800594:	eb 6d                	jmp    800603 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 d0             	pushl  -0x30(%ebp)
  80059c:	57                   	push   %edi
  80059d:	e8 ec 03 00 00       	call   80098e <strnlen>
  8005a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a5:	29 c1                	sub    %eax,%ecx
  8005a7:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005aa:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005ad:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b7:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b9:	eb 0f                	jmp    8005ca <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c4:	83 ef 01             	sub    $0x1,%edi
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	85 ff                	test   %edi,%edi
  8005cc:	7f ed                	jg     8005bb <vprintfmt+0x1ae>
  8005ce:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005d1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d4:	85 c9                	test   %ecx,%ecx
  8005d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005db:	0f 49 c1             	cmovns %ecx,%eax
  8005de:	29 c1                	sub    %eax,%ecx
  8005e0:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e9:	89 cb                	mov    %ecx,%ebx
  8005eb:	eb 16                	jmp    800603 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f1:	75 31                	jne    800624 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	ff 55 08             	call   *0x8(%ebp)
  8005fd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800600:	83 eb 01             	sub    $0x1,%ebx
  800603:	83 c7 01             	add    $0x1,%edi
  800606:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80060a:	0f be c2             	movsbl %dl,%eax
  80060d:	85 c0                	test   %eax,%eax
  80060f:	74 59                	je     80066a <vprintfmt+0x25d>
  800611:	85 f6                	test   %esi,%esi
  800613:	78 d8                	js     8005ed <vprintfmt+0x1e0>
  800615:	83 ee 01             	sub    $0x1,%esi
  800618:	79 d3                	jns    8005ed <vprintfmt+0x1e0>
  80061a:	89 df                	mov    %ebx,%edi
  80061c:	8b 75 08             	mov    0x8(%ebp),%esi
  80061f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800622:	eb 37                	jmp    80065b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800624:	0f be d2             	movsbl %dl,%edx
  800627:	83 ea 20             	sub    $0x20,%edx
  80062a:	83 fa 5e             	cmp    $0x5e,%edx
  80062d:	76 c4                	jbe    8005f3 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	ff 75 0c             	pushl  0xc(%ebp)
  800635:	6a 3f                	push   $0x3f
  800637:	ff 55 08             	call   *0x8(%ebp)
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	eb c1                	jmp    800600 <vprintfmt+0x1f3>
  80063f:	89 75 08             	mov    %esi,0x8(%ebp)
  800642:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800645:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800648:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80064b:	eb b6                	jmp    800603 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	53                   	push   %ebx
  800651:	6a 20                	push   $0x20
  800653:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800655:	83 ef 01             	sub    $0x1,%edi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	85 ff                	test   %edi,%edi
  80065d:	7f ee                	jg     80064d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	e9 d8 01 00 00       	jmp    800842 <vprintfmt+0x435>
  80066a:	89 df                	mov    %ebx,%edi
  80066c:	8b 75 08             	mov    0x8(%ebp),%esi
  80066f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800672:	eb e7                	jmp    80065b <vprintfmt+0x24e>
	if (lflag >= 2)
  800674:	83 f9 01             	cmp    $0x1,%ecx
  800677:	7e 45                	jle    8006be <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 50 04             	mov    0x4(%eax),%edx
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 08             	lea    0x8(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800690:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800694:	79 62                	jns    8006f8 <vprintfmt+0x2eb>
				putch('-', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 2d                	push   $0x2d
  80069c:	ff d6                	call   *%esi
				num = -(long long) num;
  80069e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006a4:	f7 d8                	neg    %eax
  8006a6:	83 d2 00             	adc    $0x0,%edx
  8006a9:	f7 da                	neg    %edx
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006b9:	e9 66 01 00 00       	jmp    800824 <vprintfmt+0x417>
	else if (lflag)
  8006be:	85 c9                	test   %ecx,%ecx
  8006c0:	75 1b                	jne    8006dd <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006cf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006db:	eb b3                	jmp    800690 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e5:	89 c1                	mov    %eax,%ecx
  8006e7:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8d 40 04             	lea    0x4(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f6:	eb 98                	jmp    800690 <vprintfmt+0x283>
			base = 10;
  8006f8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006fd:	e9 22 01 00 00       	jmp    800824 <vprintfmt+0x417>
	if (lflag >= 2)
  800702:	83 f9 01             	cmp    $0x1,%ecx
  800705:	7e 21                	jle    800728 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800712:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 40 08             	lea    0x8(%eax),%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800723:	e9 fc 00 00 00       	jmp    800824 <vprintfmt+0x417>
	else if (lflag)
  800728:	85 c9                	test   %ecx,%ecx
  80072a:	75 23                	jne    80074f <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800745:	ba 0a 00 00 00       	mov    $0xa,%edx
  80074a:	e9 d5 00 00 00       	jmp    800824 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	ba 00 00 00 00       	mov    $0x0,%edx
  800759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800768:	ba 0a 00 00 00       	mov    $0xa,%edx
  80076d:	e9 b2 00 00 00       	jmp    800824 <vprintfmt+0x417>
	if (lflag >= 2)
  800772:	83 f9 01             	cmp    $0x1,%ecx
  800775:	7e 42                	jle    8007b9 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 50 04             	mov    0x4(%eax),%edx
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800782:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 40 08             	lea    0x8(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078e:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800793:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800797:	0f 89 87 00 00 00    	jns    800824 <vprintfmt+0x417>
				putch('-', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	53                   	push   %ebx
  8007a1:	6a 2d                	push   $0x2d
  8007a3:	ff d6                	call   *%esi
				num = -(long long) num;
  8007a5:	f7 5d d8             	negl   -0x28(%ebp)
  8007a8:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8007ac:	f7 5d dc             	negl   -0x24(%ebp)
  8007af:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007b2:	ba 08 00 00 00       	mov    $0x8,%edx
  8007b7:	eb 6b                	jmp    800824 <vprintfmt+0x417>
	else if (lflag)
  8007b9:	85 c9                	test   %ecx,%ecx
  8007bb:	75 1b                	jne    8007d8 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d6:	eb b6                	jmp    80078e <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	eb 9b                	jmp    80078e <vprintfmt+0x381>
			putch('0', putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	53                   	push   %ebx
  8007f7:	6a 30                	push   $0x30
  8007f9:	ff d6                	call   *%esi
			putch('x', putdat);
  8007fb:	83 c4 08             	add    $0x8,%esp
  8007fe:	53                   	push   %ebx
  8007ff:	6a 78                	push   $0x78
  800801:	ff d6                	call   *%esi
			num = (unsigned long long)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
  80080d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800810:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800813:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8d 40 04             	lea    0x4(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081f:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800824:	83 ec 0c             	sub    $0xc,%esp
  800827:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80082b:	50                   	push   %eax
  80082c:	ff 75 e0             	pushl  -0x20(%ebp)
  80082f:	52                   	push   %edx
  800830:	ff 75 dc             	pushl  -0x24(%ebp)
  800833:	ff 75 d8             	pushl  -0x28(%ebp)
  800836:	89 da                	mov    %ebx,%edx
  800838:	89 f0                	mov    %esi,%eax
  80083a:	e8 e5 fa ff ff       	call   800324 <printnum>
			break;
  80083f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800842:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800845:	83 c7 01             	add    $0x1,%edi
  800848:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80084c:	83 f8 25             	cmp    $0x25,%eax
  80084f:	0f 84 cf fb ff ff    	je     800424 <vprintfmt+0x17>
			if (ch == '\0')
  800855:	85 c0                	test   %eax,%eax
  800857:	0f 84 a9 00 00 00    	je     800906 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	50                   	push   %eax
  800862:	ff d6                	call   *%esi
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	eb dc                	jmp    800845 <vprintfmt+0x438>
	if (lflag >= 2)
  800869:	83 f9 01             	cmp    $0x1,%ecx
  80086c:	7e 1e                	jle    80088c <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8b 50 04             	mov    0x4(%eax),%edx
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800879:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8d 40 08             	lea    0x8(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800885:	ba 10 00 00 00       	mov    $0x10,%edx
  80088a:	eb 98                	jmp    800824 <vprintfmt+0x417>
	else if (lflag)
  80088c:	85 c9                	test   %ecx,%ecx
  80088e:	75 23                	jne    8008b3 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	ba 00 00 00 00       	mov    $0x0,%edx
  80089a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8d 40 04             	lea    0x4(%eax),%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a9:	ba 10 00 00 00       	mov    $0x10,%edx
  8008ae:	e9 71 ff ff ff       	jmp    800824 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 04             	lea    0x4(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cc:	ba 10 00 00 00       	mov    $0x10,%edx
  8008d1:	e9 4e ff ff ff       	jmp    800824 <vprintfmt+0x417>
			putch(ch, putdat);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	53                   	push   %ebx
  8008da:	6a 25                	push   $0x25
  8008dc:	ff d6                	call   *%esi
			break;
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	e9 5c ff ff ff       	jmp    800842 <vprintfmt+0x435>
			putch('%', putdat);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	53                   	push   %ebx
  8008ea:	6a 25                	push   $0x25
  8008ec:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 f8                	mov    %edi,%eax
  8008f3:	eb 03                	jmp    8008f8 <vprintfmt+0x4eb>
  8008f5:	83 e8 01             	sub    $0x1,%eax
  8008f8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008fc:	75 f7                	jne    8008f5 <vprintfmt+0x4e8>
  8008fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800901:	e9 3c ff ff ff       	jmp    800842 <vprintfmt+0x435>
}
  800906:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800909:	5b                   	pop    %ebx
  80090a:	5e                   	pop    %esi
  80090b:	5f                   	pop    %edi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 18             	sub    $0x18,%esp
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80091a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800921:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80092b:	85 c0                	test   %eax,%eax
  80092d:	74 26                	je     800955 <vsnprintf+0x47>
  80092f:	85 d2                	test   %edx,%edx
  800931:	7e 22                	jle    800955 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800933:	ff 75 14             	pushl  0x14(%ebp)
  800936:	ff 75 10             	pushl  0x10(%ebp)
  800939:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80093c:	50                   	push   %eax
  80093d:	68 d3 03 80 00       	push   $0x8003d3
  800942:	e8 c6 fa ff ff       	call   80040d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800950:	83 c4 10             	add    $0x10,%esp
}
  800953:	c9                   	leave  
  800954:	c3                   	ret    
		return -E_INVAL;
  800955:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80095a:	eb f7                	jmp    800953 <vsnprintf+0x45>

0080095c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800962:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800965:	50                   	push   %eax
  800966:	ff 75 10             	pushl  0x10(%ebp)
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	ff 75 08             	pushl  0x8(%ebp)
  80096f:	e8 9a ff ff ff       	call   80090e <vsnprintf>
	va_end(ap);

	return rc;
}
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
  800981:	eb 03                	jmp    800986 <strlen+0x10>
		n++;
  800983:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800986:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80098a:	75 f7                	jne    800983 <strlen+0xd>
	return n;
}
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800997:	b8 00 00 00 00       	mov    $0x0,%eax
  80099c:	eb 03                	jmp    8009a1 <strnlen+0x13>
		n++;
  80099e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a1:	39 d0                	cmp    %edx,%eax
  8009a3:	74 06                	je     8009ab <strnlen+0x1d>
  8009a5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a9:	75 f3                	jne    80099e <strnlen+0x10>
	return n;
}
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b7:	89 c2                	mov    %eax,%edx
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009c3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c6:	84 db                	test   %bl,%bl
  8009c8:	75 ef                	jne    8009b9 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009ca:	5b                   	pop    %ebx
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    

008009cd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	53                   	push   %ebx
  8009d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d4:	53                   	push   %ebx
  8009d5:	e8 9c ff ff ff       	call   800976 <strlen>
  8009da:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	01 d8                	add    %ebx,%eax
  8009e2:	50                   	push   %eax
  8009e3:	e8 c5 ff ff ff       	call   8009ad <strcpy>
	return dst;
}
  8009e8:	89 d8                	mov    %ebx,%eax
  8009ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fa:	89 f3                	mov    %esi,%ebx
  8009fc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ff:	89 f2                	mov    %esi,%edx
  800a01:	eb 0f                	jmp    800a12 <strncpy+0x23>
		*dst++ = *src;
  800a03:	83 c2 01             	add    $0x1,%edx
  800a06:	0f b6 01             	movzbl (%ecx),%eax
  800a09:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a0c:	80 39 01             	cmpb   $0x1,(%ecx)
  800a0f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a12:	39 da                	cmp    %ebx,%edx
  800a14:	75 ed                	jne    800a03 <strncpy+0x14>
	}
	return ret;
}
  800a16:	89 f0                	mov    %esi,%eax
  800a18:	5b                   	pop    %ebx
  800a19:	5e                   	pop    %esi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	56                   	push   %esi
  800a20:	53                   	push   %ebx
  800a21:	8b 75 08             	mov    0x8(%ebp),%esi
  800a24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a2a:	89 f0                	mov    %esi,%eax
  800a2c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a30:	85 c9                	test   %ecx,%ecx
  800a32:	75 0b                	jne    800a3f <strlcpy+0x23>
  800a34:	eb 17                	jmp    800a4d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a36:	83 c2 01             	add    $0x1,%edx
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a3f:	39 d8                	cmp    %ebx,%eax
  800a41:	74 07                	je     800a4a <strlcpy+0x2e>
  800a43:	0f b6 0a             	movzbl (%edx),%ecx
  800a46:	84 c9                	test   %cl,%cl
  800a48:	75 ec                	jne    800a36 <strlcpy+0x1a>
		*dst = '\0';
  800a4a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4d:	29 f0                	sub    %esi,%eax
}
  800a4f:	5b                   	pop    %ebx
  800a50:	5e                   	pop    %esi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a5c:	eb 06                	jmp    800a64 <strcmp+0x11>
		p++, q++;
  800a5e:	83 c1 01             	add    $0x1,%ecx
  800a61:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a64:	0f b6 01             	movzbl (%ecx),%eax
  800a67:	84 c0                	test   %al,%al
  800a69:	74 04                	je     800a6f <strcmp+0x1c>
  800a6b:	3a 02                	cmp    (%edx),%al
  800a6d:	74 ef                	je     800a5e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6f:	0f b6 c0             	movzbl %al,%eax
  800a72:	0f b6 12             	movzbl (%edx),%edx
  800a75:	29 d0                	sub    %edx,%eax
}
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	53                   	push   %ebx
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a83:	89 c3                	mov    %eax,%ebx
  800a85:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a88:	eb 06                	jmp    800a90 <strncmp+0x17>
		n--, p++, q++;
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a90:	39 d8                	cmp    %ebx,%eax
  800a92:	74 16                	je     800aaa <strncmp+0x31>
  800a94:	0f b6 08             	movzbl (%eax),%ecx
  800a97:	84 c9                	test   %cl,%cl
  800a99:	74 04                	je     800a9f <strncmp+0x26>
  800a9b:	3a 0a                	cmp    (%edx),%cl
  800a9d:	74 eb                	je     800a8a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9f:	0f b6 00             	movzbl (%eax),%eax
  800aa2:	0f b6 12             	movzbl (%edx),%edx
  800aa5:	29 d0                	sub    %edx,%eax
}
  800aa7:	5b                   	pop    %ebx
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    
		return 0;
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaf:	eb f6                	jmp    800aa7 <strncmp+0x2e>

00800ab1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800abb:	0f b6 10             	movzbl (%eax),%edx
  800abe:	84 d2                	test   %dl,%dl
  800ac0:	74 09                	je     800acb <strchr+0x1a>
		if (*s == c)
  800ac2:	38 ca                	cmp    %cl,%dl
  800ac4:	74 0a                	je     800ad0 <strchr+0x1f>
	for (; *s; s++)
  800ac6:	83 c0 01             	add    $0x1,%eax
  800ac9:	eb f0                	jmp    800abb <strchr+0xa>
			return (char *) s;
	return 0;
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800adc:	eb 03                	jmp    800ae1 <strfind+0xf>
  800ade:	83 c0 01             	add    $0x1,%eax
  800ae1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ae4:	38 ca                	cmp    %cl,%dl
  800ae6:	74 04                	je     800aec <strfind+0x1a>
  800ae8:	84 d2                	test   %dl,%dl
  800aea:	75 f2                	jne    800ade <strfind+0xc>
			break;
	return (char *) s;
}
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800afa:	85 c9                	test   %ecx,%ecx
  800afc:	74 13                	je     800b11 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800afe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b04:	75 05                	jne    800b0b <memset+0x1d>
  800b06:	f6 c1 03             	test   $0x3,%cl
  800b09:	74 0d                	je     800b18 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	fc                   	cld    
  800b0f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b11:	89 f8                	mov    %edi,%eax
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    
		c &= 0xFF;
  800b18:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1c:	89 d3                	mov    %edx,%ebx
  800b1e:	c1 e3 08             	shl    $0x8,%ebx
  800b21:	89 d0                	mov    %edx,%eax
  800b23:	c1 e0 18             	shl    $0x18,%eax
  800b26:	89 d6                	mov    %edx,%esi
  800b28:	c1 e6 10             	shl    $0x10,%esi
  800b2b:	09 f0                	or     %esi,%eax
  800b2d:	09 c2                	or     %eax,%edx
  800b2f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b31:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b34:	89 d0                	mov    %edx,%eax
  800b36:	fc                   	cld    
  800b37:	f3 ab                	rep stos %eax,%es:(%edi)
  800b39:	eb d6                	jmp    800b11 <memset+0x23>

00800b3b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	57                   	push   %edi
  800b3f:	56                   	push   %esi
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b49:	39 c6                	cmp    %eax,%esi
  800b4b:	73 35                	jae    800b82 <memmove+0x47>
  800b4d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b50:	39 c2                	cmp    %eax,%edx
  800b52:	76 2e                	jbe    800b82 <memmove+0x47>
		s += n;
		d += n;
  800b54:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b57:	89 d6                	mov    %edx,%esi
  800b59:	09 fe                	or     %edi,%esi
  800b5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b61:	74 0c                	je     800b6f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b63:	83 ef 01             	sub    $0x1,%edi
  800b66:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b69:	fd                   	std    
  800b6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6c:	fc                   	cld    
  800b6d:	eb 21                	jmp    800b90 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6f:	f6 c1 03             	test   $0x3,%cl
  800b72:	75 ef                	jne    800b63 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b74:	83 ef 04             	sub    $0x4,%edi
  800b77:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7d:	fd                   	std    
  800b7e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b80:	eb ea                	jmp    800b6c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b82:	89 f2                	mov    %esi,%edx
  800b84:	09 c2                	or     %eax,%edx
  800b86:	f6 c2 03             	test   $0x3,%dl
  800b89:	74 09                	je     800b94 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b8b:	89 c7                	mov    %eax,%edi
  800b8d:	fc                   	cld    
  800b8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b94:	f6 c1 03             	test   $0x3,%cl
  800b97:	75 f2                	jne    800b8b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	fc                   	cld    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb ed                	jmp    800b90 <memmove+0x55>

00800ba3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ba6:	ff 75 10             	pushl  0x10(%ebp)
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	ff 75 08             	pushl  0x8(%ebp)
  800baf:	e8 87 ff ff ff       	call   800b3b <memmove>
}
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	56                   	push   %esi
  800bba:	53                   	push   %ebx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc1:	89 c6                	mov    %eax,%esi
  800bc3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc6:	39 f0                	cmp    %esi,%eax
  800bc8:	74 1c                	je     800be6 <memcmp+0x30>
		if (*s1 != *s2)
  800bca:	0f b6 08             	movzbl (%eax),%ecx
  800bcd:	0f b6 1a             	movzbl (%edx),%ebx
  800bd0:	38 d9                	cmp    %bl,%cl
  800bd2:	75 08                	jne    800bdc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bd4:	83 c0 01             	add    $0x1,%eax
  800bd7:	83 c2 01             	add    $0x1,%edx
  800bda:	eb ea                	jmp    800bc6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bdc:	0f b6 c1             	movzbl %cl,%eax
  800bdf:	0f b6 db             	movzbl %bl,%ebx
  800be2:	29 d8                	sub    %ebx,%eax
  800be4:	eb 05                	jmp    800beb <memcmp+0x35>
	}

	return 0;
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bf8:	89 c2                	mov    %eax,%edx
  800bfa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bfd:	39 d0                	cmp    %edx,%eax
  800bff:	73 09                	jae    800c0a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c01:	38 08                	cmp    %cl,(%eax)
  800c03:	74 05                	je     800c0a <memfind+0x1b>
	for (; s < ends; s++)
  800c05:	83 c0 01             	add    $0x1,%eax
  800c08:	eb f3                	jmp    800bfd <memfind+0xe>
			break;
	return (void *) s;
}
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c18:	eb 03                	jmp    800c1d <strtol+0x11>
		s++;
  800c1a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c1d:	0f b6 01             	movzbl (%ecx),%eax
  800c20:	3c 20                	cmp    $0x20,%al
  800c22:	74 f6                	je     800c1a <strtol+0xe>
  800c24:	3c 09                	cmp    $0x9,%al
  800c26:	74 f2                	je     800c1a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c28:	3c 2b                	cmp    $0x2b,%al
  800c2a:	74 2e                	je     800c5a <strtol+0x4e>
	int neg = 0;
  800c2c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c31:	3c 2d                	cmp    $0x2d,%al
  800c33:	74 2f                	je     800c64 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c35:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c3b:	75 05                	jne    800c42 <strtol+0x36>
  800c3d:	80 39 30             	cmpb   $0x30,(%ecx)
  800c40:	74 2c                	je     800c6e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c42:	85 db                	test   %ebx,%ebx
  800c44:	75 0a                	jne    800c50 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c46:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c4e:	74 28                	je     800c78 <strtol+0x6c>
		base = 10;
  800c50:	b8 00 00 00 00       	mov    $0x0,%eax
  800c55:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c58:	eb 50                	jmp    800caa <strtol+0x9e>
		s++;
  800c5a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c5d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c62:	eb d1                	jmp    800c35 <strtol+0x29>
		s++, neg = 1;
  800c64:	83 c1 01             	add    $0x1,%ecx
  800c67:	bf 01 00 00 00       	mov    $0x1,%edi
  800c6c:	eb c7                	jmp    800c35 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c72:	74 0e                	je     800c82 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c74:	85 db                	test   %ebx,%ebx
  800c76:	75 d8                	jne    800c50 <strtol+0x44>
		s++, base = 8;
  800c78:	83 c1 01             	add    $0x1,%ecx
  800c7b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c80:	eb ce                	jmp    800c50 <strtol+0x44>
		s += 2, base = 16;
  800c82:	83 c1 02             	add    $0x2,%ecx
  800c85:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c8a:	eb c4                	jmp    800c50 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c8c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c8f:	89 f3                	mov    %esi,%ebx
  800c91:	80 fb 19             	cmp    $0x19,%bl
  800c94:	77 29                	ja     800cbf <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c96:	0f be d2             	movsbl %dl,%edx
  800c99:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c9c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c9f:	7d 30                	jge    800cd1 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ca1:	83 c1 01             	add    $0x1,%ecx
  800ca4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ca8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800caa:	0f b6 11             	movzbl (%ecx),%edx
  800cad:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cb0:	89 f3                	mov    %esi,%ebx
  800cb2:	80 fb 09             	cmp    $0x9,%bl
  800cb5:	77 d5                	ja     800c8c <strtol+0x80>
			dig = *s - '0';
  800cb7:	0f be d2             	movsbl %dl,%edx
  800cba:	83 ea 30             	sub    $0x30,%edx
  800cbd:	eb dd                	jmp    800c9c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800cbf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cc2:	89 f3                	mov    %esi,%ebx
  800cc4:	80 fb 19             	cmp    $0x19,%bl
  800cc7:	77 08                	ja     800cd1 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800cc9:	0f be d2             	movsbl %dl,%edx
  800ccc:	83 ea 37             	sub    $0x37,%edx
  800ccf:	eb cb                	jmp    800c9c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd5:	74 05                	je     800cdc <strtol+0xd0>
		*endptr = (char *) s;
  800cd7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cda:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cdc:	89 c2                	mov    %eax,%edx
  800cde:	f7 da                	neg    %edx
  800ce0:	85 ff                	test   %edi,%edi
  800ce2:	0f 45 c2             	cmovne %edx,%eax
}
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	89 c3                	mov    %eax,%ebx
  800cfd:	89 c7                	mov    %eax,%edi
  800cff:	89 c6                	mov    %eax,%esi
  800d01:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d13:	b8 01 00 00 00       	mov    $0x1,%eax
  800d18:	89 d1                	mov    %edx,%ecx
  800d1a:	89 d3                	mov    %edx,%ebx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	89 d6                	mov    %edx,%esi
  800d20:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	b8 03 00 00 00       	mov    $0x3,%eax
  800d3d:	89 cb                	mov    %ecx,%ebx
  800d3f:	89 cf                	mov    %ecx,%edi
  800d41:	89 ce                	mov    %ecx,%esi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 03                	push   $0x3
  800d57:	68 5f 2c 80 00       	push   $0x802c5f
  800d5c:	6a 23                	push   $0x23
  800d5e:	68 7c 2c 80 00       	push   $0x802c7c
  800d63:	e8 cd f4 ff ff       	call   800235 <_panic>

00800d68 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d73:	b8 02 00 00 00       	mov    $0x2,%eax
  800d78:	89 d1                	mov    %edx,%ecx
  800d7a:	89 d3                	mov    %edx,%ebx
  800d7c:	89 d7                	mov    %edx,%edi
  800d7e:	89 d6                	mov    %edx,%esi
  800d80:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <sys_yield>:

void
sys_yield(void)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d92:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d97:	89 d1                	mov    %edx,%ecx
  800d99:	89 d3                	mov    %edx,%ebx
  800d9b:	89 d7                	mov    %edx,%edi
  800d9d:	89 d6                	mov    %edx,%esi
  800d9f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
  800dac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daf:	be 00 00 00 00       	mov    $0x0,%esi
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	b8 04 00 00 00       	mov    $0x4,%eax
  800dbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc2:	89 f7                	mov    %esi,%edi
  800dc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	7f 08                	jg     800dd2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5f                   	pop    %edi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd2:	83 ec 0c             	sub    $0xc,%esp
  800dd5:	50                   	push   %eax
  800dd6:	6a 04                	push   $0x4
  800dd8:	68 5f 2c 80 00       	push   $0x802c5f
  800ddd:	6a 23                	push   $0x23
  800ddf:	68 7c 2c 80 00       	push   $0x802c7c
  800de4:	e8 4c f4 ff ff       	call   800235 <_panic>

00800de9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
  800def:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	b8 05 00 00 00       	mov    $0x5,%eax
  800dfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e00:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e03:	8b 75 18             	mov    0x18(%ebp),%esi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 05                	push   $0x5
  800e1a:	68 5f 2c 80 00       	push   $0x802c5f
  800e1f:	6a 23                	push   $0x23
  800e21:	68 7c 2c 80 00       	push   $0x802c7c
  800e26:	e8 0a f4 ff ff       	call   800235 <_panic>

00800e2b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3f:	b8 06 00 00 00       	mov    $0x6,%eax
  800e44:	89 df                	mov    %ebx,%edi
  800e46:	89 de                	mov    %ebx,%esi
  800e48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	7f 08                	jg     800e56 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	50                   	push   %eax
  800e5a:	6a 06                	push   $0x6
  800e5c:	68 5f 2c 80 00       	push   $0x802c5f
  800e61:	6a 23                	push   $0x23
  800e63:	68 7c 2c 80 00       	push   $0x802c7c
  800e68:	e8 c8 f3 ff ff       	call   800235 <_panic>

00800e6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
  800e73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	b8 08 00 00 00       	mov    $0x8,%eax
  800e86:	89 df                	mov    %ebx,%edi
  800e88:	89 de                	mov    %ebx,%esi
  800e8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	7f 08                	jg     800e98 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e98:	83 ec 0c             	sub    $0xc,%esp
  800e9b:	50                   	push   %eax
  800e9c:	6a 08                	push   $0x8
  800e9e:	68 5f 2c 80 00       	push   $0x802c5f
  800ea3:	6a 23                	push   $0x23
  800ea5:	68 7c 2c 80 00       	push   $0x802c7c
  800eaa:	e8 86 f3 ff ff       	call   800235 <_panic>

00800eaf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	57                   	push   %edi
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
  800eb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec8:	89 df                	mov    %ebx,%edi
  800eca:	89 de                	mov    %ebx,%esi
  800ecc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	7f 08                	jg     800eda <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	83 ec 0c             	sub    $0xc,%esp
  800edd:	50                   	push   %eax
  800ede:	6a 09                	push   $0x9
  800ee0:	68 5f 2c 80 00       	push   $0x802c5f
  800ee5:	6a 23                	push   $0x23
  800ee7:	68 7c 2c 80 00       	push   $0x802c7c
  800eec:	e8 44 f3 ff ff       	call   800235 <_panic>

00800ef1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f0a:	89 df                	mov    %ebx,%edi
  800f0c:	89 de                	mov    %ebx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800f20:	6a 0a                	push   $0xa
  800f22:	68 5f 2c 80 00       	push   $0x802c5f
  800f27:	6a 23                	push   $0x23
  800f29:	68 7c 2c 80 00       	push   $0x802c7c
  800f2e:	e8 02 f3 ff ff       	call   800235 <_panic>

00800f33 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f44:	be 00 00 00 00       	mov    $0x0,%esi
  800f49:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
  800f5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f6c:	89 cb                	mov    %ecx,%ebx
  800f6e:	89 cf                	mov    %ecx,%edi
  800f70:	89 ce                	mov    %ecx,%esi
  800f72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	7f 08                	jg     800f80 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	50                   	push   %eax
  800f84:	6a 0d                	push   $0xd
  800f86:	68 5f 2c 80 00       	push   $0x802c5f
  800f8b:	6a 23                	push   $0x23
  800f8d:	68 7c 2c 80 00       	push   $0x802c7c
  800f92:	e8 9e f2 ff ff       	call   800235 <_panic>

00800f97 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fa7:	89 d1                	mov    %edx,%ecx
  800fa9:	89 d3                	mov    %edx,%ebx
  800fab:	89 d7                	mov    %edx,%edi
  800fad:	89 d6                	mov    %edx,%esi
  800faf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 1c             	sub    $0x1c,%esp
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800fc2:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800fc4:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800fc7:	89 d8                	mov    %ebx,%eax
  800fc9:	c1 e8 0c             	shr    $0xc,%eax
  800fcc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800fd6:	e8 8d fd ff ff       	call   800d68 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800fdb:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800fe1:	74 73                	je     801056 <pgfault+0xa0>
  800fe3:	89 c6                	mov    %eax,%esi
  800fe5:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800fec:	74 68                	je     801056 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	6a 07                	push   $0x7
  800ff3:	68 00 f0 7f 00       	push   $0x7ff000
  800ff8:	50                   	push   %eax
  800ff9:	e8 a8 fd ff ff       	call   800da6 <sys_page_alloc>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	85 c0                	test   %eax,%eax
  801003:	75 65                	jne    80106a <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801005:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	68 00 10 00 00       	push   $0x1000
  801013:	53                   	push   %ebx
  801014:	68 00 f0 7f 00       	push   $0x7ff000
  801019:	e8 85 fb ff ff       	call   800ba3 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80101e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801025:	53                   	push   %ebx
  801026:	56                   	push   %esi
  801027:	68 00 f0 7f 00       	push   $0x7ff000
  80102c:	56                   	push   %esi
  80102d:	e8 b7 fd ff ff       	call   800de9 <sys_page_map>
  801032:	83 c4 20             	add    $0x20,%esp
  801035:	85 c0                	test   %eax,%eax
  801037:	75 43                	jne    80107c <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  801039:	83 ec 08             	sub    $0x8,%esp
  80103c:	68 00 f0 7f 00       	push   $0x7ff000
  801041:	56                   	push   %esi
  801042:	e8 e4 fd ff ff       	call   800e2b <sys_page_unmap>
  801047:	83 c4 10             	add    $0x10,%esp
  80104a:	85 c0                	test   %eax,%eax
  80104c:	75 40                	jne    80108e <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  80104e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  801056:	83 ec 04             	sub    $0x4,%esp
  801059:	68 8a 2c 80 00       	push   $0x802c8a
  80105e:	6a 1f                	push   $0x1f
  801060:	68 a8 2c 80 00       	push   $0x802ca8
  801065:	e8 cb f1 ff ff       	call   800235 <_panic>
	    panic("pgfault: %e", r);
  80106a:	50                   	push   %eax
  80106b:	68 b3 2c 80 00       	push   $0x802cb3
  801070:	6a 2a                	push   $0x2a
  801072:	68 a8 2c 80 00       	push   $0x802ca8
  801077:	e8 b9 f1 ff ff       	call   800235 <_panic>
	    panic("pgfault: %e", r);
  80107c:	50                   	push   %eax
  80107d:	68 b3 2c 80 00       	push   $0x802cb3
  801082:	6a 2e                	push   $0x2e
  801084:	68 a8 2c 80 00       	push   $0x802ca8
  801089:	e8 a7 f1 ff ff       	call   800235 <_panic>
	    panic("pgfault: %e", r);
  80108e:	50                   	push   %eax
  80108f:	68 b3 2c 80 00       	push   $0x802cb3
  801094:	6a 31                	push   $0x31
  801096:	68 a8 2c 80 00       	push   $0x802ca8
  80109b:	e8 95 f1 ff ff       	call   800235 <_panic>

008010a0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	57                   	push   %edi
  8010a4:	56                   	push   %esi
  8010a5:	53                   	push   %ebx
  8010a6:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  8010a9:	68 b6 0f 80 00       	push   $0x800fb6
  8010ae:	e8 89 14 00 00       	call   80253c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8010b8:	cd 30                	int    $0x30
  8010ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  8010c0:	83 c4 10             	add    $0x10,%esp
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	78 2b                	js     8010f2 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010c7:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010d0:	0f 85 b5 00 00 00    	jne    80118b <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  8010d6:	e8 8d fc ff ff       	call   800d68 <sys_getenvid>
  8010db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010e8:	a3 0c 40 80 00       	mov    %eax,0x80400c
	    return 0;
  8010ed:	e9 8c 01 00 00       	jmp    80127e <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  8010f2:	50                   	push   %eax
  8010f3:	68 bf 2c 80 00       	push   $0x802cbf
  8010f8:	6a 77                	push   $0x77
  8010fa:	68 a8 2c 80 00       	push   $0x802ca8
  8010ff:	e8 31 f1 ff ff       	call   800235 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801104:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	25 07 0e 00 00       	and    $0xe07,%eax
  801113:	50                   	push   %eax
  801114:	57                   	push   %edi
  801115:	ff 75 e0             	pushl  -0x20(%ebp)
  801118:	57                   	push   %edi
  801119:	ff 75 e4             	pushl  -0x1c(%ebp)
  80111c:	e8 c8 fc ff ff       	call   800de9 <sys_page_map>
  801121:	83 c4 20             	add    $0x20,%esp
  801124:	85 c0                	test   %eax,%eax
  801126:	74 51                	je     801179 <fork+0xd9>
           panic("duppage: %e", r);
  801128:	50                   	push   %eax
  801129:	68 cf 2c 80 00       	push   $0x802ccf
  80112e:	6a 4a                	push   $0x4a
  801130:	68 a8 2c 80 00       	push   $0x802ca8
  801135:	e8 fb f0 ff ff       	call   800235 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	68 05 08 00 00       	push   $0x805
  801142:	57                   	push   %edi
  801143:	ff 75 e0             	pushl  -0x20(%ebp)
  801146:	57                   	push   %edi
  801147:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114a:	e8 9a fc ff ff       	call   800de9 <sys_page_map>
  80114f:	83 c4 20             	add    $0x20,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	0f 85 bc 00 00 00    	jne    801216 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	68 05 08 00 00       	push   $0x805
  801162:	57                   	push   %edi
  801163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801166:	50                   	push   %eax
  801167:	57                   	push   %edi
  801168:	50                   	push   %eax
  801169:	e8 7b fc ff ff       	call   800de9 <sys_page_map>
  80116e:	83 c4 20             	add    $0x20,%esp
  801171:	85 c0                	test   %eax,%eax
  801173:	0f 85 af 00 00 00    	jne    801228 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801179:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80117f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801185:	0f 84 af 00 00 00    	je     80123a <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  80118b:	89 d8                	mov    %ebx,%eax
  80118d:	c1 e8 16             	shr    $0x16,%eax
  801190:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801197:	a8 01                	test   $0x1,%al
  801199:	74 de                	je     801179 <fork+0xd9>
  80119b:	89 de                	mov    %ebx,%esi
  80119d:	c1 ee 0c             	shr    $0xc,%esi
  8011a0:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011a7:	a8 01                	test   $0x1,%al
  8011a9:	74 ce                	je     801179 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  8011ab:	e8 b8 fb ff ff       	call   800d68 <sys_getenvid>
  8011b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  8011b3:	89 f7                	mov    %esi,%edi
  8011b5:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8011b8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011bf:	f6 c4 04             	test   $0x4,%ah
  8011c2:	0f 85 3c ff ff ff    	jne    801104 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8011c8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011cf:	a8 02                	test   $0x2,%al
  8011d1:	0f 85 63 ff ff ff    	jne    80113a <fork+0x9a>
  8011d7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011de:	f6 c4 08             	test   $0x8,%ah
  8011e1:	0f 85 53 ff ff ff    	jne    80113a <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8011e7:	83 ec 0c             	sub    $0xc,%esp
  8011ea:	6a 05                	push   $0x5
  8011ec:	57                   	push   %edi
  8011ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8011f0:	57                   	push   %edi
  8011f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f4:	e8 f0 fb ff ff       	call   800de9 <sys_page_map>
  8011f9:	83 c4 20             	add    $0x20,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	0f 84 75 ff ff ff    	je     801179 <fork+0xd9>
	        panic("duppage: %e", r);
  801204:	50                   	push   %eax
  801205:	68 cf 2c 80 00       	push   $0x802ccf
  80120a:	6a 55                	push   $0x55
  80120c:	68 a8 2c 80 00       	push   $0x802ca8
  801211:	e8 1f f0 ff ff       	call   800235 <_panic>
	        panic("duppage: %e", r);
  801216:	50                   	push   %eax
  801217:	68 cf 2c 80 00       	push   $0x802ccf
  80121c:	6a 4e                	push   $0x4e
  80121e:	68 a8 2c 80 00       	push   $0x802ca8
  801223:	e8 0d f0 ff ff       	call   800235 <_panic>
	        panic("duppage: %e", r);
  801228:	50                   	push   %eax
  801229:	68 cf 2c 80 00       	push   $0x802ccf
  80122e:	6a 51                	push   $0x51
  801230:	68 a8 2c 80 00       	push   $0x802ca8
  801235:	e8 fb ef ff ff       	call   800235 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80123a:	83 ec 04             	sub    $0x4,%esp
  80123d:	6a 07                	push   $0x7
  80123f:	68 00 f0 bf ee       	push   $0xeebff000
  801244:	ff 75 dc             	pushl  -0x24(%ebp)
  801247:	e8 5a fb ff ff       	call   800da6 <sys_page_alloc>
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	75 36                	jne    801289 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	68 b5 25 80 00       	push   $0x8025b5
  80125b:	ff 75 dc             	pushl  -0x24(%ebp)
  80125e:	e8 8e fc ff ff       	call   800ef1 <sys_env_set_pgfault_upcall>
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	85 c0                	test   %eax,%eax
  801268:	75 34                	jne    80129e <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	6a 02                	push   $0x2
  80126f:	ff 75 dc             	pushl  -0x24(%ebp)
  801272:	e8 f6 fb ff ff       	call   800e6d <sys_env_set_status>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	75 35                	jne    8012b3 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  80127e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801284:	5b                   	pop    %ebx
  801285:	5e                   	pop    %esi
  801286:	5f                   	pop    %edi
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    
	    panic("fork: %e", r);
  801289:	50                   	push   %eax
  80128a:	68 c6 2c 80 00       	push   $0x802cc6
  80128f:	68 8a 00 00 00       	push   $0x8a
  801294:	68 a8 2c 80 00       	push   $0x802ca8
  801299:	e8 97 ef ff ff       	call   800235 <_panic>
	    panic("fork: %e", r);
  80129e:	50                   	push   %eax
  80129f:	68 c6 2c 80 00       	push   $0x802cc6
  8012a4:	68 8d 00 00 00       	push   $0x8d
  8012a9:	68 a8 2c 80 00       	push   $0x802ca8
  8012ae:	e8 82 ef ff ff       	call   800235 <_panic>
	    panic("fork: %e", r);
  8012b3:	50                   	push   %eax
  8012b4:	68 c6 2c 80 00       	push   $0x802cc6
  8012b9:	68 92 00 00 00       	push   $0x92
  8012be:	68 a8 2c 80 00       	push   $0x802ca8
  8012c3:	e8 6d ef ff ff       	call   800235 <_panic>

008012c8 <sfork>:

// Challenge!
int
sfork(void)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012ce:	68 db 2c 80 00       	push   $0x802cdb
  8012d3:	68 9b 00 00 00       	push   $0x9b
  8012d8:	68 a8 2c 80 00       	push   $0x802ca8
  8012dd:	e8 53 ef ff ff       	call   800235 <_panic>

008012e2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	56                   	push   %esi
  8012e6:	53                   	push   %ebx
  8012e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8012f0:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8012f2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8012f7:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8012fa:	83 ec 0c             	sub    $0xc,%esp
  8012fd:	50                   	push   %eax
  8012fe:	e8 53 fc ff ff       	call   800f56 <sys_ipc_recv>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 2b                	js     801335 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80130a:	85 f6                	test   %esi,%esi
  80130c:	74 0a                	je     801318 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80130e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801313:	8b 40 74             	mov    0x74(%eax),%eax
  801316:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801318:	85 db                	test   %ebx,%ebx
  80131a:	74 0a                	je     801326 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80131c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801321:	8b 40 78             	mov    0x78(%eax),%eax
  801324:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801326:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80132b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80132e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    
	    if (from_env_store != NULL) {
  801335:	85 f6                	test   %esi,%esi
  801337:	74 06                	je     80133f <ipc_recv+0x5d>
	        *from_env_store = 0;
  801339:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80133f:	85 db                	test   %ebx,%ebx
  801341:	74 eb                	je     80132e <ipc_recv+0x4c>
	        *perm_store = 0;
  801343:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801349:	eb e3                	jmp    80132e <ipc_recv+0x4c>

0080134b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	57                   	push   %edi
  80134f:	56                   	push   %esi
  801350:	53                   	push   %ebx
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	8b 7d 08             	mov    0x8(%ebp),%edi
  801357:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80135a:	85 f6                	test   %esi,%esi
  80135c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801361:	0f 44 f0             	cmove  %eax,%esi
  801364:	eb 09                	jmp    80136f <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  801366:	e8 1c fa ff ff       	call   800d87 <sys_yield>
	} while(r != 0);
  80136b:	85 db                	test   %ebx,%ebx
  80136d:	74 2d                	je     80139c <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80136f:	ff 75 14             	pushl  0x14(%ebp)
  801372:	56                   	push   %esi
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	57                   	push   %edi
  801377:	e8 b7 fb ff ff       	call   800f33 <sys_ipc_try_send>
  80137c:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	79 e1                	jns    801366 <ipc_send+0x1b>
  801385:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801388:	74 dc                	je     801366 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80138a:	50                   	push   %eax
  80138b:	68 f1 2c 80 00       	push   $0x802cf1
  801390:	6a 45                	push   $0x45
  801392:	68 fe 2c 80 00       	push   $0x802cfe
  801397:	e8 99 ee ff ff       	call   800235 <_panic>
}
  80139c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139f:	5b                   	pop    %ebx
  8013a0:	5e                   	pop    %esi
  8013a1:	5f                   	pop    %edi
  8013a2:	5d                   	pop    %ebp
  8013a3:	c3                   	ret    

008013a4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013aa:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8013af:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013b2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013b8:	8b 52 50             	mov    0x50(%edx),%edx
  8013bb:	39 ca                	cmp    %ecx,%edx
  8013bd:	74 11                	je     8013d0 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8013bf:	83 c0 01             	add    $0x1,%eax
  8013c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013c7:	75 e6                	jne    8013af <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ce:	eb 0b                	jmp    8013db <ipc_find_env+0x37>
			return envs[i].env_id;
  8013d0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013d8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    

008013dd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	05 00 00 00 30       	add    $0x30000000,%eax
  8013e8:	c1 e8 0c             	shr    $0xc,%eax
}
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013fd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80140f:	89 c2                	mov    %eax,%edx
  801411:	c1 ea 16             	shr    $0x16,%edx
  801414:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80141b:	f6 c2 01             	test   $0x1,%dl
  80141e:	74 2a                	je     80144a <fd_alloc+0x46>
  801420:	89 c2                	mov    %eax,%edx
  801422:	c1 ea 0c             	shr    $0xc,%edx
  801425:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80142c:	f6 c2 01             	test   $0x1,%dl
  80142f:	74 19                	je     80144a <fd_alloc+0x46>
  801431:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801436:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80143b:	75 d2                	jne    80140f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80143d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801443:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801448:	eb 07                	jmp    801451 <fd_alloc+0x4d>
			*fd_store = fd;
  80144a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801459:	83 f8 1f             	cmp    $0x1f,%eax
  80145c:	77 36                	ja     801494 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80145e:	c1 e0 0c             	shl    $0xc,%eax
  801461:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801466:	89 c2                	mov    %eax,%edx
  801468:	c1 ea 16             	shr    $0x16,%edx
  80146b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801472:	f6 c2 01             	test   $0x1,%dl
  801475:	74 24                	je     80149b <fd_lookup+0x48>
  801477:	89 c2                	mov    %eax,%edx
  801479:	c1 ea 0c             	shr    $0xc,%edx
  80147c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801483:	f6 c2 01             	test   $0x1,%dl
  801486:	74 1a                	je     8014a2 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148b:	89 02                	mov    %eax,(%edx)
	return 0;
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801492:	5d                   	pop    %ebp
  801493:	c3                   	ret    
		return -E_INVAL;
  801494:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801499:	eb f7                	jmp    801492 <fd_lookup+0x3f>
		return -E_INVAL;
  80149b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a0:	eb f0                	jmp    801492 <fd_lookup+0x3f>
  8014a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a7:	eb e9                	jmp    801492 <fd_lookup+0x3f>

008014a9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014b2:	ba 84 2d 80 00       	mov    $0x802d84,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014b7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014bc:	39 08                	cmp    %ecx,(%eax)
  8014be:	74 33                	je     8014f3 <dev_lookup+0x4a>
  8014c0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014c3:	8b 02                	mov    (%edx),%eax
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	75 f3                	jne    8014bc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014c9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014ce:	8b 40 48             	mov    0x48(%eax),%eax
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	51                   	push   %ecx
  8014d5:	50                   	push   %eax
  8014d6:	68 08 2d 80 00       	push   $0x802d08
  8014db:	e8 30 ee ff ff       	call   800310 <cprintf>
	*dev = 0;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    
			*dev = devtab[i];
  8014f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fd:	eb f2                	jmp    8014f1 <dev_lookup+0x48>

008014ff <fd_close>:
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	57                   	push   %edi
  801503:	56                   	push   %esi
  801504:	53                   	push   %ebx
  801505:	83 ec 1c             	sub    $0x1c,%esp
  801508:	8b 75 08             	mov    0x8(%ebp),%esi
  80150b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80150e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801511:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801512:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801518:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80151b:	50                   	push   %eax
  80151c:	e8 32 ff ff ff       	call   801453 <fd_lookup>
  801521:	89 c3                	mov    %eax,%ebx
  801523:	83 c4 08             	add    $0x8,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 05                	js     80152f <fd_close+0x30>
	    || fd != fd2)
  80152a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80152d:	74 16                	je     801545 <fd_close+0x46>
		return (must_exist ? r : 0);
  80152f:	89 f8                	mov    %edi,%eax
  801531:	84 c0                	test   %al,%al
  801533:	b8 00 00 00 00       	mov    $0x0,%eax
  801538:	0f 44 d8             	cmove  %eax,%ebx
}
  80153b:	89 d8                	mov    %ebx,%eax
  80153d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801540:	5b                   	pop    %ebx
  801541:	5e                   	pop    %esi
  801542:	5f                   	pop    %edi
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80154b:	50                   	push   %eax
  80154c:	ff 36                	pushl  (%esi)
  80154e:	e8 56 ff ff ff       	call   8014a9 <dev_lookup>
  801553:	89 c3                	mov    %eax,%ebx
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	78 15                	js     801571 <fd_close+0x72>
		if (dev->dev_close)
  80155c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155f:	8b 40 10             	mov    0x10(%eax),%eax
  801562:	85 c0                	test   %eax,%eax
  801564:	74 1b                	je     801581 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801566:	83 ec 0c             	sub    $0xc,%esp
  801569:	56                   	push   %esi
  80156a:	ff d0                	call   *%eax
  80156c:	89 c3                	mov    %eax,%ebx
  80156e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	56                   	push   %esi
  801575:	6a 00                	push   $0x0
  801577:	e8 af f8 ff ff       	call   800e2b <sys_page_unmap>
	return r;
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	eb ba                	jmp    80153b <fd_close+0x3c>
			r = 0;
  801581:	bb 00 00 00 00       	mov    $0x0,%ebx
  801586:	eb e9                	jmp    801571 <fd_close+0x72>

00801588 <close>:

int
close(int fdnum)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801591:	50                   	push   %eax
  801592:	ff 75 08             	pushl  0x8(%ebp)
  801595:	e8 b9 fe ff ff       	call   801453 <fd_lookup>
  80159a:	83 c4 08             	add    $0x8,%esp
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 10                	js     8015b1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	6a 01                	push   $0x1
  8015a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a9:	e8 51 ff ff ff       	call   8014ff <fd_close>
  8015ae:	83 c4 10             	add    $0x10,%esp
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <close_all>:

void
close_all(void)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	53                   	push   %ebx
  8015b7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ba:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015bf:	83 ec 0c             	sub    $0xc,%esp
  8015c2:	53                   	push   %ebx
  8015c3:	e8 c0 ff ff ff       	call   801588 <close>
	for (i = 0; i < MAXFD; i++)
  8015c8:	83 c3 01             	add    $0x1,%ebx
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	83 fb 20             	cmp    $0x20,%ebx
  8015d1:	75 ec                	jne    8015bf <close_all+0xc>
}
  8015d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	57                   	push   %edi
  8015dc:	56                   	push   %esi
  8015dd:	53                   	push   %ebx
  8015de:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015e4:	50                   	push   %eax
  8015e5:	ff 75 08             	pushl  0x8(%ebp)
  8015e8:	e8 66 fe ff ff       	call   801453 <fd_lookup>
  8015ed:	89 c3                	mov    %eax,%ebx
  8015ef:	83 c4 08             	add    $0x8,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	0f 88 81 00 00 00    	js     80167b <dup+0xa3>
		return r;
	close(newfdnum);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	ff 75 0c             	pushl  0xc(%ebp)
  801600:	e8 83 ff ff ff       	call   801588 <close>

	newfd = INDEX2FD(newfdnum);
  801605:	8b 75 0c             	mov    0xc(%ebp),%esi
  801608:	c1 e6 0c             	shl    $0xc,%esi
  80160b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801611:	83 c4 04             	add    $0x4,%esp
  801614:	ff 75 e4             	pushl  -0x1c(%ebp)
  801617:	e8 d1 fd ff ff       	call   8013ed <fd2data>
  80161c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80161e:	89 34 24             	mov    %esi,(%esp)
  801621:	e8 c7 fd ff ff       	call   8013ed <fd2data>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80162b:	89 d8                	mov    %ebx,%eax
  80162d:	c1 e8 16             	shr    $0x16,%eax
  801630:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801637:	a8 01                	test   $0x1,%al
  801639:	74 11                	je     80164c <dup+0x74>
  80163b:	89 d8                	mov    %ebx,%eax
  80163d:	c1 e8 0c             	shr    $0xc,%eax
  801640:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801647:	f6 c2 01             	test   $0x1,%dl
  80164a:	75 39                	jne    801685 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80164c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80164f:	89 d0                	mov    %edx,%eax
  801651:	c1 e8 0c             	shr    $0xc,%eax
  801654:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	25 07 0e 00 00       	and    $0xe07,%eax
  801663:	50                   	push   %eax
  801664:	56                   	push   %esi
  801665:	6a 00                	push   $0x0
  801667:	52                   	push   %edx
  801668:	6a 00                	push   $0x0
  80166a:	e8 7a f7 ff ff       	call   800de9 <sys_page_map>
  80166f:	89 c3                	mov    %eax,%ebx
  801671:	83 c4 20             	add    $0x20,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 31                	js     8016a9 <dup+0xd1>
		goto err;

	return newfdnum;
  801678:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80167b:	89 d8                	mov    %ebx,%eax
  80167d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801680:	5b                   	pop    %ebx
  801681:	5e                   	pop    %esi
  801682:	5f                   	pop    %edi
  801683:	5d                   	pop    %ebp
  801684:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801685:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80168c:	83 ec 0c             	sub    $0xc,%esp
  80168f:	25 07 0e 00 00       	and    $0xe07,%eax
  801694:	50                   	push   %eax
  801695:	57                   	push   %edi
  801696:	6a 00                	push   $0x0
  801698:	53                   	push   %ebx
  801699:	6a 00                	push   $0x0
  80169b:	e8 49 f7 ff ff       	call   800de9 <sys_page_map>
  8016a0:	89 c3                	mov    %eax,%ebx
  8016a2:	83 c4 20             	add    $0x20,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	79 a3                	jns    80164c <dup+0x74>
	sys_page_unmap(0, newfd);
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	56                   	push   %esi
  8016ad:	6a 00                	push   $0x0
  8016af:	e8 77 f7 ff ff       	call   800e2b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016b4:	83 c4 08             	add    $0x8,%esp
  8016b7:	57                   	push   %edi
  8016b8:	6a 00                	push   $0x0
  8016ba:	e8 6c f7 ff ff       	call   800e2b <sys_page_unmap>
	return r;
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	eb b7                	jmp    80167b <dup+0xa3>

008016c4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	53                   	push   %ebx
  8016c8:	83 ec 14             	sub    $0x14,%esp
  8016cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d1:	50                   	push   %eax
  8016d2:	53                   	push   %ebx
  8016d3:	e8 7b fd ff ff       	call   801453 <fd_lookup>
  8016d8:	83 c4 08             	add    $0x8,%esp
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	78 3f                	js     80171e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e5:	50                   	push   %eax
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	ff 30                	pushl  (%eax)
  8016eb:	e8 b9 fd ff ff       	call   8014a9 <dev_lookup>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 27                	js     80171e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fa:	8b 42 08             	mov    0x8(%edx),%eax
  8016fd:	83 e0 03             	and    $0x3,%eax
  801700:	83 f8 01             	cmp    $0x1,%eax
  801703:	74 1e                	je     801723 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801708:	8b 40 08             	mov    0x8(%eax),%eax
  80170b:	85 c0                	test   %eax,%eax
  80170d:	74 35                	je     801744 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	ff 75 10             	pushl  0x10(%ebp)
  801715:	ff 75 0c             	pushl  0xc(%ebp)
  801718:	52                   	push   %edx
  801719:	ff d0                	call   *%eax
  80171b:	83 c4 10             	add    $0x10,%esp
}
  80171e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801721:	c9                   	leave  
  801722:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801723:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801728:	8b 40 48             	mov    0x48(%eax),%eax
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	53                   	push   %ebx
  80172f:	50                   	push   %eax
  801730:	68 49 2d 80 00       	push   $0x802d49
  801735:	e8 d6 eb ff ff       	call   800310 <cprintf>
		return -E_INVAL;
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801742:	eb da                	jmp    80171e <read+0x5a>
		return -E_NOT_SUPP;
  801744:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801749:	eb d3                	jmp    80171e <read+0x5a>

0080174b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	57                   	push   %edi
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	8b 7d 08             	mov    0x8(%ebp),%edi
  801757:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80175a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175f:	39 f3                	cmp    %esi,%ebx
  801761:	73 25                	jae    801788 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	89 f0                	mov    %esi,%eax
  801768:	29 d8                	sub    %ebx,%eax
  80176a:	50                   	push   %eax
  80176b:	89 d8                	mov    %ebx,%eax
  80176d:	03 45 0c             	add    0xc(%ebp),%eax
  801770:	50                   	push   %eax
  801771:	57                   	push   %edi
  801772:	e8 4d ff ff ff       	call   8016c4 <read>
		if (m < 0)
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 08                	js     801786 <readn+0x3b>
			return m;
		if (m == 0)
  80177e:	85 c0                	test   %eax,%eax
  801780:	74 06                	je     801788 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801782:	01 c3                	add    %eax,%ebx
  801784:	eb d9                	jmp    80175f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801786:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801788:	89 d8                	mov    %ebx,%eax
  80178a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5e                   	pop    %esi
  80178f:	5f                   	pop    %edi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	53                   	push   %ebx
  801796:	83 ec 14             	sub    $0x14,%esp
  801799:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179f:	50                   	push   %eax
  8017a0:	53                   	push   %ebx
  8017a1:	e8 ad fc ff ff       	call   801453 <fd_lookup>
  8017a6:	83 c4 08             	add    $0x8,%esp
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 3a                	js     8017e7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	ff 30                	pushl  (%eax)
  8017b9:	e8 eb fc ff ff       	call   8014a9 <dev_lookup>
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	78 22                	js     8017e7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017cc:	74 1e                	je     8017ec <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d1:	8b 52 0c             	mov    0xc(%edx),%edx
  8017d4:	85 d2                	test   %edx,%edx
  8017d6:	74 35                	je     80180d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	ff 75 10             	pushl  0x10(%ebp)
  8017de:	ff 75 0c             	pushl  0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	ff d2                	call   *%edx
  8017e4:	83 c4 10             	add    $0x10,%esp
}
  8017e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ec:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8017f1:	8b 40 48             	mov    0x48(%eax),%eax
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	53                   	push   %ebx
  8017f8:	50                   	push   %eax
  8017f9:	68 65 2d 80 00       	push   $0x802d65
  8017fe:	e8 0d eb ff ff       	call   800310 <cprintf>
		return -E_INVAL;
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180b:	eb da                	jmp    8017e7 <write+0x55>
		return -E_NOT_SUPP;
  80180d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801812:	eb d3                	jmp    8017e7 <write+0x55>

00801814 <seek>:

int
seek(int fdnum, off_t offset)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80181a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	e8 2d fc ff ff       	call   801453 <fd_lookup>
  801826:	83 c4 08             	add    $0x8,%esp
  801829:	85 c0                	test   %eax,%eax
  80182b:	78 0e                	js     80183b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801833:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	53                   	push   %ebx
  801841:	83 ec 14             	sub    $0x14,%esp
  801844:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801847:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184a:	50                   	push   %eax
  80184b:	53                   	push   %ebx
  80184c:	e8 02 fc ff ff       	call   801453 <fd_lookup>
  801851:	83 c4 08             	add    $0x8,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 37                	js     80188f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185e:	50                   	push   %eax
  80185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801862:	ff 30                	pushl  (%eax)
  801864:	e8 40 fc ff ff       	call   8014a9 <dev_lookup>
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 1f                	js     80188f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801873:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801877:	74 1b                	je     801894 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187c:	8b 52 18             	mov    0x18(%edx),%edx
  80187f:	85 d2                	test   %edx,%edx
  801881:	74 32                	je     8018b5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801883:	83 ec 08             	sub    $0x8,%esp
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	50                   	push   %eax
  80188a:	ff d2                	call   *%edx
  80188c:	83 c4 10             	add    $0x10,%esp
}
  80188f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801892:	c9                   	leave  
  801893:	c3                   	ret    
			thisenv->env_id, fdnum);
  801894:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801899:	8b 40 48             	mov    0x48(%eax),%eax
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	53                   	push   %ebx
  8018a0:	50                   	push   %eax
  8018a1:	68 28 2d 80 00       	push   $0x802d28
  8018a6:	e8 65 ea ff ff       	call   800310 <cprintf>
		return -E_INVAL;
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b3:	eb da                	jmp    80188f <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ba:	eb d3                	jmp    80188f <ftruncate+0x52>

008018bc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 14             	sub    $0x14,%esp
  8018c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c9:	50                   	push   %eax
  8018ca:	ff 75 08             	pushl  0x8(%ebp)
  8018cd:	e8 81 fb ff ff       	call   801453 <fd_lookup>
  8018d2:	83 c4 08             	add    $0x8,%esp
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	78 4b                	js     801924 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018df:	50                   	push   %eax
  8018e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e3:	ff 30                	pushl  (%eax)
  8018e5:	e8 bf fb ff ff       	call   8014a9 <dev_lookup>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 33                	js     801924 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018f8:	74 2f                	je     801929 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018fa:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018fd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801904:	00 00 00 
	stat->st_isdir = 0;
  801907:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80190e:	00 00 00 
	stat->st_dev = dev;
  801911:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801917:	83 ec 08             	sub    $0x8,%esp
  80191a:	53                   	push   %ebx
  80191b:	ff 75 f0             	pushl  -0x10(%ebp)
  80191e:	ff 50 14             	call   *0x14(%eax)
  801921:	83 c4 10             	add    $0x10,%esp
}
  801924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801927:	c9                   	leave  
  801928:	c3                   	ret    
		return -E_NOT_SUPP;
  801929:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192e:	eb f4                	jmp    801924 <fstat+0x68>

00801930 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	6a 00                	push   $0x0
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	e8 26 02 00 00       	call   801b68 <open>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 1b                	js     801966 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80194b:	83 ec 08             	sub    $0x8,%esp
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	50                   	push   %eax
  801952:	e8 65 ff ff ff       	call   8018bc <fstat>
  801957:	89 c6                	mov    %eax,%esi
	close(fd);
  801959:	89 1c 24             	mov    %ebx,(%esp)
  80195c:	e8 27 fc ff ff       	call   801588 <close>
	return r;
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	89 f3                	mov    %esi,%ebx
}
  801966:	89 d8                	mov    %ebx,%eax
  801968:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    

0080196f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	89 c6                	mov    %eax,%esi
  801976:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801978:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80197f:	74 27                	je     8019a8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801981:	6a 07                	push   $0x7
  801983:	68 00 50 80 00       	push   $0x805000
  801988:	56                   	push   %esi
  801989:	ff 35 04 40 80 00    	pushl  0x804004
  80198f:	e8 b7 f9 ff ff       	call   80134b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801994:	83 c4 0c             	add    $0xc,%esp
  801997:	6a 00                	push   $0x0
  801999:	53                   	push   %ebx
  80199a:	6a 00                	push   $0x0
  80199c:	e8 41 f9 ff ff       	call   8012e2 <ipc_recv>
}
  8019a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a4:	5b                   	pop    %ebx
  8019a5:	5e                   	pop    %esi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019a8:	83 ec 0c             	sub    $0xc,%esp
  8019ab:	6a 01                	push   $0x1
  8019ad:	e8 f2 f9 ff ff       	call   8013a4 <ipc_find_env>
  8019b2:	a3 04 40 80 00       	mov    %eax,0x804004
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	eb c5                	jmp    801981 <fsipc+0x12>

008019bc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019da:	b8 02 00 00 00       	mov    $0x2,%eax
  8019df:	e8 8b ff ff ff       	call   80196f <fsipc>
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <devfile_flush>:
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	b8 06 00 00 00       	mov    $0x6,%eax
  801a01:	e8 69 ff ff ff       	call   80196f <fsipc>
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <devfile_stat>:
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8b 40 0c             	mov    0xc(%eax),%eax
  801a18:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a22:	b8 05 00 00 00       	mov    $0x5,%eax
  801a27:	e8 43 ff ff ff       	call   80196f <fsipc>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 2c                	js     801a5c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a30:	83 ec 08             	sub    $0x8,%esp
  801a33:	68 00 50 80 00       	push   $0x805000
  801a38:	53                   	push   %ebx
  801a39:	e8 6f ef ff ff       	call   8009ad <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a3e:	a1 80 50 80 00       	mov    0x805080,%eax
  801a43:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a49:	a1 84 50 80 00       	mov    0x805084,%eax
  801a4e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <devfile_write>:
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	53                   	push   %ebx
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a71:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a76:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a7c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a82:	77 30                	ja     801ab4 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	53                   	push   %ebx
  801a88:	ff 75 0c             	pushl  0xc(%ebp)
  801a8b:	68 08 50 80 00       	push   $0x805008
  801a90:	e8 a6 f0 ff ff       	call   800b3b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a95:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9a:	b8 04 00 00 00       	mov    $0x4,%eax
  801a9f:	e8 cb fe ff ff       	call   80196f <fsipc>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 04                	js     801aaf <devfile_write+0x4e>
	assert(r <= n);
  801aab:	39 d8                	cmp    %ebx,%eax
  801aad:	77 1e                	ja     801acd <devfile_write+0x6c>
}
  801aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801ab4:	68 98 2d 80 00       	push   $0x802d98
  801ab9:	68 c8 2d 80 00       	push   $0x802dc8
  801abe:	68 94 00 00 00       	push   $0x94
  801ac3:	68 dd 2d 80 00       	push   $0x802ddd
  801ac8:	e8 68 e7 ff ff       	call   800235 <_panic>
	assert(r <= n);
  801acd:	68 e8 2d 80 00       	push   $0x802de8
  801ad2:	68 c8 2d 80 00       	push   $0x802dc8
  801ad7:	68 98 00 00 00       	push   $0x98
  801adc:	68 dd 2d 80 00       	push   $0x802ddd
  801ae1:	e8 4f e7 ff ff       	call   800235 <_panic>

00801ae6 <devfile_read>:
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	56                   	push   %esi
  801aea:	53                   	push   %ebx
  801aeb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	8b 40 0c             	mov    0xc(%eax),%eax
  801af4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801af9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aff:	ba 00 00 00 00       	mov    $0x0,%edx
  801b04:	b8 03 00 00 00       	mov    $0x3,%eax
  801b09:	e8 61 fe ff ff       	call   80196f <fsipc>
  801b0e:	89 c3                	mov    %eax,%ebx
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 1f                	js     801b33 <devfile_read+0x4d>
	assert(r <= n);
  801b14:	39 f0                	cmp    %esi,%eax
  801b16:	77 24                	ja     801b3c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b18:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b1d:	7f 33                	jg     801b52 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	50                   	push   %eax
  801b23:	68 00 50 80 00       	push   $0x805000
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	e8 0b f0 ff ff       	call   800b3b <memmove>
	return r;
  801b30:	83 c4 10             	add    $0x10,%esp
}
  801b33:	89 d8                	mov    %ebx,%eax
  801b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    
	assert(r <= n);
  801b3c:	68 e8 2d 80 00       	push   $0x802de8
  801b41:	68 c8 2d 80 00       	push   $0x802dc8
  801b46:	6a 7c                	push   $0x7c
  801b48:	68 dd 2d 80 00       	push   $0x802ddd
  801b4d:	e8 e3 e6 ff ff       	call   800235 <_panic>
	assert(r <= PGSIZE);
  801b52:	68 ef 2d 80 00       	push   $0x802def
  801b57:	68 c8 2d 80 00       	push   $0x802dc8
  801b5c:	6a 7d                	push   $0x7d
  801b5e:	68 dd 2d 80 00       	push   $0x802ddd
  801b63:	e8 cd e6 ff ff       	call   800235 <_panic>

00801b68 <open>:
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	83 ec 1c             	sub    $0x1c,%esp
  801b70:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b73:	56                   	push   %esi
  801b74:	e8 fd ed ff ff       	call   800976 <strlen>
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b81:	7f 6c                	jg     801bef <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b83:	83 ec 0c             	sub    $0xc,%esp
  801b86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b89:	50                   	push   %eax
  801b8a:	e8 75 f8 ff ff       	call   801404 <fd_alloc>
  801b8f:	89 c3                	mov    %eax,%ebx
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 3c                	js     801bd4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	56                   	push   %esi
  801b9c:	68 00 50 80 00       	push   $0x805000
  801ba1:	e8 07 ee ff ff       	call   8009ad <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb6:	e8 b4 fd ff ff       	call   80196f <fsipc>
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 19                	js     801bdd <open+0x75>
	return fd2num(fd);
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bca:	e8 0e f8 ff ff       	call   8013dd <fd2num>
  801bcf:	89 c3                	mov    %eax,%ebx
  801bd1:	83 c4 10             	add    $0x10,%esp
}
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    
		fd_close(fd, 0);
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 f4             	pushl  -0xc(%ebp)
  801be5:	e8 15 f9 ff ff       	call   8014ff <fd_close>
		return r;
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	eb e5                	jmp    801bd4 <open+0x6c>
		return -E_BAD_PATH;
  801bef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bf4:	eb de                	jmp    801bd4 <open+0x6c>

00801bf6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  801c01:	b8 08 00 00 00       	mov    $0x8,%eax
  801c06:	e8 64 fd ff ff       	call   80196f <fsipc>
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	56                   	push   %esi
  801c11:	53                   	push   %ebx
  801c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c15:	83 ec 0c             	sub    $0xc,%esp
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	e8 cd f7 ff ff       	call   8013ed <fd2data>
  801c20:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c22:	83 c4 08             	add    $0x8,%esp
  801c25:	68 fb 2d 80 00       	push   $0x802dfb
  801c2a:	53                   	push   %ebx
  801c2b:	e8 7d ed ff ff       	call   8009ad <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c30:	8b 46 04             	mov    0x4(%esi),%eax
  801c33:	2b 06                	sub    (%esi),%eax
  801c35:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c3b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c42:	00 00 00 
	stat->st_dev = &devpipe;
  801c45:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c4c:	30 80 00 
	return 0;
}
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5d                   	pop    %ebp
  801c5a:	c3                   	ret    

00801c5b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	53                   	push   %ebx
  801c5f:	83 ec 0c             	sub    $0xc,%esp
  801c62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c65:	53                   	push   %ebx
  801c66:	6a 00                	push   $0x0
  801c68:	e8 be f1 ff ff       	call   800e2b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c6d:	89 1c 24             	mov    %ebx,(%esp)
  801c70:	e8 78 f7 ff ff       	call   8013ed <fd2data>
  801c75:	83 c4 08             	add    $0x8,%esp
  801c78:	50                   	push   %eax
  801c79:	6a 00                	push   $0x0
  801c7b:	e8 ab f1 ff ff       	call   800e2b <sys_page_unmap>
}
  801c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <_pipeisclosed>:
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	57                   	push   %edi
  801c89:	56                   	push   %esi
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 1c             	sub    $0x1c,%esp
  801c8e:	89 c7                	mov    %eax,%edi
  801c90:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c92:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801c97:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	57                   	push   %edi
  801c9e:	e8 38 09 00 00       	call   8025db <pageref>
  801ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ca6:	89 34 24             	mov    %esi,(%esp)
  801ca9:	e8 2d 09 00 00       	call   8025db <pageref>
		nn = thisenv->env_runs;
  801cae:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801cb4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	39 cb                	cmp    %ecx,%ebx
  801cbc:	74 1b                	je     801cd9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cbe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cc1:	75 cf                	jne    801c92 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cc3:	8b 42 58             	mov    0x58(%edx),%eax
  801cc6:	6a 01                	push   $0x1
  801cc8:	50                   	push   %eax
  801cc9:	53                   	push   %ebx
  801cca:	68 02 2e 80 00       	push   $0x802e02
  801ccf:	e8 3c e6 ff ff       	call   800310 <cprintf>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	eb b9                	jmp    801c92 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cd9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cdc:	0f 94 c0             	sete   %al
  801cdf:	0f b6 c0             	movzbl %al,%eax
}
  801ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    

00801cea <devpipe_write>:
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	57                   	push   %edi
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 28             	sub    $0x28,%esp
  801cf3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cf6:	56                   	push   %esi
  801cf7:	e8 f1 f6 ff ff       	call   8013ed <fd2data>
  801cfc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cfe:	83 c4 10             	add    $0x10,%esp
  801d01:	bf 00 00 00 00       	mov    $0x0,%edi
  801d06:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d09:	74 4f                	je     801d5a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d0b:	8b 43 04             	mov    0x4(%ebx),%eax
  801d0e:	8b 0b                	mov    (%ebx),%ecx
  801d10:	8d 51 20             	lea    0x20(%ecx),%edx
  801d13:	39 d0                	cmp    %edx,%eax
  801d15:	72 14                	jb     801d2b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d17:	89 da                	mov    %ebx,%edx
  801d19:	89 f0                	mov    %esi,%eax
  801d1b:	e8 65 ff ff ff       	call   801c85 <_pipeisclosed>
  801d20:	85 c0                	test   %eax,%eax
  801d22:	75 3a                	jne    801d5e <devpipe_write+0x74>
			sys_yield();
  801d24:	e8 5e f0 ff ff       	call   800d87 <sys_yield>
  801d29:	eb e0                	jmp    801d0b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d2e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d32:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d35:	89 c2                	mov    %eax,%edx
  801d37:	c1 fa 1f             	sar    $0x1f,%edx
  801d3a:	89 d1                	mov    %edx,%ecx
  801d3c:	c1 e9 1b             	shr    $0x1b,%ecx
  801d3f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d42:	83 e2 1f             	and    $0x1f,%edx
  801d45:	29 ca                	sub    %ecx,%edx
  801d47:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d4b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d4f:	83 c0 01             	add    $0x1,%eax
  801d52:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d55:	83 c7 01             	add    $0x1,%edi
  801d58:	eb ac                	jmp    801d06 <devpipe_write+0x1c>
	return i;
  801d5a:	89 f8                	mov    %edi,%eax
  801d5c:	eb 05                	jmp    801d63 <devpipe_write+0x79>
				return 0;
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    

00801d6b <devpipe_read>:
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	57                   	push   %edi
  801d6f:	56                   	push   %esi
  801d70:	53                   	push   %ebx
  801d71:	83 ec 18             	sub    $0x18,%esp
  801d74:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d77:	57                   	push   %edi
  801d78:	e8 70 f6 ff ff       	call   8013ed <fd2data>
  801d7d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	be 00 00 00 00       	mov    $0x0,%esi
  801d87:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d8a:	74 47                	je     801dd3 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d8c:	8b 03                	mov    (%ebx),%eax
  801d8e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d91:	75 22                	jne    801db5 <devpipe_read+0x4a>
			if (i > 0)
  801d93:	85 f6                	test   %esi,%esi
  801d95:	75 14                	jne    801dab <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d97:	89 da                	mov    %ebx,%edx
  801d99:	89 f8                	mov    %edi,%eax
  801d9b:	e8 e5 fe ff ff       	call   801c85 <_pipeisclosed>
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 33                	jne    801dd7 <devpipe_read+0x6c>
			sys_yield();
  801da4:	e8 de ef ff ff       	call   800d87 <sys_yield>
  801da9:	eb e1                	jmp    801d8c <devpipe_read+0x21>
				return i;
  801dab:	89 f0                	mov    %esi,%eax
}
  801dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801db5:	99                   	cltd   
  801db6:	c1 ea 1b             	shr    $0x1b,%edx
  801db9:	01 d0                	add    %edx,%eax
  801dbb:	83 e0 1f             	and    $0x1f,%eax
  801dbe:	29 d0                	sub    %edx,%eax
  801dc0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dcb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dce:	83 c6 01             	add    $0x1,%esi
  801dd1:	eb b4                	jmp    801d87 <devpipe_read+0x1c>
	return i;
  801dd3:	89 f0                	mov    %esi,%eax
  801dd5:	eb d6                	jmp    801dad <devpipe_read+0x42>
				return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddc:	eb cf                	jmp    801dad <devpipe_read+0x42>

00801dde <pipe>:
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	56                   	push   %esi
  801de2:	53                   	push   %ebx
  801de3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de9:	50                   	push   %eax
  801dea:	e8 15 f6 ff ff       	call   801404 <fd_alloc>
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 5b                	js     801e53 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df8:	83 ec 04             	sub    $0x4,%esp
  801dfb:	68 07 04 00 00       	push   $0x407
  801e00:	ff 75 f4             	pushl  -0xc(%ebp)
  801e03:	6a 00                	push   $0x0
  801e05:	e8 9c ef ff ff       	call   800da6 <sys_page_alloc>
  801e0a:	89 c3                	mov    %eax,%ebx
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	78 40                	js     801e53 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e19:	50                   	push   %eax
  801e1a:	e8 e5 f5 ff ff       	call   801404 <fd_alloc>
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	85 c0                	test   %eax,%eax
  801e26:	78 1b                	js     801e43 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	68 07 04 00 00       	push   $0x407
  801e30:	ff 75 f0             	pushl  -0x10(%ebp)
  801e33:	6a 00                	push   $0x0
  801e35:	e8 6c ef ff ff       	call   800da6 <sys_page_alloc>
  801e3a:	89 c3                	mov    %eax,%ebx
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	79 19                	jns    801e5c <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e43:	83 ec 08             	sub    $0x8,%esp
  801e46:	ff 75 f4             	pushl  -0xc(%ebp)
  801e49:	6a 00                	push   $0x0
  801e4b:	e8 db ef ff ff       	call   800e2b <sys_page_unmap>
  801e50:	83 c4 10             	add    $0x10,%esp
}
  801e53:	89 d8                	mov    %ebx,%eax
  801e55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e58:	5b                   	pop    %ebx
  801e59:	5e                   	pop    %esi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    
	va = fd2data(fd0);
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e62:	e8 86 f5 ff ff       	call   8013ed <fd2data>
  801e67:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e69:	83 c4 0c             	add    $0xc,%esp
  801e6c:	68 07 04 00 00       	push   $0x407
  801e71:	50                   	push   %eax
  801e72:	6a 00                	push   $0x0
  801e74:	e8 2d ef ff ff       	call   800da6 <sys_page_alloc>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	0f 88 8c 00 00 00    	js     801f12 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8c:	e8 5c f5 ff ff       	call   8013ed <fd2data>
  801e91:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e98:	50                   	push   %eax
  801e99:	6a 00                	push   $0x0
  801e9b:	56                   	push   %esi
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 46 ef ff ff       	call   800de9 <sys_page_map>
  801ea3:	89 c3                	mov    %eax,%ebx
  801ea5:	83 c4 20             	add    $0x20,%esp
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	78 58                	js     801f04 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801eb5:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801eca:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  801edc:	e8 fc f4 ff ff       	call   8013dd <fd2num>
  801ee1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ee6:	83 c4 04             	add    $0x4,%esp
  801ee9:	ff 75 f0             	pushl  -0x10(%ebp)
  801eec:	e8 ec f4 ff ff       	call   8013dd <fd2num>
  801ef1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eff:	e9 4f ff ff ff       	jmp    801e53 <pipe+0x75>
	sys_page_unmap(0, va);
  801f04:	83 ec 08             	sub    $0x8,%esp
  801f07:	56                   	push   %esi
  801f08:	6a 00                	push   $0x0
  801f0a:	e8 1c ef ff ff       	call   800e2b <sys_page_unmap>
  801f0f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f12:	83 ec 08             	sub    $0x8,%esp
  801f15:	ff 75 f0             	pushl  -0x10(%ebp)
  801f18:	6a 00                	push   $0x0
  801f1a:	e8 0c ef ff ff       	call   800e2b <sys_page_unmap>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	e9 1c ff ff ff       	jmp    801e43 <pipe+0x65>

00801f27 <pipeisclosed>:
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f30:	50                   	push   %eax
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	e8 1a f5 ff ff       	call   801453 <fd_lookup>
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 18                	js     801f58 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	ff 75 f4             	pushl  -0xc(%ebp)
  801f46:	e8 a2 f4 ff ff       	call   8013ed <fd2data>
	return _pipeisclosed(fd, p);
  801f4b:	89 c2                	mov    %eax,%edx
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	e8 30 fd ff ff       	call   801c85 <_pipeisclosed>
  801f55:	83 c4 10             	add    $0x10,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f60:	68 1a 2e 80 00       	push   $0x802e1a
  801f65:	ff 75 0c             	pushl  0xc(%ebp)
  801f68:	e8 40 ea ff ff       	call   8009ad <strcpy>
	return 0;
}
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <devsock_close>:
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	53                   	push   %ebx
  801f78:	83 ec 10             	sub    $0x10,%esp
  801f7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f7e:	53                   	push   %ebx
  801f7f:	e8 57 06 00 00       	call   8025db <pageref>
  801f84:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f87:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f8c:	83 f8 01             	cmp    $0x1,%eax
  801f8f:	74 07                	je     801f98 <devsock_close+0x24>
}
  801f91:	89 d0                	mov    %edx,%eax
  801f93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f98:	83 ec 0c             	sub    $0xc,%esp
  801f9b:	ff 73 0c             	pushl  0xc(%ebx)
  801f9e:	e8 b7 02 00 00       	call   80225a <nsipc_close>
  801fa3:	89 c2                	mov    %eax,%edx
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	eb e7                	jmp    801f91 <devsock_close+0x1d>

00801faa <devsock_write>:
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	ff 75 10             	pushl  0x10(%ebp)
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	ff 70 0c             	pushl  0xc(%eax)
  801fbe:	e8 74 03 00 00       	call   802337 <nsipc_send>
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <devsock_read>:
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fcb:	6a 00                	push   $0x0
  801fcd:	ff 75 10             	pushl  0x10(%ebp)
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	ff 70 0c             	pushl  0xc(%eax)
  801fd9:	e8 ed 02 00 00       	call   8022cb <nsipc_recv>
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <fd2sockid>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fe6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fe9:	52                   	push   %edx
  801fea:	50                   	push   %eax
  801feb:	e8 63 f4 ff ff       	call   801453 <fd_lookup>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 10                	js     802007 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  802000:	39 08                	cmp    %ecx,(%eax)
  802002:	75 05                	jne    802009 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802004:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    
		return -E_NOT_SUPP;
  802009:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80200e:	eb f7                	jmp    802007 <fd2sockid+0x27>

00802010 <alloc_sockfd>:
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	56                   	push   %esi
  802014:	53                   	push   %ebx
  802015:	83 ec 1c             	sub    $0x1c,%esp
  802018:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80201a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201d:	50                   	push   %eax
  80201e:	e8 e1 f3 ff ff       	call   801404 <fd_alloc>
  802023:	89 c3                	mov    %eax,%ebx
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 43                	js     80206f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80202c:	83 ec 04             	sub    $0x4,%esp
  80202f:	68 07 04 00 00       	push   $0x407
  802034:	ff 75 f4             	pushl  -0xc(%ebp)
  802037:	6a 00                	push   $0x0
  802039:	e8 68 ed ff ff       	call   800da6 <sys_page_alloc>
  80203e:	89 c3                	mov    %eax,%ebx
  802040:	83 c4 10             	add    $0x10,%esp
  802043:	85 c0                	test   %eax,%eax
  802045:	78 28                	js     80206f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802050:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80205c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80205f:	83 ec 0c             	sub    $0xc,%esp
  802062:	50                   	push   %eax
  802063:	e8 75 f3 ff ff       	call   8013dd <fd2num>
  802068:	89 c3                	mov    %eax,%ebx
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	eb 0c                	jmp    80207b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	56                   	push   %esi
  802073:	e8 e2 01 00 00       	call   80225a <nsipc_close>
		return r;
  802078:	83 c4 10             	add    $0x10,%esp
}
  80207b:	89 d8                	mov    %ebx,%eax
  80207d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <accept>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	e8 4e ff ff ff       	call   801fe0 <fd2sockid>
  802092:	85 c0                	test   %eax,%eax
  802094:	78 1b                	js     8020b1 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802096:	83 ec 04             	sub    $0x4,%esp
  802099:	ff 75 10             	pushl  0x10(%ebp)
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	50                   	push   %eax
  8020a0:	e8 0e 01 00 00       	call   8021b3 <nsipc_accept>
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	78 05                	js     8020b1 <accept+0x2d>
	return alloc_sockfd(r);
  8020ac:	e8 5f ff ff ff       	call   802010 <alloc_sockfd>
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <bind>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	e8 1f ff ff ff       	call   801fe0 <fd2sockid>
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	78 12                	js     8020d7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	ff 75 10             	pushl  0x10(%ebp)
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	50                   	push   %eax
  8020cf:	e8 2f 01 00 00       	call   802203 <nsipc_bind>
  8020d4:	83 c4 10             	add    $0x10,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <shutdown>:
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	e8 f9 fe ff ff       	call   801fe0 <fd2sockid>
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 0f                	js     8020fa <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020eb:	83 ec 08             	sub    $0x8,%esp
  8020ee:	ff 75 0c             	pushl  0xc(%ebp)
  8020f1:	50                   	push   %eax
  8020f2:	e8 41 01 00 00       	call   802238 <nsipc_shutdown>
  8020f7:	83 c4 10             	add    $0x10,%esp
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <connect>:
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	e8 d6 fe ff ff       	call   801fe0 <fd2sockid>
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 12                	js     802120 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	ff 75 10             	pushl  0x10(%ebp)
  802114:	ff 75 0c             	pushl  0xc(%ebp)
  802117:	50                   	push   %eax
  802118:	e8 57 01 00 00       	call   802274 <nsipc_connect>
  80211d:	83 c4 10             	add    $0x10,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <listen>:
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	e8 b0 fe ff ff       	call   801fe0 <fd2sockid>
  802130:	85 c0                	test   %eax,%eax
  802132:	78 0f                	js     802143 <listen+0x21>
	return nsipc_listen(r, backlog);
  802134:	83 ec 08             	sub    $0x8,%esp
  802137:	ff 75 0c             	pushl  0xc(%ebp)
  80213a:	50                   	push   %eax
  80213b:	e8 69 01 00 00       	call   8022a9 <nsipc_listen>
  802140:	83 c4 10             	add    $0x10,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <socket>:

int
socket(int domain, int type, int protocol)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80214b:	ff 75 10             	pushl  0x10(%ebp)
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	e8 3c 02 00 00       	call   802395 <nsipc_socket>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 05                	js     802165 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802160:	e8 ab fe ff ff       	call   802010 <alloc_sockfd>
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	53                   	push   %ebx
  80216b:	83 ec 04             	sub    $0x4,%esp
  80216e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802170:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  802177:	74 26                	je     80219f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802179:	6a 07                	push   $0x7
  80217b:	68 00 60 80 00       	push   $0x806000
  802180:	53                   	push   %ebx
  802181:	ff 35 08 40 80 00    	pushl  0x804008
  802187:	e8 bf f1 ff ff       	call   80134b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80218c:	83 c4 0c             	add    $0xc,%esp
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	e8 48 f1 ff ff       	call   8012e2 <ipc_recv>
}
  80219a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80219f:	83 ec 0c             	sub    $0xc,%esp
  8021a2:	6a 02                	push   $0x2
  8021a4:	e8 fb f1 ff ff       	call   8013a4 <ipc_find_env>
  8021a9:	a3 08 40 80 00       	mov    %eax,0x804008
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	eb c6                	jmp    802179 <nsipc+0x12>

008021b3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021c3:	8b 06                	mov    (%esi),%eax
  8021c5:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cf:	e8 93 ff ff ff       	call   802167 <nsipc>
  8021d4:	89 c3                	mov    %eax,%ebx
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	78 20                	js     8021fa <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021da:	83 ec 04             	sub    $0x4,%esp
  8021dd:	ff 35 10 60 80 00    	pushl  0x806010
  8021e3:	68 00 60 80 00       	push   $0x806000
  8021e8:	ff 75 0c             	pushl  0xc(%ebp)
  8021eb:	e8 4b e9 ff ff       	call   800b3b <memmove>
		*addrlen = ret->ret_addrlen;
  8021f0:	a1 10 60 80 00       	mov    0x806010,%eax
  8021f5:	89 06                	mov    %eax,(%esi)
  8021f7:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8021fa:	89 d8                	mov    %ebx,%eax
  8021fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ff:	5b                   	pop    %ebx
  802200:	5e                   	pop    %esi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    

00802203 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	53                   	push   %ebx
  802207:	83 ec 08             	sub    $0x8,%esp
  80220a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802215:	53                   	push   %ebx
  802216:	ff 75 0c             	pushl  0xc(%ebp)
  802219:	68 04 60 80 00       	push   $0x806004
  80221e:	e8 18 e9 ff ff       	call   800b3b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802223:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802229:	b8 02 00 00 00       	mov    $0x2,%eax
  80222e:	e8 34 ff ff ff       	call   802167 <nsipc>
}
  802233:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802246:	8b 45 0c             	mov    0xc(%ebp),%eax
  802249:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80224e:	b8 03 00 00 00       	mov    $0x3,%eax
  802253:	e8 0f ff ff ff       	call   802167 <nsipc>
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <nsipc_close>:

int
nsipc_close(int s)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802268:	b8 04 00 00 00       	mov    $0x4,%eax
  80226d:	e8 f5 fe ff ff       	call   802167 <nsipc>
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	53                   	push   %ebx
  802278:	83 ec 08             	sub    $0x8,%esp
  80227b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802286:	53                   	push   %ebx
  802287:	ff 75 0c             	pushl  0xc(%ebp)
  80228a:	68 04 60 80 00       	push   $0x806004
  80228f:	e8 a7 e8 ff ff       	call   800b3b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802294:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80229a:	b8 05 00 00 00       	mov    $0x5,%eax
  80229f:	e8 c3 fe ff ff       	call   802167 <nsipc>
}
  8022a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8022bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8022c4:	e8 9e fe ff ff       	call   802167 <nsipc>
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	56                   	push   %esi
  8022cf:	53                   	push   %ebx
  8022d0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8022db:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8022e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e4:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8022ee:	e8 74 fe ff ff       	call   802167 <nsipc>
  8022f3:	89 c3                	mov    %eax,%ebx
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	78 1f                	js     802318 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022f9:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022fe:	7f 21                	jg     802321 <nsipc_recv+0x56>
  802300:	39 c6                	cmp    %eax,%esi
  802302:	7c 1d                	jl     802321 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	50                   	push   %eax
  802308:	68 00 60 80 00       	push   $0x806000
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	e8 26 e8 ff ff       	call   800b3b <memmove>
  802315:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802318:	89 d8                	mov    %ebx,%eax
  80231a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802321:	68 26 2e 80 00       	push   $0x802e26
  802326:	68 c8 2d 80 00       	push   $0x802dc8
  80232b:	6a 62                	push   $0x62
  80232d:	68 3b 2e 80 00       	push   $0x802e3b
  802332:	e8 fe de ff ff       	call   800235 <_panic>

00802337 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	53                   	push   %ebx
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802349:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80234f:	7f 2e                	jg     80237f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	53                   	push   %ebx
  802355:	ff 75 0c             	pushl  0xc(%ebp)
  802358:	68 0c 60 80 00       	push   $0x80600c
  80235d:	e8 d9 e7 ff ff       	call   800b3b <memmove>
	nsipcbuf.send.req_size = size;
  802362:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802368:	8b 45 14             	mov    0x14(%ebp),%eax
  80236b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802370:	b8 08 00 00 00       	mov    $0x8,%eax
  802375:	e8 ed fd ff ff       	call   802167 <nsipc>
}
  80237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    
	assert(size < 1600);
  80237f:	68 47 2e 80 00       	push   $0x802e47
  802384:	68 c8 2d 80 00       	push   $0x802dc8
  802389:	6a 6d                	push   $0x6d
  80238b:	68 3b 2e 80 00       	push   $0x802e3b
  802390:	e8 a0 de ff ff       	call   800235 <_panic>

00802395 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8023b3:	b8 09 00 00 00       	mov    $0x9,%eax
  8023b8:	e8 aa fd ff ff       	call   802167 <nsipc>
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    

008023c9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023cf:	68 53 2e 80 00       	push   $0x802e53
  8023d4:	ff 75 0c             	pushl  0xc(%ebp)
  8023d7:	e8 d1 e5 ff ff       	call   8009ad <strcpy>
	return 0;
}
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <devcons_write>:
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	57                   	push   %edi
  8023e7:	56                   	push   %esi
  8023e8:	53                   	push   %ebx
  8023e9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023ef:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023f4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023fa:	eb 2f                	jmp    80242b <devcons_write+0x48>
		m = n - tot;
  8023fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023ff:	29 f3                	sub    %esi,%ebx
  802401:	83 fb 7f             	cmp    $0x7f,%ebx
  802404:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802409:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	53                   	push   %ebx
  802410:	89 f0                	mov    %esi,%eax
  802412:	03 45 0c             	add    0xc(%ebp),%eax
  802415:	50                   	push   %eax
  802416:	57                   	push   %edi
  802417:	e8 1f e7 ff ff       	call   800b3b <memmove>
		sys_cputs(buf, m);
  80241c:	83 c4 08             	add    $0x8,%esp
  80241f:	53                   	push   %ebx
  802420:	57                   	push   %edi
  802421:	e8 c4 e8 ff ff       	call   800cea <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802426:	01 de                	add    %ebx,%esi
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80242e:	72 cc                	jb     8023fc <devcons_write+0x19>
}
  802430:	89 f0                	mov    %esi,%eax
  802432:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802435:	5b                   	pop    %ebx
  802436:	5e                   	pop    %esi
  802437:	5f                   	pop    %edi
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    

0080243a <devcons_read>:
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 08             	sub    $0x8,%esp
  802440:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802445:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802449:	75 07                	jne    802452 <devcons_read+0x18>
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    
		sys_yield();
  80244d:	e8 35 e9 ff ff       	call   800d87 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802452:	e8 b1 e8 ff ff       	call   800d08 <sys_cgetc>
  802457:	85 c0                	test   %eax,%eax
  802459:	74 f2                	je     80244d <devcons_read+0x13>
	if (c < 0)
  80245b:	85 c0                	test   %eax,%eax
  80245d:	78 ec                	js     80244b <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80245f:	83 f8 04             	cmp    $0x4,%eax
  802462:	74 0c                	je     802470 <devcons_read+0x36>
	*(char*)vbuf = c;
  802464:	8b 55 0c             	mov    0xc(%ebp),%edx
  802467:	88 02                	mov    %al,(%edx)
	return 1;
  802469:	b8 01 00 00 00       	mov    $0x1,%eax
  80246e:	eb db                	jmp    80244b <devcons_read+0x11>
		return 0;
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
  802475:	eb d4                	jmp    80244b <devcons_read+0x11>

00802477 <cputchar>:
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802483:	6a 01                	push   $0x1
  802485:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802488:	50                   	push   %eax
  802489:	e8 5c e8 ff ff       	call   800cea <sys_cputs>
}
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <getchar>:
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802499:	6a 01                	push   $0x1
  80249b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80249e:	50                   	push   %eax
  80249f:	6a 00                	push   $0x0
  8024a1:	e8 1e f2 ff ff       	call   8016c4 <read>
	if (r < 0)
  8024a6:	83 c4 10             	add    $0x10,%esp
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	78 08                	js     8024b5 <getchar+0x22>
	if (r < 1)
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	7e 06                	jle    8024b7 <getchar+0x24>
	return c;
  8024b1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    
		return -E_EOF;
  8024b7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024bc:	eb f7                	jmp    8024b5 <getchar+0x22>

008024be <iscons>:
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024c7:	50                   	push   %eax
  8024c8:	ff 75 08             	pushl  0x8(%ebp)
  8024cb:	e8 83 ef ff ff       	call   801453 <fd_lookup>
  8024d0:	83 c4 10             	add    $0x10,%esp
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	78 11                	js     8024e8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024e0:	39 10                	cmp    %edx,(%eax)
  8024e2:	0f 94 c0             	sete   %al
  8024e5:	0f b6 c0             	movzbl %al,%eax
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <opencons>:
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f3:	50                   	push   %eax
  8024f4:	e8 0b ef ff ff       	call   801404 <fd_alloc>
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	78 3a                	js     80253a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802500:	83 ec 04             	sub    $0x4,%esp
  802503:	68 07 04 00 00       	push   $0x407
  802508:	ff 75 f4             	pushl  -0xc(%ebp)
  80250b:	6a 00                	push   $0x0
  80250d:	e8 94 e8 ff ff       	call   800da6 <sys_page_alloc>
  802512:	83 c4 10             	add    $0x10,%esp
  802515:	85 c0                	test   %eax,%eax
  802517:	78 21                	js     80253a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802522:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80252e:	83 ec 0c             	sub    $0xc,%esp
  802531:	50                   	push   %eax
  802532:	e8 a6 ee ff ff       	call   8013dd <fd2num>
  802537:	83 c4 10             	add    $0x10,%esp
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802542:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802549:	74 0a                	je     802555 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802555:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80255a:	8b 40 48             	mov    0x48(%eax),%eax
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	6a 07                	push   $0x7
  802562:	68 00 f0 bf ee       	push   $0xeebff000
  802567:	50                   	push   %eax
  802568:	e8 39 e8 ff ff       	call   800da6 <sys_page_alloc>
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	85 c0                	test   %eax,%eax
  802572:	75 2f                	jne    8025a3 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802574:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802579:	8b 40 48             	mov    0x48(%eax),%eax
  80257c:	83 ec 08             	sub    $0x8,%esp
  80257f:	68 b5 25 80 00       	push   $0x8025b5
  802584:	50                   	push   %eax
  802585:	e8 67 e9 ff ff       	call   800ef1 <sys_env_set_pgfault_upcall>
  80258a:	83 c4 10             	add    $0x10,%esp
  80258d:	85 c0                	test   %eax,%eax
  80258f:	74 ba                	je     80254b <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  802591:	50                   	push   %eax
  802592:	68 5f 2e 80 00       	push   $0x802e5f
  802597:	6a 24                	push   $0x24
  802599:	68 77 2e 80 00       	push   $0x802e77
  80259e:	e8 92 dc ff ff       	call   800235 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8025a3:	50                   	push   %eax
  8025a4:	68 5f 2e 80 00       	push   $0x802e5f
  8025a9:	6a 21                	push   $0x21
  8025ab:	68 77 2e 80 00       	push   $0x802e77
  8025b0:	e8 80 dc ff ff       	call   800235 <_panic>

008025b5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025b5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025b6:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025bb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025bd:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8025c0:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8025c4:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8025c7:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8025cb:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8025cf:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8025d1:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  8025d4:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8025d5:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8025d8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8025d9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8025da:	c3                   	ret    

008025db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025e1:	89 d0                	mov    %edx,%eax
  8025e3:	c1 e8 16             	shr    $0x16,%eax
  8025e6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025f2:	f6 c1 01             	test   $0x1,%cl
  8025f5:	74 1d                	je     802614 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025f7:	c1 ea 0c             	shr    $0xc,%edx
  8025fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802601:	f6 c2 01             	test   $0x1,%dl
  802604:	74 0e                	je     802614 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802606:	c1 ea 0c             	shr    $0xc,%edx
  802609:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802610:	ef 
  802611:	0f b7 c0             	movzwl %ax,%eax
}
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	66 90                	xchg   %ax,%ax
  802618:	66 90                	xchg   %ax,%ax
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <__udivdi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 1c             	sub    $0x1c,%esp
  802627:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80262b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80262f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802633:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802637:	85 d2                	test   %edx,%edx
  802639:	75 35                	jne    802670 <__udivdi3+0x50>
  80263b:	39 f3                	cmp    %esi,%ebx
  80263d:	0f 87 bd 00 00 00    	ja     802700 <__udivdi3+0xe0>
  802643:	85 db                	test   %ebx,%ebx
  802645:	89 d9                	mov    %ebx,%ecx
  802647:	75 0b                	jne    802654 <__udivdi3+0x34>
  802649:	b8 01 00 00 00       	mov    $0x1,%eax
  80264e:	31 d2                	xor    %edx,%edx
  802650:	f7 f3                	div    %ebx
  802652:	89 c1                	mov    %eax,%ecx
  802654:	31 d2                	xor    %edx,%edx
  802656:	89 f0                	mov    %esi,%eax
  802658:	f7 f1                	div    %ecx
  80265a:	89 c6                	mov    %eax,%esi
  80265c:	89 e8                	mov    %ebp,%eax
  80265e:	89 f7                	mov    %esi,%edi
  802660:	f7 f1                	div    %ecx
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 1c             	add    $0x1c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
  80266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802670:	39 f2                	cmp    %esi,%edx
  802672:	77 7c                	ja     8026f0 <__udivdi3+0xd0>
  802674:	0f bd fa             	bsr    %edx,%edi
  802677:	83 f7 1f             	xor    $0x1f,%edi
  80267a:	0f 84 98 00 00 00    	je     802718 <__udivdi3+0xf8>
  802680:	89 f9                	mov    %edi,%ecx
  802682:	b8 20 00 00 00       	mov    $0x20,%eax
  802687:	29 f8                	sub    %edi,%eax
  802689:	d3 e2                	shl    %cl,%edx
  80268b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	89 da                	mov    %ebx,%edx
  802693:	d3 ea                	shr    %cl,%edx
  802695:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802699:	09 d1                	or     %edx,%ecx
  80269b:	89 f2                	mov    %esi,%edx
  80269d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a1:	89 f9                	mov    %edi,%ecx
  8026a3:	d3 e3                	shl    %cl,%ebx
  8026a5:	89 c1                	mov    %eax,%ecx
  8026a7:	d3 ea                	shr    %cl,%edx
  8026a9:	89 f9                	mov    %edi,%ecx
  8026ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026af:	d3 e6                	shl    %cl,%esi
  8026b1:	89 eb                	mov    %ebp,%ebx
  8026b3:	89 c1                	mov    %eax,%ecx
  8026b5:	d3 eb                	shr    %cl,%ebx
  8026b7:	09 de                	or     %ebx,%esi
  8026b9:	89 f0                	mov    %esi,%eax
  8026bb:	f7 74 24 08          	divl   0x8(%esp)
  8026bf:	89 d6                	mov    %edx,%esi
  8026c1:	89 c3                	mov    %eax,%ebx
  8026c3:	f7 64 24 0c          	mull   0xc(%esp)
  8026c7:	39 d6                	cmp    %edx,%esi
  8026c9:	72 0c                	jb     8026d7 <__udivdi3+0xb7>
  8026cb:	89 f9                	mov    %edi,%ecx
  8026cd:	d3 e5                	shl    %cl,%ebp
  8026cf:	39 c5                	cmp    %eax,%ebp
  8026d1:	73 5d                	jae    802730 <__udivdi3+0x110>
  8026d3:	39 d6                	cmp    %edx,%esi
  8026d5:	75 59                	jne    802730 <__udivdi3+0x110>
  8026d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026da:	31 ff                	xor    %edi,%edi
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d 76 00             	lea    0x0(%esi),%esi
  8026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8026f0:	31 ff                	xor    %edi,%edi
  8026f2:	31 c0                	xor    %eax,%eax
  8026f4:	89 fa                	mov    %edi,%edx
  8026f6:	83 c4 1c             	add    $0x1c,%esp
  8026f9:	5b                   	pop    %ebx
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    
  8026fe:	66 90                	xchg   %ax,%ax
  802700:	31 ff                	xor    %edi,%edi
  802702:	89 e8                	mov    %ebp,%eax
  802704:	89 f2                	mov    %esi,%edx
  802706:	f7 f3                	div    %ebx
  802708:	89 fa                	mov    %edi,%edx
  80270a:	83 c4 1c             	add    $0x1c,%esp
  80270d:	5b                   	pop    %ebx
  80270e:	5e                   	pop    %esi
  80270f:	5f                   	pop    %edi
  802710:	5d                   	pop    %ebp
  802711:	c3                   	ret    
  802712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802718:	39 f2                	cmp    %esi,%edx
  80271a:	72 06                	jb     802722 <__udivdi3+0x102>
  80271c:	31 c0                	xor    %eax,%eax
  80271e:	39 eb                	cmp    %ebp,%ebx
  802720:	77 d2                	ja     8026f4 <__udivdi3+0xd4>
  802722:	b8 01 00 00 00       	mov    $0x1,%eax
  802727:	eb cb                	jmp    8026f4 <__udivdi3+0xd4>
  802729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802730:	89 d8                	mov    %ebx,%eax
  802732:	31 ff                	xor    %edi,%edi
  802734:	eb be                	jmp    8026f4 <__udivdi3+0xd4>
  802736:	66 90                	xchg   %ax,%ax
  802738:	66 90                	xchg   %ax,%ax
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__umoddi3>:
  802740:	55                   	push   %ebp
  802741:	57                   	push   %edi
  802742:	56                   	push   %esi
  802743:	53                   	push   %ebx
  802744:	83 ec 1c             	sub    $0x1c,%esp
  802747:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80274b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80274f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802757:	85 ed                	test   %ebp,%ebp
  802759:	89 f0                	mov    %esi,%eax
  80275b:	89 da                	mov    %ebx,%edx
  80275d:	75 19                	jne    802778 <__umoddi3+0x38>
  80275f:	39 df                	cmp    %ebx,%edi
  802761:	0f 86 b1 00 00 00    	jbe    802818 <__umoddi3+0xd8>
  802767:	f7 f7                	div    %edi
  802769:	89 d0                	mov    %edx,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	39 dd                	cmp    %ebx,%ebp
  80277a:	77 f1                	ja     80276d <__umoddi3+0x2d>
  80277c:	0f bd cd             	bsr    %ebp,%ecx
  80277f:	83 f1 1f             	xor    $0x1f,%ecx
  802782:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802786:	0f 84 b4 00 00 00    	je     802840 <__umoddi3+0x100>
  80278c:	b8 20 00 00 00       	mov    $0x20,%eax
  802791:	89 c2                	mov    %eax,%edx
  802793:	8b 44 24 04          	mov    0x4(%esp),%eax
  802797:	29 c2                	sub    %eax,%edx
  802799:	89 c1                	mov    %eax,%ecx
  80279b:	89 f8                	mov    %edi,%eax
  80279d:	d3 e5                	shl    %cl,%ebp
  80279f:	89 d1                	mov    %edx,%ecx
  8027a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027a5:	d3 e8                	shr    %cl,%eax
  8027a7:	09 c5                	or     %eax,%ebp
  8027a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027ad:	89 c1                	mov    %eax,%ecx
  8027af:	d3 e7                	shl    %cl,%edi
  8027b1:	89 d1                	mov    %edx,%ecx
  8027b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027b7:	89 df                	mov    %ebx,%edi
  8027b9:	d3 ef                	shr    %cl,%edi
  8027bb:	89 c1                	mov    %eax,%ecx
  8027bd:	89 f0                	mov    %esi,%eax
  8027bf:	d3 e3                	shl    %cl,%ebx
  8027c1:	89 d1                	mov    %edx,%ecx
  8027c3:	89 fa                	mov    %edi,%edx
  8027c5:	d3 e8                	shr    %cl,%eax
  8027c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027cc:	09 d8                	or     %ebx,%eax
  8027ce:	f7 f5                	div    %ebp
  8027d0:	d3 e6                	shl    %cl,%esi
  8027d2:	89 d1                	mov    %edx,%ecx
  8027d4:	f7 64 24 08          	mull   0x8(%esp)
  8027d8:	39 d1                	cmp    %edx,%ecx
  8027da:	89 c3                	mov    %eax,%ebx
  8027dc:	89 d7                	mov    %edx,%edi
  8027de:	72 06                	jb     8027e6 <__umoddi3+0xa6>
  8027e0:	75 0e                	jne    8027f0 <__umoddi3+0xb0>
  8027e2:	39 c6                	cmp    %eax,%esi
  8027e4:	73 0a                	jae    8027f0 <__umoddi3+0xb0>
  8027e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8027ea:	19 ea                	sbb    %ebp,%edx
  8027ec:	89 d7                	mov    %edx,%edi
  8027ee:	89 c3                	mov    %eax,%ebx
  8027f0:	89 ca                	mov    %ecx,%edx
  8027f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8027f7:	29 de                	sub    %ebx,%esi
  8027f9:	19 fa                	sbb    %edi,%edx
  8027fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8027ff:	89 d0                	mov    %edx,%eax
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 d9                	mov    %ebx,%ecx
  802805:	d3 ee                	shr    %cl,%esi
  802807:	d3 ea                	shr    %cl,%edx
  802809:	09 f0                	or     %esi,%eax
  80280b:	83 c4 1c             	add    $0x1c,%esp
  80280e:	5b                   	pop    %ebx
  80280f:	5e                   	pop    %esi
  802810:	5f                   	pop    %edi
  802811:	5d                   	pop    %ebp
  802812:	c3                   	ret    
  802813:	90                   	nop
  802814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802818:	85 ff                	test   %edi,%edi
  80281a:	89 f9                	mov    %edi,%ecx
  80281c:	75 0b                	jne    802829 <__umoddi3+0xe9>
  80281e:	b8 01 00 00 00       	mov    $0x1,%eax
  802823:	31 d2                	xor    %edx,%edx
  802825:	f7 f7                	div    %edi
  802827:	89 c1                	mov    %eax,%ecx
  802829:	89 d8                	mov    %ebx,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	f7 f1                	div    %ecx
  80282f:	89 f0                	mov    %esi,%eax
  802831:	f7 f1                	div    %ecx
  802833:	e9 31 ff ff ff       	jmp    802769 <__umoddi3+0x29>
  802838:	90                   	nop
  802839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802840:	39 dd                	cmp    %ebx,%ebp
  802842:	72 08                	jb     80284c <__umoddi3+0x10c>
  802844:	39 f7                	cmp    %esi,%edi
  802846:	0f 87 21 ff ff ff    	ja     80276d <__umoddi3+0x2d>
  80284c:	89 da                	mov    %ebx,%edx
  80284e:	89 f0                	mov    %esi,%eax
  802850:	29 f8                	sub    %edi,%eax
  802852:	19 ea                	sbb    %ebp,%edx
  802854:	e9 14 ff ff ff       	jmp    80276d <__umoddi3+0x2d>
