
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 20 12 f0       	mov    $0xf0122000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 8c 92 2c f0 00 	cmpl   $0x0,0xf02c928c
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 1d 09 00 00       	call   f0100978 <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 8c 92 2c f0    	mov    %esi,0xf02c928c
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 37 5e 00 00       	call   f0105ea7 <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 a0 6b 10 f0       	push   $0xf0106ba0
f010007c:	e8 cb 38 00 00       	call   f010394c <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 9b 38 00 00       	call   f0103926 <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 29 6f 10 f0 	movl   $0xf0106f29,(%esp)
f0100092:	e8 b5 38 00 00       	call   f010394c <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 c7 05 00 00       	call   f010066f <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	68 ac 1a 00 00       	push   $0x1aac
f01000b0:	68 0c 6c 10 f0       	push   $0xf0106c0c
f01000b5:	e8 92 38 00 00       	call   f010394c <cprintf>
	mem_init();
f01000ba:	e8 33 13 00 00       	call   f01013f2 <mem_init>
	env_init();
f01000bf:	e8 09 31 00 00       	call   f01031cd <env_init>
	trap_init();
f01000c4:	e8 76 39 00 00       	call   f0103a3f <trap_init>
	mp_init();
f01000c9:	e8 c7 5a 00 00       	call   f0105b95 <mp_init>
	lapic_init();
f01000ce:	e8 ee 5d 00 00       	call   f0105ec1 <lapic_init>
	pic_init();
f01000d3:	e8 81 37 00 00       	call   f0103859 <pic_init>
	time_init();
f01000d8:	e8 30 68 00 00       	call   f010690d <time_init>
	pci_init();
f01000dd:	e8 0b 68 00 00       	call   f01068ed <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000e2:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f01000e9:	e8 29 60 00 00       	call   f0106117 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000ee:	83 c4 10             	add    $0x10,%esp
f01000f1:	83 3d 94 92 2c f0 07 	cmpl   $0x7,0xf02c9294
f01000f8:	76 27                	jbe    f0100121 <i386_init+0x85>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000fa:	83 ec 04             	sub    $0x4,%esp
f01000fd:	b8 fa 5a 10 f0       	mov    $0xf0105afa,%eax
f0100102:	2d 80 5a 10 f0       	sub    $0xf0105a80,%eax
f0100107:	50                   	push   %eax
f0100108:	68 80 5a 10 f0       	push   $0xf0105a80
f010010d:	68 00 70 00 f0       	push   $0xf0007000
f0100112:	e8 ba 57 00 00       	call   f01058d1 <memmove>
f0100117:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f010011a:	bb 20 a0 2c f0       	mov    $0xf02ca020,%ebx
f010011f:	eb 19                	jmp    f010013a <i386_init+0x9e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100121:	68 00 70 00 00       	push   $0x7000
f0100126:	68 c4 6b 10 f0       	push   $0xf0106bc4
f010012b:	6a 61                	push   $0x61
f010012d:	68 27 6c 10 f0       	push   $0xf0106c27
f0100132:	e8 09 ff ff ff       	call   f0100040 <_panic>
f0100137:	83 c3 74             	add    $0x74,%ebx
f010013a:	6b 05 c4 a3 2c f0 74 	imul   $0x74,0xf02ca3c4,%eax
f0100141:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0100146:	39 c3                	cmp    %eax,%ebx
f0100148:	73 4c                	jae    f0100196 <i386_init+0xfa>
		if (c == cpus + cpunum())  // We've started already.
f010014a:	e8 58 5d 00 00       	call   f0105ea7 <cpunum>
f010014f:	6b c0 74             	imul   $0x74,%eax,%eax
f0100152:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0100157:	39 c3                	cmp    %eax,%ebx
f0100159:	74 dc                	je     f0100137 <i386_init+0x9b>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010015b:	89 d8                	mov    %ebx,%eax
f010015d:	2d 20 a0 2c f0       	sub    $0xf02ca020,%eax
f0100162:	c1 f8 02             	sar    $0x2,%eax
f0100165:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010016b:	c1 e0 0f             	shl    $0xf,%eax
f010016e:	05 00 30 2d f0       	add    $0xf02d3000,%eax
f0100173:	a3 90 92 2c f0       	mov    %eax,0xf02c9290
		lapic_startap(c->cpu_id, PADDR(code));
f0100178:	83 ec 08             	sub    $0x8,%esp
f010017b:	68 00 70 00 00       	push   $0x7000
f0100180:	0f b6 03             	movzbl (%ebx),%eax
f0100183:	50                   	push   %eax
f0100184:	e8 89 5e 00 00       	call   f0106012 <lapic_startap>
f0100189:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f010018c:	8b 43 04             	mov    0x4(%ebx),%eax
f010018f:	83 f8 01             	cmp    $0x1,%eax
f0100192:	75 f8                	jne    f010018c <i386_init+0xf0>
f0100194:	eb a1                	jmp    f0100137 <i386_init+0x9b>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100196:	83 ec 08             	sub    $0x8,%esp
f0100199:	6a 01                	push   $0x1
f010019b:	68 a8 cd 1d f0       	push   $0xf01dcda8
f01001a0:	e8 cd 31 00 00       	call   f0103372 <env_create>
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f01001a5:	83 c4 08             	add    $0x8,%esp
f01001a8:	6a 02                	push   $0x2
f01001aa:	68 c4 62 23 f0       	push   $0xf02362c4
f01001af:	e8 be 31 00 00       	call   f0103372 <env_create>
	ENV_CREATE(user_icode, ENV_TYPE_USER);
f01001b4:	83 c4 08             	add    $0x8,%esp
f01001b7:	6a 00                	push   $0x0
f01001b9:	68 88 6c 1d f0       	push   $0xf01d6c88
f01001be:	e8 af 31 00 00       	call   f0103372 <env_create>
	kbd_intr();
f01001c3:	e8 4c 04 00 00       	call   f0100614 <kbd_intr>
	sched_yield();
f01001c8:	e8 ee 43 00 00       	call   f01045bb <sched_yield>

f01001cd <mp_main>:
{
f01001cd:	55                   	push   %ebp
f01001ce:	89 e5                	mov    %esp,%ebp
f01001d0:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001d3:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
	if ((uint32_t)kva < KERNBASE)
f01001d8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001dd:	77 12                	ja     f01001f1 <mp_main+0x24>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01001df:	50                   	push   %eax
f01001e0:	68 e8 6b 10 f0       	push   $0xf0106be8
f01001e5:	6a 78                	push   $0x78
f01001e7:	68 27 6c 10 f0       	push   $0xf0106c27
f01001ec:	e8 4f fe ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01001f1:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001f6:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001f9:	e8 a9 5c 00 00       	call   f0105ea7 <cpunum>
f01001fe:	83 ec 08             	sub    $0x8,%esp
f0100201:	50                   	push   %eax
f0100202:	68 33 6c 10 f0       	push   $0xf0106c33
f0100207:	e8 40 37 00 00       	call   f010394c <cprintf>
	lapic_init();
f010020c:	e8 b0 5c 00 00       	call   f0105ec1 <lapic_init>
	env_init_percpu();
f0100211:	e8 87 2f 00 00       	call   f010319d <env_init_percpu>
	trap_init_percpu();
f0100216:	e8 45 37 00 00       	call   f0103960 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f010021b:	e8 87 5c 00 00       	call   f0105ea7 <cpunum>
f0100220:	6b d0 74             	imul   $0x74,%eax,%edx
f0100223:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100226:	b8 01 00 00 00       	mov    $0x1,%eax
f010022b:	f0 87 82 20 a0 2c f0 	lock xchg %eax,-0xfd35fe0(%edx)
f0100232:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f0100239:	e8 d9 5e 00 00       	call   f0106117 <spin_lock>
	sched_yield();
f010023e:	e8 78 43 00 00       	call   f01045bb <sched_yield>

f0100243 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100243:	55                   	push   %ebp
f0100244:	89 e5                	mov    %esp,%ebp
f0100246:	53                   	push   %ebx
f0100247:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010024a:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010024d:	ff 75 0c             	pushl  0xc(%ebp)
f0100250:	ff 75 08             	pushl  0x8(%ebp)
f0100253:	68 49 6c 10 f0       	push   $0xf0106c49
f0100258:	e8 ef 36 00 00       	call   f010394c <cprintf>
	vcprintf(fmt, ap);
f010025d:	83 c4 08             	add    $0x8,%esp
f0100260:	53                   	push   %ebx
f0100261:	ff 75 10             	pushl  0x10(%ebp)
f0100264:	e8 bd 36 00 00       	call   f0103926 <vcprintf>
	cprintf("\n");
f0100269:	c7 04 24 29 6f 10 f0 	movl   $0xf0106f29,(%esp)
f0100270:	e8 d7 36 00 00       	call   f010394c <cprintf>
	va_end(ap);
}
f0100275:	83 c4 10             	add    $0x10,%esp
f0100278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010027b:	c9                   	leave  
f010027c:	c3                   	ret    

f010027d <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010027d:	55                   	push   %ebp
f010027e:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100280:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100285:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100286:	a8 01                	test   $0x1,%al
f0100288:	74 0b                	je     f0100295 <serial_proc_data+0x18>
f010028a:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010028f:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100290:	0f b6 c0             	movzbl %al,%eax
}
f0100293:	5d                   	pop    %ebp
f0100294:	c3                   	ret    
		return -1;
f0100295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010029a:	eb f7                	jmp    f0100293 <serial_proc_data+0x16>

f010029c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010029c:	55                   	push   %ebp
f010029d:	89 e5                	mov    %esp,%ebp
f010029f:	53                   	push   %ebx
f01002a0:	83 ec 04             	sub    $0x4,%esp
f01002a3:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002a5:	ff d3                	call   *%ebx
f01002a7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002aa:	74 2d                	je     f01002d9 <cons_intr+0x3d>
		if (c == 0)
f01002ac:	85 c0                	test   %eax,%eax
f01002ae:	74 f5                	je     f01002a5 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002b0:	8b 0d 24 02 2b f0    	mov    0xf02b0224,%ecx
f01002b6:	8d 51 01             	lea    0x1(%ecx),%edx
f01002b9:	89 15 24 02 2b f0    	mov    %edx,0xf02b0224
f01002bf:	88 81 20 00 2b f0    	mov    %al,-0xfd4ffe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002c5:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01002cb:	75 d8                	jne    f01002a5 <cons_intr+0x9>
			cons.wpos = 0;
f01002cd:	c7 05 24 02 2b f0 00 	movl   $0x0,0xf02b0224
f01002d4:	00 00 00 
f01002d7:	eb cc                	jmp    f01002a5 <cons_intr+0x9>
	}
}
f01002d9:	83 c4 04             	add    $0x4,%esp
f01002dc:	5b                   	pop    %ebx
f01002dd:	5d                   	pop    %ebp
f01002de:	c3                   	ret    

f01002df <kbd_proc_data>:
{
f01002df:	55                   	push   %ebp
f01002e0:	89 e5                	mov    %esp,%ebp
f01002e2:	53                   	push   %ebx
f01002e3:	83 ec 04             	sub    $0x4,%esp
f01002e6:	ba 64 00 00 00       	mov    $0x64,%edx
f01002eb:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002ec:	a8 01                	test   $0x1,%al
f01002ee:	0f 84 fa 00 00 00    	je     f01003ee <kbd_proc_data+0x10f>
	if (stat & KBS_TERR)
f01002f4:	a8 20                	test   $0x20,%al
f01002f6:	0f 85 f9 00 00 00    	jne    f01003f5 <kbd_proc_data+0x116>
f01002fc:	ba 60 00 00 00       	mov    $0x60,%edx
f0100301:	ec                   	in     (%dx),%al
f0100302:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100304:	3c e0                	cmp    $0xe0,%al
f0100306:	0f 84 8e 00 00 00    	je     f010039a <kbd_proc_data+0xbb>
	} else if (data & 0x80) {
f010030c:	84 c0                	test   %al,%al
f010030e:	0f 88 99 00 00 00    	js     f01003ad <kbd_proc_data+0xce>
	} else if (shift & E0ESC) {
f0100314:	8b 0d 00 00 2b f0    	mov    0xf02b0000,%ecx
f010031a:	f6 c1 40             	test   $0x40,%cl
f010031d:	74 0e                	je     f010032d <kbd_proc_data+0x4e>
		data |= 0x80;
f010031f:	83 c8 80             	or     $0xffffff80,%eax
f0100322:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100324:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100327:	89 0d 00 00 2b f0    	mov    %ecx,0xf02b0000
	shift |= shiftcode[data];
f010032d:	0f b6 d2             	movzbl %dl,%edx
f0100330:	0f b6 82 c0 6d 10 f0 	movzbl -0xfef9240(%edx),%eax
f0100337:	0b 05 00 00 2b f0    	or     0xf02b0000,%eax
	shift ^= togglecode[data];
f010033d:	0f b6 8a c0 6c 10 f0 	movzbl -0xfef9340(%edx),%ecx
f0100344:	31 c8                	xor    %ecx,%eax
f0100346:	a3 00 00 2b f0       	mov    %eax,0xf02b0000
	c = charcode[shift & (CTL | SHIFT)][data];
f010034b:	89 c1                	mov    %eax,%ecx
f010034d:	83 e1 03             	and    $0x3,%ecx
f0100350:	8b 0c 8d a0 6c 10 f0 	mov    -0xfef9360(,%ecx,4),%ecx
f0100357:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010035b:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010035e:	a8 08                	test   $0x8,%al
f0100360:	74 0d                	je     f010036f <kbd_proc_data+0x90>
		if ('a' <= c && c <= 'z')
f0100362:	89 da                	mov    %ebx,%edx
f0100364:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100367:	83 f9 19             	cmp    $0x19,%ecx
f010036a:	77 74                	ja     f01003e0 <kbd_proc_data+0x101>
			c += 'A' - 'a';
f010036c:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010036f:	f7 d0                	not    %eax
f0100371:	a8 06                	test   $0x6,%al
f0100373:	75 31                	jne    f01003a6 <kbd_proc_data+0xc7>
f0100375:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010037b:	75 29                	jne    f01003a6 <kbd_proc_data+0xc7>
		cprintf("Rebooting!\n");
f010037d:	83 ec 0c             	sub    $0xc,%esp
f0100380:	68 63 6c 10 f0       	push   $0xf0106c63
f0100385:	e8 c2 35 00 00       	call   f010394c <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010038a:	b8 03 00 00 00       	mov    $0x3,%eax
f010038f:	ba 92 00 00 00       	mov    $0x92,%edx
f0100394:	ee                   	out    %al,(%dx)
f0100395:	83 c4 10             	add    $0x10,%esp
f0100398:	eb 0c                	jmp    f01003a6 <kbd_proc_data+0xc7>
		shift |= E0ESC;
f010039a:	83 0d 00 00 2b f0 40 	orl    $0x40,0xf02b0000
		return 0;
f01003a1:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01003a6:	89 d8                	mov    %ebx,%eax
f01003a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01003ab:	c9                   	leave  
f01003ac:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003ad:	8b 0d 00 00 2b f0    	mov    0xf02b0000,%ecx
f01003b3:	89 cb                	mov    %ecx,%ebx
f01003b5:	83 e3 40             	and    $0x40,%ebx
f01003b8:	83 e0 7f             	and    $0x7f,%eax
f01003bb:	85 db                	test   %ebx,%ebx
f01003bd:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003c0:	0f b6 d2             	movzbl %dl,%edx
f01003c3:	0f b6 82 c0 6d 10 f0 	movzbl -0xfef9240(%edx),%eax
f01003ca:	83 c8 40             	or     $0x40,%eax
f01003cd:	0f b6 c0             	movzbl %al,%eax
f01003d0:	f7 d0                	not    %eax
f01003d2:	21 c8                	and    %ecx,%eax
f01003d4:	a3 00 00 2b f0       	mov    %eax,0xf02b0000
		return 0;
f01003d9:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003de:	eb c6                	jmp    f01003a6 <kbd_proc_data+0xc7>
		else if ('A' <= c && c <= 'Z')
f01003e0:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003e3:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003e6:	83 fa 1a             	cmp    $0x1a,%edx
f01003e9:	0f 42 d9             	cmovb  %ecx,%ebx
f01003ec:	eb 81                	jmp    f010036f <kbd_proc_data+0x90>
		return -1;
f01003ee:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003f3:	eb b1                	jmp    f01003a6 <kbd_proc_data+0xc7>
		return -1;
f01003f5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003fa:	eb aa                	jmp    f01003a6 <kbd_proc_data+0xc7>

f01003fc <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003fc:	55                   	push   %ebp
f01003fd:	89 e5                	mov    %esp,%ebp
f01003ff:	57                   	push   %edi
f0100400:	56                   	push   %esi
f0100401:	53                   	push   %ebx
f0100402:	83 ec 1c             	sub    $0x1c,%esp
f0100405:	89 c7                	mov    %eax,%edi
	for (i = 0;
f0100407:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010040c:	be fd 03 00 00       	mov    $0x3fd,%esi
f0100411:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100416:	eb 09                	jmp    f0100421 <cons_putc+0x25>
f0100418:	89 ca                	mov    %ecx,%edx
f010041a:	ec                   	in     (%dx),%al
f010041b:	ec                   	in     (%dx),%al
f010041c:	ec                   	in     (%dx),%al
f010041d:	ec                   	in     (%dx),%al
	     i++)
f010041e:	83 c3 01             	add    $0x1,%ebx
f0100421:	89 f2                	mov    %esi,%edx
f0100423:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100424:	a8 20                	test   $0x20,%al
f0100426:	75 08                	jne    f0100430 <cons_putc+0x34>
f0100428:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010042e:	7e e8                	jle    f0100418 <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f0100430:	89 f8                	mov    %edi,%eax
f0100432:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100435:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010043a:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010043b:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100440:	be 79 03 00 00       	mov    $0x379,%esi
f0100445:	b9 84 00 00 00       	mov    $0x84,%ecx
f010044a:	eb 09                	jmp    f0100455 <cons_putc+0x59>
f010044c:	89 ca                	mov    %ecx,%edx
f010044e:	ec                   	in     (%dx),%al
f010044f:	ec                   	in     (%dx),%al
f0100450:	ec                   	in     (%dx),%al
f0100451:	ec                   	in     (%dx),%al
f0100452:	83 c3 01             	add    $0x1,%ebx
f0100455:	89 f2                	mov    %esi,%edx
f0100457:	ec                   	in     (%dx),%al
f0100458:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010045e:	7f 04                	jg     f0100464 <cons_putc+0x68>
f0100460:	84 c0                	test   %al,%al
f0100462:	79 e8                	jns    f010044c <cons_putc+0x50>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100464:	ba 78 03 00 00       	mov    $0x378,%edx
f0100469:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f010046d:	ee                   	out    %al,(%dx)
f010046e:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100473:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100478:	ee                   	out    %al,(%dx)
f0100479:	b8 08 00 00 00       	mov    $0x8,%eax
f010047e:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010047f:	89 fa                	mov    %edi,%edx
f0100481:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100487:	89 f8                	mov    %edi,%eax
f0100489:	80 cc 07             	or     $0x7,%ah
f010048c:	85 d2                	test   %edx,%edx
f010048e:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f0100491:	89 f8                	mov    %edi,%eax
f0100493:	0f b6 c0             	movzbl %al,%eax
f0100496:	83 f8 09             	cmp    $0x9,%eax
f0100499:	0f 84 b6 00 00 00    	je     f0100555 <cons_putc+0x159>
f010049f:	83 f8 09             	cmp    $0x9,%eax
f01004a2:	7e 73                	jle    f0100517 <cons_putc+0x11b>
f01004a4:	83 f8 0a             	cmp    $0xa,%eax
f01004a7:	0f 84 9b 00 00 00    	je     f0100548 <cons_putc+0x14c>
f01004ad:	83 f8 0d             	cmp    $0xd,%eax
f01004b0:	0f 85 d6 00 00 00    	jne    f010058c <cons_putc+0x190>
		crt_pos -= (crt_pos % CRT_COLS);
f01004b6:	0f b7 05 28 02 2b f0 	movzwl 0xf02b0228,%eax
f01004bd:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004c3:	c1 e8 16             	shr    $0x16,%eax
f01004c6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004c9:	c1 e0 04             	shl    $0x4,%eax
f01004cc:	66 a3 28 02 2b f0    	mov    %ax,0xf02b0228
	if (crt_pos >= CRT_SIZE) {
f01004d2:	66 81 3d 28 02 2b f0 	cmpw   $0x7cf,0xf02b0228
f01004d9:	cf 07 
f01004db:	0f 87 ce 00 00 00    	ja     f01005af <cons_putc+0x1b3>
	outb(addr_6845, 14);
f01004e1:	8b 0d 30 02 2b f0    	mov    0xf02b0230,%ecx
f01004e7:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004ec:	89 ca                	mov    %ecx,%edx
f01004ee:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004ef:	0f b7 1d 28 02 2b f0 	movzwl 0xf02b0228,%ebx
f01004f6:	8d 71 01             	lea    0x1(%ecx),%esi
f01004f9:	89 d8                	mov    %ebx,%eax
f01004fb:	66 c1 e8 08          	shr    $0x8,%ax
f01004ff:	89 f2                	mov    %esi,%edx
f0100501:	ee                   	out    %al,(%dx)
f0100502:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100507:	89 ca                	mov    %ecx,%edx
f0100509:	ee                   	out    %al,(%dx)
f010050a:	89 d8                	mov    %ebx,%eax
f010050c:	89 f2                	mov    %esi,%edx
f010050e:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010050f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100512:	5b                   	pop    %ebx
f0100513:	5e                   	pop    %esi
f0100514:	5f                   	pop    %edi
f0100515:	5d                   	pop    %ebp
f0100516:	c3                   	ret    
	switch (c & 0xff) {
f0100517:	83 f8 08             	cmp    $0x8,%eax
f010051a:	75 70                	jne    f010058c <cons_putc+0x190>
		if (crt_pos > 0) {
f010051c:	0f b7 05 28 02 2b f0 	movzwl 0xf02b0228,%eax
f0100523:	66 85 c0             	test   %ax,%ax
f0100526:	74 b9                	je     f01004e1 <cons_putc+0xe5>
			crt_pos--;
f0100528:	83 e8 01             	sub    $0x1,%eax
f010052b:	66 a3 28 02 2b f0    	mov    %ax,0xf02b0228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100531:	0f b7 c0             	movzwl %ax,%eax
f0100534:	66 81 e7 00 ff       	and    $0xff00,%di
f0100539:	83 cf 20             	or     $0x20,%edi
f010053c:	8b 15 2c 02 2b f0    	mov    0xf02b022c,%edx
f0100542:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100546:	eb 8a                	jmp    f01004d2 <cons_putc+0xd6>
		crt_pos += CRT_COLS;
f0100548:	66 83 05 28 02 2b f0 	addw   $0x50,0xf02b0228
f010054f:	50 
f0100550:	e9 61 ff ff ff       	jmp    f01004b6 <cons_putc+0xba>
		cons_putc(' ');
f0100555:	b8 20 00 00 00       	mov    $0x20,%eax
f010055a:	e8 9d fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f010055f:	b8 20 00 00 00       	mov    $0x20,%eax
f0100564:	e8 93 fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f0100569:	b8 20 00 00 00       	mov    $0x20,%eax
f010056e:	e8 89 fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f0100573:	b8 20 00 00 00       	mov    $0x20,%eax
f0100578:	e8 7f fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f010057d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100582:	e8 75 fe ff ff       	call   f01003fc <cons_putc>
f0100587:	e9 46 ff ff ff       	jmp    f01004d2 <cons_putc+0xd6>
		crt_buf[crt_pos++] = c;		/* write the character */
f010058c:	0f b7 05 28 02 2b f0 	movzwl 0xf02b0228,%eax
f0100593:	8d 50 01             	lea    0x1(%eax),%edx
f0100596:	66 89 15 28 02 2b f0 	mov    %dx,0xf02b0228
f010059d:	0f b7 c0             	movzwl %ax,%eax
f01005a0:	8b 15 2c 02 2b f0    	mov    0xf02b022c,%edx
f01005a6:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01005aa:	e9 23 ff ff ff       	jmp    f01004d2 <cons_putc+0xd6>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005af:	a1 2c 02 2b f0       	mov    0xf02b022c,%eax
f01005b4:	83 ec 04             	sub    $0x4,%esp
f01005b7:	68 00 0f 00 00       	push   $0xf00
f01005bc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005c2:	52                   	push   %edx
f01005c3:	50                   	push   %eax
f01005c4:	e8 08 53 00 00       	call   f01058d1 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005c9:	8b 15 2c 02 2b f0    	mov    0xf02b022c,%edx
f01005cf:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005d5:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005db:	83 c4 10             	add    $0x10,%esp
f01005de:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e3:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005e6:	39 d0                	cmp    %edx,%eax
f01005e8:	75 f4                	jne    f01005de <cons_putc+0x1e2>
		crt_pos -= CRT_COLS;
f01005ea:	66 83 2d 28 02 2b f0 	subw   $0x50,0xf02b0228
f01005f1:	50 
f01005f2:	e9 ea fe ff ff       	jmp    f01004e1 <cons_putc+0xe5>

f01005f7 <serial_intr>:
	if (serial_exists)
f01005f7:	80 3d 34 02 2b f0 00 	cmpb   $0x0,0xf02b0234
f01005fe:	75 02                	jne    f0100602 <serial_intr+0xb>
f0100600:	f3 c3                	repz ret 
{
f0100602:	55                   	push   %ebp
f0100603:	89 e5                	mov    %esp,%ebp
f0100605:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100608:	b8 7d 02 10 f0       	mov    $0xf010027d,%eax
f010060d:	e8 8a fc ff ff       	call   f010029c <cons_intr>
}
f0100612:	c9                   	leave  
f0100613:	c3                   	ret    

f0100614 <kbd_intr>:
{
f0100614:	55                   	push   %ebp
f0100615:	89 e5                	mov    %esp,%ebp
f0100617:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f010061a:	b8 df 02 10 f0       	mov    $0xf01002df,%eax
f010061f:	e8 78 fc ff ff       	call   f010029c <cons_intr>
}
f0100624:	c9                   	leave  
f0100625:	c3                   	ret    

f0100626 <cons_getc>:
{
f0100626:	55                   	push   %ebp
f0100627:	89 e5                	mov    %esp,%ebp
f0100629:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010062c:	e8 c6 ff ff ff       	call   f01005f7 <serial_intr>
	kbd_intr();
f0100631:	e8 de ff ff ff       	call   f0100614 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100636:	8b 15 20 02 2b f0    	mov    0xf02b0220,%edx
	return 0;
f010063c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100641:	3b 15 24 02 2b f0    	cmp    0xf02b0224,%edx
f0100647:	74 18                	je     f0100661 <cons_getc+0x3b>
		c = cons.buf[cons.rpos++];
f0100649:	8d 4a 01             	lea    0x1(%edx),%ecx
f010064c:	89 0d 20 02 2b f0    	mov    %ecx,0xf02b0220
f0100652:	0f b6 82 20 00 2b f0 	movzbl -0xfd4ffe0(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
f0100659:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010065f:	74 02                	je     f0100663 <cons_getc+0x3d>
}
f0100661:	c9                   	leave  
f0100662:	c3                   	ret    
			cons.rpos = 0;
f0100663:	c7 05 20 02 2b f0 00 	movl   $0x0,0xf02b0220
f010066a:	00 00 00 
f010066d:	eb f2                	jmp    f0100661 <cons_getc+0x3b>

f010066f <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010066f:	55                   	push   %ebp
f0100670:	89 e5                	mov    %esp,%ebp
f0100672:	57                   	push   %edi
f0100673:	56                   	push   %esi
f0100674:	53                   	push   %ebx
f0100675:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100678:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010067f:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100686:	5a a5 
	if (*cp != 0xA55A) {
f0100688:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010068f:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100693:	0f 84 de 00 00 00    	je     f0100777 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100699:	c7 05 30 02 2b f0 b4 	movl   $0x3b4,0xf02b0230
f01006a0:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006a3:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006a8:	8b 3d 30 02 2b f0    	mov    0xf02b0230,%edi
f01006ae:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006b3:	89 fa                	mov    %edi,%edx
f01006b5:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006b6:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006b9:	89 ca                	mov    %ecx,%edx
f01006bb:	ec                   	in     (%dx),%al
f01006bc:	0f b6 c0             	movzbl %al,%eax
f01006bf:	c1 e0 08             	shl    $0x8,%eax
f01006c2:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006c4:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006c9:	89 fa                	mov    %edi,%edx
f01006cb:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006cc:	89 ca                	mov    %ecx,%edx
f01006ce:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006cf:	89 35 2c 02 2b f0    	mov    %esi,0xf02b022c
	pos |= inb(addr_6845 + 1);
f01006d5:	0f b6 c0             	movzbl %al,%eax
f01006d8:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006da:	66 a3 28 02 2b f0    	mov    %ax,0xf02b0228
	kbd_intr();
f01006e0:	e8 2f ff ff ff       	call   f0100614 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006e5:	83 ec 0c             	sub    $0xc,%esp
f01006e8:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f01006ef:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006f4:	50                   	push   %eax
f01006f5:	e8 e1 30 00 00       	call   f01037db <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006fa:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006ff:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f0100704:	89 d8                	mov    %ebx,%eax
f0100706:	89 ca                	mov    %ecx,%edx
f0100708:	ee                   	out    %al,(%dx)
f0100709:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010070e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100713:	89 fa                	mov    %edi,%edx
f0100715:	ee                   	out    %al,(%dx)
f0100716:	b8 0c 00 00 00       	mov    $0xc,%eax
f010071b:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100720:	ee                   	out    %al,(%dx)
f0100721:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100726:	89 d8                	mov    %ebx,%eax
f0100728:	89 f2                	mov    %esi,%edx
f010072a:	ee                   	out    %al,(%dx)
f010072b:	b8 03 00 00 00       	mov    $0x3,%eax
f0100730:	89 fa                	mov    %edi,%edx
f0100732:	ee                   	out    %al,(%dx)
f0100733:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100738:	89 d8                	mov    %ebx,%eax
f010073a:	ee                   	out    %al,(%dx)
f010073b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100740:	89 f2                	mov    %esi,%edx
f0100742:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100743:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100748:	ec                   	in     (%dx),%al
f0100749:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010074b:	83 c4 10             	add    $0x10,%esp
f010074e:	3c ff                	cmp    $0xff,%al
f0100750:	0f 95 05 34 02 2b f0 	setne  0xf02b0234
f0100757:	89 ca                	mov    %ecx,%edx
f0100759:	ec                   	in     (%dx),%al
f010075a:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010075f:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100760:	80 fb ff             	cmp    $0xff,%bl
f0100763:	75 2d                	jne    f0100792 <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100765:	83 ec 0c             	sub    $0xc,%esp
f0100768:	68 6f 6c 10 f0       	push   $0xf0106c6f
f010076d:	e8 da 31 00 00       	call   f010394c <cprintf>
f0100772:	83 c4 10             	add    $0x10,%esp
}
f0100775:	eb 3c                	jmp    f01007b3 <cons_init+0x144>
		*cp = was;
f0100777:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010077e:	c7 05 30 02 2b f0 d4 	movl   $0x3d4,0xf02b0230
f0100785:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100788:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010078d:	e9 16 ff ff ff       	jmp    f01006a8 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100792:	83 ec 0c             	sub    $0xc,%esp
f0100795:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f010079c:	25 ef ff 00 00       	and    $0xffef,%eax
f01007a1:	50                   	push   %eax
f01007a2:	e8 34 30 00 00       	call   f01037db <irq_setmask_8259A>
	if (!serial_exists)
f01007a7:	83 c4 10             	add    $0x10,%esp
f01007aa:	80 3d 34 02 2b f0 00 	cmpb   $0x0,0xf02b0234
f01007b1:	74 b2                	je     f0100765 <cons_init+0xf6>
}
f01007b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007b6:	5b                   	pop    %ebx
f01007b7:	5e                   	pop    %esi
f01007b8:	5f                   	pop    %edi
f01007b9:	5d                   	pop    %ebp
f01007ba:	c3                   	ret    

f01007bb <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007bb:	55                   	push   %ebp
f01007bc:	89 e5                	mov    %esp,%ebp
f01007be:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007c1:	8b 45 08             	mov    0x8(%ebp),%eax
f01007c4:	e8 33 fc ff ff       	call   f01003fc <cons_putc>
}
f01007c9:	c9                   	leave  
f01007ca:	c3                   	ret    

f01007cb <getchar>:

int
getchar(void)
{
f01007cb:	55                   	push   %ebp
f01007cc:	89 e5                	mov    %esp,%ebp
f01007ce:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007d1:	e8 50 fe ff ff       	call   f0100626 <cons_getc>
f01007d6:	85 c0                	test   %eax,%eax
f01007d8:	74 f7                	je     f01007d1 <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007da:	c9                   	leave  
f01007db:	c3                   	ret    

f01007dc <iscons>:

int
iscons(int fdnum)
{
f01007dc:	55                   	push   %ebp
f01007dd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01007df:	b8 01 00 00 00       	mov    $0x1,%eax
f01007e4:	5d                   	pop    %ebp
f01007e5:	c3                   	ret    

f01007e6 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007e6:	55                   	push   %ebp
f01007e7:	89 e5                	mov    %esp,%ebp
f01007e9:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007ec:	68 c0 6e 10 f0       	push   $0xf0106ec0
f01007f1:	68 de 6e 10 f0       	push   $0xf0106ede
f01007f6:	68 e3 6e 10 f0       	push   $0xf0106ee3
f01007fb:	e8 4c 31 00 00       	call   f010394c <cprintf>
f0100800:	83 c4 0c             	add    $0xc,%esp
f0100803:	68 7c 6f 10 f0       	push   $0xf0106f7c
f0100808:	68 ec 6e 10 f0       	push   $0xf0106eec
f010080d:	68 e3 6e 10 f0       	push   $0xf0106ee3
f0100812:	e8 35 31 00 00       	call   f010394c <cprintf>
f0100817:	83 c4 0c             	add    $0xc,%esp
f010081a:	68 a4 6f 10 f0       	push   $0xf0106fa4
f010081f:	68 f5 6e 10 f0       	push   $0xf0106ef5
f0100824:	68 e3 6e 10 f0       	push   $0xf0106ee3
f0100829:	e8 1e 31 00 00       	call   f010394c <cprintf>
	return 0;
}
f010082e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100833:	c9                   	leave  
f0100834:	c3                   	ret    

f0100835 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100835:	55                   	push   %ebp
f0100836:	89 e5                	mov    %esp,%ebp
f0100838:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010083b:	68 ff 6e 10 f0       	push   $0xf0106eff
f0100840:	e8 07 31 00 00       	call   f010394c <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100845:	83 c4 08             	add    $0x8,%esp
f0100848:	68 0c 00 10 00       	push   $0x10000c
f010084d:	68 d0 6f 10 f0       	push   $0xf0106fd0
f0100852:	e8 f5 30 00 00       	call   f010394c <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100857:	83 c4 0c             	add    $0xc,%esp
f010085a:	68 0c 00 10 00       	push   $0x10000c
f010085f:	68 0c 00 10 f0       	push   $0xf010000c
f0100864:	68 f8 6f 10 f0       	push   $0xf0106ff8
f0100869:	e8 de 30 00 00       	call   f010394c <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010086e:	83 c4 0c             	add    $0xc,%esp
f0100871:	68 99 6b 10 00       	push   $0x106b99
f0100876:	68 99 6b 10 f0       	push   $0xf0106b99
f010087b:	68 1c 70 10 f0       	push   $0xf010701c
f0100880:	e8 c7 30 00 00       	call   f010394c <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100885:	83 c4 0c             	add    $0xc,%esp
f0100888:	68 00 00 2b 00       	push   $0x2b0000
f010088d:	68 00 00 2b f0       	push   $0xf02b0000
f0100892:	68 40 70 10 f0       	push   $0xf0107040
f0100897:	e8 b0 30 00 00       	call   f010394c <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010089c:	83 c4 0c             	add    $0xc,%esp
f010089f:	68 0c b0 30 00       	push   $0x30b00c
f01008a4:	68 0c b0 30 f0       	push   $0xf030b00c
f01008a9:	68 64 70 10 f0       	push   $0xf0107064
f01008ae:	e8 99 30 00 00       	call   f010394c <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008b3:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008b6:	b8 0b b4 30 f0       	mov    $0xf030b40b,%eax
f01008bb:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008c0:	c1 f8 0a             	sar    $0xa,%eax
f01008c3:	50                   	push   %eax
f01008c4:	68 88 70 10 f0       	push   $0xf0107088
f01008c9:	e8 7e 30 00 00       	call   f010394c <cprintf>
	return 0;
}
f01008ce:	b8 00 00 00 00       	mov    $0x0,%eax
f01008d3:	c9                   	leave  
f01008d4:	c3                   	ret    

f01008d5 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008d5:	55                   	push   %ebp
f01008d6:	89 e5                	mov    %esp,%ebp
f01008d8:	56                   	push   %esi
f01008d9:	53                   	push   %ebx
f01008da:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008dd:	89 eb                	mov    %ebp,%ebx
    	struct Eipdebuginfo info;
    	int result;

    	ebp = (uint32_t *)read_ebp();

    	cprintf("Stack backtrace:\r\n");
f01008df:	68 18 6f 10 f0       	push   $0xf0106f18
f01008e4:	e8 63 30 00 00       	call   f010394c <cprintf>

    	while (ebp)
f01008e9:	83 c4 10             	add    $0x10,%esp
    	{
        	cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\r\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);

        	memset(&info, 0, sizeof(struct Eipdebuginfo));
f01008ec:	8d 75 e0             	lea    -0x20(%ebp),%esi
    	while (ebp)
f01008ef:	eb 25                	jmp    f0100916 <mon_backtrace+0x41>
        	{
           		cprintf("failed to get debuginfo for eip %x.\r\n", ebp[1]);
        	}
        	else
        	{
            	cprintf("\t%s:%d: %.*s+%u\r\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, ebp[1] - info.eip_fn_addr);
f01008f1:	83 ec 08             	sub    $0x8,%esp
f01008f4:	8b 43 04             	mov    0x4(%ebx),%eax
f01008f7:	2b 45 f0             	sub    -0x10(%ebp),%eax
f01008fa:	50                   	push   %eax
f01008fb:	ff 75 e8             	pushl  -0x18(%ebp)
f01008fe:	ff 75 ec             	pushl  -0x14(%ebp)
f0100901:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100904:	ff 75 e0             	pushl  -0x20(%ebp)
f0100907:	68 2b 6f 10 f0       	push   $0xf0106f2b
f010090c:	e8 3b 30 00 00       	call   f010394c <cprintf>
f0100911:	83 c4 20             	add    $0x20,%esp
        	}

        	ebp = (uint32_t *)*ebp;
f0100914:	8b 1b                	mov    (%ebx),%ebx
    	while (ebp)
f0100916:	85 db                	test   %ebx,%ebx
f0100918:	74 52                	je     f010096c <mon_backtrace+0x97>
        	cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\r\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
f010091a:	ff 73 18             	pushl  0x18(%ebx)
f010091d:	ff 73 14             	pushl  0x14(%ebx)
f0100920:	ff 73 10             	pushl  0x10(%ebx)
f0100923:	ff 73 0c             	pushl  0xc(%ebx)
f0100926:	ff 73 08             	pushl  0x8(%ebx)
f0100929:	ff 73 04             	pushl  0x4(%ebx)
f010092c:	53                   	push   %ebx
f010092d:	68 b4 70 10 f0       	push   $0xf01070b4
f0100932:	e8 15 30 00 00       	call   f010394c <cprintf>
        	memset(&info, 0, sizeof(struct Eipdebuginfo));
f0100937:	83 c4 1c             	add    $0x1c,%esp
f010093a:	6a 18                	push   $0x18
f010093c:	6a 00                	push   $0x0
f010093e:	56                   	push   %esi
f010093f:	e8 40 4f 00 00       	call   f0105884 <memset>
        	result = debuginfo_eip(ebp[1], &info);
f0100944:	83 c4 08             	add    $0x8,%esp
f0100947:	56                   	push   %esi
f0100948:	ff 73 04             	pushl  0x4(%ebx)
f010094b:	e8 c2 43 00 00       	call   f0104d12 <debuginfo_eip>
        	if (0 != result)
f0100950:	83 c4 10             	add    $0x10,%esp
f0100953:	85 c0                	test   %eax,%eax
f0100955:	74 9a                	je     f01008f1 <mon_backtrace+0x1c>
           		cprintf("failed to get debuginfo for eip %x.\r\n", ebp[1]);
f0100957:	83 ec 08             	sub    $0x8,%esp
f010095a:	ff 73 04             	pushl  0x4(%ebx)
f010095d:	68 ec 70 10 f0       	push   $0xf01070ec
f0100962:	e8 e5 2f 00 00       	call   f010394c <cprintf>
f0100967:	83 c4 10             	add    $0x10,%esp
f010096a:	eb a8                	jmp    f0100914 <mon_backtrace+0x3f>
    	}
	return 0;
}
f010096c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100971:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100974:	5b                   	pop    %ebx
f0100975:	5e                   	pop    %esi
f0100976:	5d                   	pop    %ebp
f0100977:	c3                   	ret    

f0100978 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100978:	55                   	push   %ebp
f0100979:	89 e5                	mov    %esp,%ebp
f010097b:	57                   	push   %edi
f010097c:	56                   	push   %esi
f010097d:	53                   	push   %ebx
f010097e:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100981:	68 14 71 10 f0       	push   $0xf0107114
f0100986:	e8 c1 2f 00 00       	call   f010394c <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f010098b:	c7 04 24 38 71 10 f0 	movl   $0xf0107138,(%esp)
f0100992:	e8 b5 2f 00 00       	call   f010394c <cprintf>

	if (tf != NULL)
f0100997:	83 c4 10             	add    $0x10,%esp
f010099a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010099e:	74 57                	je     f01009f7 <monitor+0x7f>
		print_trapframe(tf);
f01009a0:	83 ec 0c             	sub    $0xc,%esp
f01009a3:	ff 75 08             	pushl  0x8(%ebp)
f01009a6:	e8 62 35 00 00       	call   f0103f0d <print_trapframe>
f01009ab:	83 c4 10             	add    $0x10,%esp
f01009ae:	eb 47                	jmp    f01009f7 <monitor+0x7f>
		while (*buf && strchr(WHITESPACE, *buf))
f01009b0:	83 ec 08             	sub    $0x8,%esp
f01009b3:	0f be c0             	movsbl %al,%eax
f01009b6:	50                   	push   %eax
f01009b7:	68 41 6f 10 f0       	push   $0xf0106f41
f01009bc:	e8 86 4e 00 00       	call   f0105847 <strchr>
f01009c1:	83 c4 10             	add    $0x10,%esp
f01009c4:	85 c0                	test   %eax,%eax
f01009c6:	74 0a                	je     f01009d2 <monitor+0x5a>
			*buf++ = 0;
f01009c8:	c6 03 00             	movb   $0x0,(%ebx)
f01009cb:	89 f7                	mov    %esi,%edi
f01009cd:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01009d0:	eb 6b                	jmp    f0100a3d <monitor+0xc5>
		if (*buf == 0)
f01009d2:	80 3b 00             	cmpb   $0x0,(%ebx)
f01009d5:	74 73                	je     f0100a4a <monitor+0xd2>
		if (argc == MAXARGS-1) {
f01009d7:	83 fe 0f             	cmp    $0xf,%esi
f01009da:	74 09                	je     f01009e5 <monitor+0x6d>
		argv[argc++] = buf;
f01009dc:	8d 7e 01             	lea    0x1(%esi),%edi
f01009df:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f01009e3:	eb 39                	jmp    f0100a1e <monitor+0xa6>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f01009e5:	83 ec 08             	sub    $0x8,%esp
f01009e8:	6a 10                	push   $0x10
f01009ea:	68 46 6f 10 f0       	push   $0xf0106f46
f01009ef:	e8 58 2f 00 00       	call   f010394c <cprintf>
f01009f4:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f01009f7:	83 ec 0c             	sub    $0xc,%esp
f01009fa:	68 3d 6f 10 f0       	push   $0xf0106f3d
f01009ff:	e8 1a 4c 00 00       	call   f010561e <readline>
f0100a04:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a06:	83 c4 10             	add    $0x10,%esp
f0100a09:	85 c0                	test   %eax,%eax
f0100a0b:	74 ea                	je     f01009f7 <monitor+0x7f>
	argv[argc] = 0;
f0100a0d:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a14:	be 00 00 00 00       	mov    $0x0,%esi
f0100a19:	eb 24                	jmp    f0100a3f <monitor+0xc7>
			buf++;
f0100a1b:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a1e:	0f b6 03             	movzbl (%ebx),%eax
f0100a21:	84 c0                	test   %al,%al
f0100a23:	74 18                	je     f0100a3d <monitor+0xc5>
f0100a25:	83 ec 08             	sub    $0x8,%esp
f0100a28:	0f be c0             	movsbl %al,%eax
f0100a2b:	50                   	push   %eax
f0100a2c:	68 41 6f 10 f0       	push   $0xf0106f41
f0100a31:	e8 11 4e 00 00       	call   f0105847 <strchr>
f0100a36:	83 c4 10             	add    $0x10,%esp
f0100a39:	85 c0                	test   %eax,%eax
f0100a3b:	74 de                	je     f0100a1b <monitor+0xa3>
			*buf++ = 0;
f0100a3d:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100a3f:	0f b6 03             	movzbl (%ebx),%eax
f0100a42:	84 c0                	test   %al,%al
f0100a44:	0f 85 66 ff ff ff    	jne    f01009b0 <monitor+0x38>
	argv[argc] = 0;
f0100a4a:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100a51:	00 
	if (argc == 0)
f0100a52:	85 f6                	test   %esi,%esi
f0100a54:	74 a1                	je     f01009f7 <monitor+0x7f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a56:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100a5b:	83 ec 08             	sub    $0x8,%esp
f0100a5e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a61:	ff 34 85 60 71 10 f0 	pushl  -0xfef8ea0(,%eax,4)
f0100a68:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a6b:	e8 79 4d 00 00       	call   f01057e9 <strcmp>
f0100a70:	83 c4 10             	add    $0x10,%esp
f0100a73:	85 c0                	test   %eax,%eax
f0100a75:	74 20                	je     f0100a97 <monitor+0x11f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a77:	83 c3 01             	add    $0x1,%ebx
f0100a7a:	83 fb 03             	cmp    $0x3,%ebx
f0100a7d:	75 dc                	jne    f0100a5b <monitor+0xe3>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a7f:	83 ec 08             	sub    $0x8,%esp
f0100a82:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a85:	68 63 6f 10 f0       	push   $0xf0106f63
f0100a8a:	e8 bd 2e 00 00       	call   f010394c <cprintf>
f0100a8f:	83 c4 10             	add    $0x10,%esp
f0100a92:	e9 60 ff ff ff       	jmp    f01009f7 <monitor+0x7f>
			return commands[i].func(argc, argv, tf);
f0100a97:	83 ec 04             	sub    $0x4,%esp
f0100a9a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a9d:	ff 75 08             	pushl  0x8(%ebp)
f0100aa0:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100aa3:	52                   	push   %edx
f0100aa4:	56                   	push   %esi
f0100aa5:	ff 14 85 68 71 10 f0 	call   *-0xfef8e98(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100aac:	83 c4 10             	add    $0x10,%esp
f0100aaf:	85 c0                	test   %eax,%eax
f0100ab1:	0f 89 40 ff ff ff    	jns    f01009f7 <monitor+0x7f>
				break;
	}
}
f0100ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100aba:	5b                   	pop    %ebx
f0100abb:	5e                   	pop    %esi
f0100abc:	5f                   	pop    %edi
f0100abd:	5d                   	pop    %ebp
f0100abe:	c3                   	ret    

f0100abf <boot_alloc>:
// before the page_free_list list has been set up.
// Note that when this function is called, we are still using entry_pgdir,
// which only maps the first 4MB of physical memory.
static void *
boot_alloc(uint32_t n)
{
f0100abf:	55                   	push   %ebp
f0100ac0:	89 e5                	mov    %esp,%ebp
    // Initialize nextfree if this is the first time.
    // 'end' is a magic symbol automatically generated by the linker,
    // which points to the end of the kernel's bss segment:
    // the first virtual address that the linker did *not* assign
    // to any kernel code or global variables.
    if (!nextfree) {
f0100ac2:	83 3d 38 02 2b f0 00 	cmpl   $0x0,0xf02b0238
f0100ac9:	74 1f                	je     f0100aea <boot_alloc+0x2b>
    // nextfree.  Make sure nextfree is kept aligned
    // to a multiple of PGSIZE.
    //
    // LAB 2: Your code here.

    result = nextfree;
f0100acb:	8b 15 38 02 2b f0    	mov    0xf02b0238,%edx
    if (n > 0) {
f0100ad1:	85 c0                	test   %eax,%eax
f0100ad3:	74 11                	je     f0100ae6 <boot_alloc+0x27>
        nextfree = ROUNDUP((char *)(nextfree + n), PGSIZE);
f0100ad5:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0100adc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ae1:	a3 38 02 2b f0       	mov    %eax,0xf02b0238
    }

    return result;
}
f0100ae6:	89 d0                	mov    %edx,%eax
f0100ae8:	5d                   	pop    %ebp
f0100ae9:	c3                   	ret    
        nextfree = ROUNDUP((char *) end, PGSIZE);
f0100aea:	ba 0b c0 30 f0       	mov    $0xf030c00b,%edx
f0100aef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100af5:	89 15 38 02 2b f0    	mov    %edx,0xf02b0238
f0100afb:	eb ce                	jmp    f0100acb <boot_alloc+0xc>

f0100afd <nvram_read>:
{
f0100afd:	55                   	push   %ebp
f0100afe:	89 e5                	mov    %esp,%ebp
f0100b00:	56                   	push   %esi
f0100b01:	53                   	push   %ebx
f0100b02:	89 c6                	mov    %eax,%esi
    return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b04:	83 ec 0c             	sub    $0xc,%esp
f0100b07:	50                   	push   %eax
f0100b08:	e8 a0 2c 00 00       	call   f01037ad <mc146818_read>
f0100b0d:	89 c3                	mov    %eax,%ebx
f0100b0f:	83 c6 01             	add    $0x1,%esi
f0100b12:	89 34 24             	mov    %esi,(%esp)
f0100b15:	e8 93 2c 00 00       	call   f01037ad <mc146818_read>
f0100b1a:	c1 e0 08             	shl    $0x8,%eax
f0100b1d:	09 d8                	or     %ebx,%eax
}
f0100b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b22:	5b                   	pop    %ebx
f0100b23:	5e                   	pop    %esi
f0100b24:	5d                   	pop    %ebp
f0100b25:	c3                   	ret    

f0100b26 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
    pte_t *p;

    pgdir = &pgdir[PDX(va)];
f0100b26:	89 d1                	mov    %edx,%ecx
f0100b28:	c1 e9 16             	shr    $0x16,%ecx
    if (!(*pgdir & PTE_P))
f0100b2b:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b2e:	a8 01                	test   $0x1,%al
f0100b30:	74 52                	je     f0100b84 <check_va2pa+0x5e>
        return ~0;
    p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100b37:	89 c1                	mov    %eax,%ecx
f0100b39:	c1 e9 0c             	shr    $0xc,%ecx
f0100b3c:	3b 0d 94 92 2c f0    	cmp    0xf02c9294,%ecx
f0100b42:	73 25                	jae    f0100b69 <check_va2pa+0x43>
    if (!(p[PTX(va)] & PTE_P))
f0100b44:	c1 ea 0c             	shr    $0xc,%edx
f0100b47:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b4d:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100b54:	89 c2                	mov    %eax,%edx
f0100b56:	83 e2 01             	and    $0x1,%edx
        return ~0;
    return PTE_ADDR(p[PTX(va)]);
f0100b59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b5e:	85 d2                	test   %edx,%edx
f0100b60:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b65:	0f 44 c2             	cmove  %edx,%eax
f0100b68:	c3                   	ret    
{
f0100b69:	55                   	push   %ebp
f0100b6a:	89 e5                	mov    %esp,%ebp
f0100b6c:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b6f:	50                   	push   %eax
f0100b70:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0100b75:	68 a6 03 00 00       	push   $0x3a6
f0100b7a:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100b7f:	e8 bc f4 ff ff       	call   f0100040 <_panic>
        return ~0;
f0100b84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100b89:	c3                   	ret    

f0100b8a <check_page_free_list>:
{
f0100b8a:	55                   	push   %ebp
f0100b8b:	89 e5                	mov    %esp,%ebp
f0100b8d:	57                   	push   %edi
f0100b8e:	56                   	push   %esi
f0100b8f:	53                   	push   %ebx
f0100b90:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b93:	84 c0                	test   %al,%al
f0100b95:	0f 85 86 02 00 00    	jne    f0100e21 <check_page_free_list+0x297>
	if (!page_free_list)
f0100b9b:	83 3d 40 02 2b f0 00 	cmpl   $0x0,0xf02b0240
f0100ba2:	74 0a                	je     f0100bae <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ba4:	be 00 04 00 00       	mov    $0x400,%esi
f0100ba9:	e9 ce 02 00 00       	jmp    f0100e7c <check_page_free_list+0x2f2>
		panic("'page_free_list' is a null pointer!");
f0100bae:	83 ec 04             	sub    $0x4,%esp
f0100bb1:	68 84 71 10 f0       	push   $0xf0107184
f0100bb6:	68 d9 02 00 00       	push   $0x2d9
f0100bbb:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100bc0:	e8 7b f4 ff ff       	call   f0100040 <_panic>
f0100bc5:	50                   	push   %eax
f0100bc6:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0100bcb:	6a 58                	push   $0x58
f0100bcd:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0100bd2:	e8 69 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bd7:	8b 1b                	mov    (%ebx),%ebx
f0100bd9:	85 db                	test   %ebx,%ebx
f0100bdb:	74 41                	je     f0100c1e <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bdd:	89 d8                	mov    %ebx,%eax
f0100bdf:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0100be5:	c1 f8 03             	sar    $0x3,%eax
f0100be8:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100beb:	89 c2                	mov    %eax,%edx
f0100bed:	c1 ea 16             	shr    $0x16,%edx
f0100bf0:	39 f2                	cmp    %esi,%edx
f0100bf2:	73 e3                	jae    f0100bd7 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100bf4:	89 c2                	mov    %eax,%edx
f0100bf6:	c1 ea 0c             	shr    $0xc,%edx
f0100bf9:	3b 15 94 92 2c f0    	cmp    0xf02c9294,%edx
f0100bff:	73 c4                	jae    f0100bc5 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100c01:	83 ec 04             	sub    $0x4,%esp
f0100c04:	68 80 00 00 00       	push   $0x80
f0100c09:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c0e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c13:	50                   	push   %eax
f0100c14:	e8 6b 4c 00 00       	call   f0105884 <memset>
f0100c19:	83 c4 10             	add    $0x10,%esp
f0100c1c:	eb b9                	jmp    f0100bd7 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100c1e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c23:	e8 97 fe ff ff       	call   f0100abf <boot_alloc>
f0100c28:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c2b:	8b 15 40 02 2b f0    	mov    0xf02b0240,%edx
		assert(pp >= pages);
f0100c31:	8b 0d 9c 92 2c f0    	mov    0xf02c929c,%ecx
		assert(pp < pages + npages);
f0100c37:	a1 94 92 2c f0       	mov    0xf02c9294,%eax
f0100c3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100c3f:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100c42:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c45:	89 4d d0             	mov    %ecx,-0x30(%ebp)
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c48:	be 00 00 00 00       	mov    $0x0,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c4d:	e9 04 01 00 00       	jmp    f0100d56 <check_page_free_list+0x1cc>
		assert(pp >= pages);
f0100c52:	68 f3 7a 10 f0       	push   $0xf0107af3
f0100c57:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100c5c:	68 f3 02 00 00       	push   $0x2f3
f0100c61:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100c66:	e8 d5 f3 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100c6b:	68 14 7b 10 f0       	push   $0xf0107b14
f0100c70:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100c75:	68 f4 02 00 00       	push   $0x2f4
f0100c7a:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100c7f:	e8 bc f3 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c84:	68 a8 71 10 f0       	push   $0xf01071a8
f0100c89:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100c8e:	68 f5 02 00 00       	push   $0x2f5
f0100c93:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100c98:	e8 a3 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100c9d:	68 28 7b 10 f0       	push   $0xf0107b28
f0100ca2:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100ca7:	68 f8 02 00 00       	push   $0x2f8
f0100cac:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100cb1:	e8 8a f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100cb6:	68 39 7b 10 f0       	push   $0xf0107b39
f0100cbb:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100cc0:	68 f9 02 00 00       	push   $0x2f9
f0100cc5:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100cca:	e8 71 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100ccf:	68 dc 71 10 f0       	push   $0xf01071dc
f0100cd4:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100cd9:	68 fa 02 00 00       	push   $0x2fa
f0100cde:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100ce3:	e8 58 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100ce8:	68 52 7b 10 f0       	push   $0xf0107b52
f0100ced:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100cf2:	68 fb 02 00 00       	push   $0x2fb
f0100cf7:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100cfc:	e8 3f f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100d01:	89 c7                	mov    %eax,%edi
f0100d03:	c1 ef 0c             	shr    $0xc,%edi
f0100d06:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0100d09:	76 1b                	jbe    f0100d26 <check_page_free_list+0x19c>
	return (void *)(pa + KERNBASE);
f0100d0b:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d11:	39 7d c8             	cmp    %edi,-0x38(%ebp)
f0100d14:	77 22                	ja     f0100d38 <check_page_free_list+0x1ae>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100d16:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d1b:	0f 84 98 00 00 00    	je     f0100db9 <check_page_free_list+0x22f>
			++nfree_extmem;
f0100d21:	83 c3 01             	add    $0x1,%ebx
f0100d24:	eb 2e                	jmp    f0100d54 <check_page_free_list+0x1ca>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d26:	50                   	push   %eax
f0100d27:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0100d2c:	6a 58                	push   $0x58
f0100d2e:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0100d33:	e8 08 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d38:	68 00 72 10 f0       	push   $0xf0107200
f0100d3d:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100d42:	68 fc 02 00 00       	push   $0x2fc
f0100d47:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100d4c:	e8 ef f2 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100d51:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d54:	8b 12                	mov    (%edx),%edx
f0100d56:	85 d2                	test   %edx,%edx
f0100d58:	74 78                	je     f0100dd2 <check_page_free_list+0x248>
		assert(pp >= pages);
f0100d5a:	39 d1                	cmp    %edx,%ecx
f0100d5c:	0f 87 f0 fe ff ff    	ja     f0100c52 <check_page_free_list+0xc8>
		assert(pp < pages + npages);
f0100d62:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f0100d65:	0f 86 00 ff ff ff    	jbe    f0100c6b <check_page_free_list+0xe1>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d6b:	89 d0                	mov    %edx,%eax
f0100d6d:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100d70:	a8 07                	test   $0x7,%al
f0100d72:	0f 85 0c ff ff ff    	jne    f0100c84 <check_page_free_list+0xfa>
	return (pp - pages) << PGSHIFT;
f0100d78:	c1 f8 03             	sar    $0x3,%eax
f0100d7b:	c1 e0 0c             	shl    $0xc,%eax
		assert(page2pa(pp) != 0);
f0100d7e:	85 c0                	test   %eax,%eax
f0100d80:	0f 84 17 ff ff ff    	je     f0100c9d <check_page_free_list+0x113>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d86:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d8b:	0f 84 25 ff ff ff    	je     f0100cb6 <check_page_free_list+0x12c>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d91:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100d96:	0f 84 33 ff ff ff    	je     f0100ccf <check_page_free_list+0x145>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d9c:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100da1:	0f 84 41 ff ff ff    	je     f0100ce8 <check_page_free_list+0x15e>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100da7:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100dac:	0f 87 4f ff ff ff    	ja     f0100d01 <check_page_free_list+0x177>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100db2:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100db7:	75 98                	jne    f0100d51 <check_page_free_list+0x1c7>
f0100db9:	68 6c 7b 10 f0       	push   $0xf0107b6c
f0100dbe:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100dc3:	68 fe 02 00 00       	push   $0x2fe
f0100dc8:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100dcd:	e8 6e f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_basemem > 0);
f0100dd2:	85 f6                	test   %esi,%esi
f0100dd4:	7e 19                	jle    f0100def <check_page_free_list+0x265>
	assert(nfree_extmem > 0);
f0100dd6:	85 db                	test   %ebx,%ebx
f0100dd8:	7e 2e                	jle    f0100e08 <check_page_free_list+0x27e>
	cprintf("check_page_free_list() succeeded!\n");
f0100dda:	83 ec 0c             	sub    $0xc,%esp
f0100ddd:	68 48 72 10 f0       	push   $0xf0107248
f0100de2:	e8 65 2b 00 00       	call   f010394c <cprintf>
}
f0100de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100dea:	5b                   	pop    %ebx
f0100deb:	5e                   	pop    %esi
f0100dec:	5f                   	pop    %edi
f0100ded:	5d                   	pop    %ebp
f0100dee:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100def:	68 89 7b 10 f0       	push   $0xf0107b89
f0100df4:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100df9:	68 06 03 00 00       	push   $0x306
f0100dfe:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100e03:	e8 38 f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100e08:	68 9b 7b 10 f0       	push   $0xf0107b9b
f0100e0d:	68 ff 7a 10 f0       	push   $0xf0107aff
f0100e12:	68 07 03 00 00       	push   $0x307
f0100e17:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100e1c:	e8 1f f2 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100e21:	a1 40 02 2b f0       	mov    0xf02b0240,%eax
f0100e26:	85 c0                	test   %eax,%eax
f0100e28:	0f 84 80 fd ff ff    	je     f0100bae <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e2e:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e31:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e34:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e37:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e3a:	89 c2                	mov    %eax,%edx
f0100e3c:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e42:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e48:	0f 95 c2             	setne  %dl
f0100e4b:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e4e:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e52:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e54:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e58:	8b 00                	mov    (%eax),%eax
f0100e5a:	85 c0                	test   %eax,%eax
f0100e5c:	75 dc                	jne    f0100e3a <check_page_free_list+0x2b0>
		*tp[1] = 0;
f0100e5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e67:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e6d:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e72:	a3 40 02 2b f0       	mov    %eax,0xf02b0240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e77:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e7c:	8b 1d 40 02 2b f0    	mov    0xf02b0240,%ebx
f0100e82:	e9 52 fd ff ff       	jmp    f0100bd9 <check_page_free_list+0x4f>

f0100e87 <page_init>:
{
f0100e87:	55                   	push   %ebp
f0100e88:	89 e5                	mov    %esp,%ebp
f0100e8a:	57                   	push   %edi
f0100e8b:	56                   	push   %esi
f0100e8c:	53                   	push   %ebx
f0100e8d:	83 ec 1c             	sub    $0x1c,%esp
    page_free_list = NULL;
f0100e90:	c7 05 40 02 2b f0 00 	movl   $0x0,0xf02b0240
f0100e97:	00 00 00 
    physaddr_t kern_pgdir_end = PADDR(boot_alloc(0));
f0100e9a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e9f:	e8 1b fc ff ff       	call   f0100abf <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100ea4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100ea9:	76 35                	jbe    f0100ee0 <page_init+0x59>
	return (physaddr_t)kva - KERNBASE;
f0100eab:	05 00 00 00 10       	add    $0x10000000,%eax
f0100eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    MARK_USE(0);
f0100eb3:	a1 9c 92 2c f0       	mov    0xf02c929c,%eax
f0100eb8:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f0100ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 1; i < npages_basemem; i++) {
f0100ec4:	8b 35 44 02 2b f0    	mov    0xf02b0244,%esi
f0100eca:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ecf:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100ed4:	b8 01 00 00 00       	mov    $0x1,%eax
            MARK_FREE(i);
f0100ed9:	bf 01 00 00 00       	mov    $0x1,%edi
    for (i = 1; i < npages_basemem; i++) {
f0100ede:	eb 2b                	jmp    f0100f0b <page_init+0x84>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100ee0:	50                   	push   %eax
f0100ee1:	68 e8 6b 10 f0       	push   $0xf0106be8
f0100ee6:	68 4e 01 00 00       	push   $0x14e
f0100eeb:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0100ef0:	e8 4b f1 ff ff       	call   f0100040 <_panic>
            MARK_USE(i);
f0100ef5:	8b 0d 9c 92 2c f0    	mov    0xf02c929c,%ecx
f0100efb:	66 c7 41 3c 00 00    	movw   $0x0,0x3c(%ecx)
f0100f01:	c7 41 38 00 00 00 00 	movl   $0x0,0x38(%ecx)
    for (i = 1; i < npages_basemem; i++) {
f0100f08:	83 c0 01             	add    $0x1,%eax
f0100f0b:	39 c6                	cmp    %eax,%esi
f0100f0d:	76 28                	jbe    f0100f37 <page_init+0xb0>
        if (i == MPENTRY_PADDR / PGSIZE)
f0100f0f:	83 f8 07             	cmp    $0x7,%eax
f0100f12:	74 e1                	je     f0100ef5 <page_init+0x6e>
            MARK_FREE(i);
f0100f14:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100f1b:	89 d1                	mov    %edx,%ecx
f0100f1d:	03 0d 9c 92 2c f0    	add    0xf02c929c,%ecx
f0100f23:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100f29:	89 19                	mov    %ebx,(%ecx)
f0100f2b:	89 d3                	mov    %edx,%ebx
f0100f2d:	03 1d 9c 92 2c f0    	add    0xf02c929c,%ebx
f0100f33:	89 fa                	mov    %edi,%edx
f0100f35:	eb d1                	jmp    f0100f08 <page_init+0x81>
f0100f37:	84 d2                	test   %dl,%dl
f0100f39:	75 30                	jne    f0100f6b <page_init+0xe4>
    for (i = 1; i < npages_basemem; i++) {
f0100f3b:	b8 00 05 00 00       	mov    $0x500,%eax
        MARK_USE(i);
f0100f40:	89 c2                	mov    %eax,%edx
f0100f42:	03 15 9c 92 2c f0    	add    0xf02c929c,%edx
f0100f48:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
f0100f4e:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f0100f54:	83 c0 08             	add    $0x8,%eax
    for (i = IOPHYSMEM / PGSIZE; i < EXTPHYSMEM / PGSIZE; i++) {
f0100f57:	3d 00 08 00 00       	cmp    $0x800,%eax
f0100f5c:	75 e2                	jne    f0100f40 <page_init+0xb9>
    for (i = EXTPHYSMEM / PGSIZE; i < kern_pgdir_end / PGSIZE; i++) {
f0100f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f61:	c1 e8 0c             	shr    $0xc,%eax
f0100f64:	ba 00 01 00 00       	mov    $0x100,%edx
f0100f69:	eb 20                	jmp    f0100f8b <page_init+0x104>
f0100f6b:	89 1d 40 02 2b f0    	mov    %ebx,0xf02b0240
f0100f71:	eb c8                	jmp    f0100f3b <page_init+0xb4>
        MARK_USE(i);
f0100f73:	8b 0d 9c 92 2c f0    	mov    0xf02c929c,%ecx
f0100f79:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f0100f7c:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100f82:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    for (i = EXTPHYSMEM / PGSIZE; i < kern_pgdir_end / PGSIZE; i++) {
f0100f88:	83 c2 01             	add    $0x1,%edx
f0100f8b:	39 d0                	cmp    %edx,%eax
f0100f8d:	77 e4                	ja     f0100f73 <page_init+0xec>
f0100f8f:	8b 1d 40 02 2b f0    	mov    0xf02b0240,%ebx
f0100f95:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100f9c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100fa1:	be 01 00 00 00       	mov    $0x1,%esi
f0100fa6:	eb 20                	jmp    f0100fc8 <page_init+0x141>
        MARK_FREE(i);
f0100fa8:	89 d1                	mov    %edx,%ecx
f0100faa:	03 0d 9c 92 2c f0    	add    0xf02c929c,%ecx
f0100fb0:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100fb6:	89 19                	mov    %ebx,(%ecx)
f0100fb8:	89 d3                	mov    %edx,%ebx
f0100fba:	03 1d 9c 92 2c f0    	add    0xf02c929c,%ebx
    for (i = kern_pgdir_end / PGSIZE; i < npages; i++) {
f0100fc0:	83 c0 01             	add    $0x1,%eax
f0100fc3:	83 c2 08             	add    $0x8,%edx
f0100fc6:	89 f1                	mov    %esi,%ecx
f0100fc8:	39 05 94 92 2c f0    	cmp    %eax,0xf02c9294
f0100fce:	77 d8                	ja     f0100fa8 <page_init+0x121>
f0100fd0:	84 c9                	test   %cl,%cl
f0100fd2:	75 08                	jne    f0100fdc <page_init+0x155>
}
f0100fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100fd7:	5b                   	pop    %ebx
f0100fd8:	5e                   	pop    %esi
f0100fd9:	5f                   	pop    %edi
f0100fda:	5d                   	pop    %ebp
f0100fdb:	c3                   	ret    
f0100fdc:	89 1d 40 02 2b f0    	mov    %ebx,0xf02b0240
f0100fe2:	eb f0                	jmp    f0100fd4 <page_init+0x14d>

f0100fe4 <page_alloc>:
{
f0100fe4:	55                   	push   %ebp
f0100fe5:	89 e5                	mov    %esp,%ebp
f0100fe7:	53                   	push   %ebx
f0100fe8:	83 ec 04             	sub    $0x4,%esp
    if (!page_free_list) {
f0100feb:	8b 1d 40 02 2b f0    	mov    0xf02b0240,%ebx
f0100ff1:	85 db                	test   %ebx,%ebx
f0100ff3:	74 19                	je     f010100e <page_alloc+0x2a>
    page_free_list = page_free_list->pp_link;
f0100ff5:	8b 03                	mov    (%ebx),%eax
f0100ff7:	a3 40 02 2b f0       	mov    %eax,0xf02b0240
    alloc_page->pp_link = NULL;
f0100ffc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    alloc_page->pp_ref = 0;
f0101002:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
    if (alloc_flags & ALLOC_ZERO) {
f0101008:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f010100c:	75 07                	jne    f0101015 <page_alloc+0x31>
}
f010100e:	89 d8                	mov    %ebx,%eax
f0101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101013:	c9                   	leave  
f0101014:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101015:	89 d8                	mov    %ebx,%eax
f0101017:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f010101d:	c1 f8 03             	sar    $0x3,%eax
f0101020:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101023:	89 c2                	mov    %eax,%edx
f0101025:	c1 ea 0c             	shr    $0xc,%edx
f0101028:	3b 15 94 92 2c f0    	cmp    0xf02c9294,%edx
f010102e:	73 1a                	jae    f010104a <page_alloc+0x66>
        memset(page2kva(alloc_page), 0, PGSIZE);
f0101030:	83 ec 04             	sub    $0x4,%esp
f0101033:	68 00 10 00 00       	push   $0x1000
f0101038:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010103a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010103f:	50                   	push   %eax
f0101040:	e8 3f 48 00 00       	call   f0105884 <memset>
f0101045:	83 c4 10             	add    $0x10,%esp
f0101048:	eb c4                	jmp    f010100e <page_alloc+0x2a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010104a:	50                   	push   %eax
f010104b:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0101050:	6a 58                	push   $0x58
f0101052:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0101057:	e8 e4 ef ff ff       	call   f0100040 <_panic>

f010105c <page_free>:
{
f010105c:	55                   	push   %ebp
f010105d:	89 e5                	mov    %esp,%ebp
f010105f:	83 ec 08             	sub    $0x8,%esp
f0101062:	8b 45 08             	mov    0x8(%ebp),%eax
    if (pp->pp_ref != 0 || pp->pp_link != NULL) {
f0101065:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010106a:	75 14                	jne    f0101080 <page_free+0x24>
f010106c:	83 38 00             	cmpl   $0x0,(%eax)
f010106f:	75 0f                	jne    f0101080 <page_free+0x24>
    pp->pp_link = page_free_list;
f0101071:	8b 15 40 02 2b f0    	mov    0xf02b0240,%edx
f0101077:	89 10                	mov    %edx,(%eax)
    page_free_list = pp;
f0101079:	a3 40 02 2b f0       	mov    %eax,0xf02b0240
}
f010107e:	c9                   	leave  
f010107f:	c3                   	ret    
        panic("page_free");
f0101080:	83 ec 04             	sub    $0x4,%esp
f0101083:	68 ac 7b 10 f0       	push   $0xf0107bac
f0101088:	68 95 01 00 00       	push   $0x195
f010108d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101092:	e8 a9 ef ff ff       	call   f0100040 <_panic>

f0101097 <page_decref>:
{
f0101097:	55                   	push   %ebp
f0101098:	89 e5                	mov    %esp,%ebp
f010109a:	83 ec 08             	sub    $0x8,%esp
f010109d:	8b 55 08             	mov    0x8(%ebp),%edx
    if (--pp->pp_ref == 0)
f01010a0:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01010a4:	83 e8 01             	sub    $0x1,%eax
f01010a7:	66 89 42 04          	mov    %ax,0x4(%edx)
f01010ab:	66 85 c0             	test   %ax,%ax
f01010ae:	74 02                	je     f01010b2 <page_decref+0x1b>
}
f01010b0:	c9                   	leave  
f01010b1:	c3                   	ret    
        page_free(pp);
f01010b2:	83 ec 0c             	sub    $0xc,%esp
f01010b5:	52                   	push   %edx
f01010b6:	e8 a1 ff ff ff       	call   f010105c <page_free>
f01010bb:	83 c4 10             	add    $0x10,%esp
}
f01010be:	eb f0                	jmp    f01010b0 <page_decref+0x19>

f01010c0 <pgdir_walk>:
{
f01010c0:	55                   	push   %ebp
f01010c1:	89 e5                	mov    %esp,%ebp
f01010c3:	57                   	push   %edi
f01010c4:	56                   	push   %esi
f01010c5:	53                   	push   %ebx
f01010c6:	83 ec 1c             	sub    $0x1c,%esp
    pde = &pgdir[PDX(va)];
f01010c9:	8b 75 0c             	mov    0xc(%ebp),%esi
f01010cc:	c1 ee 16             	shr    $0x16,%esi
f01010cf:	c1 e6 02             	shl    $0x2,%esi
f01010d2:	03 75 08             	add    0x8(%ebp),%esi
    if (*pde & PTE_P) {
f01010d5:	8b 1e                	mov    (%esi),%ebx
f01010d7:	f6 c3 01             	test   $0x1,%bl
f01010da:	74 43                	je     f010111f <pgdir_walk+0x5f>
        pgtab = (pte_t*)KADDR(PTE_ADDR(*pde));
f01010dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (PGNUM(pa) >= npages)
f01010e2:	89 d8                	mov    %ebx,%eax
f01010e4:	c1 e8 0c             	shr    $0xc,%eax
f01010e7:	39 05 94 92 2c f0    	cmp    %eax,0xf02c9294
f01010ed:	76 1b                	jbe    f010110a <pgdir_walk+0x4a>
	return (void *)(pa + KERNBASE);
f01010ef:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
    return &pgtab[PTX(va)];
f01010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01010f8:	c1 e8 0a             	shr    $0xa,%eax
f01010fb:	25 fc 0f 00 00       	and    $0xffc,%eax
f0101100:	01 d8                	add    %ebx,%eax
}
f0101102:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101105:	5b                   	pop    %ebx
f0101106:	5e                   	pop    %esi
f0101107:	5f                   	pop    %edi
f0101108:	5d                   	pop    %ebp
f0101109:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010110a:	53                   	push   %ebx
f010110b:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0101110:	68 c7 01 00 00       	push   $0x1c7
f0101115:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010111a:	e8 21 ef ff ff       	call   f0100040 <_panic>
        struct PageInfo *pp = page_alloc(ALLOC_ZERO);
f010111f:	83 ec 0c             	sub    $0xc,%esp
f0101122:	6a 01                	push   $0x1
f0101124:	e8 bb fe ff ff       	call   f0100fe4 <page_alloc>
        if (!create || !pp)
f0101129:	83 c4 10             	add    $0x10,%esp
f010112c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101130:	0f 84 82 00 00 00    	je     f01011b8 <pgdir_walk+0xf8>
f0101136:	85 c0                	test   %eax,%eax
f0101138:	74 7e                	je     f01011b8 <pgdir_walk+0xf8>
        pp->pp_ref += 1;
f010113a:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010113f:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0101145:	c1 f8 03             	sar    $0x3,%eax
f0101148:	c1 e0 0c             	shl    $0xc,%eax
f010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (PGNUM(pa) >= npages)
f010114e:	c1 e8 0c             	shr    $0xc,%eax
f0101151:	3b 05 94 92 2c f0    	cmp    0xf02c9294,%eax
f0101157:	73 33                	jae    f010118c <pgdir_walk+0xcc>
	return (void *)(pa + KERNBASE);
f0101159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010115c:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
f0101162:	89 fb                	mov    %edi,%ebx
        memset(pgtab, 0, PGSIZE);
f0101164:	83 ec 04             	sub    $0x4,%esp
f0101167:	68 00 10 00 00       	push   $0x1000
f010116c:	6a 00                	push   $0x0
f010116e:	57                   	push   %edi
f010116f:	e8 10 47 00 00       	call   f0105884 <memset>
	if ((uint32_t)kva < KERNBASE)
f0101174:	83 c4 10             	add    $0x10,%esp
f0101177:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f010117d:	76 24                	jbe    f01011a3 <pgdir_walk+0xe3>
        *pde = PADDR(pgtab) | PTE_P | PTE_W | PTE_U;
f010117f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101182:	83 c8 07             	or     $0x7,%eax
f0101185:	89 06                	mov    %eax,(%esi)
f0101187:	e9 69 ff ff ff       	jmp    f01010f5 <pgdir_walk+0x35>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010118c:	ff 75 e4             	pushl  -0x1c(%ebp)
f010118f:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0101194:	68 cd 01 00 00       	push   $0x1cd
f0101199:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010119e:	e8 9d ee ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01011a3:	57                   	push   %edi
f01011a4:	68 e8 6b 10 f0       	push   $0xf0106be8
f01011a9:	68 cf 01 00 00       	push   $0x1cf
f01011ae:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01011b3:	e8 88 ee ff ff       	call   f0100040 <_panic>
            return NULL;
f01011b8:	b8 00 00 00 00       	mov    $0x0,%eax
f01011bd:	e9 40 ff ff ff       	jmp    f0101102 <pgdir_walk+0x42>

f01011c2 <boot_map_region>:
{
f01011c2:	55                   	push   %ebp
f01011c3:	89 e5                	mov    %esp,%ebp
f01011c5:	57                   	push   %edi
f01011c6:	56                   	push   %esi
f01011c7:	53                   	push   %ebx
f01011c8:	83 ec 1c             	sub    $0x1c,%esp
f01011cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (char*)va;
f01011ce:	89 d3                	mov    %edx,%ebx
    last = (char*)(va + size);
f01011d0:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
f01011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01011d6:	8b 7d 08             	mov    0x8(%ebp),%edi
f01011d9:	29 d7                	sub    %edx,%edi
        *pte = pa | perm | PTE_P;
f01011db:	8b 45 0c             	mov    0xc(%ebp),%eax
f01011de:	83 c8 01             	or     $0x1,%eax
f01011e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01011e4:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
        if((pte = pgdir_walk(pgdir, a, 1)) == NULL)
f01011e7:	83 ec 04             	sub    $0x4,%esp
f01011ea:	6a 01                	push   $0x1
f01011ec:	53                   	push   %ebx
f01011ed:	ff 75 e4             	pushl  -0x1c(%ebp)
f01011f0:	e8 cb fe ff ff       	call   f01010c0 <pgdir_walk>
f01011f5:	83 c4 10             	add    $0x10,%esp
f01011f8:	85 c0                	test   %eax,%eax
f01011fa:	74 1d                	je     f0101219 <boot_map_region+0x57>
        if(*pte & PTE_P)
f01011fc:	f6 00 01             	testb  $0x1,(%eax)
f01011ff:	75 2f                	jne    f0101230 <boot_map_region+0x6e>
        *pte = pa | perm | PTE_P;
f0101201:	0b 75 dc             	or     -0x24(%ebp),%esi
f0101204:	89 30                	mov    %esi,(%eax)
        a += PGSIZE;
f0101206:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if (a == last)
f010120c:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
f010120f:	75 d3                	jne    f01011e4 <boot_map_region+0x22>
}
f0101211:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101214:	5b                   	pop    %ebx
f0101215:	5e                   	pop    %esi
f0101216:	5f                   	pop    %edi
f0101217:	5d                   	pop    %ebp
f0101218:	c3                   	ret    
            panic("boot_map_region");
f0101219:	83 ec 04             	sub    $0x4,%esp
f010121c:	68 b6 7b 10 f0       	push   $0xf0107bb6
f0101221:	68 e9 01 00 00       	push   $0x1e9
f0101226:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010122b:	e8 10 ee ff ff       	call   f0100040 <_panic>
            panic("remap");
f0101230:	83 ec 04             	sub    $0x4,%esp
f0101233:	68 c6 7b 10 f0       	push   $0xf0107bc6
f0101238:	68 eb 01 00 00       	push   $0x1eb
f010123d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101242:	e8 f9 ed ff ff       	call   f0100040 <_panic>

f0101247 <page_lookup>:
{
f0101247:	55                   	push   %ebp
f0101248:	89 e5                	mov    %esp,%ebp
f010124a:	53                   	push   %ebx
f010124b:	83 ec 08             	sub    $0x8,%esp
f010124e:	8b 5d 10             	mov    0x10(%ebp),%ebx
    pte_t *pte = pgdir_walk(pgdir, va, 0);
f0101251:	6a 00                	push   $0x0
f0101253:	ff 75 0c             	pushl  0xc(%ebp)
f0101256:	ff 75 08             	pushl  0x8(%ebp)
f0101259:	e8 62 fe ff ff       	call   f01010c0 <pgdir_walk>
    if (!pte || !(*pte & PTE_P)) {
f010125e:	83 c4 10             	add    $0x10,%esp
f0101261:	85 c0                	test   %eax,%eax
f0101263:	74 3a                	je     f010129f <page_lookup+0x58>
f0101265:	f6 00 01             	testb  $0x1,(%eax)
f0101268:	74 3c                	je     f01012a6 <page_lookup+0x5f>
    if (pte_store) {
f010126a:	85 db                	test   %ebx,%ebx
f010126c:	74 02                	je     f0101270 <page_lookup+0x29>
        *pte_store = pte;
f010126e:	89 03                	mov    %eax,(%ebx)
f0101270:	8b 00                	mov    (%eax),%eax
f0101272:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101275:	39 05 94 92 2c f0    	cmp    %eax,0xf02c9294
f010127b:	76 0e                	jbe    f010128b <page_lookup+0x44>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010127d:	8b 15 9c 92 2c f0    	mov    0xf02c929c,%edx
f0101283:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101286:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101289:	c9                   	leave  
f010128a:	c3                   	ret    
		panic("pa2page called with invalid pa");
f010128b:	83 ec 04             	sub    $0x4,%esp
f010128e:	68 6c 72 10 f0       	push   $0xf010726c
f0101293:	6a 51                	push   $0x51
f0101295:	68 e5 7a 10 f0       	push   $0xf0107ae5
f010129a:	e8 a1 ed ff ff       	call   f0100040 <_panic>
        return NULL;
f010129f:	b8 00 00 00 00       	mov    $0x0,%eax
f01012a4:	eb e0                	jmp    f0101286 <page_lookup+0x3f>
f01012a6:	b8 00 00 00 00       	mov    $0x0,%eax
f01012ab:	eb d9                	jmp    f0101286 <page_lookup+0x3f>

f01012ad <tlb_invalidate>:
{
f01012ad:	55                   	push   %ebp
f01012ae:	89 e5                	mov    %esp,%ebp
f01012b0:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01012b3:	e8 ef 4b 00 00       	call   f0105ea7 <cpunum>
f01012b8:	6b c0 74             	imul   $0x74,%eax,%eax
f01012bb:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f01012c2:	74 16                	je     f01012da <tlb_invalidate+0x2d>
f01012c4:	e8 de 4b 00 00       	call   f0105ea7 <cpunum>
f01012c9:	6b c0 74             	imul   $0x74,%eax,%eax
f01012cc:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01012d2:	8b 55 08             	mov    0x8(%ebp),%edx
f01012d5:	39 50 60             	cmp    %edx,0x60(%eax)
f01012d8:	75 06                	jne    f01012e0 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01012da:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012dd:	0f 01 38             	invlpg (%eax)
}
f01012e0:	c9                   	leave  
f01012e1:	c3                   	ret    

f01012e2 <page_remove>:
{
f01012e2:	55                   	push   %ebp
f01012e3:	89 e5                	mov    %esp,%ebp
f01012e5:	56                   	push   %esi
f01012e6:	53                   	push   %ebx
f01012e7:	83 ec 14             	sub    $0x14,%esp
f01012ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01012ed:	8b 75 0c             	mov    0xc(%ebp),%esi
    if ((pp = page_lookup(pgdir, va, &pte))) {
f01012f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01012f3:	50                   	push   %eax
f01012f4:	56                   	push   %esi
f01012f5:	53                   	push   %ebx
f01012f6:	e8 4c ff ff ff       	call   f0101247 <page_lookup>
f01012fb:	83 c4 10             	add    $0x10,%esp
f01012fe:	85 c0                	test   %eax,%eax
f0101300:	74 25                	je     f0101327 <page_remove+0x45>
        page_decref(pp);
f0101302:	83 ec 0c             	sub    $0xc,%esp
f0101305:	50                   	push   %eax
f0101306:	e8 8c fd ff ff       	call   f0101097 <page_decref>
        memset(pte, 0, sizeof(pte_t));
f010130b:	83 c4 0c             	add    $0xc,%esp
f010130e:	6a 04                	push   $0x4
f0101310:	6a 00                	push   $0x0
f0101312:	ff 75 f4             	pushl  -0xc(%ebp)
f0101315:	e8 6a 45 00 00       	call   f0105884 <memset>
        tlb_invalidate(pgdir, va);
f010131a:	83 c4 08             	add    $0x8,%esp
f010131d:	56                   	push   %esi
f010131e:	53                   	push   %ebx
f010131f:	e8 89 ff ff ff       	call   f01012ad <tlb_invalidate>
f0101324:	83 c4 10             	add    $0x10,%esp
}
f0101327:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010132a:	5b                   	pop    %ebx
f010132b:	5e                   	pop    %esi
f010132c:	5d                   	pop    %ebp
f010132d:	c3                   	ret    

f010132e <page_insert>:
{
f010132e:	55                   	push   %ebp
f010132f:	89 e5                	mov    %esp,%ebp
f0101331:	57                   	push   %edi
f0101332:	56                   	push   %esi
f0101333:	53                   	push   %ebx
f0101334:	83 ec 10             	sub    $0x10,%esp
f0101337:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010133a:	8b 7d 10             	mov    0x10(%ebp),%edi
    if (!(pte = pgdir_walk(pgdir, va, 1))) {
f010133d:	6a 01                	push   $0x1
f010133f:	57                   	push   %edi
f0101340:	ff 75 08             	pushl  0x8(%ebp)
f0101343:	e8 78 fd ff ff       	call   f01010c0 <pgdir_walk>
f0101348:	83 c4 10             	add    $0x10,%esp
f010134b:	85 c0                	test   %eax,%eax
f010134d:	74 39                	je     f0101388 <page_insert+0x5a>
f010134f:	89 c6                	mov    %eax,%esi
    pp->pp_ref++;
f0101351:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
    page_remove(pgdir, va);
f0101356:	83 ec 08             	sub    $0x8,%esp
f0101359:	57                   	push   %edi
f010135a:	ff 75 08             	pushl  0x8(%ebp)
f010135d:	e8 80 ff ff ff       	call   f01012e2 <page_remove>
	return (pp - pages) << PGSHIFT;
f0101362:	2b 1d 9c 92 2c f0    	sub    0xf02c929c,%ebx
f0101368:	c1 fb 03             	sar    $0x3,%ebx
f010136b:	c1 e3 0c             	shl    $0xc,%ebx
    *pte = page2pa(pp) | perm | PTE_P;
f010136e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101371:	83 c8 01             	or     $0x1,%eax
f0101374:	09 c3                	or     %eax,%ebx
f0101376:	89 1e                	mov    %ebx,(%esi)
    return 0;
f0101378:	83 c4 10             	add    $0x10,%esp
f010137b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101380:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101383:	5b                   	pop    %ebx
f0101384:	5e                   	pop    %esi
f0101385:	5f                   	pop    %edi
f0101386:	5d                   	pop    %ebp
f0101387:	c3                   	ret    
        return -E_NO_MEM;
f0101388:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010138d:	eb f1                	jmp    f0101380 <page_insert+0x52>

f010138f <mmio_map_region>:
{
f010138f:	55                   	push   %ebp
f0101390:	89 e5                	mov    %esp,%ebp
f0101392:	53                   	push   %ebx
f0101393:	83 ec 04             	sub    $0x4,%esp
	size_t rounded_size = ROUNDUP(size, PGSIZE);
f0101396:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101399:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f010139f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (base + rounded_size >= MMIOLIM) {
f01013a5:	8b 15 00 43 12 f0    	mov    0xf0124300,%edx
f01013ab:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f01013ae:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01013b3:	77 26                	ja     f01013db <mmio_map_region+0x4c>
	boot_map_region(kern_pgdir, base, rounded_size, pa, PTE_PCD | PTE_PWT | PTE_W);
f01013b5:	83 ec 08             	sub    $0x8,%esp
f01013b8:	6a 1a                	push   $0x1a
f01013ba:	ff 75 08             	pushl  0x8(%ebp)
f01013bd:	89 d9                	mov    %ebx,%ecx
f01013bf:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f01013c4:	e8 f9 fd ff ff       	call   f01011c2 <boot_map_region>
	uintptr_t curr_base = base;
f01013c9:	a1 00 43 12 f0       	mov    0xf0124300,%eax
	base += rounded_size;
f01013ce:	01 c3                	add    %eax,%ebx
f01013d0:	89 1d 00 43 12 f0    	mov    %ebx,0xf0124300
}
f01013d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01013d9:	c9                   	leave  
f01013da:	c3                   	ret    
	    panic("mmio_map_region: requested size overflow MMIOLIM");
f01013db:	83 ec 04             	sub    $0x4,%esp
f01013de:	68 8c 72 10 f0       	push   $0xf010728c
f01013e3:	68 86 02 00 00       	push   $0x286
f01013e8:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01013ed:	e8 4e ec ff ff       	call   f0100040 <_panic>

f01013f2 <mem_init>:
{
f01013f2:	55                   	push   %ebp
f01013f3:	89 e5                	mov    %esp,%ebp
f01013f5:	57                   	push   %edi
f01013f6:	56                   	push   %esi
f01013f7:	53                   	push   %ebx
f01013f8:	83 ec 3c             	sub    $0x3c,%esp
    basemem = nvram_read(NVRAM_BASELO);
f01013fb:	b8 15 00 00 00       	mov    $0x15,%eax
f0101400:	e8 f8 f6 ff ff       	call   f0100afd <nvram_read>
f0101405:	89 c3                	mov    %eax,%ebx
    extmem = nvram_read(NVRAM_EXTLO);
f0101407:	b8 17 00 00 00       	mov    $0x17,%eax
f010140c:	e8 ec f6 ff ff       	call   f0100afd <nvram_read>
f0101411:	89 c6                	mov    %eax,%esi
    ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101413:	b8 34 00 00 00       	mov    $0x34,%eax
f0101418:	e8 e0 f6 ff ff       	call   f0100afd <nvram_read>
f010141d:	c1 e0 06             	shl    $0x6,%eax
    if (ext16mem)
f0101420:	85 c0                	test   %eax,%eax
f0101422:	0f 85 d0 00 00 00    	jne    f01014f8 <mem_init+0x106>
        totalmem = 1 * 1024 + extmem;
f0101428:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010142e:	85 f6                	test   %esi,%esi
f0101430:	0f 44 c3             	cmove  %ebx,%eax
    npages = totalmem / (PGSIZE / 1024);
f0101433:	89 c2                	mov    %eax,%edx
f0101435:	c1 ea 02             	shr    $0x2,%edx
f0101438:	89 15 94 92 2c f0    	mov    %edx,0xf02c9294
    npages_basemem = basemem / (PGSIZE / 1024);
f010143e:	89 da                	mov    %ebx,%edx
f0101440:	c1 ea 02             	shr    $0x2,%edx
f0101443:	89 15 44 02 2b f0    	mov    %edx,0xf02b0244
    cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101449:	89 c2                	mov    %eax,%edx
f010144b:	29 da                	sub    %ebx,%edx
f010144d:	52                   	push   %edx
f010144e:	53                   	push   %ebx
f010144f:	50                   	push   %eax
f0101450:	68 c0 72 10 f0       	push   $0xf01072c0
f0101455:	e8 f2 24 00 00       	call   f010394c <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f010145a:	b8 00 10 00 00       	mov    $0x1000,%eax
f010145f:	e8 5b f6 ff ff       	call   f0100abf <boot_alloc>
f0101464:	a3 98 92 2c f0       	mov    %eax,0xf02c9298
	memset(kern_pgdir, 0, PGSIZE);
f0101469:	83 c4 0c             	add    $0xc,%esp
f010146c:	68 00 10 00 00       	push   $0x1000
f0101471:	6a 00                	push   $0x0
f0101473:	50                   	push   %eax
f0101474:	e8 0b 44 00 00       	call   f0105884 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101479:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
	if ((uint32_t)kva < KERNBASE)
f010147e:	83 c4 10             	add    $0x10,%esp
f0101481:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101486:	76 7a                	jbe    f0101502 <mem_init+0x110>
	return (physaddr_t)kva - KERNBASE;
f0101488:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010148e:	83 ca 05             	or     $0x5,%edx
f0101491:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*) boot_alloc(sizeof(struct PageInfo) * npages);
f0101497:	a1 94 92 2c f0       	mov    0xf02c9294,%eax
f010149c:	c1 e0 03             	shl    $0x3,%eax
f010149f:	e8 1b f6 ff ff       	call   f0100abf <boot_alloc>
f01014a4:	a3 9c 92 2c f0       	mov    %eax,0xf02c929c
    memset(pages, 0, sizeof(struct PageInfo) * npages);
f01014a9:	83 ec 04             	sub    $0x4,%esp
f01014ac:	8b 0d 94 92 2c f0    	mov    0xf02c9294,%ecx
f01014b2:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f01014b9:	52                   	push   %edx
f01014ba:	6a 00                	push   $0x0
f01014bc:	50                   	push   %eax
f01014bd:	e8 c2 43 00 00       	call   f0105884 <memset>
	envs = (struct Env*) boot_alloc(sizeof(struct Env) * NENV);
f01014c2:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01014c7:	e8 f3 f5 ff ff       	call   f0100abf <boot_alloc>
f01014cc:	a3 48 02 2b f0       	mov    %eax,0xf02b0248
	page_init();
f01014d1:	e8 b1 f9 ff ff       	call   f0100e87 <page_init>
	check_page_free_list(1);
f01014d6:	b8 01 00 00 00       	mov    $0x1,%eax
f01014db:	e8 aa f6 ff ff       	call   f0100b8a <check_page_free_list>
    if (!pages)
f01014e0:	83 c4 10             	add    $0x10,%esp
f01014e3:	83 3d 9c 92 2c f0 00 	cmpl   $0x0,0xf02c929c
f01014ea:	74 2b                	je     f0101517 <mem_init+0x125>
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01014ec:	a1 40 02 2b f0       	mov    0xf02b0240,%eax
f01014f1:	bb 00 00 00 00       	mov    $0x0,%ebx
f01014f6:	eb 3b                	jmp    f0101533 <mem_init+0x141>
        totalmem = 16 * 1024 + ext16mem;
f01014f8:	05 00 40 00 00       	add    $0x4000,%eax
f01014fd:	e9 31 ff ff ff       	jmp    f0101433 <mem_init+0x41>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101502:	50                   	push   %eax
f0101503:	68 e8 6b 10 f0       	push   $0xf0106be8
f0101508:	68 98 00 00 00       	push   $0x98
f010150d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101512:	e8 29 eb ff ff       	call   f0100040 <_panic>
        panic("'pages' is a null pointer!");
f0101517:	83 ec 04             	sub    $0x4,%esp
f010151a:	68 cc 7b 10 f0       	push   $0xf0107bcc
f010151f:	68 1a 03 00 00       	push   $0x31a
f0101524:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101529:	e8 12 eb ff ff       	call   f0100040 <_panic>
        ++nfree;
f010152e:	83 c3 01             	add    $0x1,%ebx
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101531:	8b 00                	mov    (%eax),%eax
f0101533:	85 c0                	test   %eax,%eax
f0101535:	75 f7                	jne    f010152e <mem_init+0x13c>
    assert((pp0 = page_alloc(0)));
f0101537:	83 ec 0c             	sub    $0xc,%esp
f010153a:	6a 00                	push   $0x0
f010153c:	e8 a3 fa ff ff       	call   f0100fe4 <page_alloc>
f0101541:	89 c7                	mov    %eax,%edi
f0101543:	83 c4 10             	add    $0x10,%esp
f0101546:	85 c0                	test   %eax,%eax
f0101548:	0f 84 12 02 00 00    	je     f0101760 <mem_init+0x36e>
    assert((pp1 = page_alloc(0)));
f010154e:	83 ec 0c             	sub    $0xc,%esp
f0101551:	6a 00                	push   $0x0
f0101553:	e8 8c fa ff ff       	call   f0100fe4 <page_alloc>
f0101558:	89 c6                	mov    %eax,%esi
f010155a:	83 c4 10             	add    $0x10,%esp
f010155d:	85 c0                	test   %eax,%eax
f010155f:	0f 84 14 02 00 00    	je     f0101779 <mem_init+0x387>
    assert((pp2 = page_alloc(0)));
f0101565:	83 ec 0c             	sub    $0xc,%esp
f0101568:	6a 00                	push   $0x0
f010156a:	e8 75 fa ff ff       	call   f0100fe4 <page_alloc>
f010156f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101572:	83 c4 10             	add    $0x10,%esp
f0101575:	85 c0                	test   %eax,%eax
f0101577:	0f 84 15 02 00 00    	je     f0101792 <mem_init+0x3a0>
    assert(pp1 && pp1 != pp0);
f010157d:	39 f7                	cmp    %esi,%edi
f010157f:	0f 84 26 02 00 00    	je     f01017ab <mem_init+0x3b9>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101588:	39 c6                	cmp    %eax,%esi
f010158a:	0f 84 34 02 00 00    	je     f01017c4 <mem_init+0x3d2>
f0101590:	39 c7                	cmp    %eax,%edi
f0101592:	0f 84 2c 02 00 00    	je     f01017c4 <mem_init+0x3d2>
	return (pp - pages) << PGSHIFT;
f0101598:	8b 0d 9c 92 2c f0    	mov    0xf02c929c,%ecx
    assert(page2pa(pp0) < npages*PGSIZE);
f010159e:	8b 15 94 92 2c f0    	mov    0xf02c9294,%edx
f01015a4:	c1 e2 0c             	shl    $0xc,%edx
f01015a7:	89 f8                	mov    %edi,%eax
f01015a9:	29 c8                	sub    %ecx,%eax
f01015ab:	c1 f8 03             	sar    $0x3,%eax
f01015ae:	c1 e0 0c             	shl    $0xc,%eax
f01015b1:	39 d0                	cmp    %edx,%eax
f01015b3:	0f 83 24 02 00 00    	jae    f01017dd <mem_init+0x3eb>
f01015b9:	89 f0                	mov    %esi,%eax
f01015bb:	29 c8                	sub    %ecx,%eax
f01015bd:	c1 f8 03             	sar    $0x3,%eax
f01015c0:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp1) < npages*PGSIZE);
f01015c3:	39 c2                	cmp    %eax,%edx
f01015c5:	0f 86 2b 02 00 00    	jbe    f01017f6 <mem_init+0x404>
f01015cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01015ce:	29 c8                	sub    %ecx,%eax
f01015d0:	c1 f8 03             	sar    $0x3,%eax
f01015d3:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp2) < npages*PGSIZE);
f01015d6:	39 c2                	cmp    %eax,%edx
f01015d8:	0f 86 31 02 00 00    	jbe    f010180f <mem_init+0x41d>
    fl = page_free_list;
f01015de:	a1 40 02 2b f0       	mov    0xf02b0240,%eax
f01015e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    page_free_list = 0;
f01015e6:	c7 05 40 02 2b f0 00 	movl   $0x0,0xf02b0240
f01015ed:	00 00 00 
    assert(!page_alloc(0));
f01015f0:	83 ec 0c             	sub    $0xc,%esp
f01015f3:	6a 00                	push   $0x0
f01015f5:	e8 ea f9 ff ff       	call   f0100fe4 <page_alloc>
f01015fa:	83 c4 10             	add    $0x10,%esp
f01015fd:	85 c0                	test   %eax,%eax
f01015ff:	0f 85 23 02 00 00    	jne    f0101828 <mem_init+0x436>
    page_free(pp0);
f0101605:	83 ec 0c             	sub    $0xc,%esp
f0101608:	57                   	push   %edi
f0101609:	e8 4e fa ff ff       	call   f010105c <page_free>
    page_free(pp1);
f010160e:	89 34 24             	mov    %esi,(%esp)
f0101611:	e8 46 fa ff ff       	call   f010105c <page_free>
    page_free(pp2);
f0101616:	83 c4 04             	add    $0x4,%esp
f0101619:	ff 75 d4             	pushl  -0x2c(%ebp)
f010161c:	e8 3b fa ff ff       	call   f010105c <page_free>
    assert((pp0 = page_alloc(0)));
f0101621:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101628:	e8 b7 f9 ff ff       	call   f0100fe4 <page_alloc>
f010162d:	89 c6                	mov    %eax,%esi
f010162f:	83 c4 10             	add    $0x10,%esp
f0101632:	85 c0                	test   %eax,%eax
f0101634:	0f 84 07 02 00 00    	je     f0101841 <mem_init+0x44f>
    assert((pp1 = page_alloc(0)));
f010163a:	83 ec 0c             	sub    $0xc,%esp
f010163d:	6a 00                	push   $0x0
f010163f:	e8 a0 f9 ff ff       	call   f0100fe4 <page_alloc>
f0101644:	89 c7                	mov    %eax,%edi
f0101646:	83 c4 10             	add    $0x10,%esp
f0101649:	85 c0                	test   %eax,%eax
f010164b:	0f 84 09 02 00 00    	je     f010185a <mem_init+0x468>
    assert((pp2 = page_alloc(0)));
f0101651:	83 ec 0c             	sub    $0xc,%esp
f0101654:	6a 00                	push   $0x0
f0101656:	e8 89 f9 ff ff       	call   f0100fe4 <page_alloc>
f010165b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010165e:	83 c4 10             	add    $0x10,%esp
f0101661:	85 c0                	test   %eax,%eax
f0101663:	0f 84 0a 02 00 00    	je     f0101873 <mem_init+0x481>
    assert(pp1 && pp1 != pp0);
f0101669:	39 fe                	cmp    %edi,%esi
f010166b:	0f 84 1b 02 00 00    	je     f010188c <mem_init+0x49a>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101671:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101674:	39 c6                	cmp    %eax,%esi
f0101676:	0f 84 29 02 00 00    	je     f01018a5 <mem_init+0x4b3>
f010167c:	39 c7                	cmp    %eax,%edi
f010167e:	0f 84 21 02 00 00    	je     f01018a5 <mem_init+0x4b3>
    assert(!page_alloc(0));
f0101684:	83 ec 0c             	sub    $0xc,%esp
f0101687:	6a 00                	push   $0x0
f0101689:	e8 56 f9 ff ff       	call   f0100fe4 <page_alloc>
f010168e:	83 c4 10             	add    $0x10,%esp
f0101691:	85 c0                	test   %eax,%eax
f0101693:	0f 85 25 02 00 00    	jne    f01018be <mem_init+0x4cc>
f0101699:	89 f0                	mov    %esi,%eax
f010169b:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f01016a1:	c1 f8 03             	sar    $0x3,%eax
f01016a4:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01016a7:	89 c2                	mov    %eax,%edx
f01016a9:	c1 ea 0c             	shr    $0xc,%edx
f01016ac:	3b 15 94 92 2c f0    	cmp    0xf02c9294,%edx
f01016b2:	0f 83 1f 02 00 00    	jae    f01018d7 <mem_init+0x4e5>
    memset(page2kva(pp0), 1, PGSIZE);
f01016b8:	83 ec 04             	sub    $0x4,%esp
f01016bb:	68 00 10 00 00       	push   $0x1000
f01016c0:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01016c2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01016c7:	50                   	push   %eax
f01016c8:	e8 b7 41 00 00       	call   f0105884 <memset>
    page_free(pp0);
f01016cd:	89 34 24             	mov    %esi,(%esp)
f01016d0:	e8 87 f9 ff ff       	call   f010105c <page_free>
    assert((pp = page_alloc(ALLOC_ZERO)));
f01016d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01016dc:	e8 03 f9 ff ff       	call   f0100fe4 <page_alloc>
f01016e1:	83 c4 10             	add    $0x10,%esp
f01016e4:	85 c0                	test   %eax,%eax
f01016e6:	0f 84 fd 01 00 00    	je     f01018e9 <mem_init+0x4f7>
    assert(pp && pp0 == pp);
f01016ec:	39 c6                	cmp    %eax,%esi
f01016ee:	0f 85 0e 02 00 00    	jne    f0101902 <mem_init+0x510>
	return (pp - pages) << PGSHIFT;
f01016f4:	89 f2                	mov    %esi,%edx
f01016f6:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
f01016fc:	c1 fa 03             	sar    $0x3,%edx
f01016ff:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101702:	89 d0                	mov    %edx,%eax
f0101704:	c1 e8 0c             	shr    $0xc,%eax
f0101707:	3b 05 94 92 2c f0    	cmp    0xf02c9294,%eax
f010170d:	0f 83 08 02 00 00    	jae    f010191b <mem_init+0x529>
	return (void *)(pa + KERNBASE);
f0101713:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101719:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
        assert(c[i] == 0);
f010171f:	80 38 00             	cmpb   $0x0,(%eax)
f0101722:	0f 85 05 02 00 00    	jne    f010192d <mem_init+0x53b>
f0101728:	83 c0 01             	add    $0x1,%eax
    for (i = 0; i < PGSIZE; i++)
f010172b:	39 d0                	cmp    %edx,%eax
f010172d:	75 f0                	jne    f010171f <mem_init+0x32d>
    page_free_list = fl;
f010172f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101732:	a3 40 02 2b f0       	mov    %eax,0xf02b0240
    page_free(pp0);
f0101737:	83 ec 0c             	sub    $0xc,%esp
f010173a:	56                   	push   %esi
f010173b:	e8 1c f9 ff ff       	call   f010105c <page_free>
    page_free(pp1);
f0101740:	89 3c 24             	mov    %edi,(%esp)
f0101743:	e8 14 f9 ff ff       	call   f010105c <page_free>
    page_free(pp2);
f0101748:	83 c4 04             	add    $0x4,%esp
f010174b:	ff 75 d4             	pushl  -0x2c(%ebp)
f010174e:	e8 09 f9 ff ff       	call   f010105c <page_free>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101753:	a1 40 02 2b f0       	mov    0xf02b0240,%eax
f0101758:	83 c4 10             	add    $0x10,%esp
f010175b:	e9 eb 01 00 00       	jmp    f010194b <mem_init+0x559>
    assert((pp0 = page_alloc(0)));
f0101760:	68 e7 7b 10 f0       	push   $0xf0107be7
f0101765:	68 ff 7a 10 f0       	push   $0xf0107aff
f010176a:	68 22 03 00 00       	push   $0x322
f010176f:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101774:	e8 c7 e8 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f0101779:	68 fd 7b 10 f0       	push   $0xf0107bfd
f010177e:	68 ff 7a 10 f0       	push   $0xf0107aff
f0101783:	68 23 03 00 00       	push   $0x323
f0101788:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010178d:	e8 ae e8 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0101792:	68 13 7c 10 f0       	push   $0xf0107c13
f0101797:	68 ff 7a 10 f0       	push   $0xf0107aff
f010179c:	68 24 03 00 00       	push   $0x324
f01017a1:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01017a6:	e8 95 e8 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f01017ab:	68 29 7c 10 f0       	push   $0xf0107c29
f01017b0:	68 ff 7a 10 f0       	push   $0xf0107aff
f01017b5:	68 27 03 00 00       	push   $0x327
f01017ba:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01017bf:	e8 7c e8 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017c4:	68 fc 72 10 f0       	push   $0xf01072fc
f01017c9:	68 ff 7a 10 f0       	push   $0xf0107aff
f01017ce:	68 28 03 00 00       	push   $0x328
f01017d3:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01017d8:	e8 63 e8 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp0) < npages*PGSIZE);
f01017dd:	68 3b 7c 10 f0       	push   $0xf0107c3b
f01017e2:	68 ff 7a 10 f0       	push   $0xf0107aff
f01017e7:	68 29 03 00 00       	push   $0x329
f01017ec:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01017f1:	e8 4a e8 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp1) < npages*PGSIZE);
f01017f6:	68 58 7c 10 f0       	push   $0xf0107c58
f01017fb:	68 ff 7a 10 f0       	push   $0xf0107aff
f0101800:	68 2a 03 00 00       	push   $0x32a
f0101805:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010180a:	e8 31 e8 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp2) < npages*PGSIZE);
f010180f:	68 75 7c 10 f0       	push   $0xf0107c75
f0101814:	68 ff 7a 10 f0       	push   $0xf0107aff
f0101819:	68 2b 03 00 00       	push   $0x32b
f010181e:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101823:	e8 18 e8 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0101828:	68 92 7c 10 f0       	push   $0xf0107c92
f010182d:	68 ff 7a 10 f0       	push   $0xf0107aff
f0101832:	68 32 03 00 00       	push   $0x332
f0101837:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010183c:	e8 ff e7 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0101841:	68 e7 7b 10 f0       	push   $0xf0107be7
f0101846:	68 ff 7a 10 f0       	push   $0xf0107aff
f010184b:	68 39 03 00 00       	push   $0x339
f0101850:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101855:	e8 e6 e7 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f010185a:	68 fd 7b 10 f0       	push   $0xf0107bfd
f010185f:	68 ff 7a 10 f0       	push   $0xf0107aff
f0101864:	68 3a 03 00 00       	push   $0x33a
f0101869:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010186e:	e8 cd e7 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0101873:	68 13 7c 10 f0       	push   $0xf0107c13
f0101878:	68 ff 7a 10 f0       	push   $0xf0107aff
f010187d:	68 3b 03 00 00       	push   $0x33b
f0101882:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101887:	e8 b4 e7 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f010188c:	68 29 7c 10 f0       	push   $0xf0107c29
f0101891:	68 ff 7a 10 f0       	push   $0xf0107aff
f0101896:	68 3d 03 00 00       	push   $0x33d
f010189b:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01018a0:	e8 9b e7 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018a5:	68 fc 72 10 f0       	push   $0xf01072fc
f01018aa:	68 ff 7a 10 f0       	push   $0xf0107aff
f01018af:	68 3e 03 00 00       	push   $0x33e
f01018b4:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01018b9:	e8 82 e7 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f01018be:	68 92 7c 10 f0       	push   $0xf0107c92
f01018c3:	68 ff 7a 10 f0       	push   $0xf0107aff
f01018c8:	68 3f 03 00 00       	push   $0x33f
f01018cd:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01018d2:	e8 69 e7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01018d7:	50                   	push   %eax
f01018d8:	68 c4 6b 10 f0       	push   $0xf0106bc4
f01018dd:	6a 58                	push   $0x58
f01018df:	68 e5 7a 10 f0       	push   $0xf0107ae5
f01018e4:	e8 57 e7 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(ALLOC_ZERO)));
f01018e9:	68 a1 7c 10 f0       	push   $0xf0107ca1
f01018ee:	68 ff 7a 10 f0       	push   $0xf0107aff
f01018f3:	68 44 03 00 00       	push   $0x344
f01018f8:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01018fd:	e8 3e e7 ff ff       	call   f0100040 <_panic>
    assert(pp && pp0 == pp);
f0101902:	68 bf 7c 10 f0       	push   $0xf0107cbf
f0101907:	68 ff 7a 10 f0       	push   $0xf0107aff
f010190c:	68 45 03 00 00       	push   $0x345
f0101911:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101916:	e8 25 e7 ff ff       	call   f0100040 <_panic>
f010191b:	52                   	push   %edx
f010191c:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0101921:	6a 58                	push   $0x58
f0101923:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0101928:	e8 13 e7 ff ff       	call   f0100040 <_panic>
        assert(c[i] == 0);
f010192d:	68 cf 7c 10 f0       	push   $0xf0107ccf
f0101932:	68 ff 7a 10 f0       	push   $0xf0107aff
f0101937:	68 48 03 00 00       	push   $0x348
f010193c:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0101941:	e8 fa e6 ff ff       	call   f0100040 <_panic>
        --nfree;
f0101946:	83 eb 01             	sub    $0x1,%ebx
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101949:	8b 00                	mov    (%eax),%eax
f010194b:	85 c0                	test   %eax,%eax
f010194d:	75 f7                	jne    f0101946 <mem_init+0x554>
    assert(nfree == 0);
f010194f:	85 db                	test   %ebx,%ebx
f0101951:	0f 85 33 09 00 00    	jne    f010228a <mem_init+0xe98>
    cprintf("check_page_alloc() succeeded!\n");
f0101957:	83 ec 0c             	sub    $0xc,%esp
f010195a:	68 1c 73 10 f0       	push   $0xf010731c
f010195f:	e8 e8 1f 00 00       	call   f010394c <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101964:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010196b:	e8 74 f6 ff ff       	call   f0100fe4 <page_alloc>
f0101970:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101973:	83 c4 10             	add    $0x10,%esp
f0101976:	85 c0                	test   %eax,%eax
f0101978:	0f 84 25 09 00 00    	je     f01022a3 <mem_init+0xeb1>
	assert((pp1 = page_alloc(0)));
f010197e:	83 ec 0c             	sub    $0xc,%esp
f0101981:	6a 00                	push   $0x0
f0101983:	e8 5c f6 ff ff       	call   f0100fe4 <page_alloc>
f0101988:	89 c3                	mov    %eax,%ebx
f010198a:	83 c4 10             	add    $0x10,%esp
f010198d:	85 c0                	test   %eax,%eax
f010198f:	0f 84 27 09 00 00    	je     f01022bc <mem_init+0xeca>
	assert((pp2 = page_alloc(0)));
f0101995:	83 ec 0c             	sub    $0xc,%esp
f0101998:	6a 00                	push   $0x0
f010199a:	e8 45 f6 ff ff       	call   f0100fe4 <page_alloc>
f010199f:	89 c6                	mov    %eax,%esi
f01019a1:	83 c4 10             	add    $0x10,%esp
f01019a4:	85 c0                	test   %eax,%eax
f01019a6:	0f 84 29 09 00 00    	je     f01022d5 <mem_init+0xee3>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01019ac:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01019af:	0f 84 39 09 00 00    	je     f01022ee <mem_init+0xefc>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019b5:	39 c3                	cmp    %eax,%ebx
f01019b7:	0f 84 4a 09 00 00    	je     f0102307 <mem_init+0xf15>
f01019bd:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01019c0:	0f 84 41 09 00 00    	je     f0102307 <mem_init+0xf15>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01019c6:	a1 40 02 2b f0       	mov    0xf02b0240,%eax
f01019cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f01019ce:	c7 05 40 02 2b f0 00 	movl   $0x0,0xf02b0240
f01019d5:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01019d8:	83 ec 0c             	sub    $0xc,%esp
f01019db:	6a 00                	push   $0x0
f01019dd:	e8 02 f6 ff ff       	call   f0100fe4 <page_alloc>
f01019e2:	83 c4 10             	add    $0x10,%esp
f01019e5:	85 c0                	test   %eax,%eax
f01019e7:	0f 85 33 09 00 00    	jne    f0102320 <mem_init+0xf2e>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01019ed:	83 ec 04             	sub    $0x4,%esp
f01019f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01019f3:	50                   	push   %eax
f01019f4:	6a 00                	push   $0x0
f01019f6:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f01019fc:	e8 46 f8 ff ff       	call   f0101247 <page_lookup>
f0101a01:	83 c4 10             	add    $0x10,%esp
f0101a04:	85 c0                	test   %eax,%eax
f0101a06:	0f 85 2d 09 00 00    	jne    f0102339 <mem_init+0xf47>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101a0c:	6a 02                	push   $0x2
f0101a0e:	6a 00                	push   $0x0
f0101a10:	53                   	push   %ebx
f0101a11:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101a17:	e8 12 f9 ff ff       	call   f010132e <page_insert>
f0101a1c:	83 c4 10             	add    $0x10,%esp
f0101a1f:	85 c0                	test   %eax,%eax
f0101a21:	0f 89 2b 09 00 00    	jns    f0102352 <mem_init+0xf60>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101a27:	83 ec 0c             	sub    $0xc,%esp
f0101a2a:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101a2d:	e8 2a f6 ff ff       	call   f010105c <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101a32:	6a 02                	push   $0x2
f0101a34:	6a 00                	push   $0x0
f0101a36:	53                   	push   %ebx
f0101a37:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101a3d:	e8 ec f8 ff ff       	call   f010132e <page_insert>
f0101a42:	83 c4 20             	add    $0x20,%esp
f0101a45:	85 c0                	test   %eax,%eax
f0101a47:	0f 85 1e 09 00 00    	jne    f010236b <mem_init+0xf79>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101a4d:	8b 3d 98 92 2c f0    	mov    0xf02c9298,%edi
	return (pp - pages) << PGSHIFT;
f0101a53:	8b 0d 9c 92 2c f0    	mov    0xf02c929c,%ecx
f0101a59:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101a5c:	8b 17                	mov    (%edi),%edx
f0101a5e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101a64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a67:	29 c8                	sub    %ecx,%eax
f0101a69:	c1 f8 03             	sar    $0x3,%eax
f0101a6c:	c1 e0 0c             	shl    $0xc,%eax
f0101a6f:	39 c2                	cmp    %eax,%edx
f0101a71:	0f 85 0d 09 00 00    	jne    f0102384 <mem_init+0xf92>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101a77:	ba 00 00 00 00       	mov    $0x0,%edx
f0101a7c:	89 f8                	mov    %edi,%eax
f0101a7e:	e8 a3 f0 ff ff       	call   f0100b26 <check_va2pa>
f0101a83:	89 da                	mov    %ebx,%edx
f0101a85:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101a88:	c1 fa 03             	sar    $0x3,%edx
f0101a8b:	c1 e2 0c             	shl    $0xc,%edx
f0101a8e:	39 d0                	cmp    %edx,%eax
f0101a90:	0f 85 07 09 00 00    	jne    f010239d <mem_init+0xfab>
	assert(pp1->pp_ref == 1);
f0101a96:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101a9b:	0f 85 15 09 00 00    	jne    f01023b6 <mem_init+0xfc4>
	assert(pp0->pp_ref == 1);
f0101aa1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101aa4:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101aa9:	0f 85 20 09 00 00    	jne    f01023cf <mem_init+0xfdd>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101aaf:	6a 02                	push   $0x2
f0101ab1:	68 00 10 00 00       	push   $0x1000
f0101ab6:	56                   	push   %esi
f0101ab7:	57                   	push   %edi
f0101ab8:	e8 71 f8 ff ff       	call   f010132e <page_insert>
f0101abd:	83 c4 10             	add    $0x10,%esp
f0101ac0:	85 c0                	test   %eax,%eax
f0101ac2:	0f 85 20 09 00 00    	jne    f01023e8 <mem_init+0xff6>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ac8:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101acd:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f0101ad2:	e8 4f f0 ff ff       	call   f0100b26 <check_va2pa>
f0101ad7:	89 f2                	mov    %esi,%edx
f0101ad9:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
f0101adf:	c1 fa 03             	sar    $0x3,%edx
f0101ae2:	c1 e2 0c             	shl    $0xc,%edx
f0101ae5:	39 d0                	cmp    %edx,%eax
f0101ae7:	0f 85 14 09 00 00    	jne    f0102401 <mem_init+0x100f>
	assert(pp2->pp_ref == 1);
f0101aed:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101af2:	0f 85 22 09 00 00    	jne    f010241a <mem_init+0x1028>

	// should be no free memory
	assert(!page_alloc(0));
f0101af8:	83 ec 0c             	sub    $0xc,%esp
f0101afb:	6a 00                	push   $0x0
f0101afd:	e8 e2 f4 ff ff       	call   f0100fe4 <page_alloc>
f0101b02:	83 c4 10             	add    $0x10,%esp
f0101b05:	85 c0                	test   %eax,%eax
f0101b07:	0f 85 26 09 00 00    	jne    f0102433 <mem_init+0x1041>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b0d:	6a 02                	push   $0x2
f0101b0f:	68 00 10 00 00       	push   $0x1000
f0101b14:	56                   	push   %esi
f0101b15:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101b1b:	e8 0e f8 ff ff       	call   f010132e <page_insert>
f0101b20:	83 c4 10             	add    $0x10,%esp
f0101b23:	85 c0                	test   %eax,%eax
f0101b25:	0f 85 21 09 00 00    	jne    f010244c <mem_init+0x105a>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b2b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b30:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f0101b35:	e8 ec ef ff ff       	call   f0100b26 <check_va2pa>
f0101b3a:	89 f2                	mov    %esi,%edx
f0101b3c:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
f0101b42:	c1 fa 03             	sar    $0x3,%edx
f0101b45:	c1 e2 0c             	shl    $0xc,%edx
f0101b48:	39 d0                	cmp    %edx,%eax
f0101b4a:	0f 85 15 09 00 00    	jne    f0102465 <mem_init+0x1073>
	assert(pp2->pp_ref == 1);
f0101b50:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101b55:	0f 85 23 09 00 00    	jne    f010247e <mem_init+0x108c>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101b5b:	83 ec 0c             	sub    $0xc,%esp
f0101b5e:	6a 00                	push   $0x0
f0101b60:	e8 7f f4 ff ff       	call   f0100fe4 <page_alloc>
f0101b65:	83 c4 10             	add    $0x10,%esp
f0101b68:	85 c0                	test   %eax,%eax
f0101b6a:	0f 85 27 09 00 00    	jne    f0102497 <mem_init+0x10a5>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101b70:	8b 15 98 92 2c f0    	mov    0xf02c9298,%edx
f0101b76:	8b 02                	mov    (%edx),%eax
f0101b78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101b7d:	89 c1                	mov    %eax,%ecx
f0101b7f:	c1 e9 0c             	shr    $0xc,%ecx
f0101b82:	3b 0d 94 92 2c f0    	cmp    0xf02c9294,%ecx
f0101b88:	0f 83 22 09 00 00    	jae    f01024b0 <mem_init+0x10be>
	return (void *)(pa + KERNBASE);
f0101b8e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101b93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101b96:	83 ec 04             	sub    $0x4,%esp
f0101b99:	6a 00                	push   $0x0
f0101b9b:	68 00 10 00 00       	push   $0x1000
f0101ba0:	52                   	push   %edx
f0101ba1:	e8 1a f5 ff ff       	call   f01010c0 <pgdir_walk>
f0101ba6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101ba9:	8d 51 04             	lea    0x4(%ecx),%edx
f0101bac:	83 c4 10             	add    $0x10,%esp
f0101baf:	39 d0                	cmp    %edx,%eax
f0101bb1:	0f 85 0e 09 00 00    	jne    f01024c5 <mem_init+0x10d3>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101bb7:	6a 06                	push   $0x6
f0101bb9:	68 00 10 00 00       	push   $0x1000
f0101bbe:	56                   	push   %esi
f0101bbf:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101bc5:	e8 64 f7 ff ff       	call   f010132e <page_insert>
f0101bca:	83 c4 10             	add    $0x10,%esp
f0101bcd:	85 c0                	test   %eax,%eax
f0101bcf:	0f 85 09 09 00 00    	jne    f01024de <mem_init+0x10ec>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101bd5:	8b 3d 98 92 2c f0    	mov    0xf02c9298,%edi
f0101bdb:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101be0:	89 f8                	mov    %edi,%eax
f0101be2:	e8 3f ef ff ff       	call   f0100b26 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101be7:	89 f2                	mov    %esi,%edx
f0101be9:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
f0101bef:	c1 fa 03             	sar    $0x3,%edx
f0101bf2:	c1 e2 0c             	shl    $0xc,%edx
f0101bf5:	39 d0                	cmp    %edx,%eax
f0101bf7:	0f 85 fa 08 00 00    	jne    f01024f7 <mem_init+0x1105>
	assert(pp2->pp_ref == 1);
f0101bfd:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101c02:	0f 85 08 09 00 00    	jne    f0102510 <mem_init+0x111e>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101c08:	83 ec 04             	sub    $0x4,%esp
f0101c0b:	6a 00                	push   $0x0
f0101c0d:	68 00 10 00 00       	push   $0x1000
f0101c12:	57                   	push   %edi
f0101c13:	e8 a8 f4 ff ff       	call   f01010c0 <pgdir_walk>
f0101c18:	83 c4 10             	add    $0x10,%esp
f0101c1b:	f6 00 04             	testb  $0x4,(%eax)
f0101c1e:	0f 84 05 09 00 00    	je     f0102529 <mem_init+0x1137>
	assert(kern_pgdir[0] & PTE_U);
f0101c24:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f0101c29:	f6 00 04             	testb  $0x4,(%eax)
f0101c2c:	0f 84 10 09 00 00    	je     f0102542 <mem_init+0x1150>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c32:	6a 02                	push   $0x2
f0101c34:	68 00 10 00 00       	push   $0x1000
f0101c39:	56                   	push   %esi
f0101c3a:	50                   	push   %eax
f0101c3b:	e8 ee f6 ff ff       	call   f010132e <page_insert>
f0101c40:	83 c4 10             	add    $0x10,%esp
f0101c43:	85 c0                	test   %eax,%eax
f0101c45:	0f 85 10 09 00 00    	jne    f010255b <mem_init+0x1169>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101c4b:	83 ec 04             	sub    $0x4,%esp
f0101c4e:	6a 00                	push   $0x0
f0101c50:	68 00 10 00 00       	push   $0x1000
f0101c55:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101c5b:	e8 60 f4 ff ff       	call   f01010c0 <pgdir_walk>
f0101c60:	83 c4 10             	add    $0x10,%esp
f0101c63:	f6 00 02             	testb  $0x2,(%eax)
f0101c66:	0f 84 08 09 00 00    	je     f0102574 <mem_init+0x1182>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101c6c:	83 ec 04             	sub    $0x4,%esp
f0101c6f:	6a 00                	push   $0x0
f0101c71:	68 00 10 00 00       	push   $0x1000
f0101c76:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101c7c:	e8 3f f4 ff ff       	call   f01010c0 <pgdir_walk>
f0101c81:	83 c4 10             	add    $0x10,%esp
f0101c84:	f6 00 04             	testb  $0x4,(%eax)
f0101c87:	0f 85 00 09 00 00    	jne    f010258d <mem_init+0x119b>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101c8d:	6a 02                	push   $0x2
f0101c8f:	68 00 00 40 00       	push   $0x400000
f0101c94:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101c97:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101c9d:	e8 8c f6 ff ff       	call   f010132e <page_insert>
f0101ca2:	83 c4 10             	add    $0x10,%esp
f0101ca5:	85 c0                	test   %eax,%eax
f0101ca7:	0f 89 f9 08 00 00    	jns    f01025a6 <mem_init+0x11b4>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101cad:	6a 02                	push   $0x2
f0101caf:	68 00 10 00 00       	push   $0x1000
f0101cb4:	53                   	push   %ebx
f0101cb5:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101cbb:	e8 6e f6 ff ff       	call   f010132e <page_insert>
f0101cc0:	83 c4 10             	add    $0x10,%esp
f0101cc3:	85 c0                	test   %eax,%eax
f0101cc5:	0f 85 f4 08 00 00    	jne    f01025bf <mem_init+0x11cd>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101ccb:	83 ec 04             	sub    $0x4,%esp
f0101cce:	6a 00                	push   $0x0
f0101cd0:	68 00 10 00 00       	push   $0x1000
f0101cd5:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101cdb:	e8 e0 f3 ff ff       	call   f01010c0 <pgdir_walk>
f0101ce0:	83 c4 10             	add    $0x10,%esp
f0101ce3:	f6 00 04             	testb  $0x4,(%eax)
f0101ce6:	0f 85 ec 08 00 00    	jne    f01025d8 <mem_init+0x11e6>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101cec:	8b 3d 98 92 2c f0    	mov    0xf02c9298,%edi
f0101cf2:	ba 00 00 00 00       	mov    $0x0,%edx
f0101cf7:	89 f8                	mov    %edi,%eax
f0101cf9:	e8 28 ee ff ff       	call   f0100b26 <check_va2pa>
f0101cfe:	89 c1                	mov    %eax,%ecx
f0101d00:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101d03:	89 d8                	mov    %ebx,%eax
f0101d05:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0101d0b:	c1 f8 03             	sar    $0x3,%eax
f0101d0e:	c1 e0 0c             	shl    $0xc,%eax
f0101d11:	39 c1                	cmp    %eax,%ecx
f0101d13:	0f 85 d8 08 00 00    	jne    f01025f1 <mem_init+0x11ff>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d19:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d1e:	89 f8                	mov    %edi,%eax
f0101d20:	e8 01 ee ff ff       	call   f0100b26 <check_va2pa>
f0101d25:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101d28:	0f 85 dc 08 00 00    	jne    f010260a <mem_init+0x1218>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101d2e:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101d33:	0f 85 ea 08 00 00    	jne    f0102623 <mem_init+0x1231>
	assert(pp2->pp_ref == 0);
f0101d39:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d3e:	0f 85 f8 08 00 00    	jne    f010263c <mem_init+0x124a>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101d44:	83 ec 0c             	sub    $0xc,%esp
f0101d47:	6a 00                	push   $0x0
f0101d49:	e8 96 f2 ff ff       	call   f0100fe4 <page_alloc>
f0101d4e:	83 c4 10             	add    $0x10,%esp
f0101d51:	85 c0                	test   %eax,%eax
f0101d53:	0f 84 fc 08 00 00    	je     f0102655 <mem_init+0x1263>
f0101d59:	39 c6                	cmp    %eax,%esi
f0101d5b:	0f 85 f4 08 00 00    	jne    f0102655 <mem_init+0x1263>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101d61:	83 ec 08             	sub    $0x8,%esp
f0101d64:	6a 00                	push   $0x0
f0101d66:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101d6c:	e8 71 f5 ff ff       	call   f01012e2 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101d71:	8b 3d 98 92 2c f0    	mov    0xf02c9298,%edi
f0101d77:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d7c:	89 f8                	mov    %edi,%eax
f0101d7e:	e8 a3 ed ff ff       	call   f0100b26 <check_va2pa>
f0101d83:	83 c4 10             	add    $0x10,%esp
f0101d86:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d89:	0f 85 df 08 00 00    	jne    f010266e <mem_init+0x127c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d8f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d94:	89 f8                	mov    %edi,%eax
f0101d96:	e8 8b ed ff ff       	call   f0100b26 <check_va2pa>
f0101d9b:	89 da                	mov    %ebx,%edx
f0101d9d:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
f0101da3:	c1 fa 03             	sar    $0x3,%edx
f0101da6:	c1 e2 0c             	shl    $0xc,%edx
f0101da9:	39 d0                	cmp    %edx,%eax
f0101dab:	0f 85 d6 08 00 00    	jne    f0102687 <mem_init+0x1295>
	assert(pp1->pp_ref == 1);
f0101db1:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101db6:	0f 85 e4 08 00 00    	jne    f01026a0 <mem_init+0x12ae>
	assert(pp2->pp_ref == 0);
f0101dbc:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101dc1:	0f 85 f2 08 00 00    	jne    f01026b9 <mem_init+0x12c7>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101dc7:	6a 00                	push   $0x0
f0101dc9:	68 00 10 00 00       	push   $0x1000
f0101dce:	53                   	push   %ebx
f0101dcf:	57                   	push   %edi
f0101dd0:	e8 59 f5 ff ff       	call   f010132e <page_insert>
f0101dd5:	83 c4 10             	add    $0x10,%esp
f0101dd8:	85 c0                	test   %eax,%eax
f0101dda:	0f 85 f2 08 00 00    	jne    f01026d2 <mem_init+0x12e0>
	assert(pp1->pp_ref);
f0101de0:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101de5:	0f 84 00 09 00 00    	je     f01026eb <mem_init+0x12f9>
	assert(pp1->pp_link == NULL);
f0101deb:	83 3b 00             	cmpl   $0x0,(%ebx)
f0101dee:	0f 85 10 09 00 00    	jne    f0102704 <mem_init+0x1312>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101df4:	83 ec 08             	sub    $0x8,%esp
f0101df7:	68 00 10 00 00       	push   $0x1000
f0101dfc:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101e02:	e8 db f4 ff ff       	call   f01012e2 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e07:	8b 3d 98 92 2c f0    	mov    0xf02c9298,%edi
f0101e0d:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e12:	89 f8                	mov    %edi,%eax
f0101e14:	e8 0d ed ff ff       	call   f0100b26 <check_va2pa>
f0101e19:	83 c4 10             	add    $0x10,%esp
f0101e1c:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e1f:	0f 85 f8 08 00 00    	jne    f010271d <mem_init+0x132b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101e25:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e2a:	89 f8                	mov    %edi,%eax
f0101e2c:	e8 f5 ec ff ff       	call   f0100b26 <check_va2pa>
f0101e31:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e34:	0f 85 fc 08 00 00    	jne    f0102736 <mem_init+0x1344>
	assert(pp1->pp_ref == 0);
f0101e3a:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e3f:	0f 85 0a 09 00 00    	jne    f010274f <mem_init+0x135d>
	assert(pp2->pp_ref == 0);
f0101e45:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101e4a:	0f 85 18 09 00 00    	jne    f0102768 <mem_init+0x1376>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101e50:	83 ec 0c             	sub    $0xc,%esp
f0101e53:	6a 00                	push   $0x0
f0101e55:	e8 8a f1 ff ff       	call   f0100fe4 <page_alloc>
f0101e5a:	83 c4 10             	add    $0x10,%esp
f0101e5d:	39 c3                	cmp    %eax,%ebx
f0101e5f:	0f 85 1c 09 00 00    	jne    f0102781 <mem_init+0x138f>
f0101e65:	85 c0                	test   %eax,%eax
f0101e67:	0f 84 14 09 00 00    	je     f0102781 <mem_init+0x138f>

	// should be no free memory
	assert(!page_alloc(0));
f0101e6d:	83 ec 0c             	sub    $0xc,%esp
f0101e70:	6a 00                	push   $0x0
f0101e72:	e8 6d f1 ff ff       	call   f0100fe4 <page_alloc>
f0101e77:	83 c4 10             	add    $0x10,%esp
f0101e7a:	85 c0                	test   %eax,%eax
f0101e7c:	0f 85 18 09 00 00    	jne    f010279a <mem_init+0x13a8>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101e82:	8b 0d 98 92 2c f0    	mov    0xf02c9298,%ecx
f0101e88:	8b 11                	mov    (%ecx),%edx
f0101e8a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101e90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e93:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0101e99:	c1 f8 03             	sar    $0x3,%eax
f0101e9c:	c1 e0 0c             	shl    $0xc,%eax
f0101e9f:	39 c2                	cmp    %eax,%edx
f0101ea1:	0f 85 0c 09 00 00    	jne    f01027b3 <mem_init+0x13c1>
	kern_pgdir[0] = 0;
f0101ea7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101ead:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101eb0:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101eb5:	0f 85 11 09 00 00    	jne    f01027cc <mem_init+0x13da>
	pp0->pp_ref = 0;
f0101ebb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ebe:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101ec4:	83 ec 0c             	sub    $0xc,%esp
f0101ec7:	50                   	push   %eax
f0101ec8:	e8 8f f1 ff ff       	call   f010105c <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101ecd:	83 c4 0c             	add    $0xc,%esp
f0101ed0:	6a 01                	push   $0x1
f0101ed2:	68 00 10 40 00       	push   $0x401000
f0101ed7:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101edd:	e8 de f1 ff ff       	call   f01010c0 <pgdir_walk>
f0101ee2:	89 c7                	mov    %eax,%edi
f0101ee4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101ee7:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f0101eec:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101eef:	8b 40 04             	mov    0x4(%eax),%eax
f0101ef2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101ef7:	8b 0d 94 92 2c f0    	mov    0xf02c9294,%ecx
f0101efd:	89 c2                	mov    %eax,%edx
f0101eff:	c1 ea 0c             	shr    $0xc,%edx
f0101f02:	83 c4 10             	add    $0x10,%esp
f0101f05:	39 ca                	cmp    %ecx,%edx
f0101f07:	0f 83 d8 08 00 00    	jae    f01027e5 <mem_init+0x13f3>
	assert(ptep == ptep1 + PTX(va));
f0101f0d:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f0101f12:	39 c7                	cmp    %eax,%edi
f0101f14:	0f 85 e0 08 00 00    	jne    f01027fa <mem_init+0x1408>
	kern_pgdir[PDX(va)] = 0;
f0101f1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f0101f24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f27:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101f2d:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0101f33:	c1 f8 03             	sar    $0x3,%eax
f0101f36:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101f39:	89 c2                	mov    %eax,%edx
f0101f3b:	c1 ea 0c             	shr    $0xc,%edx
f0101f3e:	39 d1                	cmp    %edx,%ecx
f0101f40:	0f 86 cd 08 00 00    	jbe    f0102813 <mem_init+0x1421>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101f46:	83 ec 04             	sub    $0x4,%esp
f0101f49:	68 00 10 00 00       	push   $0x1000
f0101f4e:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101f53:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101f58:	50                   	push   %eax
f0101f59:	e8 26 39 00 00       	call   f0105884 <memset>
	page_free(pp0);
f0101f5e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101f61:	89 3c 24             	mov    %edi,(%esp)
f0101f64:	e8 f3 f0 ff ff       	call   f010105c <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101f69:	83 c4 0c             	add    $0xc,%esp
f0101f6c:	6a 01                	push   $0x1
f0101f6e:	6a 00                	push   $0x0
f0101f70:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0101f76:	e8 45 f1 ff ff       	call   f01010c0 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101f7b:	89 fa                	mov    %edi,%edx
f0101f7d:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
f0101f83:	c1 fa 03             	sar    $0x3,%edx
f0101f86:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101f89:	89 d0                	mov    %edx,%eax
f0101f8b:	c1 e8 0c             	shr    $0xc,%eax
f0101f8e:	83 c4 10             	add    $0x10,%esp
f0101f91:	3b 05 94 92 2c f0    	cmp    0xf02c9294,%eax
f0101f97:	0f 83 88 08 00 00    	jae    f0102825 <mem_init+0x1433>
	return (void *)(pa + KERNBASE);
f0101f9d:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0101fa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101fa6:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101fac:	f6 00 01             	testb  $0x1,(%eax)
f0101faf:	0f 85 82 08 00 00    	jne    f0102837 <mem_init+0x1445>
f0101fb5:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0101fb8:	39 d0                	cmp    %edx,%eax
f0101fba:	75 f0                	jne    f0101fac <mem_init+0xbba>
	kern_pgdir[0] = 0;
f0101fbc:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f0101fc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101fc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fca:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101fd0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101fd3:	89 0d 40 02 2b f0    	mov    %ecx,0xf02b0240

	// free the pages we took
	page_free(pp0);
f0101fd9:	83 ec 0c             	sub    $0xc,%esp
f0101fdc:	50                   	push   %eax
f0101fdd:	e8 7a f0 ff ff       	call   f010105c <page_free>
	page_free(pp1);
f0101fe2:	89 1c 24             	mov    %ebx,(%esp)
f0101fe5:	e8 72 f0 ff ff       	call   f010105c <page_free>
	page_free(pp2);
f0101fea:	89 34 24             	mov    %esi,(%esp)
f0101fed:	e8 6a f0 ff ff       	call   f010105c <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0101ff2:	83 c4 08             	add    $0x8,%esp
f0101ff5:	68 01 10 00 00       	push   $0x1001
f0101ffa:	6a 00                	push   $0x0
f0101ffc:	e8 8e f3 ff ff       	call   f010138f <mmio_map_region>
f0102001:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102003:	83 c4 08             	add    $0x8,%esp
f0102006:	68 00 10 00 00       	push   $0x1000
f010200b:	6a 00                	push   $0x0
f010200d:	e8 7d f3 ff ff       	call   f010138f <mmio_map_region>
f0102012:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102014:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f010201a:	83 c4 10             	add    $0x10,%esp
f010201d:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102023:	0f 86 27 08 00 00    	jbe    f0102850 <mem_init+0x145e>
f0102029:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f010202e:	0f 87 1c 08 00 00    	ja     f0102850 <mem_init+0x145e>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102034:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f010203a:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102040:	0f 87 23 08 00 00    	ja     f0102869 <mem_init+0x1477>
f0102046:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010204c:	0f 86 17 08 00 00    	jbe    f0102869 <mem_init+0x1477>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102052:	89 da                	mov    %ebx,%edx
f0102054:	09 f2                	or     %esi,%edx
f0102056:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010205c:	0f 85 20 08 00 00    	jne    f0102882 <mem_init+0x1490>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0102062:	39 c6                	cmp    %eax,%esi
f0102064:	0f 82 31 08 00 00    	jb     f010289b <mem_init+0x14a9>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f010206a:	8b 3d 98 92 2c f0    	mov    0xf02c9298,%edi
f0102070:	89 da                	mov    %ebx,%edx
f0102072:	89 f8                	mov    %edi,%eax
f0102074:	e8 ad ea ff ff       	call   f0100b26 <check_va2pa>
f0102079:	85 c0                	test   %eax,%eax
f010207b:	0f 85 33 08 00 00    	jne    f01028b4 <mem_init+0x14c2>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102081:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102087:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010208a:	89 c2                	mov    %eax,%edx
f010208c:	89 f8                	mov    %edi,%eax
f010208e:	e8 93 ea ff ff       	call   f0100b26 <check_va2pa>
f0102093:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102098:	0f 85 2f 08 00 00    	jne    f01028cd <mem_init+0x14db>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f010209e:	89 f2                	mov    %esi,%edx
f01020a0:	89 f8                	mov    %edi,%eax
f01020a2:	e8 7f ea ff ff       	call   f0100b26 <check_va2pa>
f01020a7:	85 c0                	test   %eax,%eax
f01020a9:	0f 85 37 08 00 00    	jne    f01028e6 <mem_init+0x14f4>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01020af:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f01020b5:	89 f8                	mov    %edi,%eax
f01020b7:	e8 6a ea ff ff       	call   f0100b26 <check_va2pa>
f01020bc:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020bf:	0f 85 3a 08 00 00    	jne    f01028ff <mem_init+0x150d>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01020c5:	83 ec 04             	sub    $0x4,%esp
f01020c8:	6a 00                	push   $0x0
f01020ca:	53                   	push   %ebx
f01020cb:	57                   	push   %edi
f01020cc:	e8 ef ef ff ff       	call   f01010c0 <pgdir_walk>
f01020d1:	83 c4 10             	add    $0x10,%esp
f01020d4:	f6 00 1a             	testb  $0x1a,(%eax)
f01020d7:	0f 84 3b 08 00 00    	je     f0102918 <mem_init+0x1526>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01020dd:	83 ec 04             	sub    $0x4,%esp
f01020e0:	6a 00                	push   $0x0
f01020e2:	53                   	push   %ebx
f01020e3:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f01020e9:	e8 d2 ef ff ff       	call   f01010c0 <pgdir_walk>
f01020ee:	83 c4 10             	add    $0x10,%esp
f01020f1:	f6 00 04             	testb  $0x4,(%eax)
f01020f4:	0f 85 37 08 00 00    	jne    f0102931 <mem_init+0x153f>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f01020fa:	83 ec 04             	sub    $0x4,%esp
f01020fd:	6a 00                	push   $0x0
f01020ff:	53                   	push   %ebx
f0102100:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0102106:	e8 b5 ef ff ff       	call   f01010c0 <pgdir_walk>
f010210b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102111:	83 c4 0c             	add    $0xc,%esp
f0102114:	6a 00                	push   $0x0
f0102116:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102119:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f010211f:	e8 9c ef ff ff       	call   f01010c0 <pgdir_walk>
f0102124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f010212a:	83 c4 0c             	add    $0xc,%esp
f010212d:	6a 00                	push   $0x0
f010212f:	56                   	push   %esi
f0102130:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0102136:	e8 85 ef ff ff       	call   f01010c0 <pgdir_walk>
f010213b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102141:	c7 04 24 c2 7d 10 f0 	movl   $0xf0107dc2,(%esp)
f0102148:	e8 ff 17 00 00       	call   f010394c <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010214d:	a1 9c 92 2c f0       	mov    0xf02c929c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102152:	83 c4 10             	add    $0x10,%esp
f0102155:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010215a:	0f 86 ea 07 00 00    	jbe    f010294a <mem_init+0x1558>
f0102160:	83 ec 08             	sub    $0x8,%esp
f0102163:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102165:	05 00 00 00 10       	add    $0x10000000,%eax
f010216a:	50                   	push   %eax
f010216b:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102170:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102175:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f010217a:	e8 43 f0 ff ff       	call   f01011c2 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f010217f:	a1 48 02 2b f0       	mov    0xf02b0248,%eax
	if ((uint32_t)kva < KERNBASE)
f0102184:	83 c4 10             	add    $0x10,%esp
f0102187:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010218c:	0f 86 cd 07 00 00    	jbe    f010295f <mem_init+0x156d>
f0102192:	83 ec 08             	sub    $0x8,%esp
f0102195:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102197:	05 00 00 00 10       	add    $0x10000000,%eax
f010219c:	50                   	push   %eax
f010219d:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01021a2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01021a7:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f01021ac:	e8 11 f0 ff ff       	call   f01011c2 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, ~(uint32_t)0 - KERNBASE + 1, 0, PTE_W);
f01021b1:	83 c4 08             	add    $0x8,%esp
f01021b4:	6a 02                	push   $0x2
f01021b6:	6a 00                	push   $0x0
f01021b8:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f01021bd:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01021c2:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f01021c7:	e8 f6 ef ff ff       	call   f01011c2 <boot_map_region>
f01021cc:	c7 45 cc 00 b0 2c f0 	movl   $0xf02cb000,-0x34(%ebp)
f01021d3:	bf 00 b0 30 f0       	mov    $0xf030b000,%edi
f01021d8:	83 c4 10             	add    $0x10,%esp
f01021db:	bb 00 b0 2c f0       	mov    $0xf02cb000,%ebx
f01021e0:	be 00 80 ff ef       	mov    $0xefff8000,%esi
	if ((uint32_t)kva < KERNBASE)
f01021e5:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01021eb:	0f 86 83 07 00 00    	jbe    f0102974 <mem_init+0x1582>
	    boot_map_region(kern_pgdir, kstacktop_i - KSTKSIZE, KSTKSIZE, PADDR(percpu_kstacks[i]), PTE_W);
f01021f1:	83 ec 08             	sub    $0x8,%esp
f01021f4:	6a 02                	push   $0x2
f01021f6:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01021fc:	50                   	push   %eax
f01021fd:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102202:	89 f2                	mov    %esi,%edx
f0102204:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
f0102209:	e8 b4 ef ff ff       	call   f01011c2 <boot_map_region>
f010220e:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0102214:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++) {
f010221a:	83 c4 10             	add    $0x10,%esp
f010221d:	39 fb                	cmp    %edi,%ebx
f010221f:	75 c4                	jne    f01021e5 <mem_init+0xdf3>
	pgdir = kern_pgdir;
f0102221:	8b 3d 98 92 2c f0    	mov    0xf02c9298,%edi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102227:	a1 94 92 2c f0       	mov    0xf02c9294,%eax
f010222c:	89 45 c8             	mov    %eax,-0x38(%ebp)
f010222f:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102236:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010223b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010223e:	a1 9c 92 2c f0       	mov    0xf02c929c,%eax
f0102243:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102246:	89 45 d0             	mov    %eax,-0x30(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102249:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
	for (i = 0; i < n; i += PGSIZE)
f010224f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102254:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102257:	0f 86 5c 07 00 00    	jbe    f01029b9 <mem_init+0x15c7>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010225d:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102263:	89 f8                	mov    %edi,%eax
f0102265:	e8 bc e8 ff ff       	call   f0100b26 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f010226a:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102271:	0f 86 12 07 00 00    	jbe    f0102989 <mem_init+0x1597>
f0102277:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f010227a:	39 d0                	cmp    %edx,%eax
f010227c:	0f 85 1e 07 00 00    	jne    f01029a0 <mem_init+0x15ae>
	for (i = 0; i < n; i += PGSIZE)
f0102282:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102288:	eb ca                	jmp    f0102254 <mem_init+0xe62>
    assert(nfree == 0);
f010228a:	68 d9 7c 10 f0       	push   $0xf0107cd9
f010228f:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102294:	68 55 03 00 00       	push   $0x355
f0102299:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010229e:	e8 9d dd ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01022a3:	68 e7 7b 10 f0       	push   $0xf0107be7
f01022a8:	68 ff 7a 10 f0       	push   $0xf0107aff
f01022ad:	68 bb 03 00 00       	push   $0x3bb
f01022b2:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01022b7:	e8 84 dd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01022bc:	68 fd 7b 10 f0       	push   $0xf0107bfd
f01022c1:	68 ff 7a 10 f0       	push   $0xf0107aff
f01022c6:	68 bc 03 00 00       	push   $0x3bc
f01022cb:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01022d0:	e8 6b dd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01022d5:	68 13 7c 10 f0       	push   $0xf0107c13
f01022da:	68 ff 7a 10 f0       	push   $0xf0107aff
f01022df:	68 bd 03 00 00       	push   $0x3bd
f01022e4:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01022e9:	e8 52 dd ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01022ee:	68 29 7c 10 f0       	push   $0xf0107c29
f01022f3:	68 ff 7a 10 f0       	push   $0xf0107aff
f01022f8:	68 c0 03 00 00       	push   $0x3c0
f01022fd:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102302:	e8 39 dd ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102307:	68 fc 72 10 f0       	push   $0xf01072fc
f010230c:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102311:	68 c1 03 00 00       	push   $0x3c1
f0102316:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010231b:	e8 20 dd ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102320:	68 92 7c 10 f0       	push   $0xf0107c92
f0102325:	68 ff 7a 10 f0       	push   $0xf0107aff
f010232a:	68 c8 03 00 00       	push   $0x3c8
f010232f:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102334:	e8 07 dd ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102339:	68 3c 73 10 f0       	push   $0xf010733c
f010233e:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102343:	68 cb 03 00 00       	push   $0x3cb
f0102348:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010234d:	e8 ee dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102352:	68 74 73 10 f0       	push   $0xf0107374
f0102357:	68 ff 7a 10 f0       	push   $0xf0107aff
f010235c:	68 ce 03 00 00       	push   $0x3ce
f0102361:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102366:	e8 d5 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010236b:	68 a4 73 10 f0       	push   $0xf01073a4
f0102370:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102375:	68 d2 03 00 00       	push   $0x3d2
f010237a:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010237f:	e8 bc dc ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102384:	68 d4 73 10 f0       	push   $0xf01073d4
f0102389:	68 ff 7a 10 f0       	push   $0xf0107aff
f010238e:	68 d3 03 00 00       	push   $0x3d3
f0102393:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102398:	e8 a3 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010239d:	68 fc 73 10 f0       	push   $0xf01073fc
f01023a2:	68 ff 7a 10 f0       	push   $0xf0107aff
f01023a7:	68 d4 03 00 00       	push   $0x3d4
f01023ac:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01023b1:	e8 8a dc ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01023b6:	68 e4 7c 10 f0       	push   $0xf0107ce4
f01023bb:	68 ff 7a 10 f0       	push   $0xf0107aff
f01023c0:	68 d5 03 00 00       	push   $0x3d5
f01023c5:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01023ca:	e8 71 dc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01023cf:	68 f5 7c 10 f0       	push   $0xf0107cf5
f01023d4:	68 ff 7a 10 f0       	push   $0xf0107aff
f01023d9:	68 d6 03 00 00       	push   $0x3d6
f01023de:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01023e3:	e8 58 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01023e8:	68 2c 74 10 f0       	push   $0xf010742c
f01023ed:	68 ff 7a 10 f0       	push   $0xf0107aff
f01023f2:	68 d9 03 00 00       	push   $0x3d9
f01023f7:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01023fc:	e8 3f dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102401:	68 68 74 10 f0       	push   $0xf0107468
f0102406:	68 ff 7a 10 f0       	push   $0xf0107aff
f010240b:	68 da 03 00 00       	push   $0x3da
f0102410:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102415:	e8 26 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010241a:	68 06 7d 10 f0       	push   $0xf0107d06
f010241f:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102424:	68 db 03 00 00       	push   $0x3db
f0102429:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010242e:	e8 0d dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102433:	68 92 7c 10 f0       	push   $0xf0107c92
f0102438:	68 ff 7a 10 f0       	push   $0xf0107aff
f010243d:	68 de 03 00 00       	push   $0x3de
f0102442:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102447:	e8 f4 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010244c:	68 2c 74 10 f0       	push   $0xf010742c
f0102451:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102456:	68 e1 03 00 00       	push   $0x3e1
f010245b:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102460:	e8 db db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102465:	68 68 74 10 f0       	push   $0xf0107468
f010246a:	68 ff 7a 10 f0       	push   $0xf0107aff
f010246f:	68 e2 03 00 00       	push   $0x3e2
f0102474:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102479:	e8 c2 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010247e:	68 06 7d 10 f0       	push   $0xf0107d06
f0102483:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102488:	68 e3 03 00 00       	push   $0x3e3
f010248d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102492:	e8 a9 db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102497:	68 92 7c 10 f0       	push   $0xf0107c92
f010249c:	68 ff 7a 10 f0       	push   $0xf0107aff
f01024a1:	68 e7 03 00 00       	push   $0x3e7
f01024a6:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01024ab:	e8 90 db ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01024b0:	50                   	push   %eax
f01024b1:	68 c4 6b 10 f0       	push   $0xf0106bc4
f01024b6:	68 ea 03 00 00       	push   $0x3ea
f01024bb:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01024c0:	e8 7b db ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01024c5:	68 98 74 10 f0       	push   $0xf0107498
f01024ca:	68 ff 7a 10 f0       	push   $0xf0107aff
f01024cf:	68 eb 03 00 00       	push   $0x3eb
f01024d4:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01024d9:	e8 62 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01024de:	68 d8 74 10 f0       	push   $0xf01074d8
f01024e3:	68 ff 7a 10 f0       	push   $0xf0107aff
f01024e8:	68 ee 03 00 00       	push   $0x3ee
f01024ed:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01024f2:	e8 49 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024f7:	68 68 74 10 f0       	push   $0xf0107468
f01024fc:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102501:	68 ef 03 00 00       	push   $0x3ef
f0102506:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010250b:	e8 30 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102510:	68 06 7d 10 f0       	push   $0xf0107d06
f0102515:	68 ff 7a 10 f0       	push   $0xf0107aff
f010251a:	68 f0 03 00 00       	push   $0x3f0
f010251f:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102524:	e8 17 db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102529:	68 18 75 10 f0       	push   $0xf0107518
f010252e:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102533:	68 f1 03 00 00       	push   $0x3f1
f0102538:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010253d:	e8 fe da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102542:	68 17 7d 10 f0       	push   $0xf0107d17
f0102547:	68 ff 7a 10 f0       	push   $0xf0107aff
f010254c:	68 f2 03 00 00       	push   $0x3f2
f0102551:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102556:	e8 e5 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010255b:	68 2c 74 10 f0       	push   $0xf010742c
f0102560:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102565:	68 f5 03 00 00       	push   $0x3f5
f010256a:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010256f:	e8 cc da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102574:	68 4c 75 10 f0       	push   $0xf010754c
f0102579:	68 ff 7a 10 f0       	push   $0xf0107aff
f010257e:	68 f6 03 00 00       	push   $0x3f6
f0102583:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102588:	e8 b3 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010258d:	68 80 75 10 f0       	push   $0xf0107580
f0102592:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102597:	68 f7 03 00 00       	push   $0x3f7
f010259c:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01025a1:	e8 9a da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01025a6:	68 b8 75 10 f0       	push   $0xf01075b8
f01025ab:	68 ff 7a 10 f0       	push   $0xf0107aff
f01025b0:	68 fa 03 00 00       	push   $0x3fa
f01025b5:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01025ba:	e8 81 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01025bf:	68 f0 75 10 f0       	push   $0xf01075f0
f01025c4:	68 ff 7a 10 f0       	push   $0xf0107aff
f01025c9:	68 fd 03 00 00       	push   $0x3fd
f01025ce:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01025d3:	e8 68 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025d8:	68 80 75 10 f0       	push   $0xf0107580
f01025dd:	68 ff 7a 10 f0       	push   $0xf0107aff
f01025e2:	68 fe 03 00 00       	push   $0x3fe
f01025e7:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01025ec:	e8 4f da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01025f1:	68 2c 76 10 f0       	push   $0xf010762c
f01025f6:	68 ff 7a 10 f0       	push   $0xf0107aff
f01025fb:	68 01 04 00 00       	push   $0x401
f0102600:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102605:	e8 36 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010260a:	68 58 76 10 f0       	push   $0xf0107658
f010260f:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102614:	68 02 04 00 00       	push   $0x402
f0102619:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010261e:	e8 1d da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102623:	68 2d 7d 10 f0       	push   $0xf0107d2d
f0102628:	68 ff 7a 10 f0       	push   $0xf0107aff
f010262d:	68 04 04 00 00       	push   $0x404
f0102632:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102637:	e8 04 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010263c:	68 3e 7d 10 f0       	push   $0xf0107d3e
f0102641:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102646:	68 05 04 00 00       	push   $0x405
f010264b:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102650:	e8 eb d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102655:	68 88 76 10 f0       	push   $0xf0107688
f010265a:	68 ff 7a 10 f0       	push   $0xf0107aff
f010265f:	68 08 04 00 00       	push   $0x408
f0102664:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102669:	e8 d2 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010266e:	68 ac 76 10 f0       	push   $0xf01076ac
f0102673:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102678:	68 0c 04 00 00       	push   $0x40c
f010267d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102682:	e8 b9 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102687:	68 58 76 10 f0       	push   $0xf0107658
f010268c:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102691:	68 0d 04 00 00       	push   $0x40d
f0102696:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010269b:	e8 a0 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01026a0:	68 e4 7c 10 f0       	push   $0xf0107ce4
f01026a5:	68 ff 7a 10 f0       	push   $0xf0107aff
f01026aa:	68 0e 04 00 00       	push   $0x40e
f01026af:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01026b4:	e8 87 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01026b9:	68 3e 7d 10 f0       	push   $0xf0107d3e
f01026be:	68 ff 7a 10 f0       	push   $0xf0107aff
f01026c3:	68 0f 04 00 00       	push   $0x40f
f01026c8:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01026cd:	e8 6e d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01026d2:	68 d0 76 10 f0       	push   $0xf01076d0
f01026d7:	68 ff 7a 10 f0       	push   $0xf0107aff
f01026dc:	68 12 04 00 00       	push   $0x412
f01026e1:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01026e6:	e8 55 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f01026eb:	68 4f 7d 10 f0       	push   $0xf0107d4f
f01026f0:	68 ff 7a 10 f0       	push   $0xf0107aff
f01026f5:	68 13 04 00 00       	push   $0x413
f01026fa:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01026ff:	e8 3c d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102704:	68 5b 7d 10 f0       	push   $0xf0107d5b
f0102709:	68 ff 7a 10 f0       	push   $0xf0107aff
f010270e:	68 14 04 00 00       	push   $0x414
f0102713:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102718:	e8 23 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010271d:	68 ac 76 10 f0       	push   $0xf01076ac
f0102722:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102727:	68 18 04 00 00       	push   $0x418
f010272c:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102731:	e8 0a d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102736:	68 08 77 10 f0       	push   $0xf0107708
f010273b:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102740:	68 19 04 00 00       	push   $0x419
f0102745:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010274a:	e8 f1 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f010274f:	68 70 7d 10 f0       	push   $0xf0107d70
f0102754:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102759:	68 1a 04 00 00       	push   $0x41a
f010275e:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102763:	e8 d8 d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102768:	68 3e 7d 10 f0       	push   $0xf0107d3e
f010276d:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102772:	68 1b 04 00 00       	push   $0x41b
f0102777:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010277c:	e8 bf d8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102781:	68 30 77 10 f0       	push   $0xf0107730
f0102786:	68 ff 7a 10 f0       	push   $0xf0107aff
f010278b:	68 1e 04 00 00       	push   $0x41e
f0102790:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102795:	e8 a6 d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010279a:	68 92 7c 10 f0       	push   $0xf0107c92
f010279f:	68 ff 7a 10 f0       	push   $0xf0107aff
f01027a4:	68 21 04 00 00       	push   $0x421
f01027a9:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01027ae:	e8 8d d8 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01027b3:	68 d4 73 10 f0       	push   $0xf01073d4
f01027b8:	68 ff 7a 10 f0       	push   $0xf0107aff
f01027bd:	68 24 04 00 00       	push   $0x424
f01027c2:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01027c7:	e8 74 d8 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01027cc:	68 f5 7c 10 f0       	push   $0xf0107cf5
f01027d1:	68 ff 7a 10 f0       	push   $0xf0107aff
f01027d6:	68 26 04 00 00       	push   $0x426
f01027db:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01027e0:	e8 5b d8 ff ff       	call   f0100040 <_panic>
f01027e5:	50                   	push   %eax
f01027e6:	68 c4 6b 10 f0       	push   $0xf0106bc4
f01027eb:	68 2d 04 00 00       	push   $0x42d
f01027f0:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01027f5:	e8 46 d8 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f01027fa:	68 81 7d 10 f0       	push   $0xf0107d81
f01027ff:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102804:	68 2e 04 00 00       	push   $0x42e
f0102809:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010280e:	e8 2d d8 ff ff       	call   f0100040 <_panic>
f0102813:	50                   	push   %eax
f0102814:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0102819:	6a 58                	push   $0x58
f010281b:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0102820:	e8 1b d8 ff ff       	call   f0100040 <_panic>
f0102825:	52                   	push   %edx
f0102826:	68 c4 6b 10 f0       	push   $0xf0106bc4
f010282b:	6a 58                	push   $0x58
f010282d:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0102832:	e8 09 d8 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102837:	68 99 7d 10 f0       	push   $0xf0107d99
f010283c:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102841:	68 38 04 00 00       	push   $0x438
f0102846:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010284b:	e8 f0 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102850:	68 54 77 10 f0       	push   $0xf0107754
f0102855:	68 ff 7a 10 f0       	push   $0xf0107aff
f010285a:	68 48 04 00 00       	push   $0x448
f010285f:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102864:	e8 d7 d7 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102869:	68 7c 77 10 f0       	push   $0xf010777c
f010286e:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102873:	68 49 04 00 00       	push   $0x449
f0102878:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010287d:	e8 be d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102882:	68 a4 77 10 f0       	push   $0xf01077a4
f0102887:	68 ff 7a 10 f0       	push   $0xf0107aff
f010288c:	68 4b 04 00 00       	push   $0x44b
f0102891:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102896:	e8 a5 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f010289b:	68 b0 7d 10 f0       	push   $0xf0107db0
f01028a0:	68 ff 7a 10 f0       	push   $0xf0107aff
f01028a5:	68 4d 04 00 00       	push   $0x44d
f01028aa:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01028af:	e8 8c d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01028b4:	68 cc 77 10 f0       	push   $0xf01077cc
f01028b9:	68 ff 7a 10 f0       	push   $0xf0107aff
f01028be:	68 4f 04 00 00       	push   $0x44f
f01028c3:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01028c8:	e8 73 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01028cd:	68 f0 77 10 f0       	push   $0xf01077f0
f01028d2:	68 ff 7a 10 f0       	push   $0xf0107aff
f01028d7:	68 50 04 00 00       	push   $0x450
f01028dc:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01028e1:	e8 5a d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01028e6:	68 20 78 10 f0       	push   $0xf0107820
f01028eb:	68 ff 7a 10 f0       	push   $0xf0107aff
f01028f0:	68 51 04 00 00       	push   $0x451
f01028f5:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01028fa:	e8 41 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01028ff:	68 44 78 10 f0       	push   $0xf0107844
f0102904:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102909:	68 52 04 00 00       	push   $0x452
f010290e:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102913:	e8 28 d7 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102918:	68 70 78 10 f0       	push   $0xf0107870
f010291d:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102922:	68 54 04 00 00       	push   $0x454
f0102927:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010292c:	e8 0f d7 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102931:	68 b4 78 10 f0       	push   $0xf01078b4
f0102936:	68 ff 7a 10 f0       	push   $0xf0107aff
f010293b:	68 55 04 00 00       	push   $0x455
f0102940:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102945:	e8 f6 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010294a:	50                   	push   %eax
f010294b:	68 e8 6b 10 f0       	push   $0xf0106be8
f0102950:	68 bf 00 00 00       	push   $0xbf
f0102955:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010295a:	e8 e1 d6 ff ff       	call   f0100040 <_panic>
f010295f:	50                   	push   %eax
f0102960:	68 e8 6b 10 f0       	push   $0xf0106be8
f0102965:	68 c8 00 00 00       	push   $0xc8
f010296a:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010296f:	e8 cc d6 ff ff       	call   f0100040 <_panic>
f0102974:	53                   	push   %ebx
f0102975:	68 e8 6b 10 f0       	push   $0xf0106be8
f010297a:	68 16 01 00 00       	push   $0x116
f010297f:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102984:	e8 b7 d6 ff ff       	call   f0100040 <_panic>
f0102989:	ff 75 c4             	pushl  -0x3c(%ebp)
f010298c:	68 e8 6b 10 f0       	push   $0xf0106be8
f0102991:	68 6d 03 00 00       	push   $0x36d
f0102996:	68 d9 7a 10 f0       	push   $0xf0107ad9
f010299b:	e8 a0 d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01029a0:	68 e8 78 10 f0       	push   $0xf01078e8
f01029a5:	68 ff 7a 10 f0       	push   $0xf0107aff
f01029aa:	68 6d 03 00 00       	push   $0x36d
f01029af:	68 d9 7a 10 f0       	push   $0xf0107ad9
f01029b4:	e8 87 d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01029b9:	a1 48 02 2b f0       	mov    0xf02b0248,%eax
f01029be:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((uint32_t)kva < KERNBASE)
f01029c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01029c4:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f01029c9:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f01029cf:	89 da                	mov    %ebx,%edx
f01029d1:	89 f8                	mov    %edi,%eax
f01029d3:	e8 4e e1 ff ff       	call   f0100b26 <check_va2pa>
f01029d8:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f01029df:	76 3d                	jbe    f0102a1e <mem_init+0x162c>
f01029e1:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f01029e4:	39 d0                	cmp    %edx,%eax
f01029e6:	75 4d                	jne    f0102a35 <mem_init+0x1643>
f01029e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f01029ee:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f01029f4:	75 d9                	jne    f01029cf <mem_init+0x15dd>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01029f6:	8b 75 c8             	mov    -0x38(%ebp),%esi
f01029f9:	c1 e6 0c             	shl    $0xc,%esi
f01029fc:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102a01:	39 f3                	cmp    %esi,%ebx
f0102a03:	73 62                	jae    f0102a67 <mem_init+0x1675>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a05:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102a0b:	89 f8                	mov    %edi,%eax
f0102a0d:	e8 14 e1 ff ff       	call   f0100b26 <check_va2pa>
f0102a12:	39 c3                	cmp    %eax,%ebx
f0102a14:	75 38                	jne    f0102a4e <mem_init+0x165c>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a16:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a1c:	eb e3                	jmp    f0102a01 <mem_init+0x160f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102a1e:	ff 75 d0             	pushl  -0x30(%ebp)
f0102a21:	68 e8 6b 10 f0       	push   $0xf0106be8
f0102a26:	68 72 03 00 00       	push   $0x372
f0102a2b:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102a30:	e8 0b d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102a35:	68 1c 79 10 f0       	push   $0xf010791c
f0102a3a:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102a3f:	68 72 03 00 00       	push   $0x372
f0102a44:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102a49:	e8 f2 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a4e:	68 50 79 10 f0       	push   $0xf0107950
f0102a53:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102a58:	68 76 03 00 00       	push   $0x376
f0102a5d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102a62:	e8 d9 d5 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a67:	c7 45 d4 00 b0 2c f0 	movl   $0xf02cb000,-0x2c(%ebp)
f0102a6e:	be 00 80 ff ef       	mov    $0xefff8000,%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102a73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102a79:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102a7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102a82:	89 f3                	mov    %esi,%ebx
f0102a84:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102a87:	05 00 80 00 20       	add    $0x20008000,%eax
f0102a8c:	89 75 c8             	mov    %esi,-0x38(%ebp)
f0102a8f:	89 c6                	mov    %eax,%esi
f0102a91:	89 da                	mov    %ebx,%edx
f0102a93:	89 f8                	mov    %edi,%eax
f0102a95:	e8 8c e0 ff ff       	call   f0100b26 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102a9a:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102aa1:	0f 86 af 00 00 00    	jbe    f0102b56 <mem_init+0x1764>
f0102aa7:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102aaa:	39 d0                	cmp    %edx,%eax
f0102aac:	0f 85 bb 00 00 00    	jne    f0102b6d <mem_init+0x177b>
f0102ab2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102ab8:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
f0102abb:	75 d4                	jne    f0102a91 <mem_init+0x169f>
f0102abd:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102ac0:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102ac6:	89 da                	mov    %ebx,%edx
f0102ac8:	89 f8                	mov    %edi,%eax
f0102aca:	e8 57 e0 ff ff       	call   f0100b26 <check_va2pa>
f0102acf:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102ad2:	0f 85 ae 00 00 00    	jne    f0102b86 <mem_init+0x1794>
f0102ad8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102ade:	39 f3                	cmp    %esi,%ebx
f0102ae0:	75 e4                	jne    f0102ac6 <mem_init+0x16d4>
f0102ae2:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102ae8:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
f0102aef:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102af2:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102af9:	3d 00 b0 38 f0       	cmp    $0xf038b000,%eax
f0102afe:	0f 85 6f ff ff ff    	jne    f0102a73 <mem_init+0x1681>
	for (i = 0; i < NPDENTRIES; i++) {
f0102b04:	b8 00 00 00 00       	mov    $0x0,%eax
			if (i >= PDX(KERNBASE)) {
f0102b09:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102b0e:	0f 87 8b 00 00 00    	ja     f0102b9f <mem_init+0x17ad>
				assert(pgdir[i] == 0);
f0102b14:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102b18:	0f 85 c4 00 00 00    	jne    f0102be2 <mem_init+0x17f0>
	for (i = 0; i < NPDENTRIES; i++) {
f0102b1e:	83 c0 01             	add    $0x1,%eax
f0102b21:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102b26:	0f 87 cf 00 00 00    	ja     f0102bfb <mem_init+0x1809>
		switch (i) {
f0102b2c:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102b32:	83 fa 04             	cmp    $0x4,%edx
f0102b35:	77 d2                	ja     f0102b09 <mem_init+0x1717>
			assert(pgdir[i] & PTE_P);
f0102b37:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0102b3b:	75 e1                	jne    f0102b1e <mem_init+0x172c>
f0102b3d:	68 db 7d 10 f0       	push   $0xf0107ddb
f0102b42:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102b47:	68 8b 03 00 00       	push   $0x38b
f0102b4c:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102b51:	e8 ea d4 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b56:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102b59:	68 e8 6b 10 f0       	push   $0xf0106be8
f0102b5e:	68 7e 03 00 00       	push   $0x37e
f0102b63:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102b68:	e8 d3 d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b6d:	68 78 79 10 f0       	push   $0xf0107978
f0102b72:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102b77:	68 7e 03 00 00       	push   $0x37e
f0102b7c:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102b81:	e8 ba d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102b86:	68 c0 79 10 f0       	push   $0xf01079c0
f0102b8b:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102b90:	68 80 03 00 00       	push   $0x380
f0102b95:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102b9a:	e8 a1 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102b9f:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102ba2:	f6 c2 01             	test   $0x1,%dl
f0102ba5:	74 22                	je     f0102bc9 <mem_init+0x17d7>
				assert(pgdir[i] & PTE_W);
f0102ba7:	f6 c2 02             	test   $0x2,%dl
f0102baa:	0f 85 6e ff ff ff    	jne    f0102b1e <mem_init+0x172c>
f0102bb0:	68 ec 7d 10 f0       	push   $0xf0107dec
f0102bb5:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102bba:	68 90 03 00 00       	push   $0x390
f0102bbf:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102bc4:	e8 77 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102bc9:	68 db 7d 10 f0       	push   $0xf0107ddb
f0102bce:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102bd3:	68 8f 03 00 00       	push   $0x38f
f0102bd8:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102bdd:	e8 5e d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102be2:	68 fd 7d 10 f0       	push   $0xf0107dfd
f0102be7:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102bec:	68 92 03 00 00       	push   $0x392
f0102bf1:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102bf6:	e8 45 d4 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102bfb:	83 ec 0c             	sub    $0xc,%esp
f0102bfe:	68 e4 79 10 f0       	push   $0xf01079e4
f0102c03:	e8 44 0d 00 00       	call   f010394c <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102c08:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
	if ((uint32_t)kva < KERNBASE)
f0102c0d:	83 c4 10             	add    $0x10,%esp
f0102c10:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102c15:	0f 86 fe 01 00 00    	jbe    f0102e19 <mem_init+0x1a27>
	return (physaddr_t)kva - KERNBASE;
f0102c1b:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102c20:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102c23:	b8 00 00 00 00       	mov    $0x0,%eax
f0102c28:	e8 5d df ff ff       	call   f0100b8a <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102c2d:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102c30:	83 e0 f3             	and    $0xfffffff3,%eax
f0102c33:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102c38:	0f 22 c0             	mov    %eax,%cr0
    uintptr_t va;
    int i;

    // check that we can read and write installed pages
    pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0102c3b:	83 ec 0c             	sub    $0xc,%esp
f0102c3e:	6a 00                	push   $0x0
f0102c40:	e8 9f e3 ff ff       	call   f0100fe4 <page_alloc>
f0102c45:	89 c3                	mov    %eax,%ebx
f0102c47:	83 c4 10             	add    $0x10,%esp
f0102c4a:	85 c0                	test   %eax,%eax
f0102c4c:	0f 84 dc 01 00 00    	je     f0102e2e <mem_init+0x1a3c>
    assert((pp1 = page_alloc(0)));
f0102c52:	83 ec 0c             	sub    $0xc,%esp
f0102c55:	6a 00                	push   $0x0
f0102c57:	e8 88 e3 ff ff       	call   f0100fe4 <page_alloc>
f0102c5c:	89 c7                	mov    %eax,%edi
f0102c5e:	83 c4 10             	add    $0x10,%esp
f0102c61:	85 c0                	test   %eax,%eax
f0102c63:	0f 84 de 01 00 00    	je     f0102e47 <mem_init+0x1a55>
    assert((pp2 = page_alloc(0)));
f0102c69:	83 ec 0c             	sub    $0xc,%esp
f0102c6c:	6a 00                	push   $0x0
f0102c6e:	e8 71 e3 ff ff       	call   f0100fe4 <page_alloc>
f0102c73:	89 c6                	mov    %eax,%esi
f0102c75:	83 c4 10             	add    $0x10,%esp
f0102c78:	85 c0                	test   %eax,%eax
f0102c7a:	0f 84 e0 01 00 00    	je     f0102e60 <mem_init+0x1a6e>
    page_free(pp0);
f0102c80:	83 ec 0c             	sub    $0xc,%esp
f0102c83:	53                   	push   %ebx
f0102c84:	e8 d3 e3 ff ff       	call   f010105c <page_free>
	return (pp - pages) << PGSHIFT;
f0102c89:	89 f8                	mov    %edi,%eax
f0102c8b:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0102c91:	c1 f8 03             	sar    $0x3,%eax
f0102c94:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102c97:	89 c2                	mov    %eax,%edx
f0102c99:	c1 ea 0c             	shr    $0xc,%edx
f0102c9c:	83 c4 10             	add    $0x10,%esp
f0102c9f:	3b 15 94 92 2c f0    	cmp    0xf02c9294,%edx
f0102ca5:	0f 83 ce 01 00 00    	jae    f0102e79 <mem_init+0x1a87>
    memset(page2kva(pp1), 1, PGSIZE);
f0102cab:	83 ec 04             	sub    $0x4,%esp
f0102cae:	68 00 10 00 00       	push   $0x1000
f0102cb3:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102cb5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102cba:	50                   	push   %eax
f0102cbb:	e8 c4 2b 00 00       	call   f0105884 <memset>
	return (pp - pages) << PGSHIFT;
f0102cc0:	89 f0                	mov    %esi,%eax
f0102cc2:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0102cc8:	c1 f8 03             	sar    $0x3,%eax
f0102ccb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102cce:	89 c2                	mov    %eax,%edx
f0102cd0:	c1 ea 0c             	shr    $0xc,%edx
f0102cd3:	83 c4 10             	add    $0x10,%esp
f0102cd6:	3b 15 94 92 2c f0    	cmp    0xf02c9294,%edx
f0102cdc:	0f 83 a9 01 00 00    	jae    f0102e8b <mem_init+0x1a99>
    memset(page2kva(pp2), 2, PGSIZE);
f0102ce2:	83 ec 04             	sub    $0x4,%esp
f0102ce5:	68 00 10 00 00       	push   $0x1000
f0102cea:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102cec:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102cf1:	50                   	push   %eax
f0102cf2:	e8 8d 2b 00 00       	call   f0105884 <memset>
    page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102cf7:	6a 02                	push   $0x2
f0102cf9:	68 00 10 00 00       	push   $0x1000
f0102cfe:	57                   	push   %edi
f0102cff:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0102d05:	e8 24 e6 ff ff       	call   f010132e <page_insert>
    assert(pp1->pp_ref == 1);
f0102d0a:	83 c4 20             	add    $0x20,%esp
f0102d0d:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102d12:	0f 85 85 01 00 00    	jne    f0102e9d <mem_init+0x1aab>
    assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102d18:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102d1f:	01 01 01 
f0102d22:	0f 85 8e 01 00 00    	jne    f0102eb6 <mem_init+0x1ac4>
    page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102d28:	6a 02                	push   $0x2
f0102d2a:	68 00 10 00 00       	push   $0x1000
f0102d2f:	56                   	push   %esi
f0102d30:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0102d36:	e8 f3 e5 ff ff       	call   f010132e <page_insert>
    assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102d3b:	83 c4 10             	add    $0x10,%esp
f0102d3e:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102d45:	02 02 02 
f0102d48:	0f 85 81 01 00 00    	jne    f0102ecf <mem_init+0x1add>
    assert(pp2->pp_ref == 1);
f0102d4e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102d53:	0f 85 8f 01 00 00    	jne    f0102ee8 <mem_init+0x1af6>
    assert(pp1->pp_ref == 0);
f0102d59:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102d5e:	0f 85 9d 01 00 00    	jne    f0102f01 <mem_init+0x1b0f>
    *(uint32_t *)PGSIZE = 0x03030303U;
f0102d64:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102d6b:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102d6e:	89 f0                	mov    %esi,%eax
f0102d70:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0102d76:	c1 f8 03             	sar    $0x3,%eax
f0102d79:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102d7c:	89 c2                	mov    %eax,%edx
f0102d7e:	c1 ea 0c             	shr    $0xc,%edx
f0102d81:	3b 15 94 92 2c f0    	cmp    0xf02c9294,%edx
f0102d87:	0f 83 8d 01 00 00    	jae    f0102f1a <mem_init+0x1b28>
    assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102d8d:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102d94:	03 03 03 
f0102d97:	0f 85 8f 01 00 00    	jne    f0102f2c <mem_init+0x1b3a>
    page_remove(kern_pgdir, (void*) PGSIZE);
f0102d9d:	83 ec 08             	sub    $0x8,%esp
f0102da0:	68 00 10 00 00       	push   $0x1000
f0102da5:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0102dab:	e8 32 e5 ff ff       	call   f01012e2 <page_remove>
    assert(pp2->pp_ref == 0);
f0102db0:	83 c4 10             	add    $0x10,%esp
f0102db3:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102db8:	0f 85 87 01 00 00    	jne    f0102f45 <mem_init+0x1b53>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102dbe:	8b 0d 98 92 2c f0    	mov    0xf02c9298,%ecx
f0102dc4:	8b 11                	mov    (%ecx),%edx
f0102dc6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102dcc:	89 d8                	mov    %ebx,%eax
f0102dce:	2b 05 9c 92 2c f0    	sub    0xf02c929c,%eax
f0102dd4:	c1 f8 03             	sar    $0x3,%eax
f0102dd7:	c1 e0 0c             	shl    $0xc,%eax
f0102dda:	39 c2                	cmp    %eax,%edx
f0102ddc:	0f 85 7c 01 00 00    	jne    f0102f5e <mem_init+0x1b6c>
    kern_pgdir[0] = 0;
f0102de2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f0102de8:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102ded:	0f 85 84 01 00 00    	jne    f0102f77 <mem_init+0x1b85>
    pp0->pp_ref = 0;
f0102df3:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

    // free the pages we took
    page_free(pp0);
f0102df9:	83 ec 0c             	sub    $0xc,%esp
f0102dfc:	53                   	push   %ebx
f0102dfd:	e8 5a e2 ff ff       	call   f010105c <page_free>

    cprintf("check_page_installed_pgdir() succeeded!\n");
f0102e02:	c7 04 24 78 7a 10 f0 	movl   $0xf0107a78,(%esp)
f0102e09:	e8 3e 0b 00 00       	call   f010394c <cprintf>
}
f0102e0e:	83 c4 10             	add    $0x10,%esp
f0102e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102e14:	5b                   	pop    %ebx
f0102e15:	5e                   	pop    %esi
f0102e16:	5f                   	pop    %edi
f0102e17:	5d                   	pop    %ebp
f0102e18:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e19:	50                   	push   %eax
f0102e1a:	68 e8 6b 10 f0       	push   $0xf0106be8
f0102e1f:	68 ee 00 00 00       	push   $0xee
f0102e24:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102e29:	e8 12 d2 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0102e2e:	68 e7 7b 10 f0       	push   $0xf0107be7
f0102e33:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102e38:	68 6a 04 00 00       	push   $0x46a
f0102e3d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102e42:	e8 f9 d1 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f0102e47:	68 fd 7b 10 f0       	push   $0xf0107bfd
f0102e4c:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102e51:	68 6b 04 00 00       	push   $0x46b
f0102e56:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102e5b:	e8 e0 d1 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0102e60:	68 13 7c 10 f0       	push   $0xf0107c13
f0102e65:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102e6a:	68 6c 04 00 00       	push   $0x46c
f0102e6f:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102e74:	e8 c7 d1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102e79:	50                   	push   %eax
f0102e7a:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0102e7f:	6a 58                	push   $0x58
f0102e81:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0102e86:	e8 b5 d1 ff ff       	call   f0100040 <_panic>
f0102e8b:	50                   	push   %eax
f0102e8c:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0102e91:	6a 58                	push   $0x58
f0102e93:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0102e98:	e8 a3 d1 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102e9d:	68 e4 7c 10 f0       	push   $0xf0107ce4
f0102ea2:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102ea7:	68 71 04 00 00       	push   $0x471
f0102eac:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102eb1:	e8 8a d1 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102eb6:	68 04 7a 10 f0       	push   $0xf0107a04
f0102ebb:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102ec0:	68 72 04 00 00       	push   $0x472
f0102ec5:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102eca:	e8 71 d1 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102ecf:	68 28 7a 10 f0       	push   $0xf0107a28
f0102ed4:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102ed9:	68 74 04 00 00       	push   $0x474
f0102ede:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102ee3:	e8 58 d1 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f0102ee8:	68 06 7d 10 f0       	push   $0xf0107d06
f0102eed:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102ef2:	68 75 04 00 00       	push   $0x475
f0102ef7:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102efc:	e8 3f d1 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 0);
f0102f01:	68 70 7d 10 f0       	push   $0xf0107d70
f0102f06:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102f0b:	68 76 04 00 00       	push   $0x476
f0102f10:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102f15:	e8 26 d1 ff ff       	call   f0100040 <_panic>
f0102f1a:	50                   	push   %eax
f0102f1b:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0102f20:	6a 58                	push   $0x58
f0102f22:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0102f27:	e8 14 d1 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102f2c:	68 4c 7a 10 f0       	push   $0xf0107a4c
f0102f31:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102f36:	68 78 04 00 00       	push   $0x478
f0102f3b:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102f40:	e8 fb d0 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f0102f45:	68 3e 7d 10 f0       	push   $0xf0107d3e
f0102f4a:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102f4f:	68 7a 04 00 00       	push   $0x47a
f0102f54:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102f59:	e8 e2 d0 ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102f5e:	68 d4 73 10 f0       	push   $0xf01073d4
f0102f63:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102f68:	68 7d 04 00 00       	push   $0x47d
f0102f6d:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102f72:	e8 c9 d0 ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f0102f77:	68 f5 7c 10 f0       	push   $0xf0107cf5
f0102f7c:	68 ff 7a 10 f0       	push   $0xf0107aff
f0102f81:	68 7f 04 00 00       	push   $0x47f
f0102f86:	68 d9 7a 10 f0       	push   $0xf0107ad9
f0102f8b:	e8 b0 d0 ff ff       	call   f0100040 <_panic>

f0102f90 <user_mem_check>:
{
f0102f90:	55                   	push   %ebp
f0102f91:	89 e5                	mov    %esp,%ebp
f0102f93:	57                   	push   %edi
f0102f94:	56                   	push   %esi
f0102f95:	53                   	push   %ebx
f0102f96:	83 ec 0c             	sub    $0xc,%esp
f0102f99:	8b 75 14             	mov    0x14(%ebp),%esi
    uint32_t begin = ROUNDDOWN(addr, PGSIZE);
f0102f9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102f9f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    uint32_t end = ROUNDUP(addr + len, PGSIZE);
f0102fa5:	8b 45 10             	mov    0x10(%ebp),%eax
f0102fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
f0102fab:	8d bc 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%edi
f0102fb2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    while (begin < end) {
f0102fb8:	39 fb                	cmp    %edi,%ebx
f0102fba:	73 4e                	jae    f010300a <user_mem_check+0x7a>
        pte_t *pte = pgdir_walk(env->env_pgdir, (void *)begin, 0);
f0102fbc:	83 ec 04             	sub    $0x4,%esp
f0102fbf:	6a 00                	push   $0x0
f0102fc1:	53                   	push   %ebx
f0102fc2:	8b 45 08             	mov    0x8(%ebp),%eax
f0102fc5:	ff 70 60             	pushl  0x60(%eax)
f0102fc8:	e8 f3 e0 ff ff       	call   f01010c0 <pgdir_walk>
        if (begin >= ULIM || pte == NULL || !(*pte & PTE_P) || (*pte & perm) != perm) {
f0102fcd:	83 c4 10             	add    $0x10,%esp
f0102fd0:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102fd6:	77 18                	ja     f0102ff0 <user_mem_check+0x60>
f0102fd8:	85 c0                	test   %eax,%eax
f0102fda:	74 14                	je     f0102ff0 <user_mem_check+0x60>
f0102fdc:	8b 00                	mov    (%eax),%eax
f0102fde:	a8 01                	test   $0x1,%al
f0102fe0:	74 0e                	je     f0102ff0 <user_mem_check+0x60>
f0102fe2:	21 f0                	and    %esi,%eax
f0102fe4:	39 c6                	cmp    %eax,%esi
f0102fe6:	75 08                	jne    f0102ff0 <user_mem_check+0x60>
        begin += PGSIZE;
f0102fe8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102fee:	eb c8                	jmp    f0102fb8 <user_mem_check+0x28>
            user_mem_check_addr = (begin < addr) ? addr : begin;
f0102ff0:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0102ff3:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f0102ff7:	89 1d 3c 02 2b f0    	mov    %ebx,0xf02b023c
            return -E_FAULT;
f0102ffd:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0103002:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103005:	5b                   	pop    %ebx
f0103006:	5e                   	pop    %esi
f0103007:	5f                   	pop    %edi
f0103008:	5d                   	pop    %ebp
f0103009:	c3                   	ret    
    return 0;
f010300a:	b8 00 00 00 00       	mov    $0x0,%eax
f010300f:	eb f1                	jmp    f0103002 <user_mem_check+0x72>

f0103011 <user_mem_assert>:
{
f0103011:	55                   	push   %ebp
f0103012:	89 e5                	mov    %esp,%ebp
f0103014:	53                   	push   %ebx
f0103015:	83 ec 04             	sub    $0x4,%esp
f0103018:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f010301b:	8b 45 14             	mov    0x14(%ebp),%eax
f010301e:	83 c8 04             	or     $0x4,%eax
f0103021:	50                   	push   %eax
f0103022:	ff 75 10             	pushl  0x10(%ebp)
f0103025:	ff 75 0c             	pushl  0xc(%ebp)
f0103028:	53                   	push   %ebx
f0103029:	e8 62 ff ff ff       	call   f0102f90 <user_mem_check>
f010302e:	83 c4 10             	add    $0x10,%esp
f0103031:	85 c0                	test   %eax,%eax
f0103033:	78 05                	js     f010303a <user_mem_assert+0x29>
}
f0103035:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103038:	c9                   	leave  
f0103039:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f010303a:	83 ec 04             	sub    $0x4,%esp
f010303d:	ff 35 3c 02 2b f0    	pushl  0xf02b023c
f0103043:	ff 73 48             	pushl  0x48(%ebx)
f0103046:	68 a4 7a 10 f0       	push   $0xf0107aa4
f010304b:	e8 fc 08 00 00       	call   f010394c <cprintf>
		env_destroy(env);	// may not return
f0103050:	89 1c 24             	mov    %ebx,(%esp)
f0103053:	e8 15 06 00 00       	call   f010366d <env_destroy>
f0103058:	83 c4 10             	add    $0x10,%esp
}
f010305b:	eb d8                	jmp    f0103035 <user_mem_assert+0x24>

f010305d <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f010305d:	55                   	push   %ebp
f010305e:	89 e5                	mov    %esp,%ebp
f0103060:	57                   	push   %edi
f0103061:	56                   	push   %esi
f0103062:	53                   	push   %ebx
f0103063:	83 ec 0c             	sub    $0xc,%esp
f0103066:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	void *begin = ROUNDDOWN(va, PGSIZE);
f0103068:	89 d3                	mov    %edx,%ebx
f010306a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	void *end = ROUNDUP(va + len, PGSIZE);
f0103070:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0103077:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010307c:	89 c6                	mov    %eax,%esi

    if ((uint32_t)end > UTOP) {
f010307e:	3d 00 00 c0 ee       	cmp    $0xeec00000,%eax
f0103083:	77 30                	ja     f01030b5 <region_alloc+0x58>
        panic("region_alloc: cannot allocate pages over UTOP");
    }

    while (begin < end) {
f0103085:	39 f3                	cmp    %esi,%ebx
f0103087:	73 6f                	jae    f01030f8 <region_alloc+0x9b>
        struct PageInfo *pp;

        if ((pp = page_alloc(0)) == NULL) {
f0103089:	83 ec 0c             	sub    $0xc,%esp
f010308c:	6a 00                	push   $0x0
f010308e:	e8 51 df ff ff       	call   f0100fe4 <page_alloc>
f0103093:	83 c4 10             	add    $0x10,%esp
f0103096:	85 c0                	test   %eax,%eax
f0103098:	74 32                	je     f01030cc <region_alloc+0x6f>
            panic("region_alloc: out of free memory");
        }

        int r = page_insert(e->env_pgdir, pp, begin, PTE_U | PTE_W);
f010309a:	6a 06                	push   $0x6
f010309c:	53                   	push   %ebx
f010309d:	50                   	push   %eax
f010309e:	ff 77 60             	pushl  0x60(%edi)
f01030a1:	e8 88 e2 ff ff       	call   f010132e <page_insert>

        if (r != 0) {
f01030a6:	83 c4 10             	add    $0x10,%esp
f01030a9:	85 c0                	test   %eax,%eax
f01030ab:	75 36                	jne    f01030e3 <region_alloc+0x86>
            panic("region_alloc: %e", r);
        }
        begin += PGSIZE;
f01030ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01030b3:	eb d0                	jmp    f0103085 <region_alloc+0x28>
        panic("region_alloc: cannot allocate pages over UTOP");
f01030b5:	83 ec 04             	sub    $0x4,%esp
f01030b8:	68 0c 7e 10 f0       	push   $0xf0107e0c
f01030bd:	68 2d 01 00 00       	push   $0x12d
f01030c2:	68 7f 7e 10 f0       	push   $0xf0107e7f
f01030c7:	e8 74 cf ff ff       	call   f0100040 <_panic>
            panic("region_alloc: out of free memory");
f01030cc:	83 ec 04             	sub    $0x4,%esp
f01030cf:	68 3c 7e 10 f0       	push   $0xf0107e3c
f01030d4:	68 34 01 00 00       	push   $0x134
f01030d9:	68 7f 7e 10 f0       	push   $0xf0107e7f
f01030de:	e8 5d cf ff ff       	call   f0100040 <_panic>
            panic("region_alloc: %e", r);
f01030e3:	50                   	push   %eax
f01030e4:	68 8a 7e 10 f0       	push   $0xf0107e8a
f01030e9:	68 3a 01 00 00       	push   $0x13a
f01030ee:	68 7f 7e 10 f0       	push   $0xf0107e7f
f01030f3:	e8 48 cf ff ff       	call   f0100040 <_panic>
    }
}
f01030f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01030fb:	5b                   	pop    %ebx
f01030fc:	5e                   	pop    %esi
f01030fd:	5f                   	pop    %edi
f01030fe:	5d                   	pop    %ebp
f01030ff:	c3                   	ret    

f0103100 <envid2env>:
{
f0103100:	55                   	push   %ebp
f0103101:	89 e5                	mov    %esp,%ebp
f0103103:	56                   	push   %esi
f0103104:	53                   	push   %ebx
f0103105:	8b 45 08             	mov    0x8(%ebp),%eax
f0103108:	8b 55 10             	mov    0x10(%ebp),%edx
	if (envid == 0) {
f010310b:	85 c0                	test   %eax,%eax
f010310d:	74 2e                	je     f010313d <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f010310f:	89 c3                	mov    %eax,%ebx
f0103111:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103117:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f010311a:	03 1d 48 02 2b f0    	add    0xf02b0248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103120:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103124:	74 31                	je     f0103157 <envid2env+0x57>
f0103126:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103129:	75 2c                	jne    f0103157 <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010312b:	84 d2                	test   %dl,%dl
f010312d:	75 38                	jne    f0103167 <envid2env+0x67>
	*env_store = e;
f010312f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103132:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103134:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103139:	5b                   	pop    %ebx
f010313a:	5e                   	pop    %esi
f010313b:	5d                   	pop    %ebp
f010313c:	c3                   	ret    
		*env_store = curenv;
f010313d:	e8 65 2d 00 00       	call   f0105ea7 <cpunum>
f0103142:	6b c0 74             	imul   $0x74,%eax,%eax
f0103145:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010314b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010314e:	89 01                	mov    %eax,(%ecx)
		return 0;
f0103150:	b8 00 00 00 00       	mov    $0x0,%eax
f0103155:	eb e2                	jmp    f0103139 <envid2env+0x39>
		*env_store = 0;
f0103157:	8b 45 0c             	mov    0xc(%ebp),%eax
f010315a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103160:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103165:	eb d2                	jmp    f0103139 <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103167:	e8 3b 2d 00 00       	call   f0105ea7 <cpunum>
f010316c:	6b c0 74             	imul   $0x74,%eax,%eax
f010316f:	39 98 28 a0 2c f0    	cmp    %ebx,-0xfd35fd8(%eax)
f0103175:	74 b8                	je     f010312f <envid2env+0x2f>
f0103177:	8b 73 4c             	mov    0x4c(%ebx),%esi
f010317a:	e8 28 2d 00 00       	call   f0105ea7 <cpunum>
f010317f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103182:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0103188:	3b 70 48             	cmp    0x48(%eax),%esi
f010318b:	74 a2                	je     f010312f <envid2env+0x2f>
		*env_store = 0;
f010318d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103196:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010319b:	eb 9c                	jmp    f0103139 <envid2env+0x39>

f010319d <env_init_percpu>:
{
f010319d:	55                   	push   %ebp
f010319e:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f01031a0:	b8 20 43 12 f0       	mov    $0xf0124320,%eax
f01031a5:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01031a8:	b8 23 00 00 00       	mov    $0x23,%eax
f01031ad:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01031af:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01031b1:	b8 10 00 00 00       	mov    $0x10,%eax
f01031b6:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01031b8:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01031ba:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01031bc:	ea c3 31 10 f0 08 00 	ljmp   $0x8,$0xf01031c3
	asm volatile("lldt %0" : : "r" (sel));
f01031c3:	b8 00 00 00 00       	mov    $0x0,%eax
f01031c8:	0f 00 d0             	lldt   %ax
}
f01031cb:	5d                   	pop    %ebp
f01031cc:	c3                   	ret    

f01031cd <env_init>:
{
f01031cd:	55                   	push   %ebp
f01031ce:	89 e5                	mov    %esp,%ebp
f01031d0:	56                   	push   %esi
f01031d1:	53                   	push   %ebx
	    envs[i].env_status = ENV_FREE;
f01031d2:	8b 35 48 02 2b f0    	mov    0xf02b0248,%esi
f01031d8:	8b 15 4c 02 2b f0    	mov    0xf02b024c,%edx
f01031de:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f01031e4:	8d 5e 84             	lea    -0x7c(%esi),%ebx
f01031e7:	89 c1                	mov    %eax,%ecx
f01031e9:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	    envs[i].env_id = 0;
f01031f0:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
	    envs[i].env_link = env_free_list;
f01031f7:	89 50 44             	mov    %edx,0x44(%eax)
f01031fa:	83 e8 7c             	sub    $0x7c,%eax
	    env_free_list = &envs[i];
f01031fd:	89 ca                	mov    %ecx,%edx
	for (int i = NENV - 1; i >= 0; i--) {
f01031ff:	39 d8                	cmp    %ebx,%eax
f0103201:	75 e4                	jne    f01031e7 <env_init+0x1a>
f0103203:	89 35 4c 02 2b f0    	mov    %esi,0xf02b024c
	env_init_percpu();
f0103209:	e8 8f ff ff ff       	call   f010319d <env_init_percpu>
}
f010320e:	5b                   	pop    %ebx
f010320f:	5e                   	pop    %esi
f0103210:	5d                   	pop    %ebp
f0103211:	c3                   	ret    

f0103212 <env_alloc>:
{
f0103212:	55                   	push   %ebp
f0103213:	89 e5                	mov    %esp,%ebp
f0103215:	53                   	push   %ebx
f0103216:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103219:	8b 1d 4c 02 2b f0    	mov    0xf02b024c,%ebx
f010321f:	85 db                	test   %ebx,%ebx
f0103221:	0f 84 3d 01 00 00    	je     f0103364 <env_alloc+0x152>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103227:	83 ec 0c             	sub    $0xc,%esp
f010322a:	6a 01                	push   $0x1
f010322c:	e8 b3 dd ff ff       	call   f0100fe4 <page_alloc>
f0103231:	83 c4 10             	add    $0x10,%esp
f0103234:	85 c0                	test   %eax,%eax
f0103236:	0f 84 2f 01 00 00    	je     f010336b <env_alloc+0x159>
	return (pp - pages) << PGSHIFT;
f010323c:	89 c2                	mov    %eax,%edx
f010323e:	2b 15 9c 92 2c f0    	sub    0xf02c929c,%edx
f0103244:	c1 fa 03             	sar    $0x3,%edx
f0103247:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010324a:	89 d1                	mov    %edx,%ecx
f010324c:	c1 e9 0c             	shr    $0xc,%ecx
f010324f:	3b 0d 94 92 2c f0    	cmp    0xf02c9294,%ecx
f0103255:	0f 83 e2 00 00 00    	jae    f010333d <env_alloc+0x12b>
	return (void *)(pa + KERNBASE);
f010325b:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0103261:	89 53 60             	mov    %edx,0x60(%ebx)
    p->pp_ref += 1;
f0103264:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103269:	83 ec 04             	sub    $0x4,%esp
f010326c:	68 00 10 00 00       	push   $0x1000
f0103271:	ff 35 98 92 2c f0    	pushl  0xf02c9298
f0103277:	ff 73 60             	pushl  0x60(%ebx)
f010327a:	e8 ba 26 00 00       	call   f0105939 <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010327f:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103282:	83 c4 10             	add    $0x10,%esp
f0103285:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010328a:	0f 86 bf 00 00 00    	jbe    f010334f <env_alloc+0x13d>
	return (physaddr_t)kva - KERNBASE;
f0103290:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103296:	83 ca 05             	or     $0x5,%edx
f0103299:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f010329f:	8b 43 48             	mov    0x48(%ebx),%eax
f01032a2:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f01032a7:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f01032ac:	ba 00 10 00 00       	mov    $0x1000,%edx
f01032b1:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01032b4:	89 da                	mov    %ebx,%edx
f01032b6:	2b 15 48 02 2b f0    	sub    0xf02b0248,%edx
f01032bc:	c1 fa 02             	sar    $0x2,%edx
f01032bf:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01032c5:	09 d0                	or     %edx,%eax
f01032c7:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01032ca:	8b 45 0c             	mov    0xc(%ebp),%eax
f01032cd:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01032d0:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01032d7:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01032de:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01032e5:	83 ec 04             	sub    $0x4,%esp
f01032e8:	6a 44                	push   $0x44
f01032ea:	6a 00                	push   $0x0
f01032ec:	53                   	push   %ebx
f01032ed:	e8 92 25 00 00       	call   f0105884 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01032f2:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01032f8:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01032fe:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103304:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f010330b:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103311:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103318:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f010331f:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103323:	8b 43 44             	mov    0x44(%ebx),%eax
f0103326:	a3 4c 02 2b f0       	mov    %eax,0xf02b024c
	*newenv_store = e;
f010332b:	8b 45 08             	mov    0x8(%ebp),%eax
f010332e:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103330:	83 c4 10             	add    $0x10,%esp
f0103333:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010333b:	c9                   	leave  
f010333c:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010333d:	52                   	push   %edx
f010333e:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0103343:	6a 58                	push   $0x58
f0103345:	68 e5 7a 10 f0       	push   $0xf0107ae5
f010334a:	e8 f1 cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010334f:	50                   	push   %eax
f0103350:	68 e8 6b 10 f0       	push   $0xf0106be8
f0103355:	68 ca 00 00 00       	push   $0xca
f010335a:	68 7f 7e 10 f0       	push   $0xf0107e7f
f010335f:	e8 dc cc ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f0103364:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103369:	eb cd                	jmp    f0103338 <env_alloc+0x126>
		return -E_NO_MEM;
f010336b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103370:	eb c6                	jmp    f0103338 <env_alloc+0x126>

f0103372 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103372:	55                   	push   %ebp
f0103373:	89 e5                	mov    %esp,%ebp
f0103375:	57                   	push   %edi
f0103376:	56                   	push   %esi
f0103377:	53                   	push   %ebx
f0103378:	83 ec 34             	sub    $0x34,%esp
f010337b:	8b 7d 08             	mov    0x8(%ebp),%edi
	// LAB 3: Your code here.
	struct Env *env;
	int r;

	if((r = env_alloc(&env, 0)) != 0)
f010337e:	6a 00                	push   $0x0
f0103380:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103383:	50                   	push   %eax
f0103384:	e8 89 fe ff ff       	call   f0103212 <env_alloc>
f0103389:	83 c4 10             	add    $0x10,%esp
f010338c:	85 c0                	test   %eax,%eax
f010338e:	75 33                	jne    f01033c3 <env_create+0x51>
	    panic("env_create: %e", r);

	load_icode(env, binary);
f0103390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103393:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (elfhr->e_magic != ELF_MAGIC) {
f0103396:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f010339c:	75 3a                	jne    f01033d8 <env_create+0x66>
    lcr3(PADDR(e->env_pgdir));
f010339e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01033a1:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01033a4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01033a9:	76 44                	jbe    f01033ef <env_create+0x7d>
	return (physaddr_t)kva - KERNBASE;
f01033ab:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01033b0:	0f 22 d8             	mov    %eax,%cr3
    struct Proghdr *ph = (struct Proghdr *)(binary + elfhr->e_phoff);
f01033b3:	89 fb                	mov    %edi,%ebx
f01033b5:	03 5f 1c             	add    0x1c(%edi),%ebx
    struct Proghdr *eph = ph + elfhr->e_phnum;
f01033b8:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f01033bc:	c1 e6 05             	shl    $0x5,%esi
f01033bf:	01 de                	add    %ebx,%esi
f01033c1:	eb 44                	jmp    f0103407 <env_create+0x95>
	    panic("env_create: %e", r);
f01033c3:	50                   	push   %eax
f01033c4:	68 9b 7e 10 f0       	push   $0xf0107e9b
f01033c9:	68 aa 01 00 00       	push   $0x1aa
f01033ce:	68 7f 7e 10 f0       	push   $0xf0107e7f
f01033d3:	e8 68 cc ff ff       	call   f0100040 <_panic>
        panic("load_icode: invalid elf header");
f01033d8:	83 ec 04             	sub    $0x4,%esp
f01033db:	68 60 7e 10 f0       	push   $0xf0107e60
f01033e0:	68 7a 01 00 00       	push   $0x17a
f01033e5:	68 7f 7e 10 f0       	push   $0xf0107e7f
f01033ea:	e8 51 cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033ef:	50                   	push   %eax
f01033f0:	68 e8 6b 10 f0       	push   $0xf0106be8
f01033f5:	68 7e 01 00 00       	push   $0x17e
f01033fa:	68 7f 7e 10 f0       	push   $0xf0107e7f
f01033ff:	e8 3c cc ff ff       	call   f0100040 <_panic>
    for (; ph < eph; ph++) {
f0103404:	83 c3 20             	add    $0x20,%ebx
f0103407:	39 de                	cmp    %ebx,%esi
f0103409:	76 43                	jbe    f010344e <env_create+0xdc>
        if (ph->p_type != ELF_PROG_LOAD)
f010340b:	83 3b 01             	cmpl   $0x1,(%ebx)
f010340e:	75 f4                	jne    f0103404 <env_create+0x92>
        region_alloc(e, (uint8_t *)ph->p_va, ph->p_memsz);
f0103410:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103413:	8b 53 08             	mov    0x8(%ebx),%edx
f0103416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103419:	e8 3f fc ff ff       	call   f010305d <region_alloc>
        memcpy((uint8_t *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
f010341e:	83 ec 04             	sub    $0x4,%esp
f0103421:	ff 73 10             	pushl  0x10(%ebx)
f0103424:	89 f8                	mov    %edi,%eax
f0103426:	03 43 04             	add    0x4(%ebx),%eax
f0103429:	50                   	push   %eax
f010342a:	ff 73 08             	pushl  0x8(%ebx)
f010342d:	e8 07 25 00 00       	call   f0105939 <memcpy>
        memset((uint8_t *)ph->p_va + ph->p_filesz, 0, ph->p_memsz - ph->p_filesz);
f0103432:	8b 43 10             	mov    0x10(%ebx),%eax
f0103435:	83 c4 0c             	add    $0xc,%esp
f0103438:	8b 53 14             	mov    0x14(%ebx),%edx
f010343b:	29 c2                	sub    %eax,%edx
f010343d:	52                   	push   %edx
f010343e:	6a 00                	push   $0x0
f0103440:	03 43 08             	add    0x8(%ebx),%eax
f0103443:	50                   	push   %eax
f0103444:	e8 3b 24 00 00       	call   f0105884 <memset>
f0103449:	83 c4 10             	add    $0x10,%esp
f010344c:	eb b6                	jmp    f0103404 <env_create+0x92>
    e->env_tf.tf_eip = elfhr->e_entry;
f010344e:	8b 47 18             	mov    0x18(%edi),%eax
f0103451:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103454:	89 47 30             	mov    %eax,0x30(%edi)
	region_alloc(e, (void *)(USTACKTOP - PGSIZE), PGSIZE);
f0103457:	b9 00 10 00 00       	mov    $0x1000,%ecx
f010345c:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103461:	89 f8                	mov    %edi,%eax
f0103463:	e8 f5 fb ff ff       	call   f010305d <region_alloc>
	lcr3(PADDR(kern_pgdir));
f0103468:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
	if ((uint32_t)kva < KERNBASE)
f010346d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103472:	76 1e                	jbe    f0103492 <env_create+0x120>
	return (physaddr_t)kva - KERNBASE;
f0103474:	05 00 00 00 10       	add    $0x10000000,%eax
f0103479:	0f 22 d8             	mov    %eax,%cr3
	env->env_type = type;
f010347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010347f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103482:	89 48 50             	mov    %ecx,0x50(%eax)

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if (type == ENV_TYPE_FS) {
f0103485:	83 f9 01             	cmp    $0x1,%ecx
f0103488:	74 1d                	je     f01034a7 <env_create+0x135>
	    env->env_tf.tf_eflags |= FL_IOPL_MASK;
	}
}
f010348a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010348d:	5b                   	pop    %ebx
f010348e:	5e                   	pop    %esi
f010348f:	5f                   	pop    %edi
f0103490:	5d                   	pop    %ebp
f0103491:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103492:	50                   	push   %eax
f0103493:	68 e8 6b 10 f0       	push   $0xf0106be8
f0103498:	68 98 01 00 00       	push   $0x198
f010349d:	68 7f 7e 10 f0       	push   $0xf0107e7f
f01034a2:	e8 99 cb ff ff       	call   f0100040 <_panic>
	    env->env_tf.tf_eflags |= FL_IOPL_MASK;
f01034a7:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f01034ae:	eb da                	jmp    f010348a <env_create+0x118>

f01034b0 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f01034b0:	55                   	push   %ebp
f01034b1:	89 e5                	mov    %esp,%ebp
f01034b3:	57                   	push   %edi
f01034b4:	56                   	push   %esi
f01034b5:	53                   	push   %ebx
f01034b6:	83 ec 1c             	sub    $0x1c,%esp
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01034b9:	e8 e9 29 00 00       	call   f0105ea7 <cpunum>
f01034be:	6b c0 74             	imul   $0x74,%eax,%eax
f01034c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f01034c8:	8b 55 08             	mov    0x8(%ebp),%edx
f01034cb:	8b 7d 08             	mov    0x8(%ebp),%edi
f01034ce:	39 90 28 a0 2c f0    	cmp    %edx,-0xfd35fd8(%eax)
f01034d4:	0f 85 b2 00 00 00    	jne    f010358c <env_free+0xdc>
		lcr3(PADDR(kern_pgdir));
f01034da:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
	if ((uint32_t)kva < KERNBASE)
f01034df:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01034e4:	76 17                	jbe    f01034fd <env_free+0x4d>
	return (physaddr_t)kva - KERNBASE;
f01034e6:	05 00 00 00 10       	add    $0x10000000,%eax
f01034eb:	0f 22 d8             	mov    %eax,%cr3
f01034ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f01034f5:	8b 7d 08             	mov    0x8(%ebp),%edi
f01034f8:	e9 8f 00 00 00       	jmp    f010358c <env_free+0xdc>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034fd:	50                   	push   %eax
f01034fe:	68 e8 6b 10 f0       	push   $0xf0106be8
f0103503:	68 c4 01 00 00       	push   $0x1c4
f0103508:	68 7f 7e 10 f0       	push   $0xf0107e7f
f010350d:	e8 2e cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103512:	50                   	push   %eax
f0103513:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0103518:	68 d3 01 00 00       	push   $0x1d3
f010351d:	68 7f 7e 10 f0       	push   $0xf0107e7f
f0103522:	e8 19 cb ff ff       	call   f0100040 <_panic>
f0103527:	83 c3 04             	add    $0x4,%ebx
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010352a:	39 de                	cmp    %ebx,%esi
f010352c:	74 21                	je     f010354f <env_free+0x9f>
			if (pt[pteno] & PTE_P)
f010352e:	f6 03 01             	testb  $0x1,(%ebx)
f0103531:	74 f4                	je     f0103527 <env_free+0x77>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103533:	83 ec 08             	sub    $0x8,%esp
f0103536:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103539:	01 d8                	add    %ebx,%eax
f010353b:	c1 e0 0a             	shl    $0xa,%eax
f010353e:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103541:	50                   	push   %eax
f0103542:	ff 77 60             	pushl  0x60(%edi)
f0103545:	e8 98 dd ff ff       	call   f01012e2 <page_remove>
f010354a:	83 c4 10             	add    $0x10,%esp
f010354d:	eb d8                	jmp    f0103527 <env_free+0x77>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f010354f:	8b 47 60             	mov    0x60(%edi),%eax
f0103552:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103555:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f010355c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010355f:	3b 05 94 92 2c f0    	cmp    0xf02c9294,%eax
f0103565:	73 6a                	jae    f01035d1 <env_free+0x121>
		page_decref(pa2page(pa));
f0103567:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010356a:	a1 9c 92 2c f0       	mov    0xf02c929c,%eax
f010356f:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103572:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103575:	50                   	push   %eax
f0103576:	e8 1c db ff ff       	call   f0101097 <page_decref>
f010357b:	83 c4 10             	add    $0x10,%esp
f010357e:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f0103582:	8b 45 dc             	mov    -0x24(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103585:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010358a:	74 59                	je     f01035e5 <env_free+0x135>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010358c:	8b 47 60             	mov    0x60(%edi),%eax
f010358f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103592:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103595:	a8 01                	test   $0x1,%al
f0103597:	74 e5                	je     f010357e <env_free+0xce>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010359e:	89 c2                	mov    %eax,%edx
f01035a0:	c1 ea 0c             	shr    $0xc,%edx
f01035a3:	89 55 d8             	mov    %edx,-0x28(%ebp)
f01035a6:	39 15 94 92 2c f0    	cmp    %edx,0xf02c9294
f01035ac:	0f 86 60 ff ff ff    	jbe    f0103512 <env_free+0x62>
	return (void *)(pa + KERNBASE);
f01035b2:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01035b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01035bb:	c1 e2 14             	shl    $0x14,%edx
f01035be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01035c1:	8d b0 00 10 00 f0    	lea    -0xffff000(%eax),%esi
f01035c7:	f7 d8                	neg    %eax
f01035c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01035cc:	e9 5d ff ff ff       	jmp    f010352e <env_free+0x7e>
		panic("pa2page called with invalid pa");
f01035d1:	83 ec 04             	sub    $0x4,%esp
f01035d4:	68 6c 72 10 f0       	push   $0xf010726c
f01035d9:	6a 51                	push   $0x51
f01035db:	68 e5 7a 10 f0       	push   $0xf0107ae5
f01035e0:	e8 5b ca ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01035e5:	8b 45 08             	mov    0x8(%ebp),%eax
f01035e8:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01035eb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035f0:	76 52                	jbe    f0103644 <env_free+0x194>
	e->env_pgdir = 0;
f01035f2:	8b 55 08             	mov    0x8(%ebp),%edx
f01035f5:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
	return (physaddr_t)kva - KERNBASE;
f01035fc:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103601:	c1 e8 0c             	shr    $0xc,%eax
f0103604:	3b 05 94 92 2c f0    	cmp    0xf02c9294,%eax
f010360a:	73 4d                	jae    f0103659 <env_free+0x1a9>
	page_decref(pa2page(pa));
f010360c:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010360f:	8b 15 9c 92 2c f0    	mov    0xf02c929c,%edx
f0103615:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103618:	50                   	push   %eax
f0103619:	e8 79 da ff ff       	call   f0101097 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f010361e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103621:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f0103628:	a1 4c 02 2b f0       	mov    0xf02b024c,%eax
f010362d:	8b 55 08             	mov    0x8(%ebp),%edx
f0103630:	89 42 44             	mov    %eax,0x44(%edx)
	env_free_list = e;
f0103633:	89 15 4c 02 2b f0    	mov    %edx,0xf02b024c
}
f0103639:	83 c4 10             	add    $0x10,%esp
f010363c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010363f:	5b                   	pop    %ebx
f0103640:	5e                   	pop    %esi
f0103641:	5f                   	pop    %edi
f0103642:	5d                   	pop    %ebp
f0103643:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103644:	50                   	push   %eax
f0103645:	68 e8 6b 10 f0       	push   $0xf0106be8
f010364a:	68 e1 01 00 00       	push   $0x1e1
f010364f:	68 7f 7e 10 f0       	push   $0xf0107e7f
f0103654:	e8 e7 c9 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103659:	83 ec 04             	sub    $0x4,%esp
f010365c:	68 6c 72 10 f0       	push   $0xf010726c
f0103661:	6a 51                	push   $0x51
f0103663:	68 e5 7a 10 f0       	push   $0xf0107ae5
f0103668:	e8 d3 c9 ff ff       	call   f0100040 <_panic>

f010366d <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f010366d:	55                   	push   %ebp
f010366e:	89 e5                	mov    %esp,%ebp
f0103670:	53                   	push   %ebx
f0103671:	83 ec 04             	sub    $0x4,%esp
f0103674:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103677:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010367b:	74 21                	je     f010369e <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f010367d:	83 ec 0c             	sub    $0xc,%esp
f0103680:	53                   	push   %ebx
f0103681:	e8 2a fe ff ff       	call   f01034b0 <env_free>

	if (curenv == e) {
f0103686:	e8 1c 28 00 00       	call   f0105ea7 <cpunum>
f010368b:	6b c0 74             	imul   $0x74,%eax,%eax
f010368e:	83 c4 10             	add    $0x10,%esp
f0103691:	39 98 28 a0 2c f0    	cmp    %ebx,-0xfd35fd8(%eax)
f0103697:	74 1e                	je     f01036b7 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103699:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010369c:	c9                   	leave  
f010369d:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010369e:	e8 04 28 00 00       	call   f0105ea7 <cpunum>
f01036a3:	6b c0 74             	imul   $0x74,%eax,%eax
f01036a6:	39 98 28 a0 2c f0    	cmp    %ebx,-0xfd35fd8(%eax)
f01036ac:	74 cf                	je     f010367d <env_destroy+0x10>
		e->env_status = ENV_DYING;
f01036ae:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f01036b5:	eb e2                	jmp    f0103699 <env_destroy+0x2c>
		curenv = NULL;
f01036b7:	e8 eb 27 00 00       	call   f0105ea7 <cpunum>
f01036bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01036bf:	c7 80 28 a0 2c f0 00 	movl   $0x0,-0xfd35fd8(%eax)
f01036c6:	00 00 00 
		sched_yield();
f01036c9:	e8 ed 0e 00 00       	call   f01045bb <sched_yield>

f01036ce <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f01036ce:	55                   	push   %ebp
f01036cf:	89 e5                	mov    %esp,%ebp
f01036d1:	53                   	push   %ebx
f01036d2:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f01036d5:	e8 cd 27 00 00       	call   f0105ea7 <cpunum>
f01036da:	6b c0 74             	imul   $0x74,%eax,%eax
f01036dd:	8b 98 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%ebx
f01036e3:	e8 bf 27 00 00       	call   f0105ea7 <cpunum>
f01036e8:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01036eb:	8b 65 08             	mov    0x8(%ebp),%esp
f01036ee:	61                   	popa   
f01036ef:	07                   	pop    %es
f01036f0:	1f                   	pop    %ds
f01036f1:	83 c4 08             	add    $0x8,%esp
f01036f4:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01036f5:	83 ec 04             	sub    $0x4,%esp
f01036f8:	68 aa 7e 10 f0       	push   $0xf0107eaa
f01036fd:	68 18 02 00 00       	push   $0x218
f0103702:	68 7f 7e 10 f0       	push   $0xf0107e7f
f0103707:	e8 34 c9 ff ff       	call   f0100040 <_panic>

f010370c <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f010370c:	55                   	push   %ebp
f010370d:	89 e5                	mov    %esp,%ebp
f010370f:	53                   	push   %ebx
f0103710:	83 ec 04             	sub    $0x4,%esp
f0103713:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.

	if (curenv && curenv->env_status == ENV_RUNNING) {
f0103716:	e8 8c 27 00 00       	call   f0105ea7 <cpunum>
f010371b:	6b c0 74             	imul   $0x74,%eax,%eax
f010371e:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f0103725:	74 14                	je     f010373b <env_run+0x2f>
f0103727:	e8 7b 27 00 00       	call   f0105ea7 <cpunum>
f010372c:	6b c0 74             	imul   $0x74,%eax,%eax
f010372f:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0103735:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103739:	74 4a                	je     f0103785 <env_run+0x79>
	    curenv->env_status = ENV_RUNNABLE;
	}
    curenv = e;
f010373b:	e8 67 27 00 00       	call   f0105ea7 <cpunum>
f0103740:	6b c0 74             	imul   $0x74,%eax,%eax
f0103743:	89 98 28 a0 2c f0    	mov    %ebx,-0xfd35fd8(%eax)
    e->env_status = ENV_RUNNING;
f0103749:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
    e->env_runs++;
f0103750:	83 43 58 01          	addl   $0x1,0x58(%ebx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103754:	83 ec 0c             	sub    $0xc,%esp
f0103757:	68 c0 43 12 f0       	push   $0xf01243c0
f010375c:	e8 53 2a 00 00       	call   f01061b4 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103761:	f3 90                	pause  
    unlock_kernel();
    lcr3(PADDR(e->env_pgdir));
f0103763:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103766:	83 c4 10             	add    $0x10,%esp
f0103769:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010376e:	77 2c                	ja     f010379c <env_run+0x90>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103770:	50                   	push   %eax
f0103771:	68 e8 6b 10 f0       	push   $0xf0106be8
f0103776:	68 3e 02 00 00       	push   $0x23e
f010377b:	68 7f 7e 10 f0       	push   $0xf0107e7f
f0103780:	e8 bb c8 ff ff       	call   f0100040 <_panic>
	    curenv->env_status = ENV_RUNNABLE;
f0103785:	e8 1d 27 00 00       	call   f0105ea7 <cpunum>
f010378a:	6b c0 74             	imul   $0x74,%eax,%eax
f010378d:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0103793:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f010379a:	eb 9f                	jmp    f010373b <env_run+0x2f>
	return (physaddr_t)kva - KERNBASE;
f010379c:	05 00 00 00 10       	add    $0x10000000,%eax
f01037a1:	0f 22 d8             	mov    %eax,%cr3
	env_pop_tf(&e->env_tf);
f01037a4:	83 ec 0c             	sub    $0xc,%esp
f01037a7:	53                   	push   %ebx
f01037a8:	e8 21 ff ff ff       	call   f01036ce <env_pop_tf>

f01037ad <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01037ad:	55                   	push   %ebp
f01037ae:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01037b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01037b3:	ba 70 00 00 00       	mov    $0x70,%edx
f01037b8:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01037b9:	ba 71 00 00 00       	mov    $0x71,%edx
f01037be:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01037bf:	0f b6 c0             	movzbl %al,%eax
}
f01037c2:	5d                   	pop    %ebp
f01037c3:	c3                   	ret    

f01037c4 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01037c4:	55                   	push   %ebp
f01037c5:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01037c7:	8b 45 08             	mov    0x8(%ebp),%eax
f01037ca:	ba 70 00 00 00       	mov    $0x70,%edx
f01037cf:	ee                   	out    %al,(%dx)
f01037d0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01037d3:	ba 71 00 00 00       	mov    $0x71,%edx
f01037d8:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01037d9:	5d                   	pop    %ebp
f01037da:	c3                   	ret    

f01037db <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01037db:	55                   	push   %ebp
f01037dc:	89 e5                	mov    %esp,%ebp
f01037de:	56                   	push   %esi
f01037df:	53                   	push   %ebx
f01037e0:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01037e3:	66 a3 a8 43 12 f0    	mov    %ax,0xf01243a8
	if (!didinit)
f01037e9:	80 3d 50 02 2b f0 00 	cmpb   $0x0,0xf02b0250
f01037f0:	75 07                	jne    f01037f9 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01037f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01037f5:	5b                   	pop    %ebx
f01037f6:	5e                   	pop    %esi
f01037f7:	5d                   	pop    %ebp
f01037f8:	c3                   	ret    
f01037f9:	89 c6                	mov    %eax,%esi
f01037fb:	ba 21 00 00 00       	mov    $0x21,%edx
f0103800:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103801:	66 c1 e8 08          	shr    $0x8,%ax
f0103805:	ba a1 00 00 00       	mov    $0xa1,%edx
f010380a:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f010380b:	83 ec 0c             	sub    $0xc,%esp
f010380e:	68 b6 7e 10 f0       	push   $0xf0107eb6
f0103813:	e8 34 01 00 00       	call   f010394c <cprintf>
f0103818:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f010381b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103820:	0f b7 f6             	movzwl %si,%esi
f0103823:	f7 d6                	not    %esi
f0103825:	eb 08                	jmp    f010382f <irq_setmask_8259A+0x54>
	for (i = 0; i < 16; i++)
f0103827:	83 c3 01             	add    $0x1,%ebx
f010382a:	83 fb 10             	cmp    $0x10,%ebx
f010382d:	74 18                	je     f0103847 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f010382f:	0f a3 de             	bt     %ebx,%esi
f0103832:	73 f3                	jae    f0103827 <irq_setmask_8259A+0x4c>
			cprintf(" %d", i);
f0103834:	83 ec 08             	sub    $0x8,%esp
f0103837:	53                   	push   %ebx
f0103838:	68 6f 83 10 f0       	push   $0xf010836f
f010383d:	e8 0a 01 00 00       	call   f010394c <cprintf>
f0103842:	83 c4 10             	add    $0x10,%esp
f0103845:	eb e0                	jmp    f0103827 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103847:	83 ec 0c             	sub    $0xc,%esp
f010384a:	68 29 6f 10 f0       	push   $0xf0106f29
f010384f:	e8 f8 00 00 00       	call   f010394c <cprintf>
f0103854:	83 c4 10             	add    $0x10,%esp
f0103857:	eb 99                	jmp    f01037f2 <irq_setmask_8259A+0x17>

f0103859 <pic_init>:
{
f0103859:	55                   	push   %ebp
f010385a:	89 e5                	mov    %esp,%ebp
f010385c:	57                   	push   %edi
f010385d:	56                   	push   %esi
f010385e:	53                   	push   %ebx
f010385f:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103862:	c6 05 50 02 2b f0 01 	movb   $0x1,0xf02b0250
f0103869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010386e:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103873:	89 da                	mov    %ebx,%edx
f0103875:	ee                   	out    %al,(%dx)
f0103876:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010387b:	89 ca                	mov    %ecx,%edx
f010387d:	ee                   	out    %al,(%dx)
f010387e:	bf 11 00 00 00       	mov    $0x11,%edi
f0103883:	be 20 00 00 00       	mov    $0x20,%esi
f0103888:	89 f8                	mov    %edi,%eax
f010388a:	89 f2                	mov    %esi,%edx
f010388c:	ee                   	out    %al,(%dx)
f010388d:	b8 20 00 00 00       	mov    $0x20,%eax
f0103892:	89 da                	mov    %ebx,%edx
f0103894:	ee                   	out    %al,(%dx)
f0103895:	b8 04 00 00 00       	mov    $0x4,%eax
f010389a:	ee                   	out    %al,(%dx)
f010389b:	b8 03 00 00 00       	mov    $0x3,%eax
f01038a0:	ee                   	out    %al,(%dx)
f01038a1:	bb a0 00 00 00       	mov    $0xa0,%ebx
f01038a6:	89 f8                	mov    %edi,%eax
f01038a8:	89 da                	mov    %ebx,%edx
f01038aa:	ee                   	out    %al,(%dx)
f01038ab:	b8 28 00 00 00       	mov    $0x28,%eax
f01038b0:	89 ca                	mov    %ecx,%edx
f01038b2:	ee                   	out    %al,(%dx)
f01038b3:	b8 02 00 00 00       	mov    $0x2,%eax
f01038b8:	ee                   	out    %al,(%dx)
f01038b9:	b8 01 00 00 00       	mov    $0x1,%eax
f01038be:	ee                   	out    %al,(%dx)
f01038bf:	bf 68 00 00 00       	mov    $0x68,%edi
f01038c4:	89 f8                	mov    %edi,%eax
f01038c6:	89 f2                	mov    %esi,%edx
f01038c8:	ee                   	out    %al,(%dx)
f01038c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01038ce:	89 c8                	mov    %ecx,%eax
f01038d0:	ee                   	out    %al,(%dx)
f01038d1:	89 f8                	mov    %edi,%eax
f01038d3:	89 da                	mov    %ebx,%edx
f01038d5:	ee                   	out    %al,(%dx)
f01038d6:	89 c8                	mov    %ecx,%eax
f01038d8:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01038d9:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f01038e0:	66 83 f8 ff          	cmp    $0xffff,%ax
f01038e4:	74 0f                	je     f01038f5 <pic_init+0x9c>
		irq_setmask_8259A(irq_mask_8259A);
f01038e6:	83 ec 0c             	sub    $0xc,%esp
f01038e9:	0f b7 c0             	movzwl %ax,%eax
f01038ec:	50                   	push   %eax
f01038ed:	e8 e9 fe ff ff       	call   f01037db <irq_setmask_8259A>
f01038f2:	83 c4 10             	add    $0x10,%esp
}
f01038f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01038f8:	5b                   	pop    %ebx
f01038f9:	5e                   	pop    %esi
f01038fa:	5f                   	pop    %edi
f01038fb:	5d                   	pop    %ebp
f01038fc:	c3                   	ret    

f01038fd <irq_eoi>:

void
irq_eoi(void)
{
f01038fd:	55                   	push   %ebp
f01038fe:	89 e5                	mov    %esp,%ebp
f0103900:	b8 20 00 00 00       	mov    $0x20,%eax
f0103905:	ba 20 00 00 00       	mov    $0x20,%edx
f010390a:	ee                   	out    %al,(%dx)
f010390b:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103910:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103911:	5d                   	pop    %ebp
f0103912:	c3                   	ret    

f0103913 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103913:	55                   	push   %ebp
f0103914:	89 e5                	mov    %esp,%ebp
f0103916:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103919:	ff 75 08             	pushl  0x8(%ebp)
f010391c:	e8 9a ce ff ff       	call   f01007bb <cputchar>
	*cnt++;
}
f0103921:	83 c4 10             	add    $0x10,%esp
f0103924:	c9                   	leave  
f0103925:	c3                   	ret    

f0103926 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103926:	55                   	push   %ebp
f0103927:	89 e5                	mov    %esp,%ebp
f0103929:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f010392c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103933:	ff 75 0c             	pushl  0xc(%ebp)
f0103936:	ff 75 08             	pushl  0x8(%ebp)
f0103939:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010393c:	50                   	push   %eax
f010393d:	68 13 39 10 f0       	push   $0xf0103913
f0103942:	e8 6e 17 00 00       	call   f01050b5 <vprintfmt>
	return cnt;
}
f0103947:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010394a:	c9                   	leave  
f010394b:	c3                   	ret    

f010394c <cprintf>:

int
cprintf(const char *fmt, ...)
{
f010394c:	55                   	push   %ebp
f010394d:	89 e5                	mov    %esp,%ebp
f010394f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103952:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103955:	50                   	push   %eax
f0103956:	ff 75 08             	pushl  0x8(%ebp)
f0103959:	e8 c8 ff ff ff       	call   f0103926 <vcprintf>
	va_end(ap);

	return cnt;
}
f010395e:	c9                   	leave  
f010395f:	c3                   	ret    

f0103960 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103960:	55                   	push   %ebp
f0103961:	89 e5                	mov    %esp,%ebp
f0103963:	57                   	push   %edi
f0103964:	56                   	push   %esi
f0103965:	53                   	push   %ebx
f0103966:	83 ec 1c             	sub    $0x1c,%esp
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:

    int id = thiscpu->cpu_id;
f0103969:	e8 39 25 00 00       	call   f0105ea7 <cpunum>
f010396e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103971:	0f b6 b0 20 a0 2c f0 	movzbl -0xfd35fe0(%eax),%esi

    // Setup a TSS so that we get the right stack
    // when we trap to the kernel.
    thiscpu->cpu_ts.ts_esp0 = (uint32_t)percpu_kstacks[id] + KSTKSIZE;
f0103978:	e8 2a 25 00 00       	call   f0105ea7 <cpunum>
f010397d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103980:	89 f1                	mov    %esi,%ecx
f0103982:	0f b6 d9             	movzbl %cl,%ebx
f0103985:	89 da                	mov    %ebx,%edx
f0103987:	c1 e2 0f             	shl    $0xf,%edx
f010398a:	81 c2 00 30 2d f0    	add    $0xf02d3000,%edx
f0103990:	89 90 30 a0 2c f0    	mov    %edx,-0xfd35fd0(%eax)
    thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103996:	e8 0c 25 00 00       	call   f0105ea7 <cpunum>
f010399b:	6b c0 74             	imul   $0x74,%eax,%eax
f010399e:	66 c7 80 34 a0 2c f0 	movw   $0x10,-0xfd35fcc(%eax)
f01039a5:	10 00 
    thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f01039a7:	e8 fb 24 00 00       	call   f0105ea7 <cpunum>
f01039ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01039af:	66 c7 80 92 a0 2c f0 	movw   $0x68,-0xfd35f6e(%eax)
f01039b6:	68 00 

    // Initialize the TSS slot of the gdt.
    gdt[(GD_TSS0 >> 3) + id] = SEG16(STS_T32A, (uint32_t) (&thiscpu->cpu_ts),
f01039b8:	83 c3 05             	add    $0x5,%ebx
f01039bb:	e8 e7 24 00 00       	call   f0105ea7 <cpunum>
f01039c0:	89 c7                	mov    %eax,%edi
f01039c2:	e8 e0 24 00 00       	call   f0105ea7 <cpunum>
f01039c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01039ca:	e8 d8 24 00 00       	call   f0105ea7 <cpunum>
f01039cf:	66 c7 04 dd 40 43 12 	movw   $0x67,-0xfedbcc0(,%ebx,8)
f01039d6:	f0 67 00 
f01039d9:	6b ff 74             	imul   $0x74,%edi,%edi
f01039dc:	81 c7 2c a0 2c f0    	add    $0xf02ca02c,%edi
f01039e2:	66 89 3c dd 42 43 12 	mov    %di,-0xfedbcbe(,%ebx,8)
f01039e9:	f0 
f01039ea:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f01039ee:	81 c2 2c a0 2c f0    	add    $0xf02ca02c,%edx
f01039f4:	c1 ea 10             	shr    $0x10,%edx
f01039f7:	88 14 dd 44 43 12 f0 	mov    %dl,-0xfedbcbc(,%ebx,8)
f01039fe:	c6 04 dd 46 43 12 f0 	movb   $0x40,-0xfedbcba(,%ebx,8)
f0103a05:	40 
f0103a06:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a09:	05 2c a0 2c f0       	add    $0xf02ca02c,%eax
f0103a0e:	c1 e8 18             	shr    $0x18,%eax
f0103a11:	88 04 dd 47 43 12 f0 	mov    %al,-0xfedbcb9(,%ebx,8)
                                     sizeof(struct Taskstate) - 1, 0);
    gdt[(GD_TSS0 >> 3) + id].sd_s = 0;
f0103a18:	c6 04 dd 45 43 12 f0 	movb   $0x89,-0xfedbcbb(,%ebx,8)
f0103a1f:	89 

    // Load the TSS selector (like other segment selectors, the
    // bottom three bits are special; we leave them 0)
    ltr(GD_TSS0 + (id << 3));
f0103a20:	89 f0                	mov    %esi,%eax
f0103a22:	0f b6 f0             	movzbl %al,%esi
f0103a25:	8d 34 f5 28 00 00 00 	lea    0x28(,%esi,8),%esi
	asm volatile("ltr %0" : : "r" (sel));
f0103a2c:	0f 00 de             	ltr    %si
	asm volatile("lidt (%0)" : : "r" (p));
f0103a2f:	b8 ac 43 12 f0       	mov    $0xf01243ac,%eax
f0103a34:	0f 01 18             	lidtl  (%eax)

    // Load the IDT
    lidt(&idt_pd);
}
f0103a37:	83 c4 1c             	add    $0x1c,%esp
f0103a3a:	5b                   	pop    %ebx
f0103a3b:	5e                   	pop    %esi
f0103a3c:	5f                   	pop    %edi
f0103a3d:	5d                   	pop    %ebp
f0103a3e:	c3                   	ret    

f0103a3f <trap_init>:
{
f0103a3f:	55                   	push   %ebp
f0103a40:	89 e5                	mov    %esp,%ebp
f0103a42:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_DIVIDE], 0, GD_KT, &th_divide, 0);
f0103a45:	b8 4c 44 10 f0       	mov    $0xf010444c,%eax
f0103a4a:	66 a3 60 02 2b f0    	mov    %ax,0xf02b0260
f0103a50:	66 c7 05 62 02 2b f0 	movw   $0x8,0xf02b0262
f0103a57:	08 00 
f0103a59:	c6 05 64 02 2b f0 00 	movb   $0x0,0xf02b0264
f0103a60:	c6 05 65 02 2b f0 8e 	movb   $0x8e,0xf02b0265
f0103a67:	c1 e8 10             	shr    $0x10,%eax
f0103a6a:	66 a3 66 02 2b f0    	mov    %ax,0xf02b0266
    SETGATE(idt[T_DEBUG], 0, GD_KT, &th_debug, 0);
f0103a70:	b8 56 44 10 f0       	mov    $0xf0104456,%eax
f0103a75:	66 a3 68 02 2b f0    	mov    %ax,0xf02b0268
f0103a7b:	66 c7 05 6a 02 2b f0 	movw   $0x8,0xf02b026a
f0103a82:	08 00 
f0103a84:	c6 05 6c 02 2b f0 00 	movb   $0x0,0xf02b026c
f0103a8b:	c6 05 6d 02 2b f0 8e 	movb   $0x8e,0xf02b026d
f0103a92:	c1 e8 10             	shr    $0x10,%eax
f0103a95:	66 a3 6e 02 2b f0    	mov    %ax,0xf02b026e
    SETGATE(idt[T_NMI], 0, GD_KT, &th_nmi, 0);
f0103a9b:	b8 5c 44 10 f0       	mov    $0xf010445c,%eax
f0103aa0:	66 a3 70 02 2b f0    	mov    %ax,0xf02b0270
f0103aa6:	66 c7 05 72 02 2b f0 	movw   $0x8,0xf02b0272
f0103aad:	08 00 
f0103aaf:	c6 05 74 02 2b f0 00 	movb   $0x0,0xf02b0274
f0103ab6:	c6 05 75 02 2b f0 8e 	movb   $0x8e,0xf02b0275
f0103abd:	c1 e8 10             	shr    $0x10,%eax
f0103ac0:	66 a3 76 02 2b f0    	mov    %ax,0xf02b0276
    SETGATE(idt[T_BRKPT], 0, GD_KT, &th_brkpt, 3);
f0103ac6:	b8 62 44 10 f0       	mov    $0xf0104462,%eax
f0103acb:	66 a3 78 02 2b f0    	mov    %ax,0xf02b0278
f0103ad1:	66 c7 05 7a 02 2b f0 	movw   $0x8,0xf02b027a
f0103ad8:	08 00 
f0103ada:	c6 05 7c 02 2b f0 00 	movb   $0x0,0xf02b027c
f0103ae1:	c6 05 7d 02 2b f0 ee 	movb   $0xee,0xf02b027d
f0103ae8:	c1 e8 10             	shr    $0x10,%eax
f0103aeb:	66 a3 7e 02 2b f0    	mov    %ax,0xf02b027e
    SETGATE(idt[T_OFLOW], 0, GD_KT, &th_oflow, 0);
f0103af1:	b8 68 44 10 f0       	mov    $0xf0104468,%eax
f0103af6:	66 a3 80 02 2b f0    	mov    %ax,0xf02b0280
f0103afc:	66 c7 05 82 02 2b f0 	movw   $0x8,0xf02b0282
f0103b03:	08 00 
f0103b05:	c6 05 84 02 2b f0 00 	movb   $0x0,0xf02b0284
f0103b0c:	c6 05 85 02 2b f0 8e 	movb   $0x8e,0xf02b0285
f0103b13:	c1 e8 10             	shr    $0x10,%eax
f0103b16:	66 a3 86 02 2b f0    	mov    %ax,0xf02b0286
    SETGATE(idt[T_BOUND], 0, GD_KT, &th_bound, 0);
f0103b1c:	b8 6e 44 10 f0       	mov    $0xf010446e,%eax
f0103b21:	66 a3 88 02 2b f0    	mov    %ax,0xf02b0288
f0103b27:	66 c7 05 8a 02 2b f0 	movw   $0x8,0xf02b028a
f0103b2e:	08 00 
f0103b30:	c6 05 8c 02 2b f0 00 	movb   $0x0,0xf02b028c
f0103b37:	c6 05 8d 02 2b f0 8e 	movb   $0x8e,0xf02b028d
f0103b3e:	c1 e8 10             	shr    $0x10,%eax
f0103b41:	66 a3 8e 02 2b f0    	mov    %ax,0xf02b028e
    SETGATE(idt[T_ILLOP], 0, GD_KT, &th_illop, 0);
f0103b47:	b8 74 44 10 f0       	mov    $0xf0104474,%eax
f0103b4c:	66 a3 90 02 2b f0    	mov    %ax,0xf02b0290
f0103b52:	66 c7 05 92 02 2b f0 	movw   $0x8,0xf02b0292
f0103b59:	08 00 
f0103b5b:	c6 05 94 02 2b f0 00 	movb   $0x0,0xf02b0294
f0103b62:	c6 05 95 02 2b f0 8e 	movb   $0x8e,0xf02b0295
f0103b69:	c1 e8 10             	shr    $0x10,%eax
f0103b6c:	66 a3 96 02 2b f0    	mov    %ax,0xf02b0296
    SETGATE(idt[T_DEVICE], 0, GD_KT, &th_device, 0);
f0103b72:	b8 7a 44 10 f0       	mov    $0xf010447a,%eax
f0103b77:	66 a3 98 02 2b f0    	mov    %ax,0xf02b0298
f0103b7d:	66 c7 05 9a 02 2b f0 	movw   $0x8,0xf02b029a
f0103b84:	08 00 
f0103b86:	c6 05 9c 02 2b f0 00 	movb   $0x0,0xf02b029c
f0103b8d:	c6 05 9d 02 2b f0 8e 	movb   $0x8e,0xf02b029d
f0103b94:	c1 e8 10             	shr    $0x10,%eax
f0103b97:	66 a3 9e 02 2b f0    	mov    %ax,0xf02b029e
    SETGATE(idt[T_DBLFLT], 0, GD_KT, &th_dblflt, 0);
f0103b9d:	b8 80 44 10 f0       	mov    $0xf0104480,%eax
f0103ba2:	66 a3 a0 02 2b f0    	mov    %ax,0xf02b02a0
f0103ba8:	66 c7 05 a2 02 2b f0 	movw   $0x8,0xf02b02a2
f0103baf:	08 00 
f0103bb1:	c6 05 a4 02 2b f0 00 	movb   $0x0,0xf02b02a4
f0103bb8:	c6 05 a5 02 2b f0 8e 	movb   $0x8e,0xf02b02a5
f0103bbf:	c1 e8 10             	shr    $0x10,%eax
f0103bc2:	66 a3 a6 02 2b f0    	mov    %ax,0xf02b02a6
    SETGATE(idt[T_TSS], 0, GD_KT, &th_tss, 0);
f0103bc8:	b8 84 44 10 f0       	mov    $0xf0104484,%eax
f0103bcd:	66 a3 b0 02 2b f0    	mov    %ax,0xf02b02b0
f0103bd3:	66 c7 05 b2 02 2b f0 	movw   $0x8,0xf02b02b2
f0103bda:	08 00 
f0103bdc:	c6 05 b4 02 2b f0 00 	movb   $0x0,0xf02b02b4
f0103be3:	c6 05 b5 02 2b f0 8e 	movb   $0x8e,0xf02b02b5
f0103bea:	c1 e8 10             	shr    $0x10,%eax
f0103bed:	66 a3 b6 02 2b f0    	mov    %ax,0xf02b02b6
    SETGATE(idt[T_SEGNP], 0, GD_KT, &th_segnp, 0);
f0103bf3:	b8 88 44 10 f0       	mov    $0xf0104488,%eax
f0103bf8:	66 a3 b8 02 2b f0    	mov    %ax,0xf02b02b8
f0103bfe:	66 c7 05 ba 02 2b f0 	movw   $0x8,0xf02b02ba
f0103c05:	08 00 
f0103c07:	c6 05 bc 02 2b f0 00 	movb   $0x0,0xf02b02bc
f0103c0e:	c6 05 bd 02 2b f0 8e 	movb   $0x8e,0xf02b02bd
f0103c15:	c1 e8 10             	shr    $0x10,%eax
f0103c18:	66 a3 be 02 2b f0    	mov    %ax,0xf02b02be
    SETGATE(idt[T_STACK], 0, GD_KT, &th_stack, 0);
f0103c1e:	b8 8c 44 10 f0       	mov    $0xf010448c,%eax
f0103c23:	66 a3 c0 02 2b f0    	mov    %ax,0xf02b02c0
f0103c29:	66 c7 05 c2 02 2b f0 	movw   $0x8,0xf02b02c2
f0103c30:	08 00 
f0103c32:	c6 05 c4 02 2b f0 00 	movb   $0x0,0xf02b02c4
f0103c39:	c6 05 c5 02 2b f0 8e 	movb   $0x8e,0xf02b02c5
f0103c40:	c1 e8 10             	shr    $0x10,%eax
f0103c43:	66 a3 c6 02 2b f0    	mov    %ax,0xf02b02c6
    SETGATE(idt[T_GPFLT], 0, GD_KT, &th_gpflt, 0);
f0103c49:	b8 90 44 10 f0       	mov    $0xf0104490,%eax
f0103c4e:	66 a3 c8 02 2b f0    	mov    %ax,0xf02b02c8
f0103c54:	66 c7 05 ca 02 2b f0 	movw   $0x8,0xf02b02ca
f0103c5b:	08 00 
f0103c5d:	c6 05 cc 02 2b f0 00 	movb   $0x0,0xf02b02cc
f0103c64:	c6 05 cd 02 2b f0 8e 	movb   $0x8e,0xf02b02cd
f0103c6b:	c1 e8 10             	shr    $0x10,%eax
f0103c6e:	66 a3 ce 02 2b f0    	mov    %ax,0xf02b02ce
    SETGATE(idt[T_PGFLT], 0, GD_KT, &th_pgflt, 0);
f0103c74:	b8 94 44 10 f0       	mov    $0xf0104494,%eax
f0103c79:	66 a3 d0 02 2b f0    	mov    %ax,0xf02b02d0
f0103c7f:	66 c7 05 d2 02 2b f0 	movw   $0x8,0xf02b02d2
f0103c86:	08 00 
f0103c88:	c6 05 d4 02 2b f0 00 	movb   $0x0,0xf02b02d4
f0103c8f:	c6 05 d5 02 2b f0 8e 	movb   $0x8e,0xf02b02d5
f0103c96:	c1 e8 10             	shr    $0x10,%eax
f0103c99:	66 a3 d6 02 2b f0    	mov    %ax,0xf02b02d6
    SETGATE(idt[T_FPERR], 0, GD_KT, &th_fperr, 0);
f0103c9f:	b8 98 44 10 f0       	mov    $0xf0104498,%eax
f0103ca4:	66 a3 e0 02 2b f0    	mov    %ax,0xf02b02e0
f0103caa:	66 c7 05 e2 02 2b f0 	movw   $0x8,0xf02b02e2
f0103cb1:	08 00 
f0103cb3:	c6 05 e4 02 2b f0 00 	movb   $0x0,0xf02b02e4
f0103cba:	c6 05 e5 02 2b f0 8e 	movb   $0x8e,0xf02b02e5
f0103cc1:	c1 e8 10             	shr    $0x10,%eax
f0103cc4:	66 a3 e6 02 2b f0    	mov    %ax,0xf02b02e6
    SETGATE(idt[T_ALIGN], 0, GD_KT, &th_align, 0);
f0103cca:	b8 9e 44 10 f0       	mov    $0xf010449e,%eax
f0103ccf:	66 a3 e8 02 2b f0    	mov    %ax,0xf02b02e8
f0103cd5:	66 c7 05 ea 02 2b f0 	movw   $0x8,0xf02b02ea
f0103cdc:	08 00 
f0103cde:	c6 05 ec 02 2b f0 00 	movb   $0x0,0xf02b02ec
f0103ce5:	c6 05 ed 02 2b f0 8e 	movb   $0x8e,0xf02b02ed
f0103cec:	c1 e8 10             	shr    $0x10,%eax
f0103cef:	66 a3 ee 02 2b f0    	mov    %ax,0xf02b02ee
    SETGATE(idt[T_MCHK], 0, GD_KT, &th_mchk, 0);
f0103cf5:	b8 a2 44 10 f0       	mov    $0xf01044a2,%eax
f0103cfa:	66 a3 f0 02 2b f0    	mov    %ax,0xf02b02f0
f0103d00:	66 c7 05 f2 02 2b f0 	movw   $0x8,0xf02b02f2
f0103d07:	08 00 
f0103d09:	c6 05 f4 02 2b f0 00 	movb   $0x0,0xf02b02f4
f0103d10:	c6 05 f5 02 2b f0 8e 	movb   $0x8e,0xf02b02f5
f0103d17:	c1 e8 10             	shr    $0x10,%eax
f0103d1a:	66 a3 f6 02 2b f0    	mov    %ax,0xf02b02f6
    SETGATE(idt[T_SIMDERR], 0, GD_KT, &th_simderr, 0);
f0103d20:	b8 a8 44 10 f0       	mov    $0xf01044a8,%eax
f0103d25:	66 a3 f8 02 2b f0    	mov    %ax,0xf02b02f8
f0103d2b:	66 c7 05 fa 02 2b f0 	movw   $0x8,0xf02b02fa
f0103d32:	08 00 
f0103d34:	c6 05 fc 02 2b f0 00 	movb   $0x0,0xf02b02fc
f0103d3b:	c6 05 fd 02 2b f0 8e 	movb   $0x8e,0xf02b02fd
f0103d42:	c1 e8 10             	shr    $0x10,%eax
f0103d45:	66 a3 fe 02 2b f0    	mov    %ax,0xf02b02fe
    SETGATE(idt[T_SYSCALL], 0, GD_KT, &th_syscall, 3);
f0103d4b:	b8 ae 44 10 f0       	mov    $0xf01044ae,%eax
f0103d50:	66 a3 e0 03 2b f0    	mov    %ax,0xf02b03e0
f0103d56:	66 c7 05 e2 03 2b f0 	movw   $0x8,0xf02b03e2
f0103d5d:	08 00 
f0103d5f:	c6 05 e4 03 2b f0 00 	movb   $0x0,0xf02b03e4
f0103d66:	c6 05 e5 03 2b f0 ee 	movb   $0xee,0xf02b03e5
f0103d6d:	c1 e8 10             	shr    $0x10,%eax
f0103d70:	66 a3 e6 03 2b f0    	mov    %ax,0xf02b03e6
    SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, &th_irq_timer, 0);
f0103d76:	b8 b4 44 10 f0       	mov    $0xf01044b4,%eax
f0103d7b:	66 a3 60 03 2b f0    	mov    %ax,0xf02b0360
f0103d81:	66 c7 05 62 03 2b f0 	movw   $0x8,0xf02b0362
f0103d88:	08 00 
f0103d8a:	c6 05 64 03 2b f0 00 	movb   $0x0,0xf02b0364
f0103d91:	c6 05 65 03 2b f0 8e 	movb   $0x8e,0xf02b0365
f0103d98:	c1 e8 10             	shr    $0x10,%eax
f0103d9b:	66 a3 66 03 2b f0    	mov    %ax,0xf02b0366
    SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, &th_irq_kbd, 0);
f0103da1:	b8 ba 44 10 f0       	mov    $0xf01044ba,%eax
f0103da6:	66 a3 68 03 2b f0    	mov    %ax,0xf02b0368
f0103dac:	66 c7 05 6a 03 2b f0 	movw   $0x8,0xf02b036a
f0103db3:	08 00 
f0103db5:	c6 05 6c 03 2b f0 00 	movb   $0x0,0xf02b036c
f0103dbc:	c6 05 6d 03 2b f0 8e 	movb   $0x8e,0xf02b036d
f0103dc3:	c1 e8 10             	shr    $0x10,%eax
f0103dc6:	66 a3 6e 03 2b f0    	mov    %ax,0xf02b036e
    SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL], 0, GD_KT, &th_irq_serial, 0);
f0103dcc:	b8 c0 44 10 f0       	mov    $0xf01044c0,%eax
f0103dd1:	66 a3 80 03 2b f0    	mov    %ax,0xf02b0380
f0103dd7:	66 c7 05 82 03 2b f0 	movw   $0x8,0xf02b0382
f0103dde:	08 00 
f0103de0:	c6 05 84 03 2b f0 00 	movb   $0x0,0xf02b0384
f0103de7:	c6 05 85 03 2b f0 8e 	movb   $0x8e,0xf02b0385
f0103dee:	c1 e8 10             	shr    $0x10,%eax
f0103df1:	66 a3 86 03 2b f0    	mov    %ax,0xf02b0386
    SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS], 0, GD_KT, &th_irq_spurious, 0);
f0103df7:	b8 c6 44 10 f0       	mov    $0xf01044c6,%eax
f0103dfc:	66 a3 98 03 2b f0    	mov    %ax,0xf02b0398
f0103e02:	66 c7 05 9a 03 2b f0 	movw   $0x8,0xf02b039a
f0103e09:	08 00 
f0103e0b:	c6 05 9c 03 2b f0 00 	movb   $0x0,0xf02b039c
f0103e12:	c6 05 9d 03 2b f0 8e 	movb   $0x8e,0xf02b039d
f0103e19:	c1 e8 10             	shr    $0x10,%eax
f0103e1c:	66 a3 9e 03 2b f0    	mov    %ax,0xf02b039e
    SETGATE(idt[IRQ_OFFSET + IRQ_IDE], 0, GD_KT, &th_irq_ide, 0);
f0103e22:	b8 cc 44 10 f0       	mov    $0xf01044cc,%eax
f0103e27:	66 a3 d0 03 2b f0    	mov    %ax,0xf02b03d0
f0103e2d:	66 c7 05 d2 03 2b f0 	movw   $0x8,0xf02b03d2
f0103e34:	08 00 
f0103e36:	c6 05 d4 03 2b f0 00 	movb   $0x0,0xf02b03d4
f0103e3d:	c6 05 d5 03 2b f0 8e 	movb   $0x8e,0xf02b03d5
f0103e44:	c1 e8 10             	shr    $0x10,%eax
f0103e47:	66 a3 d6 03 2b f0    	mov    %ax,0xf02b03d6
    SETGATE(idt[IRQ_OFFSET + IRQ_ERROR], 0, GD_KT, &th_irq_error, 0);
f0103e4d:	b8 d2 44 10 f0       	mov    $0xf01044d2,%eax
f0103e52:	66 a3 f8 03 2b f0    	mov    %ax,0xf02b03f8
f0103e58:	66 c7 05 fa 03 2b f0 	movw   $0x8,0xf02b03fa
f0103e5f:	08 00 
f0103e61:	c6 05 fc 03 2b f0 00 	movb   $0x0,0xf02b03fc
f0103e68:	c6 05 fd 03 2b f0 8e 	movb   $0x8e,0xf02b03fd
f0103e6f:	c1 e8 10             	shr    $0x10,%eax
f0103e72:	66 a3 fe 03 2b f0    	mov    %ax,0xf02b03fe
	trap_init_percpu();
f0103e78:	e8 e3 fa ff ff       	call   f0103960 <trap_init_percpu>
}
f0103e7d:	c9                   	leave  
f0103e7e:	c3                   	ret    

f0103e7f <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103e7f:	55                   	push   %ebp
f0103e80:	89 e5                	mov    %esp,%ebp
f0103e82:	53                   	push   %ebx
f0103e83:	83 ec 0c             	sub    $0xc,%esp
f0103e86:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103e89:	ff 33                	pushl  (%ebx)
f0103e8b:	68 ca 7e 10 f0       	push   $0xf0107eca
f0103e90:	e8 b7 fa ff ff       	call   f010394c <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103e95:	83 c4 08             	add    $0x8,%esp
f0103e98:	ff 73 04             	pushl  0x4(%ebx)
f0103e9b:	68 d9 7e 10 f0       	push   $0xf0107ed9
f0103ea0:	e8 a7 fa ff ff       	call   f010394c <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103ea5:	83 c4 08             	add    $0x8,%esp
f0103ea8:	ff 73 08             	pushl  0x8(%ebx)
f0103eab:	68 e8 7e 10 f0       	push   $0xf0107ee8
f0103eb0:	e8 97 fa ff ff       	call   f010394c <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103eb5:	83 c4 08             	add    $0x8,%esp
f0103eb8:	ff 73 0c             	pushl  0xc(%ebx)
f0103ebb:	68 f7 7e 10 f0       	push   $0xf0107ef7
f0103ec0:	e8 87 fa ff ff       	call   f010394c <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103ec5:	83 c4 08             	add    $0x8,%esp
f0103ec8:	ff 73 10             	pushl  0x10(%ebx)
f0103ecb:	68 06 7f 10 f0       	push   $0xf0107f06
f0103ed0:	e8 77 fa ff ff       	call   f010394c <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103ed5:	83 c4 08             	add    $0x8,%esp
f0103ed8:	ff 73 14             	pushl  0x14(%ebx)
f0103edb:	68 15 7f 10 f0       	push   $0xf0107f15
f0103ee0:	e8 67 fa ff ff       	call   f010394c <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103ee5:	83 c4 08             	add    $0x8,%esp
f0103ee8:	ff 73 18             	pushl  0x18(%ebx)
f0103eeb:	68 24 7f 10 f0       	push   $0xf0107f24
f0103ef0:	e8 57 fa ff ff       	call   f010394c <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103ef5:	83 c4 08             	add    $0x8,%esp
f0103ef8:	ff 73 1c             	pushl  0x1c(%ebx)
f0103efb:	68 33 7f 10 f0       	push   $0xf0107f33
f0103f00:	e8 47 fa ff ff       	call   f010394c <cprintf>
}
f0103f05:	83 c4 10             	add    $0x10,%esp
f0103f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103f0b:	c9                   	leave  
f0103f0c:	c3                   	ret    

f0103f0d <print_trapframe>:
{
f0103f0d:	55                   	push   %ebp
f0103f0e:	89 e5                	mov    %esp,%ebp
f0103f10:	56                   	push   %esi
f0103f11:	53                   	push   %ebx
f0103f12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103f15:	e8 8d 1f 00 00       	call   f0105ea7 <cpunum>
f0103f1a:	83 ec 04             	sub    $0x4,%esp
f0103f1d:	50                   	push   %eax
f0103f1e:	53                   	push   %ebx
f0103f1f:	68 97 7f 10 f0       	push   $0xf0107f97
f0103f24:	e8 23 fa ff ff       	call   f010394c <cprintf>
	print_regs(&tf->tf_regs);
f0103f29:	89 1c 24             	mov    %ebx,(%esp)
f0103f2c:	e8 4e ff ff ff       	call   f0103e7f <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103f31:	83 c4 08             	add    $0x8,%esp
f0103f34:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103f38:	50                   	push   %eax
f0103f39:	68 b5 7f 10 f0       	push   $0xf0107fb5
f0103f3e:	e8 09 fa ff ff       	call   f010394c <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103f43:	83 c4 08             	add    $0x8,%esp
f0103f46:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103f4a:	50                   	push   %eax
f0103f4b:	68 c8 7f 10 f0       	push   $0xf0107fc8
f0103f50:	e8 f7 f9 ff ff       	call   f010394c <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103f55:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0103f58:	83 c4 10             	add    $0x10,%esp
f0103f5b:	83 f8 13             	cmp    $0x13,%eax
f0103f5e:	76 1f                	jbe    f0103f7f <print_trapframe+0x72>
		return "System call";
f0103f60:	ba 42 7f 10 f0       	mov    $0xf0107f42,%edx
	if (trapno == T_SYSCALL)
f0103f65:	83 f8 30             	cmp    $0x30,%eax
f0103f68:	74 1c                	je     f0103f86 <print_trapframe+0x79>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0103f6a:	8d 50 e0             	lea    -0x20(%eax),%edx
	return "(unknown trap)";
f0103f6d:	83 fa 10             	cmp    $0x10,%edx
f0103f70:	ba 4e 7f 10 f0       	mov    $0xf0107f4e,%edx
f0103f75:	b9 61 7f 10 f0       	mov    $0xf0107f61,%ecx
f0103f7a:	0f 43 d1             	cmovae %ecx,%edx
f0103f7d:	eb 07                	jmp    f0103f86 <print_trapframe+0x79>
		return excnames[trapno];
f0103f7f:	8b 14 85 80 82 10 f0 	mov    -0xfef7d80(,%eax,4),%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103f86:	83 ec 04             	sub    $0x4,%esp
f0103f89:	52                   	push   %edx
f0103f8a:	50                   	push   %eax
f0103f8b:	68 db 7f 10 f0       	push   $0xf0107fdb
f0103f90:	e8 b7 f9 ff ff       	call   f010394c <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103f95:	83 c4 10             	add    $0x10,%esp
f0103f98:	39 1d 60 0a 2b f0    	cmp    %ebx,0xf02b0a60
f0103f9e:	0f 84 a6 00 00 00    	je     f010404a <print_trapframe+0x13d>
	cprintf("  err  0x%08x", tf->tf_err);
f0103fa4:	83 ec 08             	sub    $0x8,%esp
f0103fa7:	ff 73 2c             	pushl  0x2c(%ebx)
f0103faa:	68 fc 7f 10 f0       	push   $0xf0107ffc
f0103faf:	e8 98 f9 ff ff       	call   f010394c <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103fb4:	83 c4 10             	add    $0x10,%esp
f0103fb7:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103fbb:	0f 85 ac 00 00 00    	jne    f010406d <print_trapframe+0x160>
			tf->tf_err & 1 ? "protection" : "not-present");
f0103fc1:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0103fc4:	89 c2                	mov    %eax,%edx
f0103fc6:	83 e2 01             	and    $0x1,%edx
f0103fc9:	b9 70 7f 10 f0       	mov    $0xf0107f70,%ecx
f0103fce:	ba 7b 7f 10 f0       	mov    $0xf0107f7b,%edx
f0103fd3:	0f 44 ca             	cmove  %edx,%ecx
f0103fd6:	89 c2                	mov    %eax,%edx
f0103fd8:	83 e2 02             	and    $0x2,%edx
f0103fdb:	be 87 7f 10 f0       	mov    $0xf0107f87,%esi
f0103fe0:	ba 8d 7f 10 f0       	mov    $0xf0107f8d,%edx
f0103fe5:	0f 45 d6             	cmovne %esi,%edx
f0103fe8:	83 e0 04             	and    $0x4,%eax
f0103feb:	b8 92 7f 10 f0       	mov    $0xf0107f92,%eax
f0103ff0:	be c7 80 10 f0       	mov    $0xf01080c7,%esi
f0103ff5:	0f 44 c6             	cmove  %esi,%eax
f0103ff8:	51                   	push   %ecx
f0103ff9:	52                   	push   %edx
f0103ffa:	50                   	push   %eax
f0103ffb:	68 0a 80 10 f0       	push   $0xf010800a
f0104000:	e8 47 f9 ff ff       	call   f010394c <cprintf>
f0104005:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104008:	83 ec 08             	sub    $0x8,%esp
f010400b:	ff 73 30             	pushl  0x30(%ebx)
f010400e:	68 19 80 10 f0       	push   $0xf0108019
f0104013:	e8 34 f9 ff ff       	call   f010394c <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104018:	83 c4 08             	add    $0x8,%esp
f010401b:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010401f:	50                   	push   %eax
f0104020:	68 28 80 10 f0       	push   $0xf0108028
f0104025:	e8 22 f9 ff ff       	call   f010394c <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f010402a:	83 c4 08             	add    $0x8,%esp
f010402d:	ff 73 38             	pushl  0x38(%ebx)
f0104030:	68 3b 80 10 f0       	push   $0xf010803b
f0104035:	e8 12 f9 ff ff       	call   f010394c <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f010403a:	83 c4 10             	add    $0x10,%esp
f010403d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104041:	75 3c                	jne    f010407f <print_trapframe+0x172>
}
f0104043:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104046:	5b                   	pop    %ebx
f0104047:	5e                   	pop    %esi
f0104048:	5d                   	pop    %ebp
f0104049:	c3                   	ret    
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010404a:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f010404e:	0f 85 50 ff ff ff    	jne    f0103fa4 <print_trapframe+0x97>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104054:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104057:	83 ec 08             	sub    $0x8,%esp
f010405a:	50                   	push   %eax
f010405b:	68 ed 7f 10 f0       	push   $0xf0107fed
f0104060:	e8 e7 f8 ff ff       	call   f010394c <cprintf>
f0104065:	83 c4 10             	add    $0x10,%esp
f0104068:	e9 37 ff ff ff       	jmp    f0103fa4 <print_trapframe+0x97>
		cprintf("\n");
f010406d:	83 ec 0c             	sub    $0xc,%esp
f0104070:	68 29 6f 10 f0       	push   $0xf0106f29
f0104075:	e8 d2 f8 ff ff       	call   f010394c <cprintf>
f010407a:	83 c4 10             	add    $0x10,%esp
f010407d:	eb 89                	jmp    f0104008 <print_trapframe+0xfb>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f010407f:	83 ec 08             	sub    $0x8,%esp
f0104082:	ff 73 3c             	pushl  0x3c(%ebx)
f0104085:	68 4a 80 10 f0       	push   $0xf010804a
f010408a:	e8 bd f8 ff ff       	call   f010394c <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010408f:	83 c4 08             	add    $0x8,%esp
f0104092:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104096:	50                   	push   %eax
f0104097:	68 59 80 10 f0       	push   $0xf0108059
f010409c:	e8 ab f8 ff ff       	call   f010394c <cprintf>
f01040a1:	83 c4 10             	add    $0x10,%esp
}
f01040a4:	eb 9d                	jmp    f0104043 <print_trapframe+0x136>

f01040a6 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f01040a6:	55                   	push   %ebp
f01040a7:	89 e5                	mov    %esp,%ebp
f01040a9:	57                   	push   %edi
f01040aa:	56                   	push   %esi
f01040ab:	53                   	push   %ebx
f01040ac:	83 ec 1c             	sub    $0x1c,%esp
f01040af:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01040b2:	0f 20 d0             	mov    %cr2,%eax
f01040b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
    if ((tf->tf_cs & 0x3) == 0) {
f01040b8:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01040bc:	74 5f                	je     f010411d <page_fault_handler+0x77>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.

	if (curenv->env_pgfault_upcall) {
f01040be:	e8 e4 1d 00 00       	call   f0105ea7 <cpunum>
f01040c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01040c6:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01040cc:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f01040d0:	75 62                	jne    f0104134 <page_fault_handler+0x8e>
	    tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
	    env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01040d2:	8b 73 30             	mov    0x30(%ebx),%esi
		curenv->env_id, fault_va, tf->tf_eip);
f01040d5:	e8 cd 1d 00 00       	call   f0105ea7 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01040da:	56                   	push   %esi
f01040db:	ff 75 e4             	pushl  -0x1c(%ebp)
		curenv->env_id, fault_va, tf->tf_eip);
f01040de:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01040e1:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01040e7:	ff 70 48             	pushl  0x48(%eax)
f01040ea:	68 44 82 10 f0       	push   $0xf0108244
f01040ef:	e8 58 f8 ff ff       	call   f010394c <cprintf>
	print_trapframe(tf);
f01040f4:	89 1c 24             	mov    %ebx,(%esp)
f01040f7:	e8 11 fe ff ff       	call   f0103f0d <print_trapframe>
	env_destroy(curenv);
f01040fc:	e8 a6 1d 00 00       	call   f0105ea7 <cpunum>
f0104101:	83 c4 04             	add    $0x4,%esp
f0104104:	6b c0 74             	imul   $0x74,%eax,%eax
f0104107:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f010410d:	e8 5b f5 ff ff       	call   f010366d <env_destroy>
}
f0104112:	83 c4 10             	add    $0x10,%esp
f0104115:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104118:	5b                   	pop    %ebx
f0104119:	5e                   	pop    %esi
f010411a:	5f                   	pop    %edi
f010411b:	5d                   	pop    %ebp
f010411c:	c3                   	ret    
        panic("page_fault_handler: page fault in kernel mode");
f010411d:	83 ec 04             	sub    $0x4,%esp
f0104120:	68 14 82 10 f0       	push   $0xf0108214
f0104125:	68 85 01 00 00       	push   $0x185
f010412a:	68 6c 80 10 f0       	push   $0xf010806c
f010412f:	e8 0c bf ff ff       	call   f0100040 <_panic>
	    if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
f0104134:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104137:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
	        utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
f010413d:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
	    if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
f0104142:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f0104148:	77 0f                	ja     f0104159 <page_fault_handler+0xb3>
	        *(uint32_t *)(tf->tf_esp - 4) = 0;  // push an empty 32-bit word
f010414a:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
	        utf = (struct UTrapframe *)(tf->tf_esp - 4 - sizeof(struct UTrapframe));
f0104151:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104154:	83 e8 38             	sub    $0x38,%eax
f0104157:	89 c7                	mov    %eax,%edi
	    user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W | PTE_U);
f0104159:	e8 49 1d 00 00       	call   f0105ea7 <cpunum>
f010415e:	6a 06                	push   $0x6
f0104160:	6a 34                	push   $0x34
f0104162:	57                   	push   %edi
f0104163:	6b c0 74             	imul   $0x74,%eax,%eax
f0104166:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f010416c:	e8 a0 ee ff ff       	call   f0103011 <user_mem_assert>
	    utf->utf_esp = tf->tf_esp;
f0104171:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104174:	89 47 30             	mov    %eax,0x30(%edi)
	    utf->utf_eflags = tf->tf_eflags;
f0104177:	8b 43 38             	mov    0x38(%ebx),%eax
f010417a:	89 fa                	mov    %edi,%edx
f010417c:	89 47 2c             	mov    %eax,0x2c(%edi)
	    utf->utf_eip = tf->tf_eip;
f010417f:	8b 43 30             	mov    0x30(%ebx),%eax
f0104182:	89 47 28             	mov    %eax,0x28(%edi)
	    utf->utf_regs = tf->tf_regs;
f0104185:	8d 7f 08             	lea    0x8(%edi),%edi
f0104188:	b9 08 00 00 00       	mov    $0x8,%ecx
f010418d:	89 de                	mov    %ebx,%esi
f010418f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	    utf->utf_err = tf->tf_err;
f0104191:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104194:	89 42 04             	mov    %eax,0x4(%edx)
	    utf->utf_fault_va = fault_va;
f0104197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010419a:	89 02                	mov    %eax,(%edx)
	    tf->tf_esp = (uint32_t)utf;
f010419c:	89 53 3c             	mov    %edx,0x3c(%ebx)
	    tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
f010419f:	e8 03 1d 00 00       	call   f0105ea7 <cpunum>
f01041a4:	6b c0 74             	imul   $0x74,%eax,%eax
f01041a7:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01041ad:	8b 40 64             	mov    0x64(%eax),%eax
f01041b0:	89 43 30             	mov    %eax,0x30(%ebx)
	    env_run(curenv);
f01041b3:	e8 ef 1c 00 00       	call   f0105ea7 <cpunum>
f01041b8:	83 c4 04             	add    $0x4,%esp
f01041bb:	6b c0 74             	imul   $0x74,%eax,%eax
f01041be:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f01041c4:	e8 43 f5 ff ff       	call   f010370c <env_run>

f01041c9 <trap>:
{
f01041c9:	55                   	push   %ebp
f01041ca:	89 e5                	mov    %esp,%ebp
f01041cc:	57                   	push   %edi
f01041cd:	56                   	push   %esi
f01041ce:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f01041d1:	fc                   	cld    
	if (panicstr)
f01041d2:	83 3d 8c 92 2c f0 00 	cmpl   $0x0,0xf02c928c
f01041d9:	74 01                	je     f01041dc <trap+0x13>
		asm volatile("hlt");
f01041db:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01041dc:	e8 c6 1c 00 00       	call   f0105ea7 <cpunum>
f01041e1:	6b d0 74             	imul   $0x74,%eax,%edx
f01041e4:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01041e7:	b8 01 00 00 00       	mov    $0x1,%eax
f01041ec:	f0 87 82 20 a0 2c f0 	lock xchg %eax,-0xfd35fe0(%edx)
f01041f3:	83 f8 02             	cmp    $0x2,%eax
f01041f6:	0f 84 99 00 00 00    	je     f0104295 <trap+0xcc>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01041fc:	9c                   	pushf  
f01041fd:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f01041fe:	f6 c4 02             	test   $0x2,%ah
f0104201:	0f 85 a3 00 00 00    	jne    f01042aa <trap+0xe1>
	if ((tf->tf_cs & 3) == 3) {
f0104207:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010420b:	83 e0 03             	and    $0x3,%eax
f010420e:	66 83 f8 03          	cmp    $0x3,%ax
f0104212:	0f 84 ab 00 00 00    	je     f01042c3 <trap+0xfa>
	last_tf = tf;
f0104218:	89 35 60 0a 2b f0    	mov    %esi,0xf02b0a60
    switch (tf->tf_trapno) {
f010421e:	8b 46 28             	mov    0x28(%esi),%eax
f0104221:	83 f8 0e             	cmp    $0xe,%eax
f0104224:	0f 84 3e 01 00 00    	je     f0104368 <trap+0x19f>
f010422a:	83 f8 30             	cmp    $0x30,%eax
f010422d:	0f 84 7d 01 00 00    	je     f01043b0 <trap+0x1e7>
f0104233:	83 f8 03             	cmp    $0x3,%eax
f0104236:	0f 84 66 01 00 00    	je     f01043a2 <trap+0x1d9>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f010423c:	83 f8 27             	cmp    $0x27,%eax
f010423f:	0f 84 8c 01 00 00    	je     f01043d1 <trap+0x208>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f0104245:	83 f8 20             	cmp    $0x20,%eax
f0104248:	0f 84 9d 01 00 00    	je     f01043eb <trap+0x222>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
f010424e:	83 f8 21             	cmp    $0x21,%eax
f0104251:	0f 84 b4 01 00 00    	je     f010440b <trap+0x242>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
f0104257:	83 f8 24             	cmp    $0x24,%eax
f010425a:	0f 84 b5 01 00 00    	je     f0104415 <trap+0x24c>
	print_trapframe(tf);
f0104260:	83 ec 0c             	sub    $0xc,%esp
f0104263:	56                   	push   %esi
f0104264:	e8 a4 fc ff ff       	call   f0103f0d <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104269:	83 c4 10             	add    $0x10,%esp
f010426c:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104271:	0f 84 a8 01 00 00    	je     f010441f <trap+0x256>
		env_destroy(curenv);
f0104277:	e8 2b 1c 00 00       	call   f0105ea7 <cpunum>
f010427c:	83 ec 0c             	sub    $0xc,%esp
f010427f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104282:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f0104288:	e8 e0 f3 ff ff       	call   f010366d <env_destroy>
f010428d:	83 c4 10             	add    $0x10,%esp
f0104290:	e9 df 00 00 00       	jmp    f0104374 <trap+0x1ab>
	spin_lock(&kernel_lock);
f0104295:	83 ec 0c             	sub    $0xc,%esp
f0104298:	68 c0 43 12 f0       	push   $0xf01243c0
f010429d:	e8 75 1e 00 00       	call   f0106117 <spin_lock>
f01042a2:	83 c4 10             	add    $0x10,%esp
f01042a5:	e9 52 ff ff ff       	jmp    f01041fc <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f01042aa:	68 78 80 10 f0       	push   $0xf0108078
f01042af:	68 ff 7a 10 f0       	push   $0xf0107aff
f01042b4:	68 4f 01 00 00       	push   $0x14f
f01042b9:	68 6c 80 10 f0       	push   $0xf010806c
f01042be:	e8 7d bd ff ff       	call   f0100040 <_panic>
f01042c3:	83 ec 0c             	sub    $0xc,%esp
f01042c6:	68 c0 43 12 f0       	push   $0xf01243c0
f01042cb:	e8 47 1e 00 00       	call   f0106117 <spin_lock>
		assert(curenv);
f01042d0:	e8 d2 1b 00 00       	call   f0105ea7 <cpunum>
f01042d5:	6b c0 74             	imul   $0x74,%eax,%eax
f01042d8:	83 c4 10             	add    $0x10,%esp
f01042db:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f01042e2:	74 3e                	je     f0104322 <trap+0x159>
		if (curenv->env_status == ENV_DYING) {
f01042e4:	e8 be 1b 00 00       	call   f0105ea7 <cpunum>
f01042e9:	6b c0 74             	imul   $0x74,%eax,%eax
f01042ec:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01042f2:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01042f6:	74 43                	je     f010433b <trap+0x172>
		curenv->env_tf = *tf;
f01042f8:	e8 aa 1b 00 00       	call   f0105ea7 <cpunum>
f01042fd:	6b c0 74             	imul   $0x74,%eax,%eax
f0104300:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104306:	b9 11 00 00 00       	mov    $0x11,%ecx
f010430b:	89 c7                	mov    %eax,%edi
f010430d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f010430f:	e8 93 1b 00 00       	call   f0105ea7 <cpunum>
f0104314:	6b c0 74             	imul   $0x74,%eax,%eax
f0104317:	8b b0 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%esi
f010431d:	e9 f6 fe ff ff       	jmp    f0104218 <trap+0x4f>
		assert(curenv);
f0104322:	68 91 80 10 f0       	push   $0xf0108091
f0104327:	68 ff 7a 10 f0       	push   $0xf0107aff
f010432c:	68 57 01 00 00       	push   $0x157
f0104331:	68 6c 80 10 f0       	push   $0xf010806c
f0104336:	e8 05 bd ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f010433b:	e8 67 1b 00 00       	call   f0105ea7 <cpunum>
f0104340:	83 ec 0c             	sub    $0xc,%esp
f0104343:	6b c0 74             	imul   $0x74,%eax,%eax
f0104346:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f010434c:	e8 5f f1 ff ff       	call   f01034b0 <env_free>
			curenv = NULL;
f0104351:	e8 51 1b 00 00       	call   f0105ea7 <cpunum>
f0104356:	6b c0 74             	imul   $0x74,%eax,%eax
f0104359:	c7 80 28 a0 2c f0 00 	movl   $0x0,-0xfd35fd8(%eax)
f0104360:	00 00 00 
			sched_yield();
f0104363:	e8 53 02 00 00       	call   f01045bb <sched_yield>
            page_fault_handler(tf);
f0104368:	83 ec 0c             	sub    $0xc,%esp
f010436b:	56                   	push   %esi
f010436c:	e8 35 fd ff ff       	call   f01040a6 <page_fault_handler>
f0104371:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104374:	e8 2e 1b 00 00       	call   f0105ea7 <cpunum>
f0104379:	6b c0 74             	imul   $0x74,%eax,%eax
f010437c:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f0104383:	74 18                	je     f010439d <trap+0x1d4>
f0104385:	e8 1d 1b 00 00       	call   f0105ea7 <cpunum>
f010438a:	6b c0 74             	imul   $0x74,%eax,%eax
f010438d:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104393:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104397:	0f 84 99 00 00 00    	je     f0104436 <trap+0x26d>
		sched_yield();
f010439d:	e8 19 02 00 00       	call   f01045bb <sched_yield>
            monitor(tf);
f01043a2:	83 ec 0c             	sub    $0xc,%esp
f01043a5:	56                   	push   %esi
f01043a6:	e8 cd c5 ff ff       	call   f0100978 <monitor>
f01043ab:	83 c4 10             	add    $0x10,%esp
f01043ae:	eb c4                	jmp    f0104374 <trap+0x1ab>
            tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,
f01043b0:	83 ec 08             	sub    $0x8,%esp
f01043b3:	ff 76 04             	pushl  0x4(%esi)
f01043b6:	ff 36                	pushl  (%esi)
f01043b8:	ff 76 10             	pushl  0x10(%esi)
f01043bb:	ff 76 18             	pushl  0x18(%esi)
f01043be:	ff 76 14             	pushl  0x14(%esi)
f01043c1:	ff 76 1c             	pushl  0x1c(%esi)
f01043c4:	e8 8b 02 00 00       	call   f0104654 <syscall>
f01043c9:	89 46 1c             	mov    %eax,0x1c(%esi)
f01043cc:	83 c4 20             	add    $0x20,%esp
f01043cf:	eb a3                	jmp    f0104374 <trap+0x1ab>
		cprintf("Spurious interrupt on irq 7\n");
f01043d1:	83 ec 0c             	sub    $0xc,%esp
f01043d4:	68 98 80 10 f0       	push   $0xf0108098
f01043d9:	e8 6e f5 ff ff       	call   f010394c <cprintf>
		print_trapframe(tf);
f01043de:	89 34 24             	mov    %esi,(%esp)
f01043e1:	e8 27 fb ff ff       	call   f0103f0d <print_trapframe>
f01043e6:	83 c4 10             	add    $0x10,%esp
f01043e9:	eb 89                	jmp    f0104374 <trap+0x1ab>
	    lapic_eoi();
f01043eb:	e8 03 1c 00 00       	call   f0105ff3 <lapic_eoi>
	    if (thiscpu->cpu_id == 0) {
f01043f0:	e8 b2 1a 00 00       	call   f0105ea7 <cpunum>
f01043f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01043f8:	80 b8 20 a0 2c f0 00 	cmpb   $0x0,-0xfd35fe0(%eax)
f01043ff:	75 05                	jne    f0104406 <trap+0x23d>
	        time_tick();
f0104401:	e8 16 25 00 00       	call   f010691c <time_tick>
	    sched_yield();
f0104406:	e8 b0 01 00 00       	call   f01045bb <sched_yield>
	    kbd_intr();
f010440b:	e8 04 c2 ff ff       	call   f0100614 <kbd_intr>
f0104410:	e9 5f ff ff ff       	jmp    f0104374 <trap+0x1ab>
	    serial_intr();
f0104415:	e8 dd c1 ff ff       	call   f01005f7 <serial_intr>
f010441a:	e9 55 ff ff ff       	jmp    f0104374 <trap+0x1ab>
		panic("unhandled trap in kernel");
f010441f:	83 ec 04             	sub    $0x4,%esp
f0104422:	68 b5 80 10 f0       	push   $0xf01080b5
f0104427:	68 35 01 00 00       	push   $0x135
f010442c:	68 6c 80 10 f0       	push   $0xf010806c
f0104431:	e8 0a bc ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0104436:	e8 6c 1a 00 00       	call   f0105ea7 <cpunum>
f010443b:	83 ec 0c             	sub    $0xc,%esp
f010443e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104441:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f0104447:	e8 c0 f2 ff ff       	call   f010370c <env_run>

f010444c <th_divide>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(th_divide, T_DIVIDE)
f010444c:	6a 00                	push   $0x0
f010444e:	6a 00                	push   $0x0
f0104450:	e9 83 00 00 00       	jmp    f01044d8 <_alltraps>
f0104455:	90                   	nop

f0104456 <th_debug>:
TRAPHANDLER_NOEC(th_debug, T_DEBUG)
f0104456:	6a 00                	push   $0x0
f0104458:	6a 01                	push   $0x1
f010445a:	eb 7c                	jmp    f01044d8 <_alltraps>

f010445c <th_nmi>:
TRAPHANDLER_NOEC(th_nmi, T_NMI)
f010445c:	6a 00                	push   $0x0
f010445e:	6a 02                	push   $0x2
f0104460:	eb 76                	jmp    f01044d8 <_alltraps>

f0104462 <th_brkpt>:
TRAPHANDLER_NOEC(th_brkpt, T_BRKPT)
f0104462:	6a 00                	push   $0x0
f0104464:	6a 03                	push   $0x3
f0104466:	eb 70                	jmp    f01044d8 <_alltraps>

f0104468 <th_oflow>:
TRAPHANDLER_NOEC(th_oflow, T_OFLOW)
f0104468:	6a 00                	push   $0x0
f010446a:	6a 04                	push   $0x4
f010446c:	eb 6a                	jmp    f01044d8 <_alltraps>

f010446e <th_bound>:
TRAPHANDLER_NOEC(th_bound, T_BOUND)
f010446e:	6a 00                	push   $0x0
f0104470:	6a 05                	push   $0x5
f0104472:	eb 64                	jmp    f01044d8 <_alltraps>

f0104474 <th_illop>:
TRAPHANDLER_NOEC(th_illop, T_ILLOP)
f0104474:	6a 00                	push   $0x0
f0104476:	6a 06                	push   $0x6
f0104478:	eb 5e                	jmp    f01044d8 <_alltraps>

f010447a <th_device>:
TRAPHANDLER_NOEC(th_device, T_DEVICE)
f010447a:	6a 00                	push   $0x0
f010447c:	6a 07                	push   $0x7
f010447e:	eb 58                	jmp    f01044d8 <_alltraps>

f0104480 <th_dblflt>:
TRAPHANDLER(th_dblflt, T_DBLFLT)
f0104480:	6a 08                	push   $0x8
f0104482:	eb 54                	jmp    f01044d8 <_alltraps>

f0104484 <th_tss>:
TRAPHANDLER(th_tss, T_TSS)
f0104484:	6a 0a                	push   $0xa
f0104486:	eb 50                	jmp    f01044d8 <_alltraps>

f0104488 <th_segnp>:
TRAPHANDLER(th_segnp, T_SEGNP)
f0104488:	6a 0b                	push   $0xb
f010448a:	eb 4c                	jmp    f01044d8 <_alltraps>

f010448c <th_stack>:
TRAPHANDLER(th_stack, T_STACK)
f010448c:	6a 0c                	push   $0xc
f010448e:	eb 48                	jmp    f01044d8 <_alltraps>

f0104490 <th_gpflt>:
TRAPHANDLER(th_gpflt, T_GPFLT)
f0104490:	6a 0d                	push   $0xd
f0104492:	eb 44                	jmp    f01044d8 <_alltraps>

f0104494 <th_pgflt>:
TRAPHANDLER(th_pgflt, T_PGFLT)
f0104494:	6a 0e                	push   $0xe
f0104496:	eb 40                	jmp    f01044d8 <_alltraps>

f0104498 <th_fperr>:
TRAPHANDLER_NOEC(th_fperr, T_FPERR)
f0104498:	6a 00                	push   $0x0
f010449a:	6a 10                	push   $0x10
f010449c:	eb 3a                	jmp    f01044d8 <_alltraps>

f010449e <th_align>:
TRAPHANDLER(th_align, T_ALIGN)
f010449e:	6a 11                	push   $0x11
f01044a0:	eb 36                	jmp    f01044d8 <_alltraps>

f01044a2 <th_mchk>:
TRAPHANDLER_NOEC(th_mchk, T_MCHK)
f01044a2:	6a 00                	push   $0x0
f01044a4:	6a 12                	push   $0x12
f01044a6:	eb 30                	jmp    f01044d8 <_alltraps>

f01044a8 <th_simderr>:
TRAPHANDLER_NOEC(th_simderr, T_SIMDERR)
f01044a8:	6a 00                	push   $0x0
f01044aa:	6a 13                	push   $0x13
f01044ac:	eb 2a                	jmp    f01044d8 <_alltraps>

f01044ae <th_syscall>:

TRAPHANDLER_NOEC(th_syscall, T_SYSCALL)
f01044ae:	6a 00                	push   $0x0
f01044b0:	6a 30                	push   $0x30
f01044b2:	eb 24                	jmp    f01044d8 <_alltraps>

f01044b4 <th_irq_timer>:

TRAPHANDLER_NOEC(th_irq_timer, IRQ_OFFSET + IRQ_TIMER)
f01044b4:	6a 00                	push   $0x0
f01044b6:	6a 20                	push   $0x20
f01044b8:	eb 1e                	jmp    f01044d8 <_alltraps>

f01044ba <th_irq_kbd>:
TRAPHANDLER_NOEC(th_irq_kbd, IRQ_OFFSET + IRQ_KBD)
f01044ba:	6a 00                	push   $0x0
f01044bc:	6a 21                	push   $0x21
f01044be:	eb 18                	jmp    f01044d8 <_alltraps>

f01044c0 <th_irq_serial>:
TRAPHANDLER_NOEC(th_irq_serial, IRQ_OFFSET + IRQ_SERIAL)
f01044c0:	6a 00                	push   $0x0
f01044c2:	6a 24                	push   $0x24
f01044c4:	eb 12                	jmp    f01044d8 <_alltraps>

f01044c6 <th_irq_spurious>:
TRAPHANDLER_NOEC(th_irq_spurious, IRQ_OFFSET + IRQ_SPURIOUS)
f01044c6:	6a 00                	push   $0x0
f01044c8:	6a 27                	push   $0x27
f01044ca:	eb 0c                	jmp    f01044d8 <_alltraps>

f01044cc <th_irq_ide>:
TRAPHANDLER_NOEC(th_irq_ide, IRQ_OFFSET + IRQ_IDE)
f01044cc:	6a 00                	push   $0x0
f01044ce:	6a 2e                	push   $0x2e
f01044d0:	eb 06                	jmp    f01044d8 <_alltraps>

f01044d2 <th_irq_error>:
TRAPHANDLER_NOEC(th_irq_error, IRQ_OFFSET + IRQ_ERROR)
f01044d2:	6a 00                	push   $0x0
f01044d4:	6a 33                	push   $0x33
f01044d6:	eb 00                	jmp    f01044d8 <_alltraps>

f01044d8 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
    pushl %ds
f01044d8:	1e                   	push   %ds
    pushl %es
f01044d9:	06                   	push   %es
    pushal
f01044da:	60                   	pusha  
    movw $GD_KD, %ax
f01044db:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds
f01044df:	8e d8                	mov    %eax,%ds
    movw %ax, %es
f01044e1:	8e c0                	mov    %eax,%es
    pushl %esp
f01044e3:	54                   	push   %esp
    call trap
f01044e4:	e8 e0 fc ff ff       	call   f01041c9 <trap>

f01044e9 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01044e9:	55                   	push   %ebp
f01044ea:	89 e5                	mov    %esp,%ebp
f01044ec:	83 ec 08             	sub    $0x8,%esp
f01044ef:	a1 48 02 2b f0       	mov    0xf02b0248,%eax
f01044f4:	83 c0 54             	add    $0x54,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01044f7:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01044fc:	8b 10                	mov    (%eax),%edx
f01044fe:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104501:	83 fa 02             	cmp    $0x2,%edx
f0104504:	76 2d                	jbe    f0104533 <sched_halt+0x4a>
	for (i = 0; i < NENV; i++) {
f0104506:	83 c1 01             	add    $0x1,%ecx
f0104509:	83 c0 7c             	add    $0x7c,%eax
f010450c:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104512:	75 e8                	jne    f01044fc <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104514:	83 ec 0c             	sub    $0xc,%esp
f0104517:	68 d0 82 10 f0       	push   $0xf01082d0
f010451c:	e8 2b f4 ff ff       	call   f010394c <cprintf>
f0104521:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104524:	83 ec 0c             	sub    $0xc,%esp
f0104527:	6a 00                	push   $0x0
f0104529:	e8 4a c4 ff ff       	call   f0100978 <monitor>
f010452e:	83 c4 10             	add    $0x10,%esp
f0104531:	eb f1                	jmp    f0104524 <sched_halt+0x3b>
	if (i == NENV) {
f0104533:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104539:	74 d9                	je     f0104514 <sched_halt+0x2b>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010453b:	e8 67 19 00 00       	call   f0105ea7 <cpunum>
f0104540:	6b c0 74             	imul   $0x74,%eax,%eax
f0104543:	c7 80 28 a0 2c f0 00 	movl   $0x0,-0xfd35fd8(%eax)
f010454a:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f010454d:	a1 98 92 2c f0       	mov    0xf02c9298,%eax
	if ((uint32_t)kva < KERNBASE)
f0104552:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104557:	76 50                	jbe    f01045a9 <sched_halt+0xc0>
	return (physaddr_t)kva - KERNBASE;
f0104559:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010455e:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104561:	e8 41 19 00 00       	call   f0105ea7 <cpunum>
f0104566:	6b d0 74             	imul   $0x74,%eax,%edx
f0104569:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010456c:	b8 02 00 00 00       	mov    $0x2,%eax
f0104571:	f0 87 82 20 a0 2c f0 	lock xchg %eax,-0xfd35fe0(%edx)
	spin_unlock(&kernel_lock);
f0104578:	83 ec 0c             	sub    $0xc,%esp
f010457b:	68 c0 43 12 f0       	push   $0xf01243c0
f0104580:	e8 2f 1c 00 00       	call   f01061b4 <spin_unlock>
	asm volatile("pause");
f0104585:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104587:	e8 1b 19 00 00       	call   f0105ea7 <cpunum>
f010458c:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f010458f:	8b 80 30 a0 2c f0    	mov    -0xfd35fd0(%eax),%eax
f0104595:	bd 00 00 00 00       	mov    $0x0,%ebp
f010459a:	89 c4                	mov    %eax,%esp
f010459c:	6a 00                	push   $0x0
f010459e:	6a 00                	push   $0x0
f01045a0:	fb                   	sti    
f01045a1:	f4                   	hlt    
f01045a2:	eb fd                	jmp    f01045a1 <sched_halt+0xb8>
}
f01045a4:	83 c4 10             	add    $0x10,%esp
f01045a7:	c9                   	leave  
f01045a8:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01045a9:	50                   	push   %eax
f01045aa:	68 e8 6b 10 f0       	push   $0xf0106be8
f01045af:	6a 52                	push   $0x52
f01045b1:	68 f9 82 10 f0       	push   $0xf01082f9
f01045b6:	e8 85 ba ff ff       	call   f0100040 <_panic>

f01045bb <sched_yield>:
{
f01045bb:	55                   	push   %ebp
f01045bc:	89 e5                	mov    %esp,%ebp
f01045be:	57                   	push   %edi
f01045bf:	56                   	push   %esi
f01045c0:	53                   	push   %ebx
f01045c1:	83 ec 0c             	sub    $0xc,%esp
	struct Env *idle = curenv;
f01045c4:	e8 de 18 00 00       	call   f0105ea7 <cpunum>
f01045c9:	6b c0 74             	imul   $0x74,%eax,%eax
f01045cc:	8b 98 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%ebx
    int idle_envid = (idle == NULL) ? -1 : ENVX(idle->env_id);
f01045d2:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01045d7:	85 db                	test   %ebx,%ebx
f01045d9:	74 09                	je     f01045e4 <sched_yield+0x29>
f01045db:	8b 4b 48             	mov    0x48(%ebx),%ecx
f01045de:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
    for (i = idle_envid + 1; i < NENV; i++) {
f01045e4:	8d 71 01             	lea    0x1(%ecx),%esi
        if (envs[i].env_status == ENV_RUNNABLE) {
f01045e7:	a1 48 02 2b f0       	mov    0xf02b0248,%eax
f01045ec:	6b d6 7c             	imul   $0x7c,%esi,%edx
f01045ef:	01 c2                	add    %eax,%edx
    for (i = idle_envid + 1; i < NENV; i++) {
f01045f1:	81 fe ff 03 00 00    	cmp    $0x3ff,%esi
f01045f7:	7f 19                	jg     f0104612 <sched_yield+0x57>
        if (envs[i].env_status == ENV_RUNNABLE) {
f01045f9:	89 d7                	mov    %edx,%edi
f01045fb:	83 c2 7c             	add    $0x7c,%edx
f01045fe:	83 7a d8 02          	cmpl   $0x2,-0x28(%edx)
f0104602:	74 05                	je     f0104609 <sched_yield+0x4e>
    for (i = idle_envid + 1; i < NENV; i++) {
f0104604:	83 c6 01             	add    $0x1,%esi
f0104607:	eb e8                	jmp    f01045f1 <sched_yield+0x36>
            env_run(&envs[i]);
f0104609:	83 ec 0c             	sub    $0xc,%esp
f010460c:	57                   	push   %edi
f010460d:	e8 fa f0 ff ff       	call   f010370c <env_run>
    for (i = 0; i < idle_envid; i++) {;
f0104612:	ba 00 00 00 00       	mov    $0x0,%edx
f0104617:	39 ca                	cmp    %ecx,%edx
f0104619:	7d 19                	jge    f0104634 <sched_yield+0x79>
        if (envs[i].env_status == ENV_RUNNABLE) {
f010461b:	89 c6                	mov    %eax,%esi
f010461d:	83 c0 7c             	add    $0x7c,%eax
f0104620:	83 78 d8 02          	cmpl   $0x2,-0x28(%eax)
f0104624:	74 05                	je     f010462b <sched_yield+0x70>
    for (i = 0; i < idle_envid; i++) {;
f0104626:	83 c2 01             	add    $0x1,%edx
f0104629:	eb ec                	jmp    f0104617 <sched_yield+0x5c>
            env_run(&envs[i]);
f010462b:	83 ec 0c             	sub    $0xc,%esp
f010462e:	56                   	push   %esi
f010462f:	e8 d8 f0 ff ff       	call   f010370c <env_run>
    if(idle != NULL && idle->env_status == ENV_RUNNING) {
f0104634:	85 db                	test   %ebx,%ebx
f0104636:	74 06                	je     f010463e <sched_yield+0x83>
f0104638:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010463c:	74 0d                	je     f010464b <sched_yield+0x90>
    sched_halt();
f010463e:	e8 a6 fe ff ff       	call   f01044e9 <sched_halt>
}
f0104643:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104646:	5b                   	pop    %ebx
f0104647:	5e                   	pop    %esi
f0104648:	5f                   	pop    %edi
f0104649:	5d                   	pop    %ebp
f010464a:	c3                   	ret    
        env_run(idle);
f010464b:	83 ec 0c             	sub    $0xc,%esp
f010464e:	53                   	push   %ebx
f010464f:	e8 b8 f0 ff ff       	call   f010370c <env_run>

f0104654 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104654:	55                   	push   %ebp
f0104655:	89 e5                	mov    %esp,%ebp
f0104657:	57                   	push   %edi
f0104658:	56                   	push   %esi
f0104659:	53                   	push   %ebx
f010465a:	83 ec 2c             	sub    $0x2c,%esp
f010465d:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	switch (syscallno) {
f0104660:	83 f8 0e             	cmp    $0xe,%eax
f0104663:	0f 87 a5 05 00 00    	ja     f0104c0e <syscall+0x5ba>
f0104669:	ff 24 85 0c 83 10 f0 	jmp    *-0xfef7cf4(,%eax,4)
    user_mem_assert(curenv, s, len, PTE_U);
f0104670:	e8 32 18 00 00       	call   f0105ea7 <cpunum>
f0104675:	6a 04                	push   $0x4
f0104677:	ff 75 10             	pushl  0x10(%ebp)
f010467a:	ff 75 0c             	pushl  0xc(%ebp)
f010467d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104680:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f0104686:	e8 86 e9 ff ff       	call   f0103011 <user_mem_assert>
	cprintf("%.*s", len, s);
f010468b:	83 c4 0c             	add    $0xc,%esp
f010468e:	ff 75 0c             	pushl  0xc(%ebp)
f0104691:	ff 75 10             	pushl  0x10(%ebp)
f0104694:	68 06 83 10 f0       	push   $0xf0108306
f0104699:	e8 ae f2 ff ff       	call   f010394c <cprintf>
f010469e:	83 c4 10             	add    $0x10,%esp
    case SYS_cputs:
        sys_cputs((const char *)a1, a2);
        return 0;
f01046a1:	bb 00 00 00 00       	mov    $0x0,%ebx
    case SYS_time_msec:
        return sys_time_msec();
    default:
        return -E_INVAL;
	}
}
f01046a6:	89 d8                	mov    %ebx,%eax
f01046a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01046ab:	5b                   	pop    %ebx
f01046ac:	5e                   	pop    %esi
f01046ad:	5f                   	pop    %edi
f01046ae:	5d                   	pop    %ebp
f01046af:	c3                   	ret    
	return cons_getc();
f01046b0:	e8 71 bf ff ff       	call   f0100626 <cons_getc>
f01046b5:	89 c3                	mov    %eax,%ebx
        return sys_cgetc();
f01046b7:	eb ed                	jmp    f01046a6 <syscall+0x52>
	return curenv->env_id;
f01046b9:	e8 e9 17 00 00       	call   f0105ea7 <cpunum>
f01046be:	6b c0 74             	imul   $0x74,%eax,%eax
f01046c1:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01046c7:	8b 58 48             	mov    0x48(%eax),%ebx
        return sys_getenvid();
f01046ca:	eb da                	jmp    f01046a6 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01046cc:	83 ec 04             	sub    $0x4,%esp
f01046cf:	6a 01                	push   $0x1
f01046d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01046d4:	50                   	push   %eax
f01046d5:	ff 75 0c             	pushl  0xc(%ebp)
f01046d8:	e8 23 ea ff ff       	call   f0103100 <envid2env>
f01046dd:	89 c3                	mov    %eax,%ebx
f01046df:	83 c4 10             	add    $0x10,%esp
f01046e2:	85 c0                	test   %eax,%eax
f01046e4:	78 c0                	js     f01046a6 <syscall+0x52>
	env_destroy(e);
f01046e6:	83 ec 0c             	sub    $0xc,%esp
f01046e9:	ff 75 e4             	pushl  -0x1c(%ebp)
f01046ec:	e8 7c ef ff ff       	call   f010366d <env_destroy>
f01046f1:	83 c4 10             	add    $0x10,%esp
	return 0;
f01046f4:	bb 00 00 00 00       	mov    $0x0,%ebx
        return sys_env_destroy(a1);
f01046f9:	eb ab                	jmp    f01046a6 <syscall+0x52>
	sched_yield();
f01046fb:	e8 bb fe ff ff       	call   f01045bb <sched_yield>
	if ((r = env_alloc(&e, curenv->env_id)) != 0) {
f0104700:	e8 a2 17 00 00       	call   f0105ea7 <cpunum>
f0104705:	83 ec 08             	sub    $0x8,%esp
f0104708:	6b c0 74             	imul   $0x74,%eax,%eax
f010470b:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104711:	ff 70 48             	pushl  0x48(%eax)
f0104714:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104717:	50                   	push   %eax
f0104718:	e8 f5 ea ff ff       	call   f0103212 <env_alloc>
f010471d:	89 c3                	mov    %eax,%ebx
f010471f:	83 c4 10             	add    $0x10,%esp
f0104722:	85 c0                	test   %eax,%eax
f0104724:	75 80                	jne    f01046a6 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f0104726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104729:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f0104730:	e8 72 17 00 00       	call   f0105ea7 <cpunum>
f0104735:	6b c0 74             	imul   $0x74,%eax,%eax
f0104738:	8b b0 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%esi
f010473e:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104746:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;  // return 0 to child
f0104748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010474b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f0104752:	8b 58 48             	mov    0x48(%eax),%ebx
        return sys_exofork();
f0104755:	e9 4c ff ff ff       	jmp    f01046a6 <syscall+0x52>
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) {
f010475a:	8b 45 10             	mov    0x10(%ebp),%eax
f010475d:	83 e8 02             	sub    $0x2,%eax
f0104760:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104765:	75 2c                	jne    f0104793 <syscall+0x13f>
	if ((r = envid2env(envid, &e, 1)) != 0) {
f0104767:	83 ec 04             	sub    $0x4,%esp
f010476a:	6a 01                	push   $0x1
f010476c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010476f:	50                   	push   %eax
f0104770:	ff 75 0c             	pushl  0xc(%ebp)
f0104773:	e8 88 e9 ff ff       	call   f0103100 <envid2env>
f0104778:	89 c3                	mov    %eax,%ebx
f010477a:	83 c4 10             	add    $0x10,%esp
f010477d:	85 c0                	test   %eax,%eax
f010477f:	0f 85 21 ff ff ff    	jne    f01046a6 <syscall+0x52>
	e->env_status = status;
f0104785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104788:	8b 7d 10             	mov    0x10(%ebp),%edi
f010478b:	89 78 54             	mov    %edi,0x54(%eax)
f010478e:	e9 13 ff ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f0104793:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
        return sys_env_set_status(a1, a2);
f0104798:	e9 09 ff ff ff       	jmp    f01046a6 <syscall+0x52>
	if ((uint32_t)va >= UTOP || PGOFF(va) != 0) {
f010479d:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01047a4:	0f 87 90 00 00 00    	ja     f010483a <syscall+0x1e6>
f01047aa:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f01047b1:	0f 85 8d 00 00 00    	jne    f0104844 <syscall+0x1f0>
	if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f01047b7:	8b 45 14             	mov    0x14(%ebp),%eax
f01047ba:	83 e0 05             	and    $0x5,%eax
f01047bd:	83 f8 05             	cmp    $0x5,%eax
f01047c0:	0f 85 88 00 00 00    	jne    f010484e <syscall+0x1fa>
	if ((perm & ~(PTE_SYSCALL)) != 0) {
f01047c6:	f7 45 14 f8 f1 ff ff 	testl  $0xfffff1f8,0x14(%ebp)
f01047cd:	0f 85 85 00 00 00    	jne    f0104858 <syscall+0x204>
	if ((r = envid2env(envid, &e, 1)) != 0) {
f01047d3:	83 ec 04             	sub    $0x4,%esp
f01047d6:	6a 01                	push   $0x1
f01047d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01047db:	50                   	push   %eax
f01047dc:	ff 75 0c             	pushl  0xc(%ebp)
f01047df:	e8 1c e9 ff ff       	call   f0103100 <envid2env>
f01047e4:	89 c3                	mov    %eax,%ebx
f01047e6:	83 c4 10             	add    $0x10,%esp
f01047e9:	85 c0                	test   %eax,%eax
f01047eb:	0f 85 b5 fe ff ff    	jne    f01046a6 <syscall+0x52>
	if((pp = page_alloc(perm)) == NULL) {
f01047f1:	83 ec 0c             	sub    $0xc,%esp
f01047f4:	ff 75 14             	pushl  0x14(%ebp)
f01047f7:	e8 e8 c7 ff ff       	call   f0100fe4 <page_alloc>
f01047fc:	89 c6                	mov    %eax,%esi
f01047fe:	83 c4 10             	add    $0x10,%esp
f0104801:	85 c0                	test   %eax,%eax
f0104803:	74 5d                	je     f0104862 <syscall+0x20e>
	if((r = page_insert(e->env_pgdir, pp, va, perm)) != 0) {
f0104805:	ff 75 14             	pushl  0x14(%ebp)
f0104808:	ff 75 10             	pushl  0x10(%ebp)
f010480b:	50                   	push   %eax
f010480c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010480f:	ff 70 60             	pushl  0x60(%eax)
f0104812:	e8 17 cb ff ff       	call   f010132e <page_insert>
f0104817:	89 c3                	mov    %eax,%ebx
f0104819:	83 c4 10             	add    $0x10,%esp
f010481c:	85 c0                	test   %eax,%eax
f010481e:	0f 84 82 fe ff ff    	je     f01046a6 <syscall+0x52>
	    page_free(pp);
f0104824:	83 ec 0c             	sub    $0xc,%esp
f0104827:	56                   	push   %esi
f0104828:	e8 2f c8 ff ff       	call   f010105c <page_free>
f010482d:	83 c4 10             	add    $0x10,%esp
	    return -E_NO_MEM;
f0104830:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f0104835:	e9 6c fe ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f010483a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010483f:	e9 62 fe ff ff       	jmp    f01046a6 <syscall+0x52>
f0104844:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104849:	e9 58 fe ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f010484e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104853:	e9 4e fe ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f0104858:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010485d:	e9 44 fe ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_NO_MEM;
f0104862:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
        return sys_page_alloc(a1, (void *)a2, a3);
f0104867:	e9 3a fe ff ff       	jmp    f01046a6 <syscall+0x52>
	if ((uint32_t)srcva >= UTOP || PGOFF(srcva) != 0) {
f010486c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104873:	0f 87 c5 00 00 00    	ja     f010493e <syscall+0x2ea>
	if ((uint32_t)dstva >= UTOP || PGOFF(dstva) != 0) {
f0104879:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104880:	0f 85 c2 00 00 00    	jne    f0104948 <syscall+0x2f4>
f0104886:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010488d:	0f 87 b5 00 00 00    	ja     f0104948 <syscall+0x2f4>
f0104893:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f010489a:	0f 85 b2 00 00 00    	jne    f0104952 <syscall+0x2fe>
	if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f01048a0:	8b 45 1c             	mov    0x1c(%ebp),%eax
f01048a3:	83 e0 05             	and    $0x5,%eax
f01048a6:	83 f8 05             	cmp    $0x5,%eax
f01048a9:	0f 85 ad 00 00 00    	jne    f010495c <syscall+0x308>
	if ((perm & ~(PTE_SYSCALL)) != 0) {
f01048af:	f7 45 1c f8 f1 ff ff 	testl  $0xfffff1f8,0x1c(%ebp)
f01048b6:	0f 85 aa 00 00 00    	jne    f0104966 <syscall+0x312>
	if ((r = envid2env(srcenvid, &srcenv, 1)) != 0) {
f01048bc:	83 ec 04             	sub    $0x4,%esp
f01048bf:	6a 01                	push   $0x1
f01048c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01048c4:	50                   	push   %eax
f01048c5:	ff 75 0c             	pushl  0xc(%ebp)
f01048c8:	e8 33 e8 ff ff       	call   f0103100 <envid2env>
f01048cd:	89 c3                	mov    %eax,%ebx
f01048cf:	83 c4 10             	add    $0x10,%esp
f01048d2:	85 c0                	test   %eax,%eax
f01048d4:	0f 85 cc fd ff ff    	jne    f01046a6 <syscall+0x52>
	if ((r = envid2env(dstenvid, &dstenv, 1)) != 0) {
f01048da:	83 ec 04             	sub    $0x4,%esp
f01048dd:	6a 01                	push   $0x1
f01048df:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01048e2:	50                   	push   %eax
f01048e3:	ff 75 14             	pushl  0x14(%ebp)
f01048e6:	e8 15 e8 ff ff       	call   f0103100 <envid2env>
f01048eb:	89 c3                	mov    %eax,%ebx
f01048ed:	83 c4 10             	add    $0x10,%esp
f01048f0:	85 c0                	test   %eax,%eax
f01048f2:	0f 85 ae fd ff ff    	jne    f01046a6 <syscall+0x52>
	if ((pp = page_lookup(srcenv->env_pgdir, srcva, &pte)) == NULL) {
f01048f8:	83 ec 04             	sub    $0x4,%esp
f01048fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01048fe:	50                   	push   %eax
f01048ff:	ff 75 10             	pushl  0x10(%ebp)
f0104902:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104905:	ff 70 60             	pushl  0x60(%eax)
f0104908:	e8 3a c9 ff ff       	call   f0101247 <page_lookup>
f010490d:	83 c4 10             	add    $0x10,%esp
f0104910:	85 c0                	test   %eax,%eax
f0104912:	74 5c                	je     f0104970 <syscall+0x31c>
	if ((*pte & PTE_W) == 0 && (perm & PTE_W) == PTE_W) {
f0104914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104917:	f6 02 02             	testb  $0x2,(%edx)
f010491a:	75 06                	jne    f0104922 <syscall+0x2ce>
f010491c:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104920:	75 58                	jne    f010497a <syscall+0x326>
	if ((r = page_insert(dstenv->env_pgdir, pp, dstva, perm)) != 0) {
f0104922:	ff 75 1c             	pushl  0x1c(%ebp)
f0104925:	ff 75 18             	pushl  0x18(%ebp)
f0104928:	50                   	push   %eax
f0104929:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010492c:	ff 70 60             	pushl  0x60(%eax)
f010492f:	e8 fa c9 ff ff       	call   f010132e <page_insert>
f0104934:	89 c3                	mov    %eax,%ebx
f0104936:	83 c4 10             	add    $0x10,%esp
f0104939:	e9 68 fd ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f010493e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104943:	e9 5e fd ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f0104948:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010494d:	e9 54 fd ff ff       	jmp    f01046a6 <syscall+0x52>
f0104952:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104957:	e9 4a fd ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f010495c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104961:	e9 40 fd ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f0104966:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010496b:	e9 36 fd ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f0104970:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104975:	e9 2c fd ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f010497a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
        return sys_page_map(a1, (void *)a2, a3, (void *)a4, a5);
f010497f:	e9 22 fd ff ff       	jmp    f01046a6 <syscall+0x52>
	if ((uint32_t)va >= UTOP || PGOFF(va) != 0) {
f0104984:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010498b:	77 40                	ja     f01049cd <syscall+0x379>
f010498d:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104994:	75 41                	jne    f01049d7 <syscall+0x383>
	if ((r = envid2env(envid, &e, 1)) != 0) {
f0104996:	83 ec 04             	sub    $0x4,%esp
f0104999:	6a 01                	push   $0x1
f010499b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010499e:	50                   	push   %eax
f010499f:	ff 75 0c             	pushl  0xc(%ebp)
f01049a2:	e8 59 e7 ff ff       	call   f0103100 <envid2env>
f01049a7:	89 c3                	mov    %eax,%ebx
f01049a9:	83 c4 10             	add    $0x10,%esp
f01049ac:	85 c0                	test   %eax,%eax
f01049ae:	0f 85 f2 fc ff ff    	jne    f01046a6 <syscall+0x52>
	page_remove(e->env_pgdir, va);
f01049b4:	83 ec 08             	sub    $0x8,%esp
f01049b7:	ff 75 10             	pushl  0x10(%ebp)
f01049ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01049bd:	ff 70 60             	pushl  0x60(%eax)
f01049c0:	e8 1d c9 ff ff       	call   f01012e2 <page_remove>
f01049c5:	83 c4 10             	add    $0x10,%esp
f01049c8:	e9 d9 fc ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f01049cd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049d2:	e9 cf fc ff ff       	jmp    f01046a6 <syscall+0x52>
f01049d7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
        return sys_page_unmap(a1, (void *)a2);
f01049dc:	e9 c5 fc ff ff       	jmp    f01046a6 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) != 0) {
f01049e1:	83 ec 04             	sub    $0x4,%esp
f01049e4:	6a 01                	push   $0x1
f01049e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01049e9:	50                   	push   %eax
f01049ea:	ff 75 0c             	pushl  0xc(%ebp)
f01049ed:	e8 0e e7 ff ff       	call   f0103100 <envid2env>
f01049f2:	89 c3                	mov    %eax,%ebx
f01049f4:	83 c4 10             	add    $0x10,%esp
f01049f7:	85 c0                	test   %eax,%eax
f01049f9:	0f 85 a7 fc ff ff    	jne    f01046a6 <syscall+0x52>
	e->env_pgfault_upcall = func;
f01049ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a02:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104a05:	89 78 64             	mov    %edi,0x64(%eax)
        return sys_env_set_pgfault_upcall(a1, (void *)a2);
f0104a08:	e9 99 fc ff ff       	jmp    f01046a6 <syscall+0x52>
	if ((uint32_t)dstva < UTOP && PGOFF(dstva) != 0) {
f0104a0d:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104a14:	77 0d                	ja     f0104a23 <syscall+0x3cf>
f0104a16:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104a1d:	0f 85 f5 01 00 00    	jne    f0104c18 <syscall+0x5c4>
	curenv->env_ipc_recving = 1;
f0104a23:	e8 7f 14 00 00       	call   f0105ea7 <cpunum>
f0104a28:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a2b:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104a31:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0104a35:	e8 6d 14 00 00       	call   f0105ea7 <cpunum>
f0104a3a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a3d:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104a43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104a46:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104a49:	e8 59 14 00 00       	call   f0105ea7 <cpunum>
f0104a4e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a51:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104a57:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	return 0;
f0104a5e:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104a63:	e9 3e fc ff ff       	jmp    f01046a6 <syscall+0x52>
	if ((r = envid2env(envid, &e, 0)) != 0) {
f0104a68:	83 ec 04             	sub    $0x4,%esp
f0104a6b:	6a 00                	push   $0x0
f0104a6d:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104a70:	50                   	push   %eax
f0104a71:	ff 75 0c             	pushl  0xc(%ebp)
f0104a74:	e8 87 e6 ff ff       	call   f0103100 <envid2env>
f0104a79:	89 c3                	mov    %eax,%ebx
f0104a7b:	83 c4 10             	add    $0x10,%esp
f0104a7e:	85 c0                	test   %eax,%eax
f0104a80:	0f 85 20 fc ff ff    	jne    f01046a6 <syscall+0x52>
	if (e->env_ipc_recving == 0) {
f0104a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a89:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104a8d:	0f 84 ce 00 00 00    	je     f0104b61 <syscall+0x50d>
	if ((uint32_t)srcva < UTOP) {
f0104a93:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104a9a:	0f 87 8a 00 00 00    	ja     f0104b2a <syscall+0x4d6>
	    if (PGOFF(srcva) != 0) {
f0104aa0:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104aa7:	0f 85 be 00 00 00    	jne    f0104b6b <syscall+0x517>
	    if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f0104aad:	8b 45 18             	mov    0x18(%ebp),%eax
f0104ab0:	83 e0 05             	and    $0x5,%eax
f0104ab3:	83 f8 05             	cmp    $0x5,%eax
f0104ab6:	0f 85 b9 00 00 00    	jne    f0104b75 <syscall+0x521>
	    if ((perm & ~(PTE_SYSCALL)) != 0) {
f0104abc:	f7 45 18 f8 f1 ff ff 	testl  $0xfffff1f8,0x18(%ebp)
f0104ac3:	0f 85 b6 00 00 00    	jne    f0104b7f <syscall+0x52b>
	    if ((pp = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL) {
f0104ac9:	e8 d9 13 00 00       	call   f0105ea7 <cpunum>
f0104ace:	83 ec 04             	sub    $0x4,%esp
f0104ad1:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104ad4:	52                   	push   %edx
f0104ad5:	ff 75 14             	pushl  0x14(%ebp)
f0104ad8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104adb:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104ae1:	ff 70 60             	pushl  0x60(%eax)
f0104ae4:	e8 5e c7 ff ff       	call   f0101247 <page_lookup>
f0104ae9:	83 c4 10             	add    $0x10,%esp
f0104aec:	85 c0                	test   %eax,%eax
f0104aee:	0f 84 95 00 00 00    	je     f0104b89 <syscall+0x535>
	    if ((*pte & PTE_W) == 0 && (perm & PTE_W) == PTE_W) {
f0104af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104af7:	f6 02 02             	testb  $0x2,(%edx)
f0104afa:	75 0a                	jne    f0104b06 <syscall+0x4b2>
f0104afc:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104b00:	0f 85 8d 00 00 00    	jne    f0104b93 <syscall+0x53f>
	    if ((r = page_insert(e->env_pgdir, pp, e->env_ipc_dstva, perm)) != 0) {
f0104b06:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104b09:	ff 75 18             	pushl  0x18(%ebp)
f0104b0c:	ff 72 6c             	pushl  0x6c(%edx)
f0104b0f:	50                   	push   %eax
f0104b10:	ff 72 60             	pushl  0x60(%edx)
f0104b13:	e8 16 c8 ff ff       	call   f010132e <page_insert>
f0104b18:	83 c4 10             	add    $0x10,%esp
f0104b1b:	85 c0                	test   %eax,%eax
f0104b1d:	75 7e                	jne    f0104b9d <syscall+0x549>
	    e->env_ipc_perm = perm;
f0104b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b22:	8b 55 18             	mov    0x18(%ebp),%edx
f0104b25:	89 50 78             	mov    %edx,0x78(%eax)
f0104b28:	eb 07                	jmp    f0104b31 <syscall+0x4dd>
	    e->env_ipc_perm = 0;
f0104b2a:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	e->env_ipc_recving = 0;
f0104b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b34:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	e->env_ipc_from = curenv->env_id;
f0104b38:	e8 6a 13 00 00       	call   f0105ea7 <cpunum>
f0104b3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104b40:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b43:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104b49:	8b 40 48             	mov    0x48(%eax),%eax
f0104b4c:	89 42 74             	mov    %eax,0x74(%edx)
	e->env_ipc_value = value;
f0104b4f:	8b 45 10             	mov    0x10(%ebp),%eax
f0104b52:	89 42 70             	mov    %eax,0x70(%edx)
	e->env_status = ENV_RUNNABLE;
f0104b55:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
f0104b5c:	e9 45 fb ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_IPC_NOT_RECV;
f0104b61:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104b66:	e9 3b fb ff ff       	jmp    f01046a6 <syscall+0x52>
	        return -E_INVAL;
f0104b6b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b70:	e9 31 fb ff ff       	jmp    f01046a6 <syscall+0x52>
	        return -E_INVAL;
f0104b75:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b7a:	e9 27 fb ff ff       	jmp    f01046a6 <syscall+0x52>
	        return -E_INVAL;
f0104b7f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b84:	e9 1d fb ff ff       	jmp    f01046a6 <syscall+0x52>
	        return -E_INVAL;
f0104b89:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b8e:	e9 13 fb ff ff       	jmp    f01046a6 <syscall+0x52>
	        return -E_INVAL;
f0104b93:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b98:	e9 09 fb ff ff       	jmp    f01046a6 <syscall+0x52>
	        return r;
f0104b9d:	89 c3                	mov    %eax,%ebx
        return sys_ipc_try_send(a1, a2, (void *)a3, a4);
f0104b9f:	e9 02 fb ff ff       	jmp    f01046a6 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) != 0) {
f0104ba4:	83 ec 04             	sub    $0x4,%esp
f0104ba7:	6a 01                	push   $0x1
f0104ba9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104bac:	50                   	push   %eax
f0104bad:	ff 75 0c             	pushl  0xc(%ebp)
f0104bb0:	e8 4b e5 ff ff       	call   f0103100 <envid2env>
f0104bb5:	89 c3                	mov    %eax,%ebx
f0104bb7:	83 c4 10             	add    $0x10,%esp
f0104bba:	85 c0                	test   %eax,%eax
f0104bbc:	0f 85 e4 fa ff ff    	jne    f01046a6 <syscall+0x52>
	user_mem_assert(e, tf, sizeof(struct Trapframe), PTE_W);
f0104bc2:	6a 02                	push   $0x2
f0104bc4:	6a 44                	push   $0x44
f0104bc6:	ff 75 10             	pushl  0x10(%ebp)
f0104bc9:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104bcc:	e8 40 e4 ff ff       	call   f0103011 <user_mem_assert>
	tf->tf_cs |= 3;
f0104bd1:	8b 45 10             	mov    0x10(%ebp),%eax
f0104bd4:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	tf->tf_ss |= 3;
f0104bd9:	66 83 48 40 03       	orw    $0x3,0x40(%eax)
	tf->tf_eflags &= ~FL_IOPL_3;
f0104bde:	8b 40 38             	mov    0x38(%eax),%eax
f0104be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104be4:	80 e4 cf             	and    $0xcf,%ah
f0104be7:	80 cc 02             	or     $0x2,%ah
f0104bea:	8b 75 10             	mov    0x10(%ebp),%esi
f0104bed:	89 46 38             	mov    %eax,0x38(%esi)
	e->env_tf = *tf;
f0104bf0:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104bf5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104bf8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0104bfa:	83 c4 10             	add    $0x10,%esp
        return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f0104bfd:	e9 a4 fa ff ff       	jmp    f01046a6 <syscall+0x52>
    return time_msec();
f0104c02:	e8 44 1d 00 00       	call   f010694b <time_msec>
f0104c07:	89 c3                	mov    %eax,%ebx
        return sys_time_msec();
f0104c09:	e9 98 fa ff ff       	jmp    f01046a6 <syscall+0x52>
        return -E_INVAL;
f0104c0e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c13:	e9 8e fa ff ff       	jmp    f01046a6 <syscall+0x52>
	    return -E_INVAL;
f0104c18:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c1d:	e9 84 fa ff ff       	jmp    f01046a6 <syscall+0x52>

f0104c22 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104c22:	55                   	push   %ebp
f0104c23:	89 e5                	mov    %esp,%ebp
f0104c25:	57                   	push   %edi
f0104c26:	56                   	push   %esi
f0104c27:	53                   	push   %ebx
f0104c28:	83 ec 14             	sub    $0x14,%esp
f0104c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104c2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104c31:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104c34:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104c37:	8b 32                	mov    (%edx),%esi
f0104c39:	8b 01                	mov    (%ecx),%eax
f0104c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104c3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104c45:	eb 2f                	jmp    f0104c76 <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0104c47:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0104c4a:	39 c6                	cmp    %eax,%esi
f0104c4c:	7f 49                	jg     f0104c97 <stab_binsearch+0x75>
f0104c4e:	0f b6 0a             	movzbl (%edx),%ecx
f0104c51:	83 ea 0c             	sub    $0xc,%edx
f0104c54:	39 f9                	cmp    %edi,%ecx
f0104c56:	75 ef                	jne    f0104c47 <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104c58:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104c5b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104c5e:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104c62:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104c65:	73 35                	jae    f0104c9c <stab_binsearch+0x7a>
			*region_left = m;
f0104c67:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104c6a:	89 06                	mov    %eax,(%esi)
			l = true_m + 1;
f0104c6c:	8d 73 01             	lea    0x1(%ebx),%esi
		any_matches = 1;
f0104c6f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104c76:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104c79:	7f 4e                	jg     f0104cc9 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0104c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104c7e:	01 f0                	add    %esi,%eax
f0104c80:	89 c3                	mov    %eax,%ebx
f0104c82:	c1 eb 1f             	shr    $0x1f,%ebx
f0104c85:	01 c3                	add    %eax,%ebx
f0104c87:	d1 fb                	sar    %ebx
f0104c89:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104c8c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104c8f:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104c93:	89 d8                	mov    %ebx,%eax
		while (m >= l && stabs[m].n_type != type)
f0104c95:	eb b3                	jmp    f0104c4a <stab_binsearch+0x28>
			l = true_m + 1;
f0104c97:	8d 73 01             	lea    0x1(%ebx),%esi
			continue;
f0104c9a:	eb da                	jmp    f0104c76 <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f0104c9c:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104c9f:	76 14                	jbe    f0104cb5 <stab_binsearch+0x93>
			*region_right = m - 1;
f0104ca1:	83 e8 01             	sub    $0x1,%eax
f0104ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104ca7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104caa:	89 03                	mov    %eax,(%ebx)
		any_matches = 1;
f0104cac:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cb3:	eb c1                	jmp    f0104c76 <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104cb5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104cb8:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f0104cba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104cbe:	89 c6                	mov    %eax,%esi
		any_matches = 1;
f0104cc0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cc7:	eb ad                	jmp    f0104c76 <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f0104cc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104ccd:	74 16                	je     f0104ce5 <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0104ccf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104cd2:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104cd4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104cd7:	8b 0e                	mov    (%esi),%ecx
f0104cd9:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104cdc:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104cdf:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
		for (l = *region_right;
f0104ce3:	eb 12                	jmp    f0104cf7 <stab_binsearch+0xd5>
		*region_right = *region_left - 1;
f0104ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ce8:	8b 00                	mov    (%eax),%eax
f0104cea:	83 e8 01             	sub    $0x1,%eax
f0104ced:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104cf0:	89 07                	mov    %eax,(%edi)
f0104cf2:	eb 16                	jmp    f0104d0a <stab_binsearch+0xe8>
		     l--)
f0104cf4:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104cf7:	39 c1                	cmp    %eax,%ecx
f0104cf9:	7d 0a                	jge    f0104d05 <stab_binsearch+0xe3>
		     l > *region_left && stabs[l].n_type != type;
f0104cfb:	0f b6 1a             	movzbl (%edx),%ebx
f0104cfe:	83 ea 0c             	sub    $0xc,%edx
f0104d01:	39 fb                	cmp    %edi,%ebx
f0104d03:	75 ef                	jne    f0104cf4 <stab_binsearch+0xd2>
			/* do nothing */;
		*region_left = l;
f0104d05:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d08:	89 07                	mov    %eax,(%edi)
	}
}
f0104d0a:	83 c4 14             	add    $0x14,%esp
f0104d0d:	5b                   	pop    %ebx
f0104d0e:	5e                   	pop    %esi
f0104d0f:	5f                   	pop    %edi
f0104d10:	5d                   	pop    %ebp
f0104d11:	c3                   	ret    

f0104d12 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104d12:	55                   	push   %ebp
f0104d13:	89 e5                	mov    %esp,%ebp
f0104d15:	57                   	push   %edi
f0104d16:	56                   	push   %esi
f0104d17:	53                   	push   %ebx
f0104d18:	83 ec 3c             	sub    $0x3c,%esp
f0104d1b:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104d1e:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104d21:	c7 06 48 83 10 f0    	movl   $0xf0108348,(%esi)
	info->eip_line = 0;
f0104d27:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f0104d2e:	c7 46 08 48 83 10 f0 	movl   $0xf0108348,0x8(%esi)
	info->eip_fn_namelen = 9;
f0104d35:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0104d3c:	89 7e 10             	mov    %edi,0x10(%esi)
	info->eip_fn_narg = 0;
f0104d3f:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104d46:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104d4c:	0f 86 1e 01 00 00    	jbe    f0104e70 <debuginfo_eip+0x15e>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104d52:	c7 45 d0 2b 95 11 f0 	movl   $0xf011952b,-0x30(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104d59:	c7 45 cc 9d 53 11 f0 	movl   $0xf011539d,-0x34(%ebp)
		stab_end = __STAB_END__;
f0104d60:	bb 9c 53 11 f0       	mov    $0xf011539c,%ebx
		stabs = __STAB_BEGIN__;
f0104d65:	c7 45 d4 68 8b 10 f0 	movl   $0xf0108b68,-0x2c(%ebp)
            return -1;
        }
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104d6c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104d6f:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
f0104d72:	0f 83 32 02 00 00    	jae    f0104faa <debuginfo_eip+0x298>
f0104d78:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104d7c:	0f 85 2f 02 00 00    	jne    f0104fb1 <debuginfo_eip+0x29f>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104d82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104d89:	2b 5d d4             	sub    -0x2c(%ebp),%ebx
f0104d8c:	c1 fb 02             	sar    $0x2,%ebx
f0104d8f:	69 c3 ab aa aa aa    	imul   $0xaaaaaaab,%ebx,%eax
f0104d95:	83 e8 01             	sub    $0x1,%eax
f0104d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104d9b:	83 ec 08             	sub    $0x8,%esp
f0104d9e:	57                   	push   %edi
f0104d9f:	6a 64                	push   $0x64
f0104da1:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104da4:	89 d1                	mov    %edx,%ecx
f0104da6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104da9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0104dac:	89 d8                	mov    %ebx,%eax
f0104dae:	e8 6f fe ff ff       	call   f0104c22 <stab_binsearch>
	if (lfile == 0)
f0104db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104db6:	83 c4 10             	add    $0x10,%esp
f0104db9:	85 c0                	test   %eax,%eax
f0104dbb:	0f 84 f7 01 00 00    	je     f0104fb8 <debuginfo_eip+0x2a6>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104dc1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104dc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104dca:	83 ec 08             	sub    $0x8,%esp
f0104dcd:	57                   	push   %edi
f0104dce:	6a 24                	push   $0x24
f0104dd0:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104dd3:	89 d1                	mov    %edx,%ecx
f0104dd5:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104dd8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0104ddb:	89 d8                	mov    %ebx,%eax
f0104ddd:	e8 40 fe ff ff       	call   f0104c22 <stab_binsearch>

	if (lfun <= rfun) {
f0104de2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0104de5:	83 c4 10             	add    $0x10,%esp
f0104de8:	3b 5d d8             	cmp    -0x28(%ebp),%ebx
f0104deb:	0f 8f 2c 01 00 00    	jg     f0104f1d <debuginfo_eip+0x20b>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104df1:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104df4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104df7:	8d 14 81             	lea    (%ecx,%eax,4),%edx
f0104dfa:	8b 02                	mov    (%edx),%eax
f0104dfc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104dff:	2b 4d cc             	sub    -0x34(%ebp),%ecx
f0104e02:	39 c8                	cmp    %ecx,%eax
f0104e04:	73 06                	jae    f0104e0c <debuginfo_eip+0xfa>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104e06:	03 45 cc             	add    -0x34(%ebp),%eax
f0104e09:	89 46 08             	mov    %eax,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104e0c:	8b 42 08             	mov    0x8(%edx),%eax
f0104e0f:	89 46 10             	mov    %eax,0x10(%esi)
		addr -= info->eip_fn_addr;
f0104e12:	29 c7                	sub    %eax,%edi
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104e14:	83 ec 08             	sub    $0x8,%esp
f0104e17:	6a 3a                	push   $0x3a
f0104e19:	ff 76 08             	pushl  0x8(%esi)
f0104e1c:	e8 47 0a 00 00       	call   f0105868 <strfind>
f0104e21:	2b 46 08             	sub    0x8(%esi),%eax
f0104e24:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lfun, &rfun, N_SLINE, addr - info->eip_fn_addr);
f0104e27:	83 c4 08             	add    $0x8,%esp
f0104e2a:	2b 7e 10             	sub    0x10(%esi),%edi
f0104e2d:	57                   	push   %edi
f0104e2e:	6a 44                	push   $0x44
f0104e30:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0104e33:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104e36:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104e39:	89 f8                	mov    %edi,%eax
f0104e3b:	e8 e2 fd ff ff       	call   f0104c22 <stab_binsearch>
    	if (lfun <= rfun)
f0104e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104e43:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0104e46:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0104e49:	83 c4 10             	add    $0x10,%esp
f0104e4c:	39 c8                	cmp    %ecx,%eax
f0104e4e:	7f 0b                	jg     f0104e5b <debuginfo_eip+0x149>
    	{
        	info->eip_line = stabs[lfun].n_desc;
f0104e50:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104e53:	0f b7 44 87 06       	movzwl 0x6(%edi,%eax,4),%eax
f0104e58:	89 46 04             	mov    %eax,0x4(%esi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104e5b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e5e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104e61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104e64:	8d 44 82 04          	lea    0x4(%edx,%eax,4),%eax
f0104e68:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0104e6b:	e9 be 00 00 00       	jmp    f0104f2e <debuginfo_eip+0x21c>
        if (user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U) < 0) {
f0104e70:	e8 32 10 00 00       	call   f0105ea7 <cpunum>
f0104e75:	6a 04                	push   $0x4
f0104e77:	6a 10                	push   $0x10
f0104e79:	68 00 00 20 00       	push   $0x200000
f0104e7e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e81:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f0104e87:	e8 04 e1 ff ff       	call   f0102f90 <user_mem_check>
f0104e8c:	83 c4 10             	add    $0x10,%esp
f0104e8f:	85 c0                	test   %eax,%eax
f0104e91:	0f 88 05 01 00 00    	js     f0104f9c <debuginfo_eip+0x28a>
		stabs = usd->stabs;
f0104e97:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0104e9d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		stab_end = usd->stab_end;
f0104ea0:	8b 1d 04 00 20 00    	mov    0x200004,%ebx
		stabstr = usd->stabstr;
f0104ea6:	a1 08 00 20 00       	mov    0x200008,%eax
f0104eab:	89 45 cc             	mov    %eax,-0x34(%ebp)
		stabstr_end = usd->stabstr_end;
f0104eae:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0104eb4:	89 55 d0             	mov    %edx,-0x30(%ebp)
        if (user_mem_check(curenv, stabs, stab_end - stabs, PTE_U) < 0) {
f0104eb7:	e8 eb 0f 00 00       	call   f0105ea7 <cpunum>
f0104ebc:	6a 04                	push   $0x4
f0104ebe:	89 da                	mov    %ebx,%edx
f0104ec0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104ec3:	29 ca                	sub    %ecx,%edx
f0104ec5:	c1 fa 02             	sar    $0x2,%edx
f0104ec8:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0104ece:	52                   	push   %edx
f0104ecf:	51                   	push   %ecx
f0104ed0:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ed3:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f0104ed9:	e8 b2 e0 ff ff       	call   f0102f90 <user_mem_check>
f0104ede:	83 c4 10             	add    $0x10,%esp
f0104ee1:	85 c0                	test   %eax,%eax
f0104ee3:	0f 88 ba 00 00 00    	js     f0104fa3 <debuginfo_eip+0x291>
        if (user_mem_check(curenv, stabstr, stabstr_end - stabstr, PTE_U) < 0) {
f0104ee9:	e8 b9 0f 00 00       	call   f0105ea7 <cpunum>
f0104eee:	6a 04                	push   $0x4
f0104ef0:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0104ef3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0104ef6:	29 ca                	sub    %ecx,%edx
f0104ef8:	52                   	push   %edx
f0104ef9:	51                   	push   %ecx
f0104efa:	6b c0 74             	imul   $0x74,%eax,%eax
f0104efd:	ff b0 28 a0 2c f0    	pushl  -0xfd35fd8(%eax)
f0104f03:	e8 88 e0 ff ff       	call   f0102f90 <user_mem_check>
f0104f08:	83 c4 10             	add    $0x10,%esp
f0104f0b:	85 c0                	test   %eax,%eax
f0104f0d:	0f 89 59 fe ff ff    	jns    f0104d6c <debuginfo_eip+0x5a>
            return -1;
f0104f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f18:	e9 a7 00 00 00       	jmp    f0104fc4 <debuginfo_eip+0x2b2>
		info->eip_fn_addr = addr;
f0104f1d:	89 7e 10             	mov    %edi,0x10(%esi)
		lline = lfile;
f0104f20:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104f23:	e9 ec fe ff ff       	jmp    f0104e14 <debuginfo_eip+0x102>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0104f28:	83 eb 01             	sub    $0x1,%ebx
f0104f2b:	83 e8 0c             	sub    $0xc,%eax
	while (lline >= lfile
f0104f2e:	39 df                	cmp    %ebx,%edi
f0104f30:	7f 31                	jg     f0104f63 <debuginfo_eip+0x251>
	       && stabs[lline].n_type != N_SOL
f0104f32:	0f b6 10             	movzbl (%eax),%edx
f0104f35:	80 fa 84             	cmp    $0x84,%dl
f0104f38:	74 0b                	je     f0104f45 <debuginfo_eip+0x233>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104f3a:	80 fa 64             	cmp    $0x64,%dl
f0104f3d:	75 e9                	jne    f0104f28 <debuginfo_eip+0x216>
f0104f3f:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0104f43:	74 e3                	je     f0104f28 <debuginfo_eip+0x216>
f0104f45:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104f48:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104f4b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104f4e:	8b 04 87             	mov    (%edi,%eax,4),%eax
f0104f51:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0104f54:	8b 7d cc             	mov    -0x34(%ebp),%edi
f0104f57:	29 fa                	sub    %edi,%edx
f0104f59:	39 d0                	cmp    %edx,%eax
f0104f5b:	73 09                	jae    f0104f66 <debuginfo_eip+0x254>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104f5d:	01 f8                	add    %edi,%eax
f0104f5f:	89 06                	mov    %eax,(%esi)
f0104f61:	eb 03                	jmp    f0104f66 <debuginfo_eip+0x254>
f0104f63:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104f66:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0104f6b:	8b 7d c8             	mov    -0x38(%ebp),%edi
f0104f6e:	39 cf                	cmp    %ecx,%edi
f0104f70:	7d 52                	jge    f0104fc4 <debuginfo_eip+0x2b2>
		for (lline = lfun + 1;
f0104f72:	8d 57 01             	lea    0x1(%edi),%edx
f0104f75:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0104f78:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104f7b:	8d 44 87 10          	lea    0x10(%edi,%eax,4),%eax
f0104f7f:	eb 07                	jmp    f0104f88 <debuginfo_eip+0x276>
			info->eip_fn_narg++;
f0104f81:	83 46 14 01          	addl   $0x1,0x14(%esi)
		     lline++)
f0104f85:	83 c2 01             	add    $0x1,%edx
		for (lline = lfun + 1;
f0104f88:	39 d1                	cmp    %edx,%ecx
f0104f8a:	74 33                	je     f0104fbf <debuginfo_eip+0x2ad>
f0104f8c:	83 c0 0c             	add    $0xc,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104f8f:	80 78 f4 a0          	cmpb   $0xa0,-0xc(%eax)
f0104f93:	74 ec                	je     f0104f81 <debuginfo_eip+0x26f>
	return 0;
f0104f95:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f9a:	eb 28                	jmp    f0104fc4 <debuginfo_eip+0x2b2>
            return -1;
f0104f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104fa1:	eb 21                	jmp    f0104fc4 <debuginfo_eip+0x2b2>
            return -1;
f0104fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104fa8:	eb 1a                	jmp    f0104fc4 <debuginfo_eip+0x2b2>
		return -1;
f0104faa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104faf:	eb 13                	jmp    f0104fc4 <debuginfo_eip+0x2b2>
f0104fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104fb6:	eb 0c                	jmp    f0104fc4 <debuginfo_eip+0x2b2>
		return -1;
f0104fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104fbd:	eb 05                	jmp    f0104fc4 <debuginfo_eip+0x2b2>
	return 0;
f0104fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104fc7:	5b                   	pop    %ebx
f0104fc8:	5e                   	pop    %esi
f0104fc9:	5f                   	pop    %edi
f0104fca:	5d                   	pop    %ebp
f0104fcb:	c3                   	ret    

f0104fcc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104fcc:	55                   	push   %ebp
f0104fcd:	89 e5                	mov    %esp,%ebp
f0104fcf:	57                   	push   %edi
f0104fd0:	56                   	push   %esi
f0104fd1:	53                   	push   %ebx
f0104fd2:	83 ec 1c             	sub    $0x1c,%esp
f0104fd5:	89 c7                	mov    %eax,%edi
f0104fd7:	89 d6                	mov    %edx,%esi
f0104fd9:	8b 45 08             	mov    0x8(%ebp),%eax
f0104fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104fdf:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104fe2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0104fe5:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104fe8:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104fed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104ff0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0104ff3:	39 d3                	cmp    %edx,%ebx
f0104ff5:	72 05                	jb     f0104ffc <printnum+0x30>
f0104ff7:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104ffa:	77 7a                	ja     f0105076 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104ffc:	83 ec 0c             	sub    $0xc,%esp
f0104fff:	ff 75 18             	pushl  0x18(%ebp)
f0105002:	8b 45 14             	mov    0x14(%ebp),%eax
f0105005:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0105008:	53                   	push   %ebx
f0105009:	ff 75 10             	pushl  0x10(%ebp)
f010500c:	83 ec 08             	sub    $0x8,%esp
f010500f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105012:	ff 75 e0             	pushl  -0x20(%ebp)
f0105015:	ff 75 dc             	pushl  -0x24(%ebp)
f0105018:	ff 75 d8             	pushl  -0x28(%ebp)
f010501b:	e8 40 19 00 00       	call   f0106960 <__udivdi3>
f0105020:	83 c4 18             	add    $0x18,%esp
f0105023:	52                   	push   %edx
f0105024:	50                   	push   %eax
f0105025:	89 f2                	mov    %esi,%edx
f0105027:	89 f8                	mov    %edi,%eax
f0105029:	e8 9e ff ff ff       	call   f0104fcc <printnum>
f010502e:	83 c4 20             	add    $0x20,%esp
f0105031:	eb 13                	jmp    f0105046 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0105033:	83 ec 08             	sub    $0x8,%esp
f0105036:	56                   	push   %esi
f0105037:	ff 75 18             	pushl  0x18(%ebp)
f010503a:	ff d7                	call   *%edi
f010503c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f010503f:	83 eb 01             	sub    $0x1,%ebx
f0105042:	85 db                	test   %ebx,%ebx
f0105044:	7f ed                	jg     f0105033 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105046:	83 ec 08             	sub    $0x8,%esp
f0105049:	56                   	push   %esi
f010504a:	83 ec 04             	sub    $0x4,%esp
f010504d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105050:	ff 75 e0             	pushl  -0x20(%ebp)
f0105053:	ff 75 dc             	pushl  -0x24(%ebp)
f0105056:	ff 75 d8             	pushl  -0x28(%ebp)
f0105059:	e8 22 1a 00 00       	call   f0106a80 <__umoddi3>
f010505e:	83 c4 14             	add    $0x14,%esp
f0105061:	0f be 80 52 83 10 f0 	movsbl -0xfef7cae(%eax),%eax
f0105068:	50                   	push   %eax
f0105069:	ff d7                	call   *%edi
}
f010506b:	83 c4 10             	add    $0x10,%esp
f010506e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105071:	5b                   	pop    %ebx
f0105072:	5e                   	pop    %esi
f0105073:	5f                   	pop    %edi
f0105074:	5d                   	pop    %ebp
f0105075:	c3                   	ret    
f0105076:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105079:	eb c4                	jmp    f010503f <printnum+0x73>

f010507b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010507b:	55                   	push   %ebp
f010507c:	89 e5                	mov    %esp,%ebp
f010507e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105081:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105085:	8b 10                	mov    (%eax),%edx
f0105087:	3b 50 04             	cmp    0x4(%eax),%edx
f010508a:	73 0a                	jae    f0105096 <sprintputch+0x1b>
		*b->buf++ = ch;
f010508c:	8d 4a 01             	lea    0x1(%edx),%ecx
f010508f:	89 08                	mov    %ecx,(%eax)
f0105091:	8b 45 08             	mov    0x8(%ebp),%eax
f0105094:	88 02                	mov    %al,(%edx)
}
f0105096:	5d                   	pop    %ebp
f0105097:	c3                   	ret    

f0105098 <printfmt>:
{
f0105098:	55                   	push   %ebp
f0105099:	89 e5                	mov    %esp,%ebp
f010509b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f010509e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01050a1:	50                   	push   %eax
f01050a2:	ff 75 10             	pushl  0x10(%ebp)
f01050a5:	ff 75 0c             	pushl  0xc(%ebp)
f01050a8:	ff 75 08             	pushl  0x8(%ebp)
f01050ab:	e8 05 00 00 00       	call   f01050b5 <vprintfmt>
}
f01050b0:	83 c4 10             	add    $0x10,%esp
f01050b3:	c9                   	leave  
f01050b4:	c3                   	ret    

f01050b5 <vprintfmt>:
{
f01050b5:	55                   	push   %ebp
f01050b6:	89 e5                	mov    %esp,%ebp
f01050b8:	57                   	push   %edi
f01050b9:	56                   	push   %esi
f01050ba:	53                   	push   %ebx
f01050bb:	83 ec 2c             	sub    $0x2c,%esp
f01050be:	8b 75 08             	mov    0x8(%ebp),%esi
f01050c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01050c4:	8b 7d 10             	mov    0x10(%ebp),%edi
f01050c7:	e9 21 04 00 00       	jmp    f01054ed <vprintfmt+0x438>
		padc = ' ';
f01050cc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f01050d0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f01050d7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f01050de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f01050e5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01050ea:	8d 47 01             	lea    0x1(%edi),%eax
f01050ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01050f0:	0f b6 17             	movzbl (%edi),%edx
f01050f3:	8d 42 dd             	lea    -0x23(%edx),%eax
f01050f6:	3c 55                	cmp    $0x55,%al
f01050f8:	0f 87 90 04 00 00    	ja     f010558e <vprintfmt+0x4d9>
f01050fe:	0f b6 c0             	movzbl %al,%eax
f0105101:	ff 24 85 a0 84 10 f0 	jmp    *-0xfef7b60(,%eax,4)
f0105108:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f010510b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f010510f:	eb d9                	jmp    f01050ea <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0105111:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105114:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0105118:	eb d0                	jmp    f01050ea <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f010511a:	0f b6 d2             	movzbl %dl,%edx
f010511d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105120:	b8 00 00 00 00       	mov    $0x0,%eax
f0105125:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0105128:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010512b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f010512f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105132:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0105135:	83 f9 09             	cmp    $0x9,%ecx
f0105138:	77 55                	ja     f010518f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f010513a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f010513d:	eb e9                	jmp    f0105128 <vprintfmt+0x73>
			precision = va_arg(ap, int);
f010513f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105142:	8b 00                	mov    (%eax),%eax
f0105144:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105147:	8b 45 14             	mov    0x14(%ebp),%eax
f010514a:	8d 40 04             	lea    0x4(%eax),%eax
f010514d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105150:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105153:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105157:	79 91                	jns    f01050ea <vprintfmt+0x35>
				width = precision, precision = -1;
f0105159:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010515c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010515f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0105166:	eb 82                	jmp    f01050ea <vprintfmt+0x35>
f0105168:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010516b:	85 c0                	test   %eax,%eax
f010516d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105172:	0f 49 d0             	cmovns %eax,%edx
f0105175:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105178:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010517b:	e9 6a ff ff ff       	jmp    f01050ea <vprintfmt+0x35>
f0105180:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105183:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f010518a:	e9 5b ff ff ff       	jmp    f01050ea <vprintfmt+0x35>
f010518f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105192:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105195:	eb bc                	jmp    f0105153 <vprintfmt+0x9e>
			lflag++;
f0105197:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010519a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f010519d:	e9 48 ff ff ff       	jmp    f01050ea <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f01051a2:	8b 45 14             	mov    0x14(%ebp),%eax
f01051a5:	8d 78 04             	lea    0x4(%eax),%edi
f01051a8:	83 ec 08             	sub    $0x8,%esp
f01051ab:	53                   	push   %ebx
f01051ac:	ff 30                	pushl  (%eax)
f01051ae:	ff d6                	call   *%esi
			break;
f01051b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f01051b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f01051b6:	e9 2f 03 00 00       	jmp    f01054ea <vprintfmt+0x435>
			err = va_arg(ap, int);
f01051bb:	8b 45 14             	mov    0x14(%ebp),%eax
f01051be:	8d 78 04             	lea    0x4(%eax),%edi
f01051c1:	8b 00                	mov    (%eax),%eax
f01051c3:	99                   	cltd   
f01051c4:	31 d0                	xor    %edx,%eax
f01051c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01051c8:	83 f8 0f             	cmp    $0xf,%eax
f01051cb:	7f 23                	jg     f01051f0 <vprintfmt+0x13b>
f01051cd:	8b 14 85 00 86 10 f0 	mov    -0xfef7a00(,%eax,4),%edx
f01051d4:	85 d2                	test   %edx,%edx
f01051d6:	74 18                	je     f01051f0 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f01051d8:	52                   	push   %edx
f01051d9:	68 11 7b 10 f0       	push   $0xf0107b11
f01051de:	53                   	push   %ebx
f01051df:	56                   	push   %esi
f01051e0:	e8 b3 fe ff ff       	call   f0105098 <printfmt>
f01051e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01051e8:	89 7d 14             	mov    %edi,0x14(%ebp)
f01051eb:	e9 fa 02 00 00       	jmp    f01054ea <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
f01051f0:	50                   	push   %eax
f01051f1:	68 6a 83 10 f0       	push   $0xf010836a
f01051f6:	53                   	push   %ebx
f01051f7:	56                   	push   %esi
f01051f8:	e8 9b fe ff ff       	call   f0105098 <printfmt>
f01051fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105200:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105203:	e9 e2 02 00 00       	jmp    f01054ea <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
f0105208:	8b 45 14             	mov    0x14(%ebp),%eax
f010520b:	83 c0 04             	add    $0x4,%eax
f010520e:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0105211:	8b 45 14             	mov    0x14(%ebp),%eax
f0105214:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0105216:	85 ff                	test   %edi,%edi
f0105218:	b8 63 83 10 f0       	mov    $0xf0108363,%eax
f010521d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f0105220:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105224:	0f 8e bd 00 00 00    	jle    f01052e7 <vprintfmt+0x232>
f010522a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f010522e:	75 0e                	jne    f010523e <vprintfmt+0x189>
f0105230:	89 75 08             	mov    %esi,0x8(%ebp)
f0105233:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105236:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105239:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010523c:	eb 6d                	jmp    f01052ab <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f010523e:	83 ec 08             	sub    $0x8,%esp
f0105241:	ff 75 d0             	pushl  -0x30(%ebp)
f0105244:	57                   	push   %edi
f0105245:	e8 da 04 00 00       	call   f0105724 <strnlen>
f010524a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010524d:	29 c1                	sub    %eax,%ecx
f010524f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0105252:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0105255:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0105259:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010525c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f010525f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105261:	eb 0f                	jmp    f0105272 <vprintfmt+0x1bd>
					putch(padc, putdat);
f0105263:	83 ec 08             	sub    $0x8,%esp
f0105266:	53                   	push   %ebx
f0105267:	ff 75 e0             	pushl  -0x20(%ebp)
f010526a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f010526c:	83 ef 01             	sub    $0x1,%edi
f010526f:	83 c4 10             	add    $0x10,%esp
f0105272:	85 ff                	test   %edi,%edi
f0105274:	7f ed                	jg     f0105263 <vprintfmt+0x1ae>
f0105276:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0105279:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010527c:	85 c9                	test   %ecx,%ecx
f010527e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105283:	0f 49 c1             	cmovns %ecx,%eax
f0105286:	29 c1                	sub    %eax,%ecx
f0105288:	89 75 08             	mov    %esi,0x8(%ebp)
f010528b:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010528e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105291:	89 cb                	mov    %ecx,%ebx
f0105293:	eb 16                	jmp    f01052ab <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f0105295:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105299:	75 31                	jne    f01052cc <vprintfmt+0x217>
					putch(ch, putdat);
f010529b:	83 ec 08             	sub    $0x8,%esp
f010529e:	ff 75 0c             	pushl  0xc(%ebp)
f01052a1:	50                   	push   %eax
f01052a2:	ff 55 08             	call   *0x8(%ebp)
f01052a5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01052a8:	83 eb 01             	sub    $0x1,%ebx
f01052ab:	83 c7 01             	add    $0x1,%edi
f01052ae:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f01052b2:	0f be c2             	movsbl %dl,%eax
f01052b5:	85 c0                	test   %eax,%eax
f01052b7:	74 59                	je     f0105312 <vprintfmt+0x25d>
f01052b9:	85 f6                	test   %esi,%esi
f01052bb:	78 d8                	js     f0105295 <vprintfmt+0x1e0>
f01052bd:	83 ee 01             	sub    $0x1,%esi
f01052c0:	79 d3                	jns    f0105295 <vprintfmt+0x1e0>
f01052c2:	89 df                	mov    %ebx,%edi
f01052c4:	8b 75 08             	mov    0x8(%ebp),%esi
f01052c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01052ca:	eb 37                	jmp    f0105303 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f01052cc:	0f be d2             	movsbl %dl,%edx
f01052cf:	83 ea 20             	sub    $0x20,%edx
f01052d2:	83 fa 5e             	cmp    $0x5e,%edx
f01052d5:	76 c4                	jbe    f010529b <vprintfmt+0x1e6>
					putch('?', putdat);
f01052d7:	83 ec 08             	sub    $0x8,%esp
f01052da:	ff 75 0c             	pushl  0xc(%ebp)
f01052dd:	6a 3f                	push   $0x3f
f01052df:	ff 55 08             	call   *0x8(%ebp)
f01052e2:	83 c4 10             	add    $0x10,%esp
f01052e5:	eb c1                	jmp    f01052a8 <vprintfmt+0x1f3>
f01052e7:	89 75 08             	mov    %esi,0x8(%ebp)
f01052ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01052ed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f01052f0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01052f3:	eb b6                	jmp    f01052ab <vprintfmt+0x1f6>
				putch(' ', putdat);
f01052f5:	83 ec 08             	sub    $0x8,%esp
f01052f8:	53                   	push   %ebx
f01052f9:	6a 20                	push   $0x20
f01052fb:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01052fd:	83 ef 01             	sub    $0x1,%edi
f0105300:	83 c4 10             	add    $0x10,%esp
f0105303:	85 ff                	test   %edi,%edi
f0105305:	7f ee                	jg     f01052f5 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f0105307:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010530a:	89 45 14             	mov    %eax,0x14(%ebp)
f010530d:	e9 d8 01 00 00       	jmp    f01054ea <vprintfmt+0x435>
f0105312:	89 df                	mov    %ebx,%edi
f0105314:	8b 75 08             	mov    0x8(%ebp),%esi
f0105317:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010531a:	eb e7                	jmp    f0105303 <vprintfmt+0x24e>
	if (lflag >= 2)
f010531c:	83 f9 01             	cmp    $0x1,%ecx
f010531f:	7e 45                	jle    f0105366 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
f0105321:	8b 45 14             	mov    0x14(%ebp),%eax
f0105324:	8b 50 04             	mov    0x4(%eax),%edx
f0105327:	8b 00                	mov    (%eax),%eax
f0105329:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010532c:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010532f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105332:	8d 40 08             	lea    0x8(%eax),%eax
f0105335:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0105338:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010533c:	79 62                	jns    f01053a0 <vprintfmt+0x2eb>
				putch('-', putdat);
f010533e:	83 ec 08             	sub    $0x8,%esp
f0105341:	53                   	push   %ebx
f0105342:	6a 2d                	push   $0x2d
f0105344:	ff d6                	call   *%esi
				num = -(long long) num;
f0105346:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105349:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010534c:	f7 d8                	neg    %eax
f010534e:	83 d2 00             	adc    $0x0,%edx
f0105351:	f7 da                	neg    %edx
f0105353:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105356:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105359:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010535c:	ba 0a 00 00 00       	mov    $0xa,%edx
f0105361:	e9 66 01 00 00       	jmp    f01054cc <vprintfmt+0x417>
	else if (lflag)
f0105366:	85 c9                	test   %ecx,%ecx
f0105368:	75 1b                	jne    f0105385 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
f010536a:	8b 45 14             	mov    0x14(%ebp),%eax
f010536d:	8b 00                	mov    (%eax),%eax
f010536f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105372:	89 c1                	mov    %eax,%ecx
f0105374:	c1 f9 1f             	sar    $0x1f,%ecx
f0105377:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010537a:	8b 45 14             	mov    0x14(%ebp),%eax
f010537d:	8d 40 04             	lea    0x4(%eax),%eax
f0105380:	89 45 14             	mov    %eax,0x14(%ebp)
f0105383:	eb b3                	jmp    f0105338 <vprintfmt+0x283>
		return va_arg(*ap, long);
f0105385:	8b 45 14             	mov    0x14(%ebp),%eax
f0105388:	8b 00                	mov    (%eax),%eax
f010538a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010538d:	89 c1                	mov    %eax,%ecx
f010538f:	c1 f9 1f             	sar    $0x1f,%ecx
f0105392:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105395:	8b 45 14             	mov    0x14(%ebp),%eax
f0105398:	8d 40 04             	lea    0x4(%eax),%eax
f010539b:	89 45 14             	mov    %eax,0x14(%ebp)
f010539e:	eb 98                	jmp    f0105338 <vprintfmt+0x283>
			base = 10;
f01053a0:	ba 0a 00 00 00       	mov    $0xa,%edx
f01053a5:	e9 22 01 00 00       	jmp    f01054cc <vprintfmt+0x417>
	if (lflag >= 2)
f01053aa:	83 f9 01             	cmp    $0x1,%ecx
f01053ad:	7e 21                	jle    f01053d0 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
f01053af:	8b 45 14             	mov    0x14(%ebp),%eax
f01053b2:	8b 50 04             	mov    0x4(%eax),%edx
f01053b5:	8b 00                	mov    (%eax),%eax
f01053b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01053ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01053bd:	8b 45 14             	mov    0x14(%ebp),%eax
f01053c0:	8d 40 08             	lea    0x8(%eax),%eax
f01053c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01053c6:	ba 0a 00 00 00       	mov    $0xa,%edx
f01053cb:	e9 fc 00 00 00       	jmp    f01054cc <vprintfmt+0x417>
	else if (lflag)
f01053d0:	85 c9                	test   %ecx,%ecx
f01053d2:	75 23                	jne    f01053f7 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
f01053d4:	8b 45 14             	mov    0x14(%ebp),%eax
f01053d7:	8b 00                	mov    (%eax),%eax
f01053d9:	ba 00 00 00 00       	mov    $0x0,%edx
f01053de:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01053e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01053e4:	8b 45 14             	mov    0x14(%ebp),%eax
f01053e7:	8d 40 04             	lea    0x4(%eax),%eax
f01053ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01053ed:	ba 0a 00 00 00       	mov    $0xa,%edx
f01053f2:	e9 d5 00 00 00       	jmp    f01054cc <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
f01053f7:	8b 45 14             	mov    0x14(%ebp),%eax
f01053fa:	8b 00                	mov    (%eax),%eax
f01053fc:	ba 00 00 00 00       	mov    $0x0,%edx
f0105401:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105404:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105407:	8b 45 14             	mov    0x14(%ebp),%eax
f010540a:	8d 40 04             	lea    0x4(%eax),%eax
f010540d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105410:	ba 0a 00 00 00       	mov    $0xa,%edx
f0105415:	e9 b2 00 00 00       	jmp    f01054cc <vprintfmt+0x417>
	if (lflag >= 2)
f010541a:	83 f9 01             	cmp    $0x1,%ecx
f010541d:	7e 42                	jle    f0105461 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
f010541f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105422:	8b 50 04             	mov    0x4(%eax),%edx
f0105425:	8b 00                	mov    (%eax),%eax
f0105427:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010542a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010542d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105430:	8d 40 08             	lea    0x8(%eax),%eax
f0105433:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105436:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
f010543b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010543f:	0f 89 87 00 00 00    	jns    f01054cc <vprintfmt+0x417>
				putch('-', putdat);
f0105445:	83 ec 08             	sub    $0x8,%esp
f0105448:	53                   	push   %ebx
f0105449:	6a 2d                	push   $0x2d
f010544b:	ff d6                	call   *%esi
				num = -(long long) num;
f010544d:	f7 5d d8             	negl   -0x28(%ebp)
f0105450:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
f0105454:	f7 5d dc             	negl   -0x24(%ebp)
f0105457:	83 c4 10             	add    $0x10,%esp
			base = 8;
f010545a:	ba 08 00 00 00       	mov    $0x8,%edx
f010545f:	eb 6b                	jmp    f01054cc <vprintfmt+0x417>
	else if (lflag)
f0105461:	85 c9                	test   %ecx,%ecx
f0105463:	75 1b                	jne    f0105480 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
f0105465:	8b 45 14             	mov    0x14(%ebp),%eax
f0105468:	8b 00                	mov    (%eax),%eax
f010546a:	ba 00 00 00 00       	mov    $0x0,%edx
f010546f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105472:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105475:	8b 45 14             	mov    0x14(%ebp),%eax
f0105478:	8d 40 04             	lea    0x4(%eax),%eax
f010547b:	89 45 14             	mov    %eax,0x14(%ebp)
f010547e:	eb b6                	jmp    f0105436 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
f0105480:	8b 45 14             	mov    0x14(%ebp),%eax
f0105483:	8b 00                	mov    (%eax),%eax
f0105485:	ba 00 00 00 00       	mov    $0x0,%edx
f010548a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010548d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105490:	8b 45 14             	mov    0x14(%ebp),%eax
f0105493:	8d 40 04             	lea    0x4(%eax),%eax
f0105496:	89 45 14             	mov    %eax,0x14(%ebp)
f0105499:	eb 9b                	jmp    f0105436 <vprintfmt+0x381>
			putch('0', putdat);
f010549b:	83 ec 08             	sub    $0x8,%esp
f010549e:	53                   	push   %ebx
f010549f:	6a 30                	push   $0x30
f01054a1:	ff d6                	call   *%esi
			putch('x', putdat);
f01054a3:	83 c4 08             	add    $0x8,%esp
f01054a6:	53                   	push   %ebx
f01054a7:	6a 78                	push   $0x78
f01054a9:	ff d6                	call   *%esi
			num = (unsigned long long)
f01054ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01054ae:	8b 00                	mov    (%eax),%eax
f01054b0:	ba 00 00 00 00       	mov    $0x0,%edx
f01054b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01054b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f01054bb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01054be:	8b 45 14             	mov    0x14(%ebp),%eax
f01054c1:	8d 40 04             	lea    0x4(%eax),%eax
f01054c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01054c7:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
f01054cc:	83 ec 0c             	sub    $0xc,%esp
f01054cf:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f01054d3:	50                   	push   %eax
f01054d4:	ff 75 e0             	pushl  -0x20(%ebp)
f01054d7:	52                   	push   %edx
f01054d8:	ff 75 dc             	pushl  -0x24(%ebp)
f01054db:	ff 75 d8             	pushl  -0x28(%ebp)
f01054de:	89 da                	mov    %ebx,%edx
f01054e0:	89 f0                	mov    %esi,%eax
f01054e2:	e8 e5 fa ff ff       	call   f0104fcc <printnum>
			break;
f01054e7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f01054ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01054ed:	83 c7 01             	add    $0x1,%edi
f01054f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01054f4:	83 f8 25             	cmp    $0x25,%eax
f01054f7:	0f 84 cf fb ff ff    	je     f01050cc <vprintfmt+0x17>
			if (ch == '\0')
f01054fd:	85 c0                	test   %eax,%eax
f01054ff:	0f 84 a9 00 00 00    	je     f01055ae <vprintfmt+0x4f9>
			putch(ch, putdat);
f0105505:	83 ec 08             	sub    $0x8,%esp
f0105508:	53                   	push   %ebx
f0105509:	50                   	push   %eax
f010550a:	ff d6                	call   *%esi
f010550c:	83 c4 10             	add    $0x10,%esp
f010550f:	eb dc                	jmp    f01054ed <vprintfmt+0x438>
	if (lflag >= 2)
f0105511:	83 f9 01             	cmp    $0x1,%ecx
f0105514:	7e 1e                	jle    f0105534 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
f0105516:	8b 45 14             	mov    0x14(%ebp),%eax
f0105519:	8b 50 04             	mov    0x4(%eax),%edx
f010551c:	8b 00                	mov    (%eax),%eax
f010551e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105521:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105524:	8b 45 14             	mov    0x14(%ebp),%eax
f0105527:	8d 40 08             	lea    0x8(%eax),%eax
f010552a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010552d:	ba 10 00 00 00       	mov    $0x10,%edx
f0105532:	eb 98                	jmp    f01054cc <vprintfmt+0x417>
	else if (lflag)
f0105534:	85 c9                	test   %ecx,%ecx
f0105536:	75 23                	jne    f010555b <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
f0105538:	8b 45 14             	mov    0x14(%ebp),%eax
f010553b:	8b 00                	mov    (%eax),%eax
f010553d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105542:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105545:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105548:	8b 45 14             	mov    0x14(%ebp),%eax
f010554b:	8d 40 04             	lea    0x4(%eax),%eax
f010554e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105551:	ba 10 00 00 00       	mov    $0x10,%edx
f0105556:	e9 71 ff ff ff       	jmp    f01054cc <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
f010555b:	8b 45 14             	mov    0x14(%ebp),%eax
f010555e:	8b 00                	mov    (%eax),%eax
f0105560:	ba 00 00 00 00       	mov    $0x0,%edx
f0105565:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105568:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010556b:	8b 45 14             	mov    0x14(%ebp),%eax
f010556e:	8d 40 04             	lea    0x4(%eax),%eax
f0105571:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105574:	ba 10 00 00 00       	mov    $0x10,%edx
f0105579:	e9 4e ff ff ff       	jmp    f01054cc <vprintfmt+0x417>
			putch(ch, putdat);
f010557e:	83 ec 08             	sub    $0x8,%esp
f0105581:	53                   	push   %ebx
f0105582:	6a 25                	push   $0x25
f0105584:	ff d6                	call   *%esi
			break;
f0105586:	83 c4 10             	add    $0x10,%esp
f0105589:	e9 5c ff ff ff       	jmp    f01054ea <vprintfmt+0x435>
			putch('%', putdat);
f010558e:	83 ec 08             	sub    $0x8,%esp
f0105591:	53                   	push   %ebx
f0105592:	6a 25                	push   $0x25
f0105594:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105596:	83 c4 10             	add    $0x10,%esp
f0105599:	89 f8                	mov    %edi,%eax
f010559b:	eb 03                	jmp    f01055a0 <vprintfmt+0x4eb>
f010559d:	83 e8 01             	sub    $0x1,%eax
f01055a0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01055a4:	75 f7                	jne    f010559d <vprintfmt+0x4e8>
f01055a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01055a9:	e9 3c ff ff ff       	jmp    f01054ea <vprintfmt+0x435>
}
f01055ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01055b1:	5b                   	pop    %ebx
f01055b2:	5e                   	pop    %esi
f01055b3:	5f                   	pop    %edi
f01055b4:	5d                   	pop    %ebp
f01055b5:	c3                   	ret    

f01055b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01055b6:	55                   	push   %ebp
f01055b7:	89 e5                	mov    %esp,%ebp
f01055b9:	83 ec 18             	sub    $0x18,%esp
f01055bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01055bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01055c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01055c5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01055c9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01055cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01055d3:	85 c0                	test   %eax,%eax
f01055d5:	74 26                	je     f01055fd <vsnprintf+0x47>
f01055d7:	85 d2                	test   %edx,%edx
f01055d9:	7e 22                	jle    f01055fd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01055db:	ff 75 14             	pushl  0x14(%ebp)
f01055de:	ff 75 10             	pushl  0x10(%ebp)
f01055e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01055e4:	50                   	push   %eax
f01055e5:	68 7b 50 10 f0       	push   $0xf010507b
f01055ea:	e8 c6 fa ff ff       	call   f01050b5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01055ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01055f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01055f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01055f8:	83 c4 10             	add    $0x10,%esp
}
f01055fb:	c9                   	leave  
f01055fc:	c3                   	ret    
		return -E_INVAL;
f01055fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105602:	eb f7                	jmp    f01055fb <vsnprintf+0x45>

f0105604 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105604:	55                   	push   %ebp
f0105605:	89 e5                	mov    %esp,%ebp
f0105607:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f010560a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010560d:	50                   	push   %eax
f010560e:	ff 75 10             	pushl  0x10(%ebp)
f0105611:	ff 75 0c             	pushl  0xc(%ebp)
f0105614:	ff 75 08             	pushl  0x8(%ebp)
f0105617:	e8 9a ff ff ff       	call   f01055b6 <vsnprintf>
	va_end(ap);

	return rc;
}
f010561c:	c9                   	leave  
f010561d:	c3                   	ret    

f010561e <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010561e:	55                   	push   %ebp
f010561f:	89 e5                	mov    %esp,%ebp
f0105621:	57                   	push   %edi
f0105622:	56                   	push   %esi
f0105623:	53                   	push   %ebx
f0105624:	83 ec 0c             	sub    $0xc,%esp
f0105627:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f010562a:	85 c0                	test   %eax,%eax
f010562c:	74 11                	je     f010563f <readline+0x21>
		cprintf("%s", prompt);
f010562e:	83 ec 08             	sub    $0x8,%esp
f0105631:	50                   	push   %eax
f0105632:	68 11 7b 10 f0       	push   $0xf0107b11
f0105637:	e8 10 e3 ff ff       	call   f010394c <cprintf>
f010563c:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010563f:	83 ec 0c             	sub    $0xc,%esp
f0105642:	6a 00                	push   $0x0
f0105644:	e8 93 b1 ff ff       	call   f01007dc <iscons>
f0105649:	89 c7                	mov    %eax,%edi
f010564b:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010564e:	be 00 00 00 00       	mov    $0x0,%esi
f0105653:	eb 4b                	jmp    f01056a0 <readline+0x82>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105655:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f010565a:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010565d:	75 08                	jne    f0105667 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010565f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105662:	5b                   	pop    %ebx
f0105663:	5e                   	pop    %esi
f0105664:	5f                   	pop    %edi
f0105665:	5d                   	pop    %ebp
f0105666:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0105667:	83 ec 08             	sub    $0x8,%esp
f010566a:	53                   	push   %ebx
f010566b:	68 5f 86 10 f0       	push   $0xf010865f
f0105670:	e8 d7 e2 ff ff       	call   f010394c <cprintf>
f0105675:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0105678:	b8 00 00 00 00       	mov    $0x0,%eax
f010567d:	eb e0                	jmp    f010565f <readline+0x41>
			if (echoing)
f010567f:	85 ff                	test   %edi,%edi
f0105681:	75 05                	jne    f0105688 <readline+0x6a>
			i--;
f0105683:	83 ee 01             	sub    $0x1,%esi
f0105686:	eb 18                	jmp    f01056a0 <readline+0x82>
				cputchar('\b');
f0105688:	83 ec 0c             	sub    $0xc,%esp
f010568b:	6a 08                	push   $0x8
f010568d:	e8 29 b1 ff ff       	call   f01007bb <cputchar>
f0105692:	83 c4 10             	add    $0x10,%esp
f0105695:	eb ec                	jmp    f0105683 <readline+0x65>
			buf[i++] = c;
f0105697:	88 9e 80 0a 2b f0    	mov    %bl,-0xfd4f580(%esi)
f010569d:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01056a0:	e8 26 b1 ff ff       	call   f01007cb <getchar>
f01056a5:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01056a7:	85 c0                	test   %eax,%eax
f01056a9:	78 aa                	js     f0105655 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01056ab:	83 f8 08             	cmp    $0x8,%eax
f01056ae:	0f 94 c2             	sete   %dl
f01056b1:	83 f8 7f             	cmp    $0x7f,%eax
f01056b4:	0f 94 c0             	sete   %al
f01056b7:	08 c2                	or     %al,%dl
f01056b9:	74 04                	je     f01056bf <readline+0xa1>
f01056bb:	85 f6                	test   %esi,%esi
f01056bd:	7f c0                	jg     f010567f <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01056bf:	83 fb 1f             	cmp    $0x1f,%ebx
f01056c2:	7e 1a                	jle    f01056de <readline+0xc0>
f01056c4:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01056ca:	7f 12                	jg     f01056de <readline+0xc0>
			if (echoing)
f01056cc:	85 ff                	test   %edi,%edi
f01056ce:	74 c7                	je     f0105697 <readline+0x79>
				cputchar(c);
f01056d0:	83 ec 0c             	sub    $0xc,%esp
f01056d3:	53                   	push   %ebx
f01056d4:	e8 e2 b0 ff ff       	call   f01007bb <cputchar>
f01056d9:	83 c4 10             	add    $0x10,%esp
f01056dc:	eb b9                	jmp    f0105697 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f01056de:	83 fb 0a             	cmp    $0xa,%ebx
f01056e1:	74 05                	je     f01056e8 <readline+0xca>
f01056e3:	83 fb 0d             	cmp    $0xd,%ebx
f01056e6:	75 b8                	jne    f01056a0 <readline+0x82>
			if (echoing)
f01056e8:	85 ff                	test   %edi,%edi
f01056ea:	75 11                	jne    f01056fd <readline+0xdf>
			buf[i] = 0;
f01056ec:	c6 86 80 0a 2b f0 00 	movb   $0x0,-0xfd4f580(%esi)
			return buf;
f01056f3:	b8 80 0a 2b f0       	mov    $0xf02b0a80,%eax
f01056f8:	e9 62 ff ff ff       	jmp    f010565f <readline+0x41>
				cputchar('\n');
f01056fd:	83 ec 0c             	sub    $0xc,%esp
f0105700:	6a 0a                	push   $0xa
f0105702:	e8 b4 b0 ff ff       	call   f01007bb <cputchar>
f0105707:	83 c4 10             	add    $0x10,%esp
f010570a:	eb e0                	jmp    f01056ec <readline+0xce>

f010570c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010570c:	55                   	push   %ebp
f010570d:	89 e5                	mov    %esp,%ebp
f010570f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105712:	b8 00 00 00 00       	mov    $0x0,%eax
f0105717:	eb 03                	jmp    f010571c <strlen+0x10>
		n++;
f0105719:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f010571c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105720:	75 f7                	jne    f0105719 <strlen+0xd>
	return n;
}
f0105722:	5d                   	pop    %ebp
f0105723:	c3                   	ret    

f0105724 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105724:	55                   	push   %ebp
f0105725:	89 e5                	mov    %esp,%ebp
f0105727:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010572a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010572d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105732:	eb 03                	jmp    f0105737 <strnlen+0x13>
		n++;
f0105734:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105737:	39 d0                	cmp    %edx,%eax
f0105739:	74 06                	je     f0105741 <strnlen+0x1d>
f010573b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010573f:	75 f3                	jne    f0105734 <strnlen+0x10>
	return n;
}
f0105741:	5d                   	pop    %ebp
f0105742:	c3                   	ret    

f0105743 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105743:	55                   	push   %ebp
f0105744:	89 e5                	mov    %esp,%ebp
f0105746:	53                   	push   %ebx
f0105747:	8b 45 08             	mov    0x8(%ebp),%eax
f010574a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010574d:	89 c2                	mov    %eax,%edx
f010574f:	83 c1 01             	add    $0x1,%ecx
f0105752:	83 c2 01             	add    $0x1,%edx
f0105755:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0105759:	88 5a ff             	mov    %bl,-0x1(%edx)
f010575c:	84 db                	test   %bl,%bl
f010575e:	75 ef                	jne    f010574f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0105760:	5b                   	pop    %ebx
f0105761:	5d                   	pop    %ebp
f0105762:	c3                   	ret    

f0105763 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105763:	55                   	push   %ebp
f0105764:	89 e5                	mov    %esp,%ebp
f0105766:	53                   	push   %ebx
f0105767:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f010576a:	53                   	push   %ebx
f010576b:	e8 9c ff ff ff       	call   f010570c <strlen>
f0105770:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f0105773:	ff 75 0c             	pushl  0xc(%ebp)
f0105776:	01 d8                	add    %ebx,%eax
f0105778:	50                   	push   %eax
f0105779:	e8 c5 ff ff ff       	call   f0105743 <strcpy>
	return dst;
}
f010577e:	89 d8                	mov    %ebx,%eax
f0105780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105783:	c9                   	leave  
f0105784:	c3                   	ret    

f0105785 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105785:	55                   	push   %ebp
f0105786:	89 e5                	mov    %esp,%ebp
f0105788:	56                   	push   %esi
f0105789:	53                   	push   %ebx
f010578a:	8b 75 08             	mov    0x8(%ebp),%esi
f010578d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105790:	89 f3                	mov    %esi,%ebx
f0105792:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105795:	89 f2                	mov    %esi,%edx
f0105797:	eb 0f                	jmp    f01057a8 <strncpy+0x23>
		*dst++ = *src;
f0105799:	83 c2 01             	add    $0x1,%edx
f010579c:	0f b6 01             	movzbl (%ecx),%eax
f010579f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01057a2:	80 39 01             	cmpb   $0x1,(%ecx)
f01057a5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f01057a8:	39 da                	cmp    %ebx,%edx
f01057aa:	75 ed                	jne    f0105799 <strncpy+0x14>
	}
	return ret;
}
f01057ac:	89 f0                	mov    %esi,%eax
f01057ae:	5b                   	pop    %ebx
f01057af:	5e                   	pop    %esi
f01057b0:	5d                   	pop    %ebp
f01057b1:	c3                   	ret    

f01057b2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01057b2:	55                   	push   %ebp
f01057b3:	89 e5                	mov    %esp,%ebp
f01057b5:	56                   	push   %esi
f01057b6:	53                   	push   %ebx
f01057b7:	8b 75 08             	mov    0x8(%ebp),%esi
f01057ba:	8b 55 0c             	mov    0xc(%ebp),%edx
f01057bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01057c0:	89 f0                	mov    %esi,%eax
f01057c2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01057c6:	85 c9                	test   %ecx,%ecx
f01057c8:	75 0b                	jne    f01057d5 <strlcpy+0x23>
f01057ca:	eb 17                	jmp    f01057e3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01057cc:	83 c2 01             	add    $0x1,%edx
f01057cf:	83 c0 01             	add    $0x1,%eax
f01057d2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f01057d5:	39 d8                	cmp    %ebx,%eax
f01057d7:	74 07                	je     f01057e0 <strlcpy+0x2e>
f01057d9:	0f b6 0a             	movzbl (%edx),%ecx
f01057dc:	84 c9                	test   %cl,%cl
f01057de:	75 ec                	jne    f01057cc <strlcpy+0x1a>
		*dst = '\0';
f01057e0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01057e3:	29 f0                	sub    %esi,%eax
}
f01057e5:	5b                   	pop    %ebx
f01057e6:	5e                   	pop    %esi
f01057e7:	5d                   	pop    %ebp
f01057e8:	c3                   	ret    

f01057e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01057e9:	55                   	push   %ebp
f01057ea:	89 e5                	mov    %esp,%ebp
f01057ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01057ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01057f2:	eb 06                	jmp    f01057fa <strcmp+0x11>
		p++, q++;
f01057f4:	83 c1 01             	add    $0x1,%ecx
f01057f7:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f01057fa:	0f b6 01             	movzbl (%ecx),%eax
f01057fd:	84 c0                	test   %al,%al
f01057ff:	74 04                	je     f0105805 <strcmp+0x1c>
f0105801:	3a 02                	cmp    (%edx),%al
f0105803:	74 ef                	je     f01057f4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105805:	0f b6 c0             	movzbl %al,%eax
f0105808:	0f b6 12             	movzbl (%edx),%edx
f010580b:	29 d0                	sub    %edx,%eax
}
f010580d:	5d                   	pop    %ebp
f010580e:	c3                   	ret    

f010580f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010580f:	55                   	push   %ebp
f0105810:	89 e5                	mov    %esp,%ebp
f0105812:	53                   	push   %ebx
f0105813:	8b 45 08             	mov    0x8(%ebp),%eax
f0105816:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105819:	89 c3                	mov    %eax,%ebx
f010581b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010581e:	eb 06                	jmp    f0105826 <strncmp+0x17>
		n--, p++, q++;
f0105820:	83 c0 01             	add    $0x1,%eax
f0105823:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105826:	39 d8                	cmp    %ebx,%eax
f0105828:	74 16                	je     f0105840 <strncmp+0x31>
f010582a:	0f b6 08             	movzbl (%eax),%ecx
f010582d:	84 c9                	test   %cl,%cl
f010582f:	74 04                	je     f0105835 <strncmp+0x26>
f0105831:	3a 0a                	cmp    (%edx),%cl
f0105833:	74 eb                	je     f0105820 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105835:	0f b6 00             	movzbl (%eax),%eax
f0105838:	0f b6 12             	movzbl (%edx),%edx
f010583b:	29 d0                	sub    %edx,%eax
}
f010583d:	5b                   	pop    %ebx
f010583e:	5d                   	pop    %ebp
f010583f:	c3                   	ret    
		return 0;
f0105840:	b8 00 00 00 00       	mov    $0x0,%eax
f0105845:	eb f6                	jmp    f010583d <strncmp+0x2e>

f0105847 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105847:	55                   	push   %ebp
f0105848:	89 e5                	mov    %esp,%ebp
f010584a:	8b 45 08             	mov    0x8(%ebp),%eax
f010584d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105851:	0f b6 10             	movzbl (%eax),%edx
f0105854:	84 d2                	test   %dl,%dl
f0105856:	74 09                	je     f0105861 <strchr+0x1a>
		if (*s == c)
f0105858:	38 ca                	cmp    %cl,%dl
f010585a:	74 0a                	je     f0105866 <strchr+0x1f>
	for (; *s; s++)
f010585c:	83 c0 01             	add    $0x1,%eax
f010585f:	eb f0                	jmp    f0105851 <strchr+0xa>
			return (char *) s;
	return 0;
f0105861:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105866:	5d                   	pop    %ebp
f0105867:	c3                   	ret    

f0105868 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105868:	55                   	push   %ebp
f0105869:	89 e5                	mov    %esp,%ebp
f010586b:	8b 45 08             	mov    0x8(%ebp),%eax
f010586e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105872:	eb 03                	jmp    f0105877 <strfind+0xf>
f0105874:	83 c0 01             	add    $0x1,%eax
f0105877:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f010587a:	38 ca                	cmp    %cl,%dl
f010587c:	74 04                	je     f0105882 <strfind+0x1a>
f010587e:	84 d2                	test   %dl,%dl
f0105880:	75 f2                	jne    f0105874 <strfind+0xc>
			break;
	return (char *) s;
}
f0105882:	5d                   	pop    %ebp
f0105883:	c3                   	ret    

f0105884 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105884:	55                   	push   %ebp
f0105885:	89 e5                	mov    %esp,%ebp
f0105887:	57                   	push   %edi
f0105888:	56                   	push   %esi
f0105889:	53                   	push   %ebx
f010588a:	8b 7d 08             	mov    0x8(%ebp),%edi
f010588d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105890:	85 c9                	test   %ecx,%ecx
f0105892:	74 13                	je     f01058a7 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105894:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010589a:	75 05                	jne    f01058a1 <memset+0x1d>
f010589c:	f6 c1 03             	test   $0x3,%cl
f010589f:	74 0d                	je     f01058ae <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01058a1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01058a4:	fc                   	cld    
f01058a5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01058a7:	89 f8                	mov    %edi,%eax
f01058a9:	5b                   	pop    %ebx
f01058aa:	5e                   	pop    %esi
f01058ab:	5f                   	pop    %edi
f01058ac:	5d                   	pop    %ebp
f01058ad:	c3                   	ret    
		c &= 0xFF;
f01058ae:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01058b2:	89 d3                	mov    %edx,%ebx
f01058b4:	c1 e3 08             	shl    $0x8,%ebx
f01058b7:	89 d0                	mov    %edx,%eax
f01058b9:	c1 e0 18             	shl    $0x18,%eax
f01058bc:	89 d6                	mov    %edx,%esi
f01058be:	c1 e6 10             	shl    $0x10,%esi
f01058c1:	09 f0                	or     %esi,%eax
f01058c3:	09 c2                	or     %eax,%edx
f01058c5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f01058c7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01058ca:	89 d0                	mov    %edx,%eax
f01058cc:	fc                   	cld    
f01058cd:	f3 ab                	rep stos %eax,%es:(%edi)
f01058cf:	eb d6                	jmp    f01058a7 <memset+0x23>

f01058d1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01058d1:	55                   	push   %ebp
f01058d2:	89 e5                	mov    %esp,%ebp
f01058d4:	57                   	push   %edi
f01058d5:	56                   	push   %esi
f01058d6:	8b 45 08             	mov    0x8(%ebp),%eax
f01058d9:	8b 75 0c             	mov    0xc(%ebp),%esi
f01058dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01058df:	39 c6                	cmp    %eax,%esi
f01058e1:	73 35                	jae    f0105918 <memmove+0x47>
f01058e3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01058e6:	39 c2                	cmp    %eax,%edx
f01058e8:	76 2e                	jbe    f0105918 <memmove+0x47>
		s += n;
		d += n;
f01058ea:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01058ed:	89 d6                	mov    %edx,%esi
f01058ef:	09 fe                	or     %edi,%esi
f01058f1:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01058f7:	74 0c                	je     f0105905 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01058f9:	83 ef 01             	sub    $0x1,%edi
f01058fc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f01058ff:	fd                   	std    
f0105900:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105902:	fc                   	cld    
f0105903:	eb 21                	jmp    f0105926 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105905:	f6 c1 03             	test   $0x3,%cl
f0105908:	75 ef                	jne    f01058f9 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f010590a:	83 ef 04             	sub    $0x4,%edi
f010590d:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105910:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105913:	fd                   	std    
f0105914:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105916:	eb ea                	jmp    f0105902 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105918:	89 f2                	mov    %esi,%edx
f010591a:	09 c2                	or     %eax,%edx
f010591c:	f6 c2 03             	test   $0x3,%dl
f010591f:	74 09                	je     f010592a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0105921:	89 c7                	mov    %eax,%edi
f0105923:	fc                   	cld    
f0105924:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105926:	5e                   	pop    %esi
f0105927:	5f                   	pop    %edi
f0105928:	5d                   	pop    %ebp
f0105929:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010592a:	f6 c1 03             	test   $0x3,%cl
f010592d:	75 f2                	jne    f0105921 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010592f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105932:	89 c7                	mov    %eax,%edi
f0105934:	fc                   	cld    
f0105935:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105937:	eb ed                	jmp    f0105926 <memmove+0x55>

f0105939 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105939:	55                   	push   %ebp
f010593a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f010593c:	ff 75 10             	pushl  0x10(%ebp)
f010593f:	ff 75 0c             	pushl  0xc(%ebp)
f0105942:	ff 75 08             	pushl  0x8(%ebp)
f0105945:	e8 87 ff ff ff       	call   f01058d1 <memmove>
}
f010594a:	c9                   	leave  
f010594b:	c3                   	ret    

f010594c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010594c:	55                   	push   %ebp
f010594d:	89 e5                	mov    %esp,%ebp
f010594f:	56                   	push   %esi
f0105950:	53                   	push   %ebx
f0105951:	8b 45 08             	mov    0x8(%ebp),%eax
f0105954:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105957:	89 c6                	mov    %eax,%esi
f0105959:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010595c:	39 f0                	cmp    %esi,%eax
f010595e:	74 1c                	je     f010597c <memcmp+0x30>
		if (*s1 != *s2)
f0105960:	0f b6 08             	movzbl (%eax),%ecx
f0105963:	0f b6 1a             	movzbl (%edx),%ebx
f0105966:	38 d9                	cmp    %bl,%cl
f0105968:	75 08                	jne    f0105972 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f010596a:	83 c0 01             	add    $0x1,%eax
f010596d:	83 c2 01             	add    $0x1,%edx
f0105970:	eb ea                	jmp    f010595c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0105972:	0f b6 c1             	movzbl %cl,%eax
f0105975:	0f b6 db             	movzbl %bl,%ebx
f0105978:	29 d8                	sub    %ebx,%eax
f010597a:	eb 05                	jmp    f0105981 <memcmp+0x35>
	}

	return 0;
f010597c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105981:	5b                   	pop    %ebx
f0105982:	5e                   	pop    %esi
f0105983:	5d                   	pop    %ebp
f0105984:	c3                   	ret    

f0105985 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105985:	55                   	push   %ebp
f0105986:	89 e5                	mov    %esp,%ebp
f0105988:	8b 45 08             	mov    0x8(%ebp),%eax
f010598b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f010598e:	89 c2                	mov    %eax,%edx
f0105990:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105993:	39 d0                	cmp    %edx,%eax
f0105995:	73 09                	jae    f01059a0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105997:	38 08                	cmp    %cl,(%eax)
f0105999:	74 05                	je     f01059a0 <memfind+0x1b>
	for (; s < ends; s++)
f010599b:	83 c0 01             	add    $0x1,%eax
f010599e:	eb f3                	jmp    f0105993 <memfind+0xe>
			break;
	return (void *) s;
}
f01059a0:	5d                   	pop    %ebp
f01059a1:	c3                   	ret    

f01059a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01059a2:	55                   	push   %ebp
f01059a3:	89 e5                	mov    %esp,%ebp
f01059a5:	57                   	push   %edi
f01059a6:	56                   	push   %esi
f01059a7:	53                   	push   %ebx
f01059a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01059ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01059ae:	eb 03                	jmp    f01059b3 <strtol+0x11>
		s++;
f01059b0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01059b3:	0f b6 01             	movzbl (%ecx),%eax
f01059b6:	3c 20                	cmp    $0x20,%al
f01059b8:	74 f6                	je     f01059b0 <strtol+0xe>
f01059ba:	3c 09                	cmp    $0x9,%al
f01059bc:	74 f2                	je     f01059b0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01059be:	3c 2b                	cmp    $0x2b,%al
f01059c0:	74 2e                	je     f01059f0 <strtol+0x4e>
	int neg = 0;
f01059c2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01059c7:	3c 2d                	cmp    $0x2d,%al
f01059c9:	74 2f                	je     f01059fa <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01059cb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01059d1:	75 05                	jne    f01059d8 <strtol+0x36>
f01059d3:	80 39 30             	cmpb   $0x30,(%ecx)
f01059d6:	74 2c                	je     f0105a04 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f01059d8:	85 db                	test   %ebx,%ebx
f01059da:	75 0a                	jne    f01059e6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01059dc:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f01059e1:	80 39 30             	cmpb   $0x30,(%ecx)
f01059e4:	74 28                	je     f0105a0e <strtol+0x6c>
		base = 10;
f01059e6:	b8 00 00 00 00       	mov    $0x0,%eax
f01059eb:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01059ee:	eb 50                	jmp    f0105a40 <strtol+0x9e>
		s++;
f01059f0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01059f3:	bf 00 00 00 00       	mov    $0x0,%edi
f01059f8:	eb d1                	jmp    f01059cb <strtol+0x29>
		s++, neg = 1;
f01059fa:	83 c1 01             	add    $0x1,%ecx
f01059fd:	bf 01 00 00 00       	mov    $0x1,%edi
f0105a02:	eb c7                	jmp    f01059cb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105a04:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105a08:	74 0e                	je     f0105a18 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105a0a:	85 db                	test   %ebx,%ebx
f0105a0c:	75 d8                	jne    f01059e6 <strtol+0x44>
		s++, base = 8;
f0105a0e:	83 c1 01             	add    $0x1,%ecx
f0105a11:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105a16:	eb ce                	jmp    f01059e6 <strtol+0x44>
		s += 2, base = 16;
f0105a18:	83 c1 02             	add    $0x2,%ecx
f0105a1b:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105a20:	eb c4                	jmp    f01059e6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0105a22:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105a25:	89 f3                	mov    %esi,%ebx
f0105a27:	80 fb 19             	cmp    $0x19,%bl
f0105a2a:	77 29                	ja     f0105a55 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105a2c:	0f be d2             	movsbl %dl,%edx
f0105a2f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105a32:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105a35:	7d 30                	jge    f0105a67 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105a37:	83 c1 01             	add    $0x1,%ecx
f0105a3a:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105a3e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105a40:	0f b6 11             	movzbl (%ecx),%edx
f0105a43:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105a46:	89 f3                	mov    %esi,%ebx
f0105a48:	80 fb 09             	cmp    $0x9,%bl
f0105a4b:	77 d5                	ja     f0105a22 <strtol+0x80>
			dig = *s - '0';
f0105a4d:	0f be d2             	movsbl %dl,%edx
f0105a50:	83 ea 30             	sub    $0x30,%edx
f0105a53:	eb dd                	jmp    f0105a32 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0105a55:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105a58:	89 f3                	mov    %esi,%ebx
f0105a5a:	80 fb 19             	cmp    $0x19,%bl
f0105a5d:	77 08                	ja     f0105a67 <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105a5f:	0f be d2             	movsbl %dl,%edx
f0105a62:	83 ea 37             	sub    $0x37,%edx
f0105a65:	eb cb                	jmp    f0105a32 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105a67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105a6b:	74 05                	je     f0105a72 <strtol+0xd0>
		*endptr = (char *) s;
f0105a6d:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105a70:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105a72:	89 c2                	mov    %eax,%edx
f0105a74:	f7 da                	neg    %edx
f0105a76:	85 ff                	test   %edi,%edi
f0105a78:	0f 45 c2             	cmovne %edx,%eax
}
f0105a7b:	5b                   	pop    %ebx
f0105a7c:	5e                   	pop    %esi
f0105a7d:	5f                   	pop    %edi
f0105a7e:	5d                   	pop    %ebp
f0105a7f:	c3                   	ret    

f0105a80 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105a80:	fa                   	cli    

	xorw    %ax, %ax
f0105a81:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0105a83:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105a85:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105a87:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105a89:	0f 01 16             	lgdtl  (%esi)
f0105a8c:	74 70                	je     f0105afe <mpsearch1+0x3>
	movl    %cr0, %eax
f0105a8e:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0105a91:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105a95:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105a98:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105a9e:	08 00                	or     %al,(%eax)

f0105aa0 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0105aa0:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105aa4:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105aa6:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105aa8:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105aaa:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0105aae:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105ab0:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105ab2:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl    %eax, %cr3
f0105ab7:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105aba:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105abd:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105ac2:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105ac5:	8b 25 90 92 2c f0    	mov    0xf02c9290,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105acb:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105ad0:	b8 cd 01 10 f0       	mov    $0xf01001cd,%eax
	call    *%eax
f0105ad5:	ff d0                	call   *%eax

f0105ad7 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105ad7:	eb fe                	jmp    f0105ad7 <spin>
f0105ad9:	8d 76 00             	lea    0x0(%esi),%esi

f0105adc <gdt>:
	...
f0105ae4:	ff                   	(bad)  
f0105ae5:	ff 00                	incl   (%eax)
f0105ae7:	00 00                	add    %al,(%eax)
f0105ae9:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105af0:	00                   	.byte 0x0
f0105af1:	92                   	xchg   %eax,%edx
f0105af2:	cf                   	iret   
	...

f0105af4 <gdtdesc>:
f0105af4:	17                   	pop    %ss
f0105af5:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105afa <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105afa:	90                   	nop

f0105afb <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105afb:	55                   	push   %ebp
f0105afc:	89 e5                	mov    %esp,%ebp
f0105afe:	57                   	push   %edi
f0105aff:	56                   	push   %esi
f0105b00:	53                   	push   %ebx
f0105b01:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0105b04:	8b 0d 94 92 2c f0    	mov    0xf02c9294,%ecx
f0105b0a:	89 c3                	mov    %eax,%ebx
f0105b0c:	c1 eb 0c             	shr    $0xc,%ebx
f0105b0f:	39 cb                	cmp    %ecx,%ebx
f0105b11:	73 1a                	jae    f0105b2d <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105b13:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105b19:	8d 34 02             	lea    (%edx,%eax,1),%esi
	if (PGNUM(pa) >= npages)
f0105b1c:	89 f0                	mov    %esi,%eax
f0105b1e:	c1 e8 0c             	shr    $0xc,%eax
f0105b21:	39 c8                	cmp    %ecx,%eax
f0105b23:	73 1a                	jae    f0105b3f <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105b25:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f0105b2b:	eb 27                	jmp    f0105b54 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105b2d:	50                   	push   %eax
f0105b2e:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0105b33:	6a 57                	push   $0x57
f0105b35:	68 fd 87 10 f0       	push   $0xf01087fd
f0105b3a:	e8 01 a5 ff ff       	call   f0100040 <_panic>
f0105b3f:	56                   	push   %esi
f0105b40:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0105b45:	6a 57                	push   $0x57
f0105b47:	68 fd 87 10 f0       	push   $0xf01087fd
f0105b4c:	e8 ef a4 ff ff       	call   f0100040 <_panic>
f0105b51:	83 c3 10             	add    $0x10,%ebx
f0105b54:	39 f3                	cmp    %esi,%ebx
f0105b56:	73 2e                	jae    f0105b86 <mpsearch1+0x8b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105b58:	83 ec 04             	sub    $0x4,%esp
f0105b5b:	6a 04                	push   $0x4
f0105b5d:	68 0d 88 10 f0       	push   $0xf010880d
f0105b62:	53                   	push   %ebx
f0105b63:	e8 e4 fd ff ff       	call   f010594c <memcmp>
f0105b68:	83 c4 10             	add    $0x10,%esp
f0105b6b:	85 c0                	test   %eax,%eax
f0105b6d:	75 e2                	jne    f0105b51 <mpsearch1+0x56>
f0105b6f:	89 da                	mov    %ebx,%edx
f0105b71:	8d 7b 10             	lea    0x10(%ebx),%edi
		sum += ((uint8_t *)addr)[i];
f0105b74:	0f b6 0a             	movzbl (%edx),%ecx
f0105b77:	01 c8                	add    %ecx,%eax
f0105b79:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105b7c:	39 fa                	cmp    %edi,%edx
f0105b7e:	75 f4                	jne    f0105b74 <mpsearch1+0x79>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105b80:	84 c0                	test   %al,%al
f0105b82:	75 cd                	jne    f0105b51 <mpsearch1+0x56>
f0105b84:	eb 05                	jmp    f0105b8b <mpsearch1+0x90>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105b86:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105b8b:	89 d8                	mov    %ebx,%eax
f0105b8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b90:	5b                   	pop    %ebx
f0105b91:	5e                   	pop    %esi
f0105b92:	5f                   	pop    %edi
f0105b93:	5d                   	pop    %ebp
f0105b94:	c3                   	ret    

f0105b95 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105b95:	55                   	push   %ebp
f0105b96:	89 e5                	mov    %esp,%ebp
f0105b98:	57                   	push   %edi
f0105b99:	56                   	push   %esi
f0105b9a:	53                   	push   %ebx
f0105b9b:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105b9e:	c7 05 c0 a3 2c f0 20 	movl   $0xf02ca020,0xf02ca3c0
f0105ba5:	a0 2c f0 
	if (PGNUM(pa) >= npages)
f0105ba8:	83 3d 94 92 2c f0 00 	cmpl   $0x0,0xf02c9294
f0105baf:	0f 84 87 00 00 00    	je     f0105c3c <mp_init+0xa7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105bb5:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105bbc:	85 c0                	test   %eax,%eax
f0105bbe:	0f 84 8e 00 00 00    	je     f0105c52 <mp_init+0xbd>
		p <<= 4;	// Translate from segment to PA
f0105bc4:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105bc7:	ba 00 04 00 00       	mov    $0x400,%edx
f0105bcc:	e8 2a ff ff ff       	call   f0105afb <mpsearch1>
f0105bd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105bd4:	85 c0                	test   %eax,%eax
f0105bd6:	0f 84 9a 00 00 00    	je     f0105c76 <mp_init+0xe1>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105bdc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105bdf:	8b 41 04             	mov    0x4(%ecx),%eax
f0105be2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105be5:	85 c0                	test   %eax,%eax
f0105be7:	0f 84 a8 00 00 00    	je     f0105c95 <mp_init+0x100>
f0105bed:	80 79 0b 00          	cmpb   $0x0,0xb(%ecx)
f0105bf1:	0f 85 9e 00 00 00    	jne    f0105c95 <mp_init+0x100>
f0105bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105bfa:	c1 e8 0c             	shr    $0xc,%eax
f0105bfd:	3b 05 94 92 2c f0    	cmp    0xf02c9294,%eax
f0105c03:	0f 83 a1 00 00 00    	jae    f0105caa <mp_init+0x115>
	return (void *)(pa + KERNBASE);
f0105c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105c0c:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f0105c12:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105c14:	83 ec 04             	sub    $0x4,%esp
f0105c17:	6a 04                	push   $0x4
f0105c19:	68 12 88 10 f0       	push   $0xf0108812
f0105c1e:	53                   	push   %ebx
f0105c1f:	e8 28 fd ff ff       	call   f010594c <memcmp>
f0105c24:	83 c4 10             	add    $0x10,%esp
f0105c27:	85 c0                	test   %eax,%eax
f0105c29:	0f 85 92 00 00 00    	jne    f0105cc1 <mp_init+0x12c>
f0105c2f:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105c33:	01 df                	add    %ebx,%edi
	sum = 0;
f0105c35:	89 c2                	mov    %eax,%edx
f0105c37:	e9 a2 00 00 00       	jmp    f0105cde <mp_init+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105c3c:	68 00 04 00 00       	push   $0x400
f0105c41:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0105c46:	6a 6f                	push   $0x6f
f0105c48:	68 fd 87 10 f0       	push   $0xf01087fd
f0105c4d:	e8 ee a3 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105c52:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105c59:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105c5c:	2d 00 04 00 00       	sub    $0x400,%eax
f0105c61:	ba 00 04 00 00       	mov    $0x400,%edx
f0105c66:	e8 90 fe ff ff       	call   f0105afb <mpsearch1>
f0105c6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105c6e:	85 c0                	test   %eax,%eax
f0105c70:	0f 85 66 ff ff ff    	jne    f0105bdc <mp_init+0x47>
	return mpsearch1(0xF0000, 0x10000);
f0105c76:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c7b:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105c80:	e8 76 fe ff ff       	call   f0105afb <mpsearch1>
f0105c85:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if ((mp = mpsearch()) == 0)
f0105c88:	85 c0                	test   %eax,%eax
f0105c8a:	0f 85 4c ff ff ff    	jne    f0105bdc <mp_init+0x47>
f0105c90:	e9 a8 01 00 00       	jmp    f0105e3d <mp_init+0x2a8>
		cprintf("SMP: Default configurations not implemented\n");
f0105c95:	83 ec 0c             	sub    $0xc,%esp
f0105c98:	68 70 86 10 f0       	push   $0xf0108670
f0105c9d:	e8 aa dc ff ff       	call   f010394c <cprintf>
f0105ca2:	83 c4 10             	add    $0x10,%esp
f0105ca5:	e9 93 01 00 00       	jmp    f0105e3d <mp_init+0x2a8>
f0105caa:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cad:	68 c4 6b 10 f0       	push   $0xf0106bc4
f0105cb2:	68 90 00 00 00       	push   $0x90
f0105cb7:	68 fd 87 10 f0       	push   $0xf01087fd
f0105cbc:	e8 7f a3 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105cc1:	83 ec 0c             	sub    $0xc,%esp
f0105cc4:	68 a0 86 10 f0       	push   $0xf01086a0
f0105cc9:	e8 7e dc ff ff       	call   f010394c <cprintf>
f0105cce:	83 c4 10             	add    $0x10,%esp
f0105cd1:	e9 67 01 00 00       	jmp    f0105e3d <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105cd6:	0f b6 0b             	movzbl (%ebx),%ecx
f0105cd9:	01 ca                	add    %ecx,%edx
f0105cdb:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105cde:	39 fb                	cmp    %edi,%ebx
f0105ce0:	75 f4                	jne    f0105cd6 <mp_init+0x141>
	if (sum(conf, conf->length) != 0) {
f0105ce2:	84 d2                	test   %dl,%dl
f0105ce4:	75 16                	jne    f0105cfc <mp_init+0x167>
	if (conf->version != 1 && conf->version != 4) {
f0105ce6:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105cea:	80 fa 01             	cmp    $0x1,%dl
f0105ced:	74 05                	je     f0105cf4 <mp_init+0x15f>
f0105cef:	80 fa 04             	cmp    $0x4,%dl
f0105cf2:	75 1d                	jne    f0105d11 <mp_init+0x17c>
f0105cf4:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105cf8:	01 d9                	add    %ebx,%ecx
f0105cfa:	eb 36                	jmp    f0105d32 <mp_init+0x19d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105cfc:	83 ec 0c             	sub    $0xc,%esp
f0105cff:	68 d4 86 10 f0       	push   $0xf01086d4
f0105d04:	e8 43 dc ff ff       	call   f010394c <cprintf>
f0105d09:	83 c4 10             	add    $0x10,%esp
f0105d0c:	e9 2c 01 00 00       	jmp    f0105e3d <mp_init+0x2a8>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105d11:	83 ec 08             	sub    $0x8,%esp
f0105d14:	0f b6 d2             	movzbl %dl,%edx
f0105d17:	52                   	push   %edx
f0105d18:	68 f8 86 10 f0       	push   $0xf01086f8
f0105d1d:	e8 2a dc ff ff       	call   f010394c <cprintf>
f0105d22:	83 c4 10             	add    $0x10,%esp
f0105d25:	e9 13 01 00 00       	jmp    f0105e3d <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105d2a:	0f b6 13             	movzbl (%ebx),%edx
f0105d2d:	01 d0                	add    %edx,%eax
f0105d2f:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105d32:	39 d9                	cmp    %ebx,%ecx
f0105d34:	75 f4                	jne    f0105d2a <mp_init+0x195>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105d36:	02 46 2a             	add    0x2a(%esi),%al
f0105d39:	75 29                	jne    f0105d64 <mp_init+0x1cf>
	if ((conf = mpconfig(&mp)) == 0)
f0105d3b:	81 7d e4 00 00 00 10 	cmpl   $0x10000000,-0x1c(%ebp)
f0105d42:	0f 84 f5 00 00 00    	je     f0105e3d <mp_init+0x2a8>
		return;
	ismp = 1;
f0105d48:	c7 05 00 a0 2c f0 01 	movl   $0x1,0xf02ca000
f0105d4f:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105d52:	8b 46 24             	mov    0x24(%esi),%eax
f0105d55:	a3 00 b0 30 f0       	mov    %eax,0xf030b000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105d5a:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105d62:	eb 4d                	jmp    f0105db1 <mp_init+0x21c>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105d64:	83 ec 0c             	sub    $0xc,%esp
f0105d67:	68 18 87 10 f0       	push   $0xf0108718
f0105d6c:	e8 db db ff ff       	call   f010394c <cprintf>
f0105d71:	83 c4 10             	add    $0x10,%esp
f0105d74:	e9 c4 00 00 00       	jmp    f0105e3d <mp_init+0x2a8>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105d79:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105d7d:	74 11                	je     f0105d90 <mp_init+0x1fb>
				bootcpu = &cpus[ncpu];
f0105d7f:	6b 05 c4 a3 2c f0 74 	imul   $0x74,0xf02ca3c4,%eax
f0105d86:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0105d8b:	a3 c0 a3 2c f0       	mov    %eax,0xf02ca3c0
			if (ncpu < NCPU) {
f0105d90:	a1 c4 a3 2c f0       	mov    0xf02ca3c4,%eax
f0105d95:	83 f8 07             	cmp    $0x7,%eax
f0105d98:	7f 2f                	jg     f0105dc9 <mp_init+0x234>
				cpus[ncpu].cpu_id = ncpu;
f0105d9a:	6b d0 74             	imul   $0x74,%eax,%edx
f0105d9d:	88 82 20 a0 2c f0    	mov    %al,-0xfd35fe0(%edx)
				ncpu++;
f0105da3:	83 c0 01             	add    $0x1,%eax
f0105da6:	a3 c4 a3 2c f0       	mov    %eax,0xf02ca3c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105dab:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105dae:	83 c3 01             	add    $0x1,%ebx
f0105db1:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105db5:	39 d8                	cmp    %ebx,%eax
f0105db7:	76 4b                	jbe    f0105e04 <mp_init+0x26f>
		switch (*p) {
f0105db9:	0f b6 07             	movzbl (%edi),%eax
f0105dbc:	84 c0                	test   %al,%al
f0105dbe:	74 b9                	je     f0105d79 <mp_init+0x1e4>
f0105dc0:	3c 04                	cmp    $0x4,%al
f0105dc2:	77 1c                	ja     f0105de0 <mp_init+0x24b>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105dc4:	83 c7 08             	add    $0x8,%edi
			continue;
f0105dc7:	eb e5                	jmp    f0105dae <mp_init+0x219>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105dc9:	83 ec 08             	sub    $0x8,%esp
f0105dcc:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105dd0:	50                   	push   %eax
f0105dd1:	68 48 87 10 f0       	push   $0xf0108748
f0105dd6:	e8 71 db ff ff       	call   f010394c <cprintf>
f0105ddb:	83 c4 10             	add    $0x10,%esp
f0105dde:	eb cb                	jmp    f0105dab <mp_init+0x216>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105de0:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105de3:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105de6:	50                   	push   %eax
f0105de7:	68 70 87 10 f0       	push   $0xf0108770
f0105dec:	e8 5b db ff ff       	call   f010394c <cprintf>
			ismp = 0;
f0105df1:	c7 05 00 a0 2c f0 00 	movl   $0x0,0xf02ca000
f0105df8:	00 00 00 
			i = conf->entry;
f0105dfb:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105dff:	83 c4 10             	add    $0x10,%esp
f0105e02:	eb aa                	jmp    f0105dae <mp_init+0x219>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105e04:	a1 c0 a3 2c f0       	mov    0xf02ca3c0,%eax
f0105e09:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105e10:	83 3d 00 a0 2c f0 00 	cmpl   $0x0,0xf02ca000
f0105e17:	75 2c                	jne    f0105e45 <mp_init+0x2b0>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0105e19:	c7 05 c4 a3 2c f0 01 	movl   $0x1,0xf02ca3c4
f0105e20:	00 00 00 
		lapicaddr = 0;
f0105e23:	c7 05 00 b0 30 f0 00 	movl   $0x0,0xf030b000
f0105e2a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105e2d:	83 ec 0c             	sub    $0xc,%esp
f0105e30:	68 90 87 10 f0       	push   $0xf0108790
f0105e35:	e8 12 db ff ff       	call   f010394c <cprintf>
		return;
f0105e3a:	83 c4 10             	add    $0x10,%esp
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105e40:	5b                   	pop    %ebx
f0105e41:	5e                   	pop    %esi
f0105e42:	5f                   	pop    %edi
f0105e43:	5d                   	pop    %ebp
f0105e44:	c3                   	ret    
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105e45:	83 ec 04             	sub    $0x4,%esp
f0105e48:	ff 35 c4 a3 2c f0    	pushl  0xf02ca3c4
f0105e4e:	0f b6 00             	movzbl (%eax),%eax
f0105e51:	50                   	push   %eax
f0105e52:	68 17 88 10 f0       	push   $0xf0108817
f0105e57:	e8 f0 da ff ff       	call   f010394c <cprintf>
	if (mp->imcrp) {
f0105e5c:	83 c4 10             	add    $0x10,%esp
f0105e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e62:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105e66:	74 d5                	je     f0105e3d <mp_init+0x2a8>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105e68:	83 ec 0c             	sub    $0xc,%esp
f0105e6b:	68 bc 87 10 f0       	push   $0xf01087bc
f0105e70:	e8 d7 da ff ff       	call   f010394c <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105e75:	b8 70 00 00 00       	mov    $0x70,%eax
f0105e7a:	ba 22 00 00 00       	mov    $0x22,%edx
f0105e7f:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105e80:	ba 23 00 00 00       	mov    $0x23,%edx
f0105e85:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105e86:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105e89:	ee                   	out    %al,(%dx)
f0105e8a:	83 c4 10             	add    $0x10,%esp
f0105e8d:	eb ae                	jmp    f0105e3d <mp_init+0x2a8>

f0105e8f <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0105e8f:	55                   	push   %ebp
f0105e90:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0105e92:	8b 0d 04 b0 30 f0    	mov    0xf030b004,%ecx
f0105e98:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105e9b:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105e9d:	a1 04 b0 30 f0       	mov    0xf030b004,%eax
f0105ea2:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105ea5:	5d                   	pop    %ebp
f0105ea6:	c3                   	ret    

f0105ea7 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105ea7:	55                   	push   %ebp
f0105ea8:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0105eaa:	8b 15 04 b0 30 f0    	mov    0xf030b004,%edx
		return lapic[ID] >> 24;
	return 0;
f0105eb0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0105eb5:	85 d2                	test   %edx,%edx
f0105eb7:	74 06                	je     f0105ebf <cpunum+0x18>
		return lapic[ID] >> 24;
f0105eb9:	8b 42 20             	mov    0x20(%edx),%eax
f0105ebc:	c1 e8 18             	shr    $0x18,%eax
}
f0105ebf:	5d                   	pop    %ebp
f0105ec0:	c3                   	ret    

f0105ec1 <lapic_init>:
	if (!lapicaddr)
f0105ec1:	a1 00 b0 30 f0       	mov    0xf030b000,%eax
f0105ec6:	85 c0                	test   %eax,%eax
f0105ec8:	75 02                	jne    f0105ecc <lapic_init+0xb>
f0105eca:	f3 c3                	repz ret 
{
f0105ecc:	55                   	push   %ebp
f0105ecd:	89 e5                	mov    %esp,%ebp
f0105ecf:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0105ed2:	68 00 10 00 00       	push   $0x1000
f0105ed7:	50                   	push   %eax
f0105ed8:	e8 b2 b4 ff ff       	call   f010138f <mmio_map_region>
f0105edd:	a3 04 b0 30 f0       	mov    %eax,0xf030b004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105ee2:	ba 27 01 00 00       	mov    $0x127,%edx
f0105ee7:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105eec:	e8 9e ff ff ff       	call   f0105e8f <lapicw>
	lapicw(TDCR, X1);
f0105ef1:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105ef6:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105efb:	e8 8f ff ff ff       	call   f0105e8f <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105f00:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105f05:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105f0a:	e8 80 ff ff ff       	call   f0105e8f <lapicw>
	lapicw(TICR, 10000000); 
f0105f0f:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105f14:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105f19:	e8 71 ff ff ff       	call   f0105e8f <lapicw>
	if (thiscpu != bootcpu)
f0105f1e:	e8 84 ff ff ff       	call   f0105ea7 <cpunum>
f0105f23:	6b c0 74             	imul   $0x74,%eax,%eax
f0105f26:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0105f2b:	83 c4 10             	add    $0x10,%esp
f0105f2e:	39 05 c0 a3 2c f0    	cmp    %eax,0xf02ca3c0
f0105f34:	74 0f                	je     f0105f45 <lapic_init+0x84>
		lapicw(LINT0, MASKED);
f0105f36:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f3b:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105f40:	e8 4a ff ff ff       	call   f0105e8f <lapicw>
	lapicw(LINT1, MASKED);
f0105f45:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f4a:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105f4f:	e8 3b ff ff ff       	call   f0105e8f <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105f54:	a1 04 b0 30 f0       	mov    0xf030b004,%eax
f0105f59:	8b 40 30             	mov    0x30(%eax),%eax
f0105f5c:	c1 e8 10             	shr    $0x10,%eax
f0105f5f:	3c 03                	cmp    $0x3,%al
f0105f61:	77 7c                	ja     f0105fdf <lapic_init+0x11e>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105f63:	ba 33 00 00 00       	mov    $0x33,%edx
f0105f68:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105f6d:	e8 1d ff ff ff       	call   f0105e8f <lapicw>
	lapicw(ESR, 0);
f0105f72:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f77:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f7c:	e8 0e ff ff ff       	call   f0105e8f <lapicw>
	lapicw(ESR, 0);
f0105f81:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f86:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f8b:	e8 ff fe ff ff       	call   f0105e8f <lapicw>
	lapicw(EOI, 0);
f0105f90:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f95:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105f9a:	e8 f0 fe ff ff       	call   f0105e8f <lapicw>
	lapicw(ICRHI, 0);
f0105f9f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fa4:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105fa9:	e8 e1 fe ff ff       	call   f0105e8f <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105fae:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105fb3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105fb8:	e8 d2 fe ff ff       	call   f0105e8f <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105fbd:	8b 15 04 b0 30 f0    	mov    0xf030b004,%edx
f0105fc3:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105fc9:	f6 c4 10             	test   $0x10,%ah
f0105fcc:	75 f5                	jne    f0105fc3 <lapic_init+0x102>
	lapicw(TPR, 0);
f0105fce:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fd3:	b8 20 00 00 00       	mov    $0x20,%eax
f0105fd8:	e8 b2 fe ff ff       	call   f0105e8f <lapicw>
}
f0105fdd:	c9                   	leave  
f0105fde:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105fdf:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105fe4:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105fe9:	e8 a1 fe ff ff       	call   f0105e8f <lapicw>
f0105fee:	e9 70 ff ff ff       	jmp    f0105f63 <lapic_init+0xa2>

f0105ff3 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0105ff3:	83 3d 04 b0 30 f0 00 	cmpl   $0x0,0xf030b004
f0105ffa:	74 14                	je     f0106010 <lapic_eoi+0x1d>
{
f0105ffc:	55                   	push   %ebp
f0105ffd:	89 e5                	mov    %esp,%ebp
		lapicw(EOI, 0);
f0105fff:	ba 00 00 00 00       	mov    $0x0,%edx
f0106004:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106009:	e8 81 fe ff ff       	call   f0105e8f <lapicw>
}
f010600e:	5d                   	pop    %ebp
f010600f:	c3                   	ret    
f0106010:	f3 c3                	repz ret 

f0106012 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106012:	55                   	push   %ebp
f0106013:	89 e5                	mov    %esp,%ebp
f0106015:	56                   	push   %esi
f0106016:	53                   	push   %ebx
f0106017:	8b 75 08             	mov    0x8(%ebp),%esi
f010601a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010601d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106022:	ba 70 00 00 00       	mov    $0x70,%edx
f0106027:	ee                   	out    %al,(%dx)
f0106028:	b8 0a 00 00 00       	mov    $0xa,%eax
f010602d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106032:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106033:	83 3d 94 92 2c f0 00 	cmpl   $0x0,0xf02c9294
f010603a:	74 7e                	je     f01060ba <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f010603c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106043:	00 00 
	wrv[1] = addr >> 4;
f0106045:	89 d8                	mov    %ebx,%eax
f0106047:	c1 e8 04             	shr    $0x4,%eax
f010604a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106050:	c1 e6 18             	shl    $0x18,%esi
f0106053:	89 f2                	mov    %esi,%edx
f0106055:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010605a:	e8 30 fe ff ff       	call   f0105e8f <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f010605f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106064:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106069:	e8 21 fe ff ff       	call   f0105e8f <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f010606e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106073:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106078:	e8 12 fe ff ff       	call   f0105e8f <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010607d:	c1 eb 0c             	shr    $0xc,%ebx
f0106080:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106083:	89 f2                	mov    %esi,%edx
f0106085:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010608a:	e8 00 fe ff ff       	call   f0105e8f <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010608f:	89 da                	mov    %ebx,%edx
f0106091:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106096:	e8 f4 fd ff ff       	call   f0105e8f <lapicw>
		lapicw(ICRHI, apicid << 24);
f010609b:	89 f2                	mov    %esi,%edx
f010609d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01060a2:	e8 e8 fd ff ff       	call   f0105e8f <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01060a7:	89 da                	mov    %ebx,%edx
f01060a9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01060ae:	e8 dc fd ff ff       	call   f0105e8f <lapicw>
		microdelay(200);
	}
}
f01060b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01060b6:	5b                   	pop    %ebx
f01060b7:	5e                   	pop    %esi
f01060b8:	5d                   	pop    %ebp
f01060b9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01060ba:	68 67 04 00 00       	push   $0x467
f01060bf:	68 c4 6b 10 f0       	push   $0xf0106bc4
f01060c4:	68 98 00 00 00       	push   $0x98
f01060c9:	68 34 88 10 f0       	push   $0xf0108834
f01060ce:	e8 6d 9f ff ff       	call   f0100040 <_panic>

f01060d3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f01060d3:	55                   	push   %ebp
f01060d4:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f01060d6:	8b 55 08             	mov    0x8(%ebp),%edx
f01060d9:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f01060df:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01060e4:	e8 a6 fd ff ff       	call   f0105e8f <lapicw>
	while (lapic[ICRLO] & DELIVS)
f01060e9:	8b 15 04 b0 30 f0    	mov    0xf030b004,%edx
f01060ef:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01060f5:	f6 c4 10             	test   $0x10,%ah
f01060f8:	75 f5                	jne    f01060ef <lapic_ipi+0x1c>
		;
}
f01060fa:	5d                   	pop    %ebp
f01060fb:	c3                   	ret    

f01060fc <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f01060fc:	55                   	push   %ebp
f01060fd:	89 e5                	mov    %esp,%ebp
f01060ff:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106108:	8b 55 0c             	mov    0xc(%ebp),%edx
f010610b:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010610e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106115:	5d                   	pop    %ebp
f0106116:	c3                   	ret    

f0106117 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106117:	55                   	push   %ebp
f0106118:	89 e5                	mov    %esp,%ebp
f010611a:	56                   	push   %esi
f010611b:	53                   	push   %ebx
f010611c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010611f:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106122:	75 07                	jne    f010612b <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0106124:	ba 01 00 00 00       	mov    $0x1,%edx
f0106129:	eb 34                	jmp    f010615f <spin_lock+0x48>
f010612b:	8b 73 08             	mov    0x8(%ebx),%esi
f010612e:	e8 74 fd ff ff       	call   f0105ea7 <cpunum>
f0106133:	6b c0 74             	imul   $0x74,%eax,%eax
f0106136:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f010613b:	39 c6                	cmp    %eax,%esi
f010613d:	75 e5                	jne    f0106124 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010613f:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106142:	e8 60 fd ff ff       	call   f0105ea7 <cpunum>
f0106147:	83 ec 0c             	sub    $0xc,%esp
f010614a:	53                   	push   %ebx
f010614b:	50                   	push   %eax
f010614c:	68 44 88 10 f0       	push   $0xf0108844
f0106151:	6a 41                	push   $0x41
f0106153:	68 a6 88 10 f0       	push   $0xf01088a6
f0106158:	e8 e3 9e ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f010615d:	f3 90                	pause  
f010615f:	89 d0                	mov    %edx,%eax
f0106161:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f0106164:	85 c0                	test   %eax,%eax
f0106166:	75 f5                	jne    f010615d <spin_lock+0x46>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106168:	e8 3a fd ff ff       	call   f0105ea7 <cpunum>
f010616d:	6b c0 74             	imul   $0x74,%eax,%eax
f0106170:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0106175:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0106178:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010617b:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f010617d:	b8 00 00 00 00       	mov    $0x0,%eax
f0106182:	eb 0b                	jmp    f010618f <spin_lock+0x78>
		pcs[i] = ebp[1];          // saved %eip
f0106184:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106187:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f010618a:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f010618c:	83 c0 01             	add    $0x1,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f010618f:	83 f8 09             	cmp    $0x9,%eax
f0106192:	7f 14                	jg     f01061a8 <spin_lock+0x91>
f0106194:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f010619a:	77 e8                	ja     f0106184 <spin_lock+0x6d>
f010619c:	eb 0a                	jmp    f01061a8 <spin_lock+0x91>
		pcs[i] = 0;
f010619e:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f01061a5:	83 c0 01             	add    $0x1,%eax
f01061a8:	83 f8 09             	cmp    $0x9,%eax
f01061ab:	7e f1                	jle    f010619e <spin_lock+0x87>
#endif
}
f01061ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01061b0:	5b                   	pop    %ebx
f01061b1:	5e                   	pop    %esi
f01061b2:	5d                   	pop    %ebp
f01061b3:	c3                   	ret    

f01061b4 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01061b4:	55                   	push   %ebp
f01061b5:	89 e5                	mov    %esp,%ebp
f01061b7:	57                   	push   %edi
f01061b8:	56                   	push   %esi
f01061b9:	53                   	push   %ebx
f01061ba:	83 ec 4c             	sub    $0x4c,%esp
f01061bd:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f01061c0:	83 3e 00             	cmpl   $0x0,(%esi)
f01061c3:	75 35                	jne    f01061fa <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f01061c5:	83 ec 04             	sub    $0x4,%esp
f01061c8:	6a 28                	push   $0x28
f01061ca:	8d 46 0c             	lea    0xc(%esi),%eax
f01061cd:	50                   	push   %eax
f01061ce:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f01061d1:	53                   	push   %ebx
f01061d2:	e8 fa f6 ff ff       	call   f01058d1 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f01061d7:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f01061da:	0f b6 38             	movzbl (%eax),%edi
f01061dd:	8b 76 04             	mov    0x4(%esi),%esi
f01061e0:	e8 c2 fc ff ff       	call   f0105ea7 <cpunum>
f01061e5:	57                   	push   %edi
f01061e6:	56                   	push   %esi
f01061e7:	50                   	push   %eax
f01061e8:	68 70 88 10 f0       	push   $0xf0108870
f01061ed:	e8 5a d7 ff ff       	call   f010394c <cprintf>
f01061f2:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01061f5:	8d 7d a8             	lea    -0x58(%ebp),%edi
f01061f8:	eb 61                	jmp    f010625b <spin_unlock+0xa7>
	return lock->locked && lock->cpu == thiscpu;
f01061fa:	8b 5e 08             	mov    0x8(%esi),%ebx
f01061fd:	e8 a5 fc ff ff       	call   f0105ea7 <cpunum>
f0106202:	6b c0 74             	imul   $0x74,%eax,%eax
f0106205:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
	if (!holding(lk)) {
f010620a:	39 c3                	cmp    %eax,%ebx
f010620c:	75 b7                	jne    f01061c5 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f010620e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106215:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f010621c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106221:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106224:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106227:	5b                   	pop    %ebx
f0106228:	5e                   	pop    %esi
f0106229:	5f                   	pop    %edi
f010622a:	5d                   	pop    %ebp
f010622b:	c3                   	ret    
					pcs[i] - info.eip_fn_addr);
f010622c:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f010622e:	83 ec 04             	sub    $0x4,%esp
f0106231:	89 c2                	mov    %eax,%edx
f0106233:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106236:	52                   	push   %edx
f0106237:	ff 75 b0             	pushl  -0x50(%ebp)
f010623a:	ff 75 b4             	pushl  -0x4c(%ebp)
f010623d:	ff 75 ac             	pushl  -0x54(%ebp)
f0106240:	ff 75 a8             	pushl  -0x58(%ebp)
f0106243:	50                   	push   %eax
f0106244:	68 b6 88 10 f0       	push   $0xf01088b6
f0106249:	e8 fe d6 ff ff       	call   f010394c <cprintf>
f010624e:	83 c4 20             	add    $0x20,%esp
f0106251:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106254:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106257:	39 c3                	cmp    %eax,%ebx
f0106259:	74 2d                	je     f0106288 <spin_unlock+0xd4>
f010625b:	89 de                	mov    %ebx,%esi
f010625d:	8b 03                	mov    (%ebx),%eax
f010625f:	85 c0                	test   %eax,%eax
f0106261:	74 25                	je     f0106288 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106263:	83 ec 08             	sub    $0x8,%esp
f0106266:	57                   	push   %edi
f0106267:	50                   	push   %eax
f0106268:	e8 a5 ea ff ff       	call   f0104d12 <debuginfo_eip>
f010626d:	83 c4 10             	add    $0x10,%esp
f0106270:	85 c0                	test   %eax,%eax
f0106272:	79 b8                	jns    f010622c <spin_unlock+0x78>
				cprintf("  %08x\n", pcs[i]);
f0106274:	83 ec 08             	sub    $0x8,%esp
f0106277:	ff 36                	pushl  (%esi)
f0106279:	68 cd 88 10 f0       	push   $0xf01088cd
f010627e:	e8 c9 d6 ff ff       	call   f010394c <cprintf>
f0106283:	83 c4 10             	add    $0x10,%esp
f0106286:	eb c9                	jmp    f0106251 <spin_unlock+0x9d>
		panic("spin_unlock");
f0106288:	83 ec 04             	sub    $0x4,%esp
f010628b:	68 d5 88 10 f0       	push   $0xf01088d5
f0106290:	6a 67                	push   $0x67
f0106292:	68 a6 88 10 f0       	push   $0xf01088a6
f0106297:	e8 a4 9d ff ff       	call   f0100040 <_panic>

f010629c <e1000_attach>:
            (E1000_DEFAULT_TIPG_IPGR2 << E1000_TIPG_IPGR2_SHIFT);
}

int
e1000_attach(struct pci_func *pcif)
{
f010629c:	55                   	push   %ebp
f010629d:	89 e5                	mov    %esp,%ebp
f010629f:	53                   	push   %ebx
f01062a0:	83 ec 10             	sub    $0x10,%esp
f01062a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    pci_func_enable(pcif);
f01062a6:	53                   	push   %ebx
f01062a7:	e8 02 05 00 00       	call   f01067ae <pci_func_enable>
    e1000_base = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f01062ac:	83 c4 08             	add    $0x8,%esp
f01062af:	ff 73 2c             	pushl  0x2c(%ebx)
f01062b2:	ff 73 14             	pushl  0x14(%ebx)
f01062b5:	e8 d5 b0 ff ff       	call   f010138f <mmio_map_region>
f01062ba:	a3 08 b0 30 f0       	mov    %eax,0xf030b008
    cprintf("e1000: status 0x%08x\n", E1000_REG(E1000_STATUS));
f01062bf:	8b 40 08             	mov    0x8(%eax),%eax
f01062c2:	83 c4 08             	add    $0x8,%esp
f01062c5:	50                   	push   %eax
f01062c6:	68 ed 88 10 f0       	push   $0xf01088ed
f01062cb:	e8 7c d6 ff ff       	call   f010394c <cprintf>
    memset(e1000_tx_queue, 0, sizeof(e1000_tx_queue));
f01062d0:	83 c4 0c             	add    $0xc,%esp
f01062d3:	68 00 04 00 00       	push   $0x400
f01062d8:	6a 00                	push   $0x0
f01062da:	68 80 8e 2c f0       	push   $0xf02c8e80
f01062df:	e8 a0 f5 ff ff       	call   f0105884 <memset>
f01062e4:	b8 80 0e 2b f0       	mov    $0xf02b0e80,%eax
f01062e9:	bb 80 8e 2c f0       	mov    $0xf02c8e80,%ebx
f01062ee:	83 c4 10             	add    $0x10,%esp
f01062f1:	ba 80 8e 2c f0       	mov    $0xf02c8e80,%edx
	if ((uint32_t)kva < KERNBASE)
f01062f6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01062fb:	0f 86 b5 00 00 00    	jbe    f01063b6 <e1000_attach+0x11a>
        e1000_tx_queue[i].addr = PADDR(e1000_tx_buf[i]);
f0106301:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
f0106307:	89 0a                	mov    %ecx,(%edx)
f0106309:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
f0106310:	05 00 06 00 00       	add    $0x600,%eax
f0106315:	83 c2 10             	add    $0x10,%edx
    for (i = 0; i < NTXDESC; i++) {
f0106318:	39 d8                	cmp    %ebx,%eax
f010631a:	75 da                	jne    f01062f6 <e1000_attach+0x5a>
    E1000_REG(E1000_TDBAL) = PADDR(e1000_tx_queue);
f010631c:	a1 08 b0 30 f0       	mov    0xf030b008,%eax
f0106321:	ba 80 8e 2c f0       	mov    $0xf02c8e80,%edx
f0106326:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010632c:	0f 86 96 00 00 00    	jbe    f01063c8 <e1000_attach+0x12c>
f0106332:	c7 80 00 38 00 00 80 	movl   $0x2c8e80,0x3800(%eax)
f0106339:	8e 2c 00 
    E1000_REG(E1000_TDBAH) = 0;
f010633c:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f0106343:	00 00 00 
    E1000_REG(E1000_TDLEN) = sizeof(e1000_tx_queue);
f0106346:	c7 80 08 38 00 00 00 	movl   $0x400,0x3808(%eax)
f010634d:	04 00 00 
    E1000_REG(E1000_TDH) = 0;
f0106350:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f0106357:	00 00 00 
    E1000_REG(E1000_TDT) = 0;
f010635a:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f0106361:	00 00 00 
    E1000_REG(E1000_TCTL) &= ~(E1000_TCTL_CT | E1000_TCTL_COLD);
f0106364:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f010636a:	81 e2 0f 00 c0 ff    	and    $0xffc0000f,%edx
f0106370:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
    E1000_REG(E1000_TCTL) |= E1000_TCTL_EN | E1000_TCTL_PSP |
f0106376:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f010637c:	81 ca 0a 01 04 00    	or     $0x4010a,%edx
f0106382:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
    E1000_REG(E1000_TIPG) &= ~(E1000_TIPG_IPGT_MASK | E1000_TIPG_IPGR1_MASK | E1000_TIPG_IPGR2_MASK);
f0106388:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
f010638e:	81 e2 00 00 00 c0    	and    $0xc0000000,%edx
f0106394:	89 90 10 04 00 00    	mov    %edx,0x410(%eax)
    E1000_REG(E1000_TIPG) |= E1000_DEFAULT_TIPG_IPGT |
f010639a:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
f01063a0:	81 ca 0a 10 60 00    	or     $0x60100a,%edx
f01063a6:	89 90 10 04 00 00    	mov    %edx,0x410(%eax)

    e1000_tx_init();

    return 0;
f01063ac:	b8 00 00 00 00       	mov    $0x0,%eax
f01063b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01063b4:	c9                   	leave  
f01063b5:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01063b6:	50                   	push   %eax
f01063b7:	68 e8 6b 10 f0       	push   $0xf0106be8
f01063bc:	6a 17                	push   $0x17
f01063be:	68 03 89 10 f0       	push   $0xf0108903
f01063c3:	e8 78 9c ff ff       	call   f0100040 <_panic>
f01063c8:	52                   	push   %edx
f01063c9:	68 e8 6b 10 f0       	push   $0xf0106be8
f01063ce:	6a 1b                	push   $0x1b
f01063d0:	68 03 89 10 f0       	push   $0xf0108903
f01063d5:	e8 66 9c ff ff       	call   f0100040 <_panic>

f01063da <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f01063da:	55                   	push   %ebp
f01063db:	89 e5                	mov    %esp,%ebp
f01063dd:	57                   	push   %edi
f01063de:	56                   	push   %esi
f01063df:	53                   	push   %ebx
f01063e0:	83 ec 1c             	sub    $0x1c,%esp
f01063e3:	8b 7d 10             	mov    0x10(%ebp),%edi
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f01063e6:	eb 03                	jmp    f01063eb <pci_attach_match+0x11>
f01063e8:	83 c7 0c             	add    $0xc,%edi
f01063eb:	89 fe                	mov    %edi,%esi
f01063ed:	8b 47 08             	mov    0x8(%edi),%eax
f01063f0:	85 c0                	test   %eax,%eax
f01063f2:	74 3f                	je     f0106433 <pci_attach_match+0x59>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f01063f4:	8b 1f                	mov    (%edi),%ebx
f01063f6:	3b 5d 08             	cmp    0x8(%ebp),%ebx
f01063f9:	75 ed                	jne    f01063e8 <pci_attach_match+0xe>
f01063fb:	8b 56 04             	mov    0x4(%esi),%edx
f01063fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0106401:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0106404:	75 e2                	jne    f01063e8 <pci_attach_match+0xe>
			int r = list[i].attachfn(pcif);
f0106406:	83 ec 0c             	sub    $0xc,%esp
f0106409:	ff 75 14             	pushl  0x14(%ebp)
f010640c:	ff d0                	call   *%eax
			if (r > 0)
f010640e:	83 c4 10             	add    $0x10,%esp
f0106411:	85 c0                	test   %eax,%eax
f0106413:	7f 1e                	jg     f0106433 <pci_attach_match+0x59>
				return r;
			if (r < 0)
f0106415:	85 c0                	test   %eax,%eax
f0106417:	79 cf                	jns    f01063e8 <pci_attach_match+0xe>
				cprintf("pci_attach_match: attaching "
f0106419:	83 ec 0c             	sub    $0xc,%esp
f010641c:	50                   	push   %eax
f010641d:	ff 76 08             	pushl  0x8(%esi)
f0106420:	ff 75 e4             	pushl  -0x1c(%ebp)
f0106423:	53                   	push   %ebx
f0106424:	68 10 89 10 f0       	push   $0xf0108910
f0106429:	e8 1e d5 ff ff       	call   f010394c <cprintf>
f010642e:	83 c4 20             	add    $0x20,%esp
f0106431:	eb b5                	jmp    f01063e8 <pci_attach_match+0xe>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0106433:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106436:	5b                   	pop    %ebx
f0106437:	5e                   	pop    %esi
f0106438:	5f                   	pop    %edi
f0106439:	5d                   	pop    %ebp
f010643a:	c3                   	ret    

f010643b <pci_conf1_set_addr>:
{
f010643b:	55                   	push   %ebp
f010643c:	89 e5                	mov    %esp,%ebp
f010643e:	53                   	push   %ebx
f010643f:	83 ec 04             	sub    $0x4,%esp
f0106442:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0106445:	3d ff 00 00 00       	cmp    $0xff,%eax
f010644a:	77 37                	ja     f0106483 <pci_conf1_set_addr+0x48>
	assert(dev < 32);
f010644c:	83 fa 1f             	cmp    $0x1f,%edx
f010644f:	77 48                	ja     f0106499 <pci_conf1_set_addr+0x5e>
	assert(func < 8);
f0106451:	83 f9 07             	cmp    $0x7,%ecx
f0106454:	77 59                	ja     f01064af <pci_conf1_set_addr+0x74>
	assert(offset < 256);
f0106456:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f010645c:	77 67                	ja     f01064c5 <pci_conf1_set_addr+0x8a>
	assert((offset & 0x3) == 0);
f010645e:	f6 c3 03             	test   $0x3,%bl
f0106461:	75 78                	jne    f01064db <pci_conf1_set_addr+0xa0>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106463:	c1 e1 08             	shl    $0x8,%ecx
	uint32_t v = (1 << 31) |		// config-space
f0106466:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
f010646c:	09 d9                	or     %ebx,%ecx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f010646e:	c1 e2 0b             	shl    $0xb,%edx
	uint32_t v = (1 << 31) |		// config-space
f0106471:	09 d1                	or     %edx,%ecx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106473:	c1 e0 10             	shl    $0x10,%eax
	uint32_t v = (1 << 31) |		// config-space
f0106476:	09 c8                	or     %ecx,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106478:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f010647d:	ef                   	out    %eax,(%dx)
}
f010647e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106481:	c9                   	leave  
f0106482:	c3                   	ret    
	assert(bus < 256);
f0106483:	68 68 8a 10 f0       	push   $0xf0108a68
f0106488:	68 ff 7a 10 f0       	push   $0xf0107aff
f010648d:	6a 2c                	push   $0x2c
f010648f:	68 72 8a 10 f0       	push   $0xf0108a72
f0106494:	e8 a7 9b ff ff       	call   f0100040 <_panic>
	assert(dev < 32);
f0106499:	68 7d 8a 10 f0       	push   $0xf0108a7d
f010649e:	68 ff 7a 10 f0       	push   $0xf0107aff
f01064a3:	6a 2d                	push   $0x2d
f01064a5:	68 72 8a 10 f0       	push   $0xf0108a72
f01064aa:	e8 91 9b ff ff       	call   f0100040 <_panic>
	assert(func < 8);
f01064af:	68 86 8a 10 f0       	push   $0xf0108a86
f01064b4:	68 ff 7a 10 f0       	push   $0xf0107aff
f01064b9:	6a 2e                	push   $0x2e
f01064bb:	68 72 8a 10 f0       	push   $0xf0108a72
f01064c0:	e8 7b 9b ff ff       	call   f0100040 <_panic>
	assert(offset < 256);
f01064c5:	68 8f 8a 10 f0       	push   $0xf0108a8f
f01064ca:	68 ff 7a 10 f0       	push   $0xf0107aff
f01064cf:	6a 2f                	push   $0x2f
f01064d1:	68 72 8a 10 f0       	push   $0xf0108a72
f01064d6:	e8 65 9b ff ff       	call   f0100040 <_panic>
	assert((offset & 0x3) == 0);
f01064db:	68 9c 8a 10 f0       	push   $0xf0108a9c
f01064e0:	68 ff 7a 10 f0       	push   $0xf0107aff
f01064e5:	6a 30                	push   $0x30
f01064e7:	68 72 8a 10 f0       	push   $0xf0108a72
f01064ec:	e8 4f 9b ff ff       	call   f0100040 <_panic>

f01064f1 <pci_conf_read>:
{
f01064f1:	55                   	push   %ebp
f01064f2:	89 e5                	mov    %esp,%ebp
f01064f4:	53                   	push   %ebx
f01064f5:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01064f8:	8b 48 08             	mov    0x8(%eax),%ecx
f01064fb:	8b 58 04             	mov    0x4(%eax),%ebx
f01064fe:	8b 00                	mov    (%eax),%eax
f0106500:	8b 40 04             	mov    0x4(%eax),%eax
f0106503:	52                   	push   %edx
f0106504:	89 da                	mov    %ebx,%edx
f0106506:	e8 30 ff ff ff       	call   f010643b <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f010650b:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106510:	ed                   	in     (%dx),%eax
}
f0106511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106514:	c9                   	leave  
f0106515:	c3                   	ret    

f0106516 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0106516:	55                   	push   %ebp
f0106517:	89 e5                	mov    %esp,%ebp
f0106519:	57                   	push   %edi
f010651a:	56                   	push   %esi
f010651b:	53                   	push   %ebx
f010651c:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0106522:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0106524:	6a 48                	push   $0x48
f0106526:	6a 00                	push   $0x0
f0106528:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010652b:	50                   	push   %eax
f010652c:	e8 53 f3 ff ff       	call   f0105884 <memset>
	df.bus = bus;
f0106531:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106534:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f010653b:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f010653e:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0106545:	00 00 00 
f0106548:	e9 25 01 00 00       	jmp    f0106672 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010654d:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0106553:	83 ec 08             	sub    $0x8,%esp
f0106556:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f010655a:	57                   	push   %edi
f010655b:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f010655c:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f010655f:	0f b6 c0             	movzbl %al,%eax
f0106562:	50                   	push   %eax
f0106563:	51                   	push   %ecx
f0106564:	89 d0                	mov    %edx,%eax
f0106566:	c1 e8 10             	shr    $0x10,%eax
f0106569:	50                   	push   %eax
f010656a:	0f b7 d2             	movzwl %dx,%edx
f010656d:	52                   	push   %edx
f010656e:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0106574:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f010657a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0106580:	ff 70 04             	pushl  0x4(%eax)
f0106583:	68 3c 89 10 f0       	push   $0xf010893c
f0106588:	e8 bf d3 ff ff       	call   f010394c <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f010658d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f0106593:	83 c4 30             	add    $0x30,%esp
f0106596:	53                   	push   %ebx
f0106597:	68 0c 44 12 f0       	push   $0xf012440c
				 PCI_SUBCLASS(f->dev_class),
f010659c:	89 c2                	mov    %eax,%edx
f010659e:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f01065a1:	0f b6 d2             	movzbl %dl,%edx
f01065a4:	52                   	push   %edx
f01065a5:	c1 e8 18             	shr    $0x18,%eax
f01065a8:	50                   	push   %eax
f01065a9:	e8 2c fe ff ff       	call   f01063da <pci_attach_match>
				 &pci_attach_class[0], f) ||
f01065ae:	83 c4 10             	add    $0x10,%esp
f01065b1:	85 c0                	test   %eax,%eax
f01065b3:	0f 84 88 00 00 00    	je     f0106641 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f01065b9:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01065c0:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01065c6:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f01065cc:	0f 83 92 00 00 00    	jae    f0106664 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f01065d2:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f01065d8:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f01065de:	b9 12 00 00 00       	mov    $0x12,%ecx
f01065e3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f01065e5:	ba 00 00 00 00       	mov    $0x0,%edx
f01065ea:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f01065f0:	e8 fc fe ff ff       	call   f01064f1 <pci_conf_read>
f01065f5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f01065fb:	66 83 f8 ff          	cmp    $0xffff,%ax
f01065ff:	74 b8                	je     f01065b9 <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0106601:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0106606:	89 d8                	mov    %ebx,%eax
f0106608:	e8 e4 fe ff ff       	call   f01064f1 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f010660d:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0106610:	ba 08 00 00 00       	mov    $0x8,%edx
f0106615:	89 d8                	mov    %ebx,%eax
f0106617:	e8 d5 fe ff ff       	call   f01064f1 <pci_conf_read>
f010661c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0106622:	89 c1                	mov    %eax,%ecx
f0106624:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0106627:	be b0 8a 10 f0       	mov    $0xf0108ab0,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f010662c:	83 f9 06             	cmp    $0x6,%ecx
f010662f:	0f 87 18 ff ff ff    	ja     f010654d <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0106635:	8b 34 8d 24 8b 10 f0 	mov    -0xfef74dc(,%ecx,4),%esi
f010663c:	e9 0c ff ff ff       	jmp    f010654d <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0106641:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0106647:	53                   	push   %ebx
f0106648:	68 f4 43 12 f0       	push   $0xf01243f4
f010664d:	89 c2                	mov    %eax,%edx
f010664f:	c1 ea 10             	shr    $0x10,%edx
f0106652:	52                   	push   %edx
f0106653:	0f b7 c0             	movzwl %ax,%eax
f0106656:	50                   	push   %eax
f0106657:	e8 7e fd ff ff       	call   f01063da <pci_attach_match>
f010665c:	83 c4 10             	add    $0x10,%esp
f010665f:	e9 55 ff ff ff       	jmp    f01065b9 <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106664:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0106667:	83 c0 01             	add    $0x1,%eax
f010666a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f010666d:	83 f8 1f             	cmp    $0x1f,%eax
f0106670:	77 5c                	ja     f01066ce <pci_scan_bus+0x1b8>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0106672:	ba 0c 00 00 00       	mov    $0xc,%edx
f0106677:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010667a:	e8 72 fe ff ff       	call   f01064f1 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f010667f:	89 c2                	mov    %eax,%edx
f0106681:	c1 ea 10             	shr    $0x10,%edx
f0106684:	83 e2 7f             	and    $0x7f,%edx
f0106687:	83 fa 01             	cmp    $0x1,%edx
f010668a:	77 d8                	ja     f0106664 <pci_scan_bus+0x14e>
		totaldev++;
f010668c:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0106693:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0106699:	8d 75 a0             	lea    -0x60(%ebp),%esi
f010669c:	b9 12 00 00 00       	mov    $0x12,%ecx
f01066a1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01066a3:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f01066aa:	00 00 00 
f01066ad:	25 00 00 80 00       	and    $0x800000,%eax
f01066b2:	83 f8 01             	cmp    $0x1,%eax
f01066b5:	19 c0                	sbb    %eax,%eax
f01066b7:	83 e0 f9             	and    $0xfffffff9,%eax
f01066ba:	83 c0 08             	add    $0x8,%eax
f01066bd:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01066c3:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01066c9:	e9 f2 fe ff ff       	jmp    f01065c0 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f01066ce:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f01066d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01066d7:	5b                   	pop    %ebx
f01066d8:	5e                   	pop    %esi
f01066d9:	5f                   	pop    %edi
f01066da:	5d                   	pop    %ebp
f01066db:	c3                   	ret    

f01066dc <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f01066dc:	55                   	push   %ebp
f01066dd:	89 e5                	mov    %esp,%ebp
f01066df:	57                   	push   %edi
f01066e0:	56                   	push   %esi
f01066e1:	53                   	push   %ebx
f01066e2:	83 ec 1c             	sub    $0x1c,%esp
f01066e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01066e8:	ba 1c 00 00 00       	mov    $0x1c,%edx
f01066ed:	89 d8                	mov    %ebx,%eax
f01066ef:	e8 fd fd ff ff       	call   f01064f1 <pci_conf_read>
f01066f4:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f01066f6:	ba 18 00 00 00       	mov    $0x18,%edx
f01066fb:	89 d8                	mov    %ebx,%eax
f01066fd:	e8 ef fd ff ff       	call   f01064f1 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0106702:	83 e7 0f             	and    $0xf,%edi
f0106705:	83 ff 01             	cmp    $0x1,%edi
f0106708:	74 56                	je     f0106760 <pci_bridge_attach+0x84>
f010670a:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f010670c:	83 ec 04             	sub    $0x4,%esp
f010670f:	6a 08                	push   $0x8
f0106711:	6a 00                	push   $0x0
f0106713:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0106716:	57                   	push   %edi
f0106717:	e8 68 f1 ff ff       	call   f0105884 <memset>
	nbus.parent_bridge = pcif;
f010671c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f010671f:	89 f0                	mov    %esi,%eax
f0106721:	0f b6 c4             	movzbl %ah,%eax
f0106724:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0106727:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f010672a:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f010672d:	89 f1                	mov    %esi,%ecx
f010672f:	0f b6 f1             	movzbl %cl,%esi
f0106732:	56                   	push   %esi
f0106733:	50                   	push   %eax
f0106734:	ff 73 08             	pushl  0x8(%ebx)
f0106737:	ff 73 04             	pushl  0x4(%ebx)
f010673a:	8b 03                	mov    (%ebx),%eax
f010673c:	ff 70 04             	pushl  0x4(%eax)
f010673f:	68 ac 89 10 f0       	push   $0xf01089ac
f0106744:	e8 03 d2 ff ff       	call   f010394c <cprintf>

	pci_scan_bus(&nbus);
f0106749:	83 c4 20             	add    $0x20,%esp
f010674c:	89 f8                	mov    %edi,%eax
f010674e:	e8 c3 fd ff ff       	call   f0106516 <pci_scan_bus>
	return 1;
f0106753:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0106758:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010675b:	5b                   	pop    %ebx
f010675c:	5e                   	pop    %esi
f010675d:	5f                   	pop    %edi
f010675e:	5d                   	pop    %ebp
f010675f:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0106760:	ff 73 08             	pushl  0x8(%ebx)
f0106763:	ff 73 04             	pushl  0x4(%ebx)
f0106766:	8b 03                	mov    (%ebx),%eax
f0106768:	ff 70 04             	pushl  0x4(%eax)
f010676b:	68 78 89 10 f0       	push   $0xf0108978
f0106770:	e8 d7 d1 ff ff       	call   f010394c <cprintf>
		return 0;
f0106775:	83 c4 10             	add    $0x10,%esp
f0106778:	b8 00 00 00 00       	mov    $0x0,%eax
f010677d:	eb d9                	jmp    f0106758 <pci_bridge_attach+0x7c>

f010677f <pci_conf_write>:
{
f010677f:	55                   	push   %ebp
f0106780:	89 e5                	mov    %esp,%ebp
f0106782:	56                   	push   %esi
f0106783:	53                   	push   %ebx
f0106784:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106786:	8b 48 08             	mov    0x8(%eax),%ecx
f0106789:	8b 70 04             	mov    0x4(%eax),%esi
f010678c:	8b 00                	mov    (%eax),%eax
f010678e:	8b 40 04             	mov    0x4(%eax),%eax
f0106791:	83 ec 0c             	sub    $0xc,%esp
f0106794:	52                   	push   %edx
f0106795:	89 f2                	mov    %esi,%edx
f0106797:	e8 9f fc ff ff       	call   f010643b <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010679c:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01067a1:	89 d8                	mov    %ebx,%eax
f01067a3:	ef                   	out    %eax,(%dx)
}
f01067a4:	83 c4 10             	add    $0x10,%esp
f01067a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01067aa:	5b                   	pop    %ebx
f01067ab:	5e                   	pop    %esi
f01067ac:	5d                   	pop    %ebp
f01067ad:	c3                   	ret    

f01067ae <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f01067ae:	55                   	push   %ebp
f01067af:	89 e5                	mov    %esp,%ebp
f01067b1:	57                   	push   %edi
f01067b2:	56                   	push   %esi
f01067b3:	53                   	push   %ebx
f01067b4:	83 ec 2c             	sub    $0x2c,%esp
f01067b7:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f01067ba:	b9 07 00 00 00       	mov    $0x7,%ecx
f01067bf:	ba 04 00 00 00       	mov    $0x4,%edx
f01067c4:	89 f8                	mov    %edi,%eax
f01067c6:	e8 b4 ff ff ff       	call   f010677f <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01067cb:	be 10 00 00 00       	mov    $0x10,%esi
f01067d0:	eb 27                	jmp    f01067f9 <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01067d2:	89 c3                	mov    %eax,%ebx
f01067d4:	83 e3 fc             	and    $0xfffffffc,%ebx
f01067d7:	f7 db                	neg    %ebx
f01067d9:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f01067db:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01067de:	83 e0 fc             	and    $0xfffffffc,%eax
f01067e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f01067e4:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f01067eb:	eb 74                	jmp    f0106861 <pci_func_enable+0xb3>
	     bar += bar_width)
f01067ed:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01067f0:	83 fe 27             	cmp    $0x27,%esi
f01067f3:	0f 87 c4 00 00 00    	ja     f01068bd <pci_func_enable+0x10f>
		uint32_t oldv = pci_conf_read(f, bar);
f01067f9:	89 f2                	mov    %esi,%edx
f01067fb:	89 f8                	mov    %edi,%eax
f01067fd:	e8 ef fc ff ff       	call   f01064f1 <pci_conf_read>
f0106802:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0106805:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f010680a:	89 f2                	mov    %esi,%edx
f010680c:	89 f8                	mov    %edi,%eax
f010680e:	e8 6c ff ff ff       	call   f010677f <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0106813:	89 f2                	mov    %esi,%edx
f0106815:	89 f8                	mov    %edi,%eax
f0106817:	e8 d5 fc ff ff       	call   f01064f1 <pci_conf_read>
		bar_width = 4;
f010681c:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0106823:	85 c0                	test   %eax,%eax
f0106825:	74 c6                	je     f01067ed <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0106827:	8d 4e f0             	lea    -0x10(%esi),%ecx
f010682a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010682d:	c1 e9 02             	shr    $0x2,%ecx
f0106830:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0106833:	a8 01                	test   $0x1,%al
f0106835:	75 9b                	jne    f01067d2 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0106837:	89 c2                	mov    %eax,%edx
f0106839:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f010683c:	83 fa 04             	cmp    $0x4,%edx
f010683f:	0f 94 c1             	sete   %cl
f0106842:	0f b6 c9             	movzbl %cl,%ecx
f0106845:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f010684c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f010684f:	89 c3                	mov    %eax,%ebx
f0106851:	83 e3 f0             	and    $0xfffffff0,%ebx
f0106854:	f7 db                	neg    %ebx
f0106856:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0106858:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010685b:	83 e0 f0             	and    $0xfffffff0,%eax
f010685e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0106861:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106864:	89 f2                	mov    %esi,%edx
f0106866:	89 f8                	mov    %edi,%eax
f0106868:	e8 12 ff ff ff       	call   f010677f <pci_conf_write>
f010686d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0106870:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0106872:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106875:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0106878:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f010687b:	85 db                	test   %ebx,%ebx
f010687d:	0f 84 6a ff ff ff    	je     f01067ed <pci_func_enable+0x3f>
f0106883:	85 d2                	test   %edx,%edx
f0106885:	0f 85 62 ff ff ff    	jne    f01067ed <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010688b:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f010688e:	83 ec 0c             	sub    $0xc,%esp
f0106891:	53                   	push   %ebx
f0106892:	52                   	push   %edx
f0106893:	ff 75 d4             	pushl  -0x2c(%ebp)
f0106896:	89 c2                	mov    %eax,%edx
f0106898:	c1 ea 10             	shr    $0x10,%edx
f010689b:	52                   	push   %edx
f010689c:	0f b7 c0             	movzwl %ax,%eax
f010689f:	50                   	push   %eax
f01068a0:	ff 77 08             	pushl  0x8(%edi)
f01068a3:	ff 77 04             	pushl  0x4(%edi)
f01068a6:	8b 07                	mov    (%edi),%eax
f01068a8:	ff 70 04             	pushl  0x4(%eax)
f01068ab:	68 dc 89 10 f0       	push   $0xf01089dc
f01068b0:	e8 97 d0 ff ff       	call   f010394c <cprintf>
f01068b5:	83 c4 30             	add    $0x30,%esp
f01068b8:	e9 30 ff ff ff       	jmp    f01067ed <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f01068bd:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f01068c0:	83 ec 08             	sub    $0x8,%esp
f01068c3:	89 c2                	mov    %eax,%edx
f01068c5:	c1 ea 10             	shr    $0x10,%edx
f01068c8:	52                   	push   %edx
f01068c9:	0f b7 c0             	movzwl %ax,%eax
f01068cc:	50                   	push   %eax
f01068cd:	ff 77 08             	pushl  0x8(%edi)
f01068d0:	ff 77 04             	pushl  0x4(%edi)
f01068d3:	8b 07                	mov    (%edi),%eax
f01068d5:	ff 70 04             	pushl  0x4(%eax)
f01068d8:	68 38 8a 10 f0       	push   $0xf0108a38
f01068dd:	e8 6a d0 ff ff       	call   f010394c <cprintf>
}
f01068e2:	83 c4 20             	add    $0x20,%esp
f01068e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01068e8:	5b                   	pop    %ebx
f01068e9:	5e                   	pop    %esi
f01068ea:	5f                   	pop    %edi
f01068eb:	5d                   	pop    %ebp
f01068ec:	c3                   	ret    

f01068ed <pci_init>:

int
pci_init(void)
{
f01068ed:	55                   	push   %ebp
f01068ee:	89 e5                	mov    %esp,%ebp
f01068f0:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f01068f3:	6a 08                	push   $0x8
f01068f5:	6a 00                	push   $0x0
f01068f7:	68 80 92 2c f0       	push   $0xf02c9280
f01068fc:	e8 83 ef ff ff       	call   f0105884 <memset>

	return pci_scan_bus(&root_bus);
f0106901:	b8 80 92 2c f0       	mov    $0xf02c9280,%eax
f0106906:	e8 0b fc ff ff       	call   f0106516 <pci_scan_bus>
}
f010690b:	c9                   	leave  
f010690c:	c3                   	ret    

f010690d <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f010690d:	55                   	push   %ebp
f010690e:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f0106910:	c7 05 88 92 2c f0 00 	movl   $0x0,0xf02c9288
f0106917:	00 00 00 
}
f010691a:	5d                   	pop    %ebp
f010691b:	c3                   	ret    

f010691c <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f010691c:	a1 88 92 2c f0       	mov    0xf02c9288,%eax
f0106921:	83 c0 01             	add    $0x1,%eax
f0106924:	a3 88 92 2c f0       	mov    %eax,0xf02c9288
	if (ticks * 10 < ticks)
f0106929:	8d 14 80             	lea    (%eax,%eax,4),%edx
f010692c:	01 d2                	add    %edx,%edx
f010692e:	39 d0                	cmp    %edx,%eax
f0106930:	77 02                	ja     f0106934 <time_tick+0x18>
f0106932:	f3 c3                	repz ret 
{
f0106934:	55                   	push   %ebp
f0106935:	89 e5                	mov    %esp,%ebp
f0106937:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f010693a:	68 40 8b 10 f0       	push   $0xf0108b40
f010693f:	6a 13                	push   $0x13
f0106941:	68 5b 8b 10 f0       	push   $0xf0108b5b
f0106946:	e8 f5 96 ff ff       	call   f0100040 <_panic>

f010694b <time_msec>:
}

unsigned int
time_msec(void)
{
f010694b:	55                   	push   %ebp
f010694c:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f010694e:	a1 88 92 2c f0       	mov    0xf02c9288,%eax
f0106953:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0106956:	01 c0                	add    %eax,%eax
}
f0106958:	5d                   	pop    %ebp
f0106959:	c3                   	ret    
f010695a:	66 90                	xchg   %ax,%ax
f010695c:	66 90                	xchg   %ax,%ax
f010695e:	66 90                	xchg   %ax,%ax

f0106960 <__udivdi3>:
f0106960:	55                   	push   %ebp
f0106961:	57                   	push   %edi
f0106962:	56                   	push   %esi
f0106963:	53                   	push   %ebx
f0106964:	83 ec 1c             	sub    $0x1c,%esp
f0106967:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010696b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010696f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106973:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106977:	85 d2                	test   %edx,%edx
f0106979:	75 35                	jne    f01069b0 <__udivdi3+0x50>
f010697b:	39 f3                	cmp    %esi,%ebx
f010697d:	0f 87 bd 00 00 00    	ja     f0106a40 <__udivdi3+0xe0>
f0106983:	85 db                	test   %ebx,%ebx
f0106985:	89 d9                	mov    %ebx,%ecx
f0106987:	75 0b                	jne    f0106994 <__udivdi3+0x34>
f0106989:	b8 01 00 00 00       	mov    $0x1,%eax
f010698e:	31 d2                	xor    %edx,%edx
f0106990:	f7 f3                	div    %ebx
f0106992:	89 c1                	mov    %eax,%ecx
f0106994:	31 d2                	xor    %edx,%edx
f0106996:	89 f0                	mov    %esi,%eax
f0106998:	f7 f1                	div    %ecx
f010699a:	89 c6                	mov    %eax,%esi
f010699c:	89 e8                	mov    %ebp,%eax
f010699e:	89 f7                	mov    %esi,%edi
f01069a0:	f7 f1                	div    %ecx
f01069a2:	89 fa                	mov    %edi,%edx
f01069a4:	83 c4 1c             	add    $0x1c,%esp
f01069a7:	5b                   	pop    %ebx
f01069a8:	5e                   	pop    %esi
f01069a9:	5f                   	pop    %edi
f01069aa:	5d                   	pop    %ebp
f01069ab:	c3                   	ret    
f01069ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01069b0:	39 f2                	cmp    %esi,%edx
f01069b2:	77 7c                	ja     f0106a30 <__udivdi3+0xd0>
f01069b4:	0f bd fa             	bsr    %edx,%edi
f01069b7:	83 f7 1f             	xor    $0x1f,%edi
f01069ba:	0f 84 98 00 00 00    	je     f0106a58 <__udivdi3+0xf8>
f01069c0:	89 f9                	mov    %edi,%ecx
f01069c2:	b8 20 00 00 00       	mov    $0x20,%eax
f01069c7:	29 f8                	sub    %edi,%eax
f01069c9:	d3 e2                	shl    %cl,%edx
f01069cb:	89 54 24 08          	mov    %edx,0x8(%esp)
f01069cf:	89 c1                	mov    %eax,%ecx
f01069d1:	89 da                	mov    %ebx,%edx
f01069d3:	d3 ea                	shr    %cl,%edx
f01069d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01069d9:	09 d1                	or     %edx,%ecx
f01069db:	89 f2                	mov    %esi,%edx
f01069dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01069e1:	89 f9                	mov    %edi,%ecx
f01069e3:	d3 e3                	shl    %cl,%ebx
f01069e5:	89 c1                	mov    %eax,%ecx
f01069e7:	d3 ea                	shr    %cl,%edx
f01069e9:	89 f9                	mov    %edi,%ecx
f01069eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01069ef:	d3 e6                	shl    %cl,%esi
f01069f1:	89 eb                	mov    %ebp,%ebx
f01069f3:	89 c1                	mov    %eax,%ecx
f01069f5:	d3 eb                	shr    %cl,%ebx
f01069f7:	09 de                	or     %ebx,%esi
f01069f9:	89 f0                	mov    %esi,%eax
f01069fb:	f7 74 24 08          	divl   0x8(%esp)
f01069ff:	89 d6                	mov    %edx,%esi
f0106a01:	89 c3                	mov    %eax,%ebx
f0106a03:	f7 64 24 0c          	mull   0xc(%esp)
f0106a07:	39 d6                	cmp    %edx,%esi
f0106a09:	72 0c                	jb     f0106a17 <__udivdi3+0xb7>
f0106a0b:	89 f9                	mov    %edi,%ecx
f0106a0d:	d3 e5                	shl    %cl,%ebp
f0106a0f:	39 c5                	cmp    %eax,%ebp
f0106a11:	73 5d                	jae    f0106a70 <__udivdi3+0x110>
f0106a13:	39 d6                	cmp    %edx,%esi
f0106a15:	75 59                	jne    f0106a70 <__udivdi3+0x110>
f0106a17:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0106a1a:	31 ff                	xor    %edi,%edi
f0106a1c:	89 fa                	mov    %edi,%edx
f0106a1e:	83 c4 1c             	add    $0x1c,%esp
f0106a21:	5b                   	pop    %ebx
f0106a22:	5e                   	pop    %esi
f0106a23:	5f                   	pop    %edi
f0106a24:	5d                   	pop    %ebp
f0106a25:	c3                   	ret    
f0106a26:	8d 76 00             	lea    0x0(%esi),%esi
f0106a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0106a30:	31 ff                	xor    %edi,%edi
f0106a32:	31 c0                	xor    %eax,%eax
f0106a34:	89 fa                	mov    %edi,%edx
f0106a36:	83 c4 1c             	add    $0x1c,%esp
f0106a39:	5b                   	pop    %ebx
f0106a3a:	5e                   	pop    %esi
f0106a3b:	5f                   	pop    %edi
f0106a3c:	5d                   	pop    %ebp
f0106a3d:	c3                   	ret    
f0106a3e:	66 90                	xchg   %ax,%ax
f0106a40:	31 ff                	xor    %edi,%edi
f0106a42:	89 e8                	mov    %ebp,%eax
f0106a44:	89 f2                	mov    %esi,%edx
f0106a46:	f7 f3                	div    %ebx
f0106a48:	89 fa                	mov    %edi,%edx
f0106a4a:	83 c4 1c             	add    $0x1c,%esp
f0106a4d:	5b                   	pop    %ebx
f0106a4e:	5e                   	pop    %esi
f0106a4f:	5f                   	pop    %edi
f0106a50:	5d                   	pop    %ebp
f0106a51:	c3                   	ret    
f0106a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106a58:	39 f2                	cmp    %esi,%edx
f0106a5a:	72 06                	jb     f0106a62 <__udivdi3+0x102>
f0106a5c:	31 c0                	xor    %eax,%eax
f0106a5e:	39 eb                	cmp    %ebp,%ebx
f0106a60:	77 d2                	ja     f0106a34 <__udivdi3+0xd4>
f0106a62:	b8 01 00 00 00       	mov    $0x1,%eax
f0106a67:	eb cb                	jmp    f0106a34 <__udivdi3+0xd4>
f0106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106a70:	89 d8                	mov    %ebx,%eax
f0106a72:	31 ff                	xor    %edi,%edi
f0106a74:	eb be                	jmp    f0106a34 <__udivdi3+0xd4>
f0106a76:	66 90                	xchg   %ax,%ax
f0106a78:	66 90                	xchg   %ax,%ax
f0106a7a:	66 90                	xchg   %ax,%ax
f0106a7c:	66 90                	xchg   %ax,%ax
f0106a7e:	66 90                	xchg   %ax,%ax

f0106a80 <__umoddi3>:
f0106a80:	55                   	push   %ebp
f0106a81:	57                   	push   %edi
f0106a82:	56                   	push   %esi
f0106a83:	53                   	push   %ebx
f0106a84:	83 ec 1c             	sub    $0x1c,%esp
f0106a87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f0106a8b:	8b 74 24 30          	mov    0x30(%esp),%esi
f0106a8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0106a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106a97:	85 ed                	test   %ebp,%ebp
f0106a99:	89 f0                	mov    %esi,%eax
f0106a9b:	89 da                	mov    %ebx,%edx
f0106a9d:	75 19                	jne    f0106ab8 <__umoddi3+0x38>
f0106a9f:	39 df                	cmp    %ebx,%edi
f0106aa1:	0f 86 b1 00 00 00    	jbe    f0106b58 <__umoddi3+0xd8>
f0106aa7:	f7 f7                	div    %edi
f0106aa9:	89 d0                	mov    %edx,%eax
f0106aab:	31 d2                	xor    %edx,%edx
f0106aad:	83 c4 1c             	add    $0x1c,%esp
f0106ab0:	5b                   	pop    %ebx
f0106ab1:	5e                   	pop    %esi
f0106ab2:	5f                   	pop    %edi
f0106ab3:	5d                   	pop    %ebp
f0106ab4:	c3                   	ret    
f0106ab5:	8d 76 00             	lea    0x0(%esi),%esi
f0106ab8:	39 dd                	cmp    %ebx,%ebp
f0106aba:	77 f1                	ja     f0106aad <__umoddi3+0x2d>
f0106abc:	0f bd cd             	bsr    %ebp,%ecx
f0106abf:	83 f1 1f             	xor    $0x1f,%ecx
f0106ac2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106ac6:	0f 84 b4 00 00 00    	je     f0106b80 <__umoddi3+0x100>
f0106acc:	b8 20 00 00 00       	mov    $0x20,%eax
f0106ad1:	89 c2                	mov    %eax,%edx
f0106ad3:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106ad7:	29 c2                	sub    %eax,%edx
f0106ad9:	89 c1                	mov    %eax,%ecx
f0106adb:	89 f8                	mov    %edi,%eax
f0106add:	d3 e5                	shl    %cl,%ebp
f0106adf:	89 d1                	mov    %edx,%ecx
f0106ae1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106ae5:	d3 e8                	shr    %cl,%eax
f0106ae7:	09 c5                	or     %eax,%ebp
f0106ae9:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106aed:	89 c1                	mov    %eax,%ecx
f0106aef:	d3 e7                	shl    %cl,%edi
f0106af1:	89 d1                	mov    %edx,%ecx
f0106af3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106af7:	89 df                	mov    %ebx,%edi
f0106af9:	d3 ef                	shr    %cl,%edi
f0106afb:	89 c1                	mov    %eax,%ecx
f0106afd:	89 f0                	mov    %esi,%eax
f0106aff:	d3 e3                	shl    %cl,%ebx
f0106b01:	89 d1                	mov    %edx,%ecx
f0106b03:	89 fa                	mov    %edi,%edx
f0106b05:	d3 e8                	shr    %cl,%eax
f0106b07:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106b0c:	09 d8                	or     %ebx,%eax
f0106b0e:	f7 f5                	div    %ebp
f0106b10:	d3 e6                	shl    %cl,%esi
f0106b12:	89 d1                	mov    %edx,%ecx
f0106b14:	f7 64 24 08          	mull   0x8(%esp)
f0106b18:	39 d1                	cmp    %edx,%ecx
f0106b1a:	89 c3                	mov    %eax,%ebx
f0106b1c:	89 d7                	mov    %edx,%edi
f0106b1e:	72 06                	jb     f0106b26 <__umoddi3+0xa6>
f0106b20:	75 0e                	jne    f0106b30 <__umoddi3+0xb0>
f0106b22:	39 c6                	cmp    %eax,%esi
f0106b24:	73 0a                	jae    f0106b30 <__umoddi3+0xb0>
f0106b26:	2b 44 24 08          	sub    0x8(%esp),%eax
f0106b2a:	19 ea                	sbb    %ebp,%edx
f0106b2c:	89 d7                	mov    %edx,%edi
f0106b2e:	89 c3                	mov    %eax,%ebx
f0106b30:	89 ca                	mov    %ecx,%edx
f0106b32:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0106b37:	29 de                	sub    %ebx,%esi
f0106b39:	19 fa                	sbb    %edi,%edx
f0106b3b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f0106b3f:	89 d0                	mov    %edx,%eax
f0106b41:	d3 e0                	shl    %cl,%eax
f0106b43:	89 d9                	mov    %ebx,%ecx
f0106b45:	d3 ee                	shr    %cl,%esi
f0106b47:	d3 ea                	shr    %cl,%edx
f0106b49:	09 f0                	or     %esi,%eax
f0106b4b:	83 c4 1c             	add    $0x1c,%esp
f0106b4e:	5b                   	pop    %ebx
f0106b4f:	5e                   	pop    %esi
f0106b50:	5f                   	pop    %edi
f0106b51:	5d                   	pop    %ebp
f0106b52:	c3                   	ret    
f0106b53:	90                   	nop
f0106b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106b58:	85 ff                	test   %edi,%edi
f0106b5a:	89 f9                	mov    %edi,%ecx
f0106b5c:	75 0b                	jne    f0106b69 <__umoddi3+0xe9>
f0106b5e:	b8 01 00 00 00       	mov    $0x1,%eax
f0106b63:	31 d2                	xor    %edx,%edx
f0106b65:	f7 f7                	div    %edi
f0106b67:	89 c1                	mov    %eax,%ecx
f0106b69:	89 d8                	mov    %ebx,%eax
f0106b6b:	31 d2                	xor    %edx,%edx
f0106b6d:	f7 f1                	div    %ecx
f0106b6f:	89 f0                	mov    %esi,%eax
f0106b71:	f7 f1                	div    %ecx
f0106b73:	e9 31 ff ff ff       	jmp    f0106aa9 <__umoddi3+0x29>
f0106b78:	90                   	nop
f0106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106b80:	39 dd                	cmp    %ebx,%ebp
f0106b82:	72 08                	jb     f0106b8c <__umoddi3+0x10c>
f0106b84:	39 f7                	cmp    %esi,%edi
f0106b86:	0f 87 21 ff ff ff    	ja     f0106aad <__umoddi3+0x2d>
f0106b8c:	89 da                	mov    %ebx,%edx
f0106b8e:	89 f0                	mov    %esi,%eax
f0106b90:	29 f8                	sub    %edi,%eax
f0106b92:	19 ea                	sbb    %ebp,%edx
f0106b94:	e9 14 ff ff ff       	jmp    f0106aad <__umoddi3+0x2d>
